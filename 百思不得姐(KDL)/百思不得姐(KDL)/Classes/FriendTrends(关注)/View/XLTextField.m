//
//  XLTextField.m
//  百思不得姐(KDL)
//
//  Created by manager on 16/5/15.
//  Copyright © 2016年 kdl. All rights reserved.
//

#import "XLTextField.h"
#import <objc/runtime.h>
static NSString *const XLPlaceholderColorKeyPath = @"_placeholderLabel.textColor";
@implementation XLTextField

+ (void)initialize
{
//    [self getIvars];
}

+ (void)getProperties
{
    unsigned int count = 0;
    
    objc_property_t *properties = class_copyPropertyList([UITextField class], &count);
    
    for (int i = 0; i<count; i++) {
        // 取出属性
        objc_property_t property = properties[i];
        
        // 打印属性名字
        XLLog(@"%s   <---->   %s", property_getName(property), property_getAttributes(property));
    }
    
    free(properties);
}

+ (void)getIvars
{
    unsigned int count = 0;
    // 拷贝出所有的成员变量列表
   Ivar *ivars = class_copyIvarList([UITextField class], &count);
    
    for(int i = 0; i < count; i ++)
    {
      //  取出成员变量
        Ivar ivar = ivars[i];
        XLLog(@"%s %s", ivar_getName(ivar),ivar_getTypeEncoding(ivar));
    }
    // 释放
    free(ivars);
}

- (void)awakeFromNib
{
    // 设置光标颜色和文字颜色一致
    self.tintColor = self.textColor;
    // 不成为第一响应者
    [self resignFirstResponder];
}
/**
 * 当前文本框聚焦时就会调用
 */
- (BOOL)becomeFirstResponder
{
    // 修改占位文字颜色
    [self setValue:self.textColor forKeyPath:XLPlaceholderColorKeyPath];
    return [super becomeFirstResponder];
}
/**
 * 当前文本框失去焦点时就会调用
 */
- (BOOL)resignFirstResponder
{
    // 修改占位文字颜色
    [self setValue:[UIColor grayColor] forKeyPath:XLPlaceholderColorKeyPath];
    return [super resignFirstResponder];
}

@end

//- (void)setHighlighted:(BOOL)highlighted
//{
//    XMGLog(@"-----%d", highlighted);
//    [self setValue:self.textColor forKeyPath:@"_placeholderLabel.textColor"];
//}

//- (void)setPlaceholderColor:(UIColor *)placeholderColor
//{
//    _placeholderColor = placeholderColor;
//
//    // 修改占位文字颜色
//    [self setValue:placeholderColor forKeyPath:XMGPlacerholderColorKeyPath];
//}

/**
 运行时(Runtime):
 * 苹果官方一套C语言库
 * 能做很多底层操作(比如访问隐藏的一些成员变量\成员方法....)
 */


// 第二种方法改变占位文字样式
//- (void)drawPlaceholderInRect:(CGRect)rect
//{
//    [self.placeholder drawInRect:CGRectMake(0, 10, self.width, 25) withAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:self.font}];
//}

