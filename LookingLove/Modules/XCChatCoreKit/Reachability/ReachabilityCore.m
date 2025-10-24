//
//  ReachabilityCore.m
//  YYMobile
//
//  Created by daixiang on 14-6-4.
//  Copyright (c) 2014年 YY.inc. All rights reserved.
//

#import "ReachabilityCore.h"
#import "YYReachability.h"
#import "CoreManager.h"
#import "YYLogger.h"

@interface ReachabilityCore ()
{
    YYReachability *_reachability;
    ReachabilityStatus _status;
    ReachabilityNetState _netState;
}

@end

@implementation ReachabilityCore

- (id)init
{
    if (self = [super init])
    {
        _reachability = [YYReachability reachabilityForInternetConnection];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged) name:kYYReachabilityChangedNotification object:nil];
        [_reachability startNotifier];
        _status = (ReachabilityStatus)[_reachability currentReachabilityStatus];
        _netState = (_status == ReachableViaWiFi || _status == ReachableViaWWAN) ? ReachabilityNetReachable : ReachabilityNetNoReachable;
    }
    return self;
}

- (ReachabilityStatus)currentStatus
{
    return _status;
}

- (BOOL)isReachable
{
    return [self currentStatus] != ReachabilityStatusNotReachable;
}

- (void)reachabilityChanged
{
    _status = (ReachabilityStatus)[_reachability currentReachabilityStatus];
    NotifyCoreClient(ReachabilityClient, @selector(reachabilityDidChange:), reachabilityDidChange:_status);
    
    ReachabilityNetState tmpNetState = (_status == ReachableViaWiFi || _status == ReachableViaWWAN) ? ReachabilityNetReachable : ReachabilityNetNoReachable;
    if (tmpNetState != _netState) {
        _netState = tmpNetState;
        NotifyCoreClient(ReachabilityClient, @selector(reachabilityNetStateDidChange:), reachabilityNetStateDidChange:_netState);
    }
}

@end
