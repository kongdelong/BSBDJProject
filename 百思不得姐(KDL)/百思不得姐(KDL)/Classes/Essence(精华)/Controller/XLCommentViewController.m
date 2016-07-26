//
//  XLCommentViewController.m
//  百思不得姐(KDL)
//
//  Created by Cb W on 16/7/18.
//  Copyright © 2016年 kdl. All rights reserved.
//

#import "XLCommentViewController.h"
#import "XLTopicCell.h"
#import "XLTopic.h"
#import <MJRefresh.h>
#import <AFNetworking.h>
#import <MJExtension.h>
#import "XLComment.h"
#import "XLCommentHeaderView.h"
#import "XLCommentCell.h"

@interface XLCommentViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSapce;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 最热评论 */
@property (nonatomic, strong) NSArray *hotComments;
/** 最新评论 */
@property (nonatomic, strong) NSMutableArray *latestComments;
/** 保存帖子的top_cmt */
@property (nonatomic, strong) XLComment *saved_top_cmt;
/** 保存当前的页码 */
@property (nonatomic, assign) NSInteger page;
/** 管理者 */
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@end

@implementation XLCommentViewController

- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBasic];
    [self setupHeader];
    [self setupRefresh];
}

- (void)setupHeader
{
    // 创建header
    UIView *header = [[UIView alloc] init];
    // 清空top_cmt
    if (self.topic.top_cmt) {
        self.saved_top_cmt = self.topic.top_cmt;
        self.topic.top_cmt = nil;
        [self.topic setValue:@0 forKeyPath:@"cellHeight"];
    }
    // 添加cell
    XLTopicCell *cell = [XLTopicCell cell];
    cell.topic = self.topic;
    cell.size = CGSizeMake(XLScreenWidth, self.topic.cellHeight);
    [header addSubview:cell];
    
    // header的高度
    header.height = self.topic.cellHeight + XLTopicCellMargin;
    
    // 设置header
    self.tableView.tableHeaderView = header;
    
    [self setupRefresh];

}

- (void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewComments)];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreComments)];
    self.tableView.mj_footer.hidden = YES;

}

- (void)loadMoreComments{
    
    // 结束之前的所有请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
     // 页码
    NSInteger page = self.page ++;  
    // 参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.topic.ID;
    params[@"page"] = @(page);
    XLComment *cmt = [self.latestComments lastObject];
    params[@"lastcid"] = cmt.ID;
    [self.manager GET:@"http://api.budejie.com/api/api_open.php"  parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
  
        
        NSLog(@"%@",responseObject);
        NSArray *newComments = [XLComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self.latestComments addObjectsFromArray:newComments];
        
        // 页码
        self.page = page;
     
        // 刷新数据
        [self.tableView reloadData];
        
        // 控制footer的状态
        NSInteger total = [responseObject[@"total"] integerValue];
        if (self.latestComments.count >= total) {
            self.tableView.mj_footer.hidden = YES;
        }else{
            // 结束刷新
            [self.tableView.mj_footer endRefreshing];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_footer endRefreshing];

    }];
}

- (void)loadNewComments
{
    // 结束之前的所有请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.topic.ID;
    params[@"hot"] = @"1";
    
 
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        // 最热评论
        self.hotComments = [XLComment mj_objectArrayWithKeyValuesArray:responseObject[@"hot"]];
        
        // 最新评论
        self.latestComments = [XLComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        // 页码
        self.page = 1;
        // 刷新数据
        [self.tableView reloadData];
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
        
        // 控制footer的状态    如果下拉刷新，只有1条，也不显示底部刷新控件
        NSInteger total = [responseObject[@"total"] integerValue];
        if (self.latestComments.count >= total) { // 全部加载完毕
            self.tableView.mj_footer.hidden = YES;
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
}

static NSString * const XLCommentId = @"comment";
- (void)setupBasic
{
    self.title = @"评论";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"comment_nav_item_share_icon" highImage:@"comment_nav_item_share_icon_click" target:nil action:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    // cell的高度设置
#warning ---- 自动高度
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = XLGlobalBg;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XLCommentCell class]) bundle:nil] forCellReuseIdentifier:XLCommentId];
}

- (void)keyboardWillChangeFrame:(NSNotification *)note
{
    // 键盘显示\隐藏完毕的frame
    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 修改底部约束
    self.bottomSapce.constant = XLScreenHeight - frame.origin.y;
    // 动画时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 动画 及时刷新
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}


#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    
    NSInteger hotCount = self.hotComments.count;
    NSInteger latestCount = self.latestComments.count;
    
    // 隐藏尾部控件
    tableView.mj_footer.hidden = (latestCount == 0);
    
    if (hotCount) return 2; // 有"最热评论" + "最新评论" 2组
    if (latestCount) return 1; // 有"最新评论" 1 组
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger hotCount = self.hotComments.count;
    NSInteger latestCount = self.latestComments.count;
    if (section == 0) {
        return hotCount ? hotCount : latestCount;
    }
    
    // 非第0组
    return latestCount;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    NSInteger hotCount = self.hotComments.count;
//    if (section == 0) {
//        return hotCount ? @"最热评论" : @"最新评论";
//    }
//    return @"最新评论";
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XLCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"comment"];
    
    cell.comment = [self commentInIndexPath:indexPath];
    
    return cell;
}

- (XLComment *)commentInIndexPath:(NSIndexPath *)indexPath
{
    return [self commentsInSection:indexPath.section][indexPath.row];
}

/**
 * 返回第section组的所有评论数组
 */
- (NSArray *)commentsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.hotComments.count ? self.hotComments : self.latestComments;
    }
    return self.latestComments;
}

/**
 *  段头
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // 先从缓存池中找header
    XLCommentHeaderView *header = [XLCommentHeaderView headerViewWithTableView:tableView];
    
    // 设置label的数据
    NSInteger hotCount = self.hotComments.count;
    if (section == 0) {
        header.title = hotCount ? @"最热评论" : @"最新评论";
    } else {
        header.title = @"最新评论";
    }
    return header;
}


#pragma mark - <UITableViewDelegate>
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIMenuController *menu = [UIMenuController sharedMenuController];
    if (menu.isMenuVisible) {
        [menu setMenuVisible:NO animated:YES];
    }else{
        // 被点击的cell
        XLCommentCell *cell = (XLCommentCell *)[tableView cellForRowAtIndexPath:indexPath];
        // 出现一个第一响应者
        [cell becomeFirstResponder];
        // 显示menucontroller
        UIMenuItem *ding = [[UIMenuItem alloc] initWithTitle:@"顶" action:@selector(ding:)];
        UIMenuItem *replay = [[UIMenuItem alloc] initWithTitle:@"回复" action:@selector(replay:)];
        UIMenuItem *report = [[UIMenuItem alloc] initWithTitle:@"举报" action:@selector(report:)];
        menu.menuItems = @[ding, replay, report];
        CGRect rect = CGRectMake(0, cell.height * 0.5, cell.width, cell.height * 0.5);
        [menu setTargetRect:rect inView:cell];
        [menu setMenuVisible:YES animated:YES];
    }
}

#pragma mark - MenuItem处理
- (void)ding:(UIMenuController *)menu
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSLog(@"%s %@", __func__, [self commentInIndexPath:indexPath].content);
}

- (void)replay:(UIMenuController *)menu
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSLog(@"%s %@", __func__, [self commentInIndexPath:indexPath].content);
}

- (void)report:(UIMenuController *)menu
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSLog(@"%s %@", __func__, [self commentInIndexPath:indexPath].content);
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //  恢复帖子top_cmt
    if (self.saved_top_cmt) {
        self.topic.top_cmt = self.saved_top_cmt;
        [self.topic setValue:@0 forKeyPath:@"cellHeight"];
    }
    
    // 取消所有任务
    //    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    [self.manager invalidateSessionCancelingTasks:YES];
   
}

@end





