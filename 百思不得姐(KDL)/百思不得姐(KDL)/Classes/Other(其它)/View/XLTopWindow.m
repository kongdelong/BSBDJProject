//
//  XLTopWindow.m
//  百思不得姐(KDL)
//
//  Created by Cb W on 16/7/21.
//  Copyright © 2016年 kdl. All rights reserved.
//

#import "XLTopWindow.h"

@implementation XLTopWindow

static UIWindow *window_;

+ (void)show
{
    window_.hidden = NO;
}

+ (void)initialize
{
    window_ = [[UIWindow alloc] init];
    window_.frame = CGRectMake(0, 0, XLScreenWidth, 20);
    window_.windowLevel = UIWindowLevelAlert;
    window_.backgroundColor = [UIColor clearColor];
    [window_ addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(windowClick)]];
    
}

+ (void)windowClick
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self searchScrollViewInView:window];
}

+ (void)searchScrollViewInView:(UIView *)supview
{
    
    //        CGRectIntersectsRect([UIApplication sharedApplication].keyWindow.bounds, subview.frame)
    
    //        CGRect newFrame = [subview.superview convertRect:subview.frame toView:nil];
    //        CGRect newFrame = [[UIApplication sharedApplication].keyWindow convertRect:subview.frame fromView:subview.superview];
    
    for (UIScrollView *subView in supview.subviews) {
//        CGRect newFrame = [subView.superview convertRect:subView.frame toView:nil];
//        CGRect winRect = [UIApplication sharedApplication].keyWindow.bounds;
//        //  判断一个控件是否真正显示在窗口上
//        BOOL isShowingOnWindow = subView.window == [UIApplication sharedApplication].keyWindow && !subView.isHidden && subView.alpha > 0.01 && CGRectIntersectsRect(newFrame, winRect);

        
        if ([subView isKindOfClass:[UIScrollView class]] && subView.isShowingOnKeyWindow) {
            CGPoint offset = subView.contentOffset;
            offset.y = -subView.contentInset.top;
            [subView setContentOffset:offset animated:YES];
        }
        // 继续查找子控件
        [self searchScrollViewInView:subView];
    }
    
    
    
  
}

@end





































































































