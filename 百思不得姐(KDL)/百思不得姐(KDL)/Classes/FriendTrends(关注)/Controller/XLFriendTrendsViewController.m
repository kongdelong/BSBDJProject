//
//  XLFriendTrendsViewController.m
//  百思不得姐(KDL)
//
//  Created by manager on 16/5/1.
//  Copyright © 2016年 kdl. All rights reserved.
//

#import "XLFriendTrendsViewController.h"
#import "XLRecommendViewController.h"
#import "XLLoginRegisterViewController.h"
@interface XLFriendTrendsViewController ()

@end

@implementation XLFriendTrendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 设置导航栏标题
    self.navigationItem.title = @"我的关注";
    //    self.title = @"我的关注";
    //    self.navigationItem.title = @"我的关注";
    //    self.tabBarItem.title = @"我的关注";
    
    // 设置导航栏左边的按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"friendsRecommentIcon" highImage:@"friendsRecommentIcon-click" target:self action:@selector(friendsClick)];
    // 设置背景色
    self.view.backgroundColor = XLGlobalBg;

}

- (void)friendsClick
{
    XLRecommendViewController *vc = [[XLRecommendViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)loginRegister
{
    XLLoginRegisterViewController *login = [[XLLoginRegisterViewController alloc]init];
    [self presentViewController:login animated:YES completion:nil];
    
}

@end
