//
//  XLRecommendCatogoryCell.m
//  百思不得姐(KDL)
//
//  Created by manager on 16/5/3.
//  Copyright © 2016年 kdl. All rights reserved.
//

#import "XLRecommendCatogoryCell.h"
#import "XLRecommendCategory.h"

@interface XLRecommendCatogoryCell ()
/** 选中时显示的指示器控件 */
@property (weak, nonatomic) IBOutlet UIView *selectedIndicator;

@end

@implementation XLRecommendCatogoryCell

- (void)awakeFromNib
{
    self.backgroundColor = XLRGBColor(244, 244, 244);
    self.selectedIndicator.backgroundColor = [UIColor redColor];
}

- (void)setCategory:(XLRecommendCategory *)category
{
    _category = category;
    self.textLabel.text = category.name;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //  重新调整内部textlabel 的 frame
    self.textLabel.y = 2;
    self.textLabel.height = self.contentView.height - 2 * self.textLabel.y;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    self.selectedIndicator.backgroundColor = [UIColor redColor];
    self.selectedIndicator.hidden = !selected;
    
    self.textLabel.textColor = selected ? self.selectedIndicator.backgroundColor : XLRGBColor(78, 78, 78);
    
}

@end
