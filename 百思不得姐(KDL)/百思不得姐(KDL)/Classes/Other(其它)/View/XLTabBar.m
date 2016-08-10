//
//  XLTabBar.m
//  百思不得姐(KDL)
//
//  Created by manager on 16/5/1.
//  Copyright © 2016年 kdl. All rights reserved.
//

#import "XLTabBar.h"
#import "XLPublishViewController.h"
#import "XLNavigationController.h"

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
    //
//    XLPublishView *publish = [XLPublishView publishView];
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    publish.frame = window.frame;
//    [window addSubview:publish];
    
    XLPublishViewController *publish = [[XLPublishViewController alloc] init];
//    XLNavigationController *nav = [[XLNavigationController alloc] initWithRootViewController:publish];
    // 这里不能使用self来弹出其它控制器,因为self执行了dismiss操作
    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
    [root presentViewController:publish animated:YES completion:nil];
    
    
   
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    // 标记按钮是否已经添加过监听器
    static BOOL added = NO;

    
 
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
    for (UIControl *button in self.subviews)
    {
        //        if (![button isKindOfClass:NSClassFromString(@"UITabBarButton")]) continue;

        if (![button isKindOfClass:[UIControl class]] || button == self.plusButton) continue;
        // 计算按钮的x值
        CGFloat buttonX = buttonW * (index > 1 ? (index + 1) : index);
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        // 增加索引
        index++;
        
        
        if (added == NO) {
            // 监听按钮点击
            [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    added = YES;
}

- (void)buttonClick
{
    // 发出一个通知
    [XLNoteCenter postNotificationName:XMGTabBarDidSelectNotification object:nil userInfo:nil];
}


@end




















