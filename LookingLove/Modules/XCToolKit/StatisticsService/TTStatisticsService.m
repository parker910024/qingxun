//
//  TTStatisticsService.m
//  TTPlay
//
//  Created by lvjunhang on 2019/1/25.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTStatisticsService.h"
#import "XCMacros.h"
#import <BaiduMobStatCodeless/BaiduMobStat.h>

@implementation TTStatisticsService

+ (void)trackEvent:(NSString *)event eventDescribe:(NSString *)describe {
    
    [self trackEvent:event eventDescribe:describe eventAttributes:nil];
}

+ (void)trackEvent:(NSString *)event eventDescribe:(NSString *)describe eventAttributes:(nullable NSDictionary *)attributes {
    if (event == nil || event.length == 0) {
        return;
    }
    
#ifdef DEBUG
        NSLog(@"trackEvent:%@ --- eventDescribe:%@", event, describe);
#endif
    [[BaiduMobStat defaultStat] logEvent:event eventLabel:describe attributes:attributes];
}

+ (void)trackEvent:(NSString *)event eventStart:(NSString *)describe {
    if (event == nil || event.length == 0) {
        return;
    }
    
#ifdef DEBUG
    NSLog(@"trackEvent:%@", event);
#endif
    [[BaiduMobStat defaultStat] eventStart:event eventLabel:describe];
    
}

+ (void)trackEvent:(NSString *)event eventEnd:(NSString *)describe {
    
    if (event == nil || event.length == 0){
        return;
    }
    
#ifdef DEBUG
    NSLog(@"trackEvent:%@", event);
#endif
    [[BaiduMobStat defaultStat] eventEnd:event eventLabel:describe];
}

+ (void)loginWithUID:(NSString *)uid {
    
    if (uid == nil || uid.length == 0) {
        return;
    }
    NSAssert(NO, @"BaiduMobStat don't need login");
}

+ (void)logout {
    NSAssert(NO, @"BaiduMobStat don't need logout");
}

@end
