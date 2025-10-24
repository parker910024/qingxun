//
//  HttpRequestHelper+RoomMagic.m
//  BberryCore
//
//  Created by Mac on 2018/3/16.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "HttpRequestHelper+RoomMagic.h"
#import "AuthCore.h"

#import "RoomMagicInfo.h"
#import "RoomMagicWallInfo.h"

@implementation HttpRequestHelper (RoomMagic)

+ (void)requestRoomMagicList:(void (^)(NSArray *))success
                     failure:(void (^)(NSNumber *, NSString *))failure{
    NSString *method = @"giftmagic/list";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {

        NSArray *roomMagicInfos = [RoomMagicInfo modelsWithArray:data];

        success(roomMagicInfos);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+ (void)requesrPersonMagicListWithUid:(UserID)uid success:(void (^)(NSArray *))success
                              failure:(void (^)(NSNumber *, NSString *))failure{
    NSString *method = @"magicwall/get";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:[NSString stringWithFormat:@"%lld",uid] forKey:@"uid"];
    [params safeSetObject:@"1" forKey:@"orderType"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {

        NSArray *roomMagicInfos = [RoomMagicWallInfo modelsWithArray:data];
        success(roomMagicInfos);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}


/**
 房间内赠送多人魔法

 @param targetUids 接受者的uid
 @param magicId 魔法的id
 @param roomUid 房间的id
 @param success 成功的回调
 @param failure 失败的回调
 */
+ (void)sendBatchMagicByUids:(NSString *)targetUids
                        magicId:(NSInteger)magicId
                        roomUid:(NSInteger)roomUid
                        success:(void (^)(RoomMagicInfo *info, NSDictionary *dataM))success
                        failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    
    NSString *method = @"giftmagic/v1/batch/send";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params safeSetObject:targetUids forKey:@"targetUids"];
    [params safeSetObject:@(magicId) forKey:@"giftMagicId"];
    [params safeSetObject:@(roomUid) forKey:@"roomUid"];
    [params safeSetObject:[GetCore(AuthCore) getTicket] forKey:@"ticket"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        
        RoomMagicInfo *roomMagicInfo = [RoomMagicInfo modelWithJSON:data];
        
        NSMutableDictionary *dataM = [NSMutableDictionary dictionaryWithDictionary:data];
        success(roomMagicInfo, dataM);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}


+ (void)sendAllMicroMagicByUids:(NSString *)targetUids
                        magicId:(NSInteger)magicId
                        roomUid:(NSInteger)roomUid
                        success:(void (^)(RoomMagicInfo *info))success
                        failure:(void (^)(NSNumber *resCode, NSString *message))failure{

    NSString *method = @"giftmagic/v1/send/wholemicro";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params safeSetObject:targetUids forKey:@"targetUids"];
    [params safeSetObject:@(magicId) forKey:@"giftMagicId"];
    [params safeSetObject:@(roomUid) forKey:@"roomUid"];
    [params safeSetObject:[GetCore(AuthCore) getTicket] forKey:@"ticket"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {

        RoomMagicInfo *roomMagicInfo = [RoomMagicInfo modelWithJSON:data];

        success(roomMagicInfo);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}


+ (void)sendMaigc:(NSInteger)magicId
        targetUid:(UserID)targetUid
          roomUid:(NSInteger)roomUid
          success:(void (^)(RoomMagicInfo *info))success
          failure:(void (^)(NSNumber *resCode, NSString *message))failure{

    NSString *method = @"giftmagic/v1/send/single";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params safeSetObject:@(targetUid) forKey:@"targetUid"];
    [params safeSetObject:@(magicId) forKey:@"giftMagicId"];
    [params safeSetObject:@(roomUid) forKey:@"roomUid"];
    [params safeSetObject:[GetCore(AuthCore) getTicket] forKey:@"ticket"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {

        RoomMagicInfo *roomMagicInfo = [RoomMagicInfo modelWithJSON:data];
        success(roomMagicInfo);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

@end
