//
//  Target_TTAuthModule.h
//  TuTu
//
//  Created by Macx on 2018/10/31.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Target_TTAuthModule : NSObject

- (void)Action_TTAuthModule;

/// 获取当前登录控制器类的字符串
- (NSString *)Action_loginViewControllerClassString;

- (UIViewController *)Action_forgetPasswordViewController:(NSDictionary *)params;

- (UIViewController *)Action_bindPhoneAlertViewController:(NSDictionary *)params;

- (UIViewController *)Action_fullinUserViewController;
@end

