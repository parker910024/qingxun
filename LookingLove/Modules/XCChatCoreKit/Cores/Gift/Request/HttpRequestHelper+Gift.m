//
//  HttpRequestHelper+Gift.m
//  BberryCore
//
//  Created by chenran on 2017/7/13.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "HttpRequestHelper+Gift.h"
#import "GiftInfo.h"
#import "AuthCore.h"
#import "ImRoomCoreV2.h"
#import "BalanceInfo.h"
#import "GiftAllMicroSendInfo.h"
#import "GiftReceiveAllMicroLuckInfo.h"
#import "ImRoomCoreV2.h"
#import "ImPublicChatroomCore.h"
#import "DESEncrypt.h"
#import "NSString+JsonToDic.h"

@implementation HttpRequestHelper (Gift)



/**
 开箱子 爆全麦 礼物
 
 @param recordId 中奖记录id
 @param targetUids 接收人ids
 @param roomUid 房主id
 @param code 验证码
 @param success 礼物数据
 @param failure 失败
 */
+ (void)sendBoxAllMicroGiftRecordId:(NSInteger)recordId
                        targetUids:(NSString *)targetUids
                            roomUid:(NSInteger)roomUid
                               code:(NSString *)code
                            success:(void (^)(GiftAllMicroSendInfo *info))success
                            failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"gift/sendWholeMicroGift";
    UserID uid = [GetCore(AuthCore) getUid].userIDValue;
    NSString *ticket = [GetCore(AuthCore) getTicket];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(recordId) forKey:@"recordId"];
    [params setObject:targetUids forKey:@"targetUids"];
    [params setObject:@(uid) forKey:@"uid"];
    [params setObject:ticket forKey:@"ticket"];
    [params setObject:@(roomUid) forKey:@"roomUid"];
    [params setObject:code forKey:@"code"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        
        GiftAllMicroSendInfo *info = [GiftAllMicroSendInfo modelWithJSON:data];
        success(info);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}


/**
 发送 福袋 礼物
 
 @param giftId 礼物id
 @param targetUid 对方id
 @param type 送礼场景 1聊天室刷礼物，2一对一送礼物
 @param success 成功
 @param failure 失败
 */
+ (void)sendLuckyGift:(NSInteger)giftId
            targetUid:(UserID)targetUid
                 type:(SendGiftType)type
              success:(void (^)(GiftAllMicroSendInfo *info))success
              failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"gift/sendV3";
    UserID uid = [GetCore(AuthCore) getUid].userIDValue;
    NSString *ticket = [GetCore(AuthCore) getTicket];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(giftId) forKey:@"giftId"];
    [params setObject:@(targetUid) forKey:@"targetUid"];
    [params setObject:@(uid) forKey:@"uid"];
    [params setObject:@(type) forKey:@"type"];
    [params setObject:ticket forKey:@"ticket"];
    [params setObject:@(1) forKey:@"giftNum"];
    [params setObject:@(GiftType_Lucky) forKey:@"giftType"];
    
    NSInteger roomUid = GetCore(ImRoomCoreV2).currentRoomInfo.uid;
    [params setObject:@(roomUid) forKey:@"roomUid"];
    
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        
        GiftAllMicroSendInfo *info = [GiftAllMicroSendInfo modelWithJSON:data];
        success(info);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}
/**
 发送全麦 福袋 礼物
 
 @param targetUids 接受礼物方 id，id 隔开
 @param giftId 礼物id
 @param roomUid 房间uid
 @param success 成功
 @param failure 失败
 */
+ (void) sendAllMicroLuckyGiftByUids:(NSString *)targetUids
                         giftId:(NSInteger)giftId
                        roomUid:(NSInteger)roomUid
                        success:(void (^)(NSArray<GiftReceiveInfo*> *infoArray))success
                        failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    
    NSString *method = @"gift/sendLuckyBagToWholeMicro";
    NSString *uid = [GetCore(AuthCore)getUid];
    NSString *ticket = [GetCore(AuthCore)getTicket];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:uid forKey:@"uid"];
    [params setObject:ticket forKey:@"ticket"];
    [params setObject:targetUids forKey:@"targetUids"];
    [params setObject:@(giftId) forKey:@"giftId"];
    [params setObject:@(1) forKey:@"giftNum"];
    [params setObject:@(roomUid) forKey:@"roomUid"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        
        NSArray *infoArray = [GiftReceiveAllMicroLuckInfo modelsWithArray:data];
        success(infoArray);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

/**
 获取用户礼物背包
 
 @param success 成功block
 @param failure 失败block
 */
+ (void)getPackGiftSuccess:(void (^)(NSArray<GiftInfo *> *info))success
                   failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    
    NSString *method = @"backpack/listUserBackpack";
    if (projectType() == ProjectType_Pudding ||
        projectType() == ProjectType_LookingLove ||
        projectType() == ProjectType_Planet) {
        method = @"backpack/listUserBackpackV2";
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *userid = [GetCore(AuthCore)getUid];
    NSString *ticket = [GetCore(AuthCore)getTicket];
    [params setObject:userid forKey:@"uid"];
    [params setObject:ticket forKey:@"ticket"];
    [HttpRequestHelper GET:method params:params success:^(id data) {
        NSArray *giftInfos = [GiftInfo modelsWithArray:data];
        success(giftInfos);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+ (void)sendAllMicroGiftByUids:(NSString *)uids
                        giftId:(NSInteger)giftId
                       giftNum:(NSInteger)giftNum
                gameGiftType:(GameRoomGiftType)gameGiftType
                       roomUid:(NSInteger)roomUid
                           msg:(NSString *)msg
                       success:(void (^)(GiftAllMicroSendInfo *))success
                       failure:(void (^)(NSNumber *, NSString *))failure {
    
    NSString *method = @"gift/sendWholeMicroV3";
    if (gameGiftType == GameRoomGiftType_GiftPack) {
        method = @"gift/sendBackpackGiftToWholeMicro";
    }
    NSString *uid = [GetCore(AuthCore)getUid];
    NSString *ticket = [GetCore(AuthCore)getTicket];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:uid forKey:@"uid"];
    [params setObject:ticket forKey:@"ticket"];
    [params setObject:uids forKey:@"targetUids"];
    [params setObject:@(giftId) forKey:@"giftId"];
    [params setObject:@(giftNum) forKey:@"giftNum"];
    [params setObject:@(roomUid) forKey:@"roomUid"];
    [params safeSetObject:msg forKey:@"msg"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {

        GiftAllMicroSendInfo *info = [GiftAllMicroSendInfo modelWithJSON:data];
        success(info);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
    
}


//旧版本礼物
+ (void)sendGift:(NSInteger)giftId
       targetUid:(UserID)targetUid
         giftNum:(NSInteger)giftNum
            type:(SendGiftType)type
             msg:(NSString *)msg
         success:(void (^)(GiftAllMicroSendInfo *info))success
         failure:(void (^)(NSNumber *, NSString *))failure {
    
    UserID uid = [GetCore(AuthCore) getUid].userIDValue;
    NSString *ticket = [GetCore(AuthCore) getTicket];
    NSString *method = @"gift/sendV3";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(giftId) forKey:@"giftId"];
    [params setObject:@(targetUid) forKey:@"targetUid"];
    [params setObject:@(uid) forKey:@"uid"];
    [params setObject:@(type) forKey:@"type"];
    [params setObject:ticket forKey:@"ticket"];
    [params setObject:msg forKey:@"msg"];
    if (giftNum == 0) {
        [params setObject:@(1) forKey:@"giftNum"];
    }else {
        [params setObject:@(giftNum) forKey:@"giftNum"];
    }
    
    if (type!=2) {
        NSInteger roomUid = GetCore(ImRoomCoreV2).currentRoomInfo.uid;
        [params setObject:@(roomUid) forKey:@"roomUid"];
    }
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        GiftAllMicroSendInfo *info = [GiftAllMicroSendInfo yy_modelWithJSON:data];
        success(info);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}


+ (void)sendGift:(NSInteger)giftId
       targetUid:(UserID)targetUid
         giftNum:(NSInteger)giftNum
    gameGiftType:(GameRoomGiftType)gameGiftType
            type:(SendGiftType)type
             msg:(NSString *)msg
         success:(void (^)(GiftAllMicroSendInfo *info))success
         failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"gift/sendV3";
    
    if(gameGiftType == GameRoomGiftType_GiftPack){
        method = @"gift/sendBackpackGift";
    }
    UserID uid = [GetCore(AuthCore) getUid].userIDValue;
    NSString *ticket = [GetCore(AuthCore) getTicket];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(giftId) forKey:@"giftId"];
    [params setObject:@(targetUid) forKey:@"targetUid"];
    [params setObject:@(uid) forKey:@"uid"];
    [params setObject:@(type) forKey:@"type"];
    [params setObject:ticket forKey:@"ticket"];
    [params safeSetObject:msg forKey:@"msg"];
    
    if (giftNum == 0) {
        [params setObject:@(1) forKey:@"giftNum"];
    }else {
        [params setObject:@(giftNum) forKey:@"giftNum"];
    }
    if (type == SendGiftType_RoomToPerson) {
        NSInteger roomUid = GetCore(ImRoomCoreV2).currentRoomInfo.uid;
        [params setObject:@(roomUid) forKey:@"roomUid"];
    }
    
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        
        GiftAllMicroSendInfo *info = [GiftAllMicroSendInfo modelWithJSON:data];
        success(info);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+ (void)requestGiftList:(void (^)(NSArray *))success failure:(void (^)(NSNumber *, NSString *))failure
{
    [self requestGiftListWithRoomUid:0 success:success failure:failure];
}

/**
 请求房间礼物列表 (普通礼物 + 房间专属礼物)
 
 @param roomUid 房间uid
 @param success 成功
 @param failure 失败
 */
+ (void)requestGiftListWithRoomUid:(NSInteger)roomUid
                           success:(void (^)(NSArray *))success
                           failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString *method = @"gift/listV4";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(roomUid) forKey:@"roomUid"];
    [params safeSetObject:@"1,2,3,4" forKey:@"consumeTypes"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        NSArray *listData = data[@"gift"];
        NSArray *giftInfos = [GiftInfo modelsWithArray:listData];
        success(giftInfos);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+(void)sendGift:(NSInteger)giftId
      targetUid:(UserID)targetUid
           type:(SendGiftType)type
        success:(void (^)(void))success
        failure:(void (^)(NSNumber *, NSString *))failure
{
    UserID uid = [GetCore(AuthCore) getUid].userIDValue;
    NSString *ticket = [GetCore(AuthCore) getTicket];
    NSString *method = @"gift/send";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(giftId) forKey:@"giftId"];
    [params setObject:@(targetUid) forKey:@"targetUid"];
    [params setObject:@(uid) forKey:@"uid"];
    [params setObject:@(type) forKey:@"type"];
    [params setObject:ticket forKey:@"ticket"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success();
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+ (void)sendPublicChatGift:(NSInteger)giftId
                 targetUid:(UserID)targetUid
                   giftNum:(NSInteger)giftNum
                       msg:(NSString *)msg
             gameGiftType:(GameRoomGiftType)gameGiftType
                   success:(void (^)(GiftAllMicroSendInfo *info))success
                   failure:(void (^)(NSNumber *, NSString *))failure {
    
    UserID uid = [GetCore(AuthCore) getUid].userIDValue;
    NSString *ticket = [GetCore(AuthCore) getTicket];
    NSString *method = @"gift/sendV3";
    if (gameGiftType == GameRoomGiftType_GiftPack) {
        method = @"gift/sendBackpackGift";
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(giftId) forKey:@"giftId"];
    [params setObject:@(targetUid) forKey:@"targetUid"];
    [params setObject:@(uid) forKey:@"uid"];
    [params setObject:@(GiftType_PublicChat) forKey:@"type"];
    [params setObject:ticket forKey:@"ticket"];
    [params safeSetObject:msg forKey:@"msg"];
    if (giftNum == 0) {
        [params setObject:@(1) forKey:@"giftNum"];
    }else {
        [params setObject:@(giftNum) forKey:@"giftNum"];
    }
    
    [params safeSetObject:@(GetCore(ImPublicChatroomCore).publicChatroomUid) forKey:@"roomUid"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        GiftAllMicroSendInfo *info = [GiftAllMicroSendInfo yy_modelWithJSON:data];
        success(info);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

//发送背包礼物给个人（有了背包礼物就用这个接口）
+ (void)sendGift:(NSInteger)giftId
       targetUid:(UserID)targetUid
         giftNum:(NSInteger)giftNum
            type:(SendGiftType)type
             msg:(NSString *)msg
    gameGiftType:(GameRoomGiftType)gameGiftType
         success:(void (^)(GiftAllMicroSendInfo *info))success
         failure:(void (^)(NSNumber *, NSString *))failure {
    
    UserID uid = [GetCore(AuthCore) getUid].userIDValue;
    NSString *ticket = [GetCore(AuthCore) getTicket];
    NSString *method = @"gift/sendV3";
    if (gameGiftType == GameRoomGiftType_GiftPack) {
        method = @"gift/sendBackpackGift";
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(giftId) forKey:@"giftId"];
    [params setObject:@(targetUid) forKey:@"targetUid"];
    [params setObject:@(uid) forKey:@"uid"];
    [params setObject:@(type) forKey:@"type"];
    [params setObject:ticket forKey:@"ticket"];
    [params setObject:msg forKey:@"msg"];
    if (giftNum == 0) {
        [params setObject:@(1) forKey:@"giftNum"];
    }else {
        [params setObject:@(giftNum) forKey:@"giftNum"];
    }
    
    if (type!=2) {
        NSInteger roomUid = GetCore(ImRoomCoreV2).currentRoomInfo.uid;
        [params setObject:@(roomUid) forKey:@"roomUid"];
    }
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        GiftAllMicroSendInfo *info = [GiftAllMicroSendInfo yy_modelWithJSON:data];
        success(info);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

/**
 兔兔统一送礼物接口, 兼容 房间/私聊/公屏 送 单人/多人/全麦 的 普通/萝卜/背包/贵族礼物
 
 @param targetUids 收礼人uids
 @param giftId 礼物id
 @param gameGiftType 礼物类型 (普通/贵族/背包)
 @param gameRoomSendType 赠送类型
 @param giftNum 礼物数量
 @param roomUid 房间uid 在房间时需要传
 @param msg 喊话内容
 */
+ (void)sendGiftByUids:(NSString *)targetUids
                giftId:(NSInteger)giftId
          gameGiftType:(GameRoomGiftType)gameGiftType
      gameRoomSendType:(GameRoomSendType)gameRoomSendType
               giftNum:(NSInteger)giftNum
               roomUid:(NSInteger)roomUid
                   msg:(NSString *)msg
             sessionId:(nullable NSString *)sessionId
               success:(void (^)(GiftAllMicroSendInfo *info, NSDictionary *dict))success
               failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"gift/sendV4";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:GetCore(AuthCore).getUid forKey:@"uid"];
    [params setObject:@(giftId) forKey:@"giftId"];
    [params setObject:targetUids forKey:@"targetUids"];
    [params setObject:msg forKey:@"msg"];
    [params setObject:@(gameRoomSendType) forKey:@"sendType"];
    if (giftNum == 0) {
        [params setObject:@(1) forKey:@"giftNum"];
    } else {
        [params setObject:@(giftNum) forKey:@"giftNum"];
    }
    
    if (gameGiftType == GameRoomGiftType_GiftPack) {
        [params setObject:@"2" forKey:@"giftSource"];
    } else {
        [params setObject:@"1" forKey:@"giftSource"];
    }
    
    if (gameRoomSendType == GameRoomSendType_PublicChat) {
        [params safeSetObject:@(GetCore(ImPublicChatroomCore).publicChatroomUid) forKey:@"roomUid"];
    } else {
        if (roomUid != 0) {
            [params setObject:@(roomUid) forKey:@"roomUid"];
        }
    }
    
    if (gameRoomSendType == GameRoomSendType_Team) {
        [params setObject:sessionId forKey:@"chatSessionId"];
    }
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
//        NSString *json = [DESEncrypt decryptUseDES:data[@"encryptInfo"] key:@"10fwg656bccqfi6s52t7nnvfkk9sksdf"];
//        NSDictionary *response = [NSString dictionaryWithJsonString:json];
        GiftAllMicroSendInfo *info = [GiftAllMicroSendInfo modelDictionary:data];
    
        if ([data isKindOfClass:[NSDictionary class]]) {
            if (success) {
                success(info, data);
            }
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+ (void)requestPrizeGiftListAndCompletionHandler:(HttpRequestHelperCompletion)completionHandler {
    NSString *method = @"gift/list/prize";
    
    [self request:method
           method:HttpRequestHelperMethodGET
           params:@{}
       completion:completionHandler];
}

@end
