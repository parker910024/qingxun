//
//  ImMessageCore.h
//  BberryCore
//
//  Created by chenran on 2017/4/19.
//  Copyright © 2017年 chenran. All rights reserved.
//
#import "BaseCore.h"
#import <Foundation/Foundation.h>
#import <NIMSDK/NIMSDK.h>
#import "GiftReceiveInfo.h"
#import "Attachment.h"

@interface ImMessageCore : BaseCore

@property (strong, nonatomic) dispatch_queue_t attrCreatQueue;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSCache *radiousImageCache;

/**
 获取未读消息数
 */
- (NSInteger)getUnreadCount;

//发送文本消息
- (void) sendTextMessage:(NSString *)text nick:(NSString*)nick sessionId:(NSString *)sessionId type:(NIMSessionType)type;



//发送tip消息-待推送
- (void)sendTipsMessage:(NSDictionary *)attchment
              sessionId:(NSString *)sessionId
                   type:(NIMSessionType)type;
/**
 发送tips的 attachment
 
 @param attachment 第三方实体
 @param sessionId 会话id
 @param type 类型
 */
- (void)sendTipsMessageWithAttachment:(Attachment *)attachment
                            sessionId:(NSString *)sessionId
                                 type:(NIMSessionType)type;


//发送自定义消息
- (void)sendCustomMessageAttachement:(Attachment *)attachment
                           sessionId:(NSString *)sessionId
                                type:(NIMSessionType)type;
//发送自定义消息-带推送
- (void)sendCustomMessageAttachement:(Attachment *)attachment
                           sessionId:(NSString *)sessionId
                                type:(NIMSessionType)type
                            needApns:(BOOL)needApns
                         apnsContent:(NSString *)apnsContent;


/**
 发送自定义消息

 @param attachment 发送附件模型
 @param sessionId 回话ID=UID
 @param type 消息类型
 @param yidunEnabled 是否需要经过易盾
 @param needApns 推送
 @param apnsContent 推送内容
 */
- (void)sendCustomMessageAttachement:(Attachment *)attachment
                           sessionId:(NSString *)sessionId
                                type:(NIMSessionType)type
                        yidunEnabled:(BOOL)yidunEnabled
                            needApns:(BOOL)needApns
                         apnsContent:(NSString *)apnsContent;




/**
 发送陌生人消息 昵称是马甲 带推送
 
 @param text
 @param communityNick 马甲
 @param sessionId
 */
- (void) sendStrangerTextMessage:(NSString *)text nick:(NSString*)communityNick sessionId:(NSString *)sessionId type:(NIMSessionType)type;



/**重新发送*/
- (void)resendP2pMessage:(NIMMessage *)message;

/**发送消息已读回执*/
- (void)sendMessageReceipt:(NSArray *)messages;

/**
 更新云信消息
 
 @param message message消息对象
 @param session session会话对象
 */
- (void)updateMessage:(NIMMessage *)message session:(NIMSession *)session;


/**
 *  从本地db读取一个会话里某条消息之前的若干条的消息
 *
 *  @param session 消息所属的会话
 *  @param message 当前最早的消息,没有则传入nil
 *  @param limit   个数限制
 *
 *  @return 消息列表，按时间从小到大排列
 */
- (nullable NSArray<NIMMessage *> *)getMessagesInSession:(NIMSession *)session
                                              message:(nullable NIMMessage *)message
                                                limit:(NSInteger)limit;



/**
 判断云信反垃圾状态

 @param orginString 原始数据
 @param message 消息
 @return 云信消息实体
 */
- (NSString *)antiSpam:(NSString *)orginString withMessage:(NIMMessage *)message;


@end
