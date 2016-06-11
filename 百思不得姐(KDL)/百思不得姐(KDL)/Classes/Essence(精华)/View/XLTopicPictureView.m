//
//  XLTopicPictureView.m
//  百思不得姐(KDL)
//
//  Created by manager on 16/6/10.
//  Copyright © 2016年 kdl. All rights reserved.
//

#import "XLTopicPictureView.h"
#import <UIImageView+WebCache.h>
#import "XLTopic.h"
#import "XLProgressView.h"
#import "XLShowPictureViewController.h"
@interface XLTopicPictureView ()
/** 图片 */
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
/** gif标识 */
@property (weak, nonatomic) IBOutlet UIImageView *gifView;
/** 查看大图按钮 */
@property (weak, nonatomic) IBOutlet UIButton *seeBigButton;
/** 进度条控件 */
@property (weak, nonatomic) IBOutlet XLProgressView *progressView;
@end

@implementation XLTopicPictureView

+ (instancetype)pictureView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (void)awakeFromNib
{
    self.autoresizingMask = UIViewAutoresizingNone;
    // 给图片添加监听器
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicture)]];
}
- (void)showPicture
{
    XLShowPictureViewController *showPicture = [[XLShowPictureViewController alloc] init];
    showPicture.topic = self.topic;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:showPicture animated:YES completion:nil];
}

- (void)setTopic:(XLTopic *)topic
{
    _topic = topic;
    /**
     在不知道图片扩展名的情况下, 如何知道图片的真实类型?
     * 取出图片数据的第一个字节, 就可以判断出图片的真实类型
     */
    // 设置图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.large_image] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
         self.progressView.hidden = NO;
        CGFloat progress = 1.0 * receivedSize / expectedSize;
        [self.progressView setProgress:progress animated:NO];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
         self.progressView.hidden = YES;
    }];
    
    
    
    // 判断是否为gif
    NSString *extension = topic.large_image.pathExtension;
    self.gifView.hidden = ![extension.lowercaseString isEqualToString:@"gif"];
    
     // 判断是否显示"点击查看全图"
    if (topic.isBigPicture) {
        self.seeBigButton.hidden = NO;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;

    }else{ // 非大图
        self.seeBigButton.hidden = YES;
        self.imageView.contentMode = UIViewContentModeScaleToFill;
    }

}

@end















