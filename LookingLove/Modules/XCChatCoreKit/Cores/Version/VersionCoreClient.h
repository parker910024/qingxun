//
//  VersionCoreClient.h
//  BberryCore
//
//  Created by 卫明何 on 2017/11/9.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VersionInfo.h"

@protocol VersionCoreClient <NSObject>
@optional
- (void)appNeedUpdateWithDesc:(NSString *)desc version:(NSString *)version;
- (void)appNeedForceUpdateWithDesc:(NSString *)desc version:(NSString *)version;
- (void)onRequestVersionStatusSuccess:(VersionInfo *)versionInfo;
//兔兔
- (void)getVestBagLoginDescriptionSuccess:(NSString *)description;

// 轻寻
- (void)getVestBagLoginDescriptionDictSuccess:(VersionInfo *)model;
@end
