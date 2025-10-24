//
//  TTEnterPayPWViewController.h
//  TuTu
//
//  Created by Macx on 2018/11/8.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "BaseUIViewController.h"
/*
    输入密码
 */

@protocol TTEnterPayPWViewControllerDelegate<NSObject>

- (void)inputPasswordEnd:(NSString *)password;
- (void)gotoForgetPasswordVC;

@end
@interface TTEnterPayPWViewController : BaseUIViewController
@property (nonatomic, weak) id<TTEnterPayPWViewControllerDelegate>  delegate;//

@end
