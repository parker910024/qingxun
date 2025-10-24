//
//  TTStatisticsService.h
//  TTPlay
//
//  Created by lvjunhang on 2019/1/25.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTStatisticsServiceEvents.h"

NS_ASSUME_NONNULL_BEGIN

/// <#Description#>
@interface TTStatisticsService : NSObject

#pragma mark - 埋点
+ (void)trackEvent:(NSString *)event
     eventDescribe:(NSString *)describe;

+ (void)trackEvent:(NSString *)event
     eventDescribe:(NSString *)describe
   eventAttributes:(nullable NSDictionary *)attributes;

+ (void)trackEvent:(NSString *)event
        eventStart:(NSString *)describe;

+ (void)trackEvent:(NSString *)event
        eventEnd:(NSString *)describe;

#pragma mark - 登录登出
+ (void)loginWithUID:(NSString *)uid;
+ (void)logout;

@end

NS_ASSUME_NONNULL_END
