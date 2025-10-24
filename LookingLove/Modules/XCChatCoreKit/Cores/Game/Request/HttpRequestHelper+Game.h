//
//  HttpRequestHelper+Game.h
//  BberryCore
//
//  Created by 卫明何 on 2018/3/29.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "HttpRequestHelper.h"
#import "RoomMagicInfo.h"
#import "MonsterAttack.h"
#import "GameLuckyResult.h"
#import "CPGameListModel.h"

@interface HttpRequestHelper (Game)

//房间配置
+ (void)getRoomConfig:(UserID)roomId
              success:(nonnull void (^)(CPGameListModel * _Nonnull))success
              failure:(nonnull void (^)(NSNumber * _Nonnull, NSString * _Nonnull))failure;

/**
 请求房间正在进行的怪兽的数据
 
 @param roomUId 房主UID
 @param success 成功
 @param failure 失败
 */
+ (void)requestMonsterByRoomUID:(NSString *)roomUid
                        Success:(void (^) (MonsterGameModel *))success
                        failure:(void (^) (NSNumber *, NSString *))failure;


/**
 游戏结果

 @param monsterId 妖怪id
 @param success 成功
 @param failure 失败
 */
+ (void)queryMonsterGameResultByMonsterId:(NSString *)monsterId
                                  success:(void (^)(GameLuckyResult *))success
                                  failure:(void (^)(NSNumber *, NSString *))failure;

/**
 请求当前房间的怪兽列表

 @param roomId 房间id
 @param success 成功
 @param failure 失败
 */
+ (void)requestMonsterListByRoomId:(NSString *)roomId
                       Success:(void (^)(NSArray *))success
                       failure:(void (^)(NSNumber *, NSString *))failure;

/**
 根据monsterid查询怪兽信息

 @param success 成功
 @param failure 失败
 */
+ (void)requesrMonsterInfoByMonsterIds:(NSString *)monsterIds
                              success:(void (^)(NSArray *))success
                              failure:(void (^)(NSNumber *, NSString *))failure;


/**
 使用魔法攻击怪兽

 @param magicId 魔法ID
 @param success 成功
 @param failure 失败
 */
+ (void)sendMagicToAttackMonsterWithMagicId:(NSString *)magicId andMonsterId:(NSString *)monsterId success:(void (^)(MonsterAttack *))success failure:(void (^)(NSNumber *, NSString *))failure;

@end
