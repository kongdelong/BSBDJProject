//
//  XLComment.h
//  百思不得姐(KDL)
//
//  Created by manager on 16/7/10.
//  Copyright © 2016年 kdl. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XLUser;
@interface XLComment : NSObject
/** 音频文件的时长 */
@property (nonatomic, assign) NSInteger voicetime;
/** 评论的文字内容 */
@property (nonatomic, copy) NSString *content;
/** 被点赞的数量 */
@property (nonatomic, assign) NSInteger like_count;
/** 用户 */
@property (nonatomic, strong) XLUser *user;
@end
