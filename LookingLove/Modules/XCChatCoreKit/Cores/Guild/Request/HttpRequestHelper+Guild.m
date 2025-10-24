//
//  HttpRequestHelper+Guild.m
//  XCChatCoreKit
//
//  Created by lvjunhang on 2019/1/7.
//  Copyright © 2019年 KevinWang. All rights reserved.
//

#import "HttpRequestHelper+Guild.h"
#import "AuthCore.h"

@implementation HttpRequestHelper (Guild)

/**
 更新模厅名
 
 @param hallName 模厅名称
 @param completion 完成回调
 */
+ (void)requestGuildHallNameUpdateWithHallName:(NSString *)hallName
                                    completion:(HttpRequestHelperGuildCompletion)completion
{
    NSString *path = @"hall/updateHallName";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    [params setValue:hallName forKey:@"hallName"];
    
    [self guild_request:path
                 method:HttpRequestHelperMethodPOST
                 params:params
             completion:completion];
}

/**
 获取模厅信息
 
 @param hallId 模厅id
 @param completion 完成回调
 */
+ (void)requestGuildHallInfoFetchWithHallId:(NSString *)hallId uid:(NSString *)uid
                                 completion:(HttpRequestHelperGuildCompletion)completion
{
    NSString *path = @"hall/getHallInfo";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:uid forKey:@"uid"];
    [params setValue:hallId forKey:@"hallId"];
    
    [self guild_request:path
                 method:HttpRequestHelperMethodGET
                 params:params
             completion:completion];
}

/**
 创建群聊
 
 @param hallId 模厅id
 @param type 群聊类型：1公开群，2内部群
 @param name 名称
 @param icon 头像
 @param notice 公告
 @param members 成员uid,多个uid用逗号拼接
 @param completion 完成回调
 */
+ (void)requestGuildGroupCreateWithHallId:(NSString *)hallId
                                         type:(NSUInteger)type
                                         name:(NSString *)name
                                         icon:(NSString *)icon
                                       notice:(NSString *)notice
                                      members:(NSString *)members
                                   completion:(HttpRequestHelperGuildCompletion)completion
{
    NSString *path = @"hall/group/create";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    [params setValue:hallId forKey:@"hallId"];
    [params setValue:@(type) forKey:@"type"];
    [params setValue:name forKey:@"name"];
    [params setValue:icon forKey:@"icon"];
    [params setValue:notice forKey:@"notice"];
    [params setValue:members forKey:@"members"];
    
    [self guild_request:path
                 method:HttpRequestHelperMethodPOST
                 params:params
             completion:completion];
}

/**
 解散群聊
 
 @param chatId 群聊id
 @param completion 完成回调
 */
+ (void)requestGuildGroupRemoveWithChatId:(NSString *)chatId
                                   completion:(HttpRequestHelperGuildCompletion)completion
{
    NSString *path = @"hall/group/remove";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    [params setValue:chatId forKey:@"chatId"];
    
    [self guild_request:path
                 method:HttpRequestHelperMethodPOST
                 params:params
             completion:completion];
}

/**
 离开群聊
 
 @param chatId 群聊id
 @param completion 完成回调
 */
+ (void)requestGuildGroupQuitWithChatId:(NSString *)chatId
                               completion:(HttpRequestHelperGuildCompletion)completion
{
    NSString *path = @"hall/group/leave";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    [params setValue:chatId forKey:@"chatId"];
    
    [self guild_request:path
                 method:HttpRequestHelperMethodPOST
                 params:params
             completion:completion];
}

/**
 获取群聊资料
 
 @param tid 云信群聊id
 @param completion 完成回调
 */
+ (void)requestGuildGroupInfoFetchWithTid:(NSString *)tid
                                      completion:(HttpRequestHelperGuildCompletion)completion
{
    NSString *path = @"/hall/group/getGroupChat";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    [params setValue:tid forKey:@"tid"];
    
    [self guild_request:path
                 method:HttpRequestHelperMethodGET
                 params:params
             completion:completion];
}

/**
 更新群聊资料
 
 @param chatId 群聊id
 @param icon 头像
 @param name 名称
 @param notice 公告
 @param completion 完成回调
 */
+ (void)requestGuildGroupInfoUpdateWithChatId:(NSString *)chatId
                                             icon:(NSString *)icon
                                             name:(NSString *)name
                                           notice:(NSString *)notice
                                       completion:(HttpRequestHelperGuildCompletion)completion
{
    NSString *path = @"hall/group/update";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    [params setValue:chatId forKey:@"chatId"];
    [params setValue:name forKey:@"name"];
    [params setValue:icon forKey:@"icon"];
    [params setValue:notice forKey:@"notice"];
    
    [self guild_request:path
                 method:HttpRequestHelperMethodPOST
                 params:params
             completion:completion];
}


/**
 根据 uid 获取模厅公告显示

 @param uid 用户 uid
 @param completion 完成回调
 */
+ (void)requestGuildHallMenusWithUid:(NSString *)uid
                          completion:(HttpRequestHelperGuildCompletion)completion {
    NSString *path = @"/hallAuth/getHallMenusByUid";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (uid.length == 0) {
        [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    } else {
        [params setValue:uid forKey:@"uid"];
    }
    
    [self guild_request:path
                 method:HttpRequestHelperMethodPOST
                 params:params
             completion:completion];
}

/**
 查询模厅权限列表
 
 @param uid 用户 uid
 @param roleType 权限类型 1表示厅主,2高管,3普通成员
 @param completion 完成回调
 */
+ (void)requestGuildHallAuthListWithUid:(NSString *)uid
                               roleType:(NSString *)roleType
                             completion:(HttpRequestHelperGuildCompletion)completion {
    NSString *path = @"hallAuth/getHallAuths";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:uid forKey:@"uid"];
    [params setValue:roleType forKey:@"roleType"];
    
    [self guild_request:path
                 method:HttpRequestHelperMethodPOST
                 params:params
             completion:completion];
}

/**
 获取高管权限列表
 
 @param uid 厅主 uid
 @param managerUid 被查询的管理员的 uid
 @param completion 完成回调
 */
+ (void)requestGuildHallGetManagerAuthWithUid:(NSString *)uid
                                    managerUid:(NSString *)managerUid
                                    completion:(HttpRequestHelperGuildCompletion)completion {
    
    NSString *path = @"hallAuth/getHallManagerAuths";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:uid forKey:@"uid"];
    [params setValue:managerUid forKey:@"managerUid"];
    
    [self guild_request:path
                 method:HttpRequestHelperMethodPOST
                 params:params
             completion:completion];
}

/**
 设置高管权限列表
 
 @param uid 厅主 uid
 @param managerUid 被设置的管理员 uid
 @param hallId 模厅 id
 @param authStr 被设置的权限
 @param completion 完成回调
 */
+ (void)requestGuildHallSetManagerAuthWithUid:(NSString *)uid
                                   managerUid:(NSString *)managerUid
                                       hallID:(NSString *)hallId
                                      authStr:(NSString *)authStr
                                   completion:(HttpRequestHelperGuildCompletion)completion {
    
    NSString *path = @"/hallAuth/setHallManagerAuths";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:uid forKey:@"uid"];
    [params setValue:managerUid forKey:@"managerUid"];
    [params setValue:hallId forKey:@"hallId"];
    [params setValue:authStr forKey:@"authStr"];
    
    [self guild_request:path
                 method:HttpRequestHelperMethodPOST
                 params:params
             completion:completion];
}

/**
 申请加入模厅
 
 @param uid 申请人的 Uid
 @param hallId 模厅 id
 @param completion 完成回调
 */
+ (void)requestGuildHallJoinWithUid:(NSString *)uid
                             hallId:(NSString *)hallId
                         completion:(HttpRequestHelperGuildCompletion)completion {
    NSString *path = @"/hall/apply";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:uid forKey:@"uid"];
    [params setValue:hallId forKey:@"hallId"];
    
    [self guild_request:path
                 method:HttpRequestHelperMethodPOST
                 params:params
             completion:completion];
}

/**
 厅主/高管 审核加入申请
 
 @param path 请求路径
 @param recordId 记录 id
 @param type 操作类型：0拒绝 1同意
 @param completion 完成回调
 */
+ (void)requestGuildHallDealApplyWithPath:(NSString *)path
                                recordId:(NSString *)recordId
                                    type:(NSInteger)type
                              completion:(HttpRequestHelperGuildCompletion)completion {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    [params setValue:recordId forKey:@"recordId"];
    [params setValue:@(type) forKey:@"type"];
    
    [self guild_request:path
                 method:HttpRequestHelperMethodPOST
                 params:params
             completion:completion];
}

/**
 厅主/高管 同意退出申请

 @param path 请求路径
 @param recordId 记录 id
 @param completion 完成回调
 */
+ (void)requestGuildAuditQuitHallWithPath:(NSString *)path
                                 recordId:(NSString *)recordId
                              completion:(HttpRequestHelperGuildCompletion)completion {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    [params setValue:recordId forKey:@"recordId"];
    
    [self guild_request:path
                 method:HttpRequestHelperMethodPOST
                 params:params
             completion:completion];
}

/**
 普通成员 处理邀请(入厅)
 
 @param path 请求路径
 @param recordId 记录 id
 @param type 操作类型：0拒绝 1同意
 */
+ (void)requestGuildDealInviteHallWithPath:(NSString *)path
                                  recordId:(NSString *)recordId
                                          type:(NSInteger)type
                                   completion:(HttpRequestHelperGuildCompletion)completion {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    [params setValue:recordId forKey:@"recordId"];
    [params setValue:@(type) forKey:@"type"];

    [self guild_request:path
                 method:HttpRequestHelperMethodPOST
                 params:params
             completion:completion];
}

/**

获取模厅群聊列表

@param hallId 模厅id
@param type 1:公开群，2：内部群， 空查全部
*/
+ (void)requestGuildGroupListWithHallId:(NSString *)hallId
                              groupType:(nullable NSString *)type
                             completion:(HttpRequestHelperGuildCompletion)completion
{
    NSString *path = @"hall/group/getGroupChatList";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    [params setValue:hallId forKey:@"hallId"];
    [params setValue:type forKey:@"type"];
    
    [self guild_request:path
                 method:HttpRequestHelperMethodGET
                 params:params
             completion:completion];
}

/**
 获取模厅所有成员列表
 
 @param hallId 公会模厅id
 @param page page 页码
 @param pageSize pageSize 每页数量
 @param completion 完成回调
 */
+ (void)requestGuildHallAllMemberListByHallId:(NSString *)hallId
                                         page:(NSInteger)page
                                     pageSize:(NSInteger)pageSize
                                   completion:(HttpRequestHelperGuildCompletion)completion {
    NSString *path = @"hall/getAllMembers";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:hallId forKey:@"hallId"];
    [params setValue:@(page) forKey:@"page"];
    [params setValue:@(pageSize) forKey:@"pageSize"];
    
    [self guild_request:path
                 method:HttpRequestHelperMethodGET
                 params:params
             completion:completion];
}

/**
 获取模厅所有管理员列表
 
 @param hallId 公会模厅id
 @param page page 页码
 @param pageSize pageSize 每页数量
 @param completion 完成回调
 */
+ (void)requestGuildHallAllManagerListByHallId:(NSString *)hallId
                                          page:(NSInteger)page
                                      pageSize:(NSInteger)pageSize
                                    completion:(HttpRequestHelperGuildCompletion)completion {
    NSString *path = @"hall/getHallManager";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:hallId forKey:@"hallId"];
    [params setValue:@(page) forKey:@"page"];
    [params setValue:@(pageSize) forKey:@"pageSize"];
    
    [self guild_request:path
                 method:HttpRequestHelperMethodGET
                 params:params
             completion:completion];
    
}

/**
 设置高管
 
 @param hallId 模厅公会id
 @param targetUid 被设置的高管 uid
 @param completion 完成回调
 */
+ (void)requestGuildHallSetManagerByHallId:(NSString *)hallId
                                 targetUid:(NSString *)targetUid
                                completion:(HttpRequestHelperGuildCompletion)completion {
    NSString *path = @"hall/setManager";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:hallId forKey:@"hallId"];
    [params setValue:targetUid forKey:@"targetUid"];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    
    [self guild_request:path
                 method:HttpRequestHelperMethodPOST
                 params:params
             completion:completion];
}

/**
 取消高管
 
 @param hallId 模厅公会id
 @param targetUid 被取消的高管 uid
 @param completion 完成回调
 */
+ (void)requestGuildHallRemoveManagerByHallId:(NSString *)hallId
                                    targetUid:(NSString *)targetUid
                                   completion:(HttpRequestHelperGuildCompletion)completion {
    NSString *path = @"hall/removeManager";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:hallId forKey:@"hallId"];
    [params setValue:targetUid forKey:@"targetUid"];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    
    [self guild_request:path
                 method:HttpRequestHelperMethodPOST
                 params:params
             completion:completion];
}

/**
 打开/关闭群聊消息提醒
 
 @param chatId 群聊id
 @param isMute 操作参数 true:开启免打扰 false:关闭免打扰
 @param completion 完成回调
 */
+ (void)requestGuildGroupPromptSettingWithChatId:(NSString *)chatId
                                    promptStatus:(BOOL)isMute
                                   completion:(HttpRequestHelperGuildCompletion)completion {
    NSString *path = @"/hall/group/prompt";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:chatId forKey:@"chatId"];
    [params setValue:@(isMute) forKey:@"promptStatus"];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    
    [self guild_request:path
                 method:HttpRequestHelperMethodPOST
                 params:params
             completion:completion];
}

/**
 收入统计
 
 @param hallId 模厅id
 @param startTimeStr 开始时间(有格式要求) 2019-01-07
 @param endTimeStr 结束时间(按日统计,结束时间要为空,有格式要求) 2019-01-13
 @param completion 完成回调
 */
+ (void)requestGuildIncomeTotalWithHallId:(NSString *)hallId
                              startTimeStr:(NSString *)startTimeStr
                                endTimeStr:(NSString *)endTimeStr
                                completion:(HttpRequestHelperGuildCompletion)completion {
    NSString *path = @"/income/incomeTotal";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];//厅主或高管Id
    [params setValue:hallId forKey:@"hallId"];
    [params setValue:startTimeStr forKey:@"startTimeStr"];
    [params setValue:endTimeStr forKey:@"endTimeStr"];
    
    [self guild_request:path
                 method:HttpRequestHelperMethodPOST
                 params:params
             completion:completion];
}

/**
 收入明细
 
 @param hallId 模厅id
 @param memberId 模厅成员id
 @param startTimeStr 开始时间(有格式要求) 2019-01-07
 @param endTimeStr 结束时间(按日统计,结束时间要为空,有格式要求) 2019-01-13
 @param completion 完成回调
 */
+ (void)requestGuildIncomeDetailWithHallId:(NSString *)hallId
                                  memberId:(NSString *)memberId
                                    startTimeStr:(NSString *)startTimeStr
                                endTimeStr:(NSString *)endTimeStr
                                      completion:(HttpRequestHelperGuildCompletion)completion {
    NSString *path = @"/income/incomeDetail";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];//厅主或高管Id
    [params setValue:hallId forKey:@"hallId"];
    [params setValue:memberId forKey:@"memberId"];
    [params setValue:startTimeStr forKey:@"startTimeStr"];
    [params setValue:endTimeStr forKey:@"endTimeStr"];

    [self guild_request:path
                 method:HttpRequestHelperMethodPOST
                 params:params
             completion:completion];
}

/**
 获取厅主模厅信息
 
 @param targetUid 目标用户uid
 @param completion 完成回调
 */
+ (void)requestGuildHallInfoWithOwnUid:(NSString *)targetUid
                                completion:(HttpRequestHelperGuildCompletion)completion {
    NSString *path = @"/hall/getOwnerHallInfo";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    [params setValue:targetUid forKey:@"targetUid"];
    
    [self guild_request:path
                 method:HttpRequestHelperMethodGET
                 params:params
             completion:completion];
}

/**
 主动加入群聊
 
 @param chatId 群聊id
 @param completion 完成回调
 */
+ (void)requestGuildGroupJoinWithChatId:(NSString *)chatId
                            completion:(HttpRequestHelperGuildCompletion)completion {
    NSString *path = @"/hall/group/join";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    [params setValue:chatId forKey:@"chatId"];
    
    [self guild_request:path
                 method:HttpRequestHelperMethodPOST
                 params:params
             completion:completion];
}

/**
 添加模厅权限(此接口待完善)
 
 @param authType authType
 @param completion 完成回调
 */
+ (void)requestGuildAuthAddWithType:(NSString *)authType
                             completion:(HttpRequestHelperGuildCompletion)completion {
    NSString *path = @"/hallAuth/addAuth";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    [params setValue:authType forKey:@"authType"];
    
    [self guild_request:path
                 method:HttpRequestHelperMethodPOST
                 params:params
             completion:completion];
}

/**
 获取不在指定群聊里面的模厅成员
 
 @param chatId 群聊id
 @param page 页码
 @param pageSize 页容量
 @param completion 完成回调
 */
+ (void)requestGuildMemberListWhichNotInGroupWithChatId:(NSString *)chatId
                                                   page:(NSInteger)page
                                               pageSize:(NSInteger)pageSize
                         completion:(HttpRequestHelperGuildCompletion)completion {
    NSString *path = @"/hall/getNotExistChat";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    [params setValue:chatId forKey:@"chatId"];
    [params setValue:@(page<=1 ? 1 : page) forKey:@"page"];
    [params setValue:@(pageSize<=0 ? 20 : pageSize) forKey:@"pageSize"];
    
    [self guild_request:path
                 method:HttpRequestHelperMethodGET
                 params:params
             completion:completion];
}

/**
 获取群聊所有成员列表
 
 @param chatId 群聊id
 @param page 页码
 @param pageSize 页容量
 @param completion 完成回调
 */
+ (void)requestGuildGroupAllMembersWithChatId:(NSString *)chatId
                                   page:(NSInteger)page
                               pageSize:(NSInteger)pageSize
                             completion:(HttpRequestHelperGuildCompletion)completion {
    NSString *path = @"hall/group/getAllMembers";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    [params setValue:chatId forKey:@"chatId"];
    [params setValue:@(page<=1 ? 1 : page) forKey:@"page"];
    [params setValue:@(pageSize<=0 ? 20 : pageSize) forKey:@"pageSize"];
    
    [self guild_request:path
                 method:HttpRequestHelperMethodGET
                 params:params
             completion:completion];
}

/**
 禁言/解禁群聊成员
 
 @param chatId 群聊id
 @param targetUid 目标用户uid
 @param isMute 操作参数 true:禁言 false:解禁
 @param completion 完成回调
 */
+ (void)requestGuildGroupBanWithChatId:(NSString *)chatId
                              targetUid:(NSString *)targetUid
                                 isMute:(BOOL)isMute
                             completion:(HttpRequestHelperGuildCompletion)completion {
    NSString *path = @"/hall/group/banned";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    [params setValue:chatId forKey:@"chatId"];
    [params setValue:targetUid forKey:@"targetUid"];
    [params setValue:@(isMute) forKey:@"mute"];
    
    [self guild_request:path
                 method:HttpRequestHelperMethodPOST
                 params:params
             completion:completion];
}

/**
 踢出群聊成员
 
 @param chatId 群聊id
 @param targetUids 目标用户uid,用逗号拼接
 @param completion 完成回调
 */
+ (void)requestGuildGroupKickWithChatId:(NSString *)chatId
                         targetUids:(NSString *)targetUids
                        completion:(HttpRequestHelperGuildCompletion)completion {
    NSString *path = @"/hall/group/kickMember";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    [params setValue:chatId forKey:@"chatId"];
    [params setValue:targetUids forKey:@"targetUids"];
    
    [self guild_request:path
                 method:HttpRequestHelperMethodPOST
                 params:params
             completion:completion];
}

/**
 按条件搜索成员
 
 @param hallId 模厅id
 @param key 关键字
 @param completion 完成回调
 */
+ (void)requestGuildSearchMembersWithHallId:(NSString *)hallId
                             key:(NSString *)key
                             completion:(HttpRequestHelperGuildCompletion)completion {
    NSString *path = @"hall/queryMembers";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    [params setValue:hallId forKey:@"hallId"];
    [params setValue:key forKey:@"key"];
    
    [self guild_request:path
                 method:HttpRequestHelperMethodGET
                 params:params
             completion:completion];
}

/**
 加入群聊
 
 @param chatId 群聊id
 @param targetUids 目标用户uid,用逗号拼接
 @param completion 完成回调
 */
+ (void)requestGuildGroupAddMembersWithChatId:(NSString *)chatId
                             targetUids:(NSString *)targetUids
                                 completion:(HttpRequestHelperGuildCompletion)completion {
    NSString *path = @"hall/group/addMember";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    [params setValue:chatId forKey:@"chatId"];
    [params setValue:targetUids forKey:@"targetUids"];
    
    [self guild_request:path
                 method:HttpRequestHelperMethodPOST
                 params:params
             completion:completion];
}

/**
 取消群聊管理
 
 @param chatId 群聊id
 @param targetUid 目标用户uid
 @param completion 完成回调
 */
+ (void)requestGuildGroupCancelManagerWithChatId:(NSString *)chatId
                             targetUid:(NSString *)targetUid
                             completion:(HttpRequestHelperGuildCompletion)completion {
    NSString *path = @"hall/group/unManager";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    [params setValue:chatId forKey:@"chatId"];
    [params setValue:targetUid forKey:@"targetUid"];
    
    [self guild_request:path
                 method:HttpRequestHelperMethodPOST
                 params:params
             completion:completion];
}

/**
 设置群聊管理
 
 @param chatId 群聊id
 @param targetUid 目标用户uid
 @param completion 完成回调
 */
+ (void)requestGuildGroupSetManagerWithChatId:(NSString *)chatId
                              targetUid:(NSString *)targetUid
                             completion:(HttpRequestHelperGuildCompletion)completion {
    NSString *path = @"hall/group/setManager";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    [params setValue:chatId forKey:@"chatId"];
    [params setValue:targetUid forKey:@"targetUid"];
    
    [self guild_request:path
                 method:HttpRequestHelperMethodPOST
                 params:params
             completion:completion];
}

/**
 获取群聊数量限制配置
 
 @param completion 完成回调
 */
+ (void)requestGuildGroupInfoLimitWithCompletion:(HttpRequestHelperGuildCompletion)completion {
    NSString *path = @"/hall/group/getGroupChatLimit";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    
    [self guild_request:path
                 method:HttpRequestHelperMethodGET
                 params:params
             completion:completion];
}

/**
 移出模厅
 
 @param targetUid 目标用户uid
 @param completion 完成回调
 */
+ (void)requestGuildHallKickWithTargetUid:(NSString *)targetUid
                             completion:(HttpRequestHelperGuildCompletion)completion {
    NSString *path = @"hall/remove";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    [params setValue:targetUid forKey:@"targetUid"];
    
    [self guild_request:path
                 method:HttpRequestHelperMethodPOST
                 params:params
             completion:completion];
}

/**
 申请退出模厅
 
 @param completion 完成回调
 */
+ (void)requestGuildHallQuitWithCompletion:(HttpRequestHelperGuildCompletion)completion {
    NSString *path = @"hall/quit";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    
    [self guild_request:path
                 method:HttpRequestHelperMethodPOST
                 params:params
             completion:completion];
}

/**
 邀请加入模厅
 
 @param targetUid 目标用户uid
 @param completion 完成回调
 */
+ (void)requestGuildHallInviteWithTargetUid:(NSString *)targetUid
                               completion:(HttpRequestHelperGuildCompletion)completion {
    NSString *path = @"hall/invite";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    [params setValue:targetUid forKey:@"targetUid"];
    
    [self guild_request:path
                 method:HttpRequestHelperMethodPOST
                 params:params
             completion:completion];
}

#pragma mark -
#pragma mark 暗号邀请码

/**
 获取公会emoji 暗号邀请码
 
 @param completion 完成回调
 */
+ (void)requestGuildEmojiCodeCompletion:(HttpRequestHelperGuildCompletion)completion {
    NSString *path = @"hall/getEmojiCode";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    
    [self guild_request:path
                 method:HttpRequestHelperMethodGET
                 params:params
             completion:completion];
}

/**
 校验 emoji 暗号邀请码
 
 @param emojiCode emoji 暗号邀请码
 @param completion 完成回调
 */
+ (void)requestGuildCheckEmojiCode:(NSString *)emojiCode
                        completion:(HttpRequestHelperGuildCompletion)completion {
    NSString *path = @"hall/checkCode";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    [params setValue:emojiCode forKey:@"code"];
    
    [self guild_request:path
                 method:HttpRequestHelperMethodPOST
                 params:params
             completion:completion];
}

/**
 通过emoji暗号邀请码加入模厅
 
 @param emojiCode 暗号邀请码
 @param completion 完成回调
 */
+ (void)requestGuildJoinByEmojiCode:(NSString *)emojiCode
                         completion:(HttpRequestHelperGuildCompletion)completion {
    NSString *path = @"hall/joinByCode";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    [params setValue:emojiCode forKey:@"code"];
    
    [self guild_request:path
                 method:HttpRequestHelperMethodPOST
                 params:params
             completion:completion];
}


#pragma mark - Private Methods
+ (void)guild_request:(NSString *)url
               method:(HttpRequestHelperMethod)method
               params:(NSDictionary *)params
           completion:(HttpRequestHelperGuildCompletion)completion
{
    if ([url hasPrefix:@"/"]) {
        url = [url substringFromIndex:1];
    }
    
    [self request:url method:method params:params success:^(id data) {
        if (completion) {
            completion(data, nil, nil);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (completion) {
            completion(nil, resCode, message);
        }
    }];
}

@end

