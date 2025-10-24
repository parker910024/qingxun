//
//  UserCache.m
//  BberryCore
//
//  Created by 卫明何 on 2017/11/30.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "UserCache.h"
#import "XCDBManager.h"

#define CACHENAME @"XCUserCache"

@interface UserCache ()

@property (nonatomic, strong) YYCache *yyCache;

@end

@implementation UserCache

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

- (RACSignal *)getUserInfoFromCacheWith:(UserID)uid {
    NSString *userId = [NSString stringWithFormat:@"%lld",uid];
    @weakify(self);
    RACSignal * signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [self.yyCache containsObjectForKey:userId withBlock:^(NSString * _Nonnull key, BOOL contains) {
            if (contains) {
                [self.yyCache objectForKey:key withBlock:^(NSString * _Nonnull key, id<NSCoding>  _Nonnull object) {
                    if (object) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [subscriber sendNext:object];
                            [subscriber sendCompleted];
                        });
                    }
                }];
            }else {
                [[XCDBManager defaultManager]getUserWithUserID:uid success:^(UserInfo *userInfo) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (userInfo) {
                            [self saveUserInfo:userInfo];
                            [subscriber sendNext:userInfo];
                            [subscriber sendCompleted];
                        }else {
                            [subscriber sendNext:nil];
                            [subscriber sendCompleted];
                        }
                        
                    });

                }];
                
            }
        }];
        return nil;
    }];
    return signal;
}

- (void)saveUserInfo:(UserInfo *)userInfo {
    NSString *key = [NSString stringWithFormat:@"%lld",userInfo.uid];
    [self.yyCache setObject:userInfo forKey:key withBlock:^{
        
    }];
}

- (void)removeUserInfoWithKey:(NSString *)key {
    [self.yyCache removeObjectForKey:key withBlock:^(NSString * _Nonnull key) {
        
    }];
}

- (void)removeAllObject {
    [self.yyCache removeAllObjects];
}


@end
