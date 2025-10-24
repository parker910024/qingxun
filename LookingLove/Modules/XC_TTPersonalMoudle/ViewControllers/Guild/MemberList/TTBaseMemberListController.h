//
//  TTBaseMemberListController.h
//  TTPlay
//
//  Created by lee on 2019/1/27.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "BaseTableViewController.h"
#import "BaseTableViewController.h"
#import "TTGuildMemberHeaderSectionView.h"
#import "UserInfo.h"
#import "GuildHallManagerInfo.h"
#import "GuildChatGroupAllMemberResponse.h"

@class UserInfo, TTGuildMemberHeaderSectionView, GuildChatGroupAllMemberResponse, GuildHallManagerInfo;
NS_ASSUME_NONNULL_BEGIN
/**
 成员列表显示类型
 
 - GuildHallListTypeMember: 普通成员
 - GuildHallListTypeKeeper: 高管列表
 - GuildHallListTypeRemoveMember: 移除模厅成员
 */

typedef NS_ENUM(NSUInteger, GuildHallListType) {
    /** 普通成员类型 */
    GuildHallListTypeMember = 0,
    /** 高级管理类型 */
    GuildHallListTypeKeeper = 1,
    /** 移除模厅成员 */
    GuildHallListTypeRemoveMember = 2,
    /** 可多选成员类型 */
    GuildHallListTypeMutableMember = 3,
    /** 禁言类型 */
    GuildHallListTypeMute = 4,
    /** 群聊成员类型 */
    GuildHallListTypeGroupMember = 5,
    /** 群聊高管类型 */
    GuildHallListTypeGroupManager = 6,
    /** 群聊成员普通类型 */
    GuildHallListTypeGroupNormal = 7,
};

@class GuildHallInfo, GuildHallGroupInfo;

typedef void(^RefreshKeeperHander)(void);
typedef void(^TranfromDataHandler)(NSMutableArray<UserInfo *> *array);

@interface TTBaseMemberListController : BaseTableViewController

/** 模厅信息 */
@property (nonatomic, strong) GuildHallInfo *hallInfo;
/** 群聊 id */
@property (nonatomic, copy) NSString *chatID;
/** 数据展示类型 */
@property (nonatomic, assign) GuildHallListType listType;
/** 刷新 handler */
@property (nonatomic, copy) RefreshKeeperHander refreshHander;
/** 传递数据 handler */
@property (nonatomic, copy) TranfromDataHandler tranfromHandler;
/** 是否是群聊添加成员 */
@property (nonatomic, assign) BOOL isGroupAdd;
/** 群聊群信息 */
@property (nonatomic, strong) GuildHallGroupInfo *groupChatInfo;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray *dataArray;
/** 头部view */
@property (nonatomic, strong) TTGuildMemberHeaderSectionView *sectionHeadView;
/** 当前的 index */
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
/** 被选中的用户 */
@property (nonatomic, strong) NSMutableArray<UserInfo *> *selectingUserArray;
/** 当前用户信息 */
@property (nonatomic, strong) UserInfo *currentInfo;
/** 授权数据 */
@property (nonatomic, strong) NSArray<GuildHallManagerInfo *> *authArray;
/** 是否是群聊 */
@property (nonatomic, assign) BOOL isGroupChat;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) GuildChatGroupAllMemberResponse *chatGroupAllMemberResponse;
- (void)requestAllMemberList;
- (void)endTableViewRefresh;
@end

NS_ASSUME_NONNULL_END
