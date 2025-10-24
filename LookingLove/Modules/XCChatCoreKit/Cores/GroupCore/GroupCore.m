//
//  GroupCore.m
//  BberryCore
//
//  Created by 卫明何 on 2018/6/1.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "GroupCore.h"
#import "HttpRequestHelper+Group.h"
#import "GroupCoreClient.h"


@implementation GroupCore

- (void)creatGroupByFamilyId:(NSInteger)familyId
                        icon:(NSString *)icon
                        name:(NSString *)name
                     members:(NSMutableDictionary *)members
                    isVerify:(BOOL)isVerify {
    [HttpRequestHelper creatGroupByFamilyId:familyId icon:icon name:name members:members isVerify:isVerify success:^(GroupModel *group) {
        NotifyCoreClient(GroupCoreClient, @selector(creatGroupSuccess:), creatGroupSuccess:group);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(GroupCoreClient, @selector(creatGroupFailth:), creatGroupFailth:message);
    }];
}

- (void)deleteGroupByTeamId:(NSInteger)teamId sessionId:(NSInteger)sessionId {
    [HttpRequestHelper deleteGroupByTeamId:teamId success:^(BOOL group) {
        NotifyCoreClient(GroupCoreClient, @selector(deleteGroupSuccessWithTeamId:sessionId:), deleteGroupSuccessWithTeamId:teamId sessionId:sessionId);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(GroupCoreClient, @selector(deleteGroupFailth:), deleteGroupFailth:message);
    }];
}

- (void)fetchGroupMemberByTeamId:(NSInteger)teamId page:(NSInteger)page pageSize:(NSInteger)pageSize andStatus:(NSInteger)status{
    [HttpRequestHelper fetchGroupMemberByTeamId:teamId page:page pageSize:pageSize success:^(GroupMember *member) {
        NotifyCoreClient(GroupCoreClient, @selector(fetchGroupMemberSuccess:page:pageSize:status:), fetchGroupMemberSuccess:member page:page pageSize:pageSize status:status);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(GroupCoreClient, @selector(fetchGroupMemberFailth:status:), fetchGroupMemberFailth:message status:status);
    }];
    
}

- (void)operationMessageNotificationSwitch:(BOOL)on teamId:(NSInteger)teamId {
    [HttpRequestHelper operationBySwitch:on teamId:teamId success:^(BOOL ope) {
        NotifyCoreClient(GroupCoreClient, @selector(muteGroupSuccessTeamId:isMute:), muteGroupSuccessTeamId:teamId isMute:on);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(GroupCoreClient, @selector(muteGroupFailth:teamId:), muteGroupFailth:message teamId:teamId);
    }];
}

- (void)kickMemberByTeamId:(NSInteger)teamId targetUid:(UserID)targetUid groupModel:(GroupMemberModel *)groupInfor{
    [HttpRequestHelper kickMemberByTeamId:teamId targetUid:targetUid success:^(BOOL ope) {
        NotifyCoreClient(GroupCoreClient, @selector(kickMemberOutOfGroupSuccess:teamId:groupModel:), kickMemberOutOfGroupSuccess:targetUid teamId:teamId groupModel:groupInfor);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(GroupCoreClient, @selector(kickMemberFailthWithMessage:targetUid:teamId:), kickMemberFailthWithMessage:message targetUid:targetUid teamId:teamId);
    }];
}

- (void)setManagerByTeamId:(NSInteger)teamId targetUid:(UserID)targetUid groupModel:(GroupMemberModel *)groupInfor{
    [HttpRequestHelper setManagerByTeamid:teamId targetUid:targetUid success:^(BOOL ope) {
        NotifyCoreClient(GroupCoreClient, @selector(setManagerSuccess:teamId:groupModel:), setManagerSuccess:targetUid teamId:teamId groupModel:groupInfor);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(GroupCoreClient, @selector(setManagerFailthMessage:targetUid:teamId:), setManagerFailthMessage:message targetUid:targetUid teamId:teamId);
    }];
}

- (void)removeManagerByTeamId:(NSInteger)teamId targetUid:(UserID)targetUid groupModel:(GroupMemberModel *)groupInfor{
    [HttpRequestHelper removeManagerByTeamid:teamId targetUid:targetUid success:^(BOOL ope) {
        NotifyCoreClient(GroupCoreClient, @selector(removeManagerSuccess:teamId:groupModel:), removeManagerSuccess:targetUid teamId:teamId groupModel:groupInfor);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(GroupCoreClient, @selector(removeManagerFailthMessage:targetUid:teamId:), removeManagerFailthMessage:message targetUid:targetUid teamId:teamId);
    }];
}

- (void)outterGroupByTeamId:(NSInteger)teamId sessionId:(NSInteger)sessiondId{
    [HttpRequestHelper outGroupByTeamid:teamId success:^(BOOL ope) {
        NotifyCoreClient(GroupCoreClient, @selector(outGroupSuccessTeamId:sessionId:), outGroupSuccessTeamId:teamId sessionId:sessiondId);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(GroupCoreClient, @selector(outGroupFailthMessage:teamId:), outGroupFailthMessage:message teamId:teamId);
    }];
}

- (void)fetchAllGroupInFamilyByfamilyId:(NSInteger)familyId {
    [HttpRequestHelper fetchAllGroupbyFamilyId:familyId success:^(NSArray<GroupModel *> *groups) {
        NotifyCoreClient(GroupCoreClient, @selector(fetchAllGroupInFamilySuccess:familyId:), fetchAllGroupInFamilySuccess:groups familyId:familyId);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(GroupCoreClient, @selector(fetchAllGroupInFamilyFailth:familyId:), fetchAllGroupInFamilyFailth:message familyId:familyId);
    }];
}

- (void)serachMemberGroupByErbanNo:(NSString *)erbanNO teamId:(NSInteger)teamId page:(NSInteger)page pageSize:(NSInteger)pageSize {
    [HttpRequestHelper searchMemberByTeamid:teamId erbanNo:erbanNO page:page pageSize:pageSize success:^(NSArray<GroupMemberModel *> *member) {
        NotifyCoreClient(GroupCoreClient, @selector(searchMembersInGroupSuccess:page:pageSize:), searchMembersInGroupSuccess:member page:page pageSize:pageSize);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(GroupCoreClient, @selector(searchMembersInGroupFailth:page:pageSize:), searchMembersInGroupFailth:message page:page pageSize:pageSize);
    }];
}

- (void)updateGroupDataByTeamId:(NSInteger)teamId icon:(NSString *)icon name:(NSString *)name isVerify:(BOOL)isVerify {
    [HttpRequestHelper updateGroupDataByTeamId:teamId icon:icon name:name isVerify:isVerify success:^(GroupModel *group) {
        NotifyCoreClient(GroupCoreClient, @selector(updateGroupDataSuccess:), updateGroupDataSuccess:group);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(GroupCoreClient, @selector(updateGroupDataFailth:), updateGroupDataFailth:message);
    }];
}

- (void)fetchGroupDetailByTeamId:(NSInteger)teamId {
    [HttpRequestHelper fetchGroupByteamId:teamId success:^(GroupModel *group) {
        self.groupInfor = group;
        NotifyCoreClient(GroupCoreClient, @selector(fetchGroupDetailSuccess:teamId:), fetchGroupDetailSuccess:group teamId:teamId);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(GroupCoreClient, @selector(fetchGroupDetailFailth:teamId:), fetchGroupDetailFailth:message teamId:teamId);
    }];
}

- (NIMTeam *)fetchGroupDetailInNIMByTeamId:(NSInteger)teamId {
    return [[NIMSDK sharedSDK].teamManager teamById:[NSString stringWithFormat:@"%ld",(long)teamId]];
}


- (void)updateGroupMemberDisable:(NSInteger)teamId andTargetId:(NSInteger )targetId muteStatus:(int)muteStatus groupModel:(GroupMemberModel *)groupInfor
{
    
    [HttpRequestHelper updateGroupUserDisable:teamId andTarget:targetId mute:muteStatus success:^(NSDictionary *dic) {
        NotifyCoreClient(GroupCoreClient, @selector(setupGroupMemberDisableSuccess:andTeamId:andStatus:groupModel:), setupGroupMemberDisableSuccess:dic andTeamId:teamId andStatus:muteStatus groupModel:groupInfor);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(GroupCoreClient, @selector(setupGroupMemberDisableFail:andStatus:), setupGroupMemberDisableFail:message andStatus:muteStatus);
    }];
}

- (void)enterFamilyGroupWith:(NSInteger)teamId message:(NSString *)message group:(XCFamilyModel *)groupInfor
{
    [HttpRequestHelper enterGroupWith:teamId message:message andSuccess:^(NSDictionary *dic) {
        NotifyCoreClient(GroupCoreClient, @selector(enterFamilyGroupSuccess:andGroupInfor:), enterFamilyGroupSuccess:dic andGroupInfor:groupInfor);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(GroupCoreClient, @selector(enterFamilyGroupFail:), enterFamilyGroupFail:message);
    }];
}

- (void)fecthUserTotalGroupWith:(int)status
{
    [HttpRequestHelper fecthUserTotalGroup:^(NSArray *groupList) {
        NotifyCoreClient(GroupCoreClient, @selector(fetchUserTotalGroupsSuccess:status:), fetchUserTotalGroupsSuccess:groupList status:status);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(GroupCoreClient, @selector(fetchUserTotalGroupsFail:status:), fetchUserTotalGroupsFail:message status:status);
    }];
}

- (void)fetchGroupMemberCountWith:(NSInteger)teamId
{
    [HttpRequestHelper fetchGroupMemberCountWith:teamId andSuccess:^(NSDictionary *dic) {
//        NotifyCoreClient(GroupCoreClient, @selector(fetchGroupMemberNumberSuccess:), fetchGroupMemberNumberSuccess:dic[@"count"]);
    } failuer:^(NSNumber *recCode, NSString *message) {
//        NotifyCoreClient(GroupCoreClient, @selector(fetchGroupMemberNumberFail:), fetchGroupMemberNumberFail:dic[@"count"]);
    }];
}


- (void)addFamilyMemberToGroup:(NSInteger)chatId andMembers:(NSMutableDictionary *)members
{
    [HttpRequestHelper addFamilyMemberToGroupWith:members andchatId:chatId andSuccess:^(NSDictionary *dic) {
        NotifyCoreClient(GroupCoreClient, @selector(addFamilyMemberToGroupSuccess:chatId:), addFamilyMemberToGroupSuccess:dic chatId:chatId);
    } failuer:^(NSNumber *recCode, NSString *message) {
        NotifyCoreClient(GroupCoreClient, @selector(addFamilyMemberToGroupFail:chatId:), addFamilyMemberToGroupFail:message chatId:chatId);
    }];
}

- (NIMTeam *)fetchGroupDetailFromNIMByTeamId:(NSInteger)teamId {
    return [[NIMSDK sharedSDK].teamManager teamById:[NSString stringWithFormat:@"%ld",(long)teamId]];
}


@end
