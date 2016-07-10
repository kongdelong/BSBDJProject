//
//  XLUser.h
//  百思不得姐(KDL)
//
//  Created by manager on 16/7/10.
//  Copyright © 2016年 kdl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLUser : NSObject
/** 用户名 */
@property (nonatomic, copy) NSString *username;
/** 性别 */
@property (nonatomic, copy) NSString *sex;
/** 头像 */
@property (nonatomic, copy) NSString *profile_image;
@end
