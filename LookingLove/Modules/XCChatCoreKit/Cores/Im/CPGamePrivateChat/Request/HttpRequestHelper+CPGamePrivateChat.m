//
//  HttpRequestHelper+CPGamePrivateChat.m
//  XCChatCoreKit
//
//  Created by new on 2019/2/20.
//  Copyright © 2019 KevinWang. All rights reserved.
//

#import "HttpRequestHelper+CPGamePrivateChat.h"
#import "CPGameListModel.h"
#import "NSMutableDictionary+Safe.h"
@implementation HttpRequestHelper (CPGamePrivateChat)


+ (void)requestGameUrlFromPrivateChatUid:(UserID )uid Name:(NSString *)name ReceiveUid:(UserID )receiveUid ReceiveName:(NSString *)receiveName GameId:(NSString *)gameId ChannelId:(NSString *)channelId MessageId:(NSString *)messageId success:(void(^)(NSDictionary *dataDict))success failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    NSString *method = @"game/v1/gameInfo/getGameUrlV2";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(uid) forKey:@"uid"];
    [params safeSetObject:name forKey:@"name"];
    [params safeSetObject:@(receiveUid) forKey:@"receiveUid"];
    [params safeSetObject:receiveName forKey:@"receiveName"];
    [params safeSetObject:gameId forKey:@"gameId"];
    [params safeSetObject:channelId forKey:@"channelId"];
    [params safeSetObject:messageId forKey:@"messageId"];
    
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

+ (void)requestCPGamePrivateChatList:(UserID )uid PageNum:(NSInteger )num PageSize:(NSInteger )size success:(void (^)(NSArray *list))success failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    NSString *method = @"game/v1/gameInfo/pk1v1";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(uid) forKey:@"uid"];
    [params safeSetObject:@(num) forKey:@"pageNum"];
    [params safeSetObject:@(size) forKey:@"pageSize"];
    [params safeSetObject:@(2) forKey:@"type"];
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

+ (void)requestCPGamePublicChatAndNormalRoomList:(UserID )uid PageNum:(NSInteger )num PageSize:(NSInteger )size success:(void (^)(NSArray *list))success failure:(void (^)(NSNumber *resCode, NSString *message))failure{
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

+ (void)requestCancelGameInviteWith:(UserID )uid MsgIds:(NSString *)msgIds success:(void (^)(BOOL success))success failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    NSString *method = @"game/v2/gameInvite/cancel";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(uid) forKey:@"uid"];
    [params safeSetObject:msgIds forKey:@"msgIds"];
    
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

+ (void)requestWatchGameWith:(UserID )uid GameId:(NSString *)gameId ChannelId:(NSString *)channelId MessageId:(NSString *)messageId success:(void (^)(NSString *urlString))success failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    
    NSString *method = @"game/v1/gameInfo/watchGameUrlV2";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(uid) forKey:@"uid"];
    [params safeSetObject:gameId forKey:@"gameId"];
    [params safeSetObject:channelId forKey:@"channelId"];
    [params safeSetObject:messageId forKey:@"messageId"];
    
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

+ (void)requestSharePictureWith:(NSString *)avatar ErbanNo:(UserID )erbanNo Nick:(NSString *)nick GameResult:(NSString *)gameResult success:(void (^)(NSString *urlString))success failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    
    NSString *method = @"picture/getSharePicture";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:avatar forKey:@"avatar"];
    [params safeSetObject:@(erbanNo) forKey:@"erbanNo"];
    [params safeSetObject:nick forKey:@"nick"];
    [params safeSetObject:gameResult forKey:@"gameResult"];
    
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

+ (void)requestGameDetailGameId:(NSString *)gameId roomUid:(UserID)roomUid Success:(void (^)(CPGameListModel *model))success failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    
    NSString *method = @"api/act/game/party/info";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:gameId forKey:@"gameId"];
    [params safeSetObject:@(roomUid) forKey:@"roomUid"];
    [HttpRequestHelper GET:method params:params success:^(id data) {
        if (success) {
            success([CPGameListModel modelWithJSON:data]);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+ (void)requestGameCloseByGameId:(NSString *)gameId roomUid:(UserID)roomUid Success:(void (^)(void))success failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    
    NSString *method = @"api/act/game/party/cancel";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:gameId forKey:@"gameId"];
    [params safeSetObject:@(roomUid) forKey:@"roomUid"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        if (success) {
            success();
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}
@end
