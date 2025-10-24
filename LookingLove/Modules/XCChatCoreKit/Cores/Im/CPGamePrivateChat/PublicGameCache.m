//
//  PublicGameCache.m
//  XCChatCoreKit
//
//  Created by new on 2019/2/22.
//  Copyright © 2019 KevinWang. All rights reserved.
//

#import "PublicGameCache.h"
#import "AuthCore.h"
#define CACHENAME @"XCGameCache"

@interface PublicGameCache ()
@property (nonatomic, strong) YYCache *yyCache;
@end

@implementation PublicGameCache

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.yyCache = [YYCache cacheWithName:CACHENAME];
    }
    return self;
}

+ (instancetype)sharePublicGameCache {
    static dispatch_once_t onceToken = 0;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)saveGameInfo:(NIMMessage *)message{
    [self.yyCache setObject:message forKey:message.messageId withBlock:^{
        
    }];
}

- (NIMMessage *)selectGameInfo:(NSString *)messageID{
    if (messageID.length > 0) {
        if ([self.yyCache containsObjectForKey:messageID]) {
            return [self.yyCache objectForKey:messageID];
        }else {
            return nil;
        }
    }else {
        return nil;
    }
    return nil;
}

- (void)changeGameInfo:(NIMMessage *)message{
    [self.yyCache setObject:message forKey:message.messageId withBlock:^{
        
    }];
}

- (void)saveGameMessageFromMeInfo:(NSDictionary *)messageDic{
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
