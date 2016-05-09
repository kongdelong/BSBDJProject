//
//  XLRecommendViewController.m
//  百思不得姐(KDL)
//
//  Created by manager on 16/5/2.
//  Copyright © 2016年 kdl. All rights reserved.
//

#import "XLRecommendViewController.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import <MJExtension.h>
#import "XLRecommendCatogoryCell.h"
#import "XLRecommendCategory.h"
#import "XLRecommendUser.h"
#import "XLRecommendUserCell.h"
#import <MJRefresh.h>

#define XLSelectedCategory  self.categories[self.categoryTableView.indexPathForSelectedRow.row]

@interface XLRecommendViewController () <UITableViewDelegate,UITableViewDataSource>
/** 左边类别数据源 */
@property (nonatomic, strong) NSMutableArray *categories;
/** 左边类别表格 */
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;
/** 右边用户表格 */
@property (weak, nonatomic) IBOutlet UITableView *userTableView;

/** 请求参数 */
@property (nonatomic, strong) NSMutableDictionary *params;
/** AFN 请求管理者 */
@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation XLRecommendViewController

static  NSString * const XLCatagoryID = @"CategoryCell";
static  NSString * const XLUserID = @"UserCell";

- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return  _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 控件的初始化
    [self setupTableView];
    // 集成刷新控件
    [self setupRefresh];
    // 加载左侧的类别数据
    [self loadCategories];
}

/**
 *  加载左侧的类别数据
 */
- (void)loadCategories
{
    // 显示指示器
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    //  发送请求
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"category";
    params[@"c"] = @"subscribe";
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 隐藏指示器
        [SVProgressHUD dismiss];
        //        XLLog(@"%@",responseObject);
        //服务器返回的json数据
        self.categories = [XLRecommendCategory mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        // 刷新表格
        [self.categoryTableView reloadData];
        // 默认选中首行
        [self.categoryTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        // 默认选中首行
        [self.userTableView.mj_header beginRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 显示失败的信息
        [SVProgressHUD showErrorWithStatus:@"加载推荐信息失败!"];
    }];
}
/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    self.userTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewUsers)];
    
    self.userTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreUsers)];

    self.userTableView.mj_footer.hidden = YES;
}
#pragma mark - 加载用户数据
/**
 *  下拉刷新
 */
- (void)loadNewUsers
{
    XLRecommendCategory *rc = XLSelectedCategory;
    // 设置当前页码为1
    rc.currentPage = 1;
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"subscribe";
    params[@"category_id"] = @(rc.id);
    params[@"page"] = @(rc.currentPage);
    
    self.params = params;// 为了避免连点发多次请求
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        XLLog(@"%@",responseObject);
        
        // 字典数组 －> 模型数组
        NSArray *users = [XLRecommendUser mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        // 先清除以前的所有旧数据
        [rc.users removeAllObjects];
        // 添加到当前类别对应的用户数组
        [rc.users addObjectsFromArray:users];
        // 保存总数
        rc.total = [responseObject[@"total"] integerValue];
        
        // 如果请求过期了，直接返回不要往下走了。
        if (self.params != params) return;//如果请求参数不等于这次的参数返回
        
        // 刷新表格
        [self.userTableView reloadData];
        // 结束刷新
        [self.userTableView.mj_header endRefreshing];
        
        // 让底部控件结束刷新
        [self checkFooterState];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        XLLog(@"error = %@",error);
        // 如果请求过期了，不要提醒用户
        if (self.params != params) return;//如果请求参数不等于这次的参数返回

        // 提醒失败
        [SVProgressHUD showErrorWithStatus:@"加载用户数据失败"];
        // 结束刷新
        [self.userTableView.mj_header endRefreshing];
    }];
    

}
/**
 *   上拉加载更多
 */
- (void)loadMoreUsers
{
    
    XLRecommendCategory *category = XLSelectedCategory;
    // 发送请求给服务器，加载右侧数据
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"subscribe";
    params[@"category_id"] = @([XLSelectedCategory id]);
    params[@"page"] = @(++category.currentPage);
    
        self.params = params;// 为了避免连点发多次请求
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        XLLog(@"%@",responseObject);
        // 字典数组 －> 模型数组
        NSArray *users = [XLRecommendUser mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        // 添加到当前类别对应的用户数组
        [category.users addObjectsFromArray:users];
        
        if(self.params != params) return ;

        // 刷新右边表格
        [self.userTableView reloadData];
     
        //  让底部控件结束刷新
        [self checkFooterState];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        XLLog(@"error = %@",error);
        if(self.params != params) return ;
        // 提醒失败
        [SVProgressHUD showErrorWithStatus:@"加载用户数据失败"];
        // 结束刷新
        [self.userTableView.mj_header endRefreshing];
    }];
}
/**
 * 控件的初始化
 */
- (void)setupTableView
{
    // 注册Cell
    [self.categoryTableView registerNib:[UINib nibWithNibName:NSStringFromClass([XLRecommendCatogoryCell class]) bundle:nil] forCellReuseIdentifier:XLCatagoryID];
    [self.userTableView registerNib:[UINib nibWithNibName:NSStringFromClass([XLRecommendUserCell class]) bundle:nil] forCellReuseIdentifier:XLUserID];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.categoryTableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.userTableView.contentInset = self.categoryTableView.contentInset;
    self.userTableView.rowHeight = 70;
    self.title =@"推荐关注";
    // 设置背景色
    self.view.backgroundColor = XLGlobalBg;

}
/**
 *  时刻监测footer的状态
 */
- (void)checkFooterState
{
      XLRecommendCategory *rc = XLSelectedCategory;
        NSInteger count = rc.users.count;
    // 每次刷新右边数据时，都控制footer显示或隐藏
    self.userTableView.mj_footer.hidden = (count==0);
    // 让底部控件结束刷新
    if (count == rc.total)
    {//  全部数据加载完毕
        [self.userTableView.mj_footer endRefreshingWithNoMoreData];
    }
    else
    { // 还没有加载完毕
        [self.userTableView.mj_footer endRefreshing];
    }
}

#pragma -- <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     // 左边的类别表格
    if (tableView == self.categoryTableView) return self.categories.count;
    // 右边的类别表格
    // 监测footer的状态
    [self checkFooterState];
    return [XLSelectedCategory users].count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.categoryTableView)
    { // 左边的类别表格
        XLRecommendCatogoryCell *cell = [tableView dequeueReusableCellWithIdentifier:XLCatagoryID];
        cell.category = self.categories[indexPath.row];
        return cell;
    }
    else
    {
        XLRecommendUserCell *cell = [tableView dequeueReusableCellWithIdentifier:XLUserID];
        // 左边被选中的类别模型
        cell.user =  [XLSelectedCategory users][indexPath.row];
        
        return cell;
    }
}

#pragma -- <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 结束刷新
    [self.userTableView.mj_header endRefreshing];
    [self.userTableView.mj_footer endRefreshing];
    
    if (tableView == self.categoryTableView)
    {
        XLRecommendCategory *c = self.categories[indexPath.row];

        if (c.users.count)
        {
            // 显示曾经的数据
            [self.userTableView reloadData];
        }
        else
        {
            // 赶紧刷新表格 马上显示category的用户数据 不让用户看见上一个category的残留数据
            [self.userTableView reloadData];
            // 进入下接刷新状态
            [self.userTableView.mj_header beginRefreshing];
        }
    }
}

#pragma mark - 控制器的销毁
// 如果控制器正在请求，突然把控制器销毁了 怎么处理？ 就是把以前的请求删掉
- (void)dealloc
{
    // 停止所有操作
    [self.manager.operationQueue cancelAllOperations];
}
@end
/**
  1. 重复发送请求

  2.只能显示一页数据
  3.网络慢带来的细节问题
 */


















