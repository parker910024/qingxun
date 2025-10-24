//
//  AppDelegate+TTSDKConfig.h
//  TuTu
//
//  Created by lvjunhang on 2018/11/2.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//  第三方 SDK 配置

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (TTSDKConfig)

/**
 需要在第一时间就注册的 SDK
 */
- (void)initSDKConfigOnTime;

/**
 可稍后注册的 SDK
 */
- (void)initSDKConfigLater;

@end

NS_ASSUME_NONNULL_END
