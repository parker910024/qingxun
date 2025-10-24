//
//  HttpRequestHelper+Game.m
//  BberryCore
//
//  Created by 卫明何 on 2018/3/29.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "HttpRequestHelper+Game.h"
#import "NSObject+YYModel.h"
#import "AuthCore.h"
#import "MonsterGameModel.h"
#import "ImRoomCoreV2.h"
#import "GameLuckyResult.h"

@implementation HttpRequestHelper (Game)

//房间配置
+ (void)getRoomConfig:(UserID)roomId
              success:(nonnull void (^)(CPGameListModel * _Nonnull))success
              failure:(nonnull void (^)(NSNumber * _Nonnull, NSString * _Nonnull))failure {
    NSString *method = @"room/config";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(roomId) forKey:@"roomUid"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
       
        CPGameListModel *game = [CPGameListModel modelDictionary:data[@"gameInfo"]];
        game.gameUrl = game.joinUrl;
        
        if (success) {
            success(game);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}
/**
 游戏结果
 
 @param monsterId 妖怪id
 @param success 成功
 @param failure 失败
 */
+ (void)queryMonsterGameResultByMonsterId:(NSString *)monsterId
                                  success:(void (^)(GameLuckyResult *))success
                                  failure:(void (^)(NSNumber *, NSString *))failure{
    NSString *method = @"v1/monster/draw/result";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:monsterId forKey:@"monsterId"];
    [params safeSetObject:[GetCore(AuthCore)getTicket] forKey:@"ticket"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        GameLuckyResult *result = [GameLuckyResult yy_modelWithJSON:data];
        success(result);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}


/**
 请求房间正在进行的怪兽的数据

 @param roomId 房主UID
 @param success 成功
 @param failure 失败
 */
+ (void)requestMonsterByRoomUID:(NSString *)roomUid Success:(void (^) (MonsterGameModel *))success failure:(void (^) (NSNumber *, NSString *))failure {
    NSString *method = @"v1/monster/ongoing";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:roomUid forKey:@"roomUid"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        MonsterGameModel *monster = [MonsterGameModel yy_modelWithJSON:data];
        success(monster);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}


/**
 请求当前房间的怪兽列表
 
 @param roomId 房间id
 @param success 成功
 @param failure 失败
 */
+ (void)requestMonsterListByRoomId:(NSString *)roomUid
                           Success:(void (^)(NSArray *))success
                           failure:(void (^)(NSNumber *, NSString *))failure{
    NSString *method = @"v1/monster/list";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:roomUid forKey:@"roomUid"];
    [params safeSetObject:[GetCore(AuthCore) getTicket] forKey:@"ticket"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {

        NSArray *monsterArray = [NSArray yy_modelArrayWithClass:[MonsterGameModel class] json:data];
        success(monsterArray);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

/**
 根据monsterid查询怪兽信息
 
 @param success 成功
 @param failure 失败
 */
+ (void)requesrMonsterInfoByMonsterIds:(NSString *)monsterIds
                              success:(void (^)(NSArray *))success
                              failure:(void (^)(NSNumber *, NSString *))failure{
    NSString *method = @"v1/monster/query";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:monsterIds forKey:@"monsterIds"];
    [params safeSetObject:[GetCore(AuthCore) getTicket] forKey:@"ticket"];
    [HttpRequestHelper GET:method params:params success:^(id data) {
        NSArray *magicList = [NSArray yy_modelArrayWithClass:[MonsterGameModel class] json:data];
        success(magicList);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}


/**
 使用魔法攻击怪兽
 
 @param magicId 魔法ID
 @param success 成功
 @param failure 失败
 */
+ (void)sendMagicToAttackMonsterWithMagicId:(NSString *)magicId andMonsterId:(NSString *)monsterId success:(void (^)(MonsterAttack *))success failure:(void (^)(NSNumber *, NSString *))failure {

    NSString *method = @"v1/monster/attack";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:[GetCore(AuthCore)getUid] forKey:@"uid"];
    [params safeSetObject:[GetCore(AuthCore) getTicket] forKey:@"ticket"];
    [params safeSetObject:magicId forKey:@"magicId"];
    [params safeSetObject:monsterId forKey:@"monsterId"];
    [params safeSetObject:GetCore(ImRoomCoreV2).currentChatRoom.creator forKey:@"roomUid"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        MonsterAttack *senderResult = [MonsterAttack yy_modelWithJSON:data];
        success(senderResult);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

@end
