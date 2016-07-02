//
//  XLTopicVoiceView.m
//  百思不得姐(KDL)
//
//  Created by manager on 16/7/2.
//  Copyright © 2016年 kdl. All rights reserved.
//

#import "XLTopicVoiceView.h"
#import "XLTopic.h"
#import <UIImageView+WebCache.h>
@interface XLTopicVoiceView ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *playCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *voiceLengthLabel;
@end

@implementation XLTopicVoiceView

+ (instancetype)voiceView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (void)awakeFromNib
{
    self.autoresizingMask = UIViewAutoresizingNone;
}

- (void)setTopic:(XLTopic *)topic
{
    _topic = topic;
   // 图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.large_image]];
    // 播放次数
    self.playCountLabel.text = [NSString stringWithFormat:@"%zd播放", topic.playcount];
    // 时长
    NSInteger min = topic.voicetime / 60;
    NSInteger sec = topic.voicetime % 60;
    self.voiceLengthLabel.text = [NSString stringWithFormat:@"%02zd:%02zd",min,sec];
}

@end

















