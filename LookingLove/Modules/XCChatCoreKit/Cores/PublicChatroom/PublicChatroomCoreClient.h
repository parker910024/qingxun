//
//  PublicCoreClient.h
//  XCChatCoreKit
//
//  Created by 卫明 on 2018/11/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PublicChatroomCoreClient <NSObject>
@optional

/**
 公聊大厅发送消息倒数

 @param countDownNumber 目前倒数的数字
 */
- (void)onPublicChatSenderCountDown:(NSInteger)countDownNumber;

/**
 公聊大厅发送消息倒数 完成
 */
- (void)onPublicChatSenderCountDownFinish;

/**
 搜索@的人 搜索范围：好友，关注，粉丝

 @param searchInfo 搜索结果
 */
- (void)searchAtFriendNoticeFansSuccess:(NSArray *)searchInfo;

/**
 获取“@我”的消息成功

 @param messages 消息
 @param page 页码
 @param count 数量
 */
- (void)fetchAtMessageSuccess:(NSArray *)messages
                         page:(NSInteger)page
                        count:(NSInteger)count;

/**
 获取“@我”的消息失败

 @param message 错误消息
 */
- (void)fetchAtMessageFailure:(NSString *)message;

/**
 获取我发的消息

 @param message 消息
 @param page 页码
 @param count 数量
 */
- (void)fetchMessageSendFromMeSuccess:(NSArray *)message
                                 page:(NSInteger)page
                                count:(NSInteger)count;

/**
 获取我发的消息失败

 @param message 错误消息
 */
- (void)fetchMessageSendFromMeFailure:(NSString *)message;


/**
 禁言成功
 */
- (void)onPublicChatRoomNotMessageSuccess;

@end

NS_ASSUME_NONNULL_END
