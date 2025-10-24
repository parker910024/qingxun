//
//  TTSetPWViewController.h
//  TuTu
//
//  Created by Macx on 2018/11/5.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "BaseUIViewController.h"

/**
    设置 支付密码 与 重置支付密码 逻辑 接口一毛一样 只是文案不一样
 **/
@class UserInfo;
@interface TTSetPWViewController : BaseUIViewController

@property (nonatomic, assign) BOOL isResetPay;//
@property (nonatomic, assign) BOOL isPayment;//NO,支付使用带有手机号验证的TTPayPwdViewController
@property (nonatomic, strong) UserInfo  *info;//

@end
