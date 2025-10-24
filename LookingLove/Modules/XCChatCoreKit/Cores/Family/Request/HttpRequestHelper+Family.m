//
//  HttpRequestHelper+Family.m
//  BberryCore
//
//  Created by 卫明何 on 2018/5/24.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "HttpRequestHelper+Family.h"
#import "MessageBussiness.h"
#import "NSObject+YYModel.h"
#import "XCFamily.h"
#import <YYModel.h>
#import "AuthCore.h"
#import "BannerInfo.h"
#import "XCFamilyModel.h"
#import "XCFamilyMoneyModel.h"


@implementation HttpRequestHelper (Family)

+ (void)updateFamilyBussinessStatusWith:(Message_Bussiness_Status)bussinessStatus
                       messageBussiness:(MessageBussiness *)messageBussiness
                                 method:(NSString *)method
                                 params:(NSMutableDictionary *)params
                               successs:(void(^)(MessageBussiness *bussiness))success
                                failure:(void (^)(NSNumber *resCode, NSString *message))failure {

//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:[GetCore(AuthCore)getUid] forKey:@"uid"];
    [params safeSetObject:[GetCore(AuthCore)getTicket] forKey:@"ticket"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        MessageBussiness *bussiness = [MessageBussiness yy_modelWithJSON:data];
        success(bussiness);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode,message);
    }];
    
}

+ (void)requestFamilyInfoByFamilyId:(NSString *)familyId
                            success:(void(^)(XCFamily *familyInfo))success
                            failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString *method = @"family/familyInfo";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:familyId forKey:@"familyId"];
    [params safeSetObject:[GetCore(AuthCore)getUid] forKey:@"uid"];
    [HttpRequestHelper GET:method params:params success:^(id data) {
        XCFamily *familyInfo = [XCFamily yy_modelWithDictionary:data];
        success(familyInfo);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

//发现
+ (void)getFamilyFinderMessageWith:(NSString *)uid
                          successs:(void(^)(NSMutableDictionary *bussiness))success
                           failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    NSString *method = @"discovery";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:uid forKey:@"uid"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        //banners
        NSArray *bannerInfos = [NSArray yy_modelArrayWithClass:[XCFamilyModel class] json:data[@"banners"]];
        if (bannerInfos.count>0) {
            [dictionary setObject:bannerInfos forKey:@"banners"];
        }
        
        XCFamily * model = [XCFamily yy_modelWithJSON:data[@"family"]];
        if (model) {
            [dictionary setObject:model forKey:@"family"];
        }
        
        success(dictionary);
    } failure:^(NSNumber *resCode, NSString *message) {
         failure(resCode,message);
    }];
}

//家族魅力排行榜
+ (void)getFamilyRecormmendList:(int)type
                           page:(int)page
                       pageSize:(int)pageSize
                       successs:(void(^)(XCFamily *charmFamilyInfor))success
                        failure:(void (^)(NSNumber *resCode, NSString *message))failure
{
    NSString *method = @"family/charm/rank";
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(pageSize) forKey:@"pageSize"];
    [params safeSetObject:@(page) forKey:@"page"];
    [params safeSetObject:@(type) forKey:@"type"];
    [HttpRequestHelper GET:method params:params success:^(id data) {
        XCFamily * family = [XCFamily yy_modelWithDictionary:data];
        success(family);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode,message);
    }];
}

//获取家族广场
+ (void)getFamilySquareMessageWith:(NSString *)uid
                          successs:(void(^)(NSMutableDictionary *bussiness))success
                           failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    NSString *method = @"family/square";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:uid forKey:@"uid"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        NSArray *bannerInfos = [NSArray yy_modelArrayWithClass:[BannerInfo class] json:data[@"banners"]];
//        NSArray *familys = [NSArray yy_modelArrayWithClass:[XCFamily class] json:data[@"familys"][@"familys"]];
        
        if (bannerInfos.count > 0) {
            [dic setValue:bannerInfos forKey:@"banners"];
        }
        
//        if (familys.count > 0) {
//            [dic setValue:familys forKey:@"familys"];
//        }
//        [dic safeSetObject:data[@"familys"][@"count"] forKey:@"familyNumber"];
        success(dic);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode,message);
    }];
}

+ (void)getTotalFamilys:(NSString *)userID
                   page:(int)page
               successs:(void(^)(NSArray *squareList))success
                failure:(void (^)(NSNumber *resCode, NSString *message))failure
{
    NSString *method = @"family/list";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(page) forKey:@"page"];
    [params safeSetObject:@(10) forKey:@"pageSize"];
    [params safeSetObject:userID forKey:@"uid"];
    [HttpRequestHelper GET:method params:params success:^(id data) {
        NSArray * array = [NSArray yy_modelArrayWithClass:[XCFamily class] json:data[@"familys"]];
        success(array);
    } failure:^(NSNumber *resCode, NSString *message) {
         failure(resCode,message);
    }];
}

//家族客服
+(void)guideAndServiceWith:(NSString *)userID
                  successs:(void(^)(NSDictionary *squareList))success
                   failure:(void (^)(NSNumber *resCode, NSString *message))failure
{
    NSString *method = @"family/customservice";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:userID forKey:@"uid"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        NSArray * array = [NSArray yy_modelArrayWithClass:[XCFamilyModel class] json:data[@"services"]];
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        if (array.count > 0) {
            for (XCFamilyModel * model in array) {
                if ([model.type isEqualToString:@"1"]) {
                    [dic setValue:model forKey:@"online"];
                }else if ([model.type isEqualToString:@"2"]){
                    [dic setValue:model forKey:@"phone"];
                }
            }
        }
        success(dic);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode,message);
    }];
}


//家族广场搜索
+ (void)searchFamilSquareListWithFamilykey:(NSString *)key
                         successs:(void(^)(NSArray<XCFamily *> *squareList))success
                          failure:(void (^)(NSNumber *resCode, NSString *message))failure
{
    NSString *method = @"family/family/search";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params safeSetObject:key forKey:@"key"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        NSArray * array = [NSArray yy_modelArrayWithClass:[XCFamily class] json:data[@"familys"]];
        success(array);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode,message);
    }];
}

+ (void)getFamilyInforWith:(NSString *)temaId
                  successs:(void(^)(XCFamily *familyModel))success
                   failure:(void (^)(NSNumber *resCode, NSString *message))failure
{
//    NSString *method = [NSString stringWithFormat:@"family/family/%@", temaId];
    NSString *method = @"family/detail";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params safeSetObject:temaId forKey:@"familyId"];
    [HttpRequestHelper GET:method params:params success:^(id data) {
        XCFamily *model = [XCFamily yy_modelWithJSON:data];
        success(model);
    } failure:^(NSNumber *resCode, NSString *message) {
         failure(resCode,message);
    }];
    
}

+ (void)modifyFamilyInforWith:(NSDictionary *)inforDic
                     successs:(void(^)(NSDictionary *modelDic))success
                      failure:(void (^)(NSNumber *resCode, NSString *message))failure
{
    NSString *method = @"family/modify";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    if ([inforDic[@"familyId"] length] > 0) {
        [params safeSetObject:inforDic[@"familyId"] forKey:@"familyId"];
    }
    
    if ([inforDic[@"familyName"] length] > 0) {
        [params safeSetObject:inforDic[@"familyName"] forKey:@"familyName"];
    }
    
    if ([inforDic[@"inputfile"] length] > 0) {
        [params safeSetObject:inforDic[@"inputfile"] forKey:@"inputfile"];
    }
    
    if ([inforDic[@"verifyType"] length] > 0) {
        [params safeSetObject:inforDic[@"verifyType"] forKey:@"verifyType"];
    }
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success(data);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode,message);
    }];
}

//查询家族成员列表
+(void)searchFamilyMemberlistWithKey:(NSString *)key
                         successs:(void(^)(NSArray *memberList))success
                          failure:(void (^)(NSNumber *resCode, NSString *message))failure
{
    NSString *method = @"family/familymember";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params safeSetObject:key forKey:@"key"];
    [HttpRequestHelper GET:method params:params success:^(id data) {
        NSArray * array = [NSArray yy_modelArrayWithClass:[XCFamilyModel class] json:data[@"members"]];
        success(array);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode,message);
    }];
    
}



//退出家族
+ (void)quitFamilysuccesss:(void(^)(NSDictionary *successDic))success
               failure:(void (^)(NSNumber *resCode, NSString *message))failure
{
    NSString *method = @"family/quit";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success(data);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode,message);
    }];
}

+ (void)userenterFamilyWith:(NSString *)teamId
                    content:(NSString *)content
                    successs:(void(^)(NSDictionary *successDic))success
                    failure:(void (^)(NSNumber *resCode, NSString *message))failure
{
    NSString *method = @"family/apply";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params safeSetObject:teamId forKey:@"familyId"];
    if (content.length > 0) {
        [params safeSetObject:content forKey:@"content"];
    }
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success(data);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode,message);
    }];
}

//踢出家族
+ (void)kichUserFromFamilyWithTargetID:(NSInteger)targetID
                              successs:(void(^)(NSDictionary *successDic))success
                               failure:(void (^)(NSNumber *resCode, NSString *message))failure
{
    NSString *method = @"family/kick";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params safeSetObject:@(targetID) forKey:@"targetId"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success(data);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode,message);
    }];
}

//家族币管理页面
+ (void)familyMoneyManagermentWith:(NSString *)userID
                          successs:(void(^)(XCFamily * model))success
                           failure:(void (^)(NSNumber *resCode, NSString *message))failure
{
    NSString *method = @"family/money/summary";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:userID forKey:@"targetUid"];
    [HttpRequestHelper GET:method params:params success:^(id data) {
        XCFamily * familyModel = [XCFamily yy_modelWithJSON:data];
        success(familyModel);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

//查询家族币
+ (void)srachFamilyMoneyTradRecordWith:(NSInteger )userID
                               andPage:(int)page
                               andTime:(NSString *)time
                              successs:(void(^)(NSMutableArray<XCFamilyMoneyModel *> *recordList))success
                               failure:(void (^)(NSNumber *resCode, NSString *message))failure
{
    NSString *method = @"family/member/money/record";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(userID) forKey:@"targetUid"];
    [params safeSetObject:@(page) forKey:@"page"];
    [params safeSetObject:@(10) forKey:@"pageSize"];
    
    if (time != nil && time.length > 0) {
     [params safeSetObject:time forKey:@"time"];
    }
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        NSMutableArray * array = [[NSArray yy_modelArrayWithClass:[XCFamilyMoneyModel class] json:data[@"recordMonVos"]] mutableCopy];
        success(array);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

//家族币的分配（族长分配 成员是没有权限的）
+ (void)familyMoneyTradExchangeWith:(NSInteger)userID andTargetID:(NSInteger)targetID andAmount:(NSString *)amount
                           successs:(void(^)(NSDictionary *successDic))success
                            failure:(void (^)(NSNumber *resCode, NSString *message))failure
{
    NSString *method = @"family/money/trade";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(userID) forKey:@"uid"];
    [params safeSetObject:@(targetID) forKey:@"targetUid"];
    [params safeSetObject:amount forKey:@"amount"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success(data);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}
//成员贡献家族币给族长
+ (void)memberContributFamilyMoneyTo:(NSString *)amount
                             uccesss:(void(^)(NSDictionary *successDic))success
                             failure:(void (^)(NSNumber *resCode, NSString *message))failure
{
    NSString *method = @"family/money/donate";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:amount forKey:@"amount"];
    [params safeSetObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success(data);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}


//邀请别人加入家族
+ (void)inviteUserToFamilyWith:(NSString *)userID andTargetID:(NSString *)targetID
                      successs:(void(^)(NSDictionary *successDic))success
                       failure:(void (^)(NSNumber *resCode, NSString *message))failure
{
    NSString *method = @"family/invite";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:userID forKey:@"uid"];
    [params safeSetObject:targetID forKey:@"targetId"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success(data);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}


//接受别人的邀请
+ (void)acceptInviteEnterFamilyWith:(NSString *)userID andInviteID:(NSString *)inviteID
                           successs:(void(^)(NSDictionary *successDic))success
                            failure:(void (^)(NSNumber *resCode, NSString *message))failure
{
    NSString *method = @"family/invitation/accept";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:userID forKey:@"uid"];
    [params safeSetObject:inviteID forKey:@"inviteId"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        
    } failure:^(NSNumber *resCode, NSString *message) {
        
    }];
}

+ (void)requestFamilyGameListByFamilyId:(NSInteger)familyId success:(void (^)(NSArray<XCFamilyModel *> *))success failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"family/game/list";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(familyId) forKey:@"familyId"];
    [params safeSetObject:[GetCore(AuthCore)getUid] forKey:@"uid"];
    [HttpRequestHelper GET:method params:params success:^(id data) {
        
        NSArray *source = [NSArray yy_modelArrayWithClass:[XCFamilyModel class] json:data[@"games"]];
        success(source);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

+ (void)fetchFamilyMembersList:(NSString*)userId page:(NSInteger)page success:(void(^)(XCFamily * family))success failure:(void(^)(NSNumber *redCode , NSString *message))failure
{
    NSString *method = @"family/allFamilymembers";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:userId forKey:@"uid"];
    [params safeSetObject:@(page) forKey:@"page"];
    [params safeSetObject:@(10) forKey:@"pageSize"];
    [HttpRequestHelper GET:method params:params success:^(id data) {
        XCFamily * familyModel = [XCFamily yy_modelWithDictionary:data];
        success(familyModel);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

//当前的群 中家族中不再里面的列表
+ (void)fetchFamilyMemberNotJoinGroupWith:(NSInteger)tid andPage:(NSInteger)page andKey:(NSString *)key success:(void(^)(XCFamily *familyInfor))success failure:(void(^)(NSNumber *redCode , NSString *message))failure
{
    NSString *method = @"family/disJoin";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params safeSetObject:@(tid) forKey:@"tid"];
    if (key && key.length >0) {
        [params safeSetObject:key forKey:@"key"];
    }else{
        [params safeSetObject:@(page) forKey:@"page"];
        [params safeSetObject:@(10) forKey:@"pageSize"];
    }
    [HttpRequestHelper GET:method params:params success:^(id data) {
        XCFamily * familyModel = [XCFamily yy_modelWithDictionary:data];
        success(familyModel);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

+ (void)fetchGroupWeekRecordWith:(NSInteger)groupId erbanNo:(NSInteger)erbanNo page:(int)page success:(void(^)(XCFamily *family))success failure:(void(^)(NSNumber * redCode, NSString * message))failure
{
    NSString *method = @"family/group/money/record/week";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (erbanNo) {
        [params safeSetObject:@(erbanNo) forKey:@"erbanNo"];
    }
    [params safeSetObject:@(groupId) forKey:@"groupId"];
    [params safeSetObject:@(page) forKey:@"page"];
    [params safeSetObject:@(10) forKey:@"pageSize"];
    [HttpRequestHelper GET:method params:params success:^(id data) {
        XCFamily * family = [XCFamily yy_modelWithDictionary:data];
        success(family);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
   
}

+ (void)getFamilyMoneyRecord:(NSString *)userID
                        time:(NSString *)time
                        page:(int)page
                    successs:(void(^)(NSMutableArray<XCFamilyMoneyModel *> *recordList))success
                     failure:(void (^)(NSNumber *resCode, NSString *message))failure
{
    NSString *method = @"family/money/record";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(page) forKey:@"page"];
    [params safeSetObject:@(10) forKey:@"pageSize"];
    [params safeSetObject:userID forKey:@"uid"];
    if (time != nil && time.length > 0) {
        [params safeSetObject:time forKey:@"time"];
    }
    [HttpRequestHelper GET:method params:params success:^(id data) {
        NSMutableArray * array = [[NSArray yy_modelArrayWithClass:[XCFamilyMoneyModel class] json:data[@"recordMonVos"]] mutableCopy];
        success(array);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

#pragma mark - 萌声的需求
+ (void)getMSDicoverBannderInfor:(UserID)uid
                        successs:(void(^)(XCFamily *charmFamilyInfor))success
                         failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    NSString * method = @"advertise/advTopList";
    NSMutableDictionary * params =[NSMutableDictionary dictionary];
    [params safeSetObject:@(uid) forKey:@"uid"];
    [HttpRequestHelper GET:method params:params success:^(id data) {
        XCFamily * discover = [XCFamily yy_modelWithDictionary:data];
        success(discover);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

@end
