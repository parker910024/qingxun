//
//  GiftCore.h
//  BberryCore
//
//  Created by chenran on 2017/7/13.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "BaseCore.h"
#import "GiftInfo.h"
#import "UserInfo.h"
#import "GiftAllMicroSendInfo.h"
#import <NIMSDK/NIMSDK.h>

extern NSString * const luckyAllMicroKey;
extern NSString * const kPagerKer;

@interface GiftCore : BaseCore

/**
 请求普通礼物列表
 */
- (void)requestGiftList;

/**
 请求房间礼物列表 (普通礼物 + 房间专属礼物)
 */
- (void)requestGiftListWithRoomUid:(NSInteger)roomUid;

/**
 开箱子 爆全麦

 @param recordId 中奖记录id
 @param targetUids 接收人ids
 @param roomUid 房主id
 @param code 验证码
 */
- (void)sendBoxAllMicGiftRecordId:(NSInteger)recordId
                       targetUids:(NSString *)targetUids
                          roomUid:(NSInteger)roomUid
                             code:(NSString *)code;

/**
 发送 私聊 福袋 礼物
 
 @param giftInfo 福袋礼物
 @param info 被赠送人
 @param targetUid 被赠送人uid
 */
- (void)sendChatLuckyGift:(GiftInfo *)giftInfo info:(UserInfo *)info targetUid:(UserID)targetUid;

/**
 发送 房间 福袋 礼物 一对一

 @param giftInfo 福袋礼物
 @param targetUid 被赠送人uid
 */
- (void)sendRoomLuckyGift:(GiftInfo *)giftInfo targetUid:(UserID)targetUid;


/**
 发送 房间全麦 福袋礼物

 @param uids 麦上用户
 @param uidsArray 麦上用户uid数组
 @param giftInfo 福袋礼物
 @param roomUid 房主id
 */
- (void)sendAllMicroLuckyGiftByUids:(NSString *)uids
                          uidsArray:(NSArray *)uidsArray
                           giftInfo:(GiftInfo *)giftInfo
                            roomUid:(NSInteger)roomUid;

- (void)sendChatGift:(NSInteger)giftID
        gameGiftType:(GameRoomGiftType)gameGiftType
                info:(UserInfo *)info
             giftNum:(NSInteger)giftNum
           targetUid:(UserID)targetUid
                 msg:(NSString *)msg;

- (void)sendRoomGift:(NSInteger)giftId
        gameGiftType:(GameRoomGiftType)gameGiftType
           targetUid:(UserID)targetUid
                type:(SendGiftType)type
             giftNum:(NSInteger)giftNum
                 msg:(NSString *)msg;

//有了礼物背包的情况下 传一个新的类型 不改变以前的方法 在原来的方法上 重新写一个方法（防止出问题）
- (void)sendChatGift:(NSInteger)giftID
                info:(UserInfo *)info
             giftNum:(NSInteger)giftNum
        gameGiftType:(GameRoomGiftType)gameGiftType
           targetUid:(UserID)targetUid
                 msg:(NSString *)msg;

//公聊大厅送礼物
- (void)sendPublicChatGift:(NSInteger)giftID
                   giftNum:(NSInteger)giftNum
              gameGiftType:(GameRoomGiftType)gameGiftType
                 targetUid:(UserID)targetUid
                       msg:(NSString *)msg;

- (void)sendRoomGift:(NSInteger)giftId
            targetUid:(UserID)targetUid
                 type:(SendGiftType)type
              giftNum:(NSInteger)giftNum
                  msg:(NSString *)msg;

- (void)sendAllMicroGiftByUids:(NSString *)uids
                    microCount:(NSInteger)microCount
                      giftId:(NSInteger)giftId
                      gameGiftType:(GameRoomGiftType)gameGiftType
                     giftNum:(NSInteger)giftNum
                     roomUid:(NSInteger)roomUid
                         msg:(NSString *)msg;

/**
 兔兔统一送礼物接口, 兼容 房间/私聊/公聊大厅 送 单人/多人/全麦 的 普通/萝卜/背包/贵族礼物

 @param uids 收礼人uids
 @param microCount 收礼人数 背包礼物时使用
 @param giftInfo 礼物
 @param gameGiftType 礼物类型 (普通/贵族/背包)
 @param gameRoomSendType 赠送类型
 @param gameRoomSendGiftType 送礼物的类型(单人/多人/全麦)
 @param giftNum 礼物数量
 @param roomUid 房间uid 在房间时需要传
 @param msg 喊话内容
 */
- (void)sendGiftByUids:(NSString *)uids
            microCount:(NSInteger)microCount
              giftInfo:(GiftInfo *)giftInfo
          gameGiftType:(GameRoomGiftType)gameGiftType
      gameRoomSendType:(GameRoomSendType)gameRoomSendType
  gameRoomSendGiftType:(GameRoomSendGiftType)gameRoomSendGiftType
               giftNum:(NSInteger)giftNum
               roomUid:(NSInteger)roomUid
                   msg:(NSString *)msg;

/**
 群聊送礼物 添加了一个群聊的id
 
 其他的和上面的 一致
 */
- (void)sendGiftByUids:(NSString *)uids
            microCount:(NSInteger)microCount
              giftInfo:(GiftInfo *)giftInfo
          gameGiftType:(GameRoomGiftType)gameGiftType
      gameRoomSendType:(GameRoomSendType)gameRoomSendType
  gameRoomSendGiftType:(GameRoomSendGiftType)gameRoomSendGiftType
               giftNum:(NSInteger)giftNum
               roomUid:(NSInteger)roomUid
                   msg:(NSString *)msg
             sessionId:(nullable NSString *)sessionId;


- (GiftInfo *)findGiftInfoByGiftId:(NSInteger)giftId;
- (GiftInfo *)findPrizeGiftByGiftId:(NSInteger)giftId;

/**
 获取游戏房礼物
 type： GameRoomGiftType（普通礼物&贵族礼物）
 */
- (NSMutableArray *)getGameRoomGiftType:(GameRoomGiftType)type;

/**
 根据type获取房间普通礼物(萝卜+普通+房间专属) 或者 贵族礼物

 @param type （普通礼物&贵族礼物）
 @param roomUid 房间uid 传0则 普通礼物(萝卜+普通) 或者 贵族礼物
 @return 礼物数组
 */
- (NSMutableArray *)getGameRoomGiftType:(GameRoomGiftType)type roomUid:(NSInteger)roomUid;

/**
 获取背包礼物
 */
- (void)getPackGift;

/// 获取盲盒开启的礼物列表
- (RACSignal *)getPrizeGiftList;

/**
 获取gameRoom房礼物

 @return 数组
 */
- (NSMutableArray *_Nullable)getGameRoomGift;

/**
 自己发送自定义消息的时候，因为自己是收不到自己发送的自定义消息的，这里用来模拟自己收到一条自定义消息

 @param msg 消息实体
 */
- (void)onRecvChatRoomCustomMsg:(NIMMessage *)msg;

/**
 自己发送自定义消息的时候，因为自己是收不到自己发送的自定义消息的，这里用来模拟自己收到一条自定义消息
 
 @param msg 消息实体
 */
- (void)onRecvP2PCustomMsg:(NIMMessage *)msg;


/**
 测试用拼命发礼物
 */
- (void)startGiftTimer;
- (void)cancelGiftTimer;
@end
