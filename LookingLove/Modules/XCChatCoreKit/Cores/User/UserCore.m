//
//  UserCore.m
//  BberryCore
//
//  Created by chenran on 2017/5/11.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "UserCore.h"

#import "NSObject+YYModel.h"
#import "HttpRequestHelper+User.h"

#import "NSDictionary+Safe.h"
#import "UserCoreClient.h"
#import "AuthCoreClient.h"

#import "AuthCore.h"
#import "XCDBManager.h"

#import "UserCache.h"
#import "UserCar.h"
#import "GuildCore.h"

#import "FamilyCore.h"


@interface UserCore ()<AuthCoreClient, UserCoreClient>

@end


@implementation UserCore

+ (void)load{
    GetCore(UserCore);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        AddCoreClient(AuthCoreClient, self);
        AddCoreClient(UserCoreClient, self);
        self.haddRepairUserInfo = NO;
        [self _configLastLoginUserInfo];
        
        @weakify(self);
        [[self rac_signalForSelector:@selector(onLoginSuccess) fromProtocol:@protocol(AuthCoreClient)] subscribeNext:^(RACTuple *tuple) {
            @strongify(self);
            self.haddRepairUserInfo = NO;
            UserID userId = [GetCore(AuthCore) getUid].userIDValue;//当前用户id
            [self _updateCurrentUserInfo:userId];
        }];
        
        [[self rac_signalForSelector:@selector(onLogout) fromProtocol:@protocol(AuthCoreClient)] subscribeNext:^(id x) {
            NotifyCoreClient(UserCoreClient, @selector(onCurrentUserInfoLogout), onCurrentUserInfoLogout);
        }];
    }
    return self;
}

- (void)onFamilyUpdateUserInfor
{
    self.haddRepairUserInfo = NO;
    UserID userId = [GetCore(AuthCore) getUid].userIDValue;//当前用户id
    [self _updateCurrentUserInfo:userId];
}


- (void)_configLastLoginUserInfo
{
    //获取上次登录用户
    //    UserID userId = [GetCore(AuthCore) getUid].userIDValue;
    //    [GetCoreI(IRealmConfig) setDefaultRealmWithUserID:userId];
    //    NSPredicate *pred = [NSPredicate predicateWithFormat:@"uid = %lld", userId];
    //    RLMResults<UserInfo *> *result = [UserInfo objectsWithPredicate:pred];
    //    UserInfo *userInfo = nil;
    //    if (result && [result count] > 0) {
    //        userInfo = [result firstObject];
    //    }
    //
    //    self.currentUserInfo = userInfo;
}

- (void)_updateCurrentUserInfo:(UserID)userId
{
    @weakify(self);
    UserExtensionRequest *request = [[UserExtensionRequest alloc]init];
    request.type = QueryUserInfoExtension_Full;
    request.needRefresh = YES;
    
    [[self queryExtensionUserInfoByWithUserID:userId requests:@[request]]subscribeNext:^(id x) {
        UserInfo *userInfo = (UserInfo *)x;
        if (userInfo.familyId > 0) {
            [GetCore(FamilyCore)checktFamilyInforWith:[NSString stringWithFormat:@"%ld",(long)userInfo.familyId]];
        }
        
        if (userInfo.hallId > 0) {
            // 如果加入了公会
            [GetCore(GuildCore) requestGuildHallInfoFetchWithHallId:@(userInfo.hallId).stringValue uid:@(userInfo.uid).stringValue];
        }

        if (userInfo.nick.length <= 0 || userInfo.avatar.length <= 0 || userInfo == nil) {
            self.haddRepairUserInfo = NO;
            [self performSelector:@selector(completePersonalInfor:) withObject:@(userId) afterDelay:2];
        } else if (!userInfo.isBindPhone) {
            self.haddRepairUserInfo = NO;
            [self performSelector:@selector(completePersonalInfor:) withObject:@(userId) afterDelay:2];
        } else {
            self.haddRepairUserInfo = YES;
            NotifyCoreClient(UserCoreClient, @selector(onCurrentUserInfoUpdate:), onCurrentUserInfoUpdate:userInfo);
        }
        
        @strongify(self);
        [self cacheUserInfo:userInfo complete:^{

            
        }];
        
    }error:^(NSError *error) {
        [[XCDBManager defaultManager]getUserWithUserID:userId success:^(UserInfo *userInfo) {
            if (userInfo.avatar.length <= 0 || userInfo.nick.length <= 0 || userInfo == nil) {
                [GetCore(AuthCore)logout];
            }
        }];
    }];

}

- (void)completePersonalInfor:(NSNumber *)userId {
    NotifyCoreClient(UserCoreClient, @selector(onCurrentUserInfoNeedComplete:), onCurrentUserInfoNeedComplete:userId.userIDValue);
}

#pragma mark - IUserInfoAction

- (RACSignal *)saveUserInfoWithUserID:(UserID)userId userInfos:(NSDictionary *)userInfos {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [[self saveUserInfoWithUserID:userId userInfos:userInfos isRepair:NO]subscribeNext:^(id x) {
            UserInfo *info = (UserInfo *)x;
            [subscriber sendNext:info];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

- (RACSignal *)saveUserInfoWithUserID:(UserID)userId userInfos:(NSDictionary *)userInfos isRepair:(BOOL)isRepair
{
    @weakify(self);
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [HttpRequestHelper updateUserInfo:userId userInfos:userInfos success:^(UserInfo *userInfo) {
            [subscriber sendNext:userInfo];
            [subscriber sendCompleted];
            if (isRepair) {
                [[BaiduMobStat defaultStat]logEvent:@"login_repari_success" eventLabel:@"注册时候的个人资料保存成功"];
            }
            self.isSaveUserInfo = YES;
            self.haddRepairUserInfo = YES;
            GetCore(AuthCore).info = nil;
            GetCore(AuthCore).qqInfo = nil;
            GetCore(AuthCore).appleInfo = nil;
            [[XCLogger shareXClogger]sendLog:@{@"text":[userInfos yy_modelToJSONString],EVENT_ID:CFillUserData} error:nil topic:BussinessLog logLevel:XCLogLevelVerbose];
            UserExtensionRequest *request = [[UserExtensionRequest alloc]init];
            request.type = QueryUserInfoExtension_Full;
            request.needRefresh = YES;
            [[GetCore(UserCore)queryExtensionUserInfoByWithUserID:userId requests:@[request]]subscribeNext:^(id x) {
                NotifyCoreClient(UserCoreClient, @selector(onCurrentUserInfoUpdate:), onCurrentUserInfoUpdate:x);
            }];
//            [self getUserInfo:userId refresh:YES success:^(UserInfo *info) {
//                NotifyCoreClient(UserCoreClient, @selector(onCurrentUserInfoUpdate:), onCurrentUserInfoUpdate:userInfo);
//            } failure:^(NSError *error) {
//
//            }];
            GetCore(AuthCore).info = nil;
            GetCore(AuthCore).qqInfo = nil;
            GetCore(AuthCore).appleInfo = nil;
        } failure:^(NSNumber *resCode, NSString *message) {
            [subscriber sendError:CORE_API_ERROR(UserCoreErrorDomain, resCode.integerValue, message)];
            NSDictionary *userInfo1 = [NSDictionary dictionaryWithObjectsAndKeys:message, NSLocalizedDescriptionKey,nil];
            NSError *error = [[NSError alloc]initWithDomain:NSCocoaErrorDomain code:[resCode integerValue] userInfo:userInfo1];
            
            if (isRepair) {
                [[BaiduMobStat defaultStat] logEvent:@"login_repari_failed" eventLabel:@"注册时候的个人资料保存失败"];
            }
            
            [[XCLogger shareXClogger]sendLog:@{@"text":[userInfos yy_modelToJSONString],EVENT_ID:CFillUserData} error:error topic:BussinessLog logLevel:XCLogLevelError];
            
            NotifyCoreClient(UserCoreClient, @selector(onSaveUserInfoFailth:errorCode:), onSaveUserInfoFailth:message errorCode:resCode.integerValue);
        }];
        return nil;
    }] doNext:^(UserInfo *userInfo) {
        //保存当前用户信息
        @strongify(self);
        //        [self getUserInfo:userId refresh:YES];
        self.haddRepairUserInfo = YES;
        [self cacheUserInfos:@[userInfo] complete:nil];
    }];
}

#pragma mark - RequestRecommend

- (void)requestRecommendRoomUid {
    [HttpRequestHelper requestRecommendChannelSuccess:^(UserID roomuid) {
        if (roomuid > 0) {
            NotifyCoreClient(UserCoreClient, @selector(onRequestRecommendRoomUidSuccess:), onRequestRecommendRoomUidSuccess:roomuid);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
    }];
}

#pragma mark - IUserInfoQuery

- (NIMUser *)fetchUserByUid:(NSString *)userId {
    return [[NIMSDK sharedSDK].userManager userInfo:userId];
}

- (RACSignal *)requestUserInfo:(UserID)userId
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [HttpRequestHelper getUserInfo:userId success:^(UserInfo *userInfo) {
            [subscriber sendNext:userInfo];
            [subscriber sendCompleted];
        } failure:^(NSNumber *resCode, NSString *message) {
            [subscriber sendError:CORE_API_ERROR(UserCoreErrorDomain, resCode.integerValue, message)];
        }];
        return nil;
    }];
}

- (RACSignal *)requestUserExtensionInfo:(UserID)userId request:(QueryUserInfoExtension)request {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [HttpRequestHelper getUserInfoExtension:userId request:request success:^(UserInfo *userInfo) {
            [subscriber sendNext:userInfo];
            [subscriber sendCompleted];
        } failure:^(NSNumber *resCode, NSString *message) {
            [subscriber sendError:CORE_API_ERROR(UserCoreErrorDomain, resCode.integerValue, message)];
        }];
        return nil;
    }];
}

- (RACSignal *)requestUserInfos:(NSArray *)userIdList
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [HttpRequestHelper getUserInfos:userIdList success:^(NSArray *userInfoList) {
            [subscriber sendNext:userInfoList];
            [subscriber sendCompleted];
        } failure:^(NSNumber *resCode, NSString *message) {
            [subscriber sendError:CORE_API_ERROR(UserCoreErrorDomain, resCode.integerValue, message)];
        }];
        return nil;
    }];
}

- (void)getUserInfo:(UserID)userId refresh:(BOOL)refresh success:(void (^)(UserInfo *))success failure:(void (^)(NSError *))failure
{
    //    UserInfo *userInfo = [[XCDBManager defaultManager]getUserWithUserID:userId];
    [[XCDBManager defaultManager]getUserWithUserID:userId success:^(UserInfo *userInfo) {
        if (userInfo == nil || userInfo.erbanNo.length == 0){
            [self _syncServerUserInfo:userId success:^(UserInfo *info) {
                if(success){
                    success(info);
                }
            } failure:^(NSError *error) {
                if (failure) {
                    failure(error);
                }
            }];
        } else {
            if (refresh){
                [self _syncServerUserInfo:userId success:^(UserInfo *info) {
                    if(success){
                        success(info);
                    }
                } failure:^(NSError *error) {
                    if (failure) {
                        failure(error);
                    }
                }];
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(userInfo);
                    
                });
            }
        }
        
    }];
}

- (RACSignal *)getUserInfoByRac:(UserID)userId refresh:(BOOL)refresh {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[XCDBManager defaultManager]getUserWithUserID:userId success:^(UserInfo *userInfo) {
            if (userInfo == nil || userInfo.erbanNo.length == 0){
                [self _syncServerUserInfo:userId success:^(UserInfo *info) {
                    [subscriber sendNext:info];
                } failure:^(NSError *error) {
                    
                }];
            } else {
                if (refresh){
                    [self _syncServerUserInfo:userId success:^(UserInfo *info) {
                        [subscriber sendNext:info];
                    }failure:^(NSError *error) {
                        
                    }];
                }else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [subscriber sendNext:userInfo];
                    });
                }
            }
            
        }];
        return nil;
    }];
}

- (RACSignal *)getUserInfoByUid:(UserID)uid refresh:(BOOL)refresh {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[[UserCache shareCache]getUserInfoFromCacheWith:uid]subscribeNext:^(id x) {
            if (x) { //缓存或者DB里面有
                
                if (refresh) {
                    [self _syncServerUserInfo:uid success:^(UserInfo *info) {
                        [subscriber sendNext:info];
                        [subscriber sendCompleted];
                    } failure:^(NSError *error) {
                        [subscriber sendError:error];
                    }];
                }else {
                    [subscriber sendNext:x];
                    [subscriber sendCompleted];
                }
                
            }else { //缓存或者DB里面都没有,从网络请求
                [self _syncServerUserInfo:uid success:^(UserInfo *info) {
                    [subscriber sendNext:info];
                    [subscriber sendCompleted];
                }failure:^(NSError *error) {
                    [subscriber sendError:error];
                }];
            }
        }];
        return nil;
    }];
}

- (void)getUserInfos:(NSArray *)userIds refresh:(BOOL) refresh success:(void (^)(NSArray *))success
{
    if (userIds.count > 0) {
        NSMutableArray *userInfos = [NSMutableArray array];
        NSMutableArray *needUpdate = [NSMutableArray array];
        BOOL needRefresh = NO;
        for (NSNumber *userId in userIds) {
            UserInfo *userInfo = [[XCDBManager defaultManager]getUserWithUserID:userId.userIDValue];
            if (userInfo == nil) {
                needRefresh = YES;
                break;
            }else {
                [userInfos addObject:userInfo];
            }
        }
        
        if (refresh) {
            [self _sycServerUserInfos:userIds success:^(NSArray *infoArr) {
                success(infoArr);
                [[XCDBManager defaultManager]creatOrUpdateUsers:infoArr];
            }];
        } else {
            if (needRefresh) {
                [self _sycServerUserInfos:needUpdate success:^(NSArray *infoArr) {
                    [[XCDBManager defaultManager]creatOrUpdateUsers:infoArr];
                    success([infoArr copy]);
                }];

            }else {
                success([userInfos copy]);
            }
        }
    }
}

- (RACSignal *)queryExtensionUserInfoByWithUserID:(UserID)userId request:(UserExtensionRequest *)request {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        if (request.needRefresh) {
            [self _syncServerUserInfoExtension:userId type:request.type success:^(UserInfo *info) {
                [subscriber sendNext:info];
                [subscriber sendCompleted];
            } failure:^(NSError *error) {
                [subscriber sendError:error];
            }];
        }else {
            [[[UserCache shareCache]getUserInfoFromCacheWith:userId]subscribeNext:^(id x) {
                if (x) { //缓存或者DB里面有
                    UserInfo *info = (UserInfo *)x;
                    if (![self judgeUserInfoComplete:info type:request.type]) {
                        [subscriber sendNext:x];
                        [subscriber sendCompleted];
                    }else {
                        [self _syncServerUserInfoExtension:userId type:request.type success:^(UserInfo *info) {
                            [subscriber sendNext:info];
                            [subscriber sendCompleted];
                        } failure:^(NSError *error) {
                            [subscriber sendError:error];
                        }];
                    }
                    
         
                }else { //缓存或者DB里面都没有,从网络请求
                    [self _syncServerUserInfoExtension:userId type:request.type success:^(UserInfo *info) {
                        [subscriber sendNext:info];
                        [subscriber sendCompleted];
                    } failure:^(NSError *error) {
                        [subscriber sendError:error];
                    }];
                }
                
            }];
        }
        
        return nil;
    }];

}


- (RACSignal *)queryExtensionUserInfoByWithUserID:(UserID)userId
                                         requests:(NSArray *)requests {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        __block UserInfo *userInfo = [[UserInfo alloc]init];
//        [[self getUserInfoByUid:userId refresh:NO]subscribeNext:^(id x) {
//            if (x) {
//                userInfo = (UserInfo *)x;
                NSMutableArray *temp = [NSMutableArray arrayWithArray:requests];
                for (UserExtensionRequest *item in requests) {
                    switch (item.type) {
                        case QueryUserInfoExtension_Family:
                        {
//                            [self _syncServerUserInfoExtension:userId type:item.type success:^(UserInfo *info) {
//                                userInfo.family = info.family;
//                            } failure:^(NSError *error) {
//
//                            }];
//                            [[self queryExtensionUserInfoByWithUserID:userId request:item]subscribeNext:^(id x) {
//                                dispatch_main_sync_safe(^{
//                                    userInfo.family = ((UserInfo *)x).family;
//                                    [subscriber sendNext:userInfo];
//                                });
//                            }];
                        }
                        
                            break;
                        case QueryUserInfoExtension_Full:
                        {
                            if (item.needRefresh) {
                                [[self getUserInfoByUid:userId refresh:YES]subscribeNext:^(id x) {
                                    if (x) {
                                        userInfo = (UserInfo *)x;
                                        if (userInfo.familyId > 0) {
                                            UserExtensionRequest *request = [[UserExtensionRequest alloc]init];
                                            request.type = QueryUserInfoExtension_Family;
                                            request.needRefresh = YES;
                                            
                                            [[self queryExtensionUserInfoByWithUserID:userId request:request]subscribeNext:^(id x) {
                                                userInfo.family = ((UserInfo *)x).family;
                                                [temp removeObject:item];
                                                if (temp.count == 0) {
                                                    dispatch_main_sync_safe(^{
                                                        [subscriber sendNext:userInfo];
                                                        NotifyCoreClient(UserCoreClient, @selector(onCurrentUserInfoUpdate:), onCurrentUserInfoUpdate:userInfo);
                                                        [subscriber sendCompleted];
                                                    });
                                                }
                                            }error:^(NSError *error) {
                                                [temp removeObject:item];
                                                if (temp.count == 0) {
                                                    dispatch_main_sync_safe(^{
                                                        [subscriber sendNext:userInfo];
                                                        NotifyCoreClient(UserCoreClient, @selector(onCurrentUserInfoUpdate:), onCurrentUserInfoUpdate:userInfo);
                                                        [subscriber sendCompleted];
                                                    });
                                                }
                                            }];
                                        }else {
                                            [temp removeObject:item];
                                            if (temp.count == 0) {
                                                dispatch_main_sync_safe(^{
                                                    [subscriber sendNext:userInfo];
                                                    NotifyCoreClient(UserCoreClient, @selector(onCurrentUserInfoUpdate:), onCurrentUserInfoUpdate:userInfo);
                                                    [subscriber sendCompleted];
                                                });
                                            }

                                        }
                                        
                                        
                                    }
                                }];
                            }else {
                                [[self getUserInfoByUid:userId refresh:NO]subscribeNext:^(id x) {
                                    if (x) {
                                        userInfo = (UserInfo *)x;
                                        UserExtensionRequest *request = [[UserExtensionRequest alloc]init];
                                        request.type = QueryUserInfoExtension_Family;
                                        request.needRefresh = NO;
                                        [[self queryExtensionUserInfoByWithUserID:userId request:request]subscribeNext:^(id x) {
                                            userInfo.family = ((UserInfo *)x).family;
                                            [temp removeObject:item];
                                            if (temp.count == 0) {
                                                dispatch_main_sync_safe(^{
                                                    [subscriber sendNext:userInfo];
                                                    [subscriber sendCompleted];
                                                });
                                            }
                                        }];
                                        
                                    }
                                }];
                            }
                        }
                            
                            
                            break;
                        default:
                            break;
                    }
                }
//            }
//        }];
        
        return nil;
    }];
}

- (UserInfo *)getUserInfoInDB:(UserID)userId {
    UserInfo *info = [[XCDBManager defaultManager]getUserWithUserID:userId];
    if (info) {
        return info;
    }else {
        UserInfo * infor = [[UserInfo alloc] init];
        info.uid = userId;
        [[XCDBManager defaultManager]creatOrUpdateUser:infor complete:^{
            [[UserCache shareCache]saveUserInfo:infor];
        }];
        
        [self _syncServerUserInfo:userId success:^(UserInfo *info) {
//            NotifyCoreClient(UserCoreClient, @selector(), <#func#>)
        } failure:^(NSError *error) {
            
        }];

    }
    return [[XCDBManager defaultManager]getUserWithUserID:userId];
}

//获取礼物墙
- (void)getReceiveGift:(UserID)userId orderType:(OrderType)orderType{
    if (userId > 0) {

        [HttpRequestHelper getReceiveGift:userId orderType:orderType success:^(NSArray * userGiftList){
            NotifyCoreClient(UserCoreClient, @selector(onGetReceiveGiftSuccess:uid:), onGetReceiveGiftSuccess:userGiftList uid:userId);
        } failure:^(NSNumber *resCode, NSString *message) {
            NotifyCoreClient(UserCoreClient, @selector(onGetReceiveGiftFailth:), onGetReceiveGiftFailth:message);
        }];
    }
}

//获取礼物墙成就列表
- (void)getAchieveGiftForUid:(UserID)targetUid {
    [HttpRequestHelper getAchieveGiftForUid:targetUid success:^(NSArray * userGiftList) {
        NotifyCoreClient(UserCoreClient, @selector(onGetAchievementGiftSuccess:uid:), onGetAchievementGiftSuccess:userGiftList uid:targetUid);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(UserCoreClient, @selector(onGetAchievementGiftFailth:), onGetAchievementGiftFailth:message);
    }];
}

//上传图片url到服务器
- (void)uploadImageUrlToServer:(NSString *)url {
    [HttpRequestHelper uploadImageURLToServerWithURL:url success:^(BOOL isSuccess) {
        NotifyCoreClient(UserCoreClient, @selector(onUploadImageUrlToServerSuccess), onUploadImageUrlToServerSuccess);
        NotifyCoreClient(UserCoreClient, @selector(onCurrentUserInfoUpdate:), onCurrentUserInfoUpdate:nil);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(UserCoreClient, @selector(onUploadImageUrlToServerFailth:), onUploadImageUrlToServerFailth:message);
    }];
}

//删除用户图片
- (void)deleteImageUrlToServerWithPid:(NSString *)pid {
    [HttpRequestHelper deleteImageToServerWithpid:pid success:^(BOOL isSuccess) {
        NotifyCoreClient(UserCoreClient, @selector(deleteImageToServerSuccess), deleteImageToServerSuccess)
        NotifyCoreClient(UserCoreClient, @selector(onCurrentUserInfoUpdate:), onCurrentUserInfoUpdate:nil);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(UserCoreClient, @selector(deleteImageUrlToServerFailth:), deleteImageUrlToServerFailth:message);
    }];
}

//- (UserInfo *)_createNewUserInfo:(UserID)userId
//{
//    UserInfo *aUserInfo = [[UserInfo alloc] init];
//    aUserInfo.uid = userId;
//    [[XCDBManager defaultManager]creatOrUpdateUser:aUserInfo complete:nil];
//    UserInfo *userInfo = [[XCDBManager defaultManager]getUserWithUserID:userId];
//    return userInfo;
//}

- (void)_syncServerUserInfo:(UserID)userId success:(void (^)(UserInfo *))success failure:(void (^)(NSError *))failure
{
    [[self requestUserInfo:userId] subscribeNext:^(id x) {
        UserInfo *newUserInfo = (UserInfo *)x;
        [[XCDBManager defaultManager]creatOrUpdateUser:newUserInfo complete:^{
            [[UserCache shareCache]saveUserInfo:newUserInfo];
            dispatch_main_sync_safe(^{
                if(success){
                    success(newUserInfo);
                }
            });
        }];
    } error:^(NSError *error) {
        dispatch_main_sync_safe(^{
            if (failure) {
                failure(error);
            }
        });
    }];
}

- (void)_syncServerUserInfoExtension:(UserID)userId type:(QueryUserInfoExtension)type success:(void (^)(UserInfo *))success failure:(void (^)(NSError *))failure {
    [[self requestUserExtensionInfo:userId request:type]subscribeNext:^(id x) {
        __block UserInfo *newUserInfo = (UserInfo *)x;
        newUserInfo.uid = userId;
        UserInfo *userInfo = [[XCDBManager defaultManager]getUserWithUserID:userId];
        userInfo.family = newUserInfo.family;
        [[XCDBManager defaultManager]creatOrUpdateUser:userInfo complete:^{
//            newUserInfo = [[XCDBManager defaultManager]getUserWithUserID:userId];
            [[UserCache shareCache]saveUserInfo:userInfo];
            dispatch_main_sync_safe(^{
                if(success){
                    success(newUserInfo);
                }
            });
        }];
    }error:^(NSError *error) {
        dispatch_main_sync_safe(^{
            if (failure) {
                failure(error);
            }
        });
    }completed:^{
        
    }];
}

- (void)_sycServerUserInfos:(NSArray *)userIds success:(void (^)(NSArray *))success
{
    [[self requestUserInfos:userIds] subscribeNext:^(id x) {
        NSArray *newUserInfos = (NSArray *)x;
        [[XCDBManager defaultManager]creatOrUpdateUsers:newUserInfos];
        success(newUserInfos);
    }];
}


// 查询 用户守护榜
- (void)getUserGuardRankByUid:(UserID)uid {
    [HttpRequestHelper getUserGuardRank:uid success:^(UserRankingInfo *userRankingInfo) {
        NotifyCoreClient(UserCoreClient, @selector(onUseGuardRankSuccess:withUid:), onUseGuardRankSuccess:userRankingInfo withUid:uid);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(UserCoreClient, @selector(onUseGuardRankFailth:), onUseGuardRankFailth:message);
    }];
}

#pragma mark -
#pragma mark 公会线业务  - 萝卜礼物

/**
 用户获得的萝卜礼物
 
 @param userID 用户 uid
 */
- (void)getReceiveCarrotGift:(UserID)userID {
    [HttpRequestHelper getReceiveCarrotGift:userID success:^(NSArray *list) {
        NotifyCoreClient(UserCoreClient, @selector(onGetReceiveCarrotGiftSuccess:uid:code:msg:), onGetReceiveCarrotGiftSuccess:list uid:userID code:nil msg:nil);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(UserCoreClient, @selector(onGetReceiveCarrotGiftSuccess:uid:code:msg:), onGetReceiveCarrotGiftSuccess:nil uid:userID code:resCode msg:message);
    }];
}

#pragma mark - 更新 位置开关
/**
 更新 位置开关
 
 @param showLocation 位置开关
 */
- (void)updateUserInfoLocationSwitch:(BOOL)showLocation {
    [HttpRequestHelper updateUserInfoLocationSwitch:showLocation success:^{
        NotifyCoreClient(UserCoreClient, @selector(updateUserInfoLocationSwitchSuccess:), updateUserInfoLocationSwitchSuccess:showLocation);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(UserCoreClient, @selector(updateUserInfoLocationSwitchFailth:errorMessage:), updateUserInfoLocationSwitchFailth:!showLocation errorMessage:message);
    }];
}

#pragma mark - 更新 年龄开关
/**
 更新 年龄开关
 
 @param show 是否显示年龄
 */
- (void)updateUserInfoAgeSwitch:(BOOL)show {
    [HttpRequestHelper updateUserInfoAgeSwitch:show completion:^(id data, NSNumber *code, NSString *msg) {
        
        NotifyCoreClient(UserCoreClient, @selector(responseUserInfoAgeSwitchSuccess:code:msg:), responseUserInfoAgeSwitchSuccess:code==nil code:code msg:msg);
    }];
}

#pragma mark - 更新匹配聊天开关
/**
 更新匹配聊天开关
 
 @param show 是否显示匹配聊天
 */
- (void)updateUserInfoMatchChatSwitch:(BOOL)show {
    [HttpRequestHelper updateUserInfoMatchChatSwitch:show completion:^(id data, NSNumber *code, NSString *msg) {
        
        NotifyCoreClient(UserCoreClient, @selector(responseUserInfoMatchChatSwitchSuccess:code:msg:), responseUserInfoMatchChatSwitchSuccess:code==nil code:code msg:msg);
    }];
}

#pragma mark - 消息设置
/// 获取用户消息设置状态
- (void)requestUserInfoNotifyStatus {
    [HttpRequestHelper requestUserInfoNotifyStatusWithCompletion:^(id data, NSNumber *code, NSString *msg) {
        
        UserNotifyStatus *model = [UserNotifyStatus modelWithJSON:data];
        NotifyCoreClient(UserCoreClient, @selector(responseUserInfoNotifyStatus:code:msg:), responseUserInfoNotifyStatus:model code:code msg:msg);
    }];
}

/// 更新系统消息状态
- (void)updateUserInfoSystemNotify:(BOOL)notify completion:(void (^)(BOOL result, NSNumber *errCode, NSString *msg))completion {
    
    [HttpRequestHelper updateUserInfoSystemNotify:notify completion:^(id data, NSNumber *code, NSString *msg) {
        
        !completion ?: completion(code==nil, code, msg);
    }];
}

/// 更新互动消息状态
- (void)updateUserInfoInteractionNotify:(BOOL)notify completion:(void (^)(BOOL result, NSNumber *errCode, NSString *msg))completion {
    
    [HttpRequestHelper updateUserInfoInteractionNotify:notify completion:^(id data, NSNumber *code, NSString *msg) {
        
        !completion ?: completion(code==nil, code, msg);
    }];
}

#pragma mark - 随机用户信
/// 用户选择随机资料
/// @param type 随机头像，随机昵称
- (void)userRandomInfoWithType:(RandomType)type {
    [HttpRequestHelper userRandomInfoWithType:type andCompletionHandler:^(id data, NSNumber *code, NSString *msg) {
        
        NSString *nick = type == RandomNickType ? data : nil;
        NSString *avatar = type == RandomAvatarType ? data : nil;
        
        NotifyCoreClient(UserCoreClient, @selector(userRandomInfoSuccessWithNick:randomAvatar:resCode:resMsg:), userRandomInfoSuccessWithNick:nick randomAvatar:[NSURL URLWithString:avatar] resCode:code resMsg:msg);
    }];
}

/// 用户随机资料开关
- (void)getUserRandomInfoStatus {
    [HttpRequestHelper getUserRandomInfoStatusAndCompletionHandler:^(id data, NSNumber *code, NSString *msg) {
       
        NotifyCoreClient(UserCoreClient, @selector(getUserRandomInfoStatus:avatarStatus:resCode:resMsg:), getUserRandomInfoStatus:[data[@"nick"] boolValue] avatarStatus:[data[@"avatar"] boolValue] resCode:code resMsg:msg);
    }];
}

#pragma mark - Private

- (BOOL)judgeUserInfoComplete:(UserInfo *)info type:(QueryUserInfoExtension)type{
    switch (type) {
        case QueryUserInfoExtension_Car:
        {
            if (info.carport) {
                return YES;
            }else {
                return NO;
            }
        }
            break;
        case QueryUserInfoExtension_Noble:
        {
            if (info.nobleUsers) {
                return YES;
            }else {
                return NO;
            }
        }
            break;
        case QueryUserInfoExtension_Photo:
        {
            if (info.privatePhoto.count > 0) {
                return YES;
            }else {
                return NO;
            }
        }
            break;
        case QueryUserInfoExtension_Family:
        {
            if (info.family) {
                return YES;
            }else {
                return NO;
            }
        }
            break;
        case QueryUserInfoExtension_HeadWear: {
            if (info.userHeadwear) {
                return YES;
            }else {
                return NO;
            }
        }
            break;
        case QueryUserInfoExtension_LevelInfo: {
            if (info.userLevelVo) {
                return YES;
            }else {
                return NO;
            }
        }
        default:
            return YES;
            break;
    }
}

#pragma mark - IUserInfoCache

- (void)cacheUserInfos:(NSArray *)userInfos
              complete:(void (^)(void))complete
{
    [[XCDBManager defaultManager]creatOrUpdateUsers:userInfos];
    
}

- (void)cacheUserInfo:(UserInfo *)userInfo
             complete:(void (^)(void))complete
{
    [[XCDBManager defaultManager]creatOrUpdateUser:userInfo complete:complete];
}

#pragma mark - UserEnterRoomInfo
/**
 查询数据库（同步方法）
 
 @param roomuid 房主uid
 @return UserEnterRoomInfo
 */
- (UserEnterRoomInfo *)getUserEnterRoomInfoInDB:(NSString *)roomuid {
   return [[XCDBManager defaultManager] getUserWithUserEnterRoomUid:roomuid];
}

/**
 插入或更新
 
 @param info UserEnterRoomInfo
 */
- (void)saveOrUpadateEnterRoomInfo:(UserEnterRoomInfo *)info {
    [[XCDBManager defaultManager] creatOrUpdateUserEnterRoomInfo:info complete:^{
        
    }];
}

@end
