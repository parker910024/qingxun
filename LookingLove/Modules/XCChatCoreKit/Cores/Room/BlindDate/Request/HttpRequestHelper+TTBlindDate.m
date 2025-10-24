//
//  HttpRequestHelper+TTBlindDate.m
//  WanBan
//
//  Created by jiangfuyuan on 2020/10/20.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import "HttpRequestHelper+TTBlindDate.h"
#import "AuthCore.h"

@implementation HttpRequestHelper (TTBlindDate)

/// 更新相亲流程 
/// @param roomUid 房间uid
/// @param uid 用户uid
/// @param position 用户麦位
/// @param procedure   当前流程  流程(1 -- 自我介绍, 2 -- 心动选择, 3 -- 心动公布, 4 -- 重新自我介绍)
/// @param success 成功
/// @param failure 失败
+ (void)updateLoveRoomProcedureWithRoomUid:(UserID)roomUid uid:(UserID)uid position:(NSInteger)position procedure:(NSInteger)procedure success:(void(^)(BOOL success))success failure:(void(^)(NSNumber * resCode, NSString * message))failure {
    
    NSString *method = @"room/blindDate/updateProcedure";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(roomUid) forKey:@"roomUid"];
    [params setObject:@(uid) forKey:@"uid"];
    [params setObject:@(position) forKey:@"position"];
    [params setObject:@(procedure) forKey:@"procedure"];
    [params setObject:GetCore(AuthCore).getTicket forKey:@"ticket"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success(YES);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode,message);
    }];
}

/// 相亲房上麦
/// @param roomUid 房间uid
/// @param uid 用户uid
/// @param position 用户麦位
+ (void)requestLoveRoomUpMicWithRoomUid:(UserID)roomUid uid:(UserID)uid position:(NSInteger)position success:(void(^)(BOOL success))success failure:(void(^)(NSNumber * resCode, NSString * message))failure {
    NSString *method = @"room/blindDate/up/mic";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(roomUid) forKey:@"roomUid"];
    [params setObject:@(uid) forKey:@"uid"];
    [params setObject:@(position) forKey:@"position"];
    [params setObject:GetCore(AuthCore).getTicket forKey:@"ticket"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success(YES);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode,message);
    }];
}

/// 相亲房下麦
/// @param roomUid 房间uid
/// @param uid 用户uid
/// @param position 用户麦位
+ (void)requestLoveRoomDownMicWithRoomUid:(UserID)roomUid uid:(UserID)uid position:(NSInteger)position success:(void(^)(BOOL success))success failure:(void(^)(NSNumber * resCode, NSString * message))failure {
    
    NSString *method = @"room/blindDate/down/mic";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(roomUid) forKey:@"roomUid"];
    [params setObject:@(uid) forKey:@"uid"];
    [params setObject:@(position) forKey:@"position"];
    [params setObject:GetCore(AuthCore).getTicket forKey:@"ticket"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success(YES);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode,message);
    }];
}

/// 相亲房选择心动
/// @param roomUid 房间uid
/// @param uid 用户uid
/// @param position 用户麦位
/// @param choosePosition 选择对象麦位
/// @param chooseUid 选择对象uid
+ (void)requestLoveRoomChooseLoveWithRoomUid:(UserID)roomUid uid:(UserID)uid position:(NSInteger)position choosePosition:(NSInteger)choosePosition chooseUid:(UserID)chooseUid success:(void(^)(BOOL success))success failure:(void(^)(NSNumber * resCode, NSString * message))failure {
    
    NSString *method = @"room/blindDate/choose/guest";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(roomUid) forKey:@"roomUid"];
    [params setObject:@(uid) forKey:@"uid"];
    [params setObject:@(position) forKey:@"position"];
    [params setObject:@(chooseUid) forKey:@"chooseUid"];
    [params setObject:@(choosePosition) forKey:@"choosePosition"];
    [params setObject:GetCore(AuthCore).getTicket forKey:@"ticket"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success(YES);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode,message);
    }];
}

/// 相亲房公布心动
/// @param roomUid 房间uid
/// @param uid 用户uid
/// @param position 用户麦位
/// @param choosePosition 选择对象麦位
/// @param chooseUid 选择对象uid
+ (void)requestLoveRoomPublicLoveWithRoomUid:(UserID)roomUid uid:(UserID)uid position:(NSInteger)position choosePosition:(NSInteger)choosePosition chooseUid:(UserID)chooseUid success:(void(^)(BOOL success))success failure:(void(^)(NSNumber * resCode, NSString * message))failure {
    
    NSString *method = @"room/blindDate/publish";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(roomUid) forKey:@"roomUid"];
    [params setObject:@(uid) forKey:@"uid"];
    [params setObject:@(position) forKey:@"position"];
    [params setObject:@(chooseUid) forKey:@"chooseUid"];
    [params setObject:@(choosePosition) forKey:@"choosePosition"];
    [params setObject:GetCore(AuthCore).getTicket forKey:@"ticket"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success(YES);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode,message);
    }];
}


@end
