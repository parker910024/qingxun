//
//  ImMessageCoreClient.h
//  BberryCore
//
//  Created by chenran on 2017/5/31.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NIMSDK/NIMSDK.h>

@protocol ImMessageCoreClient <NSObject>
@optional
- (void)onWillSendMessage:(NIMMessage *)msg;
- (void)onRecvChatRoomTextMsg:(NIMMessage *)msg;
- (void)onRecvChatRoomNotiMsg:(NIMMessage *)msg;
- (void)onRecvChatRoomCustomMsg:(NIMMessage *)msg;
- (void)onSendMessageSuccess:(NIMMessage *)msg;
- (void)onSendChatRoomMessageSuccess:(NIMMessage *)msg;
- (void)onRecvP2PCustomMsg:(NIMMessage *)msg;
- (void)onRecvAnMsg:(NIMMessage *)msg;
- (void)onUpdateMessageSuccess:(NIMMessage *)msg;
//系统广播
- (void)onRecvAnBroadcastMsg:(NIMBroadcastMessage *)msg;
- (void)onSendMessageFailthWithError;
- (void)onImUnReadCountHandleComplete;
//分享家族  发送自定义的消息成功之后
- (void)sendCustomMessageShare:(NIMMessage *)msg;
//发送 自定义 龙珠 消息 成功
- (void)onSendDragonMessageSuccess:(NIMMessage *)msg;
//发送自定义 龙珠 消息 出错
- (void)onSendDragonMessageFailthWithMsg:(NIMMessage *)msg error:(NSError *)error;
// 发送自定义消息 送礼物公屏消息失败以后
- (void)onSendGiftMessageFailthWithMsg:(NIMMessage *)msg error:(NSError *)error;
// 房间活动高能倒计时
- (void)onSendRoomActivityCountDownTimeWithMsg:(NIMMessage *)msg error:(NSError *)error;

/**已读回执*/
- (void)onRecvP2PMessageReceipt:(NIMMessageReceipt *)receipt;

/**发送消息进度回调*/
- (void)onSendMessage:(NIMMessage *)message progress:(float)progress;



/********  ----- CP 游戏 ---- ********/
- (void)onSendCPGameMessageSuccess:(NIMMessage *)msg;

// 收到更新铭牌信息。更新自己的member
- (void)onUpdateNameplate;
@end
