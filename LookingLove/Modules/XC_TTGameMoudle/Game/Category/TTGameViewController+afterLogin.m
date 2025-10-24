//
//  TTGameViewController+afterLogin.m
//  XC_TTGameMoudle
//
//  Created by JarvisZeng on 2019/4/23.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTGameViewController+afterLogin.h"
#import "AuthCore.h"
#import "UserCore.h"
#import "XCMediator+TTAuthModule.h"
#import "XCCurrentVCStackManager.h"
#import "BaseNavigationController.h"
#import "AuthCoreClient.h"

#import "TTPopup.h"

#import "TTFullinUserViewController.h"

#import "TTGameViewController+Request.h"

static NSString *const kFirstLaunchHomeKey = @"kFirstLaunchHomeKey";
static NSString *const kSynUserRanKKey = @"kSynUserRanKKey";

@implementation TTGameViewController (afterLogin)

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

// 完善用户信息后发出通知
- (void)fullinUserInfoSuccess {
    // 显示引导
//    [self showGuldeView];
    
    // 获取签到详情
    [self requestSignDetail];
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
    if ([[[XCCurrentVCStackManager shareManager] getCurrentVC] isKindOfClass:TTFullinUserViewController.class]) {
        return;
    }
    
    UserID uid = [GetCore(AuthCore) getUid].userIDValue;
    [GetCore(UserCore) getUserInfo:uid refresh:YES success:^(UserInfo *info) {
        
        // 如果没有完善用户信息，去完善
        if (info == nil || info.nick.length <= 0 || info.avatar.length <= 0) {
            UIViewController *authVC = [[XCMediator sharedInstance] ttAuthMoudle_fullinUserViewController];
            BaseNavigationController *vc = [[BaseNavigationController alloc] initWithRootViewController:authVC];
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            [[XCCurrentVCStackManager shareManager].getCurrentVC presentViewController:vc animated:YES completion:nil];
            return;
        }
        
        // 如果没有绑定手机号，去绑定
        if (!info.isBindPhone) {
            [self showBindPhoneVC];
            return;
        }
        
        // 显示引导
//        [self showGuldeView];
        
        // 获取签到详情
        [self requestSignDetail];
        
    } failure:^(NSError *error) {
    }];
}

- (void)showBindPhoneVC {
    @weakify(self)
    UIViewController *bindVC = [[XCMediator sharedInstance] ttAuthMoudle_bindPhoneAlertViewController:^{
        
        @strongify(self)
        
        // 显示引导
//        [self showGuldeView];
        
        // 获取签到详情
        [self requestSignDetail];
    }];
    [self.navigationController pushViewController:bindVC animated:YES];
}


- (void)showGuldeView {
    BOOL isFirstLaunch = [[NSUserDefaults standardUserDefaults] boolForKey:kFirstLaunchHomeKey];
    if (!isFirstLaunch) {
        UIImageView *guildMaskView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        if (statusbarHeight > 20) {
            guildMaskView.image = [UIImage imageNamed:@"home_guild_iPhone x"];
        } else {
            guildMaskView.image = [UIImage imageNamed:@"home_guild"];
            
        }
        guildMaskView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskViewDismissHandler)];
        [guildMaskView addGestureRecognizer:tap];
        [[UIApplication sharedApplication].keyWindow addSubview:guildMaskView];
        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:guildMaskView];
        self.maskGuildView = guildMaskView;
    }
}

- (void)maskViewDismissHandler {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kFirstLaunchHomeKey];
    
    [UIView transitionWithView:self.view duration:0.7 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.maskGuildView.transform = CGAffineTransformMakeScale(0.0, 0.0);
    } completion:^(BOOL finished) {
        [self.maskGuildView removeFromSuperview];
    }];
    
    NSUserDefaults *defaults =  [NSUserDefaults standardUserDefaults];
    BOOL isShow = [defaults boolForKey:kSynUserRanKKey];
    if (!isShow) {
        
        NSString *msg = @"将您的分数同步到云端便于查看您在平台的排行榜排名，是否同意将您的分数同步到云端？";
        [TTPopup alertWithMessage:msg confirmHandler:^{
            [defaults setBool:YES forKey:kSynUserRanKKey];
            [defaults synchronize];
        } cancelHandler:^{
            [defaults setBool:YES forKey:kSynUserRanKKey];
            [defaults synchronize];
        }];
    }
}

@end
