//
//  TTGameRoomViewController+MicPosition.m
//  TuTu
//
//  Created by KevinWang on 2018/11/5.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTGameRoomViewController+MicPosition.h"
#import "TTGameRoomViewController+UserCard.h"
#import "TTGameRoomViewController+RoomGift.h"
#import "TTGameRoomViewController+Private.h"
#import "TTRoomOnlineListController.h"
#import "TTRoomIntroduceViewController.h"
#import "TTGameRoomViewController+Introduce.h"
#import "TTGameRoomViewController+GiftValue.h"

#import "TTRoomSettingsInputAlertView.h"
#import "TTGiftValueAlertView.h"

#import "TTStatisticsService.h"

#import "AuthCore.h"
#import "RoomCoreV2.h"
#import "ArrangeMicCore.h"

#import "TTPopup.h"
#import "NSString+JsonToDic.h"

@implementation TTGameRoomViewController (MicPosition)

#pragma mark - XCRoomPositionViewDelegate
- (void)roomPositionViewDidClickTopicLabel:(TTPositionView *)positionView {
    
    [TTStatisticsService trackEvent:[self roomFullTrackName:TTStatisticsServiceRoomTopicClick] eventDescribe:@"设置房间话题"];
    
    NIMChatroomMember *myMember = GetCore(ImRoomCoreV2).myMember;
    if ((myMember.type == NIMChatroomMemberTypeCreator || myMember.type == NIMChatroomMemberTypeManager) && [GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue].platformRole != XCUserInfoPlatformRoleSuperAdmin) {
        TTRoomIntroduceViewController *introduceVC = [[TTRoomIntroduceViewController alloc] init];
        introduceVC.ttRoomInfo = self.roomInfo;
        [self.navigationController pushViewController:introduceVC animated:YES];
    } else {
        [self showIntroduceAlertView];
    }
}

- (void)roomPositionView:(TTPositionView *)positionView didSelectedUser:(UserID)userUid{
    
    NIMChatroomMember *myMember = GetCore(ImRoomCoreV2).myMember;
    UserInfo *  myInfor = [GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue];
    if (myMember.type == NIMChatroomMemberTypeCreator || myMember.type == NIMChatroomMemberTypeManager) { //我是房主或者管理员
        if (myInfor.platformRole == XCUserInfoPlatformRoleSuperAdmin) {
            [self ttShowUserCard:userUid isGaming:YES isSuperAdmin:YES];
        }else {
            [self ttShowUserCard:userUid isGaming:YES];
        }
    }else if (myMember.type == NIMChatroomMemberTypeNormal || myMember.type == NIMChatroomMemberTypeGuest) { //我是普通用户或游客
       if (myInfor.platformRole == XCUserInfoPlatformRoleSuperAdmin) {
            [self ttShowUserCard:userUid isGaming:YES isSuperAdmin:YES];
       }else {
           [self ttShowUserCard:userUid isGaming:YES];
       }
    }
}
//显示礼物
- (void)roomPositionView:(TTPositionView *)positionView showGiftView:(UserID)userUid{
    
    [self ttShowSendGiftViewType:SelectGiftType_gift targetUid:userUid];
}

- (void)roomPositionView:(TTPositionView *)positionView didClickEmptyPosition:(NSString *)position sequence:(ChatRoomMicSequence *)sequence{
    
    UserInfo *info = [GetCore(UserCore) getUserInfoInDB:[GetCore(AuthCore) getUid].userIDValue];
    NIMChatroomMember *member = sequence.chatRoomMember;
    MicroState *state = sequence.microState;
    UserID myUid = [GetCore(AuthCore)getUid].userIDValue;
    NIMChatroomMember *myMember = GetCore(RoomQueueCoreV2).myMember;
    NSDictionary * roomext = [NSString dictionaryWithJsonString:myMember.roomExt];
    RoomInfo *roomInfo = GetCore(RoomCoreV2).getCurrentRoomInfo;
    BOOL isLeaveMode = roomInfo.leaveMode;
    if (isLeaveMode) {
        // 如果是离开模式，房主必须关闭离开模式才可以上麦
        if (roomInfo.uid == GetCore(AuthCore).getUid.integerValue) {
            [XCHUDTool showErrorWithMessage:@"上麦请先关闭离开模式"];
            return;
        }
    }
    
    self.insuranceBOOL = YES;
    
    if (state.posState == MicroPosStateLock) { //麦序是锁的
        
        if (info.platformRole == XCUserInfoPlatformRoleSuperAdmin) {
            [self showManagerPanelSheet:position isSuperAdmin:YES];
        }else {
            if (myMember.type == NIMChatroomMemberTypeCreator || myMember.type == NIMChatroomMemberTypeManager) {
                if (myUid == member.userId.userIDValue) { //点击自己
                    [self showSelfPanel:myUid position:position];
                }else { //点击别人
                    [self showManagerPanelSheet:position];
                }
            }else{
                if ([GetCore(RoomCoreV2) getCurrentRoomInfo].roomModeType == RoomModeType_Open_Micro_Mode) {
                    if ([GetCore(RoomQueueCoreV2) isOnMicro:[GetCore(AuthCore) getUid].userIDValue]) {
                        [XCHUDTool showErrorWithMessage:@"你已经在麦上了"];
                    }else{
                        [XCHUDTool showErrorWithMessage:@"需要排麦才可以上麦哦~"];
                    }
                }
            }
        }
    }else{
        if (info.platformRole == XCUserInfoPlatformRoleSuperAdmin) {
            [self showManagerPanelSheet:position isSuperAdmin:YES];
        }else {
            if (myMember.type == NIMChatroomMemberTypeCreator || myMember.type == NIMChatroomMemberTypeManager) {
                [self showManagerPanelSheet:position];
            }else if (myMember.type == NIMChatroomMemberTypeNormal || myMember.type == NIMChatroomMemberTypeGuest) {
                
                BOOL isOnMic = [GetCore(RoomQueueCoreV2) isOnMicro:[GetCore(AuthCore) getUid].longLongValue];
                
                if (GetCore(RoomCoreV2).currenDragonFaceSendInfo) {
                    
                    TTAlertConfig *config = [[TTAlertConfig alloc] init];
                    config.title = @"提示";
                    config.message = @"您正在配对中，继续操作会视为放弃配对，确定进行此操作？";
                    
                    [TTPopup alertWithConfig:config confirmHandler:^{
                        
                        [GetCore(FaceCore) sendDragonWithState:Custom_Noti_Sub_Dragon_Cancel];
                        [GetCore(RoomQueueCoreV2) upMic:position.intValue];
                        
                    } cancelHandler:^{
                        
                    }];
                    
                }else{
                    if (self.roomInfo.roomModeType == RoomModeType_Open_Micro_Mode &&[GetCore(ArrangeMicCore).arrangeMicModel.myPos intValue] >0) {
                        [XCHUDTool showErrorWithMessage:@"取消报名才可以上麦哦！"];
                    } else if ([GetCore(ImRoomCoreV2) hasOpenGiftValue] && isOnMic) {
                        [self c_cleanGiftValueAlertWhenShiftMic:position];
                    }else{
                        NotifyCoreClient(CPGameCoreClient, @selector(suddenUpMic), suddenUpMic);
                        [GetCore(RoomQueueCoreV2) upMic:position.intValue];
                    }
                }
            }
        }
        
    }
}

#pragma mark - private method
//点自己
- (void)showSelfPanel:(UserID)uid position:(NSString *)position {
    
    @weakify(self);
    NSMutableArray *items = [NSMutableArray array];
    
    [items addObject:[TTActionSheetConfig normalTitle:@"查看资料" clickAction:^{
        @strongify(self);
        [self ttShowUserCard:uid isGaming:YES];
    }]];
    
    [items addObject:[TTActionSheetConfig normalTitle:@"下麦旁听" clickAction:^{
        @strongify(self);
        if (GetCore(RoomCoreV2).currenDragonFaceSendInfo) {
            
            TTAlertConfig *config = [[TTAlertConfig alloc] init];
            config.title = @"提示";
            config.message = @"您正在配对中，继续操作会视为放弃配对，确定进行此操作？";
            
            [TTPopup alertWithConfig:config confirmHandler:^{
                [GetCore(FaceCore) sendDragonWithState:Custom_Noti_Sub_Dragon_Cancel];
                [GetCore(RoomQueueCoreV2) downMic];
            } cancelHandler:^{
                
            }];
            
        } else if (GetCore(ImRoomCoreV2).currentRoomInfo.isOpenGame){
            
            TTAlertConfig *config = [[TTAlertConfig alloc] init];
            config.title = @"提示";
            config.message = @"您正在游戏中，继续操作将退出游戏，确定进行此操作？";
            
            @weakify(self)
            [TTPopup alertWithConfig:config confirmHandler:^{
                @strongify(self)
                self.firstEnterRoom = YES;
                [GetCore(RoomQueueCoreV2) downMic];
                
            } cancelHandler:^{
                
            }];
            
        } else if ([GetCore(ImRoomCoreV2) hasOpenGiftValue]) {
            [self c_cleanGiftValueAlertWhenDownMic];
        }else{
            [GetCore(RoomQueueCoreV2) downMic];
        }
    }]];
    
    //如果我是房主或者管理员，且麦是关的需要提示"解禁此座位"
    NIMChatroomMember *myMember = GetCore(RoomQueueCoreV2).myMember;
    MicroState *state = [GetCore(ImRoomCoreV2).micQueue objectForKey:position].microState;
    if (myMember.type == NIMChatroomMemberTypeCreator || myMember.type == NIMChatroomMemberTypeManager) {
        
        if (state.micState == MicroMicStateClose) {
            
            [items addObject:[TTActionSheetConfig normalTitle:@"解禁此座位" clickAction:^{
                [GetCore(RoomQueueCoreV2) openMic:position.intValue];
            }]];
        }
    }
    
    [TTPopup actionSheetWithItems:items.copy];
}


- (void)showManagerPanelSheet:(NSString *)position  isSuperAdmin:(BOOL)isSuperAdmin {
    MicroState *state = [GetCore(ImRoomCoreV2).micQueue objectForKey:position].microState;
    
    @weakify(self);
    NSMutableArray *items = [NSMutableArray array];
    if (!isSuperAdmin) {
        [items addObject:[TTActionSheetConfig normalTitle:@"上麦" clickAction:^{
            
            @strongify(self);
            
            BOOL isOnMic = [GetCore(RoomQueueCoreV2) isOnMicro:[GetCore(AuthCore) getUid].userIDValue];
            
            if (GetCore(RoomCoreV2).currenDragonFaceSendInfo) {
                
                TTAlertConfig *config = [[TTAlertConfig alloc] init];
                config.title = @"提示";
                config.message = @"您正在配对中，继续操作会视为放弃配对，确定进行此操作？";
                
                [TTPopup alertWithConfig:config confirmHandler:^{
                    
                    [GetCore(FaceCore) sendDragonWithState:Custom_Noti_Sub_Dragon_Cancel];
                    [GetCore(RoomQueueCoreV2) upMic:position.intValue];
                    
                } cancelHandler:^{
                    
                }];
                
            } else if ([GetCore(ImRoomCoreV2) hasOpenGiftValue] && isOnMic) {
                [self c_cleanGiftValueAlertWhenShiftMic:position];
            } else {
                [GetCore(RoomQueueCoreV2) upMic:position.intValue];
            }
        }]];
        
        [items addObject:[TTActionSheetConfig normalTitle:@"抱TA上麦" clickAction:^{
            @strongify(self);
            TTRoomOnlineListController *vc = [[TTRoomOnlineListController alloc] initWithOnlineListType:TTRoomOnlineListTypeWithoutMicro];
            [vc setSelectUserBlock:^(UserID uid) {
                if (uid == GetCore(AuthCore).getUid.userIDValue) {
                    [GetCore(RoomQueueCoreV2) upMic:position.intValue];
                } else {
                    [GetCore(RoomQueueCoreV2) inviteUpMic:uid postion:position];
                }
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }]];
    }
   
    if (state.posState == MicroPosStateFree) {
        if (self.roomInfo.roomModeType == RoomModeType_Open_Micro_Mode  && ![position isEqualToString:@"-1"]) {
            if (!isSuperAdmin) {
                [items addObject:[TTActionSheetConfig normalTitle:@"切换为排麦" clickAction:^{
                    [GetCore(RoomQueueCoreV2) lockMicPlace:position.intValue];
                }]];
            }
        }else{
            
            [items addObject:[TTActionSheetConfig normalTitle:@"锁麦" clickAction:^{
                if (isSuperAdmin) {
                    [GetCore(RoomQueueCoreV2) lockMicPlace:position.intValue success:^(BOOL success) {
                        if (success) {
                            [GetCore(RoomCoreV2) sendCustomMessageToManagerOutRoomWithTargetUid:0 targetName:nil position:position second:Custom_Noti_Sub_Room_SuperAdmin_LockMic];
                        }
                    }];
                }else {
                   [GetCore(RoomQueueCoreV2) lockMicPlace:position.intValue];
                }
                
            }]];
        }
    }else {
        if (self.roomInfo.roomModeType == RoomModeType_Open_Micro_Mode) {
            if (![position isEqualToString:@"-1"]) {
                if (!isSuperAdmin) {
                    [items addObject:[TTActionSheetConfig normalTitle:@"切换为自由麦" clickAction:^{
                        [GetCore(RoomQueueCoreV2) freeMicPlace:position.intValue];
                    }]];
                }
            }
        }else{
            if (!isSuperAdmin) {
                [items addObject:[TTActionSheetConfig normalTitle:@"解锁" clickAction:^{
                    [GetCore(RoomQueueCoreV2) freeMicPlace:position.intValue];
                }]];
            }
        }
        
    }
    
    if (state.micState == MicroMicStateOpen) {
        
        [items addObject:[TTActionSheetConfig normalTitle:@"闭麦" clickAction:^{
            if (isSuperAdmin) {
                [GetCore(RoomQueueCoreV2) closeMic:position.intValue success:^(BOOL success) {
                    if (success) {
                        [GetCore(RoomCoreV2) sendCustomMessageToManagerOutRoomWithTargetUid:0 targetName:nil position:position second:Custom_Noti_Sub_Room_SuperAdmin_noVoiceMic];
                    }
                }];
            }else {
               [GetCore(RoomQueueCoreV2) closeMic:position.intValue];
            }
        }]];
        
    }else {
        if (!isSuperAdmin) {
            [items addObject:[TTActionSheetConfig normalTitle:@"开麦" clickAction:^{
                [GetCore(RoomQueueCoreV2)openMic:position.intValue];
            }]];
        }
    }
    
    [TTPopup actionSheetWithItems:items.copy];
}

- (void)showManagerPanelSheet:(NSString *)position {
    
    [self showManagerPanelSheet:position isSuperAdmin:NO];
}

/// 更新房间话题
- (void)updateRoomTopic:(NSString *)roomTopic {
    
    if (self.roomInfo == nil) {
        NSAssert(NO, @"Fetch room info ERROR");
        return;
    }
    
    [self updateRoomInfoWithName:self.roomInfo.title
                        password:self.roomInfo.roomPwd
                           topic:roomTopic
                           tagId:self.roomInfo.tagId
              hasAnimationEffect:self.roomInfo.hasAnimationEffect
                    audioQuality:self.roomInfo.audioQuality
                       eventType:RoomUpdateEventTypeOther];
}

/// 更新房间信息
- (void)updateRoomInfoWithName:(NSString *)roomName
                      password:(NSString *)roomPwd
                         topic:(NSString *)roomTopic
                         tagId:(int)tagId
            hasAnimationEffect:(BOOL)hasAnimationEffect
                  audioQuality:(AudioQualityType)audioQuality
                     eventType:(RoomUpdateEventType)eventType {
    
    if (self.roomInfo == nil) {
        NSAssert(NO, @"Fetch room info ERROR");
        return;
    }
    
    NSDictionary *params = @{@"title": roomName ?: @"",
                             @"roomPwd": roomPwd ?: @"",
                             @"tagId": @(tagId),
                             @"roomDesc": roomTopic ?: @""
                             };
    if (GetCore(ImRoomCoreV2).myMember.type == NIMChatroomMemberTypeCreator) {
        [GetCore(RoomCoreV2) updateGameRoomInfo:params
                                           type:UpdateRoomInfoTypeUser
                             hasAnimationEffect:hasAnimationEffect
                                   audioQuality:audioQuality
                                      eventType:eventType];
        
    } else if (GetCore(ImRoomCoreV2).myMember.type == NIMChatroomMemberTypeManager) {
        [GetCore(RoomCoreV2) updateGameRoomInfo:params
                                           type:UpdateRoomInfoTypeManager
                             hasAnimationEffect:hasAnimationEffect
                                   audioQuality:audioQuality
                                      eventType:eventType];
    }
}

@end
