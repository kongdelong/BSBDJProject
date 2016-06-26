//
//  XLTabBar.m
//  百思不得姐(KDL)
//
//  Created by manager on 16/5/1.
//  Copyright © 2016年 kdl. All rights reserved.
//

#import "XLTabBar.h"
#import "XLPublishViewController.h"
@interface XLTabBar ()

/** 发布按钮 */
@property (nonatomic, weak) UIButton *plusButton;
@end

@implementation XLTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame: frame])
    {
        // 设置tabbar的背景图片
        [self setBackgroundImage:[UIImage imageNamed:@"tabbar-light"]];
        
        UIButton *plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [plusButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [plusButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
        plusButton.size = plusButton.currentBackgroundImage.size;
        [plusButton addTarget:self action:@selector(publishClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:plusButton];
        self.plusButton = plusButton;
    }
    return  self;
}

- (void)publishClick
{
    XLPublishViewController *publish = [[XLPublishViewController alloc] init];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:publish animated:NO completion:nil];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
 
    CGFloat width = self.width;
    CGFloat height = self.height;
    //  设置发布按钮的frame
    self.plusButton.width =  self.plusButton.currentBackgroundImage.size.width;
    self.plusButton.height = self.plusButton.currentBackgroundImage.size.height;
    self.plusButton.center = CGPointMake(width * 0.5, height * 0.5);

    // 设置其他UITabBarButton的frame
    CGFloat buttonY = 0;
    CGFloat buttonW = width / 5;
    CGFloat buttonH = height;
    NSInteger index = 0;
    for (UIView *button in self.subviews)
    {
        //        if (![button isKindOfClass:NSClassFromString(@"UITabBarButton")]) continue;

        if (![button isKindOfClass:[UIControl class]] || button == self.plusButton) continue;
        // 计算按钮的x值
        CGFloat buttonX = buttonW * (index > 1 ? (index + 1) : index);
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        // 增加索引
        index++;
    }
}

@end




















