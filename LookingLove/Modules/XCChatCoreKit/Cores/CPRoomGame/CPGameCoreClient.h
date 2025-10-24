//
//  CPGameCoreClient.h
//  XCChatCoreKit
//
//  Created by new on 2019/1/11.
//  Copyright © 2019 KevinWang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTCPGameCustomModel.h"
#import "CPGameListModel.h"
#import "TTGameHomeModuleModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CPGameCoreClient <NSObject>

@optional

//   CP房，游戏列表
- (void)onCPRoomGetGameList:(NSArray *)listArray;

- (void)onCPRoomGetGameListWithoutType:(NSArray *)listArray;

//   主页，游戏列表
- (void)onGameList:(NSArray *)listArray;


// 主页 列表。传3为 轮播图。 传4 为游戏列表数据
- (void)gameHomeBannerArray:(NSArray *)listArray;

- (void)gameHomeListArray:(NSArray *)listArray;


// 主页列表 排行榜
- (void)gameHomeRankListArray:(NSDictionary *)listDic;

// 获取游戏主页 运营配置模块
- (void)gameHomeModuleListArray:(NSArray *)listArray;

// 获取游戏主页 运营配置模块失败
- (void)gameHomeModuleListArrayError;

// 获取游戏开始链接
- (void)onCPRoomGameUrl:(NSString *)gameUrlString;


// 游戏页面获取游戏链接
- (void)onCPRoomGameUrlFromWebViewPage:(NSString *)gameUrlString;

// 获取观众观看游戏链接的接口
- (void)onCPRoomUrlWithWatchGame:(NSString *)watchGameUrl;

// 游戏结束，我赢了
- (void)gameOverAndWuSueecss:(NSDictionary *)relustDict;


//  当你的对手是机器人，并且你输了。那么机器人将不会发送自定义云信自定义通知，这个地方不能有赢的人来发了，只能由玩家，也就是你发送自定义通知
-(void)gamefailerAction:(TTCPGameCustomModel *)customModel;


// 游戏结束，平局
- (void)gameOverAndNobodyWin:(NSDictionary *)relustDict;

//  我突然下麦了。任性
- (void)downMic;

//  我突然上麦了。就是任性
- (void)suddenUpMic;

//  当我在房间内，开启游戏匹配之后。匹配到玩友之后需要用到通知去通知自己
- (void)enterRoomFromForInRoomMatch:(NSString *)gameString;

//  房主可以邀请好友啊
- (void)inviteFriendFromGameModel;

//   房主可以关闭游戏啊
- (void)closeGameModel;

//  当其中一个人异常退出时。这个人的界面默认就是选择游戏界面，不管是什么异常
- (void)gameOverForAbnormalReturnSelectPage;

/*  匹配到之后，拿到的游戏信息 */
- (void)matchGameAndGameData:(CPGameListModel *)model;

/*  个人资料页。游戏信息 */
- (void)gameDataWithMinePage:(NSArray *)listArray;

/*  获取用户喜欢玩的游戏  */
- (void)findFriendMatchMessageUserFavoriteGame:(NSArray *)listArray;

#pragma mark --- 话匣子游戏 ---
- (void)acquireChatterboxGameListArray:(NSArray *)listArray;

#pragma mark -
#pragma mark 青少年模式下
- (void)gameCPMatchOnTeenagerModeWarning:(NSString *)msg;

// 开启青少年模式成功
- (void)openParentModelSuccess;

// 关闭青少年模式成功
- (void)closeParentModelSuccess;
@end

NS_ASSUME_NONNULL_END
