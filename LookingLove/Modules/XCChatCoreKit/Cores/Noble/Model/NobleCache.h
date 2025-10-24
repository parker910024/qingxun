//
//  NobleCache.h
//  BberryCore
//
//  Created by 卫明何 on 2018/1/10.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NobleInfo.h"
#import <YYCache/YYCache.h>

@interface NobleCache : NSObject


+ (instancetype)shareCache;

/**
 查询贵族信息
 
 @return NobleInfo
 */
- (NSDictionary *)getNobleInfoFromCache;


/**
 缓存贵族信息
 
 @param nobleInfo 用户信息
 */
- (void)saveNobleInfo:(NSDictionary *)nobleInfo;


/**
 移除贵族缓存信息

 */
- (void)removeNobleInfo;



@end
