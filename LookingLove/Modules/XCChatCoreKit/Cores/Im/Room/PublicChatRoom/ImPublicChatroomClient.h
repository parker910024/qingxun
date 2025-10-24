//
//  PublicChatroomClient.h
//  XCChatCoreKit
//
//  Created by 卫明 on 2018/11/1.
//

#import <Foundation/Foundation.h>

#import <NIMSDK/NIMSDK.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ImPublicChatroomClient <NSObject>
@optional
/**
 公聊大厅被踢消息
 
 @param reason 原因枚举
 */
- (void)onPublicChatroomWasKickedWithReason:(NIMChatroomKickReason)reason;


/**
 进入公聊大厅成功

 @param chatroom 公聊大厅实体
 */
- (void)onPublicChatRoomSuccess:(NIMChatroom *)chatroom;

@end

NS_ASSUME_NONNULL_END
