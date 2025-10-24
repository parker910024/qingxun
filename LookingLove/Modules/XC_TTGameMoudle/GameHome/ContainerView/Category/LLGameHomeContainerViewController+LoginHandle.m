//
//  LLGameHomeContainerViewController+LoginHandle.m
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2019/7/25.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "LLGameHomeContainerViewController+LoginHandle.h"

#import "LLGameHomeContainerViewController+Checkin.h"
#import "LLGameHomeContainerViewController+TeenagerModel.h"
#import "LLGameHomeContainerViewController+PopularTicket.h"

#import "LLFullinUserViewController.h"
#import "XCMediator+TTAuthModule.h"
#import "LLBindPhonetAlertController.h"

#import "AuthCore.h"
#import "AuthCoreClient.h"
#import "UserCore.h"
#import "ClientCore.h"

#import "XCCurrentVCStackManager.h"
#import "BaseNavigationController.h"

static NSString *const kSynUserRanKKey = @"kLLSynUserRanKKey";

@implementation LLGameHomeContainerViewController (LoginHandle)

#pragma mark - UserCoreClient
/**
 当前用户信息需要完善
 
 @discussion 获取用户信息发现需要完善时会发出此通知
 两种情况：一、正常注册，二、没完善信息前异常退出然后重启应用
 注意，此通知不处理手机号绑定判断
 */
- (void)onCurrentUserInfoNeedComplete:(UserID)uid {
    [self updateUserInfoCheck];
}

#pragma mark - AuthCoreClient
/**
 登陆界面消失后的通知
 
 @discussion 此通知试图做两个功能，即登录完成后判断
 当前账号是否完善了用户信息和手机号绑定，优先判断前者
 */
- (void)loginViewControllerDismiss {
    [self updateUserInfoCheck];
}

- (void)onLoginSuccess {
    
    [self reloadDataWhenLoadFail];
    // ‘登录页’和‘自动登录’都会触发 onLoginSuccess
    // 如果是登录页触发，理论上此时页面应该是停留在登录页，此时请求签到详情 requestSignDetail
    // 可能导致登录页尝试弹出签到弹窗（该情况不被允许，已作忽略处理）
    // 所以，此处只在显示当前控制器时请求（即自动登录的情况）
    // ‘登录页’的触发在 loginViewControllerDismiss 流程里处理
    [GetCore(AuthCore) loveRoomLoginDeleteUserData];

    NSString *loginVCClsStr = [[XCMediator sharedInstance] ttAuthModule_loginViewControllerClassString];
    //是否当前显示的页面是登录控制器
    BOOL presentingLoginPage = [[[XCCurrentVCStackManager shareManager] getCurrentVC] isKindOfClass:NSClassFromString(loginVCClsStr)];
    if (!presentingLoginPage) {
        // 获取签到详情
        [self requestSignDetail];
        // 青少年弹窗
        [self needOrNotShowTeenagerView];
    }
}

// 完善用户信息后发出通知
- (void)fullinUserInfoSuccess {

    UserInfo *info = [GetCore(UserCore) getUserInfoInDB:[GetCore(AuthCore).getUid userIDValue]];
    // 如果没有绑定手机号，去绑定
    if (!info.isBindPhone) {
        if ([[[XCCurrentVCStackManager shareManager] getCurrentVC] isKindOfClass:LLBindPhonetAlertController.class]) {
            return;
        }
        [self showBindPhoneVC];
        return;
    }
    
    // 云同步弹窗
    [self showSyncToCloudAlert];
    // 获取签到详情
    [self requestSignDetail];
    // 青少年弹窗
    [self needOrNotShowTeenagerView];
}

#pragma mark - private method
/**
 检查是否更新用户信息、手机号
 
 @discussion ‘登录页消失’和‘获取用户信息判断到需要完善’都会调用此方法
 所以登录页消失时会调用两次此方法
 loginViewControllerDismiss和onCurrentUserInfoNeedComplete所做工作有一部分重叠
 未来可以考虑 onCurrentUserInfoNeedComplete 同时判断‘手机号完善’和‘用户信息完善’
 则可考虑将loginViewControllerDismiss移除（移除要考虑TTGameViewController.onLoginSuccess的注释）
 */
- (void)updateUserInfoCheck {
    
    //防止重复弹出完善资料页面
    if ([[[XCCurrentVCStackManager shareManager] getCurrentVC] isKindOfClass:LLFullinUserViewController.class]) {
        return;
    }
    if ([[[XCCurrentVCStackManager shareManager] getCurrentVC] isKindOfClass:LLBindPhonetAlertController.class]) {
        return;
    }
    
    UserID uid = [GetCore(AuthCore) getUid].userIDValue;
    [GetCore(UserCore) getUserInfo:uid refresh:YES success:^(UserInfo *info) {
        
        // 如果没有完善用户信息，去完善
        if (info == nil || info.nick.length <= 0 || info.avatar.length <= 0) {
            
            //防止重复弹出完善资料页面
            if ([[[XCCurrentVCStackManager shareManager] getCurrentVC] isKindOfClass:LLFullinUserViewController.class]) {
                return;
            }
            
            UIViewController *authVC = [[XCMediator sharedInstance] ttAuthMoudle_fullinUserViewController];
            BaseNavigationController *vc = [[BaseNavigationController alloc] initWithRootViewController:authVC];
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            [[XCCurrentVCStackManager shareManager].getCurrentVC presentViewController:vc animated:YES completion:nil];
            return;
        }
        
        // 如果没有绑定手机号，去绑定
        if (!info.isBindPhone) {
            if ([[[XCCurrentVCStackManager shareManager] getCurrentVC] isKindOfClass:LLBindPhonetAlertController.class]) {
                return;
            }
            [self showBindPhoneVC];
            return;
        }

        // 云同步弹窗
        [self showSyncToCloudAlert];
        
        // 获取签到详情
        [self requestSignDetail];
        
        // 青少年弹窗
        [self needOrNotShowTeenagerView];
        
    } failure:^(NSError *error) {
    }];
}

- (void)showBindPhoneVC {
    @weakify(self)
    UIViewController *bindVC = [[XCMediator sharedInstance] ttAuthMoudle_bindPhoneAlertViewController:^{
        
        @strongify(self)
        // 云同步弹窗
        [self showSyncToCloudAlert];
        // 获取签到详情
        [self requestSignDetail];
        // 青少年弹窗
        [self needOrNotShowTeenagerView];
    }];
    [self.navigationController pushViewController:bindVC animated:YES];
}

/**
 显示分数同步弹窗
 @discussion 只显示一次，出现首页后弹出，新用户在完善资料后弹出
 */
- (void)showSyncToCloudAlert {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL isShow = [defaults boolForKey:kSynUserRanKKey];
    if (!isShow) {
        
        [defaults setBool:YES forKey:kSynUserRanKKey];
        [defaults synchronize];
        
        NSString *msg = @"将您的分数同步到云端便于查看您在平台的排行榜排名，是否同意将您的分数同步到云端？";
        [TTPopup alertWithMessage:msg confirmHandler:^{
        } cancelHandler:^{
        }];
    }
}

@end
