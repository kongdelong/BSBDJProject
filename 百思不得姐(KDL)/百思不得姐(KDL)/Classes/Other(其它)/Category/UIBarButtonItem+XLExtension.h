//
//  UIBarButtonItem+XLExtension.h
//  百思不得姐(KDL)
//
//  Created by manager on 16/5/2.
//  Copyright © 2016年 kdl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (XLExtension)
+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action;
@end
