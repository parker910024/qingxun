//
//  AdCache.h
//  BberryCore
//
//  Created by 卫明何 on 2018/1/3.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYCache/YYCache.h>
#import "AdInfo.h"

@interface AdCache : BaseObject

+ (instancetype)shareCache;

- (AdInfo *)getAdInfoFromCacheInMainWith:(NSString *)link;
- (RACSignal *)getAdInfoFromCacheWith:(NSString *)link;
- (void)saveAdInfo:(AdInfo *)adInfo;
- (void)removeUserInfoWithKey:(NSString *)key;
- (void)removeAllObject;

@end
