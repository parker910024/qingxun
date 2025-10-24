//
//  XCMediator+TTPersonalMoudleBridge.m
//  XC_TTPersonalMoudleBridge
//
//  Created by KevinWang on 2019/4/9.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "XCMediator+TTPersonalMoudleBridge.h"

@implementation XCMediator (TTPersonalMoudleBridge)


/**
 兔兔 我的
 
 @return 我的页面
 */
- (UIViewController *)ttPersonalModule_MineView {
    return [self
            performTarget:@"TTPersonalModule" action:@"mineViewController" params:nil shouldCacheTarget:YES];
}


/**
 兔兔 我的
 
 @return 个人主页
 */
- (UIViewController *)ttPersonalModule_personalViewController:(long long)uid {
    return [self
            performTarget:@"TTPersonalModule" action:@"personalViewController" params:@{@"uid":@(uid)} shouldCacheTarget:YES];
}

/** 我的金币 */
- (UIViewController *)ttPersonalModule_goldCoinController {
    return [self
            performTarget:@"TTPersonalModule" action:@"diamondViewController" params:nil
            shouldCacheTarget:YES];
}

/** 我的钻石 */
- (UIViewController *)ttPersonalModule_diamondViewController {
    return [self
            performTarget:@"TTPersonalModule" action:@"goldCoinViewController" params:nil
            shouldCacheTarget:YES];
}


/**
 兔兔 充值
 
 @return 我的页面
 */
- (UIViewController *)ttPersonalModule_rechargeController {
    return [self
            performTarget:@"TTPersonalModule" action:@"rechargeController" params:nil shouldCacheTarget:YES];
    
}


/**
 兔兔 红包提现页面
 */
- (UIViewController *)ttPersonalModule_redDrawalsViewController {
    NSDictionary *params = @{@"outputType" : @1};
    return [self
            performTarget:@"TTPersonalModule" action:@"redDrawalsViewController" params:params
            shouldCacheTarget:YES];
    
}

- (UIViewController *)ttPersonalModule_billListViewController:(NSUInteger)type {
    NSDictionary *params = @{@"type" : @(type)};
    return [self performTarget:@"TTPersonalModule" action:@"TTBillListViewController" params:params shouldCacheTarget:YES];
}

/**
 兔兔 提现页面
 */
- (UIViewController *)ttPersonalModule_drawalsViewController {
    NSDictionary *params = @{@"outputType" : @0};
    return [self
            performTarget:@"TTPersonalModule" action:@"drawalsiewController" params:params
            shouldCacheTarget:YES];
}

/**
 
 兔兔 装扮商城
 
 @param uid 用户uid
 @param index  0.头饰  1 座驾
 @return 装扮商城
 */
- (UIViewController *)ttPersonalModule_DressUpShopViewControllerWithUid:(long long)uid index:(int)index {
    NSDictionary *params = @{@"userID":@(uid),@"place":@(index)};
    
    return [self
            performTarget:@"TTPersonalModule" action:@"dressUpShopViewController" params:params shouldCacheTarget:YES];
}


/**
 兔兔 我的装扮
 
 @param index  0. 头饰  1. 车库
 @return 我的装扮
 */
- (UIViewController *)ttPersonalModule_MyDressUpController:(int)index {
    NSDictionary *params = @{@"place":@(index)};
    
    return [self
            performTarget:@"TTPersonalModule" action:@"mineDressUpViewController" params:params shouldCacheTarget:YES];
    
}

- (UIViewController *)ttPersonalModule_BindingPhoneController:(int)type userInfo:(NSDictionary *)userInfo {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(type) forKey:@"type"];
    [params setObject:userInfo forKey:@"userInfo"];
    return [self performTarget:@"TTPersonalModule" action:@"BindingPhoneController" params:params shouldCacheTarget:YES];
}


/**
 兔兔 设置支付密码
 
 @return 设置支付密码页面
 @property (nonatomic, assign) BOOL isResetPay;//
 @property (nonatomic, assign) BOOL isPayment;//
 @property (nonatomic, strong) UserInfo  *info;//
 */

- (UIViewController *)ttPersonalModule_setPWViewController:(BOOL)isResetPay isPayment:(BOOL)isPayment userInfo:(NSDictionary *)userInfo  {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(isResetPay) forKey:@"isResetPay"];
    [params setObject:@(isPayment) forKey:@"isPayment"];
    [params setObject:userInfo forKey:@"userInfo"];
    return [self performTarget:@"TTPersonalModule" action:@"TTSetPWViewController" params:params shouldCacheTarget:YES];
}

/**
 兔兔 推荐位
 
 @return 推荐位页面
 */
- (UIViewController *)ttPersonalModule_openMyRecommendCardViewController {
    return [self performTarget:@"TTPersonalModule" action:@"TTRecommendContainViewController" params:nil shouldCacheTarget:NO];
}

/**
 兔兔 绑定提现账号
 
 @return 绑定提现账号页面
 */
- (UIViewController *)ttPersonalModule_bindingXCZViewController:(int)bindXCZAccountType userInfo:(NSDictionary *)userInfo zxcInfo:(NSDictionary *)zxcInfo  {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(bindXCZAccountType) forKey:@"bindXCZAccountType"];
    [params setObject:userInfo forKey:@"userInfo"];
    [params setObject:zxcInfo forKey:@"zxcInfo"];
    return [self performTarget:@"TTPersonalModule" action:@"TTBindingXCZViewController" params:params shouldCacheTarget:YES];
}

/**
 公会 群聊
 
 @param sessionId 云信id
 @return 群聊页面
 */
- (UIViewController *)ttPersonalModule_TTGuildGroupSessionViewControllerWithSessionId:(NSString *)sessionId {
    if (sessionId == nil) {
        NSAssert(NO, @"sessionId can't be nil");
    }
    
    NSDictionary *params = @{@"sessionId": sessionId?:@"",
                             @"NIMSessionType": @(1)}; //NIMSessionTypeTeam = 1,
    return [self performTarget:@"TTPersonalModule" action:@"TTGuildGroupSessionViewController" params:params shouldCacheTarget:YES];
}

/**
 公会 首页
 
 @return 公会首页控制器
 */
- (UIViewController *)ttPersonalModule_TTGuildViewController {
    return [self performTarget:@"TTPersonalModule" action:@"TTGuildViewController" params:nil shouldCacheTarget:YES];
}

/**
 编辑个人资料
 
 @return 编辑个人资料控制器
 */
- (UIViewController *)ttPersonalModule_TTPersonEditViewController {
    return [self performTarget:@"TTPersonalModule" action:@"TTPersonEditViewController" params:nil shouldCacheTarget:YES];
}

/// 青少年模式
- (UIViewController *)ttPersonalModule_TTParentModelViewController {
    return [self performTarget:@"TTPersonalModule" action:@"TTParentModelViewController" params:nil shouldCacheTarget:YES];
}

/// 反馈
- (UIViewController *)ttPersonalModule_TTFeedbackViewController {
    return [self performTarget:@"TTPersonalModule" action:@"TTFeedbackViewController" params:nil shouldCacheTarget:YES];
}

/// 反馈
/// @param source 反馈来源，1-设置页，2-转盘活动，3-房间红包，其他值-未知来源
- (UIViewController *)ttPersonalModule_TTFeedbackViewControllerWithSource:(NSInteger)source {
    NSDictionary *params = @{@"source": @(source)};
    return [self performTarget:@"TTPersonalModule" action:@"TTFeedbackViewControllerWithSource" params:params shouldCacheTarget:YES];
}

@end
