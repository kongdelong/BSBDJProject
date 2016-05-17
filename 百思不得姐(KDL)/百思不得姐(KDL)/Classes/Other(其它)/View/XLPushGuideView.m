//
//  XLPushGuideView.m
//  百思不得姐(KDL)
//
//  Created by manager on 16/5/17.
//  Copyright © 2016年 kdl. All rights reserved.
//

#import "XLPushGuideView.h"

@implementation XLPushGuideView

+ (instancetype)guideView
{
    return [[[NSBundle mainBundle ] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (IBAction)close
{
    [self removeFromSuperview];
}

+ (void)show
{
    NSString *key = @"CFBundleShortVersionString";
    //  获得当前软件的版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    // 获得沙盒中存储的版本号
    NSString *sanboxVersion = [[NSUserDefaults standardUserDefaults] stringForKey:key];
    if (![currentVersion isEqualToString:sanboxVersion]) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        XLPushGuideView *guideView = [XLPushGuideView guideView];
        guideView.frame = window.bounds;
        [window addSubview:guideView];
        
        // 存储版本号
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end








