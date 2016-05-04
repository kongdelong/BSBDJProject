//
//  XLRecommendCategory.h
//  百思不得姐(KDL)
//
//  Created by manager on 16/5/3.
//  Copyright © 2016年 kdl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLRecommendCategory : NSObject
/** id */
@property (nonatomic, assign) NSInteger id;
/** 总数 */
@property (nonatomic, assign) NSInteger count;
/** 名字 */
@property (nonatomic, copy) NSString *name;


/** 这个类别对应的用户数据 */
@property (nonatomic, strong) NSMutableArray *users;

@end
