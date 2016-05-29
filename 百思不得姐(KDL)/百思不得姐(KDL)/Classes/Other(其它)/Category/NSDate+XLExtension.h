//
//  NSDate+XLExtension.h
//  百思不得姐(KDL)
//
//  Created by manager on 16/5/29.
//  Copyright © 2016年 kdl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (XLExtension)
/**
 * 比较from和self的时间差值
 */
- (NSDateComponents *)deltaFrom:(NSDate *)from;

/**
 * 是否为今年
 */
- (BOOL)isThisYear;

/**
 * 是否为今天
 */
- (BOOL)isToday;

/**
 * 是否为昨天
 */
- (BOOL)isYesterday;
@end
