//
//  IObjectStore.h
//  YYMobileFramework
//
//  Created by wuwei on 14/6/16.
//  Copyright (c) 2014年 YY Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ObjectStoreCacheType)
{
    kObjectStoreCacheNone,              // 无缓存
    kObjectStoreCacheMemory,            // 命中内存缓存
    kObjectStoreCacheDisk,              // 命中磁盘缓存
    kObjevtStoreCacheDiskButExpired     // 命中磁盘缓存但缓存已过期
};

typedef NS_OPTIONS(NSInteger, ObjectStoreSavePolicy)
{
    kObjectStoreSaveToMemory        = 1 << 0,
    kObjectStoreSaveToDisk          = 1 << 1,

    kObjectStoreSaveToAll           = kObjectStoreSaveToMemory | kObjectStoreSaveToDisk,
    kObjectStoreSavePolicyDefault   = kObjectStoreSaveToAll
};

typedef NS_OPTIONS(NSInteger, ObjectStoreLoadPolicy)
{
    kObjectStoreLoadFromMemory      = 1 << 0,
    kObjectStoreLoadFromDisk        = 1 << 1,
    kObjectStoreLoadAllowExpired    = 1 << 2,
    
    kObjectStoreLoadFromAnySource   = kObjectStoreLoadFromMemory | kObjectStoreLoadFromDisk | kObjectStoreLoadAllowExpired,
    kObjectStoreLoadPolicyDefault   = kObjectStoreLoadFromAnySource
};


@protocol IObjectStore <NSObject>

@required

// Cache object
- (void)cacheObject:(id <NSSecureCoding>)object forKey:(NSString *)key;
- (void)cacheObject:(id <NSSecureCoding>)object forKey:(NSString *)key maxCacheAge:(NSTimeInterval)maxCacheAge;
- (void)cacheObject:(id <NSSecureCoding>)object forKey:(NSString *)key policy:(ObjectStoreSavePolicy)policy maxCacheAge:(NSTimeInterval)maxCacheAge;

// Query cached object asynchronously
- (void)queryCachedObjectForKey:(NSString *)key policy:(ObjectStoreLoadPolicy)policy completion:(void(^)(NSObject<NSSecureCoding> *object, ObjectStoreCacheType type))completion;
- (void)queryCachedObjectForKey:(NSString *)key completion:(void(^)(NSObject<NSSecureCoding> *object, ObjectStoreCacheType type))completion;

// Query cached object synchronously
- (NSObject<NSSecureCoding> *)queryCachedObjectForKey:(NSString *)key policy:(ObjectStoreLoadPolicy)policy cachedType:(ObjectStoreCacheType *)cachedTypePtr;
- (NSObject<NSSecureCoding> *)queryCachedObjectForKey:(NSString *)key cachedType:(ObjectStoreCacheType *)cachedTypePtr;

// Clear cache
- (BOOL)removeAllStores;
- (void)removeCachedObjectForKey:(NSString *)key;

// Caculate cached size

@end
