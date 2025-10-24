//
//  HttpRequestHelper+Guild.h
//  XCChatCoreKit
//
//  Created by lvjunhang on 2019/1/7.
//  Copyright © 2019年 KevinWang. All rights reserved.
//

#import "HttpRequestHelper.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^HttpRequestHelperGuildCompletion)(id _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg);

@interface HttpRequestHelper (Guild)

/**
 更新模厅名
 
 @param hallName 模厅名称
 @param completion 完成回调
 */
+ (void)requestGuildHallNameUpdateWithHallName:(NSString *)hallName
                                 completion:(HttpRequestHelperGuildCompletion)completion;

/**
 获取模厅信息
 
 @param hallId 模厅id
 @param completion 完成回调
 */
+ (void)requestGuildHallInfoFetchWithHallId:(NSString *)hallId uid:(NSString *)uid
                                   completion:(HttpRequestHelperGuildCompletion)completion;

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
                                   completion:(HttpRequestHelperGuildCompletion)completion;

/**
 解散群聊
 
 @param chatId 群聊id
 @param completion 完成回调
 */
+ (void)requestGuildGroupRemoveWithChatId:(NSString *)chatId
                                   completion:(HttpRequestHelperGuildCompletion)completion;

/**
 离开群聊
 
 @param chatId 群聊id
 @param completion 完成回调
 */
+ (void)requestGuildGroupQuitWithChatId:(NSString *)chatId
                             completion:(HttpRequestHelperGuildCompletion)completion;

/**
 获取群聊资料
 
 @param tid 云信群聊id
 @param completion 完成回调
 */
+ (void)requestGuildGroupInfoFetchWithTid:(NSString *)tid
                                      completion:(HttpRequestHelperGuildCompletion)completion;

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
                                       completion:(HttpRequestHelperGuildCompletion)completion;


/**
 根据 uid 获取模厅公告菜单

 @param uid 用户 uid
 @param completion 完成回调
 */
+ (void)requestGuildHallMenusWithUid:(NSString *)uid completion:(HttpRequestHelperGuildCompletion)completion;

/**
 查询模厅权限列表

 @param uid 用户 uid
 @param roleType 权限类型 1表示厅主,2高管,3普通成员
 @param completion 完成回调
 */
+ (void)requestGuildHallAuthListWithUid:(NSString *)uid
                               roleType:(NSString *)roleType
                             completion:(HttpRequestHelperGuildCompletion)completion;


/**
 获取高管权限列表

 @param uid 厅主 uid
 @param managerUid 被查询的管理员的 uid
 @param completion 完成回调
 */
+ (void)requestGuildHallGetManagerAuthWithUid:(NSString *)uid managerUid:(NSString *)managerUid completion:(HttpRequestHelperGuildCompletion)completion;

/**
 设置高管权限列表

 @param uid 厅主 uid
 @param managerUid 被设置的管理员 uid
 @param hallId 模厅 id
 @param authStr 被设置的权限
 @param completion 完成回调
 */
+ (void)requestGuildHallSetManagerAuthWithUid:(NSString *)uid managerUid:(NSString *)managerUid  hallID:(NSString *)hallId authStr:(NSString *)authStr completion:(HttpRequestHelperGuildCompletion)completion;

/**
 申请加入模厅

 @param uid 申请人的 Uid
 @param hallId 模厅 id
 @param completion 完成回调
 */
+ (void)requestGuildHallJoinWithUid:(NSString *)uid hallId:(NSString *)hallId completion:(HttpRequestHelperGuildCompletion)completion;


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
                               completion:(HttpRequestHelperGuildCompletion)completion;

/**
 厅主/高管 同意退出申请
 
 @param path 请求路径
 @param recordId 记录 id
 @param completion 完成回调
 */
+ (void)requestGuildAuditQuitHallWithPath:(NSString *)path
                                 recordId:(NSString *)recordId
                               completion:(HttpRequestHelperGuildCompletion)completion;

/**
 普通成员 处理入厅邀请
 
 @param path 请求路径
 @param recordId 记录 id
 @param type 操作类型：0拒绝 1同意
 */
+ (void)requestGuildDealInviteHallWithPath:(NSString *)path
                                  recordId:(NSString *)recordId
                                      type:(NSInteger)type
                                completion:(HttpRequestHelperGuildCompletion)completion;

/**
 获取模厅群聊列表
 
 @param hallId 模厅id
 @param type 1:公开群，2：内部群， 空查全部
 */
+ (void)requestGuildGroupListWithHallId:(NSString *)hallId
                                  groupType:(nullable NSString *)type
                                 completion:(HttpRequestHelperGuildCompletion)completion;


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
                                   completion:(HttpRequestHelperGuildCompletion)completion;

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
                                   completion:(HttpRequestHelperGuildCompletion)completion;

/**
 设置高管
 
 @param hallId 模厅公会id
 @param targetUid 被设置的高管 uid
 @param completion 完成回调
 */
+ (void)requestGuildHallSetManagerByHallId:(NSString *)hallId
                                 targetUid:(NSString *)targetUid
                                completion:(HttpRequestHelperGuildCompletion)completion;
/**
 取消高管
 
 @param hallId 模厅公会id
 @param targetUid 被取消的高管 uid
 @param completion 完成回调
 */
+ (void)requestGuildHallRemoveManagerByHallId:(NSString *)hallId
                                 targetUid:(NSString *)targetUid
                                completion:(HttpRequestHelperGuildCompletion)completion;

/**
 打开/关闭群聊消息提醒
 
 @param chatId 群聊id
 @param isMute 操作参数 true:开启免打扰 false:关闭免打扰
 @param completion 完成回调
 */
+ (void)requestGuildGroupPromptSettingWithChatId:(NSString *)chatId
                                    promptStatus:(BOOL)isMute
                                      completion:(HttpRequestHelperGuildCompletion)completion;

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
                               completion:(HttpRequestHelperGuildCompletion)completion;

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
                                completion:(HttpRequestHelperGuildCompletion)completion;

/**
 获取厅主模厅信息
 
 @param targetUid 目标用户uid
 @param completion 完成回调
 */
+ (void)requestGuildHallInfoWithOwnUid:(NSString *)targetUid
                            completion:(HttpRequestHelperGuildCompletion)completion;

/**
 主动加入群聊
 
 @param chatId 群聊id
 @param completion 完成回调
 */
+ (void)requestGuildGroupJoinWithChatId:(NSString *)chatId
                             completion:(HttpRequestHelperGuildCompletion)completion;

/**
 添加模厅权限(此接口待完善)
 
 @param authType authType
 @param completion 完成回调
 */
+ (void)requestGuildAuthAddWithType:(NSString *)authType
                         completion:(HttpRequestHelperGuildCompletion)completion;

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
                                             completion:(HttpRequestHelperGuildCompletion)completion;

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
                             completion:(HttpRequestHelperGuildCompletion)completion;

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
                            completion:(HttpRequestHelperGuildCompletion)completion;

/**
 踢出群聊成员
 
 @param chatId 群聊id
 @param targetUids 目标用户uid,用逗号拼接
 @param completion 完成回调
 */
+ (void)requestGuildGroupKickWithChatId:(NSString *)chatId
                             targetUids:(NSString *)targetUids
                             completion:(HttpRequestHelperGuildCompletion)completion;

/**
 按条件搜索成员
 
 @param hallId 模厅id
 @param key 关键字
 @param completion 完成回调
 */
+ (void)requestGuildSearchMembersWithHallId:(NSString *)hallId
                                        key:(NSString *)key
                                 completion:(HttpRequestHelperGuildCompletion)completion;

/**
 加入群聊
 
 @param chatId 群聊id
 @param targetUids 目标用户uid,用逗号拼接
 @param completion 完成回调
 */
+ (void)requestGuildGroupAddMembersWithChatId:(NSString *)chatId
                             targetUids:(NSString *)targetUids
                             completion:(HttpRequestHelperGuildCompletion)completion;

/**
 取消群聊管理
 
 @param chatId 群聊id
 @param targetUid 目标用户uid
 @param completion 完成回调
 */
+ (void)requestGuildGroupCancelManagerWithChatId:(NSString *)chatId
                              targetUid:(NSString *)targetUid
                             completion:(HttpRequestHelperGuildCompletion)completion;

/**
 设置群聊管理
 
 @param chatId 群聊id
 @param targetUid 目标用户uid
 @param completion 完成回调
 */
+ (void)requestGuildGroupSetManagerWithChatId:(NSString *)chatId
                              targetUid:(NSString *)targetUid
                             completion:(HttpRequestHelperGuildCompletion)completion;

/**
 获取群聊数量限制配置
 
 @param completion 完成回调
 */
+ (void)requestGuildGroupInfoLimitWithCompletion:(HttpRequestHelperGuildCompletion)completion;

/**
 移出模厅
 
 @param targetUid 目标用户uid
 @param completion 完成回调
 */
+ (void)requestGuildHallKickWithTargetUid:(NSString *)targetUid
                               completion:(HttpRequestHelperGuildCompletion)completion;

/**
 申请退出模厅
 
 @param completion 完成回调
 */
+ (void)requestGuildHallQuitWithCompletion:(HttpRequestHelperGuildCompletion)completion;

/**
 邀请加入模厅
 
 @param targetUid 目标用户uid
 @param completion 完成回调
 */
+ (void)requestGuildHallInviteWithTargetUid:(NSString *)targetUid
                               completion:(HttpRequestHelperGuildCompletion)completion;
/**
 获取公会emoji 暗号邀请码

 @param completion 完成回调
 */
+ (void)requestGuildEmojiCodeCompletion:(HttpRequestHelperGuildCompletion)completion;

/**
 校验 emoji 暗号邀请码
 
 @param emojiCode emoji 暗号邀请码
 @param completion 完成回调
 */
+ (void)requestGuildCheckEmojiCode:(NSString *)emojiCode completion:(HttpRequestHelperGuildCompletion)completion;

/**
 通过emoji暗号邀请码加入模厅
 
 @param emojiCode 暗号邀请码
 @param completion 完成回调
 */
+ (void)requestGuildJoinByEmojiCode:(NSString *)emojiCode completion:(HttpRequestHelperGuildCompletion)completion;

@end

NS_ASSUME_NONNULL_END

