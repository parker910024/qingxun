//
//  NormalRoomGameCache.m
//  XCChatCoreKit
//
//  Created by new on 2019/3/18.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "NormalRoomGameCache.h"
#import "AuthCore.h"
#define CACHENAME @"XCNormalGameCache"

@interface NormalRoomGameCache ()

@property (nonatomic, strong) YYCache *yyCache;

@end

@implementation NormalRoomGameCache

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.yyCache = [YYCache cacheWithName:CACHENAME];
    }
    return self;
}

+ (instancetype)shareNormalGameCache {
    static dispatch_once_t onceToken = 0;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}


- (void)saveGameMessageFromMeInfo:(NSDictionary *)messageDic{
    [self.yyCache setObject:messageDic forKey:GetCore(AuthCore).getUid withBlock:^{
        
    }];
}

- (void)removeGameMessageFromMeInfo:(NSDictionary *)messageDic {
    [self.yyCache setObject:messageDic forKey:GetCore(AuthCore).getUid withBlock:^{
        
    }];
}

- (NSDictionary *)takeOutMyOwnMessagesWithUid:(NSString *)uid{
    if (uid.length > 0) {
        if ([self.yyCache containsObjectForKey:uid]) {
            return [self.yyCache objectForKey:uid];
        }else {
            return nil;
        }
    }else {
        return nil;
    }
    return nil;
}

@end
