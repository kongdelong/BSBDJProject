//
//  XLProgressView.m
//  百思不得姐(KDL)
//
//  Created by manager on 16/6/11.
//  Copyright © 2016年 kdl. All rights reserved.
//

#import "XLProgressView.h"

@implementation XLProgressView

- (void)awakeFromNib
{
    self.roundedCorners = 2;
    self.progressLabel.textColor = [UIColor whiteColor];
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated
{
    [super setProgress:progress animated:animated];
    
    NSString *text = [NSString stringWithFormat:@"%.0f%%", progress * 100];
    self.progressLabel.text = [text stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

@end
