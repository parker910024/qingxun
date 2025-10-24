//
//  HttpRequestHelper+MentoringShip.m
//  XCChatCoreKit
//
//  Created by gzlx on 2019/1/21.
//  Copyright © 2019年 KevinWang. All rights reserved.
//

#import "HttpRequestHelper+MentoringShip.h"
#import "MasterAdvertisementModel.h"
#import "UserInfo.h"
#import "AuthCore.h"


@implementation HttpRequestHelper (MentoringShip)

/**
 是不是可以收徒
 
 @param uid 操作者的Uid
 @param success 成功
 @param failure 失败
 */
+ (void)userCanHarvestApprenticeWithUid:(UserID)uid
                                success:(void(^)(NSDictionary *dic))success
                                   fail:(void(^)(NSString * message, NSNumber * failCode))failure{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(uid) forKey:@"operUid"];
    NSString * method = @"master/apprentice/enable";
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success(data);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(message, resCode);
    }];
}


/**
 请求收徒
 
 @param uid 操作者的uid
 @param success 成功
 @param failure 失败
 */
+ (void)requstToHarvestApprcnticeWithUid:(UserID)uid
                                 success:(void(^)(NSDictionary *dic))success
                                    fail:(void(^)(NSString * message, NSNumber * failCode))failure{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(uid) forKey:@"operUid"];
    NSString * method = @"master/apprentice/get/apprentice";
    [HttpRequestHelper POST:method params:params success:^(id data) {
        NSDictionary * dic = @{@"uid":data};
        success(dic);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(message, resCode);
    }];
}


/**
 请求师徒关系的b跑马灯
 
 @param page 当前的页数
 @param pageSize 一页的个数
 @param success 成功
 @param failure 失败
 */
+ (void)getMasterAndApprenticeRelationShipListWithPage:(int)page
                                              pageSize:(int)pageSize
                                               success:(void(^)(NSArray *ships))success
                                                  fail:(void(^)(NSString * message, NSNumber * failCode))failure{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(page) forKey:@"page"];
    [params safeSetObject:@(pageSize) forKey:@"pageSize"];
    NSString * method  = @"master/apprentice/notice";
    [HttpRequestHelper GET:method params:params success:^(id data) {
        NSArray *models = [MasterAdvertisementModel modelsWithArray:data];
        success(models);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(message, resCode);
    }];
}


/**
 上报任务三
 
 @param userId 师傅的uid
 @param apprenticeUid 徒弟的Uid
 @param success 成功
 @param failure 失败
 */
+ (void)reportTheMentoringShipTaskThreeWithMasterUid:(UserID)userId
                                       apprenticeUid:(UserID)apprenticeUid
                                             success:(void(^)(NSDictionary *dic))success
                                                fail:(void(^)(NSString * message, NSNumber * failCode))failure{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(userId) forKey:@"masterUid"];
    [params safeSetObject:@(apprenticeUid) forKey:@"apprenticeUid"];
    NSString * method = @"master/apprentice/report";
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success(data);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(message, resCode);
    }];
}

/**
 建立师徒关系
 
 @param masterUid 师傅的uid
 @param apprenticeUid 徒弟的Uid
 @param type 1 同意 2 失败
 @param success 成功
 @param failure 失败
 */
+ (void)bulidMentoringShipWithMasterUid:(UserID)masterUid
                          apprenticeUid:(UserID)apprenticeUid
                                   type:(int)type
                                success:(void(^)(NSDictionary *dic))success
                                   fail:(void(^)(NSString * message, NSNumber * failCode))failure{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(masterUid) forKey:@"masterUid"];
    [params safeSetObject:@(apprenticeUid) forKey:@"apprenticeUid"];
    [params safeSetObject:@(type) forKey:@"type"];
    NSString * method = @"master/apprentice/build";
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success(data);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(message, resCode);
    }];
}


/**
师傅给徒弟打招呼
 @param uid 操作者的uid
 @param likedUid 关注的那个人的Uid
 @param success 成功
 @param failure 失败
 */
+ (void)mentoringShipFocusOrGreetToUser:(UserID)uid
                                likeUid:(UserID)likedUid
                                success:(void(^)(NSDictionary *dic))success
                                   fail:(void(^)(NSString * message, NSNumber * failCode))failure{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(uid) forKey:@"masterUid"];
    [params safeSetObject:@(likedUid) forKey:@"apprenticeUid"];
    NSString * method = @"master/apprentice/greet";
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success(data);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(message, resCode);
    }];
}

/**
 请求师徒关系的 我的师徒列表
 
 @param page 当前的页数
 @param pageSize 一页的个数
 @param success 成功
 @param failure 失败
 */
+ (void)getMyMasterAndApprenticeList:(int)page pageSize:(int)pageSize
                             success:(void(^)(NSArray *ships))success
                                fail:(void(^)(NSString * message, NSNumber * failCode))failure {
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(page) forKey:@"page"];
    [params safeSetObject:@(pageSize) forKey:@"pageSize"];
    [params safeSetObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    NSString * method  = @"master/apprentice/relations";
    [HttpRequestHelper GET:method params:params success:^(id data) {
        NSArray *models = [UserInfo modelsWithArray:data];
        success(models);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(message, resCode);
    }];
}

/**
 请求师徒关系的 获取名师榜数据
 
 @param page 当前的页数
 @param pageSize 一页的个数
 @param success 成功
 @param failure 失败
 */
+ (void)getMasterAndApprenticeRankingList:(int)page
                                 pageSize:(int)pageSize
                                     type:(int)type
                                  success:(void(^)(NSArray *ships))success
                                     fail:(void(^)(NSString * message, NSNumber * failCode))failure {
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(page) forKey:@"page"];
    [params safeSetObject:@(pageSize) forKey:@"pageSize"];
    [params safeSetObject:@(type) forKey:@"type"];
    [params safeSetObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    NSString * method  = @"master/apprentice/master/list";
    [HttpRequestHelper GET:method params:params success:^(id data) {
        NSArray *models = [UserInfo modelsWithArray:data[@"masterVos"]];
        success(models);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(message, resCode);
    }];
}

/**
 发送师徒关系邀请
 
 @param masterUid 师傅的uid
 @param apprenticeUid 徒弟的uid
 */
+ (void)masterSendInviteRequestWithMasterUid:(UserID)masterUid
                               apprenticeUid:(UserID)apprenticeUid
                                     success:(void(^)(void))success
                                        fail:(void(^)(NSString * message, NSNumber * failCode))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(masterUid) forKey:@"masterUid"];
    [params safeSetObject:@(apprenticeUid) forKey:@"apprenticeUid"];
    NSString * method = @"master/apprentice/invite";
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success();
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(message, resCode);
    }];
}

/**
 解除师徒关系
 
 @param masterUid 师傅的uid
 @param apprenticeUid 徒弟的uid
 @param operUid 操作人uid
 */
+ (void)masterSendDeleteRequestWithMasterUid:(UserID)masterUid
                               apprenticeUid:(UserID)apprenticeUid
                                     operUid:(UserID)operUid
                                     success:(void(^)(void))success
                                        fail:(void(^)(NSString * message, NSNumber * failCode))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(masterUid) forKey:@"masterUid"];
    [params safeSetObject:@(apprenticeUid) forKey:@"apprenticeUid"];
    [params safeSetObject:@(operUid) forKey:@"operUid"];
    NSString * method = @"master/apprentice/relation/remove";
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success();
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(message, resCode);
    }];
}

/**
 师徒任务3 邀请进房判断师徒任务是否有效
 
 @param masterUid 师傅的uid
 @param apprenticeUid 徒弟的uid
 */
+ (void)mentoringShipInviteEnableWithMasterUid:(UserID)masterUid
                                 apprenticeUid:(UserID)apprenticeUid
                                       success:(void(^)(void))success
                                          fail:(void(^)(NSString * message, NSNumber * failCode))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(masterUid) forKey:@"masterUid"];
    [params safeSetObject:@(apprenticeUid) forKey:@"apprenticeUid"];
    NSString * method = @"master/apprentice/invite/enable";
    [HttpRequestHelper GET:method params:params success:^(id data) {
        success();
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(message, resCode);
    }];
}

+ (void)sendMentoringShipGift:(NSInteger)giftId
       targetUid:(UserID)targetUid
         giftNum:(NSInteger)giftNum
    gameGiftType:(GameRoomGiftType)gameGiftType
            type:(SendGiftType)type
             msg:(NSString *)msg
         success:(void (^)(GiftAllMicroSendInfo *info))success
         failure:(void (^)(NSNumber *, NSString *))failure {
    
    NSString *method = @"gift/mentoring/send";
    UserID uid = [GetCore(AuthCore) getUid].userIDValue;
    NSString *ticket = [GetCore(AuthCore) getTicket];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(giftId) forKey:@"giftId"];
    [params setObject:@(targetUid) forKey:@"targetUid"];
    [params setObject:@(uid) forKey:@"uid"];
    [params setObject:@(type) forKey:@"type"];
    [params setObject:ticket forKey:@"ticket"];
    [params safeSetObject:msg forKey:@"msg"];
    
    if (giftNum == 0) {
        [params setObject:@(1) forKey:@"giftNum"];
    }else {
        [params setObject:@(giftNum) forKey:@"giftNum"];
    }
    

    [HttpRequestHelper POST:method params:params success:^(id data) {
        
        GiftAllMicroSendInfo *info = [GiftAllMicroSendInfo modelWithJSON:data];
        success(info);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

/**
 抢徒弟
 
 @param masterUid 师傅的uid
 @param apprenticeUid 徒弟的uid
 */
+ (void)mentoringShipGrabApprenticeWithMasterUid:(UserID)masterUid
                                   apprenticeUid:(UserID)apprenticeUid
                                         success:(void(^)(void))success
                                            fail:(void(^)(NSString * message, NSNumber * failCode))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(masterUid) forKey:@"masterUid"];
    [params safeSetObject:@(apprenticeUid) forKey:@"apprenticeUid"];
    NSString * method = @"master/apprentice/grab";
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success();
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(message, resCode);
    }];
}

@end
