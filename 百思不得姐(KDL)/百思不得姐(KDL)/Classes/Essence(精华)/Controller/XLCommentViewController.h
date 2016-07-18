//
//  XLCommentViewController.h
//  百思不得姐(KDL)
//
//  Created by Cb W on 16/7/18.
//  Copyright © 2016年 kdl. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XLTopic;
@interface XLCommentViewController : UIViewController
/** 帖子模型 */
@property (nonatomic, strong) XLTopic *topic;
@end
