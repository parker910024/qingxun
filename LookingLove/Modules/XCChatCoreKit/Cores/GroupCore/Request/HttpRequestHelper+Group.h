//
//  HttpRequestHelper+Group.h
//  BberryCore
//
//  Created by 卫明何 on 2018/6/1.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "HttpRequestHelper.h"
#import "GroupModel.h"
#import "GroupMemberModel.h"
#import "GroupMember.h"
@interface HttpRequestHelper (Group)

/**
 新建群聊

 @param familyId 家族id
 @param icon 图标链接
 @param name 家族名称
 @param isVerify 是否需要验证
 @param success 成功
 @param failure 失败
 */
+ (void)creatGroupByFamilyId:(NSInteger)familyId
                        icon:(NSString *)icon
                        name:(NSString *)name
                    members:(NSMutableDictionary *)members
                    isVerify:(BOOL)isVerify
                     success:(void (^) (GroupModel *group))success
                     failure:(void (^) (NSNumber *resCode, NSString *message))failure;

/**
 解散群聊

 @param teamId 群组Id
 @param success 成功
 @param failure 失败
 */
+ (void)deleteGroupByTeamId:(NSInteger)teamId
                    success:(void (^) (BOOL group))success
                    failure:(void (^) (NSNumber *resCode, NSString *message))failure;

/**
 查询群聊成员列表

 @param teamId 群聊id
 @param page 页码
 @param pageSize 页面大小
 @param success 成功
 @param failure 失败
 */
+ (void)fetchGroupMemberByTeamId:(NSInteger)teamId
                            page:(NSInteger)page
                        pageSize:(NSInteger)pageSize
                         success:(void (^)(GroupMember*member))success
                         failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 打开/关闭群聊消息提醒

 @param on 操作参数
 @param teamId 群聊id
 @param success 成功
 @param failure 失败
 */
+ (void)operationBySwitch:(BOOL)on
                   teamId:(NSInteger)teamId
                  success:(void (^)(BOOL ope))success
                  failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 踢出群聊成员

 @param teamId 群聊id
 @param targetUid 目标uid
 @param success 成功
 @param failure 失败
 */
+ (void)kickMemberByTeamId:(NSInteger)teamId
                 targetUid:(UserID)targetUid
                   success:(void (^)(BOOL ope))success
                   failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 设置群聊管理员

 @param teamId 群聊id
 @param targetUid 目标uid
 @param success 成功
 @param failure 失败
 */
+ (void)setManagerByTeamid:(NSInteger)teamId
                 targetUid:(UserID)targetUid
                   success:(void (^)(BOOL ope))success
                   failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/**
 移出群聊管理员

 @param teamId 群聊Id
 @param targetUid 目标uid
 @param success 成功
 @param failure 失败
 */
+ (void)removeManagerByTeamid:(NSInteger)teamId
                    targetUid:(UserID)targetUid
                      success:(void (^)(BOOL ope))success
                      failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 离开群聊

 @param teamId 群聊id
 @param success 成功
 @param failure 失败
 */
+ (void)outGroupByTeamid:(NSInteger)teamId
                 success:(void (^)(BOOL ope))success
                 failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 获取家族的所有群聊

 @param familyId 家族id
 @param success 成功
 @param failure 失败
 */
+ (void)fetchAllGroupbyFamilyId:(NSInteger)familyId
                        success:(void (^)(NSArray<GroupModel *> *groups))success
                        failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 通过耳伴号搜索群聊成员

 @param teamId 群聊id
 @param erbanNo 耳伴号
 @param page 页码
 @param pageSize 每页大小
 @param success 成功
 @param failure 失败
 */
+ (void)searchMemberByTeamid:(NSInteger)teamId
                     erbanNo:(NSString *)erbanNo
                        page:(NSInteger)page
                    pageSize:(NSInteger)pageSize
                     success:(void (^)(NSArray<GroupMemberModel *> *member))success
                     failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 修改群资料

 @param teamId 群聊id
 @param icon 群聊图标
 @param name 群聊名称
 @param isVerify 是否需要验证
 @param success 成功
 @param failure 失败
 
 
 
 */
+ (void)updateGroupDataByTeamId:(NSInteger)teamId
                           icon:(NSString *)icon
                           name:(NSString *)name
                       isVerify:(BOOL)isVerify
                        success:(void (^)(GroupModel *group))success
                        failure:(void (^)(NSNumber *resCode, NSString *message))failure;
/**
  查询群组id

 @param teamId 家族id
 @param success 成功
 @param failure 失败
 */
+ (void)fetchGroupByteamId:(NSInteger)teamId
                   success:(void (^) (GroupModel *group))success
                   failure:(void (^) (NSNumber *resCode, NSString *message))failure;

/**
 禁言用户
 @param teamId 群组id
 @param targetId 目标用户id
 @param mute 是不是禁言 1 禁言 0 解禁
 @param success 成功
 @param failure 失败
 */
+ (void)updateGroupUserDisable:(NSInteger)teamId
                     andTarget:(NSInteger)targetId
                          mute:(int)mute
                       success:(void(^)(NSDictionary * dic))success
                       failure:(void (^) (NSNumber *resCode, NSString *message))failure;

/**
 用户主动加入群聊
 @param teamId 要加入群组的id
 @param message 加入群组验证消息
 @param success 成功
 @param failure 失败
 */
+ (void)enterGroupWith:(NSInteger)teamId
               message:(NSString *)message
            andSuccess:(void(^)(NSDictionary *dic))success
               failure:(void(^)(NSNumber * resCode, NSString * message))failure;

/**
 获取用户所有的群聊
 */
+ (void)fecthUserTotalGroup:(void(^)(NSArray * groupList))success
                    failure:(void(^)(NSNumber * resCode, NSString * message))failure;


/**
 获取群的总的人数
 @param teamId 要加入群组的id
 @param success 成功
 @param failure 失败
 */
+ (void)fetchGroupMemberCountWith:(NSInteger)teamId
                       andSuccess:(void(^)(NSDictionary *dic))success
                          failuer:(void(^)(NSNumber * recCode, NSString * message))failure;

/**
 批量加入家族
 @param chatId 要加入群组的id
 @param members 要加入的人
 @param success 成功
 @param failure 失败
 */
+ (void)addFamilyMemberToGroupWith:(NSMutableDictionary *)members andchatId:(NSInteger)chatId
                        andSuccess:(void(^)(NSDictionary *dic))success
                           failuer:(void(^)(NSNumber * recCode, NSString * message))failure;

@end
