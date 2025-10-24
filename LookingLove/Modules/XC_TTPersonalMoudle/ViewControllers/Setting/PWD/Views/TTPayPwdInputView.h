//
//  TTPayPwdInputView.h
//  XC_TTPersonalMoudle
//
//  Created by lvjunhang on 2020/3/18.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//  支付密码输入框

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

///输入框类型
///TTPayPwdInputViewTypePwd-密码
///TTPayPwdInputViewTypeRepeatPwd-重复密码
///TTPayPwdInputViewTypeVerification-验证码
typedef NS_ENUM(NSInteger, TTPayPwdInputViewType) {
    TTPayPwdInputViewTypePwd,
    TTPayPwdInputViewTypeRepeatPwd,
    TTPayPwdInputViewTypeVerification
};

@interface TTPayPwdInputView : UIView

@property (nonatomic, assign) TTPayPwdInputViewType type;//输入框类型

@property (nonatomic, copy) void (^fetchVerificationHandler)(void);//获取验证码

/// 获取当前文本框内容
- (NSString *)contentText;

/// 验证码倒计时更新
/// @param seconds 秒数
- (void)verificationCountdownUpdate:(NSInteger)seconds;

/// 验证码倒计时结束
- (void)verificationCountdownFinish;

@end

NS_ASSUME_NONNULL_END
