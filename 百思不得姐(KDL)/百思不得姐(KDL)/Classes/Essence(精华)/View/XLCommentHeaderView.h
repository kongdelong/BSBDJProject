//
//  XLCommentHeaderView.h
//  百思不得姐(KDL)
//
//  Created by Cb W on 16/7/18.
//  Copyright © 2016年 kdl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLCommentHeaderView : UITableViewHeaderFooterView
/** 文字数据 */
@property (nonatomic, copy) NSString *title;

+ (instancetype)headerViewWithTableView:(UITableView *)tableView;
@end
