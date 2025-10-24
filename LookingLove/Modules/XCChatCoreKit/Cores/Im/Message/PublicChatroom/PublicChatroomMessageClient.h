//
//  PublicChatroomMessageClient.h
//  XCChatCoreKit
//
//  Created by 卫明 on 2018/11/1.
//

#import <Foundation/Foundation.h>

#import <NIMSDK/NIMSDK.h>
//att
#import "GiftAllMicroSendInfo.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PublicChatroomMessageClient <NSObject>
@optional
/**
 公聊大厅有新的消息
 
 @param message 消息数组
 */
- (void)onPublicChatroomMessageUpdate:(NIMMessage *)message;

/**
 发送聊天室消息成功

 @param message 消息
 */
- (void)onSendPublicChatroomMessageComplete:(NIMMessage *)message;

/**
 获取聊天室历史消息成功

 @param messages 消息数组
 @param startTime 起始时间
 @param count 数量
 */
- (void)onFetchHistoryMessageSuccess:(NSArray<NIMMessage *> *)messages
                           startTime:(NSTimeInterval)startTime
                               count:(NSInteger)count;


/**
 收到礼物消息

 @param giftInfo 礼物
 */
- (void)onReceiveGiftInPublicChatRoom:(GiftAllMicroSendInfo *)giftInfo;

@end

NS_ASSUME_NONNULL_END
