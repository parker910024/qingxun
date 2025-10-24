//
//  GameCore.h
//  BberryCore
//
//  Created by 卫明何 on 2018/3/29.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "BaseCore.h"
#import "MonsterGameModel.h"

@interface GameCore : BaseCore
@property (nonatomic,assign) BOOL isPlayingGame;
@property (nonatomic, assign) BOOL hasMonster;
@property (nonatomic, copy) NSString *monsterIds;
@property (nonatomic, strong) NSArray *monsterLists;
@property (nonatomic, strong) MonsterGameModel *currentMonster;
//房间配置
- (RACSignal *)requestRoomConfig:(long long)roomId;
//请求怪兽信息
- (void)requestMonsterInfoByMonsterIds:(NSString *)monsterIds;

//请求房间正在攻击的怪兽
- (void)getOnGoingMonsterByRoomUid:(NSString *)roomUid fromClassStr:(NSString *)classStr;

//请求房间怪兽列表
- (void)getMonsterListByRoomUid:(NSString *)roomUid;

//攻击怪兽
- (void)sendMagicToAttackMonster:(NSString *)monsterId magicId:(NSString *)magicId;
//请求游戏结果
- (void)requestGameResult:(NSString *)monsterId;

/**
 随机魔法攻击怪兽 (调试用)
 */
- (void)startAttackTimer;
- (void)cancelAttackTimer;
@end
