//
//  HttpRequestHelper+Auth.m
//  BberryCore
//
//  Created by chenran on 2017/3/5.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "HttpRequestHelper+User.h"
#import "AuthCore.h"
#import "LinkedMeCore.h"
#import "UserCar.h"
#import "UserGiftAchievementList.h"


@implementation HttpRequestHelper (User)


+ (void)requestRecommendChannelSuccess:(void (^)(UserID))success failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"/user/recommend/room";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:[GetCore(AuthCore)getUid] forKey:@"uid"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        UserID roomUid = [NSString stringWithFormat:@"%@",data[@"recommendRoomUid"]].userIDValue;
        success(roomUid);
    } failure:^(NSNumber *resCode, NSString *message) {
        
    }];
    
}

+ (void)getUserInfo:(UserID)userId success:(void (^)(UserInfo *))success failure:(void (^)(NSNumber *, NSString *))failure
{
    if (userId <= 0) {
        return;
    }
    
    NSString *method = @"user/get";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(userId) forKey:@"uid"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {

        UserInfo *userInfo = [UserInfo yy_modelWithDictionary:data];
        if (success) {
            success(userInfo);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            NSDictionary *userInfo1 = [NSDictionary dictionaryWithObjectsAndKeys:message, NSLocalizedDescriptionKey,nil];
            NSError *error = [[NSError alloc]initWithDomain:NSCocoaErrorDomain code:[resCode integerValue] userInfo:userInfo1];
            [[XCLogger shareXClogger]sendLog:@{EVENT_ID:User_get,@"uid":[GetCore(AuthCore)getUid].length>0?[GetCore(AuthCore)getUid]:@"0",@"targetUid":[NSString stringWithFormat:@"%lld",userId]} error:error topic:BussinessLog logLevel:XCLogLevelError];
            failure(resCode, message);
        }
    }];
}

+ (void) getUserInfoExtension:(UserID )userId
                      request:(QueryUserInfoExtension)request
                      success:(void (^)(UserInfo *))success
                      failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString *method = [HttpRequestHelper queryMethodByRequestType:request];
    if (method.length <= 0) {
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(userId) forKey:@"uid"];
    
    params = [self creatTheExtensionParams:params requestType:request userId:userId];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        XCFamily *family = [XCFamily yy_modelWithDictionary:data];
        UserInfo *userInfo = [[UserInfo alloc]init];
        userInfo.uid = userId;
        userInfo.family = family;

//        UserInfo *userInfo = [UserInfo modelDictionary:data];

        if (success) {
            success(userInfo);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            NSDictionary *userInfo1 = [NSDictionary dictionaryWithObjectsAndKeys:message, NSLocalizedDescriptionKey,nil];
            NSError *error = [[NSError alloc]initWithDomain:NSCocoaErrorDomain code:[resCode integerValue] userInfo:userInfo1];
            [[XCLogger shareXClogger]sendLog:@{EVENT_ID:User_get,@"uid":[GetCore(AuthCore)getUid].length>0?[GetCore(AuthCore)getUid]:@"0",@"targetUid":[NSString stringWithFormat:@"%lld",userId]} error:error topic:BussinessLog logLevel:XCLogLevelError];
            failure(resCode, message);
        }
    }];
}

+ (void)getUserInfos:(NSArray *)userIds success:(void (^)(NSArray *))success failure:(void (^)(NSNumber *, NSString *))failure
{
    if (userIds.count <= 0) {
        return;
    }
    
    NSString *method = @"user/list";
    NSMutableString *strUidList = [[NSMutableString alloc] init];
    for (int index = 0; index < [userIds count]; index++) {
        [strUidList appendString:[NSString stringWithFormat:@"%@", userIds[index]]];
        if (index != [userIds count] - 1) {
            [strUidList appendString:@","];
        }
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:strUidList forKey:@"uids"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        NSArray *userInfos = [UserInfo modelsWithArray:data];
        if (success) {
            success(userInfos);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+ (void)getReceiveGift:(UserID)userId orderType:(OrderType)orderType success:(void(^)(NSArray *))success failure:(void(^)(NSNumber *resCode,NSString *message)) failure{
    if (userId <= 0) {
        return;
    }
    NSString *method = @"giftwall/get";
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:@(userId) forKey:@"uid"];
    [params setObject:@(orderType) forKey:@"orderType"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        NSArray * userGifts = [UserGift modelsWithArray:data];
        if (success) {
            success(userGifts);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode,message);
        }
    }];
}

//获取礼物墙成就列表
+ (void)getAchieveGiftForUid:(UserID)targetUid success:(void(^)(NSArray *))success failure:(void(^)(NSNumber *resCode,NSString *message)) failure {
    
    NSString *method = @"giftwall/getAchievementList";
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:@(targetUid) forKey:@"targetUid"];
    [params setObject:GetCore(AuthCore).getUid forKey:@"uid"];

    [HttpRequestHelper GET:method params:params success:^(id data) {
        NSArray *modelArray = [UserGiftAchievementList modelsWithArray:data];
        !success ?: success(modelArray);
    } failure:^(NSNumber *resCode, NSString *message) {
        !failure ?: failure(resCode, message);
    }];
}

+ (void) updateUserInfo:(UserID)userId
              userInfos:(NSDictionary *)userInfos
                success:(void (^)(UserInfo *))success
                failure:(void (^)(NSNumber *resCode, NSString *message))failure
{
    if (userId <= 0) {
        return;
    }
    
    NSString *ticket = GetCore(AuthCore).getTicket;
    
    NSString *method = @"user/v2/update";
    NSMutableDictionary *params = [userInfos mutableCopy];
    [params setObject:@(userId) forKey:@"uid"];
    [params setObject:ticket forKey:@"ticket"];
    if (GetCore(LinkedMeCore).linkme) {
        if (GetCore(LinkedMeCore).linkme.roomuid != nil) {
            [params setObject:GetCore(LinkedMeCore).linkme.roomuid forKey:@"roomUid"];
        }
        if (GetCore(LinkedMeCore).linkme.uid != nil) {
            [params setObject:GetCore(LinkedMeCore).linkme.uid forKey:@"shareUid"];
        }
        if (GetCore(LinkedMeCore).channel != nil) {
            [params setObject:GetCore(LinkedMeCore).channel forKey:@"shareChannel"];
        }
    }
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        UserInfo *userInfo = [UserInfo modelDictionary:data];

        if (success) {
            success(userInfo);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

//上传用户相册图片到服务器
+ (void)uploadImageURLToServerWithURL:(NSString *)urlStr success:(void (^)(BOOL))success failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"photo/v2/upload";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *uid = [GetCore(AuthCore) getUid];
    NSString *ticket = [GetCore(AuthCore) getTicket];
    [params setObject:uid forKey:@"uid"];
    [params setObject:urlStr forKey:@"photoStr"];
    [params setObject:ticket forKey:@"ticket"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success(YES);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

//删除用户图片
+ (void)deleteImageToServerWithpid:(NSString *)pid success:(void (^)(BOOL))success failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"photo/delPhoto";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *uid = [GetCore(AuthCore) getUid];
    NSString *ticket = [GetCore(AuthCore)getTicket];
    [params setObject:uid forKey:@"uid"];
    [params setObject:pid forKey:@"pid"];
    [params setObject:ticket forKey:@"ticket"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success(YES);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}


+ (NSString *)queryMethodByRequestType:(QueryUserInfoExtension)request {
    switch (request) {
        case QueryUserInfoExtension_Family:
            return @"family/familyInfo";
            break;
        case QueryUserInfoExtension_Photo:
            break;
        case QueryUserInfoExtension_Car:
            break;
        case QueryUserInfoExtension_Full:
            break;
        case QueryUserInfoExtension_Basic:
            break;
        case QueryUserInfoExtension_Noble:
            break;
        case QueryUserInfoExtension_HeadWear:
            break;
        case QueryUserInfoExtension_LevelInfo:
            break;
        default:
            return @"";
            break;
    }
    return @"";
}

+ (NSMutableDictionary *)creatTheExtensionParams:(NSMutableDictionary *)params requestType:(QueryUserInfoExtension)request userId:(UserID)userId {
    switch (request) {
        case QueryUserInfoExtension_Family:
        {
            NSInteger familyId = [GetCore(UserCore)getUserInfoInDB:userId].familyId;
            [params safeSetObject:@(familyId) forKey:@"familyId"];
            return params;
        }
            break;
        case QueryUserInfoExtension_Photo:
            break;
        case QueryUserInfoExtension_Car:
            break;
        case QueryUserInfoExtension_Full:
        {
            NSInteger familyId = [GetCore(UserCore)getUserInfoInDB:userId].familyId;
            [params safeSetObject:@(familyId) forKey:@"familyId"];
            return params;
        }
            break;
        case QueryUserInfoExtension_Basic:
            break;
        case QueryUserInfoExtension_Noble:
            break;
        case QueryUserInfoExtension_HeadWear:
            break;
        case QueryUserInfoExtension_LevelInfo:
            break;
        default:
            return params;
            break;
    }
    return params;
}


/**
 获取用户守护榜
 
 @param userId 用户id
 @param success 成功
 @param failure 失败
 */
+ (void)getUserGuardRank:(UserID)userId
                 success:(void (^)(UserRankingInfo *userRankingInfo))success
                 failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    
    NSString *method = @"userRank/rankings/summary";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *ticket = [GetCore(AuthCore)getTicket];
    [params setObject:@(userId) forKey:@"uid"];
    [params setObject:ticket forKey:@"ticket"];
    
    

    [HttpRequestHelper GET:method params:params success:^(id data) {
        
        UserRankingInfo *userRankingInfo = [UserRankingInfo modelDictionary:data];
        if (success) {
            success(userRankingInfo);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode,message);
        }
    }];
    
}

#pragma mark -
#pragma mark 公会线业务  - 萝卜礼物

/**
 用户获得的萝卜礼物
 
 @param userID 用户 uid
 */
+ (void)getReceiveCarrotGift:(UserID)userID
                     success:(void(^)(NSArray *))success
                     failure:(void(^)(NSNumber *resCode,NSString *message)) failure {
    NSString *interface = @"radish/gift/wall/get";
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:@(userID) forKey:@"uid"];
    
    [HttpRequestHelper GET:interface params:dict success:^(id data) {
        NSArray * carrotGifts = [UserGift modelsWithArray:data];
        !success ? : success(carrotGifts);
    } failure:^(NSNumber *resCode, NSString *message) {
        !failure ? : failure(resCode, message);
    }];
}

#pragma mark - 更新 位置开关
/**
 更新 位置开关
 
 @param showLocation 位置开关
 */
+ (void)updateUserInfoLocationSwitch:(BOOL)showLocation
                             success:(void(^)(void))success
                             failure:(void(^)(NSNumber *resCode,NSString *message))failure {
    NSString *interface = @"user/address/show";
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [dict setObject:@(showLocation) forKey:@"showLocation"];
    
    [HttpRequestHelper POST:interface params:dict success:^(id data) {
        success();
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

 #pragma mark - 更新 年龄开关
 /**
  更新 年龄开关
  
  @param show 是否显示年龄
  */
 + (void)updateUserInfoAgeSwitch:(BOOL)show
                      completion:(HttpRequestHelperCompletion)completion {
     
     NSMutableDictionary *params = [NSMutableDictionary dictionary];
     [params setObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
     [params setObject:@(show) forKey:@"showAge"];
     
     [HttpRequestHelper request:@"user/showAge"
                         method:HttpRequestHelperMethodPOST
                         params:params
                     completion:completion];
 }

 #pragma mark - 更新匹配聊天开关
 /**
  更新匹配聊天开关
  
  @param show 是否显示匹配聊天
  */
+ (void)updateUserInfoMatchChatSwitch:(BOOL)show
                           completion:(HttpRequestHelperCompletion)completion {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params setObject:@(show) forKey:@"matchChat"];
    
    [HttpRequestHelper request:@"user/matchChat"
                        method:HttpRequestHelperMethodPOST
                        params:params
                    completion:completion];
}

#pragma mark - 消息设置
/// 获取用户消息设置状态
+ (void)requestUserInfoNotifyStatusWithCompletion:(HttpRequestHelperCompletion)completion {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    
    [HttpRequestHelper request:@"user/msgNotify"
                        method:HttpRequestHelperMethodGET
                        params:params
                    completion:completion];
}

/// 更新系统消息状态
+ (void)updateUserInfoSystemNotify:(BOOL)notify completion:(HttpRequestHelperCompletion)completion {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params setObject:@(notify) forKey:@"sysMsgNotify"];

    [HttpRequestHelper request:@"user/sysMsgNotify"
                        method:HttpRequestHelperMethodPOST
                        params:params
                    completion:completion];
}

/// 更新互动消息状态
+ (void)updateUserInfoInteractionNotify:(BOOL)notify completion:(HttpRequestHelperCompletion)completion {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params setObject:@(notify) forKey:@"interactiveMsgNotify"];

    [HttpRequestHelper request:@"user/interactiveMsgNotify"
                        method:HttpRequestHelperMethodPOST
                        params:params
                    completion:completion];
}

#pragma mark - 随机用户信息
/// 用户选择随机资料
/// @param type 随机头像，随机昵称
+ (void)userRandomInfoWithType:(NSInteger)type andCompletionHandler:(HttpRequestHelperCompletion)completion {
    
    NSString *method = @"userRandom/getAvatar";
    if (type == 1001) {
        method = @"userRandom/getNickname";
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [HttpRequestHelper request:method
                        method:HttpRequestHelperMethodGET
                        params:params
                    completion:completion];
}

/// 用户随机资料开关
/// @param completion 完成回调
+ (void)getUserRandomInfoStatusAndCompletionHandler:(HttpRequestHelperCompletion)completion {
    NSString *method = @"userRandom/getConfig";
        
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [HttpRequestHelper request:method
                        method:HttpRequestHelperMethodGET
                        params:params
                    completion:completion];
}
@end
