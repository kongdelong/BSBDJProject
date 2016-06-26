//
//  XLPublishView.m
//  百思不得姐(KDL)
//
//  Created by manager on 16/6/26.
//  Copyright © 2016年 kdl. All rights reserved.
//

#import "XLPublishView.h"
#import "XLVerticalButton.h"
#import <POP.h>

static CGFloat const XLAnimationDelay = 0.1;
static CGFloat const XLSpringFactor = 10;

@interface XLPublishView ()

@end

@implementation XLPublishView

+ (instancetype)publishView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

static UIWindow *window_;
+ (void)show
{
    // 创建窗口
    window_ = [[UIWindow alloc] init];
    window_.frame = [UIScreen mainScreen].bounds;
    window_.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    window_.hidden = NO;
    
    // 添加发布界面
    XLPublishView *publishView = [XLPublishView publishView];
    publishView.frame = window_.bounds;
    [window_ addSubview:publishView];
}

- (void)awakeFromNib {

    // 不能被点击
    self.userInteractionEnabled = NO;
    
    // 数据
    NSArray *images = @[@"publish-video", @"publish-picture", @"publish-text", @"publish-audio", @"publish-review", @"publish-offline"];
    NSArray *titles = @[@"发视频", @"发图片", @"发段子", @"发声音", @"审帖", @"离线下载"];
    
    // 中间6个按钮
    int maxCols = 3;
    CGFloat buttonW = 72;
    CGFloat buttonH = buttonW + 30;
    CGFloat startY = (XLScreenHeight - 2 * buttonH) * 0.5;
    CGFloat startX = 30;
    CGFloat xMargin = (XLScreenWidth - 2 * startX - maxCols * buttonW) / (maxCols - 1);

    for (int i = 0; i < images.count; i ++) {
      
        XLVerticalButton *button = [[XLVerticalButton alloc] init];
        button.tag = i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
          // 设置内容
        button.titleLabel.font =[UIFont systemFontOfSize:14];
        [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        //  设置X/Y
        int col = i % maxCols;
        int row = i / maxCols;
        CGFloat buttonX = col * (buttonW + xMargin) + startX;
        CGFloat buttonEndY = startY + row * buttonH;
        CGFloat buttonBeginY = buttonEndY - XLScreenHeight;
       
        // 按钮动画
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        anim.fromValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonBeginY, buttonW, buttonH)];
        anim.toValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonEndY, buttonW, buttonH)];
        // 弹簧系数
        anim.springBounciness = XLSpringFactor;
        // 下落速度
        anim.springSpeed = XLSpringFactor ;
        anim.beginTime = CACurrentMediaTime() + XLAnimationDelay * i;
        [button pop_addAnimation:anim forKey:nil];
    }
    
    // 添加标语
    UIImageView *sloganView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_slogan"]];
    [self addSubview:sloganView];
    
    // 标语动画
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    CGFloat centX = XLScreenWidth * 0.5;
    CGFloat centEndY = XLScreenHeight * 0.2;
    CGFloat centBeginY = centEndY - XLScreenHeight;
    anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(centX, centBeginY)];
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(centX, centEndY)];
    anim.beginTime = CACurrentMediaTime() + images.count * XLAnimationDelay;
    anim.springBounciness = XLSpringFactor;
    anim.springSpeed = XLSpringFactor;
    [anim setCompletionBlock:^(POPAnimation * anim, BOOL finished) {
        // 标语动画执行完毕, 恢复点击事件
        self.userInteractionEnabled = YES;
    }];
    [sloganView pop_addAnimation:anim forKey:nil];
}

- (void)buttonClick:(UIButton *)button
{
    [self cancelWithCompletionBlock:^{
        if (button.tag == 0) {
            XLLog(@"发视频");
        } else if (button.tag == 1) {
            XLLog(@"发图片");
        }
    }];
}

- (IBAction)cancel {
    
    [self cancelWithCompletionBlock: nil];
}

/**
 * 先执行退出动画, 动画完毕后执行completionBlock
 */
- (void)cancelWithCompletionBlock:(void(^)())completionBlock
{
    // 不能被点击
    self.userInteractionEnabled = NO;
    int beginIndex = 1;
    
    for ( int i = beginIndex; i < self.subviews.count; i ++) {
        UIView *subview = self.subviews[i];
        //  基本动画
        POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
        CGFloat centerY = subview.centerY + XLScreenHeight;
        // 动画的执行节奏(一开始很慢, 后面很快)
        //        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        anim.toValue = [NSValue valueWithCGPoint:CGPointMake(subview.centerX, centerY)];
        anim.beginTime = CACurrentMediaTime() + (i - beginIndex) * XLAnimationDelay;
        [subview pop_addAnimation:anim forKey:nil];
        // 监听最后一个动画
        if (i == self.subviews.count - 1) {
            [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
                // 销毁窗口
                window_.hidden = YES;
                window_ = nil;
                // 执行传过来的block
                 !completionBlock ? : completionBlock();
            }];
        }
    }
}

/**
 pop和Core Animation的区别
 1.Core Animation的动画只能添加到layer上
 2.pop的动画能添加到任何对象
 3.pop的底层并非基于Core Animation, 是基于CADisplayLink
 4.Core Animation的动画仅仅是表象, 并不会真正修改对象的frame\size等值
 5.pop的动画实时修改对象的属性, 真正地修改了对象的属性
 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self cancelWithCompletionBlock:nil];
}
@end
















