//
//  XLLoginTool.h
//  百思不得姐(KDL)
//
//  Created by Cb W on 16/8/15.
//  Copyright © 2016年 kdl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLLoginTool : NSObject
+ (void)setUid:(NSString *)uid;

/**
 获得当前登录用户的uid，检测是否登录
 NSString *：已经登录, nil：没有登录
 */
+ (NSString *)getUid;
+ (NSString *)getUid:(BOOL)showLoginController;
@end
