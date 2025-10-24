//
//  UITextField+LimitLength.m
//  YYFace
//
//  Created by zill on 2016/10/19.
//  Copyright © 2016年 com.yy.face. All rights reserved.
//

#import "UITextField+LimitLength.h"
#import <objc/objc.h>
#import <objc/runtime.h>

@implementation UITextField (LimitLength)

static NSString *kLimitTextLengthKey = @"kLimitTextLengthKey";

- (void)limitTextLength:(int)length
{
    objc_setAssociatedObject(self, (const void *)CFBridgingRetain(kLimitTextLengthKey), [NSNumber numberWithInt:length], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self addTarget:self action:@selector(textFieldTextLengthLimit:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldTextLengthLimit:(id)sender
{
    NSNumber *lengthNumber = objc_getAssociatedObject(self, (const void *)CFBridgingRetain(kLimitTextLengthKey));
    int maxLength = [lengthNumber intValue];
    NSString *toBeString = self.text;
    NSString *lang = self.textInputMode.primaryLanguage; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"] || [lang isEqualToString:@"zh-Hant"]) { // 简繁体中文
        UITextRange *selectedRange = [self markedTextRange];
//        NSString *selectedText = [self textInRange:selectedRange];
        //获取高亮部分
        UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
//        UITextPosition* beginning = self.beginningOfDocument;
//        NSInteger location = [self offsetFromPosition:beginning toPosition:selectedRange.start];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position){// || location >= maxLength) {
            if (toBeString.length > maxLength) {
                self.text = [toBeString substringToIndex:maxLength];
            }
        }
//        else{
//            NSRange range = NSMakeRange(0, 1);
//            NSString *firstString = [selectedText substringWithRange:range];
//            const char  *cString = [firstString UTF8String];
//            if (strlen(cString) >= 3 && toBeString.length > maxLength)
//            {
//                self.text = [toBeString substringToIndex:maxLength];
//            }
//        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > maxLength && self.markedTextRange == nil)
        {
            //用字符串的字符编码指定索引查找位置
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:maxLength];
            if (rangeIndex.length == 1)
            {
                self.text = [toBeString substringToIndex:maxLength];
            }
            else
            {
                //用字符串的字符编码指定区域段查找位置
                self.text = [toBeString substringWithRange:NSMakeRange(0, toBeString.length - rangeIndex.length)];
            }
        }
    }
}

- (BOOL)shouldChangeTextInRange:(UITextRange *)range replacementText:(NSString *)text
{
    [self textFieldTextLengthLimit:nil];
    return YES;
}

@end
