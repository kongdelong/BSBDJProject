//
//  XLRecommendTagCell.m
//  百思不得姐(KDL)
//
//  Created by manager on 16/5/9.
//  Copyright © 2016年 kdl. All rights reserved.
//

#import "XLRecommendTagCell.h"
#import <UIImageView+WebCache.h>
#import "XLRecommentTags.h"
@interface XLRecommendTagCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageListImageView;
@property (weak, nonatomic) IBOutlet UILabel *themeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subNumberLabel;
@end

@implementation XLRecommendTagCell


- (void)setRecommentTag:(XLRecommentTags *)recommentTag
{
    _recommentTag = recommentTag;

    
       
    
    [self.imageListImageView setHeader:recommentTag.image_list];
    
    self.themeNameLabel.text = recommentTag.theme_name;
    
    NSString *subNumber = nil;
    if (recommentTag.sub_number < 10000)
    {
        subNumber = [NSString stringWithFormat:@"%zd人订阅",recommentTag.sub_number];
    }
    else
    { // 大于10000
        subNumber = [NSString stringWithFormat:@"%.1f万人订阅",recommentTag.sub_number/10000.0];
    }
    self.subNumberLabel.text = subNumber;
    
}

- (void)setFrame:(CGRect)frame
{
    frame.origin.x = 5;
    frame.size.width -= 2 * frame.origin.x;
    frame.size.height -=1;
    [super setFrame:frame];
}
@end
























