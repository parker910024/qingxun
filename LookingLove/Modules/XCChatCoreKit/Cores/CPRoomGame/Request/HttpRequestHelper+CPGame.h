//
//  HttpRequestHelper+CPGame.h
//  XCChatCoreKit
//
//  Created by new on 2019/1/10.
//  Copyright © 2019 KevinWang. All rights reserved.
//

#import "HttpRequestHelper.h"

@class TTGameHomeModuleModel;
NS_ASSUME_NONNULL_BEGIN

@interface HttpRequestHelper (CPGame)



/**
 开启CP房间游戏模式
 
 @param roomUid 房主uid
 @param success 成功
 @param failure 失败
 */
+ (void)requestGameOpenCPModeWithRoomUid:(NSString *)roomUid
                                 success:(void (^)(BOOL success))success
                                 failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 关闭CP房间游戏模式
 
 @param roomUid 房主uid
 @param success 成功
 @param failure 失败
 */
+ (void)requestGameCloseCPModeWithRoomUid:(NSString *)roomUid
                                  success:(void (^)(BOOL success))success
                                  failure:(void (^)(NSNumber *resCode, NSString *message))failure;



/**
 请求CP房间游戏列表
 
 @param roomUid 房主uid
 @param success 成功
 @param failure 失败
 */

+ (void)requestCPGameList:(NSString *)roomUid PageNum:(NSInteger )num PageSize:(NSInteger )size success:(void (^)(NSArray *list))success failure:(void (^)(NSNumber *resCode, NSString *message))failure;

+ (void)requestCPGameListWithoutType:(NSString *)roomUid PageNum:(NSInteger )num PageSize:(NSInteger )size success:(void (^)(NSArray *list))success failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 请求游戏开始链接
 
 @param uid 用户uid
 @param roomID 房主uid
 @param gameid 游戏ID
 @param channelid 厂商ID
 @param success 成功
 @param failure 失败
 */
+ (void)requestGameUrlUid:(UserID )uid Name:(NSString *)name Roomid:(UserID )roomId GameId:(NSString *)gameid ChannelId:(NSString *)channelid AiUId:(UserID )aiUId success:(void(^)(NSString *urlString))success failure:(void (^)(NSNumber *resCode, NSString *message))failure;




+ (void)requestGameOverGameResult:(NSString *)gameResult success:(void (^)(BOOL success))success
                          failure:(void (^)(NSNumber *resCode, NSString *message))failure;



+ (void)requestGameOverGameWithChatResult:(NSString *)gameResult WithMessageID:(NSString *)messageId success:(void (^)(BOOL success))success
                                  failure:(void (^)(NSNumber *resCode, NSString *message))failure;
/**
 开始了游戏模式  各种更新当前房间游戏状态  传给后台
 
 @param roomId 房主uid
 @param status 游戏状态
 @param gameid 游戏ID
 @param gameName 游戏名称
 @param startUid 游戏发起人ID
 
 */
+ (void)requestGameRoomid:(UserID )roomId WithGameStatus:(NSInteger)status GameId:(NSString *)gameid gameName:(NSString *)gameName StartUid:(NSString *)startUid success:(void(^)(BOOL success))success failure:(void (^)(NSNumber *resCode, NSString *message))failure;




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
+ (void)requestWatchGameUrlUid:(UserID )uid Roomid:(UserID )roomId GameId:(NSString *)gameid ChannelId:(NSString *)channelid UidLeft:(UserID )uidLeft UidRight:(UserID )uidRight success:(void(^)(NSString *urlString))success failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/**
 请求主页游戏列表
 
 @param uid 本人uid
 
 */
+ (void)requestGameList:(UserID )uid PageNum:(NSInteger )num PageSize:(NSInteger )size success:(void (^)(NSArray *list))success failure:(void (^)(NSNumber *resCode, NSString *message))failure;




/**
 点击进入游戏匹配
 
 @param uid 本人uid
 
 */
+ (void)requestGameList:(UserID )uid GameId:(NSString *)gameId success:(void (^)(BOOL success))success failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/**
 取消游戏匹配
 
 @param uid 本人uid
 
 */
+ (void)requestCancelGameMatch:(UserID )uid GameId:(NSString *)gameId success:(void (^)(BOOL success))success failure:(void (^)(NSNumber *resCode, NSString *message))failure;




/**
 将自己的游戏房加入匹配池。前提是房间没有设置进房限制。并且已经选择了一款游戏，并且另一个麦上没有人
 
 @param uid 本人uid
 @param roomId 房间的ID  是房间roomID 而不是房间的uid
 @param gameId 游戏ID
 
 */

+ (void)requestRoomJoinMatchPoolList:(UserID )uid RoomID:(NSString *)roomId GameId:(NSString *)gameId success:(void (^)(BOOL success))success failure:(void (^)(NSNumber *resCode, NSString *message))failure;




/**
 将自己的游戏房移出匹配池。前提是房间设置了进房限制。或者没有选择一款游戏，或者另一个麦上有人，或者关闭房间，或者关闭游戏模式
 
 @param uid 本人uid
 @param roomId 房间的ID  是房间roomID 而不是房间的uid
 @param gameId 游戏ID
 
 */
+ (void)requestRoomExitMatchPoolList:(UserID )uid RoomID:(NSString *)roomId GameId:(NSString *)gameId success:(void (^)(BOOL success))success failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/**
 首页banner
 
 @param bannerType 本人轮播图类型
 
 */
+ (void)requestGameHomeBanner:(NSInteger )bannerType success:(void (^)(NSArray *list))success failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/**
 首页Rank
 
 @param uid 本人id
 
 */
+ (void)requestGameHomeRankList:(NSString *)uid success:(void (^)(NSDictionary *list))success failure:(void (^)(NSNumber *resCode, NSString *message))failure;



/**
 首页运营可配置模块
 
 @param uid 本人id
 
 */
+ (void)requestGameGetModuleRoomsListSuccess:(void (^)(NSArray *listArray))success failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/**
 查询用户本周的各个游戏的获胜战绩，个人资料页
 
 @param uid 本人id
 
 */
+ (void)requestGameListDataForPersonPage:(UserID )uid success:(void (^)(NSArray *listArray))success failure:(void (^)(NSNumber *resCode, NSString *message))failure;

#pragma mark --- 找玩友匹配 ---
/**
 加入找玩友匹配池
 
 @param uid 本人id
 @param findType 选择的限制条件 1/男 2/女 3/不限
 
 */
+ (void)addFindFriendMatchPoolWithUid:(UserID )uid WithFindType:(NSInteger )findType success:(void (^)(BOOL success))success failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/**
 移除找玩友匹配池
 
 @param uid 本人id
 
 */
+ (void)removeFindFriendMatchPoolWithUid:(UserID )uid WithFindType:(NSInteger )findType success:(void (^)(BOOL success))success failure:(void (^)(NSNumber *resCode, NSString *message))failure;

#pragma mark -- 异性匹配 ---
/**
 添加房主到异性匹配池
 
 @param uid 本人uid
 @param roomId 房间的id
 
 */
+ (void)roomOwnerAddOppositeSexMatchPoolWithUid:(UserID )uid WithRoomId:(UserID )roomId success:(void (^)(BOOL success))success failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 房主移除异性匹配池
 
 @param uid 本人uid
 
 */
+ (void)roomOwnerRemoveOppositeSexMatchPoolWithUid:(UserID )uid success:(void (^)(BOOL success))success failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/**
 添加到异性匹配池
 
 @param uid 本人uid
 
 */
+ (void)userAddOppositeSexMatchPoolWithUid:(UserID )uid success:(void (^)(BOOL success))success failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 用户移除异性匹配池
 
 @param uid 本人uid
 
 */
+ (void)userRemoveOppositeSexMatchPoolWithUid:(UserID )uid success:(void (^)(BOOL success))success failure:(void (^)(NSNumber *resCode, NSString *message))failure;

#pragma mark -- 嗨聊派对 --
/**
 嗨聊派对匹配
 
 @param uid 本人id
 
 */
+ (void)userMatchGuildRoomWithUid:(UserID )uid success:(void (^)(NSString *roomUid))success failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 嗨聊派对匹配池 每次10个
 
 @auth @lifulong
 
 @time 2019-10-10
 
 @param uid 本人id
 
 */
+ (void)userMatchGuildRoomListWithUid:(UserID )uid success:(void (^)(NSArray *roomUids))success failure:(void (^)(NSNumber *resCode, NSString *message))failure;

#pragma mark --- 获取游戏表情 ---
/**
 获取游戏表情
 */
+ (void)requestGetGameFaceSuccess:(void (^)(NSArray *list))success failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/**
 获取用户喜欢玩的游戏
 
 @param uid 本人uid
 
 */
+ (void)requestGetUserFavoriteGameWithUid:(UserID )uid success:(void (^)(NSArray *listArray))success failure:(void (^)(NSNumber *resCode, NSString *message))failure;

#pragma mark --- 开启 关闭 家长模式 ---
/**
 开启 关闭 家长模式
 @param uid 本人id
 
 @param password 家长模式密码password
 
 @param status status  0-关闭 | 1-开启
 */
+ (void)requestOpenOrCloseParentModelWithUid:(UserID )uid password:(NSString *)password status:(NSInteger )status success:(void (^)(BOOL success))success failure:(void (^)(NSNumber *resCode, NSString *message))failure;


#pragma mark --- 活动入口统计 ---
/**
 活动入口统计
 @param type 入口，1-首页，2-房间
 
 @param actId 活动id
 
 */
+ (void)requestActivityWithType:(NSString *)type withActId:(NSString *)actId success:(void (^)(BOOL success))success failure:(void (^)(NSNumber *resCode, NSString *message))failure;


#pragma mark --- 话匣子游戏 ---
/**
 话匣子游戏，获取游戏内容
 
 */
+ (void)requestChatterboxGameListSuccess:(void (^)(NSArray *listArray))success failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/**
 话匣子游戏，是否可以发起
 
 @param uid 本人id
 
 @param uidTo 对方id
 */
+ (void)requestChatterboxGameLaunchLWithUid:(UserID )uid uidTo:(UserID )uidTo success:(void (^)(NSDictionary *dict))success failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 话匣子游戏，抛点数上报
 
 @param uid 本人id
 
 @param uidTo 对方id
 */
+ (void)requestChatterboxGameReportLWithUid:(UserID )uid uidTo:(UserID )uidTo withType:(NSInteger )type success:(void (^)(BOOL success))success failure:(void (^)(NSNumber *resCode, NSString *message))failure;

@end

NS_ASSUME_NONNULL_END

