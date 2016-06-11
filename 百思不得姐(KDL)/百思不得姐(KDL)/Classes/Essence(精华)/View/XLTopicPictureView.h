//
//  XLTopicPictureView.h
//  百思不得姐(KDL)
//
//  Created by manager on 16/6/10.
//  Copyright © 2016年 kdl. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XLTopic;
@interface XLTopicPictureView : UIView
+ (instancetype)pictureView;
/** 帖子数据 */
@property (nonatomic, strong) XLTopic *topic;
@end
