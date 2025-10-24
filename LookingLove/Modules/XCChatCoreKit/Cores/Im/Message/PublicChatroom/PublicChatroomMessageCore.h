//
//  PublicChatroomMessageCore.h
//  XCChatCoreKit
//
//  Created by 卫明 on 2018/11/1.
//

#import "BaseCore.h"

NS_ASSUME_NONNULL_BEGIN

@interface PublicChatroomMessageCore : BaseCore

/**
 获取聊天室历史消息

 @param chatroomId 公聊大厅ID
 @param count 数量
 */
- (void)fetchHistoryMessageByChatroomId:(NSString *)chatroomId
                                  count:(NSInteger)count
                              startTime:(NSTimeInterval)startTime;

@end

NS_ASSUME_NONNULL_END
