//
//  XLLoginRegisterViewController.m
//  百思不得姐(KDL)
//
//  Created by manager on 16/5/10.
//  Copyright © 2016年 kdl. All rights reserved.
//

#import "XLLoginRegisterViewController.h"

@interface XLLoginRegisterViewController ()
/** 最后那个大背景 */
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;

@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *passworldField;
/** 登录框距离控制器view左边的间距 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginViewLeftMargin;

@end

@implementation XLLoginRegisterViewController
/**
 *  点击叉叉退出控制器
 */
- (IBAction)dismiss {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self dismissViewControllerAnimated:YES completion:nil];
  
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    // 让最后的那个大背景图在最后面
    [self.view sendSubviewToBack:self.bgImage];
    //  文字属性
//    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
//    NSAttributedString *placeholder = [[NSAttributedString alloc] initWithString:@"手机号" attributes:attrs];
//    self.phoneField.attributedText = placeholder;

}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)showLoginOrRegister:(UIButton *)sender {
    // 退出键盘
    [self.view endEditing:YES];
    
    if (self.loginViewLeftMargin.constant == 0) {//  显示注册页面
        self.loginViewLeftMargin.constant = - self.view.width;
        [sender setTitle:@"已有账号?" forState:UIControlStateNormal];
    }else{// 显示登录界面
        self.loginViewLeftMargin.constant = 0;
        [sender setTitle:@"注册账号" forState:UIControlStateNormal];

    }
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}
#warning ----------
// iOS 7 开始， 默认情况下状态栏由控制器设置。但是可以恢复以前做法。在info.plist里加一个  View controller-based status bar appearance  设置成 NO 就可以了。让它不基于控制器。不基于控制器的话，就基于applacation  然后在viewdidload中写

//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}

@end
