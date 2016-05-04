//
//  XLRecommendCategory.m
//  百思不得姐(KDL)
//
//  Created by manager on 16/5/3.
//  Copyright © 2016年 kdl. All rights reserved.
//

#import "XLRecommendCategory.h"

@implementation XLRecommendCategory

- (NSMutableArray *)users
{
    if (!_users)
    {
        _users = [NSMutableArray array];
    }
    return _users;
}

@end
