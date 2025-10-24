//
//  GroupCore.h
//  BberryCore
//
//  Created by 卫明何 on 2018/6/1.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "BaseCore.h"
#import <NIMSDK/NIMSDK.h>
#import "GroupModel.h"
#import "XCFamilyModel.h"

@interface GroupCore : BaseCore


@property (nonatomic, assign) BOOL isReloadGroupInfor;

@property (nonatomic, strong) GroupModel * groupInfor;

/**
 创建群聊

 @param familyId 家族id
 @param icon 家族图标
 @param members 群成员
 @param isVerify 是否需要验证
 */
- (void)creatGroupByFamilyId:(NSInteger)familyId icon:(NSString *)icon name:(NSString *)name members:(NSMutableDictionary *)members isVerify:(BOOL)isVerify;

/**
 删除群聊

 @param teamId 群组id
 @param sessionId 云信的ID
 */
- (void)deleteGroupByTeamId:(NSInteger)teamId sessionId:(NSInteger)sessionId;

/**
 查询群聊成员

 @param teamId 群聊id
 @param page 页码
 @param pageSize 页面大小
 */
- (void)fetchGroupMemberByTeamId:(NSInteger)teamId page:(NSInteger)page pageSize:(NSInteger)pageSize andStatus:(NSInteger)status;

/**
 打开/关闭群聊消息提醒

 @param on YES OR NO
 @param teamId 群组id
 */
- (void)operationMessageNotificationSwitch:(BOOL)on teamId:(NSInteger)teamId;

/**
 踢出群聊成员

 @param teamId 群聊id
 @param targetUid 目标用户uid
 */
- (void)kickMemberByTeamId:(NSInteger)teamId targetUid:(UserID)targetUid groupModel:(GroupMemberModel *)groupInfor;

/**
 设置群聊管理员

 @param teamId 群聊id
 @param targetUid 目标用户uid
 */
- (void)setManagerByTeamId:(NSInteger)teamId targetUid:(UserID)targetUid groupModel:(GroupMemberModel *)groupInfor;

/**
 移出群聊管理员

 @param teamId 群聊id
 @param targetUid 目标用户id
 */
- (void)removeManagerByTeamId:(NSInteger)teamId targetUid:(UserID)targetUid groupModel:(GroupMemberModel *)groupInfor;

/**
 离开群聊

 @param teamId 群聊id
 @param sessiondId 云信的ID
 */
- (void)outterGroupByTeamId:(NSInteger)teamId sessionId:(NSInteger)sessiondId;




/**
 获取家族的所有群聊

 @param familyId 家族id
 */
- (void)fetchAllGroupInFamilyByfamilyId:(NSInteger)familyId;

/**
 通过耳伴号搜索群聊成员

 @param erbanNO 耳伴号
 @param teamId 群聊id
 @param page 页码
 @param pageSize 每页大小
 */
- (void)serachMemberGroupByErbanNo:(NSString *)erbanNO teamId:(NSInteger)teamId page:(NSInteger)page pageSize:(NSInteger)pageSize;

/**
 修改群资料

 @param teamId 群聊id
 @param icon 群聊图标
 @param name 群聊名称
 @param isVerify 是否需要验证
 */
- (void)updateGroupDataByTeamId:(NSInteger)teamId icon:(NSString *)icon name:(NSString *)name isVerify:(BOOL)isVerify;

/**
 查询群组详情

 @param teamId 群组id
 */
- (void)fetchGroupDetailByTeamId:(NSInteger)teamId;

/**
 从云信查询群组信息

 @param teamId 云信的群id
 @return 云信的群实体
 */
- (NIMTeam *)fetchGroupDetailInNIMByTeamId:(NSInteger)teamId;

/**
 群禁言
 @param teamId 群组ID
 @param targetId muteStatus目标用户UId
 @param muteStatus 是否禁言
 */
- (void)updateGroupMemberDisable:(NSInteger)teamId andTargetId:(NSInteger )targetId muteStatus:(int)muteStatus groupModel:(GroupMemberModel *)groupInfor;


/**
 加入群组
 @param teamId 群组的id
 @param groupInfor 加入群组的信息
 */
- (void)enterFamilyGroupWith:(NSInteger)teamId message:(NSString *)message group:(XCFamilyModel *)groupInfor;

/**
 获取个人所有的群组
 @param status 头部还是尾部刷新
 */
- (void)fecthUserTotalGroupWith:(int)status;

/**
 获取群聊人数
 */
- (void)fetchGroupMemberCountWith:(NSInteger)teamId;

/**
  吧家族里面的人 加到群里面
 @param chatId 群聊的id
 @param members 所有的uid
 */
- (void)addFamilyMemberToGroup:(NSInteger)chatId andMembers:(NSMutableDictionary *)members;

/**
 查询云信服务器群聊的人数
 */
- (NIMTeam *)fetchGroupDetailFromNIMByTeamId:(NSInteger)teamId ;


@end
