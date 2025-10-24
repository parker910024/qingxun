//
//  UITextField+ALInputControl.h
//  Allo
//
//  Created by apple on 2018/11/15.
//  Copyright © 2018 yizhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

BOOL al_shouldChangeCharactersIn(id _Nullable target, NSRange range, NSString * _Nullable string);
void al_textDidChange(id _Nullable target);

typedef NS_ENUM(NSInteger, ALTextControlType) {
    ALTextControlType_none, //无限制
    
    ALTextControlType_number,   //数字
    ALTextControlType_letter,   //字母（包含大小写）
    ALTextControlType_letterSmall,  //小写字母
    ALTextControlType_letterBig,    //大写字母
    ALTextControlType_number_letterSmall,   //数字+小写字母
    ALTextControlType_number_letterBig, //数字+大写字母
    ALTextControlType_number_letter,    //数字+字母
    
    ALTextControlType_excludeInvisible, //去除不可见字符（包括空格、制表符、换页符等）
    ALTextControlType_price,    //价格（小数点后最多输入两位）
};

@interface ALInputControlProfile : NSObject

/**
 限制输入长度，NSUIntegerMax表示不限制（默认不限制）
 */
@property (nonatomic, assign) NSUInteger maxLength;

/**
 限制输入的文本类型（单选，在内部其实是配置了regularStr属性）
 */
@property (nonatomic, assign) ALTextControlType textControlType;

/**
 限制输入的正则表达式字符串
 */
@property (nonatomic, copy, nullable) NSString *regularStr;

/**
 文本变化回调（observer为UITextFiled或UITextView）
 */
@property (nonatomic, copy, nullable) void(^textChanged)(id observe);

/**
 添加文本变化监听
 @param target 方法接收者
 @param action 方法（方法参数为UITextFiled或UITextView）
 */
- (void)addTargetOfTextChange:(id)target action:(SEL)action;

/**
 链式配置方法（对应属性配置）
 */
+ (ALInputControlProfile *)creat;
- (ALInputControlProfile *(^)(ALTextControlType type))set_textControlType;
- (ALInputControlProfile *(^)(NSString *regularStr))set_regularStr;
- (ALInputControlProfile *(^)(NSUInteger maxLength))set_maxLength;
- (ALInputControlProfile *(^)(void (^textChanged)(id observe)))set_textChanged;
- (ALInputControlProfile *(^)(id target, SEL action))set_targetOfTextChange;

//键盘索引和键盘类型，当设置了 textControlType 内部会自动配置，当然你也可以自己配置
@property(nonatomic) UITextAutocorrectionType autocorrectionType;
@property(nonatomic) UIKeyboardType keyboardType;

//取消输入前回调的长度判断
@property (nonatomic, assign, readonly) BOOL cancelTextLengthControlBefore;
//文本变化方法体
@property (nonatomic, strong, nullable, readonly) NSInvocation *textChangeInvocation;

@end

@interface UITextField (ALInputControl) <UITextFieldDelegate>

@property (nonatomic, strong, nullable) ALInputControlProfile *al_inputCP;

@end

@interface UITextView (ALInputControl) <UITextViewDelegate>

@property (nonatomic, strong, nullable) ALInputControlProfile *al_inputCP;

@end

