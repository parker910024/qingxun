//
//  GameCoreClient.h
//  BberryCore
//
//  Created by 卫明何 on 2018/3/29.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MonsterGameModel.h"
#import "RoomMagicInfo.h"
#import "MonsterAttack.h"
#import "GameLuckyResult.h"

@protocol GameCoreClient <NSObject>
@optional

//根据monsterid获取怪兽信息
- (void)onGetMonsterInfosSuccess:(NSArray *)monsters;
- (void)onGetMonsterInfosFailth:(NSString *)message;

//请求房间正在攻击的怪兽
- (void)onGetRoomMonsterInfoSuccess:(MonsterGameModel *)monster classStr:(NSString *)className;
- (void)onGetRoomMonsterInfoFailth:(NSString *)message;

//进房间获取怪兽列表
- (void)onGetRoomMonsterListSuccess:(NSArray *)monsterList;
- (void)onGetRoomMonsterListFailth:(NSString *)message;



//打怪兽流程(房间外)
- (void)onMonsterWillAppear:(MonsterGameModel *)monster; //怪兽准备出现 
- (void)onMonsterDidAppear:(MonsterGameModel *)monster; //怪兽已经出现 （开始）
- (void)onMonsterDidDead:(MonsterGameModel *)monster; //怪兽被打败
- (void)onMonsterDidLeave:(MonsterGameModel *)monster; //怪兽逃走了
- (void)onMonsterBeAttackBy:(MonsterAttack *)roomMagicInfo;
//攻击结果
- (void)onRequestGameResultSuccess:(GameLuckyResult *)gameLuckyResult monsterId:(NSString *)monsterId;
- (void)onRequestGameResultFail:(NSString *)message;


//房间内
- (void)onMonsterWillAppearInRoom:(MonsterGameModel *)monster;//怪兽准备出现 
- (void)onMonsterDidAppearInRoom:(MonsterGameModel *)monster; //怪兽已经出现 （开始）
- (void)onMonsterDidDeadInRoom:(MonsterGameModel *)monster; //怪兽被打败
- (void)onMonsterDidLeaveInRoom:(MonsterGameModel *)monster; //怪兽逃走了
- (void)onRequestGameResultSuccessInRoom:(GameLuckyResult *)gameLuckyResult monsterId:(NSString *)monsterId;



//打怪兽失败
- (void)onMonsterAttackFail:(NSString *)message;

@end
