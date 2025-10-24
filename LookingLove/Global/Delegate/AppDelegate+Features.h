//
//  AppDelegate+Features.h
//  TTPlay
//
//  Created by lee on 2019/2/26.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

/// 最后更新地理位置日期存储
static NSString *kLastUpdateLocationDateStoreKey = @"kLastUpdateLocationDataStoreKey";

@interface AppDelegate (Features)<GuildCoreClient, AMapLocationManagerDelegate>
/** 解析暗号 */
- (void)analysisSecretCodeKey;

/** 定位 */
- (void)locationWithCompletionBlock;

/** 开始获取获取用户地理信息 */
- (void)startConfigLocation;
@end

NS_ASSUME_NONNULL_END
