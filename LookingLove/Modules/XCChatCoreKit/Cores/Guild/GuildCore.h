//
//  GuildCore.h
//  XCChatCoreKit
//
//  Created by lvjunhang on 2019/1/7.
//  Copyright © 2019年 KevinWang. All rights reserved.
//

#import "BaseCore.h"
#import "GuildHallInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface GuildCore : BaseCore

@property (nonatomic, strong) GuildHallInfo *hallInfo;

/**
 更新模厅名
 
 @param hallName 模厅名称
 */
- (void)requestGuildUpdateHallName:(NSString *)hallName;

/**
 获取模厅信息
 
 @param hallId 模厅id
 */
- (void)requestGuildHallInfoFetchWithHallId:(NSString *)hallId uid:(NSString *)uid;

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
                                      members:(NSString *)members;

/**
 解散群聊
 
 @param chatId 群聊id
 */
- (void)requestGuildGroupRemoveWithChatId:(NSString *)chatId;

/**
 离开群聊
 
 @param chatId 群聊id
 */
- (void)requestGuildGroupQuitWithChatId:(NSString *)chatId;

/**
 获取群聊资料
 
 @param tid 云信群聊id
 */
- (void)requestGuildGroupInfoFetchWithTid:(NSString *)tid;

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
                                       notice:(nullable NSString *)notice;


/**
 根据 Uid 获取模厅公告菜单

 @param uid 用户uid
 */
- (void)requestGuildHallMenusWithUid:(NSString *)uid;

/**
 获取高管权限列表
 
 @param uid 用户 uid
 @param roleType 权限类型 1表示厅主,2高管,3普通成员
 */
- (void)requestGuildHallGetHallAuthsWithUid:(NSString *)uid
                                   roleType:(NSString *)roleType;

/**
 申请加入模厅
 获取模厅群聊列表
 
 @param hallId 模厅id
 @param type 1:公开群，2：内部群， 空查全部
 */
- (void)requestGuildGroupListWithHallId:(NSString *)hallId groupType:(nullable NSString *)type;

/**
 申请加入模厅
 @param uid 用户 uid
 @param hallId 要加入的模厅 id
 */
- (void)requestGuildHallJoinHallWithUid:(NSString *)uid
                                 hallId:(NSString *)hallId;

/**
 厅主/高管 审核加入申请
 
 @param path 请求路径
 @param recordId 记录 id
 @param type 操作类型：0拒绝 1同意
 */
- (void)requestGuildAuditApplyHallWithPath:(NSString *)path
                                 recordId:(NSString *)recordId
                                     type:(NSInteger)type;

/**
 厅主/高管 同意退出申请
 
 @param path 请求路径
 @param recordId 记录 id
 */
- (void)requestGuildAuditQuitHallWithPath:(NSString *)path
                                 recordId:(NSString *)recordId;

/**
 普通成员 处理入厅邀请
 
 @param path 请求路径
 @param recordId 记录 id
 @param type 操作类型：0拒绝 1同意
 */
- (void)requestGuildDealInviteHallWithPath:(NSString *)path
                                  recordId:(NSString *)recordId
                                          type:(NSInteger)type;

/**
 获取模厅所有成员列表

 @param hallId 公会模厅id
 @param page page 页码
 @param pageSize pageSize 每页数量
 */
- (void)requestGuildHallAllMembersListByHallId:(NSString *)hallId
                                          page:(NSInteger)page
                                      pageSize:(NSInteger)pageSize;

/**
 获取模厅所有管理员列表
 
 @param hallId 公会模厅id
 @param page page 页码
 @param pageSize pageSize 每页数量
 */
- (void)requestGuildHallAllManagersListByHallId:(NSString *)hallId
                                          page:(NSInteger)page
                                      pageSize:(NSInteger)pageSize;

/**
 设置高管

 @param hallId  模厅公会id
 @param targetUid  被设置的高管 Uid
 */
- (void)requestGuildHallSetManagerByHallId:(NSString *)hallId
                                 targetUid:(NSString *)targetUid;

/**
 取消高管
 
 @param hallId  模厅公会id
 @param targetUid  被取消的高管 Uid
 */
- (void)requestGuildHallRemoveManagerByHallId:(NSString *)hallId
                                 targetUid:(NSString *)targetUid;

/**
 获取高管权限列表
 
 @param uid 厅主 id
 @param managerUid 被查询的管理员 id
 */
- (void)requestGuildhallManagerAuthsListByUid:(NSString *)uid
                                   managerUid:(NSString *)managerUid;
/**
 打开/关闭群聊消息提醒
 
 @param chatId 群聊id
 @param isMute 操作参数 true:开启免打扰 false:关闭免打扰
 */
- (void)requestGuildGroupPromptSettingWithChatId:(NSString *)chatId
                                    promptStatus:(BOOL)isMute;

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
                                       authStr:(NSString *)authStr;

/**
 收入统计
 
 @param hallId 模厅id
 @param startTimeStr 开始时间(有格式要求) 2019-01-07
 @param endTimeStr 结束时间(按日统计,结束时间要为空,有格式要求) 2019-01-13
 */
- (void)requestGuildIncomeTotalWithHallId:(NSString *)hallId
                             startTimeStr:(NSString *)startTimeStr
                               endTimeStr:(nullable NSString *)endTimeStr;

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
                                endTimeStr:(NSString *)endTimeStr;

/**
 获取厅主模厅信息
 
 @param targetUid 目标用户uid
 */
- (void)requestGuildHallInfoWithOwnUid:(NSString *)targetUid;

/**
 主动加入群聊
 
 @param chatId 群聊id
 */
- (void)requestGuildGroupJoinWithChatId:(NSString *)chatId;

/**
 添加模厅权限(此接口待完善)
 
 @param authType authType
 */
- (void)requestGuildAuthAddWithType:(NSString *)authType;

/**
 获取不在指定群聊里面的模厅成员
 
 @param chatId 群聊id
 @param page 页码
 @param pageSize 页容量
 */
- (void)requestGuildMemberListWhichNotInGroupWithChatId:(NSString *)chatId
                                                   page:(NSInteger)page
                                               pageSize:(NSInteger)pageSize;

/**
 获取群聊所有成员列表
 
 @param chatId 群聊id
 @param page 页码
 @param pageSize 页容量
 */
- (void)requestGuildGroupAllMembersWithChatId:(NSString *)chatId
                                   page:(NSInteger)page
                               pageSize:(NSInteger)pageSize;

/**
 禁言/解禁群聊成员
 
 @param chatId 群聊id
 @param targetUid 目标用户uid
 @param isMute 操作参数 true:禁言 false:解禁
 */
- (void)requestGuildGroupBanWithChatId:(NSString *)chatId
                             targetUid:(NSString *)targetUid
                                isMute:(BOOL)isMute;

/**
 踢出群聊成员
 
 @param chatId 群聊id
 @param targetUids 目标用户uid,用逗号拼接
 */
- (void)requestGuildGroupKickWithChatId:(NSString *)chatId
                             targetUids:(NSString *)targetUids;

/**
 按条件搜索成员
 
 @param hallId 模厅id
 @param key 关键字
 */
- (void)requestGuildSearchMembersWithHallId:(NSString *)hallId
                                        key:(NSString *)key;

/**
 加入群聊
 
 @param chatId 群聊id
 @param targetUids 目标用户uid,用逗号拼接
 */
- (void)requestGuildGroupAddMembersWithChatId:(NSString *)chatId
                             targetUids:(NSString *)targetUids;

/**
 取消群聊管理
 
 @param chatId 群聊id
 @param targetUid 目标用户uid
 */
- (void)requestGuildGroupCancelManagerWithChatId:(NSString *)chatId
                                       targetUid:(NSString *)targetUid;

/**
 设置群聊管理
 
 @param chatId 群聊id
 @param targetUid 目标用户uid
 */
- (void)requestGuildGroupSetManagerWithChatId:(NSString *)chatId
                                    targetUid:(NSString *)targetUid;

/**
 获取群聊数量限制配置
 */
- (void)requestGuildGroupInfoLimit;

/**
 移出模厅
 
 @param targetUid 目标用户uid
 */
- (void)requestGuildHallKickWithTargetUid:(NSString *)targetUid;

/**
 申请退出模厅
 */
- (void)requestGuildHallQuit;

/**
 邀请加入模厅
 
 @param targetUid 目标用户uid
 */
- (void)requestGuildHallInviteWithTargetUid:(NSString *)targetUid;

/**
 获取公会emoji 暗号邀请码
 */
- (void)requestGuildEmojiCode;

/**
 校验 emoji 暗号邀请码

 @param emojiCode emoji 暗号邀请码
 */
- (void)requestGuildCheckEmojiCode:(NSString *)emojiCode;

/**
 通过emoji暗号邀请码加入模厅

 @param emojiCode 暗号邀请码
 */
- (void)requestGuildJoinByEmojiCode:(NSString *)emojiCode;
@end

NS_ASSUME_NONNULL_END
