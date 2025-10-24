//
//  GuildCoreClient.h
//  XCChatCoreKit
//
//  Created by lvjunhang on 2019/1/7.
//  Copyright © 2019年 KevinWang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GuildHallGroupInfo.h"
#import "GuildHallGroupCreateResponse.h"
#import "GuildHallInfo.h"
#import "GuildHallGroupListItem.h"
#import "GuildIncomeTotal.h"
#import "GuildIncomeDetail.h"
#import "GuildOwnerHallInfo.h"
#import "UserInfo.h"
#import "GuildGroupInfoLimit.h"
#import "GuildHallManagerInfo.h"
#import "GuildChatGroupAllMemberResponse.h"
#import "SearchResultInfo.h"
#import "GuildHallMenu.h"
// 暗号邀请码
#import "GuildEmojiCode.h"
#import "GuildCheckEmojiCode.h"


@protocol GuildCoreClient <NSObject>
@optional

/**
 更新模厅名响应

 @param isSuccess 是否成功，出现错误时通过 code 和 msg 返回
 @param code 错误码
 @param msg 错误信息
 */
- (void)responseGuildHallNameUpdate:(BOOL)isSuccess errorCode:(NSNumber *)code msg:(NSString *)msg;

/**
 获取模厅信息
 
 @param data 模厅信息
 @param code 错误码
 @param msg 错误信息
 */
- (void)responseGuildHallInfoFetch:(GuildHallInfo *)data errorCode:(NSNumber *)code msg:(NSString *)msg;

/**
 创建群聊
 
 @param data 创建成功返回数据
 @param code 错误码
 @param msg 错误信息
 */
- (void)responseGuildGroupCreate:(GuildHallGroupCreateResponse *)data errorCode:(NSNumber *)code msg:(NSString *)msg;

/**
 解散群聊
 
 @param isSuccess 是否成功，出现错误时通过 code 和 msg 返回
 @param code 错误码
 @param msg 错误信息
 */
- (void)responseGuildGroupRemove:(BOOL)isSuccess errorCode:(NSNumber *)code msg:(NSString *)msg;

/**
 离开群聊
 
 @param isSuccess 是否成功，出现错误时通过 code 和 msg 返回
 @param code 错误码
 @param msg 错误信息
 */
- (void)responseGuildGroupQuit:(BOOL)isSuccess errorCode:(NSNumber *)code msg:(NSString *)msg;

/**
 获取群聊资料
 
 @param data 群聊资料
 @param code 错误码
 @param msg 错误信息
 */
- (void)responseGuildGroupInfoFetch:(GuildHallGroupInfo *)data errorCode:(NSNumber *)code msg:(NSString *)msg;

/**
 更新群聊资料
 
 @param isSuccess 是否成功，出现错误时通过 code 和 msg 返回
 @param code 错误码
 @param msg 错误信息
 */
- (void)responseGuildGroupInfoUpdate:(BOOL)isSuccess errorCode:(NSNumber *)code msg:(NSString *)msg;

/**
 获取模厅公告

 @param list 数据源
 @param code 错误码
 @param msg 错误信息
 */
- (void)responseGuildHallMenusList:(NSArray<GuildHallMenu *> *)list errorCode:(NSNumber *)code msg:(NSString *)msg;

/**
 申请加入模厅

 @param success 是否成功，出现错误时通过 code 和 msg 返回
 @param code 错误码
 @param msg 错误信息
 */
- (void)responseGuildHallJoinHall:(BOOL)success errorCode:(NSNumber *)code msg:(NSString *)msg;

/**
 厅主/高管 审核加入申请

 @param data 操作成功时为 nil，出现错误时返回 code 和 msg 返回，注意和外层 code msg 是不同的
 code: 90121：消息已过期 / 90122：消息已处理
 
 @param code 错误码
 @param msg 错误信息
 */
- (void)responseGuildHallDealApply:(NSDictionary *)data errorCode:(NSNumber *)code msg:(NSString *)msg;

/**
 厅主/高管 同意退出申请
 
 @param data 操作成功时为 nil，出现错误时返回 code 和 msg 返回，注意和外层 code msg 是不同的
 code: 90121：消息已过期 / 90122：消息已处理
 
 @param code 错误码
 @param msg 错误信息
 */
- (void)responseGuildDealAuditQuit:(NSDictionary *)data errorCode:(NSNumber *)code msg:(NSString *)msg;

/**
 普通成员 处理入厅邀请
 
 @param data 操作成功时为 nil，出现错误时返回 code 和 msg 返回，注意和外层 code msg 是不同的
 code: 90121：消息已过期 / 90122：消息已处理
 
 @param code 错误码
 @param msg 错误信息
 */
- (void)responseGuildDealHallInvite:(NSDictionary *)data errorCode:(NSNumber *)code msg:(NSString *)msg;

/**
 获取模厅群聊列表
 
 @param data 群聊列表
 @param code 错误码
 @param msg 错误信息
 */
- (void)responseGuildGroupList:(NSArray<GuildHallGroupListItem *> *)data errorCode:(NSNumber *)code msg:(NSString *)msg;


/**
  获取模厅所有成员列表

 @param list 成员列表
 @param count 成员数量
 @param code 错误码
 @param msg 错误信息
 */
- (void)responseGuildHallAllMembersList:(NSArray *)list count:(NSString *)count errorCode:(NSNumber *)code msg:(NSString *)msg;

/**
 获取模厅所有管理员列表
 
 @param list 管理员列表
 @param code 错误码
 @param msg 错误信息
 */
- (void)responseGuildHallAllManagersList:(NSArray *)list errorCode:(NSNumber *)code msg:(NSString *)msg;

/**
 设置模厅高管

@param isSuccess 成功
 @param code 错误码
 @param msg 错误消息
 */
- (void)responseGuildHallSetManagerSuccess:(BOOL)isSuccess errorCode:(NSNumber *)code msg:(NSString *)msg;

/**
 设置模厅高管
 
 @param isSuccess 成功
 @param code 错误码
 @param msg 错误消息
 */
- (void)responseGuildHallRemoveManagerSuccess:(BOOL)isSuccess errorCode:(NSNumber *)code msg:(NSString *)msg;

/**
 获取高管权限列表

 @param list 权限列表
 @param code 错误码
 @param msg 错误消息
 */
- (void)responseGuildHallManagerInfoList:(NSArray *)list errorCode:(NSNumber *)code msg:(NSString *)msg;

/**
 设置高管权限

 @param isSuccess 成功
 @param code 错误码
 @param msg 错误信息
 */
- (void)responseGuildHallSetManagerAuthSuccess:(BOOL)isSuccess errorCode:(NSNumber *)code msg:(NSString *)msg;

/**
 打开/关闭群聊消息提醒
 
 @param isSuccess 成功
 @param code 错误码
 @param msg 错误消息
 */
- (void)responseGuildGroupPromptSetting:(BOOL)isSuccess errorCode:(NSNumber *)code msg:(NSString *)msg;

/**
 收入统计 日
 
 @param data 统计信息
 @param code 错误码
 @param msg 错误消息
 */
- (void)responseGuildIncomeDailyTotal:(GuildIncomeTotal *)data errorCode:(NSNumber *)code msg:(NSString *)msg;

/**
 收入统计 周
 
 @param data 统计信息
 @param code 错误码
 @param msg 错误消息
 */
- (void)responseGuildIncomeWeeklyTotal:(GuildIncomeTotal *)data errorCode:(NSNumber *)code msg:(NSString *)msg;

/**
 收入明细
 
 @param list 明细
 @param code 错误码
 @param msg 错误消息
 */
- (void)responseGuildIncomeDetailList:(NSArray<GuildIncomeDetail *> *)list errorCode:(NSNumber *)code msg:(NSString *)msg;

/**
 获取厅主模厅信息

 @param data 厅主模厅信息
 @param code 错误码
 @param msg 错误消息
 */
- (void)responseGuildOwnerHallInfo:(GuildOwnerHallInfo *)data errorCode:(NSNumber *)code msg:(NSString *)msg;

/**
 主动加入群聊

 @param isSuccess 成功
 @param code 错误码
 @param msg 错误消息
 */
- (void)responseGuildGroupJoin:(BOOL)isSuccess errorCode:(NSNumber *)code msg:(NSString *)msg;

/**
 添加模厅权限
 
 @param isSuccess 成功
 @param code 错误码
 @param msg 错误消息
 */
- (void)responseGuildAuthAdd:(BOOL)isSuccess errorCode:(NSNumber *)code msg:(NSString *)msg;

/**
 获取不在指定群聊里面的模厅成员

 @param data 模厅成员列表
 @param code 错误码
 @param msg 错误消息
 */
- (void)responseGuildNotInGroupMembers:(NSArray<UserInfo *> *)data errorCode:(NSNumber *)code msg:(NSString *)msg;

/**
 获取群聊所有成员列表

 @param list 群聊所有成员列表
 @param code 错误码
 @param msg 错误消息
 */

/**
 获取群聊所有成员列表

 @param list 群聊所有成员列表
 @param data 完整的data
 @param code 错误码
 @param msg 错误消息
 */
- (void)responseGuildGroupAllMembers:(NSArray<UserInfo *> *)list data:(GuildChatGroupAllMemberResponse *)data errorCode:(NSNumber *)code msg:(NSString *)msg;

/**
 禁言/解禁群聊成员

 @param isSuccess 成功
 @param code 错误码
 @param msg 错误消息
 */
- (void)responseGuildGroupBan:(BOOL)isSuccess errorCode:(NSNumber *)code msg:(NSString *)msg;

/**
 踢出群聊成员

 @param isSuccess 成功
 @param code 错误码
 @param msg 错误消息
 */
- (void)responseGuildGroupKick:(BOOL)isSuccess errorCode:(NSNumber *)code msg:(NSString *)msg;

/**
 按条件搜索成员

 @param data 群聊所有成员列表
 @param code 错误码
 @param msg 错误消息
 */
- (void)responseGuildHallSearchMembers:(NSArray<SearchResultInfo *> *)data errorCode:(NSNumber *)code msg:(NSString *)msg;

/**
 加入群聊

 @param isSuccess 成功
 @param code 错误码
 @param msg 错误消息
 */
- (void)responseGuildGroupAddMembers:(BOOL)isSuccess errorCode:(NSNumber *)code msg:(NSString *)msg;

/**
 取消群聊管理

 @param isSuccess 成功
 @param code 错误码
 @param msg 错误消息
 */
- (void)responseGuildGroupCancelManager:(BOOL)isSuccess errorCode:(NSNumber *)code msg:(NSString *)msg;

/**
 设置群聊管理
 
 @param isSuccess 成功
 @param code 错误码
 @param msg 错误消息
 */
- (void)responseGuildGroupSetManager:(BOOL)isSuccess errorCode:(NSNumber *)code msg:(NSString *)msg;

/**
 获取群聊数量限制配置

 @param data 配置信息
 @param code 错误码
 @param msg 错误消息
 */
- (void)responseGuildGroupInfoLimit:(GuildGroupInfoLimit *)data errorCode:(NSNumber *)code msg:(NSString *)msg;

/**
 移出模厅

 @param isSuccess 成功
 @param code 错误码
 @param msg 错误消息
 */
- (void)responseGuildHallKick:(BOOL)isSuccess errorCode:(NSNumber *)code msg:(NSString *)msg;

/**
 申请退出模厅

 @param isSuccess 成功
 @param code 错误码
 @param msg 错误消息
 */
- (void)responseGuildHallQuit:(BOOL)isSuccess errorCode:(NSNumber *)code msg:(NSString *)msg;

/**
 邀请加入模厅

 @param isSuccess 成功
 @param code 错误码
 @param msg 错误消息
 */
- (void)responseGuildHallInvite:(BOOL)isSuccess errorCode:(NSNumber *)code msg:(NSString *)msg;

/**
 查询模厅权限列表

 @param list 权限列表
 @param code 错误码
 @param msg 错误消息
 */
- (void)responseGuildHallGetManagerAuthList:(NSArray<GuildHallManagerInfo *> *)list errorCode:(NSNumber *)code msg:(NSString *)msg;

/**
 获取公会emoji 暗号邀请码
 @param emojiCodo 暗号邀请码model
 @param code 错误码
 @param msg 错误消息
 */
- (void)responseGuildEmojiCode:(GuildEmojiCode *)emojiCodo errorCode:(NSNumber *)code msg:(NSString *)msg;

/**
  校验 emoji 暗号邀请码

 @param guildCheckEmojiCode  校验暗号邀请码model
 @param code 错误码
 @param msg 错误消息
 */
- (void)responseGuildCheckEmojiCode:(GuildCheckEmojiCode *)guildCheckEmojiCode errorCode:(NSNumber *)code msg:(NSString *)msg;

/**
 通过emoji暗号邀请码加入模厅

 @param isSuccess 加入公会模厅成功
 @param code 错误码
 @param msg 错误消息
 */
- (void)responseGuildJoinByEmojiCode:(BOOL)isSuccess errorCode:(NSNumber *)code msg:(NSString *)msg;

@end

