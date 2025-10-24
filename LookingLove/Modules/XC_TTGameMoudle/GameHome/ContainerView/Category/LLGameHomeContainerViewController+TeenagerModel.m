//
//  LLGameHomeContainerViewController+TeenagerModel.m
//  XC_TTGameMoudle
//
//  Created by lee on 2019/7/30.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "LLGameHomeContainerViewController+TeenagerModel.h"

#import "TTPopup.h"
#import <YYCache/YYCache.h>
#import "UserCore.h"
#import "AuthCore.h"
#import "ClientCore.h"

///////////// 青少年模式 /////////////////
static NSString *const kTeenagerAlertCacheNameKey = @"kTeenagerAlertCacheNameKey"; // cache Name
static NSString *const kDidShowTeenagerAlertKey = @"didShowTeenagerAlertKey"; // cache Key

static NSString *const kShowTeenagerAlertUserIDKey = @"uid"; //
static NSString *const kShowTeenagerAlertDateKey = @"showTeenagerAlertDateKey"; // 弹窗出现日期

@implementation LLGameHomeContainerViewController (TeenagerModel)

#pragma mark -
#pragma mark 青少年模式弹窗
// 是否需要显示青少年模式
- (void)needOrNotShowTeenagerView {
    
    UserInfo *userInfo = [GetCore(UserCore) getUserInfoInDB:[[GetCore(AuthCore) getUid] longLongValue]];
    
    if (!userInfo) {
        // 拿不到用户数据就返回
        return;
    }
    
    if (userInfo.parentMode) {
        // 如果开启了青少年模式就不弹窗
        return;
    }
    
    YYCache *cache = [YYCache cacheWithName:kTeenagerAlertCacheNameKey];
    NSArray *array = (NSArray *)[cache objectForKey:kDidShowTeenagerAlertKey];
    
    __block BOOL hasShowAlert = NO; //
    
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj integerValue] == userInfo.uid) {
            // 当前用户的 uid 是否已经在显示过弹窗的用户数据中
            hasShowAlert = YES; // 已经显示过弹窗
            * stop = YES;
        }
    }];
    
    BOOL isSameDay = [[NSCalendar currentCalendar] isDateInToday:(NSDate *)[cache objectForKey:kShowTeenagerAlertDateKey]]; // 是否是同一天
    
    switch (GetCore(ClientCore).teenagerMode) {
        case TeenagerAlertTypeNormal:
        {
            // 弱引导，安装后显示一次就不再弹出
            if (array.count) {
                return;
            }
            // 显示弹窗
            [self showTeeagersView];
        }
            break;
        case TeenagerAlertTypeUnDefine: // 未获取到配置的情况下默认和强引导一样
        case TeenagerAlertTypeHigh:
        {
            // 强引导，每天启动一次
            if (isSameDay && hasShowAlert) {
                // 如果是同一天，而且已经弹出来过。就不再弹起
                return;
            }
            
            if (!isSameDay) {
                // 如果不是同一天就全部清除
                [cache removeAllObjects];
            }
            
            // 显示弹窗
            [self showTeeagersView];
        }
            break;
            
        default:
            break;
    }
}

// 显示青少年弹窗
- (void)showTeeagersView {
    
    if (![GetCore(AuthCore) isLogin]) {
        // 防止未登录情况下出现此弹窗。
        return;
    }
    
    LLTeenagerModelAlertView *teenagerModelView = [[LLTeenagerModelAlertView alloc] initWithFrame:CGRectMake(0, 0, 280, 261)];
    teenagerModelView.delegate = self;
    self.teenagerView = teenagerModelView;
    
    TTPopupService *service = [[TTPopupService alloc] init];
    service.contentView = teenagerModelView;
    service.shouldDismissOnBackgroundTouch = NO;
    service.style = TTPopupStyleAlert;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 延迟2s 显示
        [TTPopup popupWithConfig:service];
    });
    
    // 保存数据
    UserInfo *userInfo = [GetCore(UserCore) getUserInfoInDB:[[GetCore(AuthCore) getUid] longLongValue]];
    
    // 初始化缓存
    YYCache *teenagerAlertCache = [YYCache cacheWithName:kTeenagerAlertCacheNameKey];
    // 先从缓存中读取已存储的用户数据列表
    NSArray *array = (NSArray *)[teenagerAlertCache objectForKey:kDidShowTeenagerAlertKey];
    
    // 将当前用户添加进去
    NSMutableArray *userIDArray = [NSMutableArray arrayWithArray:array];
    [userIDArray addObject:@(userInfo.uid)];
    
    // 去重
    NSSet *set = [NSSet setWithArray:userIDArray.mutableCopy];
    
    // 用户数据
    [teenagerAlertCache setObject:set.allObjects forKey:kDidShowTeenagerAlertKey];
    // 日期
    [teenagerAlertCache setObject:[NSDate date] forKey:kShowTeenagerAlertDateKey];
    
}

@end
