//
//  GuildCore.m
//  XCChatCoreKit
//
//  Created by lvjunhang on 2019/1/7.
//  Copyright © 2019年 KevinWang. All rights reserved.
//

#import "GuildCore.h"
#import "GuildCoreClient.h"
#import "HttpRequestHelper+Guild.h"

// model
#import "GuildHallGroupInfo.h"
#import "GuildHallGroupListItem.h"
#import "UserInfo.h"
#import "GuildHallManagerInfo.h"
#import "GuildIncomeTotal.h"
#import "GuildIncomeDetail.h"
#import "GuildOwnerHallInfo.h"
#import "GuildChatGroupAllMemberResponse.h"
#import "GuildHallMenu.h"
// 暗号邀请码
#import "GuildEmojiCode.h"
#import "GuildCheckEmojiCode.h"

@implementation GuildCore

/**
 更新模厅名
 
 @param hallName 模厅名称
 */
- (void)requestGuildUpdateHallName:(NSString *)hallName {
    [HttpRequestHelper requestGuildHallNameUpdateWithHallName:hallName completion:^(id  _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg) {
        
        BOOL isSuccess = code == nil && msg == nil;
        NotifyCoreClient(GuildCoreClient, @selector(responseGuildHallNameUpdate:errorCode:msg:), responseGuildHallNameUpdate:isSuccess errorCode:code msg:msg);
    }];
};

/**
 获取模厅信息
 
 @param hallId 模厅id
 */
- (void)requestGuildHallInfoFetchWithHallId:(NSString *)hallId uid:(NSString *)uid {
    [HttpRequestHelper requestGuildHallInfoFetchWithHallId:hallId uid:uid completion:^(id  _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg) {
        
        GuildHallInfo *response = [GuildHallInfo yy_modelWithJSON:data];
        if (data == nil || ![response isKindOfClass:GuildHallInfo.class]) {
            response = nil;
        }
        self.hallInfo = response;
        NotifyCoreClient(GuildCoreClient, @selector(responseGuildHallInfoFetch:errorCode:msg:), responseGuildHallInfoFetch:response errorCode:code msg:msg);
    }];
}

/**
 创建群聊
 
 @param hallId 模厅id
 @param type 群聊类型：1公开群，2内部群
 @param name 名称
 @param icon 头像
 @param notice 公告
 @param members 成员uid,多个uid用逗号拼接
 */
- (void)requestGuildGroupCreateWithHallId:(NSString *)hallId
                                         type:(NSUInteger)type
                                         name:(NSString *)name
                                         icon:(NSString *)icon
                                       notice:(NSString *)notice
                                      members:(NSString *)members {
    [HttpRequestHelper requestGuildGroupCreateWithHallId:hallId type:type name:name icon:icon notice:notice members:members completion:^(id  _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg) {
        
        GuildHallGroupCreateResponse *response = [GuildHallGroupCreateResponse yy_modelWithJSON:data];
        if (data == nil || ![response isKindOfClass:GuildHallGroupCreateResponse.class]) {
            response = nil;
        }
        
        NotifyCoreClient(GuildCoreClient, @selector(responseGuildGroupCreate:errorCode:msg:), responseGuildGroupCreate:response errorCode:code msg:msg);
    }];
}

/**
 解散群聊
 
 @param chatId 群聊id
 */
- (void)requestGuildGroupRemoveWithChatId:(NSString *)chatId {
    [HttpRequestHelper requestGuildGroupRemoveWithChatId:chatId completion:^(id  _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg) {
        
        BOOL isSuccess = code == nil && msg == nil;
        NotifyCoreClient(GuildCoreClient, @selector(responseGuildGroupRemove:errorCode:msg:), responseGuildGroupRemove:isSuccess errorCode:code msg:msg);
    }];
}

/**
 离开群聊
 
 @param chatId 群聊id
 */
- (void)requestGuildGroupQuitWithChatId:(NSString *)chatId {
    [HttpRequestHelper requestGuildGroupQuitWithChatId:chatId completion:^(id  _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg) {
        
        BOOL isSuccess = code == nil && msg == nil;
        NotifyCoreClient(GuildCoreClient, @selector(responseGuildGroupQuit:errorCode:msg:), responseGuildGroupQuit:isSuccess errorCode:code msg:msg);
    }];
}

/**
 获取群聊资料
 
 @param tid 云信群聊id
 */
- (void)requestGuildGroupInfoFetchWithTid:(NSString *)tid {
    [HttpRequestHelper requestGuildGroupInfoFetchWithTid:tid completion:^(id  _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg) {
        
        GuildHallGroupInfo *model = [GuildHallGroupInfo yy_modelWithJSON:data];
        if (data == nil || ![model isKindOfClass:GuildHallGroupInfo.class]) {
            model = nil;
        }
        
        NotifyCoreClient(GuildCoreClient, @selector(responseGuildGroupInfoFetch:errorCode:msg:), responseGuildGroupInfoFetch:model errorCode:code msg:msg);
    }];
}

/**
 更新群聊资料
 
 @param chatId 群聊id
 @param icon 头像
 @param name 名称
 @param notice 公告
 */
- (void)requestGuildGroupInfoUpdateWithChatId:(NSString *)chatId
                                             icon:(nullable NSString *)icon
                                             name:(nullable NSString *)name
                                           notice:(nullable NSString *)notice {
    [HttpRequestHelper requestGuildGroupInfoUpdateWithChatId:chatId icon:icon name:name notice:notice completion:^(id  _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg) {
        
        BOOL isSuccess = code == nil && msg == nil;
        NotifyCoreClient(GuildCoreClient, @selector(responseGuildGroupInfoUpdate:errorCode:msg:), responseGuildGroupInfoUpdate:isSuccess errorCode:code msg:msg);
    }];
}

/**
 根据 Uid 获取模厅公告菜单
 
 @param uid 用户uid
 */
- (void)requestGuildHallMenusWithUid:(NSString *)uid {
    [HttpRequestHelper requestGuildHallMenusWithUid:uid completion:^(id  _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg) {
        NSArray *list = [NSArray yy_modelArrayWithClass:GuildHallMenu.class json:data];
        NotifyCoreClient(GuildCoreClient, @selector(responseGuildHallMenusList:errorCode:msg:), responseGuildHallMenusList:list errorCode:code msg:msg);
    }];
}

/**
 获取高管权限列表
 
 @param uid 用户 uid
 @param roleType 权限类型 1表示厅主,2高管,3普通成员
 */
- (void)requestGuildHallGetHallAuthsWithUid:(NSString *)uid
                                   roleType:(NSString *)roleType {
 
    [HttpRequestHelper requestGuildHallAuthListWithUid:uid roleType:roleType completion:^(id  _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg) {
        NSArray *list = [NSArray yy_modelArrayWithClass:GuildHallManagerInfo.class json:data];
        NotifyCoreClient(GuildCoreClient, @selector(responseGuildHallGetManagerAuthList:errorCode:msg:), responseGuildHallGetManagerAuthList:list errorCode:code msg:msg);
    }];
}


/**
 申请加入模厅
 
 @param uid 用户 uid
 @param hallId 要加入的模厅 id
 */
- (void)requestGuildHallJoinHallWithUid:(NSString *)uid
                                 hallId:(NSString *)hallId {
    [HttpRequestHelper requestGuildHallJoinWithUid:uid hallId:hallId completion:^(id  _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg) {
        BOOL isSuccess = code == nil && msg == nil;
        NotifyCoreClient(GuildCoreClient, @selector(responseGuildHallJoinHall:errorCode:msg:), responseGuildHallJoinHall:isSuccess errorCode:code msg:msg);
    }];
}


/**
 厅主/高管 审核加入申请
 
 @param path 请求路径
 @param recordId 记录 id
 @param type 操作类型：0拒绝 1同意
 */
- (void)requestGuildAuditApplyHallWithPath:(NSString *)path
                             recordId:(NSString *)recordId
                                 type:(NSInteger)type {
    [HttpRequestHelper requestGuildHallDealApplyWithPath:path recordId:recordId type:type completion:^(id  _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg) {
        NotifyCoreClient(GuildCoreClient, @selector(responseGuildHallDealApply:errorCode:msg:), responseGuildHallDealApply:data errorCode:code msg:msg);
    }];
}

/**
 厅主/高管 同意退出申请

 @param path 请求路径
 @param recordId 记录 id
 */
- (void)requestGuildAuditQuitHallWithPath:(NSString *)path
                                 recordId:(NSString *)recordId {
    [HttpRequestHelper requestGuildAuditQuitHallWithPath:path recordId:recordId completion:^(id  _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg) {
        NotifyCoreClient(GuildCoreClient, @selector(responseGuildDealAuditQuit:errorCode:msg:), responseGuildDealAuditQuit:data errorCode:code msg:msg);
    }];
}

/**
 普通成员 处理入厅邀请
 
 @param path 请求路径
 @param recordId 记录 id
 @param type 操作类型：0拒绝 1同意
 */
- (void)requestGuildDealInviteHallWithPath:(NSString *)path
                                  recordId:(NSString *)recordId
                                      type:(NSInteger)type {
    [HttpRequestHelper requestGuildDealInviteHallWithPath:path recordId:recordId type:type completion:^(id  _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg) {
        NotifyCoreClient(GuildCoreClient, @selector(responseGuildDealHallInvite:errorCode:msg:), responseGuildDealHallInvite:data errorCode:code msg:msg);
    }];
}

/**
 获取模厅所有成员列表
 
 @param hallId 公会模厅id
 @param page page 页码
 @param pageSize pageSize 每页数量
 */
- (void)requestGuildHallAllMembersListByHallId:(NSString *)hallId
                                          page:(NSInteger)page
                                      pageSize:(NSInteger)pageSize {
    [HttpRequestHelper requestGuildHallAllMemberListByHallId:hallId page:page pageSize:pageSize completion:^(id  _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg) {
        NSArray *array = [NSArray yy_modelArrayWithClass:UserInfo.class json:data[@"members"]];
        NSString *count = data[@"count"];
        NotifyCoreClient(GuildCoreClient, @selector(responseGuildHallAllMembersList:count:errorCode:msg:), responseGuildHallAllMembersList:array count:count errorCode:code msg:msg);
    }];
}


/**
 获取模厅所有管理员列表
 
 @param hallId 公会模厅id
 @param page page 页码
 @param pageSize pageSize 每页数量
 */
- (void)requestGuildHallAllManagersListByHallId:(NSString *)hallId
                                           page:(NSInteger)page
                                       pageSize:(NSInteger)pageSize {
    
    [HttpRequestHelper requestGuildHallAllManagerListByHallId:hallId page:page pageSize:pageSize completion:^(id  _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg) {
        NSArray *array = [NSArray yy_modelArrayWithClass:UserInfo.class json:data[@"members"]];
        NotifyCoreClient(GuildCoreClient, @selector(responseGuildHallAllManagersList:errorCode:msg:), responseGuildHallAllManagersList:array errorCode:code msg:msg);
    }];
}

/**
 获取模厅群聊列表
 
 @param hallId 模厅id
 @param type 1:公开群，2：内部群， 空查全部
 */
- (void)requestGuildGroupListWithHallId:(NSString *)hallId groupType:(nullable NSString *)type {
    
    [HttpRequestHelper requestGuildGroupListWithHallId:hallId groupType:type completion:^(id  _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg) {
        
        NSArray *list = [NSArray yy_modelArrayWithClass:GuildHallGroupListItem.class json:data];
        if (code == nil && msg == nil && list == nil) {
            list = @[];
        }
        
        NotifyCoreClient(GuildCoreClient, @selector(responseGuildGroupList:errorCode:msg:), responseGuildGroupList:list errorCode:code msg:msg);
    }];
}


/**
 设置高管

 @param hallId 模厅 id
 @param targetUid 被设置的高管 uid
 */
- (void)requestGuildHallSetManagerByHallId:(NSString *)hallId targetUid:(NSString *)targetUid {
    [HttpRequestHelper requestGuildHallSetManagerByHallId:hallId targetUid:targetUid completion:^(id  _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg) {
        BOOL isSuccess = code == nil && msg == nil;
        NotifyCoreClient(GuildCoreClient, @selector(responseGuildHallSetManagerSuccess:errorCode:msg:), responseGuildHallSetManagerSuccess:isSuccess errorCode:code msg:msg);
    }];
}

/**
 取消高管
 
 @param hallId  模厅公会id
 @param targetUid  被取消的高管 Uid
 */
- (void)requestGuildHallRemoveManagerByHallId:(NSString *)hallId
                                    targetUid:(NSString *)targetUid {
    [HttpRequestHelper requestGuildHallRemoveManagerByHallId:hallId targetUid:targetUid completion:^(id  _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg) {
        BOOL isSuccess = code == nil && msg == nil;
        NotifyCoreClient(GuildCoreClient, @selector(responseGuildHallRemoveManagerSuccess:errorCode:msg:), responseGuildHallRemoveManagerSuccess:isSuccess errorCode:code msg:msg);
    }];
}

/**
 获取高管权限列表
 
 @param uid 厅主 id
 @param managerUid 被查询的管理员 id
 */
- (void)requestGuildhallManagerAuthsListByUid:(NSString *)uid
                                   managerUid:(NSString *)managerUid {
    [HttpRequestHelper requestGuildHallGetManagerAuthWithUid:uid managerUid:managerUid completion:^(id  _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg) {
        NSArray *array = [NSArray yy_modelArrayWithClass:GuildHallManagerInfo.class json:data];
        NotifyCoreClient(GuildCoreClient, @selector(responseGuildHallManagerInfoList:errorCode:msg:), responseGuildHallManagerInfoList:array errorCode:code msg:msg);
    }];
}

/**
 设置高管权限
 
 @param uid 厅主 uid
 @param managerUid 管理员 id
 @param hallId 模厅 id
 @param authStr 权限列表
 */
- (void)requestGuildsetHallManagerAuthsWithUid:(NSString *)uid
                                    managerUid:(NSString *)managerUid
                                        hallId:(NSString *)hallId
                                       authStr:(NSString *)authStr {
    [HttpRequestHelper requestGuildHallSetManagerAuthWithUid:uid managerUid:managerUid hallID:hallId authStr:authStr completion:^(id  _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg) {
        BOOL isSuccess = code == nil && msg == nil;
        NotifyCoreClient(GuildCoreClient, @selector(responseGuildHallSetManagerAuthSuccess:errorCode:msg:), responseGuildHallSetManagerAuthSuccess:isSuccess errorCode:code msg:msg);
    }];
}
     
/**
 打开/关闭群聊消息提醒
 
 @param chatId 群聊id
 @param isMute 操作参数 true:开启免打扰 false:关闭免打扰
 */
- (void)requestGuildGroupPromptSettingWithChatId:(NSString *)chatId
                                    promptStatus:(BOOL)isMute {
    [HttpRequestHelper requestGuildGroupPromptSettingWithChatId:chatId promptStatus:isMute completion:^(id  _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg) {
        BOOL isSuccess = code == nil && msg == nil;
        NotifyCoreClient(GuildCoreClient, @selector(responseGuildGroupPromptSetting:errorCode:msg:), responseGuildGroupPromptSetting:isSuccess errorCode:code msg:msg);
    }];
}

/**
 收入统计
 
 @param hallId 模厅id
 @param startTimeStr 开始时间(有格式要求) 2019-01-07
 @param endTimeStr 结束时间(按日统计,结束时间要为空,有格式要求) 2019-01-13
 */
- (void)requestGuildIncomeTotalWithHallId:(NSString *)hallId
                             startTimeStr:(NSString *)startTimeStr
                               endTimeStr:(nullable NSString *)endTimeStr {
    [HttpRequestHelper requestGuildIncomeTotalWithHallId:hallId startTimeStr:startTimeStr endTimeStr:endTimeStr completion:^(id  _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg) {
        
        GuildIncomeTotal *model = [GuildIncomeTotal yy_modelWithJSON:data];
        if (endTimeStr==nil || endTimeStr.length==0) {
            NotifyCoreClient(GuildCoreClient, @selector(responseGuildIncomeDailyTotal:errorCode:msg:), responseGuildIncomeDailyTotal:model errorCode:code msg:msg);
        } else {
            NotifyCoreClient(GuildCoreClient, @selector(responseGuildIncomeWeeklyTotal:errorCode:msg:), responseGuildIncomeWeeklyTotal:model errorCode:code msg:msg);
        }
    }];
}

/**
 收入明细
 
 @param hallId 模厅id
 @param memberId 模厅成员id
 @param startTimeStr 开始时间(有格式要求) 2019-01-07
 @param endTimeStr 结束时间(按日统计,结束时间要为空,有格式要求) 2019-01-13
 */
- (void)requestGuildIncomeDetailWithHallId:(NSString *)hallId
                                  memberId:(NSString *)memberId
                              startTimeStr:(NSString *)startTimeStr
                                endTimeStr:(NSString *)endTimeStr {
    [HttpRequestHelper requestGuildIncomeDetailWithHallId:hallId memberId:memberId startTimeStr:startTimeStr endTimeStr:endTimeStr completion:^(id  _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg) {
        NSArray *list = [NSArray yy_modelArrayWithClass:GuildIncomeDetail.class json:data];
        NotifyCoreClient(GuildCoreClient, @selector(responseGuildIncomeDetailList:errorCode:msg:), responseGuildIncomeDetailList:list errorCode:code msg:msg)
    }];
}

/**
 获取厅主模厅信息
 
 @param targetUid 目标用户uid
 */
- (void)requestGuildHallInfoWithOwnUid:(NSString *)targetUid {
    [HttpRequestHelper requestGuildHallInfoWithOwnUid:targetUid completion:^(id  _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg) {
        
        GuildOwnerHallInfo *model = [GuildOwnerHallInfo yy_modelWithJSON:data];
        NotifyCoreClient(GuildCoreClient, @selector(responseGuildOwnerHallInfo:errorCode:msg:), responseGuildOwnerHallInfo:model errorCode:code msg:msg)
    }];
}

/**
 主动加入群聊
 
 @param chatId 群聊id
 */
- (void)requestGuildGroupJoinWithChatId:(NSString *)chatId {
    [HttpRequestHelper requestGuildGroupJoinWithChatId:chatId completion:^(id  _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg) {
        BOOL isSuccess = code == nil && msg == nil;
        NotifyCoreClient(GuildCoreClient, @selector(responseGuildGroupJoin:errorCode:msg:), responseGuildGroupJoin:isSuccess errorCode:code msg:msg);
    }];
}

/**
 添加模厅权限(此接口待完善)
 
 @param authType authType
 */
- (void)requestGuildAuthAddWithType:(NSString *)authType {
    [HttpRequestHelper requestGuildAuthAddWithType:authType completion:^(id  _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg) {
        BOOL isSuccess = code == nil && msg == nil;
        NotifyCoreClient(GuildCoreClient, @selector(responseGuildAuthAdd:errorCode:msg:), responseGuildAuthAdd:isSuccess errorCode:code msg:msg);
    }];
}

/**
 获取不在指定群聊里面的模厅成员
 
 @param chatId 群聊id
 @param page 页码
 @param pageSize 页容量
 */
- (void)requestGuildMemberListWhichNotInGroupWithChatId:(NSString *)chatId
                                                   page:(NSInteger)page
                                               pageSize:(NSInteger)pageSize {
    [HttpRequestHelper requestGuildMemberListWhichNotInGroupWithChatId:chatId page:page pageSize:pageSize completion:^(id  _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg) {
        
        NSArray *list = [NSArray yy_modelArrayWithClass:UserInfo.class json:data[@"members"]];
        NotifyCoreClient(GuildCoreClient, @selector(responseGuildNotInGroupMembers:errorCode:msg:), responseGuildNotInGroupMembers:list errorCode:code msg:msg)
    }];
}

/**
 获取群聊所有成员列表
 
 @param chatId 群聊id
 @param page 页码
 @param pageSize 页容量
 */
- (void)requestGuildGroupAllMembersWithChatId:(NSString *)chatId
                                   page:(NSInteger)page
                                     pageSize:(NSInteger)pageSize {
    [HttpRequestHelper requestGuildGroupAllMembersWithChatId:chatId page:page pageSize:pageSize completion:^(id  _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg) {
        GuildChatGroupAllMemberResponse *response = [GuildChatGroupAllMemberResponse yy_modelWithJSON:data];
        NSArray *list = [NSArray yy_modelArrayWithClass:UserInfo.class json:data[@"members"]];
        NotifyCoreClient(GuildCoreClient, @selector(responseGuildGroupAllMembers:data:errorCode:msg:), responseGuildGroupAllMembers:list data:response errorCode:code msg:msg)
    }];
}

/**
 禁言/解禁群聊成员
 
 @param chatId 群聊id
 @param targetUid 目标用户uid
 @param isMute 操作参数 true:禁言 false:解禁
 */
- (void)requestGuildGroupBanWithChatId:(NSString *)chatId
                             targetUid:(NSString *)targetUid
                                isMute:(BOOL)isMute {
    [HttpRequestHelper requestGuildGroupBanWithChatId:chatId targetUid:targetUid isMute:isMute completion:^(id  _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg) {
        BOOL isSuccess = code == nil && msg == nil;
        NotifyCoreClient(GuildCoreClient, @selector(responseGuildGroupBan:errorCode:msg:), responseGuildGroupBan:isSuccess errorCode:code msg:msg);
    }];
}

/**
 踢出群聊成员
 
 @param chatId 群聊id
 @param targetUids 目标用户uid,用逗号拼接
 */
- (void)requestGuildGroupKickWithChatId:(NSString *)chatId
                             targetUids:(NSString *)targetUids {
    [HttpRequestHelper requestGuildGroupKickWithChatId:chatId targetUids:targetUids completion:^(id  _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg) {
        BOOL isSuccess = code == nil && msg == nil;
        NotifyCoreClient(GuildCoreClient, @selector(responseGuildGroupKick:errorCode:msg:), responseGuildGroupKick:isSuccess errorCode:code msg:msg);
    }];
}

/**
 按条件搜索成员
 
 @param hallId 模厅id
 @param key 关键字
 */
- (void)requestGuildSearchMembersWithHallId:(NSString *)hallId
                                        key:(NSString *)key {
    [HttpRequestHelper requestGuildSearchMembersWithHallId:hallId key:key completion:^(id  _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg) {
        
        NSArray *list = [NSArray yy_modelArrayWithClass:SearchResultInfo.class json:data[@"members"]];
        NotifyCoreClient(GuildCoreClient, @selector(responseGuildHallSearchMembers:errorCode:msg:), responseGuildHallSearchMembers:list errorCode:code msg:msg)
    }];
}

/**
 加入群聊
 
 @param chatId 群聊id
 @param targetUids 目标用户uid,用逗号拼接
 */
- (void)requestGuildGroupAddMembersWithChatId:(NSString *)chatId
                                   targetUids:(NSString *)targetUids {
    [HttpRequestHelper requestGuildGroupAddMembersWithChatId:chatId targetUids:targetUids completion:^(id  _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg) {
        
        BOOL isSuccess = code == nil && msg == nil;
        NotifyCoreClient(GuildCoreClient, @selector(responseGuildGroupAddMembers:errorCode:msg:), responseGuildGroupAddMembers:isSuccess errorCode:code msg:msg);
    }];
}

/**
 取消群聊管理
 
 @param chatId 群聊id
 @param targetUid 目标用户uid
 */
- (void)requestGuildGroupCancelManagerWithChatId:(NSString *)chatId
                                       targetUid:(NSString *)targetUid {
    [HttpRequestHelper requestGuildGroupCancelManagerWithChatId:chatId targetUid:targetUid completion:^(id  _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg) {
        
        BOOL isSuccess = code == nil && msg == nil;
        NotifyCoreClient(GuildCoreClient, @selector(responseGuildGroupCancelManager:errorCode:msg:), responseGuildGroupCancelManager:isSuccess errorCode:code msg:msg);
    }];
}

/**
 设置群聊管理
 
 @param chatId 群聊id
 @param targetUid 目标用户uid
 */
- (void)requestGuildGroupSetManagerWithChatId:(NSString *)chatId
                                    targetUid:(NSString *)targetUid {
    [HttpRequestHelper requestGuildGroupSetManagerWithChatId:chatId targetUid:targetUid completion:^(id  _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg) {
        
        BOOL isSuccess = code == nil && msg == nil;
        NotifyCoreClient(GuildCoreClient, @selector(responseGuildGroupSetManager:errorCode:msg:), responseGuildGroupSetManager:isSuccess errorCode:code msg:msg);
    }];
}

/**
 获取群聊数量限制配置
 */
- (void)requestGuildGroupInfoLimit {
    [HttpRequestHelper requestGuildGroupInfoLimitWithCompletion:^(id  _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg) {
        
        GuildGroupInfoLimit *model = [GuildGroupInfoLimit yy_modelWithJSON:data];
        NotifyCoreClient(GuildCoreClient, @selector(responseGuildGroupInfoLimit:errorCode:msg:), responseGuildGroupInfoLimit:model errorCode:code msg:msg)
    }];
}

/**
 移出模厅
 
 @param targetUid 目标用户uid
 */
- (void)requestGuildHallKickWithTargetUid:(NSString *)targetUid {
    [HttpRequestHelper requestGuildHallKickWithTargetUid:targetUid completion:^(id  _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg) {
        
        BOOL isSuccess = code == nil && msg == nil;
        NotifyCoreClient(GuildCoreClient, @selector(responseGuildHallKick:errorCode:msg:), responseGuildHallKick:isSuccess errorCode:code msg:msg);
    }];
}

/**
 申请退出模厅
 */
- (void)requestGuildHallQuit {
    [HttpRequestHelper requestGuildHallQuitWithCompletion:^(id  _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg) {
        
        BOOL isSuccess = code == nil && msg == nil;
        NotifyCoreClient(GuildCoreClient, @selector(responseGuildHallQuit:errorCode:msg:), responseGuildHallQuit:isSuccess errorCode:code msg:msg);
    }];
}

/**
 邀请加入模厅
 
 @param targetUid 目标用户uid
 */
- (void)requestGuildHallInviteWithTargetUid:(NSString *)targetUid {
    [HttpRequestHelper requestGuildHallInviteWithTargetUid:targetUid completion:^(id  _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg) {
        
        BOOL isSuccess = code == nil && msg == nil;
        NotifyCoreClient(GuildCoreClient, @selector(responseGuildHallInvite:errorCode:msg:), responseGuildHallInvite:isSuccess errorCode:code msg:msg);
    }];
}

/**
 获取公会emoji 暗号邀请码
 */
- (void)requestGuildEmojiCode {
    [HttpRequestHelper requestGuildEmojiCodeCompletion:^(id  _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg) {
        GuildEmojiCode *model = [GuildEmojiCode yy_modelWithJSON:data];
        NotifyCoreClient(GuildCoreClient, @selector(responseGuildEmojiCode:errorCode:msg:), responseGuildEmojiCode:model errorCode:code msg:msg);
    }];
}

/**
 通过emoji暗号邀请码加入模厅
 
 @param emojiCode 暗号邀请码
 */
- (void)requestGuildJoinByEmojiCode:(NSString *)emojiCode {
    [HttpRequestHelper requestGuildJoinByEmojiCode:emojiCode completion:^(id  _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg) {
        BOOL isSuccess = code == nil && msg == nil;
        NotifyCoreClient(GuildCoreClient, @selector(responseGuildJoinByEmojiCode:errorCode:msg:), responseGuildJoinByEmojiCode:isSuccess errorCode:code msg:msg);
    }];
}

/**
 校验 emoji 暗号邀请码
 
 @param emojiCode emoji 暗号邀请码
 */
- (void)requestGuildCheckEmojiCode:(NSString *)emojiCode {
    [HttpRequestHelper requestGuildCheckEmojiCode:emojiCode completion:^(id  _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg) {
        GuildCheckEmojiCode *model = [GuildCheckEmojiCode yy_modelWithJSON:data];
        NotifyCoreClient(GuildCoreClient, @selector(responseGuildCheckEmojiCode:errorCode:msg:), responseGuildCheckEmojiCode:model errorCode:code msg:msg);
    }];
}

@end
     
