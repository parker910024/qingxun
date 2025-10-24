//
//  XCMediator+TTAuthModule.m
//  TuTu
//
//  Created by Macx on 2018/10/29.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "XCMediator+TTAuthModule.h"

@implementation XCMediator (TTAuthModule)

- (void)ttAuthModule_authModule {
    [self performTarget:@"TTAuthModule" action:@"TTAuthModule" params:nil shouldCacheTarget:NO];
}

/// 获取当前登录控制器类的字符串
- (NSString *)ttAuthModule_loginViewControllerClassString {
    
    return [self performTarget:@"TTAuthModule" action:@"loginViewControllerClassString" params:nil shouldCacheTarget:NO];
}

- (UIViewController *)ttAuthMoudle_forgetPasswordViewController:(BOOL)isSetting {
    NSString * temp = (isSetting == YES) ? @"1":@"0";
    NSDictionary * params = @{@"isSetting":temp};
    return [self performTarget:@"TTAuthModule" action:@"forgetPasswordViewController" params:params shouldCacheTarget:NO];
}

- (UIViewController *)ttAuthMoudle_bindPhoneAlertViewController:(id)dismissBlock {
    NSDictionary *params = @{@"block" : dismissBlock};
    return [self performTarget:@"TTAuthModule" action:@"bindPhoneAlertViewController" params:params shouldCacheTarget:NO];
}

- (UIViewController *)ttAuthMoudle_fullinUserViewController {
    return [self performTarget:@"TTAuthModule" action:@"fullinUserViewController" params:nil shouldCacheTarget:NO];
}
- (void)ttAuthModule_NothingView {
    
}
@end
