//
//  UITextField+PlaceHolderColor.m
//  XCCategrayKit
//
//  Created by jiangfuyuan on 2019/9/27.
//  Copyright © 2019 WuJieHuDong. All rights reserved.
//

#import "UITextField+PlaceHolderColor.h"
#import <objc/message.h>

@implementation UITextField (PlaceHolderColor)
//分类的代码
+ (void)load
{
     Method placeholder = class_getInstanceMethod(self, @selector(setPlaceholder:));
    
    Method placeBS_holder = class_getInstanceMethod(self, @selector(setBS_Placeholder:));
    
    method_exchangeImplementations(placeholder, placeBS_holder);

}
//这是设置颜色的方法
- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
   //给系统的类增加一个属性，然后保存起来
    objc_setAssociatedObject(self, "placeholderColor", placeholderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    UILabel *placeholder = [self valueForKey:@"placeholderLabel"];
    
    placeholder.textColor = placeholderColor;
}

- (UIColor *)placeholderColor
{
    return objc_getAssociatedObject(self, "placeholderColor");
}

//交换方法的实现
- (void)setBS_Placeholder:(NSString *)placeholder
{
   //因为交换方法实现所以是调用了系统的方法
    [self setBS_Placeholder:placeholder];
    //再把颜色赋值
    self.placeholderColor = self.placeholderColor;
    
}

@end
