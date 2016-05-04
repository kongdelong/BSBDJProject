//
//  XLRecommendUserCell.m
//  百思不得姐(KDL)
//
//  Created by manager on 16/5/4.
//  Copyright © 2016年 kdl. All rights reserved.
//

#import "XLRecommendUserCell.h"
#import "XLRecommendUser.h"
#import <UIImageView+WebCache.h>
@interface XLRecommendUserCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansCountLabel;

@end

@implementation XLRecommendUserCell

- (void)setUser:(XLRecommendUser *)user
{
    _user = user;
    
    self.screenNameLabel.text = user.screen_name;
    self.fansCountLabel.text = [NSString stringWithFormat:@"%zd 人关注",user.fans_count];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:user.header] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    
}

@end
