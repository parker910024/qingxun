//
//  TTAuthViewControllerCenter.m
//  TuTu
//
//  Created by Macx on 2018/10/29.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTAuthViewControllerCenter.h"
#import "TTLoginViewController.h"
#import "LLLoginViewController.h"
#import "LLQuickLoginController.h"
#import "TTOldUserRegressionView.h"

#import "BaseNavigationController.h"
#import "XCCurrentVCStackManager.h"
#import "XCHUDTool.h"
#import "TTPopup.h"

// core
#import "AuthCoreClient.h"
#import "AuthCore.h"
#import "ImLoginCoreClient.h"
#import "HttpErrorClient.h"
#import "ActivityCore.h"
#import "ActivityCoreClient.h"
#import "XCTheme.h"

//temp
#import "PLTimeUtil.h"

@interface TTAuthViewControllerCenter ()<AuthCoreClient, ImLoginCoreClient, HttpErrorClient, ActivityCoreClient>

@end

@implementation TTAuthViewControllerCenter

+ (instancetype)defaultCenter {
    static dispatch_once_t onceToken = 0;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        AddCoreClient(AuthCoreClient, self);
        AddCoreClient(ImLoginCoreClient, self);
        AddCoreClient(HttpErrorClient, self);
        AddCoreClient(ActivityCoreClient, self);
    }
    return self;
}

- (void)dealloc {
    RemoveCoreClientAll(self);
}

- (UIViewController *)toLogin {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (projectType() == ProjectType_LookingLove || projectType() == ProjectType_Planet) {
        if ([[[XCCurrentVCStackManager shareManager] getCurrentVC] isKindOfClass:[LLQuickLoginController class]]) {
            return nil;
        }
        
    if (projectType() == ProjectType_LookingLove) {
        if ([[[XCCurrentVCStackManager shareManager] getCurrentVC] isKindOfClass:[LLLoginViewController class]]) {
            return nil;
        }
    }
        
    } else {
        if ([[[XCCurrentVCStackManager shareManager] getCurrentVC] isKindOfClass:[TTLoginViewController class]]) {
            return nil;
        }
    }
    
    if ([rootViewController presentedViewController]) { //有一个被present出来的控制器 要先dismiss
        [[rootViewController presentedViewController] dismissViewControllerAnimated:YES completion:^{
            if ([[XCCurrentVCStackManager shareManager] getCurrentVC].navigationController.viewControllers.count > 1) {
                [[[XCCurrentVCStackManager shareManager] getCurrentVC].navigationController popToRootViewControllerAnimated:YES];
            }
            if ([[UIApplication sharedApplication].delegate.window.rootViewController isKindOfClass:[UITabBarController class]]) {
                
                UITabBarController *tabVC = (UITabBarController *)[UIApplication sharedApplication].delegate.window.rootViewController;
                if (tabVC.selectedViewController.navigationController) {
                    [tabVC.selectedViewController.navigationController popToRootViewControllerAnimated:YES];
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [tabVC setSelectedIndex:0];
                });
            }
            //[self toLogin];
        }];
    }else { //不是被present出来的 就有可能是rootvc或者是被push出来的 所以要判断nav是不是只有一个vc 如果有多个就pop
        
        if ([[XCCurrentVCStackManager shareManager] getCurrentVC].navigationController.viewControllers.count > 1) {
            [[[XCCurrentVCStackManager shareManager] getCurrentVC].navigationController popToRootViewControllerAnimated:YES];
        }
        if ([[UIApplication sharedApplication].delegate.window.rootViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tabVC = (UITabBarController *)[UIApplication sharedApplication].delegate.window.rootViewController;
            if (tabVC.selectedViewController) {
                if ([tabVC.selectedViewController isKindOfClass:[UINavigationController class]]) {
                    [tabVC.selectedViewController popToRootViewControllerAnimated:YES];
                } else {
                    [tabVC.selectedViewController.navigationController popToRootViewControllerAnimated:YES];
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [tabVC setSelectedIndex:0];
                });
            }
        }
    }
    
    UIViewController *loginVC = [[[self loginViewControllerClass] alloc] init];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
    
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:nav animated:YES completion:nil];
    
    return nav;
}

/// 获取当前项目登录控制器所属类
- (Class)loginViewControllerClass {
    if (projectType() == ProjectType_LookingLove ||
        projectType() == ProjectType_Planet) {
        return [LLQuickLoginController class];
    } else {
        return [TTLoginViewController class];
    }
}

#pragma mark - AuthCoreClient
- (void)onNeedLogin {
    [self toLogin];
}

- (void)onLogout {
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
    @weakify(self);
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        @strongify(self);
        [self toLogin];
    });
}

- (void)onKicked {
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    @weakify(self);
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        @strongify(self);
        
        [XCHUDTool showErrorWithMessage:@"您已被踢下线，若非正常行为，请及时修改密码"];
        [self toLogin];
    });
}

- (void)onLoginSuccess {
//    [GetCore(ActivityCore) checkOldUserRegressionActivity];
}

#pragma mark - ImLoginClient
- (void)onImLoginFailth {

    [self toLogin];
}

- (void)onImKick {
    [GetCore(AuthCore) kicked];
}

#pragma mark - ActivityCoreClient
- (void)onCheckTheOldUserRegressionWithMath:(BOOL)isMatch {
    if (!isMatch) {
        return;
    }
    
    //老用户回归，整个应用周期只展现一次
    BOOL hadShow = [[NSUserDefaults standardUserDefaults] boolForKey:TTOldUserRegressionViewShowStatusStoreKey];
    if (hadShow) {
        return;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [TTOldUserRegressionView show];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:TTOldUserRegressionViewShowStatusStoreKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    });
}

#pragma mark - HttpErrorClient
- (void)requestFailureWithMsg:(NSString *)msg {
    [XCHUDTool showErrorWithMessage:msg];
}

- (void)requestAccountWasBlockWith:(NSDictionary *)data {
    [XCHUDTool hideHUD];
    
    NSString *reason = [data objectForKey:@"reason"];
    NSString *date = [NSString stringWithFormat:@"%.0f",[[data objectForKey:@"date"]doubleValue]];
    NSString *dateDes = [PLTimeUtil getDateWithYYMMDD:date];
    NSString *msg = [NSString stringWithFormat:@"您的账号因%@被封禁\n解封时间：%@", reason, dateDes];
    
    TTAlertMessageAttributedConfig *dateAttrConfig = [[TTAlertMessageAttributedConfig alloc] init];
    dateAttrConfig.text = dateDes;
    dateAttrConfig.color = [XCTheme getTTMainColor];
    
    TTAlertConfig *config = [[TTAlertConfig alloc] init];
    config.title = @"你被封号了";
    config.message = msg;
    config.messageAttributedConfig = @[dateAttrConfig];
    
    [TTPopup alertWithConfig:config confirmHandler:^{
        
    } cancelHandler:^{
        
    }];
}

- (void)onTicketInvalid {
    [GetCore(AuthCore) logout];
}

- (void)networkDisconnect {
    
}

@end
