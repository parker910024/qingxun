//
//  Target_TTAuthModule.m
//  TuTu
//
//  Created by Macx on 2018/10/31.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "Target_TTAuthModule.h"

#import "TTAuthViewControllerCenter.h"
#import "AuthCore.h"
#import "TTForgetPasswordViewController.h"
#import "LLForgetPasswordViewController.h"
#import "LLFullinUserViewController.h"
#import "TTFullinUserViewController.h"
#import "TTBindPhonetAlertController.h"
#import "LLBindPhonetAlertController.h"
#import "XCConst.h"
@implementation Target_TTAuthModule
- (void)Action_TTAuthModule {
    [TTAuthViewControllerCenter defaultCenter];
    [GetCore(AuthCore) autoLogin];
}

- (NSString *)Action_loginViewControllerClassString {
    Class cls = [[TTAuthViewControllerCenter defaultCenter] loginViewControllerClass];
    return NSStringFromClass(cls);
}

- (UIViewController *)Action_forgetPasswordViewController:(NSDictionary *)params {
    if (projectType() == ProjectType_LookingLove || projectType() == ProjectType_Planet) {
        LLForgetPasswordViewController *vc = [[LLForgetPasswordViewController alloc] init];
        vc.isSetting = [[params objectForKey:@"isSetting"] isEqualToString:@"1"];
        return vc;
    } else {
        TTForgetPasswordViewController *vc = [[TTForgetPasswordViewController alloc] init];
        vc.isSetting = [[params objectForKey:@"isSetting"] isEqualToString:@"1"];
        return vc;
    }
}

- (UIViewController *)Action_bindPhoneAlertViewController:(NSDictionary *)params {
    if (projectType() == ProjectType_LookingLove || projectType() == ProjectType_Planet) {
        LLBindPhonetAlertController *vc = [[LLBindPhonetAlertController alloc] init];
        if ([params.allKeys containsObject:@"block"]) {
            vc.dismissBlcok = params[@"block"];
        }
        return vc;
    } else {
        TTBindPhonetAlertController *vc = [[TTBindPhonetAlertController alloc] init];
        if ([params.allKeys containsObject:@"block"]) {
            vc.dismissBlcok = params[@"block"];
        }
        return vc;
    }
}

- (UIViewController *)Action_fullinUserViewController {
    if (projectType() == ProjectType_LookingLove || projectType() == ProjectType_Planet) {
        LLFullinUserViewController *vc = [[LLFullinUserViewController alloc] init];
        return vc;
    } else {
        TTFullinUserViewController *vc = [[TTFullinUserViewController alloc] init];
        return vc;
    }
}

@end
