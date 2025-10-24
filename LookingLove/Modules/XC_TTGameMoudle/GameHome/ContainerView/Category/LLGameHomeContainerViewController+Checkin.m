//
//  LLGameHomeContainerViewController+Checkin.m
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2019/7/25.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "LLGameHomeContainerViewController+Checkin.h"
#import "LLGameHomeContainerViewController+PopularTicket.h"

#import "TTDiscoverCheckInMissionNotiConst.h"

#import "CheckinCoreClient.h"
#import "CheckinCore.h"
#import "AuthCore.h"
#import "UserCore.h"

#import "XCHUDTool.h"
#import "TTStatisticsService.h"
#import "XCCurrentVCStackManager.h"

#import "LLTeenagerModelAlertView.h"
#import "ClientCore.h"

#import <YYCache/YYCache.h>

static NSString *const kCheckinCacheNameKey = @"kCheckinCacheNameKey";
static NSString *const kCheckinStoreUidsKey = @"kCheckinStoreUidsKey";

@implementation LLGameHomeContainerViewController (Checkin)

#pragma mark - CheckinCoreClient
///签到详情接口响应
- (void)responseCheckinSignDetail:(CheckinSignDetail *)data errorCode:(NSNumber *)code msg:(NSString *)msg {
    
    self.checkinView.checkinButton.userInteractionEnabled = YES;
    
    ///确保是当前控制器调用的接口
    if (self.navigationController.viewControllers.count != 1) {
        return;
    }
    
    /// When Network Error
    if (code == nil && msg.length > 0) {
        [XCHUDTool showErrorWithMessage:@"网络出现问题" inView:self.view];
        return;
    }
    
    /// When Servers Send Error
    if (code != nil) {
        [XCHUDTool showErrorWithMessage:msg ?: @"获取数据出现问题" inView:self.view];
        return;
    }
    
    self.checkinView.signDetail = data;

    if (data.needSignDialog) {
        [self showCheckinView];
    } else {
        [self requestPopularTicket];
    }
}

///签到接口响应
- (void)responseCheckinSign:(CheckinSign *)data errorCode:(NSNumber *)code msg:(NSString *)msg {
    
    self.checkinView.checkinButton.userInteractionEnabled = YES;
    
    ///确保是当前控制器调用的接口
    if (self.navigationController.viewControllers.count != 1) {
        return;
    }
    
    /// When Network Error
    if (code == nil && msg.length > 0) {
        [XCHUDTool showErrorWithMessage:@"网络出现问题"];
        return;
    }
    
    /// When Servers Send Error
    if (code != nil) {
        [XCHUDTool showErrorWithMessage:msg ?: @"获取数据出现问题"];
        return;
    }
    
    self.checkinView.checkinButton.userInteractionEnabled = NO;
    
    [self requestSignDetail];
    
    ///签到完将金币个数累加上去
    [self.checkinView addCoin:data.signGoldNum];
    
    [TTStatisticsService trackEvent:TTStatisticsServiceEventSignSuccess
                      eventDescribe:@"弹窗签到成功"];
    
    NSString *toast = [NSString stringWithFormat:@"签到成功，奖金池已增加%ld金币", data.signGoldNum];
    [XCHUDTool showSuccessWithMessage:toast];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TTDiscoverCheckInMissonRefreshNoti object:nil];
}

#pragma mark - Public
/**
 显示签到页面
 */
- (void)showCheckinView {
    //这里特指获取AppDelegate的window
    UIWindow *appDelegateWindow = UIApplication.sharedApplication.delegate.window;
    //当前显示的window
    UIWindow *currentPresentingWindow = UIApplication.sharedApplication.keyWindow;
    //是否当前显示的window就是‘AppDelegate的window’
    BOOL showingAppDelegateWindow = currentPresentingWindow == appDelegateWindow;
    //是否当前显示的页面是这个类的控制器
    BOOL presentingCurrentPage = [[[XCCurrentVCStackManager shareManager] getCurrentVC] isKindOfClass:self.class];
    
    //拦截，显示的是主控制器的window，但页面却不是当前发起弹出的类（self.class）
    //可能情况：网络回调慢，导致弹窗前用户切换到其他页面还弹出签到框
    if (showingAppDelegateWindow && !presentingCurrentPage) {
        return;
    }

    [TTPopup popupView:self.checkinView style:TTPopupStyleAlert];
}

/**
 移除签到页面
 */
- (void)dismissCheckinView {
    // 缩小返回的动画
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"position"];
    anima.toValue = [NSValue valueWithCGPoint:CGPointMake(KScreenWidth - 70, kNavigationHeight - 20)];
    anima.fromValue = [NSValue valueWithCGPoint:self.view.center];
    //动画持续时间
    anima.duration = 0.6;
    
    //动画填充模式
    anima.fillMode = kCAFillModeForwards;
    
    //动画完成不删除
    anima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    //xcode8.0之后需要遵守代理协议
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scale.toValue = @(0.01);
    scale.fromValue = @(1);
    scale.duration = 0.5;
    scale.fillMode = kCAFillModeForwards;
    scale.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[anima, scale];
    group.duration = 1;
    //把动画添加到要作用的Layer上面
    [self.checkinView.layer addAnimation:group forKey:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [TTPopup dismiss];
        [self requestPopularTicket];
    });
}

#pragma mark request
/**
 请求签到详情接口
 */
- (void)requestSignDetail {
    
    if (![GetCore(AuthCore) isLogin]) {
        return;
    }
    
//    if (![self shouldRequestCheckinDetail]) {
//        return;
//    }
    
    YYCache *cache = [YYCache cacheWithName:kCheckinCacheNameKey];
    NSMutableSet<NSString *> *uids = (NSMutableSet *)[cache objectForKey:kCheckinStoreUidsKey];
    if (!uids) {
        uids = [NSMutableSet set];
    }
    
    [uids addObject:GetCore(AuthCore).getUid];
    [cache setObject:uids forKey:kCheckinStoreUidsKey];
    [cache setObject:[NSDate date] forKey:GetCore(AuthCore).getUid];
        
    [GetCore(UserCore) getUserInfo:[GetCore(AuthCore)getUid].userIDValue refresh:YES success:^(UserInfo *info) {
        
        //如果没有完善用户信息，不请求签到详情
        if (info == nil || info.nick.length <= 0 || info.avatar.length <= 0) {
            return;
        }
        
        [GetCore(CheckinCore) requestCheckinSignDetail];
        
    } failure:^(NSError *error) {
        
    }];
}

/// 判断是否需要请求签到弹窗
/// 同一账户一天只请求一次
- (BOOL)shouldRequestCheckinDetail {
    if (![GetCore(AuthCore) isLogin]) {
        return NO;
    }
    
    YYCache *cache = [YYCache cacheWithName:kCheckinCacheNameKey];
    NSMutableSet<NSString *> *uids = (NSMutableSet *)[cache objectForKey:kCheckinStoreUidsKey];
    
    BOOL history = [uids containsObject:GetCore(AuthCore).getUid];
    if (history) {
        NSDate *date = (NSDate *)[cache objectForKey:GetCore(AuthCore).getUid];
        BOOL today = [[NSCalendar currentCalendar] isDateInToday:date];
        return !today;
    }
    return YES;
}

@end
