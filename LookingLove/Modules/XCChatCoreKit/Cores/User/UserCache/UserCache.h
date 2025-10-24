//
//  UserCache.h
//  BberryCore
//
//  Created by 卫明何 on 2017/11/30.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYCache.h>
#import "UserInfo.h"

@interface UserCache : NSObject

+ (instancetype)shareCache;

/**
查询用户信息

 @param uid 用户id
 @return rac
 */
- (RACSignal *)getUserInfoFromCacheWith:(UserID)uid;


/**
 缓存用户信息

 @param userInfo 用户信息
 */
- (void)saveUserInfo:(UserInfo *)userInfo;


/**
 移除用户信息

 @param key key
 */
- (void)removeUserInfoWithKey:(NSString *)key;


/**
 移除所有用户信息
 */
- (void)removeAllObject;

@end
