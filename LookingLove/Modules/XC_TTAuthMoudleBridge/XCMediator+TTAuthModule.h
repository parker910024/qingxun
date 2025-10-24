//
//  XCMediator+TTAuthModule.h
//  TuTu
//
//  Created by Macx on 2018/10/29.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "XCMediator.h"

#import <UIKit/UIKit.h>

@interface XCMediator (TTAuthModule)
/**
 登录注册完善资料模块
 */
- (void)ttAuthModule_authModule;

/// 获取当前登录控制器类的字符串
- (NSString *)ttAuthModule_loginViewControllerClassString;

- (void)ttAuthModule_NothingView; 
/**
 跳转到忘记密码
 
 @param isSetting 是否是设置跳转过去
 */
- (UIViewController *)ttAuthMoudle_forgetPasswordViewController:(BOOL)isSetting;

/**
 跳转到绑定手机
 
 @param dismissBlock 控制器消失的 block
 */
- (UIViewController *)ttAuthMoudle_bindPhoneAlertViewController:(id)dismissBlock;

/**
 补全用户信息
 */
- (UIViewController *)ttAuthMoudle_fullinUserViewController;
@end
