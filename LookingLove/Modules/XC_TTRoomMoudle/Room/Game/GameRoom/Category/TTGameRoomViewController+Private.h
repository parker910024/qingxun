//
//  TTGameRoomViewController+Private.h
//  TuTu
//
//  Created by KevinWang on 2018/11/3.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTGameRoomViewController.h"

@interface TTGameRoomViewController (Private)
//是否显示🎲
- (void)isShowTogetherButton;

//主播下线
- (void)ttShowFinishLive;

//加入黑名单
- (void)ttShowAlertWithAddBlackList:(NIMChatroomMember *)member;

//举报
- (void)ttshowReportList;

//退出房间
- (void)ttQuiteRoom:(int)reason;
//退出房间 超管操作
- (void)ttQuiteRoomByAdmin:(NIMChatroomBeKickedResult *)result;
//超管踢管理员的时候
- (void)ttReceiveSuperAdminMessageQuitRoomHandle;
//close
- (void)ttShowCloseList;

//最小化
- (void)ttSetBeMiniRoom;

//余额不足
- (void)ttShowBalanceNotEnougth;

//被邀请上麦
- (void)ttShowInviteAlert;

//生成埋点全名：cp/mp + click
- (NSString *)roomFullTrackName:(NSString *)clickName;

//处理容器view中的数据
- (void)hideRoomContainerViewData;

/** 萝卜钱包余额不足 */
- (void)ttShowCarrotBalanceNotEnougth;

/// 当前用户是否为超管
- (BOOL)isSuperAdmin;

@end
