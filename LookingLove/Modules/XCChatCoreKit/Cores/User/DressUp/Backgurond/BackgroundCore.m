//
//  BackgroundCore.m
//  BberryCore
//
//  Created by Macx on 2018/6/20.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "BackgroundCore.h"
#import "HttpRequestHelper+UserBackground.h"
#import "UserCoreClient.h"
#import "AuthCore.h"

@implementation BackgroundCore


/**
 请求背景商城列表
 
 @param page 页码
 @param pageSize 每页数量
 */
- (void)requestBackgroundListByPage:(NSString *)page pageSize:(NSString *)pageSize state:(int)state uid:(UserID)uid {
    
    [HttpRequestHelper getBackgroundListWithPageSize:pageSize page:page uid:uid Success:^(NSArray *backgroundList) {
        NotifyCoreClient(UserCoreClient, @selector(onGetBackgroundListSuccess:state:), onGetBackgroundListSuccess:backgroundList state:state);
    } failure:^(NSNumber *code, NSString *msg) {
        NotifyCoreClient(UserCoreClient, @selector(onGetBackgroundListFailth:), onGetBackgroundListFailth:msg);
    }];
}



/**
 请求背景列表
 */
- (void)requestUserBackgroundWithUid:(NSString *)uid {
    [HttpRequestHelper getBackgroundList:uid success:^(NSArray *list) {
        NotifyCoreClient(UserCoreClient, @selector(onGetOwnBackgroundListSuccess:), onGetOwnBackgroundListSuccess:list);
    } failure:^(NSNumber *code, NSString *msg) {
        NotifyCoreClient(UserCoreClient, @selector(onGetOwnBackgroundListFailth:), onGetOwnBackgroundListFailth:msg);

    }];    
}



/**
 请求可用背景列表
 */
- (void)requestUserAvailableBackgroundWithUid:(NSString *)uid {
    
    [HttpRequestHelper getUserAvailableBackgroundList:uid success:^(NSArray *list) {
        NotifyCoreClient(UserCoreClient, @selector(onGetOwnAvailableBackgroundListSuccess:), onGetOwnAvailableBackgroundListSuccess:list);
    } failure:^(NSNumber *code, NSString *msg) {
        NotifyCoreClient(UserCoreClient, @selector(onGetOwnAvailableBackgroundListFailth:), onGetOwnAvailableBackgroundListFailth:msg);
    }];
    
}
/**
 购买背景
 
 @param backgroundId 背景Id
 @return complete就是成功 error就是失败
 */
- (RACSignal *)buyBackgroundByBackgroundId:(NSString *)backgroundId{
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [HttpRequestHelper buyOrRenewBackgroundByBackgroundId:backgroundId Success:^(BOOL success) {
                    [subscriber sendCompleted];
                } failure:^(NSNumber *resCode, NSString *message) {
                    NSError *error = [[NSError alloc]initWithDomain:message code:[resCode integerValue] userInfo:nil];
                    [subscriber sendError:error];
                }];
                return nil;
            }];
    
}




/**
 赠送背景
 
 @param backgroundId 背景Id
 @param targetUid  被赠送Id
 @return complete就是成功 error就是失败
 */
- (RACSignal *)presentBackgroundByBackgroundId:(NSString *)backgroundId toTargetUid:(UserID)targetUid {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                NSString *uid = GetCore(AuthCore).getUid;
                [HttpRequestHelper presentBackgroundFromUid:uid toTargetUid:targetUid withBackgroundId:backgroundId success:^(BOOL success) {
                        [subscriber sendCompleted];
                } failure:^(NSNumber *resCode, NSString *message) {
                        NSError *error = [[NSError alloc]initWithDomain:message code:[resCode integerValue] userInfo:nil];
                        [subscriber sendError:error];
                }];
            return nil;
    }];
}



/**
 使用背景
 
 @param backgroundId 背景Id
 */
- (RACSignal *)useBackgroundByBackgroundId:(NSString *)backgroundId  roomUid:(NSString *)roomUid{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [HttpRequestHelper useBackgroundByBackgroundId:backgroundId roomUid:roomUid Success:^(BOOL success) {
            [subscriber sendCompleted];
        } failure:^(NSNumber *resCode, NSString *message) {
            NSError *error = [[NSError alloc]initWithDomain:message code:[resCode integerValue] userInfo:nil];
            [subscriber sendError:error];
        }];
        return nil;
    }];
    
}

/**
 取消使用背景
 
 */
- (RACSignal *)cancelBackgroundRoomUid:(NSString *)roomUid {
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [HttpRequestHelper cancelBackgroundByRoomUid:roomUid Success:^(BOOL success) {
            [subscriber sendCompleted];
        } failure:^(NSNumber *resCode, NSString *message) {
            NSError *error = [[NSError alloc]initWithDomain:message code:[resCode integerValue] userInfo:nil];
            [subscriber sendError:error];
        }];
        return nil;
    }];
}




@end
