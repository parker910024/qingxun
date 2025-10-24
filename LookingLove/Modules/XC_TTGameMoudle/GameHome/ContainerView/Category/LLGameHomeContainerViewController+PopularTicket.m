//
//  LLGameHomeContainerViewController+PopularTicket.m
//  LookingLove
//
//  Created by lvjunhang on 2020/12/3.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import "LLGameHomeContainerViewController+PopularTicket.h"
#import "TTPopularTicketAlertView.h"
#import "TTPopup.h"
#import "AuthCore.h"
#import "HomeCore.h"
#import "TTWKWebViewViewController.h"

#import <YYCache/YYCache.h>

static NSString *const kPopularTicketCacheNameKey = @"kPopularTicketCacheNameKey";
static NSString *const kPopularTicketStoreUidsKey = @"kPopularTicketStoreUidsKey";

@implementation LLGameHomeContainerViewController (PopularTicket)

/// 请求人气票（显示人气票弹窗，在签到弹窗之后弹出）
- (void)requestPopularTicket {
    if (![self shouldRequestPopularTicket]) {
        return;
    }
    
    YYCache *cache = [YYCache cacheWithName:kPopularTicketCacheNameKey];
    NSMutableSet<NSString *> *uids = (NSMutableSet *)[cache objectForKey:kPopularTicketStoreUidsKey];
    if (!uids) {
        uids = [NSMutableSet set];
    }
    
    [uids addObject:GetCore(AuthCore).getUid];
    [cache setObject:uids forKey:kPopularTicketStoreUidsKey];
    [cache setObject:[NSDate date] forKey:GetCore(AuthCore).getUid];
    
    [GetCore(HomeCore) requestHomePopularTicketCompletion:^(PopularTicket *data, NSNumber *errorCode, NSString *msg) {
            
        if (errorCode) {
            return;
        }
        
        [self showPopularTicketAlertView:data];
    }];
}

/// 显示人气票弹窗，在签到弹窗之后弹出
- (void)showPopularTicketAlertView:(PopularTicket *)data {
    if (!data.needDialog) {
        //服务端的判断
        return;
    }
    
    TTPopularTicketAlertView *alert = [[TTPopularTicketAlertView alloc] init];
    alert.model = data;
    alert.doneHandler = ^{
        [TTPopup dismiss];
        
        TTWKWebViewViewController *vc = [[TTWKWebViewViewController alloc] init];
        vc.url = [NSURL URLWithString:data.skipLink];
        [self.navigationController pushViewController:vc animated:YES];
    };
    alert.closeHandler = ^{
        [TTPopup dismiss];
    };
    [TTPopup popupView:alert style:TTPopupStyleAlert];
}

/// 判断是否需要请求人气票
/// 同一账户一天只请求一次
- (BOOL)shouldRequestPopularTicket {
    if (![GetCore(AuthCore) isLogin]) {
        return NO;
    }
    
    YYCache *cache = [YYCache cacheWithName:kPopularTicketCacheNameKey];
    NSMutableSet<NSString *> *uids = (NSMutableSet *)[cache objectForKey:kPopularTicketStoreUidsKey];
    
    BOOL history = [uids containsObject:GetCore(AuthCore).getUid];
    if (history) {
        NSDate *date = (NSDate *)[cache objectForKey:GetCore(AuthCore).getUid];
        BOOL today = [[NSCalendar currentCalendar] isDateInToday:date];
        return !today;
    }
    return YES;
}

@end
