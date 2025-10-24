//
//  HttpRequestHelper+Gift.h
//  BberryCore
//
//  Created by chenran on 2017/7/13.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "HttpRequestHelper.h"
#import "BalanceInfo.h"
#import "GiftAllMicroSendInfo.h"
#import "GiftInfo.h"
#import "GiftCore.h"

@interface HttpRequestHelper (Gift)

/**
 发送公聊大厅礼物

 @param giftId 礼物id
 @param targetUid 发送对象
 @param giftNum 礼物数量
 @param msg 喊话消息
 @param gameGiftType 礼物类型
 @param success 成功
 @param failure 失败
 */
+ (void)sendPublicChatGift:(NSInteger)giftId
                 targetUid:(UserID)targetUid
                   giftNum:(NSInteger)giftNum
                       msg:(NSString *)msg
             gameGiftType:(GameRoomGiftType)gameGiftType
                   success:(void (^)(GiftAllMicroSendInfo *info))success
                   failure:(void (^)(NSNumber *, NSString *))failure;

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
                            failure:(void (^)(NSNumber *, NSString *))failure;

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
         failure:(void (^)(NSNumber *, NSString *))failure;

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
                        failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/**
 获取用户礼物背包

 @param success 成功block
 @param failure 失败block
 */
+ (void)getPackGiftSuccess:(void (^)(NSArray<GiftInfo *> *info))success
                   failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 发送全麦礼物
 
 @param uids 接受礼物方 id，id 隔开
 @param giftId 礼物id
 @param giftNum 发送礼物的数量
 @param gameGiftType 礼物类型：1 礼物面板礼物 2.背包礼物
 @param roomUid 房间id
 @param msg 喊话
 @param success 成功
 @param failure 失败
 */
+ (void) sendAllMicroGiftByUids:(NSString *)uids
                        giftId:(NSInteger)giftId
                       giftNum:(NSInteger)giftNum
                  gameGiftType:(GameRoomGiftType)gameGiftType
                       roomUid:(NSInteger)roomUid
                           msg:(NSString *)msg
                       success:(void (^)(GiftAllMicroSendInfo *info))success
                       failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 发送礼物
 
 @param giftId 礼物id
 @param targetUid 对方id
 @param type 送礼场景 1聊天室刷礼物，2一对一送礼物
 @param gameGiftType 礼物类型：1 礼物面板礼物 2.背包礼物
 @param giftNum 发送礼物的数量
 @param success 成功
 @param failure 失败
 */
+ (void)sendGift:(NSInteger)giftId
       targetUid:(UserID)targetUid
         giftNum:(NSInteger)giftNum
    gameGiftType:(GameRoomGiftType)gameGiftType
            type:(SendGiftType)type
             msg:(NSString *)msg
         success:(void (^)(GiftAllMicroSendInfo *info))success
         failure:(void (^)(NSNumber *, NSString *))failure;

/**
 获取礼物列表

 @param success 成功
 @param failure 失败
 */
+ (void)requestGiftList:(void (^)(NSArray *))success
            failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 请求房间礼物列表 (普通礼物 + 房间专属礼物)
 
 @param roomUid 房间uid
 @param success 成功
 @param failure 失败
 */
+ (void)requestGiftListWithRoomUid:(NSInteger)roomUid
                           success:(void (^)(NSArray *))success
                           failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 发送礼物

 @param giftId 礼物id
 @param targetUid 对方id
 @param type 送礼场景1聊天室刷礼物，2一对一送礼物
 @param success 成功
 @param failure 失败
 */
+ (void) sendGift:(NSInteger)giftId
        targetUid:(UserID)targetUid
             type:(SendGiftType)type
          success:(void (^)(void))success
          failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 发送礼物
 
 @param giftId 礼物id
 @param targetUid 对方id
 @param type 送礼场景1聊天室刷礼物，2一对一送礼物
 @param giftNum 发送礼物的数量
 @param success 成功
 @param failure 失败
 */
+ (void)sendGift:(NSInteger)giftId
       targetUid:(UserID)targetUid
         giftNum:(NSInteger)giftNum
            type:(SendGiftType)type
             msg:(NSString *)msg
         success:(void (^)(GiftAllMicroSendInfo *info))success
         failure:(void (^)(NSNumber *, NSString *))failure;

/**
 送背包礼物的
 
 @param giftId 礼物的ID
 @param targetUid 送的那个人的id
 @param giftNum 礼物的个数
 @param type 类型送礼物对象类型。1:轻聊房间、竞拍房间给主播直接刷礼物，2:私聊送个人礼物, 3:坑位房中，给坑位中的人刷礼物
 @param msg 喊话内容
 @param gameGiftType 礼物的类型
 @param success 成功
 @param failure 失败
 */
+ (void)sendGift:(NSInteger)giftId
       targetUid:(UserID)targetUid
         giftNum:(NSInteger)giftNum
            type:(SendGiftType)type
             msg:(NSString *)msg
    gameGiftType:(GameRoomGiftType)gameGiftType
         success:(void (^)(GiftAllMicroSendInfo *info))success
         failure:(void (^)(NSNumber *, NSString *))failure;

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
               failure:(void (^)(NSNumber *, NSString *))failure;

//HTTP
///gift/list/prize
//GET
//获取盲盒奖品礼物列表
/// @param completionHandler 回调
+ (void)requestPrizeGiftListAndCompletionHandler:(HttpRequestHelperCompletion _Nullable )completionHandler;

@end
