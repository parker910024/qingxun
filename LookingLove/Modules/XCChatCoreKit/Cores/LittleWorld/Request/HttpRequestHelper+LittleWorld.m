//
//  HttpRequestHelper+LittleWorld.m
//  XCChatCoreKit
//
//  Created by lvjunhang on 2019/7/2.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "HttpRequestHelper+LittleWorld.h"
#import "AuthCore.h"
#import "ImRoomCoreV2.h"
#import "CTDynamicModel.h"
#import "CTTabTopicModel.h"
#import "HeartCommentInfo.h"
#import "UserCore.h"
#import "LTUnreadModel.h"
#import "CTCommentReplyModel.h"
#import "LLDynamicModel.h"

@implementation HttpRequestHelper (LittleWorld)

/**
 小世界首页（世界广场）
 */
+ (void)requestWorldSquareWithCompletion:(HttpRequestHelperCompletion)completion {
    
    NSString *path = @"world/home";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    
    [self request:path
           method:HttpRequestHelperMethodPOST
           params:params
       completion:completion];
}

/**
 小世界首页全部分类列表，包含’我加入的‘和’推荐‘
 */
+ (void)requestWorldFullCategoryListOnCompletion:(HttpRequestHelperCompletion)completion {
    NSString *path = @"world/type/listAll";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    
    [self request:path
           method:HttpRequestHelperMethodPOST
           params:params
       completion:completion];
}

/**
 小世界分类列表
 */
+ (void)requestWorldCategoryListOnCompletion:(HttpRequestHelperCompletion)completion {
    NSString *path = @"world/type/list";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    
    [self request:path
           method:HttpRequestHelperMethodPOST
           params:params
       completion:completion];
}

/**
 小世界列表
 
 @param page 查询页数，从 1 开始
 @param pageSize 每页数量
 @param searchKey 小世界查询关键字，用户耳伴号或小世界名称，支持模糊搜索
 @param worldTypeId 小世界类型，-1：我加入的，-2：推荐，其他
 */
+ (void)requestWorldListWithPage:(NSInteger)page
                        pageSize:(NSInteger)pageSize
                       searchKey:(nullable NSString *)searchKey
                     worldTypeId:(NSString *)worldTypeId
                      completion:(HttpRequestHelperCompletion)completion {
    
    NSString *path = @"world/list";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (worldTypeId.integerValue == -1) {
        [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    }
    [params setValue:@(MAX(page, 1)) forKey:@"page"];
    [params setValue:@(MAX(pageSize, 1)) forKey:@"pageSize"];
    [params setValue:searchKey forKey:@"searchKey"];
    [params setValue:worldTypeId forKey:@"worldTypeId"];
    
    [self request:path
           method:HttpRequestHelperMethodPOST
           params:params
       completion:completion];
}

/**
 获取世界分享图片
 */
+ (void)requestWorldSharePicWithWorldId:(NSString *)worldId
                             completion:(HttpRequestHelperCompletion)completion {
    
    NSString *path = @"world/get/share/picture";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    [params setValue:worldId forKey:@"worldId"];
    
    [self request:path
           method:HttpRequestHelperMethodPOST
           params:params
       completion:completion];
}


// start fuyuan
/**
 小世界详情页
 
 @param worldId 小世界 id
 */
+ (void)requestWorldLetDetailDataWithUid:(NSString *)worldId uid:(UserID)uid success:(void(^)(LittleWorldListItem *model))success failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    
    NSString *method = @"world/detail";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:worldId forKey:@"worldId"];
    [params safeSetObject:@(uid) forKey:@"uid"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        LittleWorldListItem *model = [LittleWorldListItem modelDictionary:data];
        if (success) {
            success(model);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

/**
 加入小世界
 
 @param worldId 小世界 id
 @param uid 当前用户uid
 */
+ (void)requestJoinWorldLetWithUid:(NSString *)worldId uid:(UserID)uid isFromRoom:(BOOL)isFromRoom success:(void(^)(BOOL success))success failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    
    NSString *method = @"world/join/v2";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:worldId forKey:@"worldId"];
    [params safeSetObject:@(uid) forKey:@"uid"];
    if (isFromRoom) {
        if (worldId.integerValue == GetCore(ImRoomCoreV2).currentRoomInfo.worldId) {
            [params safeSetObject:@(GetCore(ImRoomCoreV2).currentRoomInfo.uid) forKey:@"roomUid"];
        }
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

/**
 退出小世界
 
 @param worldId 小世界 id
 @param uid 当前用户uid
 */
+ (void)requestExitWorldLetWithUid:(NSString *)worldId uid:(UserID)uid success:(void(^)(BOOL success))success failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    
    NSString *method = @"world/exit";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:worldId forKey:@"worldId"];
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
 解散小世界
 
 @param worldId 小世界 id
 @param uid 创建者uid
 */
+ (void)requestDismissWorldLetWithUid:(NSString *)worldId uid:(UserID)uid success:(void(^)(BOOL success))success failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    
    NSString *method = @"world/dismiss";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:worldId forKey:@"worldId"];
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
 编辑小世界
 
 @param worldId 小世界ID
 @param uid 创建者ID
 @param name 小世界名称
 @param icon 小世界图片
 @param description 小世界描述
 @param notice 小世界公告
 @param worldTypeId 小世界类型ID
 @param agreeFlag 加入小世界是否有限制
 */
+ (void)requestWorldLetEditDataWithWorld:(NSString *)worldId uid:(UserID)uid name:(NSString *)name icon:(NSString *)icon description:(NSString *)description notice:(NSString *)notice worldTypeId:(NSString *)worldTypeId agreeFlag:(BOOL)agreeFlag success:(void(^)(BOOL success))success failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    
    NSString *method = @"world/edit";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:worldId forKey:@"worldId"];
    [params safeSetObject:@(uid) forKey:@"uid"];
    [params safeSetObject:name forKey:@"name"];
    [params safeSetObject:icon forKey:@"icon"];
    [params safeSetObject:description forKey:@"description"];
    [params safeSetObject:notice forKey:@"notice"];
    [params safeSetObject:worldTypeId forKey:@"worldTypeId"];
    [params safeSetObject:@(agreeFlag) forKey:@"agreeFlag"];
    
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
 小世界消息免打扰
 
 @param chatId 群聊ID
 @param uid uid
 @param ope true=开启、false=关闭
 */
+ (void)requestWorldLetChatMuteWithChatId:(UserID)chatId uid:(UserID)uid ope:(BOOL)ope success:(void(^)(BOOL success))success failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    
    NSString *method = @"world/group/chat/mute";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(chatId) forKey:@"chatId"];
    [params safeSetObject:@(uid) forKey:@"uid"];
    [params safeSetObject:@(ope) forKey:@"ope"];
    
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
 关闭普通房的派对模式
 
 @param roomUid 房主uid
 */
+ (void)requestWorldLetCloseGroupChatWithRoomUid:(UserID)roomUid success:(void(^)(BOOL success))success failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    
    NSString *method = @"room/world/mode/close";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(roomUid) forKey:@"roomUid"];
    
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
 查询当前用户是否在世界内
 
 @param worldId 世界ID
 @param uid uid
 */
+ (void)requestUserInWorldletWithWorldId:(UserID)worldId uid:(UserID)uid success:(void(^)(TTWorldletRoomModel *model))success failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    
    NSString *method = @"world/member/get/flag";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(worldId) forKey:@"worldId"];
    [params safeSetObject:@(uid) forKey:@"uid"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        TTWorldletRoomModel *model = [TTWorldletRoomModel modelDictionary:data];
        if (success) {
            success(model);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}


//start @fengshuo
/**
 请求小世界成员列表

 @param worldId 小世界的id
 @param searchKey 搜索的关键词
 @param page 当前的页数
 @param success 成功
 @param failure 失败
 */
+ (void)requsetLittleWorldMemberListWithWorldId:(UserID)worldId
                               searchKey:(NSString *)searchKey
                                    page:(int)page
                                 success:(void(^)(LittleWorldMemberModel * model))success
                                 failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    
    NSString * method = @"world/member/list";
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    if (searchKey) {
        [params safeSetObject:searchKey forKey:@"searchKey"];
    }
    [params safeSetObject:@(worldId) forKey:@"worldId"];
    [params safeSetObject:@(page) forKey:@"page"];
    [params safeSetObject:@(20) forKey:@"pageSize"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        LittleWorldMemberModel *model = [LittleWorldMemberModel yy_modelWithJSON:data];
        success(model);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}


/**
 群聊里面的随机话题

 @param pageSize 一页的个数
 @param success 成功
 @param failure 失败
 */
+ (void)requestLittleWorldTeamTopicListWithPageSize:(int)pageSize
                                success:(void(^)(NSArray <LittleWorldTeamModel *> *lists))success
                                failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString * method = @"world/group/chat/topic/list";
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(pageSize) forKey:@"pageSize"];
    [HttpRequestHelper GET:method params:params success:^(id data) {
        NSArray * array = [NSArray yy_modelArrayWithClass:[LittleWorldTeamModel class] json:data];
        success(array);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

/**
 更新群聊的名字 或者是话题

 @param chatId 群聊的id
 @param name 群聊的名字
 @param topic 群聊的话题
 @param success 成功
 @param failure 失败
 */
+ (void)updateLittleWorldTeamTopicWithChatId:(UserID)chatId
                                  name:(NSString *)name
                                 topic:(NSString *)topic
                                   uid:(UserID)uid
                               success:(void(^)(BOOL success))success
                               failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString * method = @"world/group/chat/update";
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    if (name) {
        [params safeSetObject:name forKey:@"name"];
    }
    
    if (topic) {
      [params safeSetObject:topic forKey:@"topic"];
    }
    
    [params safeSetObject:@(chatId) forKey:@"chatId"];
    [params safeSetObject:@(uid) forKey:@"uid"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success(YES);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

/**
 获取群聊的信息

 @param chatId 群聊的id
 @param success 成功
 @param failure 失败
 */
+ (void)requestLittleWorldTeamDetailWithChatId:(UserID)chatId
                                     uid:(UserID)uid
                                 success:(void(^)(LittleWorldTeamModel *teamModel))success
                                 failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString * method = @"world/group/chat/get";
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(chatId) forKey:@"tid"];
    [params safeSetObject:@(uid) forKey:@"uid"];
    [HttpRequestHelper GET:method params:params success:^(id data) {
        LittleWorldTeamModel * model = [LittleWorldTeamModel yy_modelWithJSON:data];
        success(model);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

/**
 请求群聊中的派对列表
 
 @param worldId 世界的id
 @param page 当前的页数
 @param pageSize 每页的个数
 @param success 成功
 @param failure 失败
 */
+ (void)requsetLittleWorldTeamPartyListWithWorldId:(UserID)worldId
                                       page:(int)page
                                   pageSize:(int)pageSize
                                    success:(void(^)(TTLittleWorldPartyListModel *listModel))success
                                    failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString * method = @"world/room/list";
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(worldId) forKey:@"worldId"];
    [params safeSetObject:@(page) forKey:@"page"];
    [params safeSetObject:@(pageSize) forKey:@"pageSize"];
     [params safeSetObject:GetCore(AuthCore).getUid forKey:@"uid"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        TTLittleWorldPartyListModel * listModel = [TTLittleWorldPartyListModel yy_modelWithJSON:data];
        success(listModel);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

/**
 创建群聊派对
 
 @param worldId 世界的id
 @param roomUid 房间的Uid
 @param success 成功
 @param failure 失败
 */
+ (void)creatLittleWorldTeamPartyWithWorldId:(UserID)worldId
                                  roomUid:(UserID)roomUid
                              success:(void(^)(NSString * warn))success
                              failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString * method = @"room/world/mode/open";
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(worldId) forKey:@"worldId"];
    [params safeSetObject:@(roomUid) forKey:@"roomUid"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        NSString * warn = data[@"warn"];
        if (!warn) {
            warn = @"";
        }
        success(warn);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

/**
 小世界移出成员

 @param worldId 小世界的id
 @param managerUid 操作者的uid
 @param removerUid 移出的那个人的uid
 @param success 成功
 @param failure 失败
 */
+ (void)littleWorldRemoveMemberWithWorld:(UserID)worldId
                              managerUid:(UserID)managerUid
                               removerId:(UserID)removerUid
                                 success:(void(^)(BOOL isSuccess))success
                                 failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString * method = @"world/kick";
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(worldId) forKey:@"worldId"];
    [params safeSetObject:@(managerUid) forKey:@"uid"];
    [params safeSetObject:@(removerUid) forKey:@"kickUid"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success(YES);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

//end @fengshuo

/// 小世界成员活跃上报
/// @auth fulong
/// @param worldId 小世界id
/// @param uid 用户uid
/// @param activeType 在小世界群聊中活跃类型 活跃类型，1-消息，2-送礼物，3-创建语音派对，4-加入语音派对
/// @param completionHandler 完成回调
+ (void)reportWorldMemberoActiveType:(int)activeType reportUid:(UserID)uid worldId:(UserID)worldId completionHandler:(HttpRequestHelperCompletion)completionHandler {
    NSString *method = @"world/member/active/record/report";
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict safeSetObject:@(worldId) forKey:@"worldId"];
    [dict safeSetObject:@(uid) forKey:@"uid"];
    [dict safeSetObject:@(activeType) forKey:@"activeType"];
    
    [self request:method
        method:HttpRequestHelperMethodPOST
        params:dict
    completion:completionHandler];
}

#pragma mark -
#pragma mark littleWorld 2.0

+ (void)requestMyDynamicListWithUid:(NSString *)uid pageNum:(NSInteger)pageNum Success:(void (^)(NSArray <LLDynamicModel *>* dynamicModelList))success failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString *method = @"dynamic/getDynamicByUid";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:uid forKey:@"uid"];
    [params safeSetObject:@(pageNum) forKey:@"pageNum"];
    [params safeSetObject:@(20) forKey:@"pageSize"];
    [params safeSetObject:GetCore(AuthCore).getUid forKey:@"id"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        CTDynamicModel *previousModel = nil;
        NSMutableArray *tempArr = [NSMutableArray array];
        for (NSDictionary *dict in data) {
            CTDynamicModel *model = [CTDynamicModel modelDictionary:dict];
            model.isShowYears = ![model.dateStr isEqualToString:previousModel.dateStr];
            [tempArr addObject:model];
            previousModel = model;
        }
        success(tempArr.copy);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+ (void)requestDynamicListWithStart:(NSString *)start
                            pageNum:(NSInteger)pageNum
                            Success:(void (^)(NSArray <LLDynamicModel *>* dynamicModelList))success
                            failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    NSString *method = @"dynamic/getDynamicList";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:GetCore(AuthCore).getUid forKey:@"uid"];
    [params safeSetObject:@(pageNum) forKey:@"pageNum"];
    [params safeSetObject:@(20) forKey:@"pageSize"];
    [params safeSetObject:@"0,2" forKey:@"types"];
    [params safeSetObject:@(48) forKey:@"worldId"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        NSArray<LLDynamicModel *> *modelList = [LLDynamicModel modelsWithArray:data];
        success(modelList);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

/// 获取动态列表
/// @param worldId 所在的小世界id
/// @param dynamicId 动态id 服务器提供，只有在上拉加在更多的时候需要传入
/// @param success 成功回调
/// @param failure 失败回调
+ (void)requestDynamicListWithWorldID:(NSString *)worldId dynamicId:(NSInteger)dynamicId Success:(nonnull void (^)(NSArray<LLDynamicModel *> * _Nonnull, NSString * _Nonnull))success failure:(nonnull void (^)(NSNumber * _Nonnull, NSString * _Nonnull))failure {
    NSString *method = @"dynamic/list";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params safeSetObject:GetCore(AuthCore).getUid forKey:@"uid"];
    if (dynamicId > 0) {
        [params safeSetObject:@(dynamicId) forKey:@"dynamicId"];
    }
//    [params safeSetObject:@(pageNum) forKey:@"pageSize"];
    [params safeSetObject:@"0,2" forKey:@"types"];
    [params safeSetObject:worldId forKey:@"worldId"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        
        NSArray<LLDynamicModel *> *modelList = [LLDynamicModel modelsWithArray:data[@"dynamicList"]];
        success(modelList, data[@"nextDynamicId"]);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+ (void)requestDynamicAddWitDynamicModel:(LLDynamicModel *)model Success:(void (^)(LLDynamicModel *dynamicModel))success failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString *method = @"dynamic/addDynamic";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *imageUrl = [model.imageUrl componentsJoinedByString:@","];
    [params safeSetObject:model.uid forKey:@"uid"];
    [params safeSetObject:model.content forKey:@"content"];
    [params safeSetObject:imageUrl forKey:@"imageUrl"];
    [params safeSetObject:@(model.topicId) forKey:@"topicId"];
    if (model.voiceUrl.length > 0) {//有录音
        [params safeSetObject:model.voiceUrl forKey:@"voiceUrl"];
        [params safeSetObject:@(model.voiceLength) forKey:@"voiceLength"];
    }
    [params safeSetObject:@(model.type) forKey:@"type"];
    [params safeSetObject:model.cover forKey:@"cover"];
    [params safeSetObject:model.videoUrl forKey:@"videoUrl"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        LLDynamicModel *dynamicModel = [LLDynamicModel modelDictionary:data];
        success(dynamicModel);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

/// 发布动态
/// @param worldId 小世界id
/// @param type 发布动态的类型 动态类型，0-纯文本，1-声音，2-图文，3-视频
/// @param content 动态文本内容
/// @param resList 图片资源列表
/// @param completionHandler 请求回调
+ (void)requestPostDynamicWithWorldID:(NSString *)worldId type:(int)type content:(NSString *)content resList:(NSArray *)resList completionHandler:(HttpRequestHelperCompletion)completionHandler {
    
    [self requestPostDynamicWithWorldID:worldId type:type content:content resList:resList workOrder:nil completionHandler:completionHandler];
}

/// 发布动态
/// @param worldId 小世界id
/// @param type 发布动态的类型 动态类型，0-纯文本，1-声音，2-图文，3-视频
/// @param content 动态文本内容
/// @param resList 图片资源列表
/// @param workOrder 认证主播的派单
/// @param completionHandler 请求回调
+ (void)requestPostDynamicWithWorldID:(NSString *)worldId type:(int)type content:(NSString *)content resList:(NSArray *)resList workOrder:(AnchorOrderInfo *_Nullable)workOrder completionHandler:(HttpRequestHelperCompletion)completionHandler {
    
    NSString *method = @"dynamic/publish";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params safeSetObject:GetCore(AuthCore).getUid forKey:@"uid"];
    [params safeSetObject:@(type) forKey:@"type"];
    if (worldId) {
        [params safeSetObject:worldId forKey:@"worldId"];
    }
    [params safeSetObject:content forKey:@"content"];
    if (resList) {
        [params safeSetObject:resList forKey:@"resList"];
    }
    
    if (workOrder) {
        [params setValue:[workOrder model2dictionary] forKey:@"workOrder"];
    }
    
    [self postDynamic:method params:params success:^(id data) {
        completionHandler(@(YES), nil, nil);
    } failure:^(NSNumber *resCode, NSString *message) {
        completionHandler(nil, resCode, message);
    }];
}

/// 发布动态（广场）
/// @param worldId 小世界id（可为空）
/// @param type 发布动态的类型 动态类型，0-纯文本，1-声音，2-图文，3-视频
/// @param content 动态文本内容
/// @param resList 图片资源列表
/// @param completionHandler 请求回调
+ (void)requestPostSquareDynamicWithWorldID:(NSString *)worldId type:(int)type content:(NSString *)content resList:(NSArray *)resList completionHandler:(HttpRequestHelperCompletion)completionHandler {
    
    [self requestPostSquareDynamicWithWorldID:worldId type:type content:content resList:resList workOrder:nil completionHandler:completionHandler];
}

/// 发布动态（广场）
/// @param worldId 小世界id（可为空）
/// @param type 发布动态的类型 动态类型，0-纯文本，1-声音，2-图文，3-视频
/// @param content 动态文本内容
/// @param resList 图片资源列表
/// @param workOrder 认证主播的派单
/// @param completionHandler 请求回调
+ (void)requestPostSquareDynamicWithWorldID:(NSString *)worldId type:(int)type content:(NSString *)content resList:(NSArray *)resList workOrder:(AnchorOrderInfo *_Nullable)workOrder completionHandler:(HttpRequestHelperCompletion)completionHandler {
    
    NSString *method = @"dynamic/square/publish";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params safeSetObject:GetCore(AuthCore).getUid forKey:@"uid"];
    [params safeSetObject:@(type) forKey:@"type"];
    if (worldId) {
        [params safeSetObject:worldId forKey:@"worldId"];
    }
    [params safeSetObject:content forKey:@"content"];
    if (resList) {
        [params safeSetObject:resList forKey:@"resList"];
    }
    
    if (workOrder) {
        [params setValue:[workOrder model2dictionary] forKey:@"workOrder"];
    }
    
    [self postDynamic:method params:params success:^(id data) {
        completionHandler(@(YES), nil, nil);
    } failure:^(NSNumber *resCode, NSString *message) {
        completionHandler(nil, resCode, message);
    }];
}

+ (void)requestDynamicDeleteWitDynamicId:(long)dynamicId
                                 worldId:(NSString *)worldId
                                 Success:(void (^)(void))success
                                 failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString *method = [NSString stringWithFormat:@"dynamic/delete"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:GetCore(AuthCore).getUid forKey:@"uid"];
    [params safeSetObject:worldId forKey:@"worldId"];
    [params safeSetObject:@(dynamicId) forKey:@"dynamicId"];

    [HttpRequestHelper POST:method params:params success:^(id data) {
        success();
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+ (void)requestDynamicLikeWitWitDynamicId:(NSInteger)dynamicId worldId:(NSString *)worldId isLike:(BOOL)isLike dynamicUid:(NSString *)dynamicUid Success:(void (^)(void))success failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString *method = [NSString stringWithFormat:@"dynamic/like"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:GetCore(AuthCore).getUid forKey:@"uid"];
    [params safeSetObject:@(isLike) forKey:@"status"];
    [params safeSetObject:dynamicUid forKey:@"likedUid"];
    [params safeSetObject:@(dynamicId) forKey:@"dynamicId"];
    [params safeSetObject:worldId forKey:@"worldId"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success();
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+ (void)requestDynamicDetailsWitDynamicId:(long)dynamicId
                                      uid:(NSString *)uid
                                  Success:(void (^)(LLDynamicModel *dynamicModel))success
                                  failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString *method = [NSString stringWithFormat:@"dynamic/get/%ld",dynamicId];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:uid forKey:@"uid"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        UserInfo *userInfo = [GetCore(UserCore)getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue];
        LLDynamicModel *model = [LLDynamicModel modelDictionary:data];
        model.isCommunityDetails = YES;
        success(model);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+ (void)requestTabListWitUid:(NSString *)uid
                     Success:(void (^)(NSArray <CTTabTopicModel *> *homeTabModelList , NSArray <CTTabTopicModel *> *topicTabModelList))success
                     failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString *method = @"tab/list";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:uid forKey:@"uid"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        NSArray *homeTabList = [CTTabTopicModel modelsWithArray:data[@"homePage"]];
        NSArray *topicTablist = [CTTabTopicModel modelsWithArray:data[@"page"]];
        success(homeTabList,topicTablist);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+ (void)requestHomeTopicsWitUid:(NSString *)uid
                        Success:(void (^)(NSArray <CTTabTopicModel *> *tabModelList))success
                        failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString *method = @"topic/get";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:uid forKey:@"uid"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        NSArray *tabList = [CTTabTopicModel modelsWithArray:data];
        success(tabList);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+ (void)requestTopicsRecommendWitUid:(NSString *)uid
                             Success:(void (^)(NSArray <CTTabTopicModel *> *tabModelList))success
                             failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString *method = @"topic/recommend";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:uid forKey:@"uid"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        NSArray *tabList = [CTTabTopicModel modelsWithArray:data];
        success(tabList);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+ (void)requestTopicListWitUid:(NSString *)uid
                       pageNum:(NSInteger)pageNum
                       Success:(void (^)(NSArray <CTTabTopicModel *> *tabModelList))success
                       failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString *method = @"topic/list";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:uid forKey:@"uid"];
    [params safeSetObject:@(pageNum) forKey:@"pageNum"];
    [params safeSetObject:@(20) forKey:@"pageSize"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        NSArray *tabList = [CTTabTopicModel modelsWithArray:data];
        success(tabList);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}


+ (void)requestDynamicSeduceWitUid:(NSString *)uid
                         dynamicId:(long)dynamicId
                           Success:(void (^)(void))success
                           failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString *method = @"dynamic/seduce";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:uid forKey:@"uid"];
    [params safeSetObject:@(dynamicId) forKey:@"dynamicId"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success();
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+ (void)requestRedpacketIsReceiveWitUid:(NSString *)uid
                              dynamicId:(long)dynamicId
                             receiveUid:(NSString *)receiveUid
                                Success:(void (^)(void))success
                                failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString *method = @"redpacket/isReceive";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:uid forKey:@"uid"];
    [params safeSetObject:@(dynamicId) forKey:@"dynamicId"];
    [params safeSetObject:receiveUid forKey:@"receiveUid"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success();
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+ (void)requestRedpacketEffectiveWitUid:(NSString *)uid
                              dynamicId:(long)dynamicId
                                Success:(void (^)(BOOL isEffective))success
                                failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString *method = @"redpacket/effective";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:uid forKey:@"uid"];
    [params safeSetObject:@(dynamicId) forKey:@"dynamicId"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        BOOL isEffective = [data[@"effective"] boolValue];
        success(isEffective);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+ (void)requestFindDynamicRoomWitUid:(NSString *)uid
                             Success:(void (^)(long long roomId))success
                             failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString *method = @"multiRoom/findDynamicRoom";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:uid forKey:@"uid"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        long long roomId = [data[@"roomId"] longLongValue];
        success(roomId);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+ (void)requestDynamicExpireWitUid:(NSString *)uid
                         dynamicId:(long)dynamicId
                           Success:(void (^)(void))success
                           failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString *method = @"dynamic/expire";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:uid forKey:@"uid"];
    [params safeSetObject:@(dynamicId) forKey:@"dynamicId"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success();
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}


+ (void) requestUnReadListTpye:(int)type
                       success:(void (^)(NSArray *lists))success
                       failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    NSString *method = @"msg/unReadList";
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject: [GetCore(AuthCore) getUid] forKey:@"uid"];
    [params setObject:@(type) forKey:@"type"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        
        NSArray *lists = [HeartCommentInfo modelsWithArray:data];
        if (success) {
            success(lists);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+ (void) requestUnReadClearListTpye:(int)type
                            success:(void (^)(void))success
                            failure:(void (^)(NSString *message))failure{
    NSString *method = @"msg/clear";
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject: [GetCore(AuthCore) getUid] forKey:@"uid"];
    [params setObject:@(type) forKey:@"type"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        if (success) {
            success();
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(message);
        }
    }];
}

+ (void) requestUnReadCountSuccess:(void (^)(LTUnreadModel *model))success
                           failure:(void (^)(NSString *message))failure{
    NSString *method = @"msg/unreadCount";
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject: [GetCore(AuthCore) getUid] forKey:@"uid"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        LTUnreadModel *model = [LTUnreadModel yy_modelWithDictionary:data];
        if (success) {
            success(model);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(message);
        }
    }];
}

+ (void) requestHistoryListTpye:(int)type
                           page:(NSInteger)page
                        minDate:(NSInteger)minDate
                        success:(void (^)(NSArray *lists))success
                        failure:(void (^)(NSString *message))failure{
    NSString *method = @"msg/historyList";
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject: [GetCore(AuthCore) getUid] forKey:@"uid"];
    [params setObject:@(type) forKey:@"type"];
    if (page == 0) {
        [params setObject:@(1) forKey:@"pageNum"];
    }else {
        [params setObject:@(page) forKey:@"pageNum"];
    }
    [params setObject:@(20) forKey:@"pageSize"];
    [params setObject:@(minDate) forKey:@"minDate"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        
        NSArray *lists = [HeartCommentInfo modelsWithArray:data];
        if (success) {
            success(lists);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(message);
        }
    }];
}

+ (void)requestDynamicGetSquareSuccess:(void (^)(NSArray <LLDynamicModel *>* dynamicModelList))success
                                failure:(void (^)(NSString *message))failure {
    NSString *method = @"dynamic/getSquare";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:GetCore(AuthCore).getUid forKey:@"uid"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        NSArray *dynamicArr = [LLDynamicModel modelsWithArray:data];
        success(dynamicArr);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(message);
        }
    }];
}

+ (void)requestGetBlackListStatusWithMyUid:(long)myUid toUid:(long)toUid Success:(void (^)(NSInteger likeStatus))success failure:(void (^)(NSString *message))failure {
    NSString *method = @"like/getBlackList";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(myUid) forKey:@"myUid"];
    [params safeSetObject:@(toUid) forKey:@"toUid"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        NSInteger likeStatus = [data[@"likeStatus"] integerValue];
        success(likeStatus);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(message);
        }
    }];
}

/**
 小世界列表
 
 @param worldId 世界id
  @param page 查询页数，从 1 开始
  @param pageSize 每页数量
  @param searchKey 小世界查询关键字，用户耳伴号或小世界名称，支持模糊搜索
  */
+ (void)requestWorldGroupListWithWorldId:(NSString *)worldId
                                    page:(NSInteger)page
                                pageSize:(NSInteger)pageSize
                               searchKey:(nullable NSString *)searchKey
                              completion:(HttpRequestHelperCompletion)completion {
     
    NSString *path = @"world/group/chat/member/list";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    [params setValue:@(MAX(page, 1)) forKey:@"page"];
    [params setValue:@(MAX(pageSize, 1)) forKey:@"pageSize"];
    [params setValue:searchKey forKey:@"searchKey"];
    [params setValue:worldId forKey:@"worldId"];
    
    [self request:path
           method:HttpRequestHelperMethodPOST
           params:params
       completion:completion];
}

/**
 加入小世界群聊
 
 @param worldId 小世界id
 */
+ (void)requestWorldGroupJoinWithWorldId:(NSString *)worldId
                              completion:(HttpRequestHelperCompletion)completion {
    
    NSString *path = @"world/group/chat/joinByWorldId";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    [params setValue:worldId forKey:@"worldId"];
    
    [self request:path
           method:HttpRequestHelperMethodPOST
           params:params
       completion:completion];
}

/**
 退出小世界群聊，两个id二选一
 
 @param chatId 小世界群聊id
 @param sessionId 云信id
 */
+ (void)requestWorldGroupQuitWithChatId:(NSString *)chatId
                              sessionId:(NSString *)sessionId
                             completion:(HttpRequestHelperCompletion)completion {
    
    NSString *path = @"world/group/chat/exit";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    [params setValue:chatId forKey:@"chatId"];
    [params setValue:sessionId forKey:@"tid"];

    [self request:path
           method:HttpRequestHelperMethodPOST
           params:params
       completion:completion];
}

/**
 踢出小世界群聊

 @param toUid 被踢用户id
 */
+ (void)requestWorldGroupKickWithUid:(NSString *)toUid
                          completion:(HttpRequestHelperCompletion)completion {
    
    NSString *path = @"world/group/chat/exit";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    [params setValue:toUid forKey:@"toUid"];
    
    [self request:path
           method:HttpRequestHelperMethodPOST
           params:params
       completion:completion];
}

/**
 用户动态列表（我的主客态页）
 @param uid 查看对象的uid
 @param types 类型 0：纯文本，1:语音，2图片，3视频(为空标识所有,多种用逗号隔开)
 */
+ (void)requestUserMomentListForUid:(NSString *)uid types:(NSString *)types page:(NSInteger)page pageSize:(NSInteger)pageSize completion:(HttpRequestHelperCompletion)completion {
    
    NSString *path = @"dynamic/getMyDynamic";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"fromUid"];//当前用户uid
    [params setValue:uid forKey:@"uid"];//客态页用户uid
    [params setValue:types forKey:@"types"];
    [params setValue:@(MAX(1, page)) forKey:@"page"];
    [params setValue:@(MAX(1, pageSize)) forKey:@"pageSize"];

    [self request:path
           method:HttpRequestHelperMethodPOST
           params:params
       completion:completion];
}

/**
 获取动态详情

 @param dynamicId 动态id
 @param worldID 小世界id
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)requestDynamicDetailsWitDynamicId:(NSString *)dynamicId
                                  worldID:(NSString *)worldID
                                  Success:(void (^)(LLDynamicModel *dynamicModel))success
                                  failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString *method = @"dynamic/detail";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:dynamicId forKey:@"dynamicId"];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    [params setValue:worldID forKey:@"worldId"];

    [HttpRequestHelper POST:method params:params success:^(id data) {
        LLDynamicModel *model = [LLDynamicModel modelDictionary:data];
        model.isCommunityDetails = YES;
        success(model);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

/**
 请求评论列表

 @param worldId 所在小世界id
 @param dynamicId 动态id
 @param pageNum 页数
 @param timestamp 上一个评论list里的最后时间戳
 */
+ (void)requestCommentListWithWorldID:(NSString *)worldID
                            dynamicId:(NSString *)dynamicId
                              pageNum:(NSInteger)pageNum
                            timestamp:(long)timestamp
                              Success:(void (^)(NSArray <CTCommentReplyModel *> *commentList, long timeStamp))success
                              failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString *method = @"dynamic/comment/list";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:GetCore(AuthCore).getUid forKey:@"uid"];
//    [params safeSetObject:worldID forKey:@"worldId"];
    [params safeSetObject:dynamicId forKey:@"dynamicId"];
//    [params safeSetObject:@(pageNum) forKey:@"pageNum"];
    [params safeSetObject:@(10) forKey:@"pageSize"];
    if (timestamp) {
        [params safeSetObject:@(timestamp) forKey:@"timestamp"];
    }

    [HttpRequestHelper GET:method params:params success:^(id data) {
        NSArray *commentList = [CTCommentReplyModel  modelsWithArray:data[@"commentList"]];
        long timeStamp = [data[@"nextTimestamp"] longValue];
        success(commentList, timeStamp);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+ (void)requestAddCommentWithDynamicId:(NSInteger)dynamicId
                         content:(NSString *)content
                         Success:(void (^)(CTCommentReplyModel * commentModel))success
                         failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString *method = @"dynamic/comment/publish";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:GetCore(AuthCore).getUid forKey:@"uid"];
    [params safeSetObject:@(dynamicId) forKey:@"dynamicId"];
    [params safeSetObject:content forKey:@"content"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        CTCommentReplyModel *model = [CTCommentReplyModel  modelDictionary:data];
        success(model);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

/**
 回复评论

 @param dynamicId 动态id
 @param content 回复类容
 @param commentId 被回复的评论id
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)requestReplyCommentWitDynamicId:(NSInteger)dynamicId
                                content:(NSString *)content
                              commentId:(NSInteger )commentId
                                Success:(void (^)(CTReplyModel * replyModel))success
                                failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString *method = @"dynamic/comment/reply";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params safeSetObject:@(dynamicId) forKey:@"dynamicId"];
    [params safeSetObject:GetCore(AuthCore).getUid forKey:@"uid"];
    [params safeSetObject:@(commentId) forKey:@"commentId"];
    [params safeSetObject:content forKey:@"content"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        if (data) {
            CTReplyModel *model = [CTReplyModel  modelDictionary:data];
            success(model);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

/**
 查询嗨玩派对房间（语音派对）
 */
+ (void)requestWorldPartyRoomListWithWorldId:(NSString *)worldId completion:(HttpRequestHelperCompletion)completion {
    
    NSString *path = @"world/room/query";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    [params setValue:worldId forKey:@"worldId"];

    [self request:path
           method:HttpRequestHelperMethodPOST
           params:params
       completion:completion];
}

/// 删除评论 or 评论回复
/// @param commnetID 评论id
/// @param success 成功回调
/// @param failure 失败回调
+ (void)requestDynamicDeleteCommentWithCommentID:(NSString *)commnetID
                                         Success:(void (^)(CTReplyModel * replyModel))success
                                         failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString *method = @"dynamic/comment/delete";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params safeSetObject:commnetID forKey:@"commentId"];
    [params safeSetObject:GetCore(AuthCore).getUid forKey:@"uid"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        CTReplyModel * model = [CTReplyModel modelWithJSON:data];
        success(model);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

/// 获取评论回复列表
/// @param dynamicID 当前动态的动态id
/// @param commentID 动态的当前评论id
/// @param timestamp 上一条回复的时间戳
/// @param success 成功回调
/// @param failure 失败回调
+ (void)requestDynamicCommentReplyListWithDynamicID:(NSInteger)dynamicID commentID:(NSString *)commentID timestamp:(NSString *)timestamp Success:(void (^)(CTReplyInfoModel *replyInfoModel))success failure:(void (^)(NSNumber *resCode, NSString *message))failure {
   
    NSString *method = @"dynamic/comment/reply/list";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
     
    [params safeSetObject:@(dynamicID) forKey:@"dynamicId"];
    [params safeSetObject:GetCore(AuthCore).getUid forKey:@"uid"];
    [params safeSetObject:@"5" forKey:@"pageSize"];
    [params safeSetObject:commentID forKey:@"commentId"];
    [params safeSetObject:timestamp forKey:@"timestamp"];
     
    [HttpRequestHelper POST:method params:params success:^(id data) {
        CTReplyInfoModel *replyInfo = [CTReplyInfoModel modelWithJSON:data];
        success(replyInfo);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

/// 分享动态
/// @param worldId 所在的小世界id
/// @param dynamicID 动态id
/// @param uid 被分享人的 uid
+ (void)requestWorldShareDynamicWithWorldId:(NSString *)worldId dynamicID:(NSInteger)dynamicID uid:(NSString *)uid Success:(void (^)(CTReplyInfoModel *replyInfoModel))success failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    
    NSString *method = @"dynamic/share";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
     
    [params safeSetObject:@(dynamicID) forKey:@"dynamicId"];
    [params safeSetObject:uid forKey:@"uid"];
    [params safeSetObject:worldId forKey:@"worldId"];
    [params safeSetObject:GetCore(AuthCore).getUid forKey:@"shareUid"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success(data);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
    
}

/// 动态广场推荐的动态
+ (void)requestDynamicSquareRecommendDynamicsWithPage:(NSInteger)page Success:(void (^)(NSArray <LLDynamicModel *>* dynamicModelList))success failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString *method = @"dynamic/square/recommendDynamics";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params safeSetObject:@(page) forKey:@"page"];
    [params safeSetObject:@"0,2" forKey:@"types"];
    [params safeSetObject:@20 forKey:@"pageSize"];
    [HttpRequestHelper GET:method params:params success:^(id data) {
        NSArray<LLDynamicModel *> *modelList = [LLDynamicModel modelsWithArray:data];
        success(modelList);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}
/// 动态广场关注的动态
+ (void)requestDynamicSquareFollowerDynamicsWithDynamicId:(NSString *)dynamicId Success:(void (^)(NSArray <LLDynamicModel *>* dynamicModelList, NSString *nextDynamicId))success failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString *method = @"dynamic/square/followerDynamics";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
     
    [params safeSetObject:@20 forKey:@"pageSize"];
    [params safeSetObject:@"0,2" forKey:@"types"];
    [params safeSetObject:dynamicId forKey:@"dynamicId"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        NSArray<LLDynamicModel *> *modelList = [LLDynamicModel modelsWithArray:data[@"dynamicList"]];
        success(modelList, data[@"nextDynamicId"]);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}
/// 动态广场动态详情
+ (void)requestDynamicSquareDynamicsDetailWithSuccess:(void (^)(LLDynamicModel *dynamicModel))success failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    
}

/// 动态发布里的世界列表
/// @param type 请求世界类型
/// @param page 分页，默认1
+ (void)requestWorldDynamicPostWorldListWithType:(DynamicPostWorldRequestType)type page:(NSInteger)page completion:(HttpRequestHelperCompletion)completion {
    
    NSString *path = @"dynamic/square/world";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    [params setValue:@(type) forKey:@"type"];
    [params setValue:@(page) forKey:@"page"];
//    [params setValue:@(10) forKey:@"pageSize"];//type为2时，默认为5，其他取10
    
    [self request:path
           method:HttpRequestHelperMethodGET
           params:params
       completion:completion];
}

/// 获取主播订单状态（获取用户最新的动态派单）
/// @param targetUid 对方uid
+ (void)requestAnchorOrderStatusWithUid:(NSString *)targetUid
                           completion:(HttpRequestHelperCompletion)completion {
    
    NSString *path = @"workOrder/getLastOrder";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    [params setValue:targetUid forKey:@"targetUid"];
    
    [self request:path
           method:HttpRequestHelperMethodGET
           params:params
       completion:completion];
}

/// 获取动态派单的配置
+ (void)requestAnchorOrderConfigWithCompletion:(HttpRequestHelperCompletion)completion {
    
    NSString *path = @"workOrder/getOrderConfig";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [self request:path
           method:HttpRequestHelperMethodGET
           params:params
       completion:completion];
}

@end
