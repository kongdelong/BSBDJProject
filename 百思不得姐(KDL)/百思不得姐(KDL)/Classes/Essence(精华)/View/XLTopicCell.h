//
//  XLTopicCell.h
//  百思不得姐(KDL)
//
//  Created by manager on 16/5/29.
//  Copyright © 2016年 kdl. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XLTopic;
@interface XLTopicCell : UITableViewCell
/** 帖子数据 */
@property (nonatomic, strong) XLTopic *topic;

+ (instancetype)cell;
@end
