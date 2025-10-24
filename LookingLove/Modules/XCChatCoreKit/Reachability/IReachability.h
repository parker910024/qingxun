//
//  IReachability.h
//  YYMobileCore
//
//  Created by wuwei on 14/8/5.
//  Copyright (c) 2014年 YY.inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSInteger {
    ReachabilityStatusNotReachable = 0,
    ReachabilityStatusReachableViaWiFi = 2,
    ReachabilityStatusReachableViaWWAN = 1
} ReachabilityStatus;

typedef enum : NSInteger {
    ReachabilityNetNoReachable = 0,
    ReachabilityNetReachable = 1
} ReachabilityNetState;


@protocol IReachability <NSObject>

- (ReachabilityStatus)currentStatus;
- (BOOL)isReachable;

@end

@protocol ReachabilityClient <NSObject>

@optional
- (void)reachabilityDidChange:(ReachabilityStatus)currentStatus;
- (void)reachabilityNetStateDidChange:(ReachabilityNetState)currentNetState;

@end
