
//
//  XLCommentHeaderView.m
//  百思不得姐(KDL)
//
//  Created by Cb W on 16/7/18.
//  Copyright © 2016年 kdl. All rights reserved.
//

#import "XLCommentHeaderView.h"

@interface XLCommentHeaderView ()
/** 文字标签 */
@property (nonatomic, weak) UILabel *label;
@end

@implementation XLCommentHeaderView

+ (instancetype)headerViewWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"header";
    XLCommentHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (header == nil) { // 缓存池中没有, 自己创建
        header = [[XLCommentHeaderView alloc] initWithReuseIdentifier:ID];
    }
    return header;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = XLGlobalBg;
        // 创建label
        UILabel *label = [[UILabel alloc] init];
        label.textColor = XLRGBColor(67, 67, 67);
        label.width = 200;
        label.x = XLTopicCellMargin;
        label.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:label];
        self.label = label;
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    _title = [title copy];
    
    self.label.text = title;
}

@end
