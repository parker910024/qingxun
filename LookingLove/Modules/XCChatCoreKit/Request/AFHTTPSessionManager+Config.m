//
//  AFHTTPSessionManager+Config.m
//  Bberry
//
//  Created by KevinWang on 2018/6/2.
//  Copyright © 2018年 XC. All rights reserved.
//

#import "AFHTTPSessionManager+Config.h"
#import <objc/runtime.h>
#import "NSMutableDictionary+Safe.h"
#import "YYReachability.h"
#import "YYUtility.h"

static NSString * const kHttpClientBasicParameterOSKey         = @"os";
static NSString * const kHttpClientBasicParameterOSVersionKey  = @"osVersion";
static NSString * const kHttpClientBasicParameterISPTypeKey    = @"ispType";
static NSString * const kHttpClientBasicParameterNetTypeKey    = @"netType";
static NSString * const kHttpClientBasicParameterChannelKey    = @"channel";
static NSString * const kHttpClientBasicParameterModelKey      = @"model";
static NSString * const kHttpClientBasicParameterDeviceIdKey = @"deviceId";
static NSString * const kHttpClientBasicParameterAPpVersionKey = @"appVersion";
static NSString * const kHttpClientBasicParameterAppName       = @"app";


static void * Parameter = (void *)@"parameter";

@implementation AFHTTPSessionManager (Config)

- (NSMutableDictionary*)parmars{
    
    return objc_getAssociatedObject(self, Parameter);
}

- (void)setParmars:(NSMutableDictionary *)parmars{
    
    objc_setAssociatedObject(self, Parameter, parmars, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (NSDictionary*)configBaseParmars:(NSDictionary *)parmars {
    NSDictionary *defaultBasciParame = [self defaultBasicParameterConstructor];
    if (!parmars||![parmars isKindOfClass:[NSDictionary class]]){
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:defaultBasciParame];
        return dic;
    }
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:parmars];
    for (NSString *parameKey in defaultBasciParame.allKeys) {
        [dic safeSetObject:defaultBasciParame[parameKey] forKey:parameKey];
    }
    return dic;
}

+ (NSDictionary *)defaultBasicParameterConstructor {
    
    return @{
             kHttpClientBasicParameterOSKey:        @"iOS",
             kHttpClientBasicParameterOSVersionKey: [YYUtility systemVersion],
             kHttpClientBasicParameterNetTypeKey:   ([YYUtility networkStatus] == ReachableViaWiFi) ? @2 : @1,
             kHttpClientBasicParameterISPTypeKey:   @([YYUtility carrierIdentifier]),
             kHttpClientBasicParameterChannelKey:  [YYUtility getAppSource] ? : @"",
             kHttpClientBasicParameterModelKey: [YYUtility modelName],
             kHttpClientBasicParameterDeviceIdKey:[YYUtility deviceUniqueIdentification],
             kHttpClientBasicParameterAPpVersionKey:[YYUtility appVersion],
             kHttpClientBasicParameterAppName:[YYUtility appName]
             };
}

+ (NSDictionary *)basicParameters {
    return [self defaultBasicParameterConstructor];
}

@end

