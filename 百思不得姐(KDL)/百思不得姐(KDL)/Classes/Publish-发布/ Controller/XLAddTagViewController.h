//
//  XLAddTagViewController.h
//  百思不得姐(KDL)
//
//  Created by Cb W on 16/8/11.
//  Copyright © 2016年 kdl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLAddTagViewController : UIViewController
/** 获取tags的block */
@property (nonatomic, copy) void (^tagsBlock)(NSArray *tags);
/** 所有的标签 */
@property (nonatomic, strong) NSArray *tags;
@end
