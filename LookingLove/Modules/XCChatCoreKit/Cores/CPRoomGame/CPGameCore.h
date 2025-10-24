//
//  CPGameCore.h
//  XCChatCoreKit
//
//  Created by new on 2019/1/10.
//  Copyright © 2019 KevinWang. All rights reserved.
//

#import "BaseCore.h"
#import "ImMessageCoreClient.h"
NS_ASSUME_NONNULL_BEGIN
@interface CPGameCore : BaseCore

/// 嗨聊房列表
@property (nonatomic, strong) NSArray *roomUids;
/// 当前嗨聊房的 index 
@property (nonatomic, assign) NSInteger currentRoomIndex;
/**
 开启CP房间游戏模式
 
 @param roomUid 房主uid
 @return 结果
 */
- (RACSignal *)GameOpenCPModeWithRoomUid:(NSString *)roomUid;

/**
 关闭CP房间游戏模式
 
 @param roomUid 房主uid
 @return 结果
 */
- (RACSignal *)GameCloseCPModeWithRoomUid:(NSString *)roomUid;


/**
 请求CP房间游戏列表
 
 @param roomUid 房主uid
 
 */
- (RACSignal *)requestCPGameList:(NSString *)roomUid PageNum:(NSInteger )num PageSize:(NSInteger )size;

- (RACSignal *)requestCPGameListWithoutType:(NSString *)roomUid PageNum:(NSInteger )num PageSize:(NSInteger )size;

/**
 选择游戏的时候重新拉取游戏列表
 
 @param roomUid 房主uid
 
 */
- (RACSignal *)requestCPGameListWithSelectGame:(NSString *)roomUid PageNum:(NSInteger )num PageSize:(NSInteger )size;


/**
 开始游戏请求游戏链接
 
 @param uid 用户uid
 @param roomID 房主uid
 @param gameid 游戏ID
 @param channelid 厂商ID
 @param success 成功
 @param failure 失败
 */
- (void)requestGameUrlUid:(UserID )uid Name:(NSString *)name Roomid:(UserID )roomId GameId:(NSString *)gameid ChannelId:(NSString *)channelid AiUId:(UserID )aiUId;



/**
 游戏页面请求游戏链接
 
 @param uid 用户uid
 @param roomID 房主uid
 @param gameid 游戏ID
 @param channelid 厂商ID
 @param success 成功
 @param failure 失败
 */
- (RACSignal *)requestGameUrlFromGamePageUid:(UserID )uid Name:(NSString *)name Roomid:(UserID )roomId GameId:(NSString *)gameid ChannelId:(NSString *)channelid AiUId:(UserID )aiUId;

/**
 开始了游戏模式  各种更新当前房间游戏状态  传给后台
 
 @param roomId 房主uid
 @param status 游戏状态
 @param gameid 游戏ID
 @param gameName 游戏名称
 @param startUid 游戏发起人ID
 
 */
- (RACSignal *)requestGameRoomid:(UserID )roomId WithGameStatus:(NSInteger)status GameId:(NSString *)gameid gameName:(NSString *)gameName StartUid:(NSString *)startUid;




/**
 请求游戏开始链接
 
 @param uid 用户uid
 @param roomId 房主uid
 @param gameid 游戏ID
 @param channelid 厂商ID
 @param uidLeft 左边人的id
 @param uidRight 右边人的id
 @param success 成功
 @param failure 失败
 */
- (RACSignal *)requestWatchGameUrlUid:(UserID )uid Roomid:(UserID )roomId GameId:(NSString *)gameid ChannelId:(NSString *)channelid UidLeft:(UserID )uidLeft UidRight:(UserID )uidRight;



/**
 游戏结束数据回调
 
 @param gameResult 游戏结束结果
 
 */
- (RACSignal *)requestGameOverGameResult:(NSString *)gameResult;


/*
 私聊公聊  游戏结束数据回调
 */
- (RACSignal *)requestGameOverGameWithChatResult:(NSString *)gameResult WithMessageID:(NSString *)messageId;

/**
 请求主页游戏列表
 
 @param uid 本人uid
 
 */
- (RACSignal *)requestGameList:(UserID )uid PageNum:(NSInteger )num PageSize:(NSInteger )size;




/**
 加入游戏匹配
 
 @param uid 本人uid
 
 */
- (RACSignal *)requestGameList:(UserID )uid GameId:(NSString *)gameId;


/**
 取消游戏匹配
 
 @param uid 本人uid
 
 */
- (RACSignal *)requestCancelGameMatch:(UserID )uid GameId:(NSString *)gameId;



/**
 将自己的游戏房加入匹配池。前提是房间没有设置进房限制。并且已经选择了一款游戏，并且另一个麦上没有人
 
 @param uid 本人uid
 @param roomId 房间的ID  是房间roomID 而不是房间的uid
 @param gameId 游戏ID
 
 */
- (RACSignal *)requestRoomJoinMatchPoolList:(UserID )uid RoomID:(NSString *)roomId GameId:(NSString *)gameId;




/**
 将自己的游戏房移出匹配池。前提是房间设置了进房限制。或者没有选择一款游戏，或者另一个麦上有人，或者关闭房间，或者关闭游戏模式
 
 @param uid 本人uid
 @param roomId 房间的ID  是房间roomID 而不是房间的uid
 @param gameId 游戏ID
 
 */
- (RACSignal *)requestRoomExitMatchPoolList:(UserID )uid RoomID:(NSString *)roomId GameId:(NSString *)gameId;




/**
 首页banner
 
 @param bannerType 本人轮播图类型
 
 */
- (RACSignal *)requestGameHomeBanner:(NSInteger )bannerType;



/**
 首页Rank
 
 @param uid 本人id
 
 */
- (void)requestGameHomeRankList:(NSString *)uid;


/**
 首页运营可配置模块
 
 @param uid 本人id
 
 */
- (void)requestGameGetModuleRoomsList;


/**
 查询用户本周的各个游戏的获胜战绩，个人资料页
 
 @param uid 本人id
 
 */
- (RACSignal *)requestGameListDataForPersonPage:(UserID )uid;


#pragma mark --- 找玩友匹配 ---
/**
 加入找玩友匹配池
 
 @param uid 本人id
 @param findType 选择的限制条件 1/男 2/女 3/不限
 
 */
- (void)addFindFriendMatchPoolWithUid:(UserID )uid WithFindType:(NSInteger )findType;

/**
 * 加入找玩友匹配池 rac 模式
 * @param uid 本人 uid
 * @param findType 选择的限制条件 1/男 2/女 3/不限
 * @return rac 信号 📶
 */
- (RACSignal *)rac_addFindFriendMatchPoolWithUid:(UserID)uid findType:(NSInteger)findType;

/**
 移除找玩友匹配池
 
 @param uid 本人id
 
 */
- (void)removeFindFriendMatchPoolWithUid:(UserID )uid WithFindType:(NSInteger )findType;

#pragma mark -- 异性匹配 ---
/**
 添加房主到异性匹配池
 
 @param uid 本人uid
 @param roomId 房间的id
 
 */
- (void)roomOwnerAddOppositeSexMatchPoolWithUid:(UserID )uid WithRoomId:(UserID )roomId;

/**
 * 添加房主到异性匹配池
 * @param uid  用户 id
 * @param roomId  房间的 id
 */
- (RACSignal *)RAC_roomOwnerAddOppositeSexMatchPoolWithUid:(UserID )uid WithRoomId:(UserID )roomId;

/**
 房主移除异性匹配池
 
 @param uid 本人uid
 
 */
- (void)roomOwnerRemoveOppositeSexMatchPoolWithUid:(UserID )uid;


/**
 添加到异性匹配池
 
 @param uid 本人uid
 
 */
- (void)userAddOppositeSexMatchPoolWithUid:(UserID )uid;

- (RACSignal *)RAC_roomOwnerAddOppositeSexMatchPoolWithUid:(UserID )uid;

/**
 用户移除异性匹配池
 
 @param uid 本人uid
 
 */
- (void)userRemoveOppositeSexMatchPoolWithUid:(UserID )uid;

#pragma mark -- 嗨聊派对 --
/**
 嗨聊派对匹配
 
 @param uid 本人id
 
 */
- (RACSignal *)userMatchGuildRoomWithUid:(UserID )uid;

/**
 嗨聊派对匹配池 每次10个
 
 @auth @lifulong
 
 @time 2019-10-10
 
 @param uid 本人id
 
 */
- (RACSignal *)userMatchGuildRoomListWithUid:(UserID )uid;

#pragma mark --- 获取游戏表情 ---
/**
 获取游戏表情
 */
- (RACSignal *)requestGetGameFace;


/**
 获取用户喜欢玩的游戏
 
 @param uid 本人uid
 
 */
- (void)requestGetUserFavoriteGameWithUid:(UserID )uid;

#pragma mark --- 开启 关闭 家长模式 ---
/**
 开启 关闭 家长模式
 @param uid 本人id
 
 @param password 家长模式密码password
 
 @param status status  0-关闭 | 1-开启
 */
- (RACSignal *)requestOpenOrCloseParentModelWithUid:(UserID )uid password:(NSString *)password status:(NSInteger )status;


#pragma mark --- 活动入口统计 ---
/**
 活动入口统计
 @param type 入口，1-首页，2-房间
 
 @param actId 活动id
 
 */
- (void)requestActivityWithType:(NSString *)type withActId:(NSString *)actId;


#pragma mark --- 话匣子游戏 ---
/**
 话匣子游戏，获取游戏内容
 
 */
- (void)requestChatterboxGameList;

/**
 话匣子游戏，是否可以发起
 
 @param uid 本人id
 
 @param uidTo 对方id
 */
- (RACSignal *)requestChatterboxGameLaunchLWithUid:(UserID )uid uidTo:(UserID )uidTo;

/**
 话匣子游戏，抛点数上报
 
 @param uid 本人id
 
 @param uidTo 对方id
 */
- (void)requestChatterboxGameReportLWithUid:(UserID )uid uidTo:(UserID )uidTo withType:(NSInteger )type;
@end

NS_ASSUME_NONNULL_END
