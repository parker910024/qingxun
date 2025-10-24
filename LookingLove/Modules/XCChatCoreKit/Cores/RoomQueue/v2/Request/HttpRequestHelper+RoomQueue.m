//
//  HttpRequestHelper+RoomQueue.m
//  XCChatCoreKit
//
//  Created by KevinWang on 2018/8/22.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "HttpRequestHelper+RoomQueue.h"
#import "AuthCore.h"
#import "UserCore.h"
#import "ImRoomCoreV2.h"

@implementation HttpRequestHelper (RoomQueue)


/**
 房间坑位开启倒计时
 
 @param position 坑位索引
 @param seconds  倒计时时长(单位秒)
 */
+ (void)requestOpenMic:(int)position
            serveTimer:(int)seconds
               success:(void (^)(void))success
               failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    
    NSString *method = @"room/mic/countdown/start";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params safeSetObject:@(GetCore(ImRoomCoreV2).currentRoomInfo.uid) forKey:@"roomUid"];
    [params safeSetObject:GetCore(AuthCore).getUid forKey:@"uid"];
    [params safeSetObject:GetCore(AuthCore).getUid forKey:@"targetUid"];
    [params safeSetObject:@(position) forKey:@"position"];
    [params safeSetObject:@(seconds) forKey:@"seconds"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        
        success();
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

/**
 房间坑位停止倒计时
 
 @param position 坑位索引
 */
+ (void)requestCloseMicServeTimer:(UserID)uid
                         position:(int)position
                          success:(void (^)(void))success
                          failure:(void (^)(NSNumber * _Nonnull, NSString * _Nonnull))failure{
    
    NSString *method = @"room/mic/countdown/stop";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params safeSetObject:@(GetCore(ImRoomCoreV2).currentRoomInfo.uid) forKey:@"roomUid"];
    [params safeSetObject:GetCore(AuthCore).getUid forKey:@"uid"];
    [params safeSetObject:[NSString stringWithFormat:@"%lld",uid] forKey:@"targetUid"];
    [params safeSetObject:@(position) forKey:@"position"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        
        success();
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
    
}

/// 通过接口上麦
/// @param micUid 麦位用户uid
/// @param roomUid 房间uid
/// @param position 坑位
/// @param reconnect 是否是重连上麦
/// @param success 成功
/// @param failure  失败
+ (void)onUpRoomMic:(UserID)micUid roomUid:(NSInteger)roomUid reconnect:(BOOL)reconnect position:(NSInteger)position success:(void (^)(BOOL success))success failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString *method = @"room/mic/upRoomMic";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params safeSetObject:@(micUid) forKey:@"micUid"];
    [params safeSetObject:@(roomUid) forKey:@"roomUid"];
    [params safeSetObject:@(position) forKey:@"position"];
    [params safeSetObject:@(reconnect) forKey:@"reconnect"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        if (success) {
            success(YES);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

/// 通过接口下麦
/// @param micUid 麦位用户uid
/// @param roomUid 房间uid
/// @param position 坑位
/// @param kickMicType  抱下麦类型(1 -- 房间抱下麦, 2 -- 拉黑报下麦, 3-- 踢出房间)
/// @param outRoom 是否是退出房间下麦
/// @param success 成功
/// @param failure  失败
+ (void)onDownRoomMic:(UserID)micUid roomUid:(NSInteger)roomUid position:(NSInteger)position kickMicType:(NSInteger)kickMicType outRoom:(BOOL)outRoom success:(void (^)(BOOL success))success failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString *method = @"room/mic/downRoomMic";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params safeSetObject:@(micUid) forKey:@"micUid"];
    [params safeSetObject:@(roomUid) forKey:@"roomUid"];
    [params safeSetObject:@(position) forKey:@"position"];
    [params safeSetObject:@(kickMicType) forKey:@"kickMicType"];
    [params safeSetObject:@(outRoom) forKey:@"outRoom"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        if (success) {
            success(YES);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

@end
