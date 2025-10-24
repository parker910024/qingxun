//
//  TTGameRoomUserCardFunctionItemsConfig.m
//  TuTu
//
//  Created by KevinWang on 2018/12/1.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTGameRoomUserCardFunctionItemsConfig.h"

//tool
#import "XCCurrentVCStackManager.h"
#import "TTPopup.h"
#import "TTUserCardDelegate.h"
#import "NSString+JsonToDic.h"
//core
#import "AuthCore.h"
#import "PraiseCore.h"
#import "RoomCoreV2.h"
#import "GiftCore.h"
#import "RoomQueueCoreV2.h"
#import "FaceCore.h"
#import "ImRoomCoreV2.h"
#import "MeetingCore.h"
#import "CPGameCoreClient.h"
#import "TTGameStaticTypeCore.h"
#import "RoomGiftValueCore.h"

//toast
#import "XCHUDTool.h"

//view
#import "TTSendGiftView.h"
#import "TTGiftValueAlertView.h"
#import "TTPickMicView.h"

//bridge
#import "XCMediator+TTPersonalMoudleBridge.h"

///礼物值换麦清空提醒状态保存
static NSString *const kGiftValueShiftMicAlertStatusStoreKey = @"TTGameRoomViewControllerGiftValueShiftMicAlertStatus";

///礼物值下麦清空提醒状态保存
static NSString *const kGiftValueDownMicAlertStatusStoreKey = @"TTGameRoomViewControllerGiftValueDownMicAlertStatus";

///礼物值抱下麦清空提醒状态保存
static NSString *const kGiftValueKickMicAlertStatusStoreKey = @"TTGameRoomViewControllerGiftValueKickMicAlertStatus";

@interface TTGameRoomUserCardFunctionItemsConfig ()

@end

@implementation TTGameRoomUserCardFunctionItemsConfig

+ (RACSignal *)getFunctionItemsInGameRoomWithUid:(UserID)uid isSuperAdmin:(BOOL)isSuperAdmin {
    UserID myUid = [GetCore(AuthCore) getUid].userIDValue;
    NIMChatroomMember *myMember = GetCore(RoomQueueCoreV2).myMember;
    NSMutableArray *items = [NSMutableArray array];
    
    NSString *position = [GetCore(RoomQueueCoreV2) findThePositionByUid:uid];
    // 如果是离开模式，获取不到房主所在的房主位的坑位。所以需要自己指定
    if (GetCore(RoomCoreV2).getCurrentRoomInfo.leaveMode) {
        if (!position && (uid == GetCore(RoomCoreV2).getCurrentRoomInfo.uid)) {
            position = @"-1"; // 房主位
        }
    }
    ///清除礼物值
    TTUserCardFunctionItem *clearGiftValueItem = [[TTUserCardFunctionItem alloc]init];
    clearGiftValueItem.normalTitle = GetCore(ImRoomCoreV2).currentRoomInfo.type == RoomType_Love ? @"清除心动值" : @"清除礼物值";
    clearGiftValueItem.actionId = uid;
    clearGiftValueItem.isDisable = NO;
    clearGiftValueItem.type = TTUserCardFunctionItemType_PersonPage;
    [clearGiftValueItem setActionBolock:^(UserID uid, NSIndexPath *indexPath, TTUserCardFunctionItem *item) {
        
        UserID roomUID = GetCore(ImRoomCoreV2).currentRoomInfo.uid;
        [GetCore(RoomGiftValueCore) requestRoomGiftValueCleanWithRoomUid:roomUID micUid:uid];
    }];
    
    if (myUid == uid) {//自己点击自己
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            if (position) {
                
                TTUserCardFunctionItem *downItem = [[TTUserCardFunctionItem alloc]init];
                downItem.normalTitle = @"下麦旁听";
                downItem.actionId = uid;
                downItem.isDisable = NO;
                downItem.type = TTUserCardFunctionItemType_DownBySelf;
                [downItem setActionBolock:^(UserID uid, NSIndexPath *indexPath, TTUserCardFunctionItem *item) {
                    
                    [TTPopup dismiss];
                    
                    if ([GetCore(ImRoomCoreV2) hasOpenGiftValue]) {
                        
                        [self cleanGiftValueAlertWhenDownMic];
                        
                    } else if (GetCore(RoomCoreV2).currenDragonFaceSendInfo) {
                        
                        TTAlertConfig *config = [[TTAlertConfig alloc] init];
                        config.title = @"提示";
                        config.message = @"您正在配对中，继续操作会视为放弃配对，确定进行此操作？";
                        
                        [TTPopup alertWithConfig:config confirmHandler:^{
                            
                            [GetCore(FaceCore) sendDragonWithState:Custom_Noti_Sub_Dragon_Cancel];
                            [GetCore(RoomQueueCoreV2) downMic];
                            
                        } cancelHandler:^{
                            
                        }];
                        
                    }else{
                        if (GetCore(TTGameStaticTypeCore).openRoomStatus == OpenRoomType_CP) {
                            NotifyCoreClient(CPGameCoreClient, @selector(downMic), downMic);
                        }
                        [GetCore(RoomQueueCoreV2) downMic];
                    }
                }];
                
                
                
                if(myMember.type == NIMChatroomMemberTypeCreator || myMember.type == NIMChatroomMemberTypeManager){
                    
                    ChatRoomMicSequence *squence = [GetCore(RoomQueueCoreV2) findTheRoomQueueMemberInfo:uid];
                    //麦管理
                    TTUserCardFunctionItem *micItem = [[TTUserCardFunctionItem alloc]init];
                    micItem.normalTitle = @"闭麦";
                    micItem.actionId = uid;
                    micItem.isDisable = NO;
                    micItem.type = TTUserCardFunctionItemType_CloseMic;
                    [micItem setActionBolock:^(UserID uid, NSIndexPath *indexPath, TTUserCardFunctionItem *item) {
                        
                        [TTPopup dismiss];
                        
                        [[BaiduMobStat defaultStat]logEvent:@"data_dard_close_mic" eventLabel:@"资料卡片-闭麦"];
                        [GetCore(RoomQueueCoreV2)closeMic:position.intValue];
                    }];
                    
                    if (squence.microState.micState == MicroMicStateClose) {
                        
                        micItem.normalTitle = @"开麦";
                        micItem.type = TTUserCardFunctionItemType_OpenMic;
                        [micItem setActionBolock:^(UserID uid, NSIndexPath *indexPath, TTUserCardFunctionItem *item) {
                            
                            [TTPopup dismiss];
                            [GetCore(RoomQueueCoreV2)openMic:position.intValue];
                        }];
                    }
                    
                    
                    //坑位管理
                    TTUserCardFunctionItem *positionItem = [[TTUserCardFunctionItem alloc]init];
                    positionItem.normalTitle = @"锁麦";
                    positionItem.actionId = uid;
                    positionItem.isDisable = NO;
                    positionItem.type = TTUserCardFunctionItemType_LockPosition;
                    [positionItem setActionBolock:^(UserID uid, NSIndexPath *indexPath, TTUserCardFunctionItem *item) {
                        [[BaiduMobStat defaultStat]logEvent:@"data_dard_lock_mic" eventLabel:@"资料卡片-锁麦"];
                        RoomInfo * infor = [GetCore(RoomCoreV2) getCurrentRoomInfo];
                        if (infor.roomModeType == RoomModeType_Open_Micro_Mode) {
                            [XCHUDTool showErrorWithMessage:@"排麦模式不可以锁麦哦！"];
                        }else{
                            [TTPopup dismiss];
                             [GetCore(RoomQueueCoreV2) lockMicPlace:position.intValue];
                        }
                        
                    }];
                    
                    if (squence.microState.posState == MicroPosStateLock) {
                        positionItem.normalTitle = @"解锁";
                        positionItem.type = TTUserCardFunctionItemType_UnlockPosition;
                        [positionItem setActionBolock:^(UserID uid, NSIndexPath *indexPath, TTUserCardFunctionItem *item) {
                            if ([GetCore(RoomCoreV2) getCurrentRoomInfo].roomModeType == RoomModeType_Open_Micro_Mode) {
                                [XCHUDTool showErrorWithMessage:@"排麦模式不可以解锁哦！"];
                            }else{
                                
                                [TTPopup dismiss];
                                [GetCore(RoomQueueCoreV2) freeMicPlace:position.intValue];
                            }
                        }];
                    }
                    
                    [items addObject:micItem];
                    [items addObject:positionItem];
                    if (GetCore(TTGameStaticTypeCore).openRoomStatus == OpenRoomType_CP) {
                        if (myMember.type == NIMChatroomMemberTypeManager) {
                            [items addObject:downItem];
                        }
                    }else{
                        [items addObject:downItem];
                    }
                    
                    ///在麦上，且有管理权限，开启礼物值时
                    if ([GetCore(ImRoomCoreV2) hasOpenGiftValue]) {
                        [items addObject:clearGiftValueItem];
                    }
                    
                }else{
                    [items addObject:downItem];
                }
                
                // 如果是离开模式，而且是房主位，则不显示
                if (GetCore(RoomCoreV2).getCurrentRoomInfo.leaveMode &&
                    [position isEqualToString:@"-1"]) {
                    [items removeAllObjects]; // 自己点自己，只显示清除礼物值
                    // 离开模式下，开启了礼物值，才需要显示清除礼物值按钮
                    if (GetCore(RoomCoreV2).getCurrentRoomInfo.showGiftValue) {
                        [items addObject:clearGiftValueItem];
                    }
                }
                
                [subscriber sendNext:items];
                [subscriber sendCompleted];
            } else {
                ///如果不在麦上
                [subscriber sendNext:items];
                [subscriber sendCompleted];
            }
            
            return nil;
        }];
        
        
    }else{
        
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            [[GetCore(ImRoomCoreV2) rac_queryChartRoomMemberByUid:[NSString stringWithFormat:@"%lld",uid]] subscribeNext:^(id x) {
                
                NIMChatroomMember *targetMember  = (NIMChatroomMember *)x;
                
                if((myMember.type == NIMChatroomMemberTypeCreator || myMember.type == NIMChatroomMemberTypeManager) && !isSuperAdmin){
                    if(position) {
                        ChatRoomMicSequence *squence = [GetCore(RoomQueueCoreV2) findTheRoomQueueMemberInfo:uid];
                        
                        //麦管理
                        TTUserCardFunctionItem *micItem = [[TTUserCardFunctionItem alloc]init];
                        
                        
                        if (squence.microState.micState == MicroMicStateClose) {
                            
                            micItem.normalTitle = @"开麦";
                            micItem.type = TTUserCardFunctionItemType_OpenMic;
                            [micItem setActionBolock:^(UserID uid, NSIndexPath *indexPath, TTUserCardFunctionItem *item) {
                                
                                [TTPopup dismiss];
                                [GetCore(RoomQueueCoreV2)openMic:position.intValue];
                            }];
                            [items addObject:micItem];
                        }else{
                            
                            micItem.normalTitle = @"闭麦";
                            micItem.actionId = uid;
                            micItem.isDisable = NO;
                            micItem.type = TTUserCardFunctionItemType_CloseMic;
                            [micItem setActionBolock:^(UserID uid, NSIndexPath *indexPath, TTUserCardFunctionItem *item) {
                                
                                [TTPopup dismiss];
                                
                                [[BaiduMobStat defaultStat]logEvent:@"data_dard_close_mic" eventLabel:@"资料卡片-闭麦"];
                                [GetCore(RoomQueueCoreV2)closeMic:position.intValue];
                            }];
                            if (myMember.type == NIMChatroomMemberTypeCreator) {
                                [items addObject:micItem];
                            }else{//管理员不可对房主或者管理员闭麦
                                if (targetMember.type != NIMChatroomMemberTypeCreator &&  targetMember.type != NIMChatroomMemberTypeManager) {
                                    [items addObject:micItem];
                                }
                            }
                            
                        }
                        
                        //上下麦管理
                        TTUserCardFunctionItem *downItem = [[TTUserCardFunctionItem alloc]init];
                        downItem.normalTitle = @"抱TA下麦";
                        downItem.actionId = uid;
                        downItem.isDisable = NO;
                        downItem.type = TTUserCardFunctionItemType_MicDown;
                        [downItem setActionBolock:^(UserID uid, NSIndexPath *indexPath, TTUserCardFunctionItem *item) {
                            
                            [TTPopup dismiss];
                            
                            [[BaiduMobStat defaultStat]logEvent:@"data_dard_takeOut_mic" eventLabel:@"资料卡片-抱TA下麦"];
                            
                            if ([GetCore(ImRoomCoreV2) hasOpenGiftValue]) {
                                [self cleanGiftValueAlertWhenKickMic:uid postion:position];
                            } else {
                                [GetCore(RoomQueueCoreV2)kickDownMic:uid position:position.intValue];
                            }
                        }];
                        
                        if (myMember.type == NIMChatroomMemberTypeCreator) {
                            
                            [items addObject:downItem];
                        }else{ //管理员不可抱房主下麦
                            if (GetCore(TTGameStaticTypeCore).openRoomStatus != OpenRoomType_CP) {
                                if (targetMember.type != NIMChatroomMemberTypeCreator) {
                                    [items addObject:downItem];
                                }
                            }
                        }
                        
                        //坑位管理
                        TTUserCardFunctionItem *positionItem = [[TTUserCardFunctionItem alloc]init];
                        positionItem.normalTitle = @"锁麦";
                        positionItem.actionId = uid;
                        positionItem.isDisable = NO;
                        positionItem.type = TTUserCardFunctionItemType_LockPosition;
                        [positionItem setActionBolock:^(UserID uid, NSIndexPath *indexPath, TTUserCardFunctionItem *item) {
                            
                            [[BaiduMobStat defaultStat]logEvent:@"data_dard_lock_mic" eventLabel:@"资料卡片-锁麦"];
                            if ([GetCore(RoomCoreV2) getCurrentRoomInfo].roomModeType == RoomModeType_Open_Micro_Mode) {
                                [XCHUDTool showErrorWithMessage:@"排麦模式不可以锁麦哦！"];
                            }else{
                                
                                [TTPopup dismiss];
                                [GetCore(RoomQueueCoreV2) lockMicPlace:position.intValue];
                            }
                        }];
                        
                        if (squence.microState.posState == MicroPosStateLock) {
                            positionItem.normalTitle = @"解锁";
                            positionItem.type = TTUserCardFunctionItemType_UnlockPosition;
                            [positionItem setActionBolock:^(UserID uid, NSIndexPath *indexPath, TTUserCardFunctionItem *item) {
                                if ([GetCore(RoomCoreV2) getCurrentRoomInfo].roomModeType == RoomModeType_Open_Micro_Mode) {
                                    [XCHUDTool showErrorWithMessage:@"排麦模式不可以解锁哦！"];
                                }else{
                                    
                                    [TTPopup dismiss];
                                    [GetCore(RoomQueueCoreV2) freeMicPlace:position.intValue];
                                }
                            }];
                        }
                        
                        [items addObject:positionItem];
                        
                        ///在麦上，且有管理权限，开启礼物值时
                        if ([GetCore(ImRoomCoreV2) hasOpenGiftValue]) {
                            [items addObject:clearGiftValueItem];
                        }
                        
                    }else {
                        //上下麦管理
                        TTUserCardFunctionItem *upItem = [[TTUserCardFunctionItem alloc]init];
                        upItem.normalTitle = @"抱TA上麦";
                        upItem.actionId = uid;
                        upItem.isDisable = NO;
                        upItem.type = TTUserCardFunctionItemType_MicUp;
                        [upItem setActionUserBlock:^(UserInfo * _Nonnull userInfo, NSIndexPath * _Nonnull indexPath, TTUserCardFunctionItem * _Nonnull item) {
                            
                            if (userInfo.defUser == AccountType_Robot) {
                                [XCHUDTool showErrorWithMessage:@"该用户等级过低无法上麦"];
                            } else if (GetCore(RoomCoreV2).getCurrentRoomInfo.leaveMode &&
                                       userInfo.uid == GetCore(RoomCoreV2).getCurrentRoomInfo.uid) {
                                // 如果是离开模式下，抱房主上麦，不被允许
                                [XCHUDTool showErrorWithMessage:@"抱房主上麦请先解除离线模式"];
                            } else {
                                
                                [TTPopup dismiss];
                                if (GetCore(RoomCoreV2).getCurrentRoomInfo.type == RoomType_CP) {
                                    [GetCore(RoomQueueCoreV2) inviteUpFreeMic:uid];
                                } else {
                                    TTPickMicView *view = [[TTPickMicView alloc] initWithRoomType:GetCore(ImRoomCoreV2).currentRoomInfo.type uid:uid];
                                    [TTPopup popupView:view style:TTPopupStyleAlert];
                                }
                            }
                        }];
                        
                        [items addObject:upItem];
                    }
                    
                    // 离开模式下，针对房主位管理员仅有清除礼物值权限功能.
                    if (GetCore(RoomCoreV2).getCurrentRoomInfo.leaveMode &&
                        [position isEqualToString:@"-1"]) {
                        [items removeAllObjects];
                        // 离开模式下，开启了礼物值，才显示清除礼物值按钮
                        if (GetCore(RoomCoreV2).getCurrentRoomInfo.showGiftValue) {
                            [items addObject:clearGiftValueItem];
                        }
                    }

                }else if (isSuperAdmin) {
                    if(position) {
                        BOOL isLevelmodel = GetCore(RoomCoreV2).getCurrentRoomInfo.leaveMode;
                        ChatRoomMicSequence *squence = [GetCore(RoomQueueCoreV2) findTheRoomQueueMemberInfo:uid];
                        
                        //麦管理
                        TTUserCardFunctionItem *micItem = [[TTUserCardFunctionItem alloc]init];
                        
                        
                        if (squence.microState.micState == MicroMicStateOpen) {
                            micItem.normalTitle = @"闭麦";
                            micItem.actionId = uid;
                            micItem.isDisable = NO;
                            micItem.type = TTUserCardFunctionItemType_CloseMic;
                            [micItem setActionBolock:^(UserID uid, NSIndexPath *indexPath, TTUserCardFunctionItem *item) {
                                
                                [TTPopup dismiss];
                                
                                [[BaiduMobStat defaultStat]logEvent:@"data_dard_close_mic" eventLabel:@"资料卡片-闭麦"];
                                [GetCore(RoomQueueCoreV2)closeMic:position.intValue success:^(BOOL success) {
                                    if (success) {
                                        [GetCore(RoomCoreV2) sendCustomMessageToManagerOutRoomWithTargetUid:0 targetName:nil position:position second:Custom_Noti_Sub_Room_SuperAdmin_noVoiceMic];
                                    }
                                }];
                            }];
                            if (!isLevelmodel) {
                               [items addObject:micItem];
                            }
                           
                        }
                        
                        //上下麦管理
                        TTUserCardFunctionItem *downItem = [[TTUserCardFunctionItem alloc]init];
                        downItem.normalTitle = @"抱TA下麦";
                        downItem.actionId = uid;
                        downItem.isDisable = NO;
                        downItem.type = TTUserCardFunctionItemType_MicDown;
                        [downItem setActionBolock:^(UserID uid, NSIndexPath *indexPath, TTUserCardFunctionItem *item) {
                            
                            [TTPopup dismiss];
                            
                            [[BaiduMobStat defaultStat]logEvent:@"data_dard_takeOut_mic" eventLabel:@"资料卡片-抱TA下麦"];
                            
                            if ([GetCore(ImRoomCoreV2) hasOpenGiftValue]) {
                                [self cleanGiftValueAlertWhenKickMic:uid postion:position isSuperAdmin:YES];
                            } else {
                                [GetCore(RoomQueueCoreV2)kickDownMic:uid position:position.intValue success:^(NSString *nick, UserID uid) {
                                     [GetCore(RoomCoreV2) sendCustomMessageToManagerOutRoomWithTargetUid:uid targetName:nick position:nil second:Custom_Noti_Sub_Room_SuperAdmin_DownMic];
                                }];
                            }
                        }];
                        
                        //管理员不可抱房主下麦
                        if (GetCore(TTGameStaticTypeCore).openRoomStatus != OpenRoomType_CP && !isLevelmodel) {
                            [items addObject:downItem];
                        }
                        
                        if (squence.microState.posState == MicroPosStateFree) {
                            //坑位管理
                            TTUserCardFunctionItem *positionItem = [[TTUserCardFunctionItem alloc]init];
                            positionItem.normalTitle = @"锁麦";
                            positionItem.actionId = uid;
                            positionItem.isDisable = NO;
                            positionItem.type = TTUserCardFunctionItemType_LockPosition;
                            [positionItem setActionBolock:^(UserID uid, NSIndexPath *indexPath, TTUserCardFunctionItem *item) {
                                
                                [[BaiduMobStat defaultStat]logEvent:@"data_dard_lock_mic" eventLabel:@"资料卡片-锁麦"];
                                if ([GetCore(RoomCoreV2) getCurrentRoomInfo].roomModeType == RoomModeType_Open_Micro_Mode) {
                                    [XCHUDTool showErrorWithMessage:@"排麦模式不可以锁麦哦！"];
                                }else{
                                    
                                    [TTPopup dismiss];
                                    [GetCore(RoomQueueCoreV2) lockMicPlace:position.intValue success:^(BOOL success) {
                                        if (success) {
                                            [GetCore(RoomCoreV2) sendCustomMessageToManagerOutRoomWithTargetUid:0 targetName:nil position:position second:Custom_Noti_Sub_Room_SuperAdmin_LockMic];
                                        }
                                    }];
                                }
                            }];
                            if (!isLevelmodel) {
                                 [items addObject:positionItem];
                            }
                        }
                    }
            
                }else { // 普通用户
                    
                    // 离开模式下，针对房主位，普通用户无任何权限
                    if (GetCore(RoomCoreV2).getCurrentRoomInfo.leaveMode &&
                        [position isEqualToString:@"-1"]) {
                        [items removeAllObjects];
                    }
                }
                
                [subscriber sendNext:items];
                [subscriber sendCompleted];
            }];
            return nil;
        }];
    }
}

+ (RACSignal *)getFunctionItemsInGameRoomWithUid:(UserID)uid {
  return [self getFunctionItemsInGameRoomWithUid:uid isSuperAdmin:NO];
}


+ (RACSignal *)getCenterFunctionItemsInGameRoomWithUid:(UserID)uid isGaming:(BOOL)isGameing isSuperAdmin:(BOOL)isSuperAdmin {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        if (uid == [GetCore(AuthCore) getUid].userIDValue) {
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
            return nil;
        }
        NSMutableArray *items = [NSMutableArray array];
        NIMChatroomMember *myMember = GetCore(RoomQueueCoreV2).myMember;
        NSString *position =  [GetCore(RoomQueueCoreV2) findThePositionByUid:uid];
        
        if (isGameing && !isSuperAdmin) {
            TTUserCardFunctionItem *gift = [[TTUserCardFunctionItem alloc]init];
            gift.normalIcon = [UIImage imageNamed:@"usercard_sendgift_enable_icon"];
            gift.normalTitle = @"送礼物";
            gift.disableIcon = [UIImage imageNamed:@"usercard_sendgift_disable_icon"];
            gift.disableTitle = @"送礼物";
            [gift setActionUserBlock:^(UserInfo * _Nonnull userInfo, NSIndexPath * _Nonnull indexPath, TTUserCardFunctionItem * _Nonnull item) {
                
                [[BaiduMobStat defaultStat]logEvent:@"data_card_gift_send" eventLabel:@"资料卡片-送礼物"];
                
                [TTPopup dismiss];
                
                TTSendGiftView *giftView = [[TTSendGiftView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) usingPlace:XCSendGiftViewUsingPlace_Room roomUid:[GetCore(RoomCoreV2) getCurrentRoomInfo].uid];
                UserInfo *info = [[UserInfo alloc] init];
                info.uid = uid;
                giftView.targetInfo = info;
                giftView.delegate = [TTUserCardDelegate defaultDelegate];
                
                TTPopupConfig *config = [[TTPopupConfig alloc] init];
                config.contentView = giftView;
                config.style = TTPopupStyleActionSheet;
                
                [TTPopup popupWithConfig:config];
            }];
            gift.type = TTUserCardFunctionItemType_SendGift;
            gift.isDisable = NO;
            [items addObject:gift];
        }
        
        TTUserCardFunctionItem *magic = [[TTUserCardFunctionItem alloc]init];
        magic.normalIcon = [UIImage imageNamed:@"usercard_roomchat_enable_icon"];
        magic.normalTitle = @"私聊";
        magic.disableIcon = [UIImage imageNamed:@"usercard_roomchat_enable_icon"];
        magic.disableTitle = @"私聊";
        magic.type = TTUserCardFunctionItemType_RoomChat;
        magic.isDisable = NO;
        [items addObject:magic];
        
        if (!isSuperAdmin) {
            TTUserCardFunctionItem *dress = [[TTUserCardFunctionItem alloc]init];
            dress.normalIcon = [UIImage imageNamed:@"usercard_sendDress_enable_icon"];
            dress.normalTitle = @"送装扮";
            dress.disableIcon = [UIImage imageNamed:@"usercard_sendDress_enable_icon"];
            dress.disableTitle = @"送装扮";
            [dress setActionBolock:^(UserID uid, NSIndexPath *indexPath, TTUserCardFunctionItem *item) {
                
                [TTPopup dismiss];
                
                [[BaiduMobStat defaultStat]logEvent:@"data_card_decoration_send" eventLabel:@"资料卡片-施装扮"];
                UIViewController *vc = [[XCMediator sharedInstance]ttPersonalModule_DressUpShopViewControllerWithUid:uid index:0];
                [[[XCCurrentVCStackManager shareManager]currentNavigationController]pushViewController:vc animated:YES];
            }];
            dress.type = TTUserCardFunctionItemType_SendDress;
            dress.isDisable = NO;
            [items addObject:dress];
        }
       
        
        
        [[GetCore(ImRoomCoreV2) rac_queryChartRoomMemberByUid:[NSString stringWithFormat:@"%lld",uid]] subscribeNext:^(id x) {
            
            NIMChatroomMember *targetMember  = (NIMChatroomMember *)x;
            
            if (myMember.type == NIMChatroomMemberTypeCreator) {
                
                //踢人
                TTUserCardFunctionItem *kickedItem = [[TTUserCardFunctionItem alloc]init];
                kickedItem.type = TTUserCardFunctionItemType_Kick;
                kickedItem.isDisable = NO;
                kickedItem.normalIcon = [UIImage imageNamed:@"usercard_kick_enable_icon"];
                kickedItem.normalTitle = @"踢出房间";
                
                [kickedItem setActionBolock:^(UserID uid, NSIndexPath *indexPath, TTUserCardFunctionItem *item) {
                    
                    [TTPopup dismiss];
                    
                    [[BaiduMobStat defaultStat]logEvent:@"data_card_kickout_room" eventLabel:@"资料卡片-踢出房间"];
                    
                    UserInfo *userInfo = [GetCore(UserCore) getUserInfoInDB:uid];
                    NSString *message = [NSString stringWithFormat:@"是否需要将%@踢出房间？",userInfo.nick];
                    
                    TTAlertConfig *config = [[TTAlertConfig alloc] init];
                    config.title = @"操作提醒";
                    config.message = message;
                    
                    [TTPopup alertWithConfig:config confirmHandler:^{
                        
                        if (position) {
                            [GetCore(RoomQueueCoreV2) kickDownMic:uid position:position.intValue kickRoom:YES isBlack:NO success:^{
                                [GetCore(ImRoomCoreV2) kickUser:uid];
                            }];
                        } else {
                            [GetCore(ImRoomCoreV2) kickUser:uid];
                        }
                        
                    } cancelHandler:^{
                        
                    }];
                }];
                [items addObject:kickedItem];
                
                //管理员管理
                TTUserCardFunctionItem *managerItem = [[TTUserCardFunctionItem alloc]init];
                managerItem.isDisable = NO;
                managerItem.normalIcon = [UIImage imageNamed:@"usercard_manager_enable_icon"];
                managerItem.normalTitle = @"设为管理员";
                [managerItem setActionBolock:^(UserID uid, NSIndexPath *indexPath, TTUserCardFunctionItem *item) {
                    
                    [TTPopup dismiss];
                    
                    [[BaiduMobStat defaultStat]logEvent:@"data_card_set_admin" eventLabel:@"资料卡片-设为管理员"];
                    
                    [GetCore(ImRoomCoreV2)markManagerList:uid enable:YES];
                }];
                managerItem.type = TTUserCardFunctionItemType_SetManager;
                
                if (targetMember.type == NIMChatroomMemberTypeManager) {
                    
                    managerItem.normalIcon = [UIImage imageNamed:@"usercard_manager_disable_icon"];
                    managerItem.normalTitle = @"取消管理员";
                    [managerItem setActionBolock:^(UserID uid, NSIndexPath *indexPath, TTUserCardFunctionItem *item) {
                        
                        [TTPopup dismiss];
                        
                        [GetCore(ImRoomCoreV2)markManagerList:uid enable:NO];
                    }];
                    managerItem.type = TTUserCardFunctionItemType_CancelManager;
                }
                [items addObject:managerItem];
                
                //拉黑
                TTUserCardFunctionItem *backListItem = [[TTUserCardFunctionItem alloc]init];
                backListItem.isDisable = NO;
                backListItem.normalIcon = [UIImage imageNamed:@"usercard_blacklist_enable_icon"];
                backListItem.normalTitle = @"加入黑名单";
                [backListItem setActionBolock:^(UserID uid, NSIndexPath *indexPath, TTUserCardFunctionItem *item) {
                    
                    [TTPopup dismiss];
                    
                    [[BaiduMobStat defaultStat]logEvent:@"data_dard_join_blacklist" eventLabel:@"资料卡片-加入黑名单"];
                    
                    UserInfo *userInfo = [GetCore(UserCore) getUserInfoInDB:uid];
                    NSString *title = [NSString stringWithFormat:@"你正在拉黑%@",userInfo.nick];
                    
                    TTAlertConfig *config = [[TTAlertConfig alloc] init];
                    config.title = title;
                    config.message = @"拉黑后他将无法加入此房间";
                    
                    [TTPopup alertWithConfig:config confirmHandler:^{
                        
                        if (position) {
                            [GetCore(RoomQueueCoreV2) kickDownMic:uid position:position.intValue kickRoom:NO isBlack:YES success:^{
                                [GetCore(ImRoomCoreV2) markBlackList:uid enable:YES];
                            }];
                        } else {
                            [GetCore(ImRoomCoreV2) markBlackList:uid enable:YES];
                        }
                    } cancelHandler:^{
                        
                    }];
                    
                }];
                if ([GetCore(ImRoomCoreV2) isInBackList:uid]) {
                    backListItem.isDisable = NO;
                    backListItem.normalIcon = [UIImage imageNamed:@"usercard_blacklist_disable_icon"];
                    backListItem.normalTitle = @"已拉入黑名单";
                    [backListItem setActionBolock:^(UserID uid, NSIndexPath *indexPath, TTUserCardFunctionItem *item) {
                        
                    }];
                }
                
                
                backListItem.type = TTUserCardFunctionItemType_Black;
                [items addObject:backListItem];
                
                @weakify(items);
                [[GetCore(PraiseCore)rac_queryIsLike:[GetCore(AuthCore)getUid].userIDValue isLikeUid:uid]subscribeNext:^(id x) {
                    BOOL isLike = [x boolValue];
                    @strongify(items);
                    __block TTUserCardFunctionItem *foucus = [[TTUserCardFunctionItem alloc]init];
                    foucus.normalIcon = [UIImage imageNamed:@"usercard_focus_enable_icon"];
                    foucus.normalTitle = @"关注Ta";
                    foucus.disableIcon = [UIImage imageNamed:@"usercard_focus_disable_icon"];
                    foucus.disableTitle = @"已关注Ta";
                    foucus.isDisable = isLike;
                    [foucus setActionBolock:^(UserID uid, NSIndexPath *indexPath, TTUserCardFunctionItem *item) {
                        [[BaiduMobStat defaultStat]logEvent:@"data_card_follow" eventLabel:@"资料卡片-关注TA"];
                        if (item.isDisable) { //没关注
                            
                        }else {//已经关注
                            [[GetCore(PraiseCore)rac_praise:[GetCore(AuthCore)getUid].userIDValue WithBePraisedUid:uid]subscribeCompleted:^{
                                item.isDisable = !item.isDisable;
                            }];
                        }
                    }];
                    foucus.type = TTUserCardFunctionItemType_Foucs;
                    
                    if (isGameing) {
                        [items insertObject:foucus atIndex:3];
                    }else{
                        [items insertObject:foucus atIndex:1]; //不在gaming 不显示送礼物 施魔法
                    }
                    [subscriber sendNext:items];
                    [subscriber sendCompleted];
                } error:^(NSError *error) {
                    [subscriber sendNext:items];
                    [subscriber sendCompleted];
                }];
            }else if (myMember.type == NIMChatroomMemberTypeManager && !isSuperAdmin){
                
                if (targetMember.type != NIMChatroomMemberTypeCreator && targetMember.type != NIMChatroomMemberTypeManager){
                    
                    //踢人
                    TTUserCardFunctionItem *kickedItem = [[TTUserCardFunctionItem alloc]init];
                    kickedItem.normalIcon = [UIImage imageNamed:@"usercard_kick_enable_icon"];
                    kickedItem.normalTitle = @"踢出房间";
                    [kickedItem setActionBolock:^(UserID uid, NSIndexPath *indexPath, TTUserCardFunctionItem *item) {
                        
                        [[BaiduMobStat defaultStat]logEvent:@"data_card_kickout_room" eventLabel:@"资料卡片-踢出房间"];
                        
                        [TTPopup dismiss];
                        
                        UserInfo *userInfo = [GetCore(UserCore) getUserInfoInDB:uid];
                        NSString *message = [NSString stringWithFormat:@"是否需要将%@踢出房间？",userInfo.nick];
                        
                        TTAlertConfig *config = [[TTAlertConfig alloc] init];
                        config.title = @"操作提醒";
                        config.message = message;
                        
                        [TTPopup alertWithConfig:config confirmHandler:^{
                            if (position) {
                                [GetCore(RoomQueueCoreV2) kickDownMic:uid position:position.intValue kickRoom:YES isBlack:NO success:^{
                                    [GetCore(ImRoomCoreV2) kickUser:uid];
                                }];
                            } else {
                                [GetCore(ImRoomCoreV2) kickUser:uid];
                            }
                            [[NSUserDefaults standardUserDefaults] setObject:@"userLive" forKey:@"UserBeLiveMic"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            
                        } cancelHandler:^{
                            
                        }];
                    }];
                    kickedItem.type = TTUserCardFunctionItemType_Kick;
                    kickedItem.isDisable = NO;
                    [items addObject:kickedItem];
                    
                    
                    //拉黑
                    TTUserCardFunctionItem *backListItem = [[TTUserCardFunctionItem alloc]init];
                    backListItem.isDisable = NO;
                    backListItem.normalIcon = [UIImage imageNamed:@"usercard_blacklist_enable_icon"];
                    backListItem.normalTitle = @"加入黑名单";
                    [backListItem setActionBolock:^(UserID uid, NSIndexPath *indexPath, TTUserCardFunctionItem *item) {
                        
                        [[BaiduMobStat defaultStat]logEvent:@"data_dard_join_blacklist" eventLabel:@"资料卡片-加入黑名单"];
                        
                        [TTPopup dismiss];
                        
                        UserInfo *userInfo = [GetCore(UserCore) getUserInfoInDB:uid];
                        NSString *title = [NSString stringWithFormat:@"你正在拉黑%@",userInfo.nick];
                        
                        TTAlertConfig *config = [[TTAlertConfig alloc] init];
                        config.title = title;
                        config.message = @"拉黑后他将无法加入此房间";
                        
                        [TTPopup alertWithConfig:config confirmHandler:^{
                            
                            if (position) {
                                [GetCore(RoomQueueCoreV2) kickDownMic:uid position:position.intValue];
                            }
                            [GetCore(ImRoomCoreV2) markBlackList:uid enable:YES];
                            
                        } cancelHandler:^{
                            
                        }];
                    }];
                    backListItem.type = TTUserCardFunctionItemType_Black;
                    [items addObject:backListItem];
                }
                
                @weakify(items);
                [[GetCore(PraiseCore)rac_queryIsLike:[GetCore(AuthCore)getUid].userIDValue isLikeUid:uid]subscribeNext:^(id x) {
                    BOOL isLike = [x boolValue];
                    @strongify(items);
                    __block TTUserCardFunctionItem *foucus = [[TTUserCardFunctionItem alloc]init];
                    foucus.normalIcon = [UIImage imageNamed:@"usercard_focus_enable_icon"];
                    foucus.normalTitle = @"关注Ta";
                    foucus.disableIcon = [UIImage imageNamed:@"usercard_focus_disable_icon"];
                    foucus.disableTitle = @"已关注Ta";
                    foucus.isDisable = isLike;
                    [foucus setActionBolock:^(UserID uid, NSIndexPath *indexPath, TTUserCardFunctionItem *item) {
                        [[BaiduMobStat defaultStat]logEvent:@"data_card_follow" eventLabel:@"资料卡片-关注TA"];
                        if (item.isDisable) { //没关注
                            
                        }else {//已经关注
                            [[GetCore(PraiseCore)rac_praise:[GetCore(AuthCore)getUid].userIDValue WithBePraisedUid:uid]subscribeCompleted:^{
                                item.isDisable = !item.isDisable;
                            }];
                        }
                    }];
                    foucus.type = TTUserCardFunctionItemType_Foucs;
                    
                    if (isGameing) {
                        [items insertObject:foucus atIndex:3];
                    }else{
                        [items insertObject:foucus atIndex:1]; //不在gaming 不显示送礼物 施魔法
                    }
                    [subscriber sendNext:items];
                    [subscriber sendCompleted];
                } error:^(NSError *error) {
                    [subscriber sendNext:items];
                    [subscriber sendCompleted];
                }];
                
            }else if (isSuperAdmin) {//超管踢人
                if (targetMember.type != NIMChatroomMemberTypeCreator){
                    //踢人
                    TTUserCardFunctionItem *kickedItem = [[TTUserCardFunctionItem alloc]init];
                    kickedItem.normalIcon = [UIImage imageNamed:@"usercard_kick_enable_icon"];
                    kickedItem.normalTitle = @"踢出房间";
                    [kickedItem setActionBolock:^(UserID uid, NSIndexPath *indexPath, TTUserCardFunctionItem *item) {
                        
                        [[BaiduMobStat defaultStat]logEvent:@"data_card_kickout_room" eventLabel:@"资料卡片-踢出房间"];
                        
                        [TTPopup dismiss];
                        
                        UserInfo *userInfo = [GetCore(UserCore) getUserInfoInDB:uid];
                        NSString *message = [NSString stringWithFormat:@"是否需要将%@踢出房间？",userInfo.nick];
                        
                        TTAlertConfig *config = [[TTAlertConfig alloc] init];
                        config.title = @"操作提醒";
                        config.message = message;
                        
                        [TTPopup alertWithConfig:config confirmHandler:^{
                            if (myMember.type == NIMChatroomMemberTypeManager) {
                                if (targetMember.type == NIMChatroomMemberTypeManager) {
                                    [GetCore(RoomCoreV2) sendCustomMessageToManagerOutRoomWithTargetUid:targetMember.userId.userIDValue targetName:targetMember.roomNickname position:nil second:Custom_Noti_Sub_Room_SuperAdmin_TickManagerRoom];
                                }else {
                                    if (position) {
                                        [GetCore(RoomQueueCoreV2) kickDownMic:uid position:position.intValue kickRoom:YES isBlack:NO success:^{
                                            [GetCore(ImRoomCoreV2) kickUser:uid successBlcok:^(BOOL success) {
                                                [GetCore(RoomCoreV2) sendCustomMessageToManagerOutRoomWithTargetUid:targetMember.userId.userIDValue targetName:targetMember.roomNickname position:nil second:Custom_Noti_Sub_Room_SuperAdmin_TickRoom];
                                            }];
                                        }];
                                    } else {
                                        [GetCore(ImRoomCoreV2) kickUser:uid successBlcok:^(BOOL success) {
                                            [GetCore(RoomCoreV2) sendCustomMessageToManagerOutRoomWithTargetUid:targetMember.userId.userIDValue targetName:targetMember.roomNickname position:nil second:Custom_Noti_Sub_Room_SuperAdmin_TickRoom];
                                        }];
                                    }
                                    [[NSUserDefaults standardUserDefaults] setObject:@"userLive" forKey:@"UserBeLiveMic"];
                                    [[NSUserDefaults standardUserDefaults] synchronize];
                                }
                                
                            }else {
                                //自己先变成管理员
                                [GetCore(RoomCoreV2) requsetRoomSettingSuperAdminWithTargetUid:GetCore(AuthCore).getUid.userIDValue opt:1 success:^(BOOL success) {
                                    if (success) {
                                        if (targetMember.type == NIMChatroomMemberTypeManager) {
                                            //他是管理员的话 就发消息 让他自己退出房间
                                            [GetCore(RoomCoreV2) sendCustomMessageToManagerOutRoomWithTargetUid:targetMember.userId.userIDValue targetName:targetMember.roomNickname position:nil second:Custom_Noti_Sub_Room_SuperAdmin_TickManagerRoom];
                                        }else {
                                            //不是管理员 我是管理员 直接踢
                                            if (position){
                                                [GetCore(RoomQueueCoreV2) kickDownMic:uid position:position.intValue kickRoom:YES isBlack:NO success:^{
                                                    [GetCore(ImRoomCoreV2) kickUser:uid successBlcok:^(BOOL success) {
                                                        [GetCore(RoomCoreV2) sendCustomMessageToManagerOutRoomWithTargetUid:targetMember.userId.userIDValue targetName:targetMember.roomNickname position:nil second:Custom_Noti_Sub_Room_SuperAdmin_TickRoom];
                                                    }];

                                                }];
                                            } else {
                                                [GetCore(ImRoomCoreV2) kickUser:uid successBlcok:^(BOOL success) {
                                                    [GetCore(RoomCoreV2) sendCustomMessageToManagerOutRoomWithTargetUid:targetMember.userId.userIDValue targetName:targetMember.roomNickname position:nil second:Custom_Noti_Sub_Room_SuperAdmin_TickRoom];
                                                }];

                                            }
                                            [[NSUserDefaults standardUserDefaults] setObject:@"userLive" forKey:@"UserBeLiveMic"];
                                            [[NSUserDefaults standardUserDefaults] synchronize];
                                        }
                                    }
                                }];
                            }
                            
                        } cancelHandler:^{
                            
                        }];
                    }];
                    kickedItem.type = TTUserCardFunctionItemType_Kick;
                    kickedItem.isDisable = NO;
                    [items addObject:kickedItem];
                    
                    
                    //拉黑
                    TTUserCardFunctionItem *backListItem = [[TTUserCardFunctionItem alloc]init];
                    backListItem.isDisable = NO;
                    backListItem.normalIcon = [UIImage imageNamed:@"usercard_blacklist_enable_icon"];
                    backListItem.normalTitle = @"加入黑名单";
                    [backListItem setActionBolock:^(UserID uid, NSIndexPath *indexPath, TTUserCardFunctionItem *item) {
                        
                        [[BaiduMobStat defaultStat]logEvent:@"data_dard_join_blacklist" eventLabel:@"资料卡片-加入黑名单"];
                        
                        [TTPopup dismiss];
                        
                        UserInfo *userInfo = [GetCore(UserCore) getUserInfoInDB:uid];
                        NSString *title = [NSString stringWithFormat:@"你正在拉黑%@",userInfo.nick];
                        
                        TTAlertConfig *config = [[TTAlertConfig alloc] init];
                        config.title = title;
                        config.message = @"拉黑后他将无法加入此房间";
                        
                        [TTPopup alertWithConfig:config confirmHandler:^{
                            [GetCore(RoomCoreV2) requsetRoomSettingSuperAdminWithTargetUid:uid opt:-1 success:^(BOOL success) {
                                if (success) {
                                    [GetCore(RoomCoreV2) sendCustomMessageToManagerOutRoomWithTargetUid:targetMember.userId.userIDValue targetName:targetMember.roomNickname position:position second:Custom_Noti_Sub_Room_SuperAdmin_Shield];
                                }
                            }];
                        } cancelHandler:^{
                            
                        }];
                    }];
                    backListItem.type = TTUserCardFunctionItemType_Black;
                    [items addObject:backListItem];
                }
                
                @weakify(items);
                [[GetCore(PraiseCore)rac_queryIsLike:[GetCore(AuthCore)getUid].userIDValue isLikeUid:uid]subscribeNext:^(id x) {
                    BOOL isLike = [x boolValue];
                    @strongify(items);
                    __block TTUserCardFunctionItem *foucus = [[TTUserCardFunctionItem alloc]init];
                    foucus.normalIcon = [UIImage imageNamed:@"usercard_focus_enable_icon"];
                    foucus.normalTitle = @"关注Ta";
                    foucus.disableIcon = [UIImage imageNamed:@"usercard_focus_disable_icon"];
                    foucus.disableTitle = @"已关注Ta";
                    foucus.isDisable = isLike;
                    [foucus setActionBolock:^(UserID uid, NSIndexPath *indexPath, TTUserCardFunctionItem *item) {
                        [[BaiduMobStat defaultStat]logEvent:@"data_card_follow" eventLabel:@"资料卡片-关注TA"];
                        if (item.isDisable) { //没关注
                            
                        }else {//已经关注
                            [[GetCore(PraiseCore)rac_praise:[GetCore(AuthCore)getUid].userIDValue WithBePraisedUid:uid]subscribeCompleted:^{
                                item.isDisable = !item.isDisable;
                            }];
                        }
                    }];
                    foucus.type = TTUserCardFunctionItemType_Foucs;
                    
                    [items addObject:foucus];
                    [subscriber sendNext:items];
                    [subscriber sendCompleted];
                } error:^(NSError *error) {
                    [subscriber sendNext:items];
                    [subscriber sendCompleted];
                }];
            }else {
                @weakify(items);
                [[GetCore(PraiseCore)rac_queryIsLike:[GetCore(AuthCore)getUid].userIDValue isLikeUid:uid]subscribeNext:^(id x) {
                    BOOL isLike = [x boolValue];
                    @strongify(items);
                    __block TTUserCardFunctionItem *foucus = [[TTUserCardFunctionItem alloc]init];
                    foucus.normalIcon = [UIImage imageNamed:@"usercard_focus_enable_icon"];
                    foucus.normalTitle = @"关注Ta";
                    foucus.disableIcon = [UIImage imageNamed:@"usercard_focus_disable_icon"];
                    foucus.disableTitle = @"已关注Ta";
                    foucus.isDisable = isLike;
                    [foucus setActionBolock:^(UserID uid, NSIndexPath *indexPath, TTUserCardFunctionItem *item) {
                        [[BaiduMobStat defaultStat]logEvent:@"data_card_follow" eventLabel:@"资料卡片-关注TA"];
                        if (item.isDisable) { //没关注
                            
                        }else {//已经关注
                            [[GetCore(PraiseCore)rac_praise:[GetCore(AuthCore)getUid].userIDValue WithBePraisedUid:uid]subscribeCompleted:^{
                                item.isDisable = !item.isDisable;
                            }];
                        }
                    }];
                    foucus.type = TTUserCardFunctionItemType_Foucs;
                    
                    [items addObject:foucus];
                    [subscriber sendNext:items];
                    [subscriber sendCompleted];
                } error:^(NSError *error) {
                    [subscriber sendNext:items];
                    [subscriber sendCompleted];
                }];
            }
        } error:^(NSError *error) {
            @weakify(items);
            [[GetCore(PraiseCore)rac_queryIsLike:[GetCore(AuthCore)getUid].userIDValue isLikeUid:uid]subscribeNext:^(id x) {
                BOOL isLike = [x boolValue];
                @strongify(items);
                __block TTUserCardFunctionItem *foucus = [[TTUserCardFunctionItem alloc]init];
                foucus.normalIcon = [UIImage imageNamed:@"usercard_focus_enable_icon"];
                foucus.normalTitle = @"关注Ta";
                foucus.disableIcon = [UIImage imageNamed:@"usercard_focus_disable_icon"];
                foucus.disableTitle = @"已关注Ta";
                foucus.isDisable = isLike;
                [foucus setActionBolock:^(UserID uid, NSIndexPath *indexPath, TTUserCardFunctionItem *item) {
                    [[BaiduMobStat defaultStat]logEvent:@"data_card_follow" eventLabel:@"资料卡片-关注TA"];
                    if (item.isDisable) { //没关注
                        
                    }else {//已经关注
                        [[GetCore(PraiseCore)rac_praise:[GetCore(AuthCore)getUid].userIDValue WithBePraisedUid:uid]subscribeCompleted:^{
                            item.isDisable = !item.isDisable;
                        }];
                    }
                }];
                foucus.type = TTUserCardFunctionItemType_Foucs;
                
                if (isGameing) {
                    [items insertObject:foucus atIndex:3];
                }else{
                    [items insertObject:foucus atIndex:1]; //不在gaming 不显示送礼物 施魔法
                }
                [subscriber sendNext:items];
                [subscriber sendCompleted];
            } error:^(NSError *error) {
                [subscriber sendNext:items];
                [subscriber sendCompleted];
            }];
        }];
        
        return nil;
    }];
}

+ (RACSignal *)getCenterFunctionItemsInGameRoomWithUid:(UserID)uid isGaming:(BOOL)isGameing{
    return [self getCenterFunctionItemsInGameRoomWithUid:uid isGaming:isGameing isSuperAdmin:NO];
}

#pragma mark - Private Methods
#pragma mark Clean Gift Value Alert
/**
 清空礼物值换麦弹窗提醒
 
 @param position 新麦位
 */
+ (void)cleanGiftValueAlertWhenShiftMic:(NSString *)position {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults boolForKey:kGiftValueShiftMicAlertStatusStoreKey]) {
        [GetCore(RoomQueueCoreV2) upMic:position.intValue];
        return;
    }
    
    TTGiftValueAlertView *alertView = [[TTGiftValueAlertView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth - 80, 220) text:GetCore(ImRoomCoreV2).currentRoomInfo.type == RoomType_Love ? @"更换麦位将会清除你当前的心动值，确认更换吗?" : @"更换麦位将会清除你当前的礼物值，确认更换吗?"];
    
    alertView.enterHandler = ^(BOOL notShowNextTime) {
        
        [TTPopup dismiss];
        
        [GetCore(RoomQueueCoreV2) upMic:position.intValue];
        
        // 如果是不再显示
        if (notShowNextTime) {
            [userDefaults setBool:notShowNextTime forKey:kGiftValueShiftMicAlertStatusStoreKey];
            [userDefaults synchronize];
        }
    };
    
    alertView.cancelHandler = ^{
        [TTPopup dismiss];
    };
    
    [TTPopup popupView:alertView style:TTPopupStyleAlert];
}

/**
 清空礼物值下麦弹窗提醒
 */
+ (void)cleanGiftValueAlertWhenDownMic {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults boolForKey:kGiftValueDownMicAlertStatusStoreKey]) {
        [GetCore(RoomQueueCoreV2) downMic];
        return;
    }
    
    TTGiftValueAlertView *alertView = [[TTGiftValueAlertView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth - 80, 220) text:GetCore(ImRoomCoreV2).currentRoomInfo.type == RoomType_Love ?
                                       @"下麦将会清除你当前的心动值，确认下麦吗？" :
                                       @"下麦将会清除你当前的礼物值，确认下麦吗？"];
    
    alertView.enterHandler = ^(BOOL notShowNextTime) {
        
        [TTPopup dismiss];
        
        [GetCore(RoomQueueCoreV2) downMic];
        
        // 如果是不再显示
        if (notShowNextTime) {
            [userDefaults setBool:notShowNextTime forKey:kGiftValueDownMicAlertStatusStoreKey];
            [userDefaults synchronize];
        }
    };
    alertView.cancelHandler = ^{
        [TTPopup dismiss];
    };
    
    [TTPopup popupView:alertView style:TTPopupStyleAlert];
}

/**
 清空礼物值抱Ta下麦弹窗提醒
 */
+ (void)cleanGiftValueAlertWhenKickMic:(UserID)uid postion:(NSString *)position {
    
    [self cleanGiftValueAlertWhenKickMic:uid postion:position isSuperAdmin:NO];
}

/**
 清空礼物值抱Ta下麦弹窗提醒 是不是超管
 */
+ (void)cleanGiftValueAlertWhenKickMic:(UserID)uid postion:(NSString *)position isSuperAdmin:(BOOL)isSuperAdmin {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults boolForKey:kGiftValueKickMicAlertStatusStoreKey]) {
        if (isSuperAdmin) {
            [GetCore(RoomQueueCoreV2) kickDownMic:uid position:position.intValue success:^(NSString *nick, UserID uid) {
                [GetCore(RoomCoreV2) sendCustomMessageToManagerOutRoomWithTargetUid:uid targetName:nick position:nil second:Custom_Noti_Sub_Room_SuperAdmin_DownMic];
            }];
        }else {
             [GetCore(RoomQueueCoreV2) kickDownMic:uid position:position.intValue];
        }
        return;
    }
    
    TTGiftValueAlertView *alertView = [[TTGiftValueAlertView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth - 80, 220) text:GetCore(ImRoomCoreV2).currentRoomInfo.type == RoomType_Love ? @"抱Ta下麦清除该用户当前的心动值，确认抱Ta下麦吗？" : @"抱Ta下麦清除该用户当前的礼物值，确认抱Ta下麦吗？"];
    
    alertView.enterHandler = ^(BOOL notShowNextTime) {
        
        [TTPopup dismiss];
        if (isSuperAdmin) {
            [GetCore(RoomQueueCoreV2) kickDownMic:uid position:position.intValue success:^(NSString *nick, UserID uid) {
                [GetCore(RoomCoreV2) sendCustomMessageToManagerOutRoomWithTargetUid:uid targetName:nick position:nil second:Custom_Noti_Sub_Room_SuperAdmin_DownMic];
            }];
        }else {
             [GetCore(RoomQueueCoreV2) kickDownMic:uid position:position.intValue];
        }
       
        
        // 如果是不再显示
        if (notShowNextTime) {
            [userDefaults setBool:notShowNextTime forKey:kGiftValueKickMicAlertStatusStoreKey];
            [userDefaults synchronize];
        }
    };
    alertView.cancelHandler = ^{
        [TTPopup dismiss];
    };
    
    [TTPopup popupView:alertView style:TTPopupStyleAlert];
}
@end
