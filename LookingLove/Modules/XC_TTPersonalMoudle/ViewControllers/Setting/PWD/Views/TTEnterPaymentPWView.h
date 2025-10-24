//
//  TTEnterPaymentPWView.h
//  TuTu
//
//  Created by Macx on 2018/11/8.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TTEnterPaymentPWViewDelegate<NSObject>

- (void)closePassword;
- (void)forgetPassword;

@end
@interface TTEnterPaymentPWView : UIView

@property (nonatomic, weak) id<TTEnterPaymentPWViewDelegate>  delegate;//
@property (nonatomic, assign) NSUInteger inputLength;//当前输入密码的长度

@end
