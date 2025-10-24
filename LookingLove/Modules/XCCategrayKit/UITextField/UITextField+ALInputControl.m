//
//  UITextField+ALInputControl.m
//  Allo
//
//  Created by apple on 2018/11/15.
//  Copyright © 2018 yizhuan. All rights reserved.
//

#import "UITextField+ALInputControl.h"
#import <objc/runtime.h>

static const void *key_profile = &key_profile;
static const void *key_tempDelegate = &key_tempDelegate;

static BOOL judgeRegular(NSString *contentStr, NSString *regularStr) {
    NSError *error;
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:regularStr options:0 error:&error];
    if (error) {
        return YES;
    }
    NSArray *results = [regex matchesInString:contentStr options:0 range:NSMakeRange(0, contentStr.length)];
    return results.count > 0;
}

BOOL al_shouldChangeCharactersIn(id target, NSRange range, NSString *string) {
    if (!target) {
        return YES;
    }
    ALInputControlProfile *profile = objc_getAssociatedObject(target, key_profile);
    if (!profile) {
        return YES;
    }
    //计算若输入成功的字符串
    NSString *nowStr = [target valueForKey:@"text"];
    NSMutableString *resultStr = [NSMutableString stringWithString:nowStr];
    if (string.length == 0) {
        [resultStr deleteCharactersInRange:range];
    } else {
        if (range.length == 0) {
            [resultStr insertString:string atIndex:range.location];
        } else {
            [resultStr replaceCharactersInRange:range withString:string];
        }
    }
    //长度判断
    if (profile.maxLength != NSUIntegerMax) {
        if (!profile.cancelTextLengthControlBefore && resultStr.length > profile.maxLength) {
            return NO;
        }
    }
    //正则表达式匹配
    if (resultStr.length > 0) {
        if (!profile.regularStr || profile.regularStr.length <= 0) {
            return YES;
        }
        return judgeRegular(resultStr, profile.regularStr);
    }
    return YES;
}

void al_textDidChange(id target) {
    if (!target) {
        return;
    }
    ALInputControlProfile *profile = objc_getAssociatedObject(target, key_profile);
    if (!profile) {
        return;
    }
    //内容适配
    if (profile.maxLength != NSUIntegerMax && [target valueForKey:@"markedTextRange"] == nil) {
        NSString *resultText = [target valueForKey:@"text"];
        //先内容过滤
        if (profile.textControlType == ALTextControlType_excludeInvisible) {
            resultText = [[target valueForKey:@"text"] stringByReplacingOccurrencesOfString:@" " withString:@""];
        }
        //再判断长度
        if (resultText.length > profile.maxLength) {
            [target setValue:[resultText substringToIndex:profile.maxLength] forKey:@"text"];
        } else {
            [target setValue:resultText forKey:@"text"];
        }
    }
    //回调
    if (profile.textChangeInvocation) {
        [profile.textChangeInvocation setArgument:&target atIndex:2];
        [profile.textChangeInvocation invoke];
    }
    if (profile.textChanged) {
        profile.textChanged(target);
    }
}

@interface ALInputControlProfile ()

@property (nonatomic, assign) BOOL cancelTextLengthControlBefore;
@property (nonatomic, strong, nullable) NSInvocation *textChangeInvocation;

@end

@implementation ALInputControlProfile

- (instancetype)init {
    self = [super init];
    if (self) {
        self.maxLength = NSUIntegerMax;
    }
    return self;
}

- (void)addTargetOfTextChange:(id)target action:(SEL)action {
    NSInvocation *invocation = nil;
    if (target && action) {
        invocation = [NSInvocation invocationWithMethodSignature:[target methodSignatureForSelector:action]];
        invocation.target = target;
        invocation.selector = action;
    }
    self.textChangeInvocation = invocation;
}

- (void)setTextControlType:(ALTextControlType)textControlType {
    _textControlType = textControlType;
    
    switch (textControlType) {
        case ALTextControlType_none: {
            self.regularStr = @"";
            self.keyboardType = UIKeyboardTypeDefault;
            self.autocorrectionType = UITextAutocorrectionTypeDefault;
            self.cancelTextLengthControlBefore = YES;
        }
            break;
        case ALTextControlType_number: {
            self.regularStr = @"^[0-9]*$";
            self.keyboardType = UIKeyboardTypeNumberPad;
            self.autocorrectionType = UITextAutocorrectionTypeNo;
            self.cancelTextLengthControlBefore = NO;
        }
            break;
        case ALTextControlType_letter: {
            self.regularStr = @"^[a-zA-Z]*$";
            self.keyboardType = UIKeyboardTypeASCIICapable;
            self.autocorrectionType = UITextAutocorrectionTypeNo;
            self.cancelTextLengthControlBefore = NO;
        }
            break;
        case ALTextControlType_letterSmall: {
            self.regularStr = @"^[a-z]*$";
            self.keyboardType = UIKeyboardTypeASCIICapable;
            self.autocorrectionType = UITextAutocorrectionTypeNo;
            self.cancelTextLengthControlBefore = NO;
        }
            break;
        case ALTextControlType_letterBig: {
            self.regularStr = @"^[A-Z]*$";
            self.keyboardType = UIKeyboardTypeASCIICapable;
            self.autocorrectionType = UITextAutocorrectionTypeNo;
            self.cancelTextLengthControlBefore = NO;
        }
            break;
        case ALTextControlType_number_letter: {
            self.regularStr = @"^[0-9a-zA-Z]*$";
            self.keyboardType = UIKeyboardTypeASCIICapable;
            self.autocorrectionType = UITextAutocorrectionTypeNo;
            self.cancelTextLengthControlBefore = NO;
        }
            break;
        case ALTextControlType_number_letterSmall: {
            self.regularStr = @"^[0-9a-z]*$";
            self.keyboardType = UIKeyboardTypeASCIICapable;
            self.autocorrectionType = UITextAutocorrectionTypeNo;
            self.cancelTextLengthControlBefore = NO;
        }
            break;
        case ALTextControlType_number_letterBig: {
            self.regularStr = @"^[0-9A-Z]*$";
            self.keyboardType = UIKeyboardTypeASCIICapable;
            self.autocorrectionType = UITextAutocorrectionTypeNo;
            self.cancelTextLengthControlBefore = NO;
        }
            break;
        case ALTextControlType_price: {
            NSString *tempStr = self.maxLength == NSUIntegerMax?@"":[NSString stringWithFormat:@"%ld", (unsigned long)self.maxLength];
            self.regularStr = [NSString stringWithFormat:@"^(([1-9]\\d{0,%@})|0)(\\.\\d{0,2})?$", tempStr];
            self.keyboardType = UIKeyboardTypeDecimalPad;
            self.autocorrectionType = UITextAutocorrectionTypeNo;
            self.cancelTextLengthControlBefore = NO;
        }
            break;
        case ALTextControlType_excludeInvisible: {
            self.regularStr = @"";
            self.keyboardType = UIKeyboardTypeDefault;
            self.autocorrectionType = UITextAutocorrectionTypeDefault;
            self.cancelTextLengthControlBefore = YES;
        }
            break;
        default:
            break;
    }
}

+ (ALInputControlProfile *)creat {
    ALInputControlProfile *profile = [ALInputControlProfile new];
    return profile;
}

- (ALInputControlProfile * _Nonnull (^)(ALTextControlType))set_textControlType {
    return ^ALInputControlProfile* (ALTextControlType type) {
        self.textControlType = type;
        return self;
    };
}

- (ALInputControlProfile * _Nonnull (^)(NSString * _Nonnull))set_regularStr {
    return ^ALInputControlProfile* (NSString *regularStr) {
        self.regularStr = regularStr;
        return self;
    };
}

- (ALInputControlProfile * _Nonnull (^)(NSUInteger))set_maxLength {
    return ^ALInputControlProfile* (NSUInteger maxLength) {
        self.maxLength = maxLength;
        return self;
    };
}

- (ALInputControlProfile * _Nonnull (^)(void (^ _Nonnull)(id _Nonnull)))set_textChanged {
    return ^ALInputControlProfile *(void (^block)(id observe)) {
        if (block) {
            self.textChanged = ^(id observe) {
                block(observe);
            };
        }
        return self;
    };
}

- (ALInputControlProfile * _Nonnull (^)(id _Nonnull, SEL _Nonnull))set_targetOfTextChange {
    return ^ALInputControlProfile *(id target, SEL action) {
        [self addTargetOfTextChange:target action:action];
        return self;
    };
}

@end

@interface ALInputControlTempDelegate : NSObject <UITextFieldDelegate>

@property (nonatomic, weak) id delegate_inside;
@property (nonatomic, weak) id delegate_outside;
@property (nonatomic, strong) Protocol *protocol;

@end

@implementation ALInputControlTempDelegate

- (BOOL)respondsToSelector:(SEL)aSelector {
    struct objc_method_description des = protocol_getMethodDescription(self.protocol, aSelector, NO, YES);
    if (des.types == NULL) {
        return [super respondsToSelector:aSelector];
    }
    if ([self.delegate_inside respondsToSelector:aSelector] || [self.delegate_outside respondsToSelector:aSelector]) {
        return YES;
    }
    return [super respondsToSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    SEL sel = anInvocation.selector;
    BOOL isResponds = NO;
    if ([self.delegate_inside respondsToSelector:sel]) {
        isResponds = YES;
        [anInvocation invokeWithTarget:self.delegate_inside];
    }
    if ([self.delegate_outside respondsToSelector:sel]) {
        isResponds = YES;
        [anInvocation invokeWithTarget:self.delegate_outside];
    }
    if (!isResponds) {
        [self doesNotRecognizeSelector:sel];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *sig_inside = [self.delegate_inside methodSignatureForSelector:aSelector];
    NSMethodSignature *sig_outside = [self.delegate_outside methodSignatureForSelector:aSelector];
    NSMethodSignature *result_sig = sig_inside?:sig_outside?:nil;
    return result_sig;
}

- (Protocol *)protocol {
    if (!_protocol) {
        if ([self.delegate_inside isKindOfClass:UITextField.self]) {
            _protocol = objc_getProtocol("UITextFieldDelegate");
        }
    }
    return _protocol;
}

@end

@implementation UITextField (ALInputControl)
#pragma mark insert logic to selector--setDelegate:

+ (void)load {
    if ([NSStringFromClass(self) isEqualToString:@"UITextField"]) {
        Method m1 = class_getInstanceMethod(self, @selector(setDelegate:));
        Method m2 = class_getInstanceMethod(self, @selector(customSetDelegate:));
        if (m1 && m2) {
            method_exchangeImplementations(m1, m2);
        }
    }
}

- (void)customSetDelegate:(id)delegate {
    @synchronized(self) {
        if (objc_getAssociatedObject(self, key_profile)) {
            ALInputControlTempDelegate *tempDelegate = [ALInputControlTempDelegate new];
            tempDelegate.delegate_inside = self;
            if (self.delegate && delegate == self) {
                tempDelegate.delegate_outside = self.delegate;
            } else {
                tempDelegate.delegate_outside = delegate;
            }
            [self customSetDelegate:tempDelegate];
            objc_setAssociatedObject(self, key_tempDelegate, tempDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        } else {
            [self customSetDelegate:delegate];
        }
    }
}

#pragma mark - getters and setters

- (void)setAl_inputCP:(ALInputControlProfile *)al_inputCP {
    @synchronized(self) {
        if (al_inputCP && [al_inputCP isKindOfClass:ALInputControlProfile.self]) {
            objc_setAssociatedObject(self, key_profile, al_inputCP, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            
            self.delegate = self;
            self.keyboardType = al_inputCP.keyboardType;
            self.autocorrectionType = al_inputCP.autocorrectionType;
            al_inputCP.textChangeInvocation || al_inputCP.textChanged ? [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents : UIControlEventEditingChanged]:nil;
        } else {
            objc_setAssociatedObject(self, key_profile, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
}

- (ALInputControlProfile *)al_inputCP {
    return objc_getAssociatedObject(self, key_profile);
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return al_shouldChangeCharactersIn(textField, range, string);
}
- (void)textFieldDidChange:(UITextField *)textField {
    al_textDidChange(textField);
}

@end

@implementation UITextView (ALInputControl)

#pragma mark - getters and setters

- (void)setAl_inputCP:(ALInputControlProfile *)al_inputCP {
    @synchronized(self) {
        if (al_inputCP && [al_inputCP isKindOfClass:ALInputControlProfile.self]) {
            objc_setAssociatedObject(self, key_profile, al_inputCP, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            
            self.delegate = self;
            self.keyboardType = al_inputCP.keyboardType;
            self.autocorrectionType = al_inputCP.autocorrectionType;
        } else {
            objc_setAssociatedObject(self, key_profile, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
}

- (ALInputControlProfile *)al_inputCP {
    return objc_getAssociatedObject(self, key_profile);
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return al_shouldChangeCharactersIn(textView, range, text);
}
- (void)textViewDidChange:(UITextView *)textView {
    al_textDidChange(textView);
}

@end
