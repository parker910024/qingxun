//
//  TTCPGamePrivateChatCore.h
//  TTPlay
//
//  Created by new on 2019/2/19.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "BaseCore.h"
#import "TTMessageDisplayModel.h"
#import "CPGameListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TTCPGamePrivateChatCore : BaseCore

@property (nonatomic, strong) NSTimer *privateTimer;
@property (nonatomic, strong) NSMutableDictionary *myMessageDic;
@property (nonatomic, strong) NSMutableDictionary *youMessageDic;


// 公聊记录我自己发的消息
@property (nonatomic, strong) NSMutableDictionary *publicMyMessageDic;

@property (nonatomic, assign) BOOL publicChatType;

// 多人房
@property (nonatomic, strong) NSMutableDictionary *normalRoomDic;

- (void)storageMessageForNormalRoomGameStatus:(TTMessageDisplayModel *)model;

- (void)startTimer;
/**
 请求游戏开始链接
 
 @param uid 发起人uid
 @param name 发起人昵称
 @param receiveUid 被邀请人uid
 @param receiveName 被邀请人昵称
 @param gameId 游戏id
 @param channelId 厂商id
 @param messageId 消息id
 
 */
- (RACSignal *)requestGameUrlFromPrivateChatUid:(UserID )uid Name:(NSString *)name ReceiveUid:(UserID )receiveUid ReceiveName:(NSString *)receiveName GameId:(NSString *)gameId ChannelId:(NSString *)channelId MessageId:(NSString *)messageId;


/**
 IM私聊游戏列表
 
 @param roomUid 房主uid
 
 */
- (RACSignal *)requestCPGamePrivateChatList:(UserID )uid PageNum:(NSInteger )num PageSize:(NSInteger )size;


/**
 IM公聊和多人房游戏列表
 
 @param roomUid 房主uid
 
 */
- (RACSignal *)requestCPGamePublicChatAndNormalRoomList:(UserID )uid PageNum:(NSInteger )num PageSize:(NSInteger )size;


/**
 取消游戏邀请
 
 @param uid 发起人uid
 
 @param msgIds 要取消的消息多个消息用，隔开例如  1，2，3
 
 */
- (RACSignal *)requestCancelGameInviteWith:(UserID )uid MsgIds:(NSString *)msgIds;


/**
 获取观战地址
 
 @param uid 发起人uid
 
 @param gameId 游戏id
 
 @param channelId 渠道id
 
 @param messageId 消息id
 */
- (RACSignal *)requestWatchGameWith:(UserID )uid GameId:(NSString *)gameId ChannelId:(NSString *)channelId MessageId:(NSString *)messageId;


/**
 获取分享图片
 
 @param uid 发起人uid
 
 @param gameId 游戏id
 
 @param channelId 渠道id
 
 @param messageId 消息id
 */
- (RACSignal *)requestSharePictureWith:(NSString *)avatar ErbanNo:(UserID )erbanNo Nick:(NSString *)nick GameResult:(NSString *)gameResult;


/**
 游戏详情
@param gameId 游戏id

@param roomUid 房间uid
*/
- (void)requestGameDetailGameId:(NSString *)gameId roomUid:(UserID)roomUid Success:(void (^)(CPGameListModel *model))success failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/**
 取消游戏
@param gameId 游戏id

@param roomUid 房间uid
*/
- (void)requestGameCloseByGameId:(NSString *)gameId roomUid:(UserID)roomUid Success:(void (^)(void))success failure:(void (^)(NSNumber *resCode, NSString *message))failure;

@end

NS_ASSUME_NONNULL_END
