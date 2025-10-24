//
//  CPGameCore.m
//  XCChatCoreKit
//
//  Created by new on 2019/1/10.
//  Copyright © 2019 KevinWang. All rights reserved.
//

#import "CPGameCore.h"
#import "HttpRequestHelper+CPGame.h"
#import "CPGameCoreClient.h"
#import "ImMessageCoreClient.h"
#import "Attachment.h"
#import "AuthCore.h"


@implementation CPGameCore


- (RACSignal *)GameOpenCPModeWithRoomUid:(NSString *)roomUid{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [HttpRequestHelper requestGameOpenCPModeWithRoomUid:roomUid success:^(BOOL success) {
            [subscriber sendCompleted];
        } failure:^(NSNumber *resCode, NSString *message) {
            NSError *error = [[NSError alloc]initWithDomain:message code:[resCode integerValue] userInfo:nil];
            [subscriber sendError:error];
        }];
        return nil;
    }];
}

- (RACSignal *)GameCloseCPModeWithRoomUid:(NSString *)roomUid{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [HttpRequestHelper requestGameCloseCPModeWithRoomUid:roomUid success:^(BOOL success) {
            [subscriber sendCompleted];
        } failure:^(NSNumber *resCode, NSString *message) {
            NSError *error = [[NSError alloc]initWithDomain:message code:[resCode integerValue] userInfo:nil];
            [subscriber sendError:error];
        }];
        return nil;
    }];
}

- (RACSignal *)requestCPGameList:(NSString *)roomUid PageNum:(NSInteger )num PageSize:(NSInteger )size{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [HttpRequestHelper requestCPGameList:roomUid PageNum:num PageSize:size success:^(NSArray * _Nonnull list) {
            NotifyCoreClient(CPGameCoreClient, @selector(onCPRoomGetGameList:), onCPRoomGetGameList:list);
            [subscriber sendNext:list];
            [subscriber sendCompleted];
        } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
            NSError *error = [[NSError alloc]initWithDomain:message code:[resCode integerValue] userInfo:nil];
            [subscriber sendError:error];
        }];
        return nil;
    }];
}


- (RACSignal *)requestCPGameListWithoutType:(NSString *)roomUid PageNum:(NSInteger )num PageSize:(NSInteger )size{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [HttpRequestHelper requestCPGameListWithoutType:roomUid PageNum:num PageSize:size success:^(NSArray * _Nonnull list) {
            NotifyCoreClient(CPGameCoreClient, @selector(onCPRoomGetGameListWithoutType:), onCPRoomGetGameListWithoutType:list);
            [subscriber sendNext:list];
            [subscriber sendCompleted];
        } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
            NSError *error = [[NSError alloc]initWithDomain:message code:[resCode integerValue] userInfo:nil];
            [subscriber sendError:error];
        }];
        return nil;
    }];
}


- (RACSignal *)requestCPGameListWithSelectGame:(NSString *)roomUid PageNum:(NSInteger )num PageSize:(NSInteger )size{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [HttpRequestHelper requestCPGameListWithoutType:roomUid PageNum:num PageSize:size success:^(NSArray * _Nonnull list) {
            [subscriber sendNext:list];
            [subscriber sendCompleted];
        } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
            NSError *error = [[NSError alloc]initWithDomain:message code:[resCode integerValue] userInfo:nil];
            [subscriber sendError:error];
        }];
        return nil;
    }];
}


- (void)requestGameUrlUid:(UserID )uid Name:(NSString *)name Roomid:(UserID )roomId GameId:(NSString *)gameid ChannelId:(NSString *)channelid AiUId:(UserID )aiUId{
        [HttpRequestHelper requestGameUrlUid:uid Name:name Roomid:roomId GameId:gameid ChannelId:channelid AiUId:aiUId success:^(NSString * _Nonnull urlString) {
            NotifyCoreClient(CPGameCoreClient, @selector(onCPRoomGameUrl:), onCPRoomGameUrl:urlString);
        } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
            
        }];
}


// 游戏页面重新请求游戏链接
- (RACSignal *)requestGameUrlFromGamePageUid:(UserID )uid Name:(NSString *)name Roomid:(UserID )roomId GameId:(NSString *)gameid ChannelId:(NSString *)channelid AiUId:(UserID )aiUId{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [HttpRequestHelper requestGameUrlUid:uid Name:name Roomid:roomId GameId:gameid ChannelId:channelid AiUId:aiUId success:^(NSString * _Nonnull urlString) {
            NotifyCoreClient(CPGameCoreClient, @selector(onCPRoomGameUrlFromWebViewPage:), onCPRoomGameUrlFromWebViewPage:urlString);
            [subscriber sendCompleted];
        } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
            NSError *error = [[NSError alloc]initWithDomain:message code:[resCode integerValue] userInfo:nil];
            [subscriber sendError:error];
        }];
        return nil;
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
- (RACSignal *)requestGameRoomid:(UserID )roomId WithGameStatus:(NSInteger)status GameId:(NSString *)gameid gameName:(NSString *)gameName StartUid:(NSString *)startUid{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [HttpRequestHelper requestGameRoomid:roomId WithGameStatus:status GameId:gameid gameName:gameName StartUid:startUid success:^(BOOL success) {
            [subscriber sendCompleted];
        } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
            NSError *error = [[NSError alloc]initWithDomain:message code:[resCode integerValue] userInfo:nil];
            [subscriber sendError:error];
        }];
        return nil;
    }];
}




/**
 请求游戏开始链接
 
 @param uid 用户uid
 @param roomId 房主uid
 @param gameid 游戏ID
 @param channelid 厂商ID
 @param uidLeft 左边人的id
 @param uidRight 右边人的id
 */
- (RACSignal *)requestWatchGameUrlUid:(UserID )uid Roomid:(UserID )roomId GameId:(NSString *)gameid ChannelId:(NSString *)channelid UidLeft:(UserID )uidLeft UidRight:(UserID )uidRight{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [HttpRequestHelper requestWatchGameUrlUid:uid Roomid:roomId GameId:gameid ChannelId:channelid UidLeft:uidLeft UidRight:uidRight success:^(NSString * _Nonnull urlString) {
            NotifyCoreClient(CPGameCoreClient, @selector(onCPRoomUrlWithWatchGame:), onCPRoomUrlWithWatchGame:urlString);
            [subscriber sendCompleted];
        } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
            NSError *error = [[NSError alloc]initWithDomain:message code:[resCode integerValue] userInfo:nil];
            [subscriber sendError:error];
        }];
        return nil;
    }];
}

- (RACSignal *)requestGameOverGameResult:(NSString *)gameResult{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [HttpRequestHelper requestGameOverGameResult:gameResult success:^(BOOL success) {
            [subscriber sendCompleted];
        } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
            NSError *error = [[NSError alloc]initWithDomain:message code:[resCode integerValue] userInfo:nil];
            [subscriber sendError:error];
        }];
        return nil;
    }];
}


- (RACSignal *)requestGameOverGameWithChatResult:(NSString *)gameResult WithMessageID:(NSString *)messageId{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [HttpRequestHelper requestGameOverGameWithChatResult:gameResult WithMessageID:messageId success:^(BOOL success) {
            [subscriber sendCompleted];
        } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
            NSError *error = [[NSError alloc]initWithDomain:message code:[resCode integerValue] userInfo:nil];
            [subscriber sendError:error];
        }];
        return nil;
    }];
}


/**
 请求主页游戏列表
 
 @param uid 本人uid
 
 */
- (RACSignal *)requestGameList:(UserID )uid PageNum:(NSInteger )num PageSize:(NSInteger )size{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [HttpRequestHelper requestGameList:uid PageNum:num PageSize:size success:^(NSArray * _Nonnull list) {
            NotifyCoreClient(CPGameCoreClient, @selector(onGameList:), onGameList:list);
            [subscriber sendCompleted];
        } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
            NSError *error = [[NSError alloc]initWithDomain:message code:[resCode integerValue] userInfo:nil];
            [subscriber sendError:error];
        }];
        return nil;
    }];
}

- (RACSignal *)requestGameList:(UserID )uid GameId:(NSString *)gameId{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [HttpRequestHelper requestGameList:uid GameId:gameId success:^(BOOL success) {
            [subscriber sendCompleted];
        } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
            NSError *error = [[NSError alloc]initWithDomain:message code:[resCode integerValue] userInfo:nil];
            [subscriber sendError:error];
        }];
        return nil;
    }];
}



/**
 取消游戏匹配
 
 @param uid 本人uid
 
 */
- (RACSignal *)requestCancelGameMatch:(UserID )uid GameId:(NSString *)gameId{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [HttpRequestHelper requestCancelGameMatch:uid GameId:gameId success:^(BOOL success) {
            [subscriber sendCompleted];
        } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
            NSError *error = [[NSError alloc]initWithDomain:message code:[resCode integerValue] userInfo:nil];
            [subscriber sendError:error];
        }];
        return nil;
    }];
}




/**
 将自己的游戏房加入匹配池。前提是房间没有设置进房限制。并且已经选择了一款游戏，并且另一个麦上没有人
 
 @param uid 本人uid
 @param roomId 房间的ID  是房间roomID 而不是房间的uid
 @param gameId 游戏ID
 
 */
- (RACSignal *)requestRoomJoinMatchPoolList:(UserID )uid RoomID:(NSString *)roomId GameId:(NSString *)gameId{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [HttpRequestHelper requestRoomJoinMatchPoolList:uid RoomID:roomId GameId:gameId success:^(BOOL success) {
            [subscriber sendCompleted];
        } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
            NSError *error = [[NSError alloc]initWithDomain:message code:[resCode integerValue] userInfo:nil];
            [subscriber sendError:error];
        }];
        return nil;
    }];
}



/**
 将自己的游戏房移出匹配池。前提是房间设置了进房限制。或者没有选择一款游戏，或者另一个麦上有人，或者关闭房间，或者关闭游戏模式
 
 @param uid 本人uid
 @param roomId 房间的ID  是房间roomID 而不是房间的uid
 @param gameId 游戏ID
 
 */
- (RACSignal *)requestRoomExitMatchPoolList:(UserID )uid RoomID:(NSString *)roomId GameId:(NSString *)gameId{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [HttpRequestHelper requestRoomExitMatchPoolList:uid RoomID:roomId GameId:gameId success:^(BOOL success) {
            [subscriber sendCompleted];
        } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
            NSError *error = [[NSError alloc]initWithDomain:message code:[resCode integerValue] userInfo:nil];
            [subscriber sendError:error];
        }];
        return nil;
    }];
}


/**
 首页banner
 
 @param bannerType 本人轮播图类型
 
 */
- (RACSignal *)requestGameHomeBanner:(NSInteger )bannerType{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [HttpRequestHelper requestGameHomeBanner:bannerType success:^(NSArray * _Nonnull list) {
            if (bannerType == 3) {
                NotifyCoreClient(CPGameCoreClient, @selector(gameHomeBannerArray:), gameHomeBannerArray:list);
            }else{
                NotifyCoreClient(CPGameCoreClient, @selector(gameHomeListArray:), gameHomeListArray:list);
            }
            [subscriber sendCompleted];
        } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
            NSError *error = [[NSError alloc]initWithDomain:message code:[resCode integerValue] userInfo:nil];
            [subscriber sendError:error];
        }];
        return nil;
    }];
}


- (void)requestGameHomeRankList:(NSString *)uid{
    [HttpRequestHelper requestGameHomeRankList:uid success:^(NSDictionary * _Nonnull list) {
        NotifyCoreClient(CPGameCoreClient, @selector(gameHomeRankListArray:), gameHomeRankListArray:list);
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
    }];
}

- (void)requestGameGetModuleRoomsList{
    [HttpRequestHelper requestGameGetModuleRoomsListSuccess:^(NSArray * _Nonnull listArray) {
        NotifyCoreClient(CPGameCoreClient, @selector(gameHomeModuleListArray:), gameHomeModuleListArray:listArray);
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        NotifyCoreClient(CPGameCoreClient, @selector(gameHomeModuleListArrayError), gameHomeModuleListArrayError);
    }];
}


- (RACSignal *)requestGameListDataForPersonPage:(UserID )uid{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [HttpRequestHelper requestGameListDataForPersonPage:uid success:^(NSArray * _Nonnull listArray) {
            NotifyCoreClient(CPGameCoreClient, @selector(gameDataWithMinePage:), gameDataWithMinePage:listArray);
            [subscriber sendCompleted];
        } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
            NSError *error = [[NSError alloc]initWithDomain:message code:[resCode integerValue] userInfo:nil];
            [subscriber sendError:error];
        }];
        return nil;
    }];
}

/**
 加入找玩友匹配池
 
 @param uid 本人id
 @param findType 选择的限制条件 1/男 2/女 3/不限
 
 */
- (void)addFindFriendMatchPoolWithUid:(UserID )uid WithFindType:(NSInteger )findType{
    [HttpRequestHelper addFindFriendMatchPoolWithUid:uid WithFindType:findType success:^(BOOL success) {
    }                                        failure:^(NSNumber *_Nonnull resCode, NSString *_Nonnull message) {
        // 青少年模式下
        if (resCode.integerValue == 30000) {
            NotifyCoreClient(CPGameCoreClient, @selector(gameCPMatchOnTeenagerModeWarning:), gameCPMatchOnTeenagerModeWarning:
                message);
        }
    }];
}

- (RACSignal *)rac_addFindFriendMatchPoolWithUid:(UserID)uid findType:(NSInteger)findType {
    return [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        [HttpRequestHelper addFindFriendMatchPoolWithUid:uid WithFindType:findType success:^(BOOL success) {

            [subscriber sendNext:@(success)];
            [subscriber sendCompleted];
        } failure:^(NSNumber *_Nonnull resCode, NSString *_Nonnull message) {
            [subscriber sendError:CORE_API_ERROR(RoomCoreErrorDomain, resCode.integerValue, message)];
        }];
        return nil;
    }];
}


/**
 移除找玩友匹配池
 
 @param uid 本人id
 
 */
- (void)removeFindFriendMatchPoolWithUid:(UserID )uid WithFindType:(NSInteger )findType{
    [HttpRequestHelper removeFindFriendMatchPoolWithUid:uid WithFindType:findType success:^(BOOL success) {
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
    }];
}

#pragma mark -- 异性匹配 ---
/**
 添加房主到异性匹配池
 
 @param uid 本人uid
 @param roomId 房间的id
 
 */
- (void)roomOwnerAddOppositeSexMatchPoolWithUid:(UserID )uid WithRoomId:(UserID )roomId{
    [HttpRequestHelper roomOwnerAddOppositeSexMatchPoolWithUid:uid WithRoomId:roomId success:^(BOOL success) {
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
    }];
}

/**
 房主移除异性匹配池
 
 @param uid 本人uid
 
 */
- (void)roomOwnerRemoveOppositeSexMatchPoolWithUid:(UserID )uid{
    [HttpRequestHelper roomOwnerRemoveOppositeSexMatchPoolWithUid:uid success:^(BOOL success) {
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
    }];
}

/**
 添加到异性匹配池
 
 @param uid 本人uid
 @param roomId 房间的id
 
 */
- (void)userAddOppositeSexMatchPoolWithUid:(UserID )uid{
    [HttpRequestHelper userAddOppositeSexMatchPoolWithUid:uid success:^(BOOL success) {
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        
    }];
}

- (RACSignal *)RAC_roomOwnerAddOppositeSexMatchPoolWithUid:(UserID )uid {
    return [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        [HttpRequestHelper userAddOppositeSexMatchPoolWithUid:uid success:^(BOOL success) {
            [subscriber sendNext:@(success)];
            [subscriber sendCompleted];
        } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
            [subscriber sendError:CORE_API_ERROR(RoomCoreErrorDomain, resCode.integerValue, message)];
        }];
        return nil;
    }];
}

/**
 用户移除异性匹配池
 
 @param uid 本人uid
 
 */
- (void)userRemoveOppositeSexMatchPoolWithUid:(UserID )uid{
    [HttpRequestHelper userRemoveOppositeSexMatchPoolWithUid:uid success:^(BOOL success) {
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
    }];
}

#pragma mark -- 嗨聊派对 --
/**
 嗨聊派对匹配
 
 @param uid 本人id
 
 */
- (RACSignal *)userMatchGuildRoomWithUid:(UserID )uid{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [HttpRequestHelper userMatchGuildRoomWithUid:uid success:^(NSString * _Nonnull roomUid) {
            [subscriber sendNext:roomUid];
            [subscriber sendCompleted];
        } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
            [subscriber sendError:CORE_API_ERROR(RoomCoreErrorDomain, resCode.integerValue, message)];
        }];
        return nil;
    }];
}

/**
 嗨聊派对匹配池 每次10个
 
 @auth @lifulong
 
 @time 2019-10-10
 
 @param uid 本人id
 
 */
- (RACSignal *)userMatchGuildRoomListWithUid:(UserID )uid {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [HttpRequestHelper userMatchGuildRoomListWithUid:uid success:^(NSArray * _Nonnull roomUids) {
            self.roomUids = roomUids; // 嗨聊房数据存储
            self.currentRoomIndex = 0; // 嗨聊房默认 index
            [subscriber sendNext:roomUids];
            [subscriber sendCompleted];
        } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
            [subscriber sendError:CORE_API_ERROR(RoomCoreErrorDomain, resCode.integerValue, message)];
        }];
        return nil;
    }];
}


#pragma mark --- 获取游戏表情 ---
/**
 获取游戏表情
 */
- (RACSignal *)requestGetGameFace{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [HttpRequestHelper requestGetGameFaceSuccess:^(NSArray * _Nonnull list) {
            [subscriber sendNext:list];
            [subscriber sendCompleted];
        } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        }];
        return nil;
    }];
}


/**
 获取用户喜欢玩的游戏
 
 @param uid 本人uid
 
 */
- (void)requestGetUserFavoriteGameWithUid:(UserID )uid{
    [HttpRequestHelper requestGetUserFavoriteGameWithUid:uid success:^(NSArray * _Nonnull listArray) {
        NotifyCoreClient(CPGameCoreClient, @selector(findFriendMatchMessageUserFavoriteGame:), findFriendMatchMessageUserFavoriteGame:listArray);
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        
    }];
}

#pragma mark --- 开启 关闭 家长模式 ---
/**
 开启 关闭 家长模式
 @param uid 本人id
 
 @param password 家长模式密码password
 
 @param status status  0-关闭 | 1-开启
 */
- (RACSignal *)requestOpenOrCloseParentModelWithUid:(UserID )uid password:(NSString *)password status:(NSInteger )status {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [HttpRequestHelper requestOpenOrCloseParentModelWithUid:uid password:password status:status success:^(BOOL success) {
            [subscriber sendCompleted];
        } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
            NSError *error;
            [subscriber sendError:error];
        }];
        return nil;
    }];
}

#pragma mark --- 活动入口统计 ---
/**
 活动入口统计
 @param type 入口，1-首页，2-房间
 
 @param actId 活动id
 
 */
- (void)requestActivityWithType:(NSString *)type withActId:(NSString *)actId {
    [HttpRequestHelper requestActivityWithType:type withActId:actId success:^(BOOL success) {
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
    }];
}

#pragma mark --- 话匣子游戏 ---
/**
 话匣子游戏，获取游戏内容
 
 */
- (void)requestChatterboxGameList {
    [HttpRequestHelper requestChatterboxGameListSuccess:^(NSArray * _Nonnull listArray) {
        NotifyCoreClient(CPGameCoreClient, @selector(acquireChatterboxGameListArray:), acquireChatterboxGameListArray:listArray);
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
    }];
}

/**
 话匣子游戏，是否可以发起
 
 @param uid 本人id
 
 @param uidTo 对方id
 */
- (RACSignal *)requestChatterboxGameLaunchLWithUid:(UserID )uid uidTo:(UserID )uidTo {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [HttpRequestHelper requestChatterboxGameLaunchLWithUid:uid uidTo:uidTo success:^(NSDictionary *dict) {
            [subscriber sendNext:dict];
            [subscriber sendCompleted];
        } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
            NSError *error = [[NSError alloc]initWithDomain:message code:[resCode integerValue] userInfo:nil];
            [subscriber sendError:error];
        }];
        return nil;
    }];
}

/**
 话匣子游戏，抛点数上报
 
 @param uid 本人id
 
 @param uidTo 对方id
 
 @param type 1 是发起话匣子游戏  2是抛点数
 */
- (void)requestChatterboxGameReportLWithUid:(UserID )uid uidTo:(UserID )uidTo withType:(NSInteger )type {
    [HttpRequestHelper requestChatterboxGameReportLWithUid:uid uidTo:uidTo withType:type success:^(BOOL success) {
        
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        
    }];
}


@end
