//
//  HttpRequestHelper+Group.m
//  BberryCore
//
//  Created by 卫明何 on 2018/6/1.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "HttpRequestHelper+Group.h"
#import "AuthCore.h"
#import "FamilyCore.h"
#import "NSObject+YYModel.h"
#import "XCFamilyModel.h"
@implementation HttpRequestHelper (Group)

+ (void)creatGroupByFamilyId:(NSInteger)familyId
                        icon:(NSString *)icon
                        name:(NSString *)name
                      members:(NSMutableDictionary *)members
                    isVerify:(BOOL)isVerify
                     success:(void (^)(GroupModel *))success
                     failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"family/group/create";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(familyId) forKey:@"familyId"];
    [params safeSetObject:[GetCore(FamilyCore) getLaderID] forKey:@"uid"];
    [params safeSetObject:icon forKey:@"icon"];
    [params safeSetObject:name forKey:@"name"];
    [params safeSetObject:@(isVerify) forKey:@"isVerify"];
    
    
    if ([members allKeys].count > 0) {
        NSString * membersuid = [[members allKeys] componentsJoinedByString:@","];
        [params safeSetObject:membersuid forKey:@"members"];
    }
   
    [HttpRequestHelper POST:method params:params success:^(id data) {
        GroupModel *group = [GroupModel yy_modelWithJSON:data];
        success(group);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

+ (void)deleteGroupByTeamId:(NSInteger)teamId
                    success:(void (^)(BOOL))success
                    failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"family/group/remove";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params safeSetObject:@(teamId) forKey:@"chatId"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success(YES);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

+ (void)fetchGroupMemberByTeamId:(NSInteger)teamId
                            page:(NSInteger)page
                        pageSize:(NSInteger)pageSize
                         success:(void (^)(GroupMember *member))success
                         failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString *method = @"family/group/member/queryMember";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params setObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params safeSetObject:@(teamId) forKey:@"chatId"];
    [params safeSetObject:@(page) forKey:@"page"];
    [params safeSetObject:@(pageSize) forKey:@"pageSize"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        GroupMember * member = [GroupMember yy_modelWithJSON:data];
        success(member);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

+ (void)operationBySwitch:(BOOL)on
                   teamId:(NSInteger)teamId
                  success:(void (^)(BOOL))success
                  failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"family/group/member/mute";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(teamId) forKey:@"chatId"];
    [params safeSetObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params safeSetObject:@(on) forKey:@"ope"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success(YES);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];

}

+ (void)kickMemberByTeamId:(NSInteger)teamId
                 targetUid:(UserID)targetUid
                   success:(void (^)(BOOL))success
                   failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"family/group/member/kick";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(teamId) forKey:@"chatId"];
    [params safeSetObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params safeSetObject:@(targetUid) forKey:@"targetUid"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success(YES);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

+ (void)setManagerByTeamid:(NSInteger)teamId
                 targetUid:(UserID)targetUid
                   success:(void (^)(BOOL))success
                   failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"family/group/member/setManager";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(teamId) forKey:@"chatId"];
    [params safeSetObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params safeSetObject:@(targetUid) forKey:@"targetUid"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success(YES);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}


+ (void)removeManagerByTeamid:(NSInteger)teamId targetUid:(UserID)targetUid success:(void (^)(BOOL))success failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"family/group/member/unManager";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(teamId) forKey:@"chatId"];
    [params safeSetObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params safeSetObject:@(targetUid) forKey:@"targetUid"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success(YES);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

+ (void)outGroupByTeamid:(NSInteger)teamId
                 success:(void (^)(BOOL))success
                 failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"family/group/member/leave";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(teamId) forKey:@"chatId"];
    [params safeSetObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success(YES);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

+ (void)fetchAllGroupbyFamilyId:(NSInteger)familyId
                        success:(void (^)(NSArray<GroupModel *> *groups))success
                        failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString *method = @"family/group/query";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(familyId) forKey:@"familyId"];
    [params safeSetObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [HttpRequestHelper GET:method params:params success:^(id data) {
        NSArray<GroupModel *> *groups = [NSArray yy_modelArrayWithClass:[GroupModel class] json:data];
        success(groups);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];

}

+ (void)searchMemberByTeamid:(NSInteger)teamId
                     erbanNo:(NSString *)erbanNo
                        page:(NSInteger)page
                    pageSize:(NSInteger)pageSize
                     success:(void (^)(NSArray<GroupMemberModel *> *))success
                     failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"family/group/member/queryByErbanNo";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(teamId) forKey:@"chatId"];
    [params safeSetObject:erbanNo forKey:@"key"];
    [params safeSetObject:@(page) forKey:@"page"];
    [params safeSetObject:@(pageSize) forKey:@"pageSize"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        NSArray<GroupMemberModel *> *groups = [NSArray yy_modelArrayWithClass:[GroupMemberModel class] json:data];
        success(groups);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];

}

+ (void)updateGroupDataByTeamId:(NSInteger)teamId
                           icon:(NSString *)icon
                           name:(NSString *)name
                       isVerify:(BOOL)isVerify
                        success:(void (^)(GroupModel *group))success
                        failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString *method = @"family/group/update";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(teamId) forKey:@"chatId"];
    [params setObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    if (icon) {
        [params safeSetObject:icon forKey:@"icon"];
    }
    if (name) {
        [params safeSetObject:name forKey:@"name"];
    }
    [params safeSetObject:@(isVerify) forKey:@"isVerify"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        GroupModel *group = [GroupModel yy_modelWithJSON:data];
        success(group);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];

}

+ (void)fetchGroupByteamId:(NSInteger)teamId
                   success:(void (^) (GroupModel *group))success
                   failure:(void (^) (NSNumber *resCode, NSString *message))failure {
    NSString *method = @"family/group/get";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(teamId) forKey:@"tid"];
    [params setObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        GroupModel *group = [GroupModel yy_modelWithJSON:data];
        success(group);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

+ (void)updateGroupUserDisable:(NSInteger)teamId andTarget:(NSInteger)targetId mute:(int)mute success:(void(^)(NSDictionary * dic))success failure:(void (^) (NSNumber *resCode, NSString *message))failure
{
    NSString *method = @"family/group/member/disable";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(teamId) forKey:@"chatId"];
    [params setObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params safeSetObject:@(mute) forKey:@"mute"];
    [params safeSetObject:@(targetId) forKey:@"targetUid"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success(data[@"data"]);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

+ (void)enterGroupWith:(NSInteger)teamId message:(NSString *)message andSuccess:(void(^)(NSDictionary *dic))success failure:(void(^)(NSNumber * resCode, NSString * message))failure
{
    NSString *method = @"family/group/member/join";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(teamId) forKey:@"chatId"];
    [params safeSetObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params safeSetObject:message forKey:@"message"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success(data[@"data"]);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

+ (void)fecthUserTotalGroup:(void(^)(NSArray * groupList))success failure:(void(^)(NSNumber * resCode, NSString * message))failure
{
    NSString *method = @"family/group/queryJoin";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [HttpRequestHelper GET:method params:params success:^(id data) {
        NSArray * array = [NSArray yy_modelArrayWithClass:[GroupModel class] json:data];
        success(array);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}


+ (void)fetchGroupMemberCountWith:(NSInteger)teamId
                       andSuccess:(void(^)(NSDictionary *dic))success
                          failuer:(void(^)(NSNumber * recCode, NSString * message))failure
{
    NSString *method = @"family/group/member/count";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(teamId) forKey:@"chatId"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success(data[@"data"]);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

+ (void)addFamilyMemberToGroupWith:(NSMutableDictionary *)members andchatId:(NSInteger)chatId
                        andSuccess:(void(^)(NSDictionary *dic))success
                           failuer:(void(^)(NSNumber * recCode, NSString * message))failure
{
    NSString *method = @"family/group/member/add";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(chatId) forKey:@"chatId"];
    [params safeSetObject:[GetCore(AuthCore) getUid] forKey:@"uid"];

    if ([members allKeys].count > 0) {
        NSString * membersuid = [[members allKeys] componentsJoinedByString:@","];
        [params safeSetObject:membersuid forKey:@"targetUids"];
    }
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success(data[@"data"]);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}



@end
