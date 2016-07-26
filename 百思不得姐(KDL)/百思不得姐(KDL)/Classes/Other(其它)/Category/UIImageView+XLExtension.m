//
//  UIImageView+XLExtension.m
//  百思不得姐(KDL)
//
//  Created by Cb W on 16/7/26.
//  Copyright © 2016年 kdl. All rights reserved.
//

#import "UIImageView+XLExtension.h"
#import <UIImageView+WebCache.h>

@implementation UIImageView (XLExtension)
- (void)setHeader:(NSString *)url
{
    UIImage *placeholder = [[UIImage imageNamed:@"defaultUserIcon"] circleImage];
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.image = image ? [image circleImage] : placeholder;
    }];
}
@end
