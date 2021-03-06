//
//  XLEssenceViewController.m
//  百思不得姐(KDL)
//
//  Created by manager on 16/5/2.
//  Copyright © 2016年 kdl. All rights reserved.
//

#import "XLEssenceViewController.h"
#import "XLRecommendTagsViewController.h"
#import "XLTopicViewController.h"

@interface XLEssenceViewController ()<UIScrollViewDelegate>
/** 标签栏底部的红色指示器 */
@property (nonatomic, weak) UIView *indicatorView;
/** 当前选中的按钮 */
@property (nonatomic, weak) UIButton *selectedButton;
/** 顶部的所有标签 */
@property (nonatomic, weak) UIScrollView *titlesView;
/** 底部的所有内容 */
@property (nonatomic, weak) UIScrollView *contentView;
@end

@implementation XLEssenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 设置导航栏
    [self setupNav];
    
    // 初始化子控制器
    [self setupChildVces];
    
    // 设置顶部的标签栏
    [self setupTitlesView];
    
    // 底部的scrollView
    [self setupContentView];
  
}
/**
 * 初始化子控制器
 */
- (void)setupChildVces
{
    
    XLTopicViewController *all = [[XLTopicViewController alloc] init];
    all.title = @"全部";
      all.type = XLTopicTypeAll;
    [self addChildViewController:all];
    
    XLTopicViewController *video = [[XLTopicViewController alloc] init];
    video.title = @"视频";
     video.type = XLTopicTypeVideo;
    [self addChildViewController:video];
    
    XLTopicViewController *voice = [[XLTopicViewController alloc] init];
    voice.title = @"声音";
     voice.type = XLTopicTypeVoice;
    [self addChildViewController:voice];
    
    XLTopicViewController *picture = [[XLTopicViewController alloc] init];
    picture.title = @"图片";
         picture.type = XLTopicTypePicture;
    [self addChildViewController:picture];
    
    XLTopicViewController *word = [[XLTopicViewController alloc] init];
    word.title = @"段子";
    word.type = XLTopicTypeWord;
    [self addChildViewController:word];
     
    
    
//    XLAllViewController *a = [[XLAllViewController alloc] init];
//    all.title = @"全部2";
//    [self addChildViewController:a];
//    XLAllViewController *b = [[XLAllViewController alloc] init];
//    all.title = @"全部3";
//    [self addChildViewController:b];
//    XLAllViewController *c = [[XLAllViewController alloc] init];
//    all.title = @"全部4";
//    [self addChildViewController:c];
//    XLAllViewController *d = [[XLAllViewController alloc] init];
//    all.title = @"全部5";
//    [self addChildViewController:d];
}

/**
 *  设置顶部的标签栏
 */
- (void)setupTitlesView
{
    // 标签栏整体
    UIScrollView *titlesView = [[UIScrollView alloc] init];
    titlesView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    titlesView.showsVerticalScrollIndicator = NO;
    titlesView.showsHorizontalScrollIndicator = NO;

    titlesView.width = self.view.width;
    titlesView.height = XLTitilesViewH;
    titlesView.y = XLTitilesViewY;
    [self.view addSubview:titlesView];
    self.titlesView = titlesView;
    
    // 底部红色指示器
    UIView *indicatorView = [[UIView alloc] init];
    indicatorView.backgroundColor = [UIColor redColor];
    indicatorView.height = 2;
    indicatorView.tag = 1000;
    indicatorView.y = titlesView.height - indicatorView.height;
    self.indicatorView = indicatorView;
    
    
    // 定义临时变量
    CGFloat W = 100;
    CGFloat Y = 0;
    CGFloat H = self.titlesView.frame.size.height;
    //  内部的子标签
//    NSArray *titles = @[@"全部",@"视频",@"声音",@"图片",@"段子",@"网红",@"社会",@"美女",@"游戏"];
   
    for (NSInteger i = 0; i<self.childViewControllers.count; i++)
    {
        UIButton *button = [[UIButton alloc] init];
        CGFloat X = i * W;
        button.frame = CGRectMake(X, Y, W, H);
        button.tag = i;
        UIViewController *vc = self.childViewControllers[i];
        [button setTitle:vc.title forState:UIControlStateNormal];
//        [button layoutIfNeeded];// 强制布局(强制更新子控件的frame)
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [titlesView addSubview:button];
        // 默认点击了第一个按钮
        if (i == 0)
        {
            button.enabled = NO;
            self.selectedButton = button;
          // 让按钮内部的label根据文字内容来计算尺寸
            [button.titleLabel sizeToFit];
            self.indicatorView.width = button.titleLabel.width;
            self.indicatorView.centerX = button.centerX;
        }
        // 设置titlesView 的 contentSize
        self.titlesView.contentSize = CGSizeMake(self.childViewControllers.count * W, 0);
        
    }
    [titlesView addSubview:indicatorView];
}

- (void)titleClick:(UIButton *)button
{
    // 修改按钮状态
    self.selectedButton.enabled = YES;
    button.enabled = NO;
    self.selectedButton = button;
    // 动画
    [UIView animateWithDuration:0.25 animations:^{
        self.indicatorView.width = button.titleLabel.width;
        self.indicatorView.centerX = button.centerX;
    }];
    // 滚动
    CGPoint offset = self.contentView.contentOffset;
    offset.x = button.tag * self.contentView.width;
    [self.contentView setContentOffset:offset animated:YES];
}
/**
 * 底部的scrollView
 */
- (void)setupContentView
{
    // 不要自动调整inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    
  UIScrollView *contentView = [[UIScrollView alloc] init
                               ];
    contentView.frame = self.view.bounds;
    contentView.delegate = self;
    contentView.pagingEnabled = YES;
    [self.view insertSubview:contentView atIndex:0];
    contentView.contentSize = CGSizeMake(contentView.width * self.childViewControllers.count, 0);
    self.contentView = contentView;
    
    // 添加第一个控制器的view
    [self scrollViewDidEndScrollingAnimation:contentView];
}

- (void)setupNav
{
    // 设置导航栏标题
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
    // 设置导航栏左边的按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"MainTagSubIcon" highImage:@"MainTagSubIconClick" target:self action:@selector(tagClick)];
    
    // 设置背景色
    self.view.backgroundColor = XLGlobalBg;
}

- (void)tagClick
{
    XLRecommendTagsViewController *tags = [[XLRecommendTagsViewController alloc] init];
    [self.navigationController pushViewController:tags
                                         animated:YES];
}
#pragma mark - <UIScrollViewDelegate>
/**
 * scrollView结束了滚动动画以后就会调用这个方法（比如- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated;方法执行的动画完毕后）
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
     // 当前的索引
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    // 取出子控制器
    UIViewController *vc = self.childViewControllers[index];
    vc.view.x = scrollView.contentOffset.x;
    vc.view.y = 0;// 设置控制器view的y值为0(默认是20)
    vc.view.height = scrollView.height; // 设置控制器view的height值为整个屏幕的高度(默认是比屏幕高度少个20)
    [scrollView addSubview:vc.view];
    
    
    // 3. 让上边Button在中间
    CGFloat width = scrollView.frame.size.width;
    // 让对应的顶部标题居中显示
    UIButton *button = self.titlesView.subviews[index];
    CGPoint titleOffset = self.titlesView.contentOffset;
    titleOffset.x = button.center.x - width * 0.5;
    // 左边超出处理
    if (titleOffset.x < 0) titleOffset.x = 0;
    // 右边超出处理
    CGFloat maxTitleOffsetX = self.titlesView.contentSize.width - width;
    if (titleOffset.x > maxTitleOffsetX) titleOffset.x = maxTitleOffsetX;
    
    [self.titlesView setContentOffset:titleOffset animated:YES];
    

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
    // 点击按钮
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    [self titleClick:self.titlesView.subviews[index]];
}

@end






























