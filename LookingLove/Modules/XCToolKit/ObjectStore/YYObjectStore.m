//
//  YYObjectStore.m
//  YYMobileCore
//
//  Created by wuwei on 14/6/11.
//  Copyright (c) 2014年 YY.inc. All rights reserved.
//

#import "YYObjectStore.h"
#import "NSString+AutoMessageDigest.h"
#import <sys/xattr.h>
#import <objc/runtime.h>


typedef NS_ENUM(NSInteger, IOQueueCondition) {
    NODATA = 0,
    HASDATA = 1
};

static const NSTimeInterval kDefaultMaxCacheAge = 60 * 60 * 24; // 1 day


const char * kObjectStoreMaxCacheAgeAttribute = "com.yy.objectStore.maxCacheAge";

@interface YYObjectStore ()

@property (nonatomic, strong, readonly) NSString *namespace;

/**
 *  Key-Value内存缓存
 */
@property (nonatomic, strong, readonly) NSCache *memoryCache;

/**
 *  磁盘缓存路径
 */
@property (nonatomic, strong, readonly) NSString *diskCachePath;
@property (nonatomic, strong, readonly) NSFileManager *fileManager;

@property (nonatomic, strong, readonly) dispatch_queue_t ioQueue;

- (NSString *)_cachePathForKey:(NSString *)key;
- (NSString *)_cacheFileNameForKey:(NSString *)key;

@end

@implementation YYObjectStore

@synthesize namespace = _namespace;

@synthesize memoryCache = _memoryCache;
@synthesize diskCachePath = _diskCachePath;

+ (instancetype)objectStoreWithNamespace:(NSString *)namespace
{
    return [[self alloc] initWithNamespace:namespace];
}

- (instancetype)initWithNamespace:(NSString *)namespace inDirectory:(NSString *)directory
{
    self = [super init];
    if (self) {
        _namespace = namespace;
        _memoryCache = [[NSCache alloc] init];
        _memoryCache.name = namespace;
        
        if (directory.length == 0) {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            directory = [paths[0] stringByAppendingPathComponent:@"com.yy.objectstore"];
        }
        _diskCachePath = [directory stringByAppendingPathComponent:namespace];
        _ioQueue = dispatch_queue_create("com.yy.objectstore", DISPATCH_QUEUE_SERIAL);
        dispatch_sync(_ioQueue, ^{
            _fileManager = [[NSFileManager alloc] init];
        });
        
        // received memory warning, just clear the memory cache
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearMemory) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

- (instancetype)initWithNamespace:(NSString *)ns
{
    return [self initWithNamespace:ns inDirectory:nil];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"[YYObjectStore] namespace: %@\ndiskCachePath: %@\nmemoryCache: %@", self.namespace, self.diskCachePath, self.memoryCache];
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Save, Asynchronously

- (void)cacheObject:(id <NSSecureCoding>)object forKey:(NSString *)key
{
    [self cacheObject:object forKey:key policy:kObjectStoreSavePolicyDefault maxCacheAge:kDefaultMaxCacheAge];
}

- (void)cacheObject:(id <NSSecureCoding>)object forKey:(NSString *)key maxCacheAge:(NSTimeInterval)maxCacheAge
{
    [self cacheObject:object forKey:key policy:kObjectStoreSavePolicyDefault maxCacheAge:maxCacheAge];
}

- (void)cacheObject:(id <NSSecureCoding>)object forKey:(NSString *)key policy:(ObjectStoreSavePolicy)policy maxCacheAge:(NSTimeInterval)maxCacheAge
{
    if (policy & kObjectStoreSaveToMemory) {
        [self.memoryCache setObject:object forKey:key];
    }
    
    maxCacheAge = maxCacheAge > 0 ? maxCacheAge : kDefaultMaxCacheAge;
    
    if (policy & kObjectStoreSaveToDisk) {
        NSData *archive = [NSKeyedArchiver archivedDataWithRootObject:object];
        dispatch_async(self.ioQueue, ^{
            NSString *cachePath = [self _cachePathForKey:key];
            [self _createCacheDirectory];
            
            BOOL success = [self.fileManager createFileAtPath:cachePath contents:archive attributes:nil];
            
            if (success) {
                [self _setMaxCacheAge:maxCacheAge forPath:cachePath];
            }
        });
    }
}

#pragma mark - Load, Asynchronously

- (void)queryCachedObjectForKey:(NSString *)key completion:(void (^)(NSObject<NSSecureCoding> *, ObjectStoreCacheType))completion
{
    [self queryCachedObjectForKey:key policy:kObjectStoreLoadPolicyDefault completion:completion];
}

- (void)queryCachedObjectForKey:(NSString *)key policy:(ObjectStoreLoadPolicy)policy completion:(void (^)(NSObject<NSSecureCoding> *, ObjectStoreCacheType))completion
{
    NSParameterAssert(completion);
    
    if (policy & kObjectStoreLoadFromMemory) {
        id objectInMemory = [self.memoryCache objectForKey:key];
        if (objectInMemory) {
            completion(objectInMemory, kObjectStoreCacheMemory);
            return;
        }
    }
    
    // Did not get from memory cache
    if (policy & kObjectStoreLoadFromDisk) {
        dispatch_async(self.ioQueue, ^{
            NSString *cachePath = [self _cachePathForKey:key];
            __block id objectInDisk;
            NSTimeInterval maxCacheAge = [self _getMaxCacheForPath:cachePath];
            if (maxCacheAge > 0) {
                NSDictionary *fileAttributes = [self.fileManager attributesOfItemAtPath:cachePath error:nil];
                NSDate *modificationDate = [fileAttributes fileModificationDate];
                NSDate *expirationDate = [NSDate dateWithTimeIntervalSinceNow:-maxCacheAge];
                BOOL isFileExpired = [modificationDate laterDate:expirationDate] == expirationDate;
                if (isFileExpired && !(policy & kObjectStoreLoadAllowExpired)) {
                    // The file cached is expired
                    // And, we do not load the expired file, just remove the file and return
                    // We do not load the expired file
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(nil, kObjectStoreCacheNone);
                    });
                    return;
                }
                
                __block BOOL isFileInvalid = NO;
                NSData *data = [self.fileManager contentsAtPath:cachePath];
                @try {
                    if (data) {
                        objectInDisk = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                    }
                }
                @catch (NSException *exception) {
                    isFileInvalid = YES;
                }
                @finally {
                    if (isFileExpired || isFileInvalid) {
                        [self.fileManager removeItemAtPath:cachePath error:nil];
                    }
                    else if (objectInDisk) {
                        [self.memoryCache setObject:objectInDisk forKey:key];
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(objectInDisk, objectInDisk ? (isFileExpired ? kObjevtStoreCacheDiskButExpired : kObjectStoreCacheDisk) : kObjectStoreCacheNone);
                    });
                }
            }
            else
            {
                // max cache age <= 0, file is invalid
                [self.fileManager removeItemAtPath:cachePath error:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(nil, kObjectStoreCacheNone);
                });
            }
        });
    }
//    else {
    
//    }
}

#pragma mark - Load, Synchronously

- (NSObject<NSSecureCoding> *)queryCachedObjectForKey:(NSString *)key cachedType:(ObjectStoreCacheType *)cachedTypePtr
{
    return [self queryCachedObjectForKey:key policy:kObjectStoreLoadPolicyDefault cachedType:cachedTypePtr];
}

- (NSObject<NSSecureCoding> *)queryCachedObjectForKey:(NSString *)key policy:(ObjectStoreLoadPolicy)policy cachedType:(ObjectStoreCacheType *)cachedTypePtr
{
    if (policy & kObjectStoreLoadFromMemory) {
        id objectInMemory = [self.memoryCache objectForKey:key];
        if (objectInMemory) {
            if (cachedTypePtr) {
                *cachedTypePtr = kObjectStoreCacheMemory;
            }
            return objectInMemory;
        }
    }
    
    __block id objectInDisk = nil;
    __block ObjectStoreCacheType cacheType = kObjectStoreCacheNone;
    if (policy & kObjectStoreLoadFromDisk) {
        
        NSConditionLock *lock = [[NSConditionLock alloc] initWithCondition:NODATA];
        dispatch_async(self.ioQueue, ^{
            NSString *cachePath = [self _cachePathForKey:key];
            NSTimeInterval maxCacheAge = [self _getMaxCacheForPath:cachePath];
            if (maxCacheAge > 0) {
                NSDictionary *fileAttributes = [self.fileManager attributesOfItemAtPath:cachePath error:nil];
                NSDate *modificationDate = [fileAttributes fileModificationDate];
                NSDate *expirationDate = [NSDate dateWithTimeIntervalSinceNow:-maxCacheAge];
                BOOL isFileExpired = [modificationDate laterDate:expirationDate] == expirationDate;
                if (isFileExpired && !(policy & kObjectStoreLoadAllowExpired)) {
                    // The file cached is expired
                    // And, we do not load the expired file, just remove the file and return
                    [self.fileManager removeItemAtPath:cachePath error:nil];
                    objectInDisk = nil;
                }
                else {
                    NSData *data = [self.fileManager contentsAtPath:cachePath];
                    __block BOOL isFileInvalid = NO;
                    @try {
                        // NSKeyedUnarchiver unarchiveObjectWithData raises NSInvalidArchiveOperationException
                        if (data) {
                            objectInDisk = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                        }
                    }
                    @catch (NSException *exception) {
                        isFileExpired = YES;
                    }
                    @finally {
                        cacheType = objectInDisk ? (isFileExpired ? kObjevtStoreCacheDiskButExpired : kObjectStoreCacheDisk) : kObjectStoreCacheNone;
                        if (isFileExpired || isFileInvalid) {
                            [self.fileManager removeItemAtPath:cachePath error:nil];
                        }
                        else if (objectInDisk) {
                            [self.memoryCache setObject:objectInDisk forKey:key];
                        }
                    }
                }
            }
            else
            {
                // Missing max cache age, delete
                [self.fileManager removeItemAtPath:cachePath error:nil];
                objectInDisk = nil;
            }
            
            [lock lock];
            [lock unlockWithCondition:HASDATA];
        });
        
        [lock lockWhenCondition:HASDATA];
        [lock unlock];
    }
    
    if (cachedTypePtr) {
        *cachedTypePtr = cacheType;
    }
    return objectInDisk;
}

#pragma mark - Remove Object

- (BOOL)removeAllStores {
    
    BOOL result = [self.fileManager removeItemAtPath:_diskCachePath error:nil];
    
    [self.memoryCache removeAllObjects];
    
    return result;
}

- (void)removeCachedObjectForKey:(NSString *)key
{
    [self.memoryCache removeObjectForKey:key];
    
    NSString *cachePath = [self _cachePathForKey:key];
    [self.fileManager removeItemAtPath:cachePath error:nil];
}

#pragma mark - Clear

- (void)clearMemory
{
    [self.memoryCache removeAllObjects];
}

- (void)cleanCache
{
    dispatch_async(self.ioQueue, ^{
        CFAbsoluteTime beginTimestamp = CFAbsoluteTimeGetCurrent();

        NSDirectoryEnumerator *directoryEnumerator = [self.fileManager enumeratorAtPath:self.diskCachePath];
        NSMutableArray *filesToDelete = [NSMutableArray array];
        for (NSString *fileName in directoryEnumerator) {
            NSString *filePath = [self.diskCachePath stringByAppendingPathComponent:fileName];
            NSTimeInterval maxCacheAge = [self _getMaxCacheForPath:filePath];
            if (maxCacheAge <= 0) {
                continue;
            }
            
            NSDictionary *fileAttributes = [self.fileManager attributesOfItemAtPath:filePath error:nil];
            NSDate *modificationDate = [fileAttributes fileModificationDate];
            
            NSDate *expirationDate = [NSDate dateWithTimeIntervalSinceNow:-maxCacheAge];
            if ([modificationDate laterDate:expirationDate] == expirationDate) {
                [filesToDelete addObject:filePath];
            }
        }
        
        for (NSString *filePath in filesToDelete) {
            [self.fileManager removeItemAtPath:filePath error:nil];
        }
        
        CFAbsoluteTime endTimestamp = CFAbsoluteTimeGetCurrent();
    });
}

#pragma mark - Private

- (NSString *)_cachePathForKey:(NSString *)key
{
    return [self.diskCachePath stringByAppendingPathComponent:[self _cacheFileNameForKey:key]];
}

- (NSString *)_cacheFileNameForKey:(NSString *)key
{
    return [key MD5];
}

- (void)_createCacheDirectory
{
    [[NSFileManager defaultManager] createDirectoryAtPath:self.diskCachePath withIntermediateDirectories:YES attributes:nil error:nil];
}

- (void)_setMaxCacheAge:(NSTimeInterval)maxCacheAge forPath:(NSString *)path
{
    const char *maxCacheAgeStr = [[NSString stringWithFormat:@"%lu", (unsigned long)maxCacheAge] UTF8String];
    setxattr([path UTF8String], kObjectStoreMaxCacheAgeAttribute, maxCacheAgeStr, strlen(maxCacheAgeStr), 0, 0);
}

- (NSTimeInterval)_getMaxCacheForPath:(NSString *)path
{
    const char *filePath = [path fileSystemRepresentation];
    
    NSTimeInterval interval = 0;
    int bufferLength = (int)getxattr(filePath, kObjectStoreMaxCacheAgeAttribute, NULL, 0, 0, 0);
    if (bufferLength > 0) {
        char *buffer = malloc(bufferLength);
        
        getxattr(filePath, kObjectStoreMaxCacheAgeAttribute, buffer, 255, 0, 0);
        
        NSString *attributeValue = [[NSString alloc] initWithBytes:buffer length:bufferLength encoding:NSUTF8StringEncoding];
        
        free(buffer);
        
        interval = [attributeValue doubleValue];
    }
    return interval;
}

@end
