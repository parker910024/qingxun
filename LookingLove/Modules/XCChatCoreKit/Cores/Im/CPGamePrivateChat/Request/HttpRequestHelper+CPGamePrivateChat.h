//
//  HttpRequestHelper+CPGamePrivateChat.h
//  XCChatCoreKit
//
//  Created by new on 2019/2/20.
//  Copyright © 2019 KevinWang. All rights reserved.
//

#import "HttpRequestHelper.h"
#import "CPGameListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HttpRequestHelper (CPGamePrivateChat)

/**
 请求游戏开始链接
 
 @param uid 发起人uid
 @param name 发起人昵称
 @param receiveUid 被邀请人uid
 @param receiveName 被邀请人昵称
 @param gameId 游戏id
 @param channelId 厂商id
 @param messageId 消息id
 @param success 成功
 @param failure 失败
 */
+ (void)requestGameUrlFromPrivateChatUid:(UserID )uid Name:(NSString *)name ReceiveUid:(UserID )receiveUid ReceiveName:(NSString *)receiveName GameId:(NSString *)gameId ChannelId:(NSString *)channelId MessageId:(NSString *)messageId success:(void(^)(NSDictionary *dataDict))success failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/**
 请求IM私聊游戏列表
 
 @param uid  本人的uid
 @param success 成功
 @param failure 失败
 */

+ (void)requestCPGamePrivateChatList:(UserID )uid PageNum:(NSInteger )num PageSize:(NSInteger )size success:(void (^)(NSArray *list))success failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 请求IM公聊和多人房游戏列表
 
 @param uid  本人的uid
 @param success 成功
 @param failure 失败
 */
+ (void)requestCPGamePublicChatAndNormalRoomList:(UserID )uid PageNum:(NSInteger )num PageSize:(NSInteger )size success:(void (^)(NSArray *list))success failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 取消游戏邀请
 
 @param uid 发起人uid
 @param msgIds 要取消的消息多个消息用，隔开例如  1，2，3
 @param success 成功
 @param failure 失败
 */

+ (void)requestCancelGameInviteWith:(UserID )uid MsgIds:(NSString *)msgIds success:(void (^)(BOOL success))success failure:(void (^)(NSNumber *resCode, NSString *message))failure;



/**
 获取观战地址
 
 @param uid 发起人uid
 
 @param gameId 游戏id
 
 @param channelId 渠道id
 
 @param messageId 消息id
 */
+ (void)requestWatchGameWith:(UserID )uid GameId:(NSString *)gameId ChannelId:(NSString *)channelId MessageId:(NSString *)messageId success:(void (^)(NSString *urlString))success failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/**
 获取分享图片
 
 @param uid 发起人uid
 
 @param gameId 游戏id
 
 @param channelId 渠道id
 
 @param messageId 消息id
 */
+ (void)requestSharePictureWith:(NSString *)avatar ErbanNo:(UserID )erbanNo Nick:(NSString *)nick GameResult:(NSString *)gameResult success:(void (^)(NSString *urlString))success failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 游戏详情
@param gameId 游戏id

@param roomUid 房间uid
*/
+ (void)requestGameDetailGameId:(NSString *)gameId roomUid:(UserID)roomUid Success:(void (^)(CPGameListModel *model))success failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/**
 关闭游戏
@param gameId 游戏id

@param roomUid 房间uid
*/
+ (void)requestGameCloseByGameId:(NSString *)gameId roomUid:(UserID)roomUid Success:(void (^)(void))success failure:(void (^)(NSNumber *resCode, NSString *message))failure;
@end

NS_ASSUME_NONNULL_END
