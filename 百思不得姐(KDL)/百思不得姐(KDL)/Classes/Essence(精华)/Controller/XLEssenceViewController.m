//
//  XLEssenceViewController.m
//  百思不得姐(KDL)
//
//  Created by manager on 16/5/2.
//  Copyright © 2016年 kdl. All rights reserved.
//

#import "XLEssenceViewController.h"
#import "XLRecommendTagsViewController.h"
@interface XLEssenceViewController ()

@end

@implementation XLEssenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 设置导航栏标题
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
    // 设置导航栏左边的按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"MainTagSubIcon" highImage:@"MainTagSubIconClick" target:self action:@selector(tagClick)];
    
    // 设置背景色
    self.view.backgroundColor = XLGlobalBg;
}

- (void)tagClick
{
    XLRecommendTagsViewController *tags = [[XLRecommendTagsViewController alloc] init];
    [self.navigationController pushViewController:tags
                                         animated:YES];
}


@end
