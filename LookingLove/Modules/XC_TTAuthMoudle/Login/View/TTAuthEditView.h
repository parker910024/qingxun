//
//  TTAuthEditView.h
//  TuTu
//
//  Created by Macx on 2018/10/30.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    TTAuthEditViewTypeNormal, // 普通类型
    TTAuthEditViewTypeSms,    // 短信验证码类型
    TTAuthEditViewTypeCaptchaImage,    // 图片验证码类型
} TTAuthEditViewType;

typedef void(^RightButtonDidClickBlcok)(UIButton *);
@interface TTAuthEditView : UIView
/** textField */
@property (nonatomic, strong, readonly) UITextField *textField;
/** 验证码 */
@property (nonatomic, strong, readonly) UIButton *authCodeButton;


/** 类型 */
@property (nonatomic, assign) TTAuthEditViewType type;
/** 右边按钮点击的回调 && 验证码按钮点击的回调 */
@property (nonatomic, copy) RightButtonDidClickBlcok rightButtonDidClickBlcok;

/**
 初始化方法
 
 @param placeholder 占位文字
 @return 对象
 */
- (instancetype)initWithPlaceholder:(NSString *)placeholder;

/**
 更新图片验证码

 @param captchaImage 图片
 */
- (void)updateCaptchaImage:(UIImage *)captchaImage;
@end
