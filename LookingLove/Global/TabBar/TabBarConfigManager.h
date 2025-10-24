//
//  TabBarConfigManager.h
//  LookingLove
//
//  Created by lvjunhang on 2020/12/4.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//  TabBar动态配置管理

#import <Foundation/Foundation.h>
#import "TabBarConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface TabBarConfigManager : NSObject
+ (instancetype)shareInstance;
- (TabBarConfig *)config;
- (void)updateConfig:(TabBarConfig *)config;
@end

NS_ASSUME_NONNULL_END
