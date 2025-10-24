//
//  HttpRequestHelper+CPGame.m
//  XCChatCoreKit
//
//  Created by new on 2019/1/10.
//  Copyright © 2019 KevinWang. All rights reserved.
//

#import "HttpRequestHelper+CPGame.h"
#import "CPGameListModel.h"
#import "CPGameHomeBannerModel.h"
#import "TTMineGameListModel.h"
#import "TTGameHomeModuleModel.h"

#import "NSMutableDictionary+Safe.h"
#import "DESEncrypt.h"

@implementation HttpRequestHelper (CPGame)


+ (void)requestGameOpenCPModeWithRoomUid:(NSString *)roomUid
                                 success:(void (^)(BOOL success))success
                                 failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    NSString *method = @"room/openOrCloseGame";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:roomUid forKey:@"roomUid"];
    [params safeSetObject:@(true) forKey:@"gameStatus"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        if (success) {
            success(YES);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+ (void)requestGameCloseCPModeWithRoomUid:(NSString *)roomUid
                                  success:(void (^)(BOOL success))success
                                  failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    NSString *method = @"room/openOrCloseGame";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:roomUid forKey:@"roomUid"];
    [params safeSetObject:@(false) forKey:@"gameStatus"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        if (success) {
            success(YES);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}



+ (void)requestCPGameList:(NSString *)roomUid PageNum:(NSInteger )num PageSize:(NSInteger )size success:(void (^)(NSArray *list))success failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    NSString *method = @"game/v1/gameInfo/pk1v1";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:roomUid forKey:@"uid"];
    [params safeSetObject:@(num) forKey:@"pageNum"];
    [params safeSetObject:@(size) forKey:@"pageSize"];
    [params safeSetObject:@(1) forKey:@"type"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        
        NSMutableArray *dataArray = [NSMutableArray array];
        NSArray *dataList = [CPGameListModel modelsWithArray:data];
        for (int i = 0; i < dataList.count; i++) {
            CPGameListModel *model = dataList[i];
            if ([model.platform isEqualToString:@"ios"] || [model.platform isEqualToString:@"all"]) {
                [dataArray addObject:model];
            }
        }
        
        if (success) {
            success(dataArray);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+ (void)requestCPGameListWithoutType:(NSString *)roomUid PageNum:(NSInteger )num PageSize:(NSInteger )size success:(void (^)(NSArray *list))success failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    NSString *method = @"game/v1/gameInfo/pk1v1";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:roomUid forKey:@"uid"];
    [params safeSetObject:@(num) forKey:@"pageNum"];
    [params safeSetObject:@(size) forKey:@"pageSize"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        
        NSMutableArray *dataArray = [NSMutableArray array];
        NSArray *dataList = [CPGameListModel modelsWithArray:data];
        for (int i = 0; i < dataList.count; i++) {
            CPGameListModel *model = dataList[i];
            if ([model.platform isEqualToString:@"ios"] || [model.platform isEqualToString:@"all"]) {
                [dataArray addObject:model];
            }
        }
        
        if (success) {
            success(dataArray);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}


+ (void)requestGameOverGameResult:(NSString *)gameResult success:(void (^)(BOOL success))success
                          failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    
    NSString *method = @"game/v1/gameResult/saveGameResult";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:gameResult forKey:@"gameResult"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        if (success) {
            success(YES);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+ (void)requestGameOverGameWithChatResult:(NSString *)gameResult WithMessageID:(NSString *)messageId success:(void (^)(BOOL success))success
                                  failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    NSString *method = @"game/v1/gameResult/saveGameResult";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:gameResult forKey:@"gameResult"];
    [params safeSetObject:messageId forKey:@"messageId"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        if (success) {
            success(YES);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+ (void)requestGameUrlUid:(UserID )uid Name:(NSString *)name Roomid:(UserID )roomId GameId:(NSString *)gameid ChannelId:(NSString *)channelid AiUId:(UserID )aiUId success:(void(^)(NSString *urlString))success failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    NSString *method = @"game/v1/gameInfo/getGameUrl";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(uid) forKey:@"uid"];
    [params safeSetObject:@(roomId) forKey:@"roomId"];
    [params safeSetObject:gameid forKey:@"gameId"];
    [params safeSetObject:channelid forKey:@"channelId"];
    [params safeSetObject:name forKey:@"name"];
    [params safeSetObject:aiUId > 0 ? @(aiUId) : @(0) forKey:@"aiUid"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        if (success) {
            success(data[@"url"]);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
    
}

/**
 开始了游戏模式  各种更新当前房间游戏状态  传给后台
 
 @param roomId 房主uid
 @param status 游戏状态
 @param gameid 游戏ID
 @param gameName 游戏名称
 @param startUid 游戏发起人ID
 
 */

+ (void)requestGameRoomid:(UserID )roomId WithGameStatus:(NSInteger)status GameId:(NSString *)gameid gameName:(NSString *)gameName StartUid:(NSString *)startUid success:(void(^)(BOOL success))success failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    
    NSString *method = @"room/updateGameStatus";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(roomId) forKey:@"roomUid"];
    [params safeSetObject:@(status) forKey:@"status"];
    
    if (gameid.length > 0) {
        [params safeSetObject:gameid forKey:@"gameId"];
    }
    if (gameName.length > 0) {
        [params safeSetObject:gameName forKey:@"gameName"];
    }
    if (startUid.length > 0) {
        [params safeSetObject:@(startUid.userIDValue) forKey:@"startUid"];
    }
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        if (success) {
            success(YES);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}


+ (void)requestWatchGameUrlUid:(UserID )uid Roomid:(UserID )roomId GameId:(NSString *)gameid ChannelId:(NSString *)channelid UidLeft:(UserID )uidLeft UidRight:(UserID )uidRight success:(void(^)(NSString *urlString))success failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    
    NSString *method = @"game/v1/gameInfo/watchGameUrl";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(uid) forKey:@"uid"];
    [params safeSetObject:@(roomId) forKey:@"roomId"];
    [params safeSetObject:gameid forKey:@"gameId"];
    [params safeSetObject:channelid forKey:@"channelId"];
    [params safeSetObject:@(uidLeft) forKey:@"uidLeft"];
    [params safeSetObject:@(uidRight) forKey:@"uidRight"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        if (success) {
            success(data[@"url"]);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+ (void)requestGameList:(UserID )uid PageNum:(NSInteger )num PageSize:(NSInteger )size success:(void (^)(NSArray *list))success failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    NSString *method = @"game/v1/gameInfo/list";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(uid) forKey:@"uid"];
    [params safeSetObject:@(num) forKey:@"pageNum"];
    [params safeSetObject:@(size) forKey:@"pageSize"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        NSMutableArray *dataArray = [NSMutableArray array];
        NSArray *dataList = [CPGameListModel modelsWithArray:data];
        for (int i = 0; i < dataList.count; i++) {
            CPGameListModel *model = dataList[i];
            if ([model.platform isEqualToString:@"ios"] || [model.platform isEqualToString:@"all"]) {
                [dataArray addObject:model];
            }
        }
        
        if (success) {
            success(dataArray);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
    
}

+ (void)requestGameList:(UserID )uid GameId:(NSString *)gameId success:(void (^)(BOOL success))success failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    NSString *method = @"game/v1/match/add";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(uid) forKey:@"uid"];
    [params safeSetObject:gameId forKey:@"gameId"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        if (success) {
            success(YES);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}


+ (void)requestCancelGameMatch:(UserID )uid GameId:(NSString *)gameId success:(void (^)(BOOL success))success failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    NSString *method = @"game/v1/match/remove";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(uid) forKey:@"uid"];
    [params safeSetObject:gameId forKey:@"gameId"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        if (success) {
            success(YES);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}


+ (void)requestRoomJoinMatchPoolList:(UserID )uid RoomID:(NSString *)roomId GameId:(NSString *)gameId success:(void (^)(BOOL success))success failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    NSString *method = @"room/addPoolForRoom";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(uid) forKey:@"uid"];
    [params safeSetObject:roomId forKey:@"roomId"];
    [params safeSetObject:gameId forKey:@"gameId"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        if (success) {
            success(YES);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}


+ (void)requestRoomExitMatchPoolList:(UserID )uid RoomID:(NSString *)roomId GameId:(NSString *)gameId success:(void (^)(BOOL success))success failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    NSString *method = @"room/removePoolForRoom";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(uid) forKey:@"uid"];
    [params safeSetObject:roomId forKey:@"roomId"];
    [params safeSetObject:gameId forKey:@"gameId"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        if (success) {
            success(YES);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}



/**
 首页banner
 
 @param bannerType 本人轮播图类型
 
 */
+ (void)requestGameHomeBanner:(NSInteger )bannerType success:(void (^)(NSArray *list))success failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    NSString *method = @"banner/gameFirstPage";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(bannerType) forKey:@"bannerType"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        NSArray *dataList = [CPGameHomeBannerModel modelsWithArray:data];
        if (success) {
            success(dataList);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+ (void)requestGameHomeRankList:(NSString *)uid success:(void (^)(NSDictionary *list))success failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    NSString *method = @"game/v2/rank/list";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:uid forKey:@"uid"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+ (void)requestGameGetModuleRoomsListSuccess:(void (^)(NSArray *listArray))success failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    
    NSString *method = @"home/v4/getModuleRooms";
    
    [HttpRequestHelper GET:method params:nil success:^(id data) {
        NSArray *dataList = [TTGameHomeModuleModel modelsWithArray:data];
        if (success) {
            success(dataList);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}



+ (void)requestGameListDataForPersonPage:(UserID )uid success:(void (^)(NSArray *listArray))success failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    
    NSString *method = @"game/v3/week";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params safeSetObject:@(uid) forKey:@"uid"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        NSMutableArray *dataArray = [NSMutableArray array];
        NSArray *dataList = [TTMineGameListModel modelsWithArray:data];
        for (int i = 0; i < dataList.count; i++) {
            TTMineGameListModel *model = dataList[i];
            if ([model.platform isEqualToString:@"ios"] || [model.platform isEqualToString:@"all"]) {
                [dataArray addObject:model];
            }
        }
        if (success) {
            success(dataArray);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

#pragma mark --- 找玩友匹配 ---
/**
 加入找玩友匹配池
 
 @param uid 本人id
 @param findType 选择的限制条件 1/男 2/女 3/不限
 
 */
+ (void)addFindFriendMatchPoolWithUid:(UserID )uid WithFindType:(NSInteger )findType success:(void (^)(BOOL success))success failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    
    NSString *method = @"game/v4/match/addPlayer";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params safeSetObject:@(uid) forKey:@"uid"];
    [params safeSetObject:@(findType) forKey:@"findType"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        if (success) {
            success(YES);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

/**
 移除找玩友匹配池
 
 @param uid 本人id
 
 */
+ (void)removeFindFriendMatchPoolWithUid:(UserID )uid WithFindType:(NSInteger )findType success:(void (^)(BOOL success))success failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    NSString *method = @"game/v4/match/removePlayer";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params safeSetObject:@(uid) forKey:@"uid"];
    [params safeSetObject:@(findType) forKey:@"findType"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        if (success) {
            success(YES);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

#pragma mark -- 异性匹配 ---
/**
 添加房主到异性匹配池
 
 @param uid 本人uid
 @param roomId 房间的id
 
 */
+ (void)roomOwnerAddOppositeSexMatchPoolWithUid:(UserID )uid WithRoomId:(UserID )roomId success:(void (^)(BOOL success))success failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    NSString *method = @"room/addIsomerismPoolForRoom";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params safeSetObject:@(uid) forKey:@"uid"];
    [params safeSetObject:@(roomId) forKey:@"roomId"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        if (success) {
            success(YES);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

/**
 房主移除异性匹配池
 
 @param uid 本人uid
 
 */
+ (void)roomOwnerRemoveOppositeSexMatchPoolWithUid:(UserID )uid success:(void (^)(BOOL success))success failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    NSString *method = @"room/removeIsomerismPoolForRoom";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params safeSetObject:@(uid) forKey:@"uid"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        if (success) {
            success(YES);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

/**
 添加到异性匹配池
 
 @param uid 本人uid
 
 */
+ (void)userAddOppositeSexMatchPoolWithUid:(UserID )uid success:(void (^)(BOOL success))success failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    NSString *method = @"game/v4/match/addIsomerism";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params safeSetObject:@(uid) forKey:@"uid"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        if (success) {
            success(YES);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

/**
 用户移除异性匹配池
 
 @param uid 本人uid
 
 */
+ (void)userRemoveOppositeSexMatchPoolWithUid:(UserID )uid success:(void (^)(BOOL success))success failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    NSString *method = @"game/v4/match/removeIsomerism";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params safeSetObject:@(uid) forKey:@"uid"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        if (success) {
            success(YES);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
    
}

#pragma mark -- 嗨聊派对 --
/**
 嗨聊派对匹配
 
 @param uid 本人id
 
 */
+ (void)userMatchGuildRoomWithUid:(UserID )uid success:(void (^)(NSString *roomUid))success failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    NSString *method = @"room/getGuildRoomId";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params safeSetObject:@(uid) forKey:@"uid"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        NSString *roomID = [NSString stringWithFormat:@"%@",data];
        if (success) {
            success(roomID);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

/**
 嗨聊派对匹配池 每次10个
 
 @auth @lifulong
 
 @time 2019-10-10
 
 @param uid 本人id
 
 */
+ (void)userMatchGuildRoomListWithUid:(UserID )uid success:(void (^)(NSArray *roomUids))success failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString *method = @"room/chat/party/get";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params safeSetObject:@(uid) forKey:@"uid"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        if ([data isKindOfClass:[NSArray class]]) {
            if (success) {
                success(data);
            }
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

#pragma mark --- 获取游戏表情 ---
/**
 获取游戏表情
 */
+ (void)requestGetGameFaceSuccess:(void (^)(NSArray *list))success failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    NSString *method = @"face/getGameFace";
    
    [HttpRequestHelper POST:method params:nil success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

/**
 获取用户喜欢玩的游戏
 
 @param uid 本人uid
 
 */
+ (void)requestGetUserFavoriteGameWithUid:(UserID )uid success:(void (^)(NSArray *listArray))success failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    NSString *method = @"game/v4/match/gameUserLikes";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params safeSetObject:@(uid) forKey:@"uid"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        NSMutableArray *dataArray = [NSMutableArray array];
        NSArray *dataList = [CPGameListModel modelsWithArray:data];
        for (int i = 0; i < dataList.count; i++) {
            CPGameListModel *model = dataList[i];
            if ([model.platform isEqualToString:@"ios"] || [model.platform isEqualToString:@"all"]) {
                [dataArray addObject:model];
            }
        }
        if (success) {
            success(dataArray);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

#pragma mark --- 开启 关闭 家长模式 ---
/**
 开启 关闭 家长模式
 @param uid 本人id
 
 @param password 家长模式密码password
 
 @param status status  0-关闭 | 1-开启
 */
+ (void)requestOpenOrCloseParentModelWithUid:(UserID )uid password:(NSString *)password status:(NSInteger )status success:(void (^)(BOOL success))success failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    NSString *method = @"user/openOrClose";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params safeSetObject:@(uid) forKey:@"uid"];
    [params safeSetObject:[DESEncrypt encryptUseDES:password key:keyWithType(KeyType_PwdEncode, YES)] forKey:@"password"];
    [params safeSetObject:@(status) forKey:@"status"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        if (success) {
            success(YES);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

#pragma mark --- 活动入口统计 ---
/**
 活动入口统计
 @param type 入口，1-首页，2-房间
 
 @param actId 活动id
 
 */
+ (void)requestActivityWithType:(NSString *)type withActId:(NSString *)actId success:(void (^)(BOOL success))success failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString *method = @"charge/activity/visit/log";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params safeSetObject:type forKey:@"type"];
    [params safeSetObject:actId forKey:@"actId"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        if (success) {
            success(YES);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}


#pragma mark --- 话匣子游戏 ---
/**
 话匣子游戏，获取游戏内容
 
 */
+ (void)requestChatterboxGameListSuccess:(void (^)(NSArray *listArray))success failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    
    NSString *method = @"topicBoxItem/list";
    
    [HttpRequestHelper POST:method params:nil success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

/**
 话匣子游戏，是否可以发起
 
 @param uid 本人id
 
 @param uidTo 对方id
 */
+ (void)requestChatterboxGameLaunchLWithUid:(UserID )uid uidTo:(UserID )uidTo success:(void (^)(NSDictionary *dict))success failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    
    NSString *method = @"topicBoxMsg/canSend";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params safeSetObject:@(uid) forKey:@"from"];
    [params safeSetObject:@(uidTo) forKey:@"to"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

/**
 话匣子游戏，抛点数上报
 
 @param uid 本人id
 
 @param uidTo 对方id
 */
+ (void)requestChatterboxGameReportLWithUid:(UserID )uid uidTo:(UserID )uidTo withType:(NSInteger )type success:(void (^)(BOOL success))success failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString *method = @"topicBoxMsg/report";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params safeSetObject:@(uid) forKey:@"from"];
    [params safeSetObject:@(uidTo) forKey:@"to"];
    [params safeSetObject:@(type) forKey:@"type"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        if (success) {
            success(YES);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}
@end
