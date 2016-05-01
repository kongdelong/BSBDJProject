//
//  XLEssenceViewController.m
//  百思不得姐(KDL)
//
//  Created by manager on 16/5/1.
//  Copyright © 2016年 kdl. All rights reserved.
//

#import "XLEssenceViewController.h"

@interface XLEssenceViewController ()

@end

@implementation XLEssenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置导航栏标题
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    // 设置导航栏左边的按钮
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"MainTagSubIcon"] forState:UIControlStateNormal];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"MainTagSubIconClick"] forState:UIControlStateHighlighted];
    leftButton.size =  leftButton.currentBackgroundImage.size;
    [leftButton addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
}

- (void)leftBtnClick
{
    XLLogFunc;
}

@end
