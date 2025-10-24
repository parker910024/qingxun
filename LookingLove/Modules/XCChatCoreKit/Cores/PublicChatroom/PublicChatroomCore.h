//
//  PublicChatroomCore.h
//  XCChatCoreKit
//
//  Created by 卫明 on 2018/11/1.
//

#import "BaseCore.h"
#import <NIMSDK/NIMSDK.h>

#import "PublicChatAtMemberAttachment.h"
//request
#import "HttpRequestHelper+PublicChatroom.h"
#import "XCCPGamePrivateAttachment.h"
#import "XCCPGamePrivateSysNotiAttachment.h"
NS_ASSUME_NONNULL_BEGIN

@interface PublicChatroomCore : BaseCore

/**
 是否能发送消息
 */
@property (nonatomic,assign) BOOL canSenMsg;


/**
 获取“@我“的消息

 @param chatroomId 聊天室ID
 @param count 每页的数量
 @param pageCount 页码
 */
- (void)fetchAtMeMessageByChatroomid:(NSString *)chatroomId
                                  count:(NSInteger)count
                              pageCount:(NSInteger)pageCount
                                success:(void (^)(NSArray<NIMMessage *> *))success
                                failure:(void (^)(NSNumber * _Nonnull, NSString * _Nonnull))failure;



/**
 获取我发送的消息

 @param chatroomId 聊天室ID
 @param count 每页的数量
 @param pageCount 页码
 */
- (void)fetchSendFromMeMessageByChatroomid:(NSString *)chatroomId
                                     count:(NSInteger)count
                                 pageCount:(NSInteger)pageCount
                                   success:(void (^)(NSArray<NIMMessage *> *))success
                                   failure:(void (^)(NSNumber * _Nonnull, NSString * _Nonnull))failure;


/**
 搜索@的人 搜索范围：好友，关注，粉丝

 @param key 关键字
 */
- (void)searchAtFriendNoticeFans:(NSString *)key;


/**
 发送@人的消息

 @param attachment 实体
 */
- (void)onSendPublicChatAtMessage:(PublicChatAtMemberAttachment *)attachment;

/**
 发送文字消息

 @param text 文字
 */
- (void)onSendPublicChatTextMessage:(NSString *)text;


/**
 发送游戏消息
 
 @param attachment 游戏实体
 */
- (void)onSendPublicChatGameMessage:(XCCPGamePrivateAttachment *)attachment;

- (void)onSendPublicChatGameOverMessage:(XCCPGamePrivateSysNotiAttachment *)attachment;

/**
 公聊大厅禁言
 
 @param targetUid 禁言用户uid
 @param duration 禁言时间(秒)
 @param remark 禁言原因
 */
- (void)publicChatRoomNotMessage:(UserID)targetUid
                        duration:(int)duration
                          remark:(NSString *)remark;
@end

NS_ASSUME_NONNULL_END
