//
//  TTGameRoomViewController+FunctionMenu.m
//  TuTu
//
//  Created by KevinWang on 2018/11/3.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTGameRoomViewController+FunctionMenu.h"
#import "TTGameRoomViewController+RoomGift.h"
#import "TTGameRoomViewController+RoomShare.h"
#import "TTGameRoomSettingController.h"
#import "TTRoomRoleListController.h"
#import "TTGameRoomViewController+ArrangeMic.h"
#import "TTGameRoomViewController+CPGameView.h"
#import "TTGameRoomViewController+Private.h"
#import "TTGameRoomViewController+NormalRoomGame.h"
#import "TTGameRoomViewController+ChatMessage.h"
#import "TTGameRoomViewController+GiftValue.h"

//t
#import "XCMacros.h"
#import <IQKeyboardManager.h>
#import "FaceCore.h"
#import "ArrangeMicCore.h"
#import "ArrangeMicModel.h"
#import "ImMessageCore.h"
#import "RoomGiftValueCore.h"
#import "TTCPGameStaticCore.h"

// 邀请好友
#import "ShareModelInfor.h"
#import "ShareCore.h"
#import "XCMediator+TTDiscoverModuleBridge.h"
#import "XCMediator+TTPersonalMoudleBridge.h"
#import "TTPopup.h"

#import "TTRoomSettingsInputAlertView.h"
#import "TTStatisticsService.h"

@implementation TTGameRoomViewController (FunctionMenu)


#pragma mark - toolBarDelegate
// 选择了主功能
- (void)functionMenuView:(TTFunctionMenuView *)menuView didSelectMenuButton:(TTFunctionMenuButton *)menuButton {
    
    if (menuButton.type == TTFunctionMenuButtonType_Chat) {
        [IQKeyboardManager sharedManager].enable = NO;
        //聊天按钮
        if (GetCore(ImRoomCoreV2).currentRoomInfo.isCloseScreen) {
            [XCHUDTool showErrorWithMessage:@"房间公屏已关闭"];
            return;
        }
        [self.editTextFiled becomeFirstResponder];
        [self.view bringSubviewToFront:self.editContainerView];
        self.editContainerView.hidden = NO;
        [TTStatisticsService trackEvent:@"room_input_box_click" eventDescribe:@"底部文字输入框点击"];
        
    }else if (menuButton.type == TTFunctionMenuButtonType_MicroSwitch) {
        //麦克风
        if([GetCore(MeetingCore) setCloseMicro:!GetCore(MeetingCore).isCloseMicro]) {
            
            if (GetCore(MeetingCore).isCloseMicro) {
                [TTStatisticsService trackEvent:[self roomFullTrackName:TTStatisticsServiceRoomCloseMicClick] eventDescribe:@"关闭麦克风"];
            }
            
            [self updateMicroState:menuButton];
        }
    }else if (menuButton.type == TTFunctionMenuButtonType_VolumeSwitch) {
        //扬声器
        if ([GetCore(MeetingCore) setMute:!GetCore(MeetingCore).isMute]) {
            
            if (GetCore(MeetingCore).isMute) {
                [TTStatisticsService trackEvent:[self roomFullTrackName:TTStatisticsServiceRoomCloseSoundClick] eventDescribe:@"关闭声音"];
            }
            
            [self updateMuteState:menuButton];
        }
    }else if (menuButton.type == TTFunctionMenuButtonType_Face) {
        [TTStatisticsService trackEvent:[self roomFullTrackName:TTStatisticsServiceRoomEmojiClick] eventDescribe:@"表情面板按钮"];
        
        //表情
        [self selectedFaceFunction];
    }else if (menuButton.type == TTFunctionMenuButtonType_More) {
        self.moreToolBarButton = menuButton;
        //更多
        menuButton.selected = !menuButton.selected;
        if (menuButton.selected) {
            self.functionMenuView.functionMenuTypetype = TTFunctionMenuType_More;
        }else {
            //展示
            self.functionMenuView.functionMenuTypetype = TTFunctionMenuType_Normal;
        }
        
        [TTStatisticsService trackEvent:[self roomFullTrackName:TTStatisticsServiceRoomMoreClick] eventDescribe:@"更多面板按钮"];
        
        //布局toolBar更多功能
        [self layoutToolBarMoreFuntionUI];
        
    }else if ((menuButton.type == TTFunctionMenuButtonType_Game)){
        
        if (self.roomInfo.isOpenGame) {
            [self gameCloseRoomCPMode];
            //            [[BaiduMobStat defaultStat]logEvent:@"roomcp_game_open_click" eventLabel:@"游戏面板启动按钮"];
        }else{
            [[BaiduMobStat defaultStat]logEvent:@"roomcp_game_open_click" eventLabel:@"游戏面板启动按钮"];
            [self gameOpenRoomCPMode];
        }
    }else if (menuButton.type == TTFunctionMenuButtonType_Gift) {

        if (self.roomInfo.type == RoomType_CP) { // CP房间单独埋点
            [TTStatisticsService trackEvent:@"roomcp_gift_open_click" eventDescribe:@"CP房-礼物面板按钮"];
        } else {
            [TTStatisticsService trackEvent:[self roomFullTrackName:TTStatisticsServiceRoomGiftClick] eventDescribe:@"礼物面板按钮"];
        }
    
        [self ttShowSendGiftViewType:SelectGiftType_gift targetUid:0];
    } else if (menuButton.type == TTFunctionMenuButtonType_QueueMike) {
        [self ttShowArrangeMicVc]; // 排麦列表
        if (self.roomInfo.type == RoomType_Love) {
            [TTStatisticsService trackEvent:@"room_blinddate_join" eventDescribe:@"相亲房我要参加"];
        } else {
            [TTStatisticsService trackEvent:@"room_blinddate_join" eventDescribe:@"非相亲房我要参加"];
        }
    }else if (menuButton.type == TTFunctionMenuButtonType_RoomMessage){
        [self showRoomChatMessage];
    }
}
//选择了 更多中的二级功能
- (void)functionMenuView:(TTFunctionMenuView *)menuView didSelectMenuItem:(TTFunctionMenuItemTag)tag{
    NIMChatroomMember *mineMember = GetCore(RoomQueueCoreV2).myMember;
    switch (tag) {
        case TTFunctionMenuItemTag_GiftEffect_Open:
        case TTFunctionMenuItemTag_GiftEffect_Close:
        {
            GetCore(RoomCoreV2).hasChangeGiftEffectControl = YES;
            GetCore(RoomCoreV2).hasAnimationEffect = !GetCore(RoomCoreV2).hasAnimationEffect;
            if (GetCore(RoomCoreV2).hasAnimationEffect) {
                [XCHUDTool showSuccessWithMessage:@"礼物特效已开启"];
            }else{
                [XCHUDTool showSuccessWithMessage:@"礼物特效已关闭"];
            }
            [self updateRoomInfoLabel];
            [self functionMenuView:self.functionMenuView didSelectMenuButton:self.moreToolBarButton];
        }
            break;
        case TTFunctionMenuItemTag_RoomMessage_Open:
        case TTFunctionMenuItemTag_RoomMessage_Close:
        {
          UserInfo * info =  [GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue];
            if (info.platformRole == XCUserInfoPlatformRoleSuperAdmin) {
               [GetCore(RoomCoreV2) updateRoomMessageViewState:[GetCore(AuthCore)getUid].userIDValue isCloseScreen:!GetCore(ImRoomCoreV2).currentRoomInfo.isCloseScreen isSuperAdmin:YES];
            }else {
              [GetCore(RoomCoreV2) updateRoomMessageViewState:[GetCore(AuthCore)getUid].userIDValue isCloseScreen:!GetCore(ImRoomCoreV2).currentRoomInfo.isCloseScreen];
            }
            
            [self functionMenuView:self.functionMenuView didSelectMenuButton:self.moreToolBarButton];
        }
            break;
        case TTFunctionMenuItemTag_Room_OfficalManager:
        case TTFunctionMenuItemTag_Room_Setting:
        {
            TTGameRoomSettingController *vc = [[TTGameRoomSettingController alloc] init];
            [[TTRoomModuleCenter defaultCenter].currentNav pushViewController:vc animated:self];
        }
            break;
        case TTFunctionMenuItemTag_Room_Manager:
        {
            TTRoomRoleListController *roleListVc = [[TTRoomRoleListController alloc] init];
            roleListVc.role = TTRoomRoleManager;
            [[TTRoomModuleCenter defaultCenter].currentNav pushViewController:roleListVc animated:YES];
        }
            break;
        case TTFunctionMenuItemTag_Room_Limit:
        {
            [self setEnterRoomPermissions:mineMember];
        }
            break;
        case TTFunctionMenuItemTag_Room_Game:
        {
            [self updateFunctionMenu];
            // 普通房开启游戏模式
            [self normalRoomOperGameModel];
            [[BaiduMobStat defaultStat]logEvent:@"mp_room_game" eventLabel:@"点击游戏选择面板按钮"];
        }
            break;
        case TTFunctionMenuItemTag_Room_GuildManager:
        {
            [TTStatisticsService trackEvent:TTStatisticsServiceRoomHallManagerClick eventDescribe:@"厅管理入口"];
            
            // 公会管理
            UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_TTGuildViewController];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            case TTFunctionMenuItemTag_GiftValue_Close:
        {
            [self functionMenuView:self.functionMenuView didSelectMenuButton:self.moreToolBarButton];
            
            [self c_openGiftValue];
        }
            break;
        case TTFunctionMenuItemTag_GiftValue_Open:
        {
            [self functionMenuView:self.functionMenuView didSelectMenuButton:self.moreToolBarButton];
            
            [self c_closeGiftValue];
        }
            break;
        case TTFunctionMenuItemTag_Redbag_Open:
        {
            [self setRedbag:mineMember isClose:NO];
        }
            break;
       case TTFunctionMenuItemTag_Redbag_Close:
        {
             [self setRedbag:mineMember isClose:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - XCFaceViewKitDelegate
- (void)nobleFaceNoPermissionForLevel:(NSInteger)currentLevel needLevel:(NSInteger)needLevel {
    [TTPopup dismiss];
    
    TTOpenNobleTipCardView *cardView = [[TTOpenNobleTipCardView alloc] initWithCurrentLevel:MatchNobleNameUsingID(@(currentLevel).stringValue) doAction:@"" needLevel:MatchNobleNameUsingID(@(needLevel).stringValue)];
    cardView.delegate = self;
    [TTPopup popupView:cardView style:TTPopupStyleAlert];
}

#pragma mark - puble method

- (void)updateFunctionMenu {
    
    BOOL isDelete = self.functionMenuView.delegateSuperAdmin;
    if (![self.roomContainerView.subviews containsObject:self.messageVc.view]) {
        [self.functionMenuView removeFromSuperview];
        self.functionMenuView = nil;
        BOOL needAddSubview = YES;
        for (UIView *view in self.view.subviews) {
            if ([view isKindOfClass:[TTOffLineView class]]) {
                //房间关闭直播
                self.toolBarBgView.hidden = YES;
                needAddSubview = NO;
            }
        }
        
        NIMChatroomMember *mineMember = GetCore(RoomQueueCoreV2).myMember;
        NIMChatroomMember *minelastMember = GetCore(RoomQueueCoreV2).myLastMember;
        [self.functionMenuView.collectionView reloadData];
        
        if ([GetCore(RoomQueueCoreV2) isOnMicro:[GetCore(AuthCore)getUid].userIDValue] && self.roomInfo.hasDragonGame && !GetCore(VersionCore).loadingData) {
            self.gameStartBtn.hidden = NO;
            self.gameOpenBtn.hidden = NO;
            self.gameCancelBtn.hidden = NO;
            if (GetCore(RoomCoreV2).currenDragonFaceSendInfo) {
                self.gameStartBtn.enabled = NO;
                self.gameCancelBtn.hidden = NO;
                self.gameOpenBtn.hidden = NO;
                
            }else {
                self.gameStartBtn.enabled = YES;
                self.gameCancelBtn.hidden = YES;
                self.gameOpenBtn.hidden = YES;
                
            }
            if (self.roomInfo.type == RoomType_CP) {
                self.gameStartBtn.hidden = YES;
                self.gameCancelBtn.hidden = YES;
                self.gameOpenBtn.hidden = YES;
            }
        } else {
            self.gameStartBtn.hidden = YES;
            self.gameOpenBtn.hidden = YES;
            self.gameCancelBtn.hidden = YES;
        }
        //角色改变
        if (mineMember.type == minelastMember.type && self.functionMenuView) {
            return;
        }
        
        if (needAddSubview) {
            self.functionMenuView = [[TTFunctionMenuView alloc]init];
            self.functionMenuView.roomOwnerUserInfo = self.roomOwnerUserInfo;
            if (isDelete) {
                self.functionMenuView.delegateSuperAdmin = isDelete;
            }
            self.functionMenuView.delegate = self;
            self.functionMenuView.itemWidth = 36;
            self.functionMenuView.itemHeight = 36;
            self.functionMenuView.widthSpacing = 8;
            self.functionMenuView.items = [self getToolBarSubItems];
            [self.view addSubview:self.functionMenuView];
            self.functionMenuView.frame = CGRectMake(0, self.view.frame.size.height - self.functionMenuView.itemHeight-20-kSafeAreaTopHeight, KScreenWidth, self.functionMenuView.itemHeight+30);
            self.functionMenuView.currentUserOnMicStatus = [GetCore(RoomQueueCoreV2) isOnMicro:[GetCore(AuthCore)getUid].userIDValue];
            [self.functionMenuView layoutTheViews];
            self.toolBarBgView.hidden = YES;
            self.functionMenuView.bgView.hidden = YES;
            
            ///如果当前显示房间榜单页面，将其放到最前面 @xiaoxiao 崩溃隐藏
//            if ([self respondsToSelector:@selector(contributionContainerView)]) {
//                id view = [self valueForKey:@"contributionContainerView"];
//                if (view != nil) {
//                    if (!self.contributionContainerView.hidden) {
//                        [self.view bringSubviewToFront:self.contributionContainerView];
//                    }
//                }
//            }
          
        }
    }
}


#pragma mark - private method
//更新mute扬声器
- (void)updateMuteState:(TTFunctionMenuButton *)sender {
    sender.selected = GetCore(MeetingCore).isMute;
}

//更新voice麦克风
- (void)updateMicroState:(TTFunctionMenuButton *)sender {
    sender.enabled = GetCore(MeetingCore).actor;
    if (GetCore(MeetingCore).actor) {
        sender.selected = GetCore(MeetingCore).isCloseMicro;
    }
}

//选择表情功能
- (void)selectedFaceFunction {
    NSString *position = [GetCore(RoomQueueCoreV2)findThePositionByUid:[GetCore(AuthCore)getUid].userIDValue];
    if (position.length > 0 && position != nil) {
        if (self.roomFaceView == nil) {
            XCGameRoomFaceViewDisplayModel * displayModel = [self getGameRoomFaceViewDisplayModel];
            CGFloat hh = (displayModel.displayType == XCGameRoomFaceViewDisplayType_Noble) ? 274 : 234;
            self.roomFaceView = [[XCGameRoomFaceView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, hh) WithDisplayModel:displayModel];
            self.roomFaceView.delegate = self;
        }else {
            if (!self.roomFaceView.faceInfos) {
                self.roomFaceView.faceInfos = [GetCore(FaceCore) getFaceInfosType:RoomFaceTypeNormal];
                [self.roomFaceView.faceCollectionView reloadData];
            }
        }
        
        [TTPopup popupView:self.roomFaceView style:TTPopupStyleActionSheet];
        
    }else if (self.roomInfo.uid ==  [GetCore(AuthCore) getUid].userIDValue) {
        if (self.roomFaceView == nil) {
            self.roomFaceView  = [[XCGameRoomFaceView alloc] init];
            self.roomFaceView.delegate = self;
        }else {
            if (!self.roomFaceView.faceInfos) {
                self.roomFaceView.faceInfos = [GetCore(FaceCore)getFaceInfosType:RoomFaceTypeNormal];
                [self.roomFaceView.faceCollectionView reloadData];
            }
        }
        
        [TTPopup popupView:self.roomFaceView style:TTPopupStyleActionSheet];
        
    }else {
        [XCHUDTool showErrorWithMessage:@"需要上麦才可以发送表情噢"];
    }
}



//点击toolBar更多功能-更新布局toolBar的frame
- (void)layoutToolBarMoreFuntionUI{
    if (!self.functionMenuView) {
        return;
    }
    if (self.functionMenuView.functionMenuTypetype == TTFunctionMenuType_More) {
        
        CGFloat height = (self.functionMenuView.funArray.count > 5) ? 200 : 125;
        self.functionMenuView.frame = CGRectMake(0, self.view.frame.size.height - height -kSafeAreaTopHeight - kSafeAreaBottomHeight, KScreenWidth, height + kSafeAreaBottomHeight);
        [self.view insertSubview:self.toolBarBgView belowSubview:self.functionMenuView];
        self.toolBarBgView.hidden = NO;
        self.functionMenuView.bgView.hidden = NO;
    }else {
        self.functionMenuView.frame = CGRectMake(0, self.view.frame.size.height - self.functionMenuView.itemHeight-20-kSafeAreaTopHeight, KScreenWidth, self.functionMenuView.itemHeight+30);
        self.toolBarBgView.hidden = YES;
        self.functionMenuView.bgView.hidden = YES;
    }
}
//创建toolBar 的元素内容
- (NSMutableArray *)getToolBarSubItems {
    
    NIMChatroomMember *mineMember = GetCore(RoomQueueCoreV2).myMember;
    
    UserInfo *info = [GetCore(UserCore) getUserInfoInDB:[GetCore(AuthCore) getUid].userIDValue];
    BOOL superAdmin = info.platformRole == XCUserInfoPlatformRoleSuperAdmin;
    
    NSMutableArray *items = [NSMutableArray array];
    
    //非超管身份显示聊天框
    if (!superAdmin) {
        [items addObject:[self getFunctionMenuButton:TTFunctionMenuButtonType_Chat]];
    }
    
    if (mineMember) {
        
        if ([GetCore(RoomQueueCoreV2) isOnMicro:[GetCore(AuthCore)getUid].userIDValue]) {
            [items addObject:[self getFunctionMenuButton:TTFunctionMenuButtonType_MicroSwitch]];
            [items addObject:[self getFunctionMenuButton:TTFunctionMenuButtonType_VolumeSwitch]];
            [items addObject:[self getFunctionMenuButton:TTFunctionMenuButtonType_Face]];
        } else {
            [items addObject:[self getFunctionMenuButton:TTFunctionMenuButtonType_VolumeSwitch]];
        }
        
    } else {
        [items addObject:[self getFunctionMenuButton:TTFunctionMenuButtonType_VolumeSwitch]];
    }
    
    if (GetCore(TTGameStaticTypeCore).openRoomStatus != OpenRoomType_CP) {
        if (GetCore(RoomCoreV2).getCurrentRoomInfo.roomModeType == RoomModeType_Open_Micro_Mode) {
            if (!superAdmin) {
                // 开启排麦模式才显示排麦按钮
                [items addObject:[self getFunctionMenuButton:TTFunctionMenuButtonType_QueueMike]];
            }
        }
    }
    
    // 更多
    [items addObject:[self getFunctionMenuButton:TTFunctionMenuButtonType_RoomMessage]];
    
    // 更多
    [items addObject:[self getFunctionMenuButton:TTFunctionMenuButtonType_More]];
    
    
    if (GetCore(TTGameStaticTypeCore).openRoomStatus == OpenRoomType_CP) {
        if (mineMember.type == NIMChatroomMemberTypeCreator){
            if (projectType() != ProjectType_Planet) {
                // 只有游戏开关是打开的模式下，才添加游戏按钮
                if (GetCore(TTCPGameStaticCore).gameSwitch) {
                    [items addObject:[self getFunctionMenuButton:TTFunctionMenuButtonType_Game]];
                }
            }
        }
    }
    
    //非超管身份显示送礼物
    if (!superAdmin) {
        [items addObject:[self getFunctionMenuButton:TTFunctionMenuButtonType_Gift]];
    }
    
    return items;
}

//根据type创建XCToolBarButton
- (TTFunctionMenuButton *) getFunctionMenuButton:(TTFunctionMenuButtonType)type {
    
    TTFunctionMenuButton *btn = [[TTFunctionMenuButton alloc]init];
    btn.type = type;
    
    if (type == TTFunctionMenuButtonType_MicroSwitch) {
        [btn setButtonNormalImage:@"room_GameOpen_voice_logo"
                     disableImage:@"room_GameClose_voice_logo"
                    selectedImage:@"room_GameClose_voice_logo"];
        btn.enabled = GetCore(MeetingCore).actor;
        if (GetCore(MeetingCore).actor) {
            btn.selected = GetCore(MeetingCore).isCloseMicro;
        }
        
    } else if (type == TTFunctionMenuButtonType_VolumeSwitch) {
        [btn setButtonNormalImage:@"room_GameOpen_mute_logo"
                     disableImage:@""
                    selectedImage:@"room_GameClose_mute_logo"];
        btn.selected = GetCore(MeetingCore).isMute;
        
    }else if (type == TTFunctionMenuButtonType_Chat) {
        
        [btn setButtonNormalImage:@"room_GameChat_logo" disableImage:@"room_GameChat_logo" selectedImage:@"room_GameChat_logo"];
    }else if (type == TTFunctionMenuButtonType_Face) {
        
        [btn setButtonNormalImage:@"room_CPGame_face_btn" disableImage:@"room_CPGame_face_btn" selectedImage:@"room_CPGame_face_btn"];
    }else if (type == TTFunctionMenuButtonType_More) {
        
        [btn setButtonNormalImage:@"room_GameMore_logo" disableImage:@"room_GameMore_logo" selectedImage:@"room_GameMore_logo"];
    }else if (type == TTFunctionMenuButtonType_Game) {
        
        [btn setButtonNormalImage:@"room_game_logo" disableImage:@"room_game_logo" selectedImage:@"room_gameClose_logo"];
        if (self.roomInfo.isOpenGame) {
            btn.selected = YES;
        }else{
            btn.selected = NO;
        }
    }else if (type == TTFunctionMenuButtonType_Gift) {
        
        [btn setButtonNormalImage:@"room_gift_logo" disableImage:@"room_gift_logo" selectedImage:@"room_gift_logo"];
    } else if (type == TTFunctionMenuButtonType_QueueMike) {
        //        NSLog(@"%@", GetCore(ArrangeMicCore).arrangeMicModel);
        if (self.roomInfo.roomModeType == RoomModeType_Open_Micro_Mode) {
            if (GetCore(ArrangeMicCore).arrangeMicModel.count.integerValue > 0) {
                btn.selected = YES;
            }
        }
        
        if (GetCore(ImRoomCoreV2).currentRoomInfo.type == RoomType_Love) {
            [btn setButtonNormalImage:@"loveRoom_queueMic_normal" disableImage:@"loveRoom_queueMic_normal" selectedImage:@"loveRoom_queueMic_selected"];
        } else {
            [btn setButtonNormalImage:@"queueMic_normal" disableImage:@"queueMic_normal" selectedImage:@"queueMic_selected"];
        }
    }else if (type == TTFunctionMenuButtonType_RoomMessage){
        if (GetCore(ImMessageCore).getUnreadCount) {
            [btn setButtonNormalImage:@"room_new_message" disableImage:@"room_new_message" selectedImage:@"room_new_message"];
        }else{
            [btn setButtonNormalImage:@"room_nomal_message" disableImage:@"room_nomal_message" selectedImage:@"room_nomal_message"];
        }
    }
    return btn;
}

- (XCGameRoomFaceViewDisplayModel *)getGameRoomFaceViewDisplayModel{
    XCGameRoomFaceViewDisplayModel *faceDisplayModel = [[XCGameRoomFaceViewDisplayModel alloc] init];
    faceDisplayModel.displayType = XCGameRoomFaceViewDisplayType_Noble;
    
    faceDisplayModel.titles = [self getTitles];
    return faceDisplayModel;
}

- (NSMutableArray *)getTitles{
    
    XCGameRoomFaceTitleDisplayModel *normalTitle = [[XCGameRoomFaceTitleDisplayModel alloc] init];
    normalTitle.type = RoomFaceTypeNormal;
    normalTitle.title = @"普通表情";
    normalTitle.isSelected = YES;
    
    XCGameRoomFaceTitleDisplayModel *nobleTitle = [[XCGameRoomFaceTitleDisplayModel alloc] init];
    nobleTitle.type = RoomFaceTypeNoble;
    nobleTitle.title = @"贵族表情";
    nobleTitle.isSelected = NO;
    
    return @[normalTitle,nobleTitle].mutableCopy;
    
}
@end
