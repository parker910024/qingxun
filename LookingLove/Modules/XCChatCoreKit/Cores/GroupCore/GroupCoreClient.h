//
//  GroupCoreClient.h
//  BberryCore
//
//  Created by 卫明何 on 2018/6/1.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GroupModel.h"
#import "GroupMemberModel.h"
#import "XCFamilyModel.h"
#import "GroupMember.h"

@protocol GroupCoreClient <NSObject>
@optional
- (void)creatGroupSuccess:(GroupModel *)group;
- (void)creatGroupFailth:(NSString *)message;

//- (void)deleteGroupSuccess;删除了这个方法 一面别的项目 出现收不到通知的问题
- (void)deleteGroupSuccessWithTeamId:(NSInteger)teamId sessionId:(NSInteger)sessionId;
- (void)deleteGroupFailth:(NSString *)message;

- (void)fetchGroupMemberSuccess:(GroupMember *)groupMember page:(NSInteger)page pageSize:(NSInteger)pageSize status:(NSInteger)status;
- (void)fetchGroupMemberFailth:(NSString *)message status:(NSInteger)status;

- (void)muteGroupSuccessTeamId:(NSInteger)teamId isMute:(BOOL)isMute;
- (void)muteGroupFailth:(NSString *)message teamId:(NSInteger)teamId;

- (void)kickMemberOutOfGroupSuccess:(UserID)targetUid teamId:(NSInteger)teamId groupModel:(GroupMemberModel *)groupInfor;
- (void)kickMemberFailthWithMessage:(NSString *)message targetUid:(UserID)targetUid teamId:(NSInteger)teamId;

- (void)setManagerSuccess:(UserID)targetUid teamId:(NSInteger)teamId groupModel:(GroupMemberModel *)groupInfor;
- (void)setManagerFailthMessage:(NSString *)message targetUid:(UserID)targetUid teamId:(NSInteger)teamId;

- (void)removeManagerSuccess:(UserID)targetUid teamId:(NSInteger)teamId groupModel:(GroupMemberModel *)groupInfor;
- (void)removeManagerFailthMessage:(NSString *)message targetUid:(UserID)targetUid teamId:(NSInteger)teamId;

- (void)outGroupSuccessTeamId:(NSInteger)teamId sessionId:(NSInteger)sessionId;
- (void)outGroupFailthMessage:(NSString *)message teamId:(NSInteger)teamId;

- (void)fetchAllGroupInFamilySuccess:(NSArray<GroupModel *>*)groups familyId:(NSInteger)familyId;
- (void)fetchAllGroupInFamilyFailth:(NSString *)message familyId:(NSInteger)familyId;

- (void)searchMembersInGroupSuccess:(NSArray<GroupMemberModel *> *)groupMembers page:(NSInteger)page pageSize:(NSInteger)pageSize;
- (void)searchMembersInGroupFailth:(NSString *)message page:(NSInteger)page pageSize:(NSInteger)pageSize;

- (void)updateGroupDataSuccess:(GroupModel *)group;
- (void)updateGroupDataFailth:(NSString *)message;

- (void)fetchGroupDetailSuccess:(GroupModel *)group teamId:(NSInteger)teamId;
- (void)fetchGroupDetailFailth:(NSString *)message teamId:(NSInteger)teamId;
//禁言
- (void)setupGroupMemberDisableSuccess:(NSDictionary *)dic andTeamId:(NSInteger)temaId  andStatus:(BOOL)status groupModel:(GroupMemberModel *)groupInfor;
- (void)setupGroupMemberDisableFail:(NSString *)message andStatus:(BOOL)status;
//加入群组
- (void)enterFamilyGroupSuccess:(NSDictionary *)dic andGroupInfor:(XCFamilyModel *)model;
- (void)enterFamilyGroupFail:(NSString *)message;
//获取所有的群组
- (void)fetchUserTotalGroupsSuccess:(NSArray *)groups status:(int)staus;
- (void)fetchUserTotalGroupsFail:(NSString *)message status:(int)stauts;
//批量吧家族里面的人加入群组
- (void)addFamilyMemberToGroupSuccess:(NSDictionary *)dic chatId:(NSInteger)chatId;
- (void)addFamilyMemberToGroupFail:(NSString *)message chatId:(NSInteger)chatId;

//获取群聊的人数
- (void)fetchGroupMemberNumberSuccess:(NSInteger)count;
- (void)fetchGroupMemberNumberFail:(NSString *)message;
@end
