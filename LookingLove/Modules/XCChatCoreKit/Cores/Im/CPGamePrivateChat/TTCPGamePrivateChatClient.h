
//
//  TTCPGamePrivateChatClient.h
//  TTPlay
//
//  Created by new on 2019/2/19.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NIMSDK/NIMSDK.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TTCPGamePrivateChatClient <NSObject>

#pragma mark  --- 私聊 ---
//  IM私聊游戏列表
- (void)onCPGamePrivateChatList:(NSArray *)list;

- (void)onSendCPGamePrivateChatMessageSuccess:(NIMMessage *)message;

- (void)onReceiveCPGamePrivateChatMessageSuccess:(NIMMessage *)message;


// 发送约战已取消
- (void)onSendCPGamePrivateChatCancelGameMessageSuccess:(NIMMessage *)message;

// 收到约战已取消
- (void)onReceiveCPGamePrivateChatCancelGameMessageSuccess:(NIMMessage *)message;


// 私聊我接收了游戏
- (void)acceptGameFromPrivateChat:(NSDictionary *)jsonDict GameUrl:(NSString *)gameUrl FromUid:(NIMMessage *)message;

// 公聊我接收了游戏
- (void)acceptGameFromPublicChatGameUrl:(NSString *)gameUrl FromUid:(NIMMessage *)message;

// 游戏开始
- (void)gameStartFromPrivateChat:(NSDictionary *)dict;

// 游戏结束 私聊和房间内用的是同一个方法，为了避免被房间内私聊的情况出现。已经房间最小化，去私聊发起游戏，然后再回房间发起游戏。出现房间内游戏内结果出现在私聊。 需要分开使用
#pragma mark --- 游戏结束，私聊 ---
- (void)gameOverFromPrivateChat:(NSDictionary *)resultData;

#pragma mark --- 游戏结束，公聊大厅 ---
- (void)gameOverFromPublicChat:(NSDictionary *)resultData;

#pragma mark --- 游戏结束，多人房 ---
- (void)gameOverFromNormalRoomChat:(NSDictionary *)resultData;


#pragma mark --- 公聊 ---
// 发送公聊游戏成功回调
- (void)onSendCPGamePublicChatMessageSuccess:(NIMMessage *)message;

// 接受公聊游戏成功回调
- (void)onReceiveCPGamePublicChatMessageSuccess:(NIMMessage *)message;

// 收到公聊接受游戏回调
- (void)onReceiveCPGamePublicChatAcceptGameMessageSuccess:(NIMMessage *)message;

// 收到游戏结束的回调
- (void)onReceiveCPGamePublicChatGameOverMessageSuccess:(NIMMessage *)message;

// 收到取消游戏的回调
- (void)onReceiveCPGamePublicChatGameCancelMessageSuccess:(NIMMessage *)message;

// 游戏开始观战方法
- (void)gameStartAndMatchGame:(NSString *)matchUrlString;


// 点击观战，游戏是否失效的判断，并且更新tableView
- (void)gameFailureAndRefreshTableView:(NIMMessage *)message;



#pragma mark --- 房间 ---
// 点击接受游戏
- (void)acceptGameFromNormalRoom:(NIMMessage *)message;


- (void)watchGameOverFromNormalRoom:(NIMMessage *)message;

// 主动取消游戏
- (void)cancelGameFromNormalRoom:(NIMMessage *)message;

//  游戏失效
- (void)failureGameFromNormalRoom:(NIMMessage *)message;


#pragma mark --- 话匣子游戏 抛点数 ---
- (void)chatterboxGamePointCount:(NIMMessage *)message;
@end

NS_ASSUME_NONNULL_END
