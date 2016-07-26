//
//  XLTopicCell.m
//  百思不得姐(KDL)
//
//  Created by manager on 16/5/29.
//  Copyright © 2016年 kdl. All rights reserved.
//

#import "XLTopicCell.h"
#import "XLTopic.h"
#import <UIImageView+WebCache.h>
#import "XLTopicPictureView.h"
#import "XLTopicVoiceView.h"
#import "XLTopicVideoView.h"
#import "XLComment.h"
#import "XLUser.h"
@interface XLTopicCell ()
/** 头像 */
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
/** 昵称 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/** 时间 */
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
/** 顶 */
@property (weak, nonatomic) IBOutlet UIButton *dingButton;
/** 踩 */
@property (weak, nonatomic) IBOutlet UIButton *caiButton;
/** 分享 */
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
/** 评论 */
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
/** 新浪加V */
@property (weak, nonatomic) IBOutlet UIImageView *sinaVView;
/** 帖子的文字内容 */
@property (weak, nonatomic) IBOutlet UILabel *text_Label;
/** 图片帖子中间的内容 */
@property (nonatomic, weak) XLTopicPictureView *pictureView;
/** 声音帖子中间的内容 */
@property (nonatomic, weak) XLTopicVoiceView *voiceView;
/** 视频帖子中间的内容 */
@property (nonatomic, weak) XLTopicVideoView *videoView;
/** 最热评论的内容 */
@property (weak, nonatomic) IBOutlet UILabel *topCmtContentLabel;
/** 最热评论的整体 */
@property (weak, nonatomic) IBOutlet UIView *topCmtView;
@end

@implementation XLTopicCell

+ (instancetype)cell
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

- (XLTopicPictureView *)pictureView
{
    if (!_pictureView) {
        XLTopicPictureView *pictureView = [XLTopicPictureView pictureView];
        [self.contentView addSubview:pictureView];
        _pictureView = pictureView;
    }
    return _pictureView;
}

- (XLTopicVoiceView *)voiceView
{
    if (!_voiceView) {
        XLTopicVoiceView *voiceView = [XLTopicVoiceView voiceView];
        [self.contentView addSubview:voiceView];
        _voiceView = voiceView;
    }
    return _voiceView;
}

- (XLTopicVideoView *)videoView
{
    if (!_videoView) {
        XLTopicVideoView *videoView = [XLTopicVideoView videoView];
        [self.contentView addSubview:videoView];
        _videoView = videoView;
    }
    return _videoView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.image = [UIImage imageNamed:@"mainCellBackground"];
    self.backgroundView = bgView;
        
}
/**
 今年
    今天
     1分钟内
     刚刚
     1小时内
     xx分钟前
 其他
   xx小时前
 昨天
   昨天 18:56:34
 其他
   06-23 19:56:23
 
 非今年
   2014-05-08 18:45:30
 */
- (void)setTopic:(XLTopic *)topic
{
    _topic = topic;
    
    // 新浪加V
    self.sinaVView.hidden = !topic.isSina_v;
    // 设置其它控件
    [self.profileImageView setHeader:topic.profile_image];

    self.nameLabel.text = topic.name;
    self.createTimeLabel.text = topic.create_time;

    // 设置按钮文字
    [self setupButtonTitle:self.dingButton count:topic.ding placeholder:@"顶"];
    [self setupButtonTitle:self.caiButton count:topic.cai placeholder:@"踩"];
    [self setupButtonTitle:self.shareButton count:topic.repost placeholder:@"分享"];
    [self setupButtonTitle:self.commentButton count:topic.comment placeholder:@"评论"];
    
    // 设置帖子的文字内容
    self.text_Label.text = topic.text;
    
    
    // 根据模型类型(帖子类型)添加对应的内容到cell的中间
    if (topic.type == XLTopicTypePicture) { // 图片帖子
           self.pictureView.hidden = NO;
        self.pictureView.topic = topic;
        self.pictureView.frame = topic.pictureF;
        
        self.voiceView.hidden = YES;
        self.videoView.hidden = YES;
    }else if (topic.type == XLTopicTypeVoice){ // 声音帖子
        self.voiceView.hidden = NO;

        self.voiceView.topic = topic;
        self.voiceView.frame = topic.voiceF;
        
        self.pictureView.hidden = YES;
        self.videoView.hidden = YES;
    }else if (topic.type == XLTopicTypeVideo){ // 视频帖子
        self.videoView.hidden = NO;

        self.videoView.topic = topic;
        self.videoView.frame = topic.videoF;
        
        self.voiceView.hidden = YES;
        self.pictureView.hidden = YES;
    }else{ // 段子
        self.videoView.hidden = YES;
        self.voiceView.hidden = YES;
        self.pictureView.hidden = YES;
    }
    
    
    // 处理最热评论
    if (topic.top_cmt) {
        self.topCmtView.hidden = NO;
        self.topCmtContentLabel.text = [NSString stringWithFormat:@"%@ : %@", topic.top_cmt.user.username, topic.top_cmt.content];
    } else {
        self.topCmtView.hidden = YES;
    }
}


/**
 * 设置底部按钮文字
 */
- (void)setupButtonTitle:(UIButton *)button count:(NSInteger)count placeholder:(NSString *)placeholder
{
    //    NSString *title = nil;
    //    if (count == 0) {
    //        title = placeholder;
    //    } else if (count > 10000) {
    //        title = [NSString stringWithFormat:@"%.1f万", count / 10000.0];
    //    } else {
    //        title = [NSString stringWithFormat:@"%zd", count];
    //    }
    if (count > 10000) {
        placeholder = [NSString stringWithFormat:@"%.1f万", count / 10000.0];
    } else if (count > 0) {
        placeholder = [NSString stringWithFormat:@"%zd", count];
    }
    [button setTitle:placeholder forState:UIControlStateNormal];
}

- (void)setFrame:(CGRect)frame
{
    static CGFloat margin = 10;
    
    frame.origin.x = margin;
    frame.size.width -= 2 * margin;
    frame.size.height -= margin;
    frame.origin.y += margin;
    
    [super setFrame:frame];
}

@end









































