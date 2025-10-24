//
//  NobleCache.m
//  BberryCore
//
//  Created by 卫明何 on 2018/1/10.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "NobleCache.h"
#define CACHENAME @"XCNobleCache"
#define CACHEKEY @"XCNobleCache"

@interface NobleCache ()
@property (nonatomic, strong) YYCache *yyCache;
@end

@implementation NobleCache

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.yyCache = [YYCache cacheWithName:CACHENAME];
    }
    return self;
}

+ (instancetype)shareCache
{
    static dispatch_once_t onceToken = 0;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

/**
 查询贵族信息
 
 @return NobleInfo
 */
- (NSDictionary *)getNobleInfoFromCache {
    return (NSDictionary *)[self.yyCache objectForKey:CACHEKEY];
}


/**
 缓存贵族信息
 
 @param nobleInfo 用户信息
 */
- (void)saveNobleInfo:(NSDictionary *)nobleInfo {
    [self.yyCache setObject:nobleInfo forKey:CACHEKEY withBlock:^{
        
    }];
}


/**
 移除贵族缓存信息
 
 */
- (void)removeNobleInfo {
    [self.yyCache removeObjectForKey:CACHEKEY withBlock:^(NSString * _Nonnull key) {
        
    }];
}



@end
