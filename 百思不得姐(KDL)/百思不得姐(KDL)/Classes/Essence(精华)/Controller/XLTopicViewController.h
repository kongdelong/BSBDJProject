//
//  XLTopicViewController.h
//  百思不得姐(KDL)
//
//  Created by manager on 16/5/29.
//  Copyright © 2016年 kdl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    XMGTopicTypeAll = 1,
    XMGTopicTypePicture = 10,
    XMGTopicTypeWord = 29,
    XMGTopicTypeVoice = 31,
    XMGTopicTypeVideo = 41
} XMGTopicType;

@interface XLTopicViewController : UITableViewController
/** 帖子类型 */
@property (nonatomic, assign) XMGTopicType type;
@end
