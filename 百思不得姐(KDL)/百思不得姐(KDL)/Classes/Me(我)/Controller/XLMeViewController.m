//
//  XLMeViewController.m
//  百思不得姐(KDL)
//
//  Created by manager on 16/5/1.
//  Copyright © 2016年 kdl. All rights reserved.
//

#import "XLMeViewController.h"

@interface XLMeViewController ()

@end

@implementation XLMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 设置导航栏标题
    self.navigationItem.title = @"我的";
    // 设置导航栏右边的按钮

    UIBarButtonItem *settingItem = [UIBarButtonItem itemWithImage:@"mine-setting-icon" highImage:@"mine-setting-icon-click" target:self action:@selector(settingClick)];
    UIBarButtonItem *nightModeItem = [UIBarButtonItem itemWithImage:@"mine-moon-icon" highImage:@"mine-moon-icon-click" target:self action:@selector(nightModeClick)];
    
    self.navigationItem.rightBarButtonItems = @[
                                                settingItem,
                                                nightModeItem
                                                ];
    // 设置背景色
    self.view.backgroundColor = XLGlobalBg;

    
}

- (void)settingClick
{
    XLLogFunc;
}

- (void)nightModeClick
{
    XLLogFunc;
}

@end
