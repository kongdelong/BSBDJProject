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
@interface XLRecommendViewController () <UITableViewDelegate,UITableViewDataSource>
/** 左边类别数据源 */
@property (nonatomic, strong) NSMutableArray *categories;
/** 左边类别表格 */
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;
/** 右边用户表格 */
@property (weak, nonatomic) IBOutlet UITableView *userTableView;



@end

@implementation XLRecommendViewController

static  NSString * const XLCatagoryID = @"CategoryCell";
static  NSString * const XLUserID = @"UserCell";


- (void)viewDidLoad {
    [super viewDidLoad];
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
     // 显示指示器
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    //  发送请求
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"category";
    params[@"c"] = @"subscribe";
    
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 隐藏指示器
        [SVProgressHUD dismiss];
//        XLLog(@"%@",responseObject);
        //服务器返回的json数据
        self.categories = [XLRecommendCategory mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [self.categoryTableView reloadData];
        // 默认选中首行
        [self.categoryTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       // 显示失败的信息
        [SVProgressHUD showErrorWithStatus:@"加载推荐信息失败!"];
    }];
  
}

#pragma -- <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.categoryTableView)
    { // 左边的类别表格
        return self.categories.count;
    }
    else
    { // 右边的类别表格
        // 左边被选中的类别模型
     XLRecommendCategory *c = self.categories[self.categoryTableView.indexPathForSelectedRow.row];
        return  c.users.count;
    }
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
        XLRecommendCategory *c = self.categories[self.categoryTableView.indexPathForSelectedRow.row];
        cell.user = c.users[indexPath.row];
        
        return cell;
    }
}

#pragma -- <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XLRecommendCategory *c = self.categories[indexPath.row];
    if (tableView == self.categoryTableView)
    {
        if (c.users.count)
        {
            // 显示曾经的数据
            [self.userTableView reloadData];
        }
        else
        {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"a"] = @"list";
            params[@"c"] = @"subscribe";
            params[@"category_id"] = @(c.id);
            [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                //        XLLog(@"%@",responseObject);
                // 字典数组 －> 模型数组
                NSArray *users = [XLRecommendUser mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
                // 添加到当前类别对应的用户数组
                [c.users addObjectsFromArray:users];
                // 刷新表格
                [self.userTableView reloadData];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                XLLog(@"error = %@",error);
            }];
        }
    }
}

@end
/**
  1. 重复发送请求

  2.只能显示一页数据
  3.网络慢带来的细节问题
 */


















