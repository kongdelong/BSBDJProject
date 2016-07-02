//
//  XLTopicVoiceView.h
//  百思不得姐(KDL)
//
//  Created by manager on 16/7/2.
//  Copyright © 2016年 kdl. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XLTopic;
@interface XLTopicVoiceView : UIView
+ (instancetype)voiceView;
/** 帖子数据 */
@property (nonatomic, strong) XLTopic *topic;
@end
