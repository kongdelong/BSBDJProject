//
//  XLRecommendTagsViewController.m
//  百思不得姐(KDL)
//
//  Created by manager on 16/5/9.
//  Copyright © 2016年 kdl. All rights reserved.
//

#import "XLRecommendTagsViewController.h"
#import "XLRecommendTagCell.h"
#import "XLRecommentTags.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>

@interface XLRecommendTagsViewController ()
/** 标签数据 */
@property (nonatomic, strong) NSArray *tags;

@end

@implementation XLRecommendTagsViewController

static NSString * const XLTagsId = @"tag";


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
    
    [self loadTags];
    
}

- (void)loadTags
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"tag_recommend";
    params[@"action"] = @"sub";
    params[@"c"] = @"topic";
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.tags = [XLRecommentTags mj_objectArrayWithKeyValuesArray:responseObject];
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"加载标签数据失败!"];
    }];
}

- (void)setupTableView
{
   self.title = @"推荐标签";
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XLRecommendTagCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:XLTagsId];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = XLGlobalBg;
    self.tableView.rowHeight = 70;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tags.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XLRecommendTagCell *cell = [tableView dequeueReusableCellWithIdentifier:XLTagsId];
    cell.recommentTag = self.tags[indexPath.row];
    return cell;
}


@end


























