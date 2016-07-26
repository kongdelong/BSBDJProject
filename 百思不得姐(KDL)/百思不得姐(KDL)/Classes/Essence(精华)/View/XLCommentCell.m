//
//  XLCommentCell.m
//  百思不得姐(KDL)
//
//  Created by Cb W on 16/7/19.
//  Copyright © 2016年 kdl. All rights reserved.
//

#import "XLCommentCell.h"
#import <UIImageView+WebCache.h>
#import "XLUser.h"
#import "XLComment.h"

@interface XLCommentCell ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sexView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *voiceButton;

@end

@implementation XLCommentCell
// 使用uimenucontroller必须实现的方法
- (BOOL)canBecomeFirstResponder
{
    return YES;
}
// 使用uimenucontroller必须实现的方法
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return NO;
}




- (void)setComment:(XLComment *)comment
{
    _comment = comment;
    
    [self.profileImageView setHeader:comment.user.profile_image];
    
    self.sexView.image = [comment.user.sex isEqualToString:XLUserSexMale] ? [UIImage imageNamed:@"Profile_manIcon"] : [UIImage imageNamed:@"Profile_womanIcon"];
    self.contentLabel.text = comment.content;
    self.usernameLabel.text = comment.user.username;
    self.likeCountLabel.text = [NSString stringWithFormat:@"%zd", comment.like_count];
    
    if (comment.voiceuri.length) {
        self.voiceButton.hidden = NO;
        [self.voiceButton setTitle:[NSString stringWithFormat:@"%zd''", comment.voicetime] forState:UIControlStateNormal];
    } else {
        self.voiceButton.hidden = YES;
    }

}

- (void)setFrame:(CGRect)frame
{
    frame.origin.x = XLTopicCellMargin;
    frame.size.width -= 2 * XLTopicCellMargin;
    [super setFrame:frame];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.image = [UIImage imageNamed:@"mainCellBackground"];
    self.backgroundView = bgView;
    
}
@end


































