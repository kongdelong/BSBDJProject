//
//  XLTopic.m
//  百思不得姐(KDL)
//
//  Created by manager on 16/5/29.
//  Copyright © 2016年 kdl. All rights reserved.
//

#import "XLTopic.h"
#import <MJExtension.h>
#import "XLComment.h"
#import "XLUser.h"
@implementation XLTopic
{
    CGFloat _cellHeight;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"small_image" : @"image0",
             @"large_image" : @"image1",
             @"middle_image" : @"image2",
             @"ID" : @"id"
             };
}

+ (NSDictionary *)objectClassInArray
{
    //    return @{@"top_cmt" : [XLComment class]};
    return @{@"top_cmt" : @"XLComment"};
}

- (NSString *)create_time
{
    //  日期格式化类
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    // 设置日期格式(y:年,M:月,d:日,H:时,m:分,s:秒)
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    // 帖子的创建时间
    NSDate *create = [fmt dateFromString:_create_time];
    
    if (create.isThisYear) { // 今年
        if (create.isToday) { // 今天
            NSDateComponents *cmps = [[NSDate date] deltaFrom:create];
            if (cmps.hour >=1) { // 时间差距 >= 1小时
                return [NSString stringWithFormat:@"%zd小时前", cmps.hour];
            } else if (cmps.minute >= 1){ // 1小时 > 时间差距 >= 1分钟
                return [NSString stringWithFormat:@"%zd分钟前", cmps.minute];
            } else { // 1分钟 > 时间差距
                return @"刚刚";
            }
        } else if (create.isYesterday){ // 昨天
            fmt.dateFormat = @"昨天 HH:mm:ss";
            return [fmt stringFromDate:create];
        } else { // 其它
            fmt.dateFormat = @"MM-dd HH:mm:ss";
            return [fmt stringFromDate:create];
        }
    }
    else {// 非今年
        fmt.dateFormat = @"MM-dd HH:mm:ss";
        return [fmt stringFromDate:create];
    }
}

- (CGFloat)cellHeight
{
    if (!_cellHeight) {
        // 文字的最大尺寸
        CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 4 * XLTopicCellMargin, MAXFLOAT);
        // 计算文字的高度
        CGFloat textH = [self.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
        
        // cell的高度
        // 文字部分的高度
        _cellHeight = XLTopicCellTextY + textH + XLTopicCellMargin;
        
        
        // 根据段子的类型来计算cell的高度
        if (self.type == XLTopicTypePicture)
        {// 图片帖子
            // 图片显示出来的宽度
            CGFloat pictureW = maxSize.width;
            // 显示显示出来的高度
            CGFloat pictureH = pictureW * self.height / self.width;
            
            if (pictureH >= XLTopicCellPictureMaxH) {// 图片高度过长
                pictureH = XLTopicCellPictureBreakH;
                self.bigPicture = YES; // 大图
            }
            
            // 计算图片控件的frame
            CGFloat pictureX = XLTopicCellMargin;
            CGFloat pictureY = XLTopicCellTextY + textH + XLTopicCellMargin;
            _pictureF = CGRectMake(pictureX, pictureY, pictureW, pictureH);
            
            _cellHeight += pictureH + XLTopicCellMargin;
        }
        else if (self.type == XLTopicTypeVoice){ // 声音帖子
            CGFloat voiceX = XLTopicCellMargin;
            CGFloat voiceY = XLTopicCellTextY + textH + XLTopicCellMargin;
            CGFloat voiceW = maxSize.width;
            CGFloat voiceH = voiceW * self.height / self.width;
            _voiceF = CGRectMake(voiceX, voiceY, voiceW, voiceH);
            
            _cellHeight += voiceH + XLTopicCellMargin;
        }
        else if (self.type == XLTopicTypeVideo){ // 视频帖子
            
            CGFloat videoX = XLTopicCellMargin;
            CGFloat videoY = XLTopicCellTextY + textH + XLTopicCellMargin;
            CGFloat videoW = maxSize.width;
            CGFloat videoH = videoW * self.height / self.width;
            _videoF = CGRectMake(videoX, videoY, videoW, videoH);
            
            _cellHeight += videoH + XLTopicCellMargin;
        }
        
        // 如果有最热评论
        XLComment *cmt = [self.top_cmt firstObject];
        if (cmt) {
           
            NSString *content = [NSString stringWithFormat:@"%@ : %@", cmt.user.username, cmt.content];
            CGFloat contentH = [content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil].size.height;
            
            _cellHeight += XLTopicCellTopCmtTitleH + contentH + XLTopicCellMargin;
        }
        
        
        // 底部工具条的高度
        _cellHeight += XLTopicCellBottomBarH + XLTopicCellMargin;
        
    }
    return _cellHeight;
}



@end
















