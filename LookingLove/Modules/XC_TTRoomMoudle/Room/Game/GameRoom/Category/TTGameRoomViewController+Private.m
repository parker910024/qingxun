//
//  TTGameRoomViewController+Private.m
//  TuTu
//
//  Created by KevinWang on 2018/11/3.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTGameRoomViewController+Private.h"
#import "TTGameRoomSettingController.h"
#import "XCMediator+TTPersonalMoudleBridge.h"
#import "TTWKWebViewViewController.h"
#import "XCHtmlUrl.h"
#import "ArrangeMicCore.h"
#import "TTGameCPPrivateChatModel.h"
#import "TTCPGamePrivateChatCore.h"
#import "TTRoomUIClient.h"
#import "TTDisplayModelMaker+RoomNormalGame.h"
#import "NormalRoomGameCache.h"
#import "TTGameRoomViewController+NormalRoomGame.h"
#import "XCMediator+TTDiscoverModuleBridge.h"
#import "XCMediator+TTRoomMoudleBridge.h" // 房间的bridge
#import "TTPopup.h"
#import "NSString+JsonToDic.h"
#import "TTStatisticsService.h"

@implementation TTGameRoomViewController (Private)

#pragma mark - puble method
//是否显示🎲
- (void)isShowTogetherButton{
    if (!GetCore(FaceCore).canPlayTogether) {
        self.togetherButton.hidden = YES;
    } else {
        self.togetherButton.hidden = YES;
    }
}

//主播下线
- (void)ttShowFinishLive{
    //避免在其他页面，如在线列表
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    if (self.hadShowFinishView) {
        return;
    }
    self.hadShowFinishView = YES;
    [TTPopup dismiss];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(roomExit)]) {
        [self.delegate roomExit];
    }
    
    
    NIMChatroomMember *mineMember = GetCore(RoomQueueCoreV2).myMember;
    if (mineMember.type != NIMChatroomMemberTypeCreator) {
        TTOffLineView *finishLiveView = [[TTOffLineView alloc] initWithUserId:self.roomOwnerUserInfo.uid];
        [self.view addSubview:finishLiveView];
    }else{
        if (self.roomInfo) {
            if (self.roomInfo.uid == GetCore(AuthCore).getUid.userIDValue){
                if (!self.roomInfo.valid) {
                    NSLog(@"房间已经关闭，并且我是房主");
                    TTOffLineView *finishLiveView = [[TTOffLineView alloc] initWithUserId:self.roomOwnerUserInfo.uid];
                    [self.view addSubview:finishLiveView];
                } else {
                    NSLog(@"房间信息存在，并且我是房主");
                }
            }else{
                TTOffLineView *finishLiveView = [[TTOffLineView alloc] initWithUserId:self.roomOwnerUserInfo.uid];
                [self.view addSubview:finishLiveView];
            }
        }else{
            NSLog(@"房间不存在");
            TTOffLineView *finishLiveView = [[TTOffLineView alloc] initWithUserId:self.roomOwnerUserInfo.uid];
            [self.view addSubview:finishLiveView];
        }
    }
    
}

//加入黑名单
- (void)ttShowAlertWithAddBlackList:(NIMChatroomMember *)member{
    
    TTAlertConfig *config = [[TTAlertConfig alloc] init];
    config.title = @"是否确定加入黑名单？";
    config.message = @"加入黑名单后你将收不到房主发送的消息";
    
    [TTPopup alertWithConfig:config confirmHandler:^{
        [XCHUDTool showSuccessWithMessage:@"加入黑名单成功"];
    } cancelHandler:^{
        
    }];
}

//举报
- (void)ttshowReportList{
    
    TTWKWebViewViewController *vc = [[TTWKWebViewViewController alloc]init];
    NSString *urlstr = [NSString stringWithFormat:@"%@?reportUid=%lld&source=ROOM",HtmlUrlKey(kReportURL),self.roomInfo.uid];
    vc.urlString = urlstr;
    [self.navigationController pushViewController:vc animated:YES];
    
}

//退出房间 超管操作
- (void)ttQuiteRoomByAdmin:(NIMChatroomBeKickedResult *)result {
    
    if (result.reason == 2) {
        if (result.ext && [[[[NSString dictionaryWithJsonString:result.ext] objectForKey:@"role"] stringValue] isEqualToString:@"1"]) {
            [XCHUDTool showSuccessWithMessage:@"系统检测涉嫌违规，你已请出房间"];
        }else {
            [XCHUDTool showSuccessWithMessage:@"您被管理员踢出直播间"];
        }
    } else if (result.reason == 5) {
        if (result.ext && [[[[NSString dictionaryWithJsonString:result.ext] objectForKey:@"role"] stringValue] isEqualToString:@"1"]) {
             [XCHUDTool showSuccessWithMessage:@"系统检测涉嫌违规，你已被加入黑名单"];
        }else {
          [XCHUDTool showSuccessWithMessage:@"您已被管理员拉黑"];
        }
    }
    
    [[TTRoomModuleCenter defaultCenter] dismissChannelViewWithQuitCurrentRoom:NO animation:YES completion:nil];
    
}

//退出房间
- (void)ttQuiteRoom:(int)reason {
    
    if (reason == 2) {
        [XCHUDTool showSuccessWithMessage:@"您被管理员踢出直播间"];
    } else if (reason == 5) {
        [XCHUDTool showSuccessWithMessage:@"您已被管理员拉黑"];
    }
    
    [[TTRoomModuleCenter defaultCenter] dismissChannelViewWithQuitCurrentRoom:NO animation:YES completion:nil];
}

//close
- (void)ttShowCloseList {
    
    @weakify(self);
    NSMutableArray *items = [NSMutableArray array];
    
//    if (GetCore(ImRoomCoreV2).currentRoomInfo.type != RoomType_Love) {
//        [items addObject:[TTActionSheetConfig normalTitle:@"随机进入嗨聊房" clickAction:^{
//            @strongify(self);
//            [self ttRandomEnterHotRoom];
//        }]];
//    }
    
    [items addObject:[TTActionSheetConfig normalTitle:@"退出房间" clickAction:^{
        @strongify(self);
        [self ttQuitRoomHandle];
    }]];
    
    // 如果是房主，才有权限关闭房间
    if (GetCore(RoomQueueCoreV2).myMember.type == NIMChatroomMemberTypeCreator) {
        [items addObject:[TTActionSheetConfig normalTitle:@"关闭房间" clickAction:^{
            @strongify(self);
            [self closeRoom];
            /// 退出房间关闭定时器
            [TTStatisticsService trackEvent:@"room_close" eventDescribe:@"房间-关闭"];
        }]];
    }
    
    [items addObject:[TTActionSheetConfig normalTitle:@"最小化房间" clickAction:^{
        @strongify(self);
        [self ttSetBeMiniRoom];
    }]];
    
    [items addObject:[TTActionSheetConfig normalTitle:@"举报房间" clickAction:^{
        @strongify(self);
        [self ttshowReportList];
    }]];
    
    [TTPopup actionSheetWithItems:items.copy];
}

/**
 随机进入嗨聊房
 */
- (void)ttRandomEnterHotRoom {
    [[BaiduMobStat defaultStat] logEvent:@"room_hiparty" eventLabel:@"随机进入嗨聊房"];
#ifdef DEBUG
    NSLog(@"room_hiparty");
#else
    
#endif

    if (self.roomInfo.type == RoomType_CP) {
        if ([GetCore(AuthCore) getUid].userIDValue == self.roomInfo.uid) {
            if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"enterHiChatRoom"] isEqualToString:@"EnterHiChatRoom"]){
                [[NSUserDefaults standardUserDefaults] setObject:@"EnterHiChatRoom" forKey:@"enterHiChatRoom"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                TTAlertConfig *config = [[TTAlertConfig alloc] init];
                config.title = @"提示";
                config.message = @"即将切换房间且解散房内用户";
                
                @weakify(self)
                [TTPopup alertWithConfig:config confirmHandler:^{
                    @strongify(self)
                    [XCHUDTool showGIFLoadingInView:self.view];
                    [GetCore(RoomCoreV2)closeRoomWithBlock:self.roomInfo.uid Success:^(UserID uid) {//close
                        [self closeCurrentRoomOpenNewRoom];
                        [XCHUDTool hideHUDInView:self.view];
                    } failure:^(NSNumber *resCode, NSString *message) {
                        [XCHUDTool hideHUDInView:self.view];
                    }];
                    
                } cancelHandler:^{
                    
                }];
                
            }else{
                [XCHUDTool showGIFLoading];
                [GetCore(RoomCoreV2)closeRoomWithBlock:self.roomInfo.uid Success:^(UserID uid) {//close
                    [self closeCurrentRoomOpenNewRoom];
                    [XCHUDTool hideHUD];
                } failure:^(NSNumber *resCode, NSString *message) {
                }];
            }
        }else{
            [self closeCurrentRoomOpenNewRoom];
        }
    }else{
        [self closeCurrentRoomOpenNewRoom];
    }
}

/// 关闭当前房间并进入一个嗨聊房
- (void)closeCurrentRoomOpenNewRoom {
    [[TTRoomModuleCenter defaultCenter] dismissChannelViewWithQuitCurrentRoom:YES animation:NO completion:^{
        [[GetCore(CPGameCore) userMatchGuildRoomListWithUid:GetCore(AuthCore).getUid.userIDValue] subscribeNext:^(id x) {
            if ([x isKindOfClass:[NSArray class]]) {
                NSArray *uids = (NSArray *)x;
                if (uids.count == 0) {
                    [XCHUDTool showErrorWithMessage:@"当前没有嗨聊房"];
                    return;
                }
                
                NSDictionary *dict = [uids firstObject];
                if (dict[@"uid"]) {
                    [[XCMediator sharedInstance] ttRoomMoudle_presentRoomViewControllerWithRoomUid:[dict[@"uid"] userIDValue] andNeedEdgeGesture:YES];
                }
            }
        }];
    }];
    [TTCPGameView attempDealloc];
}

- (void)closeRoom {
    [TTPopup alertWithMessage:@"关闭房间，并将房间内所有用户踢出，请谨慎操作" confirmHandler:^{
        [GetCore(RoomCoreV2) closeRoomWithBlock:GetCore(ImRoomCoreV2).currentRoomInfo.uid Success:^(UserID uid) {//close
            
        } failure:^(NSNumber *resCode, NSString *message) {
            
        }];
    } cancelHandler:^{
        
    }];
}

- (void)ttQuitRoomHandle {
    
    if (GetCore(RoomCoreV2).getCurrentRoomInfo.roomModeType == RoomModeType_Open_Micro_Mode && [GetCore(ArrangeMicCore).arrangeMicModel.myPos intValue] > 0) {
        
        TTAlertConfig *config = [[TTAlertConfig alloc] init];
        config.title = @"提示";
        config.message = @"退出房间后将退出目前排麦，再次进入需要重新排麦，确认退出房间吗？";
        
        [TTPopup alertWithConfig:config confirmHandler:^{
            
            [GetCore(ArrangeMicCore) userBegainOrCancleArrangeMicWith:1 operuid:[GetCore(AuthCore) getUid].userIDValue roomUid:GetCore(RoomCoreV2).getCurrentRoomInfo.uid];
            [[TTRoomModuleCenter defaultCenter] dismissChannelViewWithQuitCurrentRoom:YES];
            
        } cancelHandler:^{
            
        }];
        return ;
        
    }
    
    if (GetCore(RoomCoreV2).currenDragonFaceSendInfo) {
        
        TTAlertConfig *config = [[TTAlertConfig alloc] init];
        config.title = @"提示";
        config.message = @"您正在配对中，继续操作会视为放弃配对，确定进行此操作？";
        
        [TTPopup alertWithConfig:config confirmHandler:^{
            
            [GetCore(FaceCore) sendDragonWithState:Custom_Noti_Sub_Dragon_Cancel];
            [[TTRoomModuleCenter defaultCenter] dismissChannelViewWithQuitCurrentRoom:YES];
            
        } cancelHandler:^{
            
        }];
    }else{
        // 多人房有游戏退出时需要判断清除游戏
        if (self.roomInfo.type == RoomType_Game) { // 普通房
            [self ttCancelGameInviteFromCloseRoom];
        } else if (self.roomInfo.type == RoomType_Love) {
            [[TTRoomModuleCenter defaultCenter] dismissChannelViewWithQuitCurrentRoom:YES];
        } else {
            // 陪伴房
            if ([GetCore(AuthCore) getUid].userIDValue == self.roomInfo.uid) {
                [XCHUDTool showGIFLoading];
                [GetCore(RoomCoreV2)closeRoomWithBlock:self.roomInfo.uid Success:^(UserID uid) {//close
                    [[TTRoomModuleCenter defaultCenter] dismissChannelViewWithQuitCurrentRoom:YES];
                    [TTCPGameView attempDealloc];
                    [XCHUDTool hideHUDInView:self.view];
                } failure:^(NSNumber *resCode, NSString *message) {
                    [[TTRoomModuleCenter defaultCenter] dismissChannelViewWithQuitCurrentRoom:YES];
                    [TTCPGameView attempDealloc];
                    [XCHUDTool hideHUDInView:self.view];
                }];
            }else{
                if (self.roomInfo.isOpenGame) { // 陪伴房开启了游戏，最小化要清除游戏状态
                    if ([self.roomInfo.roomGame[@"status"] integerValue] == 3) {
                        if (GetCore(TTGameStaticTypeCore).selectGameForMe) {
                            [self.gamePlayView cancelPrepareAction];
                        }
                    }
                }
                [TTCPGameView attempDealloc];
                [[TTRoomModuleCenter defaultCenter] dismissChannelViewWithQuitCurrentRoom:YES];
            }
        }
    }
    GetCore(RoomCoreV2).hasChangeGiftEffectControl = NO;
}

//最小化
- (void)ttSetBeMiniRoom{
    [self.navigationController popViewControllerAnimated:YES];
    UserID myuid = [GetCore(AuthCore) getUid].longLongValue;
    
    if (GetCore(RoomCoreV2).currenDragonFaceSendInfo) {
        
        TTAlertConfig *config = [[TTAlertConfig alloc] init];
        config.title = @"提示";
        config.message = @"您正在配对中，继续操作会视为放弃配对，确定进行此操作？";
        
        [TTPopup alertWithConfig:config confirmHandler:^{
            
            [GetCore(FaceCore) sendDragonWithState:Custom_Noti_Sub_Dragon_Cancel];
            [[TTRoomModuleCenter defaultCenter] dismissChannelViewWithQuitCurrentRoom:NO];
            
        } cancelHandler:^{
            
        }];
        
    } else {
        
        if (self.roomInfo.type == RoomType_Game) { // 多人房开启了游戏，最小化要清除游戏状态
            [self miniRoomForGameTiming];
            
        }else if (self.roomInfo.isOpenGame) { // 陪伴房开启了游戏，最小化要清除游戏状态
            [self miniRoomForOpemGameAndStatusSelect];
        }else{
            [GetCore(FaceCore) sendDragonWithState:Custom_Noti_Sub_Dragon_Cancel];
            [[TTRoomModuleCenter defaultCenter] dismissChannelViewWithQuitCurrentRoom:NO];
        }
    }
}

// 多人房退出房间的时候要取消游戏邀请
- (void)ttCancelGameInviteFromCloseRoom{
    NSMutableDictionary *messsicDict = [[[NormalRoomGameCache shareNormalGameCache] takeOutMyOwnMessagesWithUid:GetCore(AuthCore).getUid] mutableCopy];
    
    NSArray *allKeyArray = messsicDict.allKeys;
    
    NSMutableArray *gameMessageArray = [NSMutableArray array];
    
    for (int i = 0; i < allKeyArray.count; i++) {
        TTMessageDisplayModel *messageModel = messsicDict[allKeyArray[i]];
        if (!messageModel.message.localExt) {
            [gameMessageArray addObject:messageModel];
            [messsicDict removeObjectForKey:allKeyArray[i]];
        }
    }
    [[NormalRoomGameCache shareNormalGameCache] saveGameMessageFromMeInfo:messsicDict];
    
    if (gameMessageArray.count > 0) {
        if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"firstMiniRoom"] isEqualToString:@"FirstMini"]){
            
            TTAlertConfig *config = [[TTAlertConfig alloc] init];
            config.title = @"提示";
            config.message = @"退出房间会取消当前游戏发起";
            
            @weakify(self)
            [TTPopup alertWithConfig:config confirmHandler:^{
                @strongify(self)
                [[NSUserDefaults standardUserDefaults] setObject:@"FirstMini" forKey:@"firstMiniRoom"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [self cancelGameAndMiniRoom:gameMessageArray];
                
                [[TTRoomModuleCenter defaultCenter] dismissChannelViewWithQuitCurrentRoom:YES];
                
            } cancelHandler:^{
                [[NSUserDefaults standardUserDefaults] setObject:@"FirstMini" forKey:@"firstMiniRoom"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }];
            
        }else{
            
            [self cancelGameAndMiniRoom:gameMessageArray];
            
            [[TTRoomModuleCenter defaultCenter] dismissChannelViewWithQuitCurrentRoom:YES];
        }
    }else{
        [[TTRoomModuleCenter defaultCenter] dismissChannelViewWithQuitCurrentRoom:YES];
    }
}

// 多人房最小化的时候要取消游戏邀请
- (void)ttExitRoomAndCancelGame:(NSMutableArray *)gameMessageArray{
    for (int i = 0; i < gameMessageArray.count; i++) {
        TTMessageDisplayModel *messageModel = gameMessageArray[i];
        NIMCustomObject *obj = (NIMCustomObject *)messageModel.message.messageObject;
        Attachment *attachment = (Attachment *)obj.attachment;
        TTGameCPPrivateChatModel *model = [TTGameCPPrivateChatModel modelDictionary:attachment.data];
        
        model.status = TTGameStatusTypeInvalid;
        
        messageModel.message.localExt = [model model2dictionary];
        
        [self miniRoomAndCancelMyGameStatusWithMessage:messageModel.message];
        
        [[TTDisplayModelMaker shareMaker] makeRoomNormalGameWithMessage:messageModel.message model:messageModel];
        
        [self.messageView.tableView reloadData];
    }
}

//余额不足
- (void)ttShowBalanceNotEnougth {
    
    //self.messageVc 不为空表示正在进行私聊送礼
    //此时房间和 session 各接收一次 onBalanceNotEnough 消息
    //return 防止多次弹窗
    if (self.messageVc) {
        return;
    }
    
    //防止多次充值弹窗
    static BOOL hasShowRechargeAlert = NO;
    if (hasShowRechargeAlert) {
        return;
    }
    
    hasShowRechargeAlert = YES;
    
    TTAlertConfig *config = [[TTAlertConfig alloc] init];
    config.title = @"余额不足";
    config.message = @"是否前往充值?";
    config.shouldDismissOnBackgroundTouch = NO;
    
    @weakify(self)
    [TTPopup alertWithConfig:config confirmHandler:^{
        
        @strongify(self);
        UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_rechargeController];
        [self.navigationController pushViewController:vc animated:YES];
        
        hasShowRechargeAlert = NO;
        
        if ([self.view.subviews containsObject:self.redDrawView] ||
            [self.view.subviews containsObject:self.redListView]) {
            [TTStatisticsService trackEvent:@"room_not_enough_money" eventDescribe:@"确认"];
        } else {
            [TTStatisticsService trackEvent:TTStatisticsServiceEventNotEnoughToRecharge eventDescribe:@"送礼物-房间内"];
        }
    } cancelHandler:^{
        hasShowRechargeAlert = NO;
        
        if ([self.view.subviews containsObject:self.redDrawView] ||
            [self.view.subviews containsObject:self.redListView]) {
            [TTStatisticsService trackEvent:@"room_not_enough_money" eventDescribe:@"取消"];
        }
    }];
}

/** 萝卜钱包余额不足 */
- (void)ttShowCarrotBalanceNotEnougth {
    
    [TTPopup dismiss];
    
    //防止多次萝卜不足弹窗
    static BOOL hasShowRadishAlert = NO;
    if (hasShowRadishAlert) {
        return;
    }
    
    hasShowRadishAlert = YES;
    
    TTAlertMessageAttributedConfig *moreAttrConf = [[TTAlertMessageAttributedConfig alloc] init];
    moreAttrConf.text = @"完成任务获取更多的萝卜";
    moreAttrConf.color = [XCTheme getTTMainColor];
    
    TTAlertConfig *config = [[TTAlertConfig alloc] init];
    config.message = @"您的萝卜不足,请前往任务中心\n完成任务获取更多的萝卜";
    config.messageAttributedConfig = @[moreAttrConf];
    config.confirmButtonConfig.title = @"前往";
    
    @weakify(self);
    [TTPopup alertWithConfig:config confirmHandler:^{
        
        // 前往任务中心
        @strongify(self);
        UIViewController *vc = [[XCMediator sharedInstance] ttDiscoverMoudle_TTMissionViewController];
        [self.navigationController pushViewController:vc animated:YES];
        
        hasShowRadishAlert = NO;
        
    } cancelHandler:^{
        hasShowRadishAlert = NO;
    }];
}

//被邀请上麦
- (void)ttShowInviteAlert{

    TTAlertConfig *config = [[TTAlertConfig alloc] init];
    config.title = @"房主或管理员拉你上麦";
    config.message = @"你已被房主或管理员拉上麦，但并未开启麦克风，需要说话，请打开麦克风";
    
    [TTPopup alertWithConfig:config confirmHandler:^{
        
    } cancelHandler:^{
        
    }];
}

//生成埋点全名：cp/mp + click
- (NSString *)roomFullTrackName:(NSString *)clickName {
    if (clickName == nil) {
        return @"";
    }
    
    NSString *prefix = self.roomInfo.type == RoomType_CP ? @"cp" : @"mp";
    NSString *fullName = [NSString stringWithFormat:@"%@_%@", prefix, clickName];
    
    return fullName;
}

/// 当前用户是否为超管
- (BOOL)isSuperAdmin {
    UserInfo *info = [GetCore(UserCore) getUserInfoInDB:[GetCore(AuthCore) getUid].userIDValue];
    BOOL superAdmin = info.platformRole == XCUserInfoPlatformRoleSuperAdmin;
    return superAdmin;
}

#pragma mark - private method
- (void)showBlackListAlerView {
    
    TTAlertConfig *config = [[TTAlertConfig alloc] init];
    config.title = @"是否确定加入黑名单？";
    config.message = @"加入黑名单后你将收不到房主发送的消息";
    
    [TTPopup alertWithConfig:config confirmHandler:^{
        [XCHUDTool showSuccessWithMessage:@"加入黑名单成功"];
    } cancelHandler:^{
        
    }];
}

- (void)hideRoomContainerViewData{
    for (UIView *subView in self.roomContainerView.subviews) {
        if (subView != self.roomContainerBgView) {
            [subView removeFromSuperview];
        }
    }
    self.roomContainerView.hidden = YES;
    
}

// 陪伴房选择游戏的人最小化房间
- (void)miniRoomForOpemGameAndStatusSelect{
    if ([self.roomInfo.roomGame[@"status"] integerValue] == 3) {
        if (GetCore(TTGameStaticTypeCore).selectGameForMe) {
            if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"CPMiniRoom"] isEqualToString:@"CPRoomFirstMini"]) {
                
                TTAlertConfig *config = [[TTAlertConfig alloc] init];
                config.title = @"提示";
                config.message = @"最小化房间会取消当前游戏发起";
                
                @weakify(self)
                [TTPopup alertWithConfig:config confirmHandler:^{
                    @strongify(self)
                    [[NSUserDefaults standardUserDefaults] setObject:@"CPRoomFirstMini" forKey:@"CPMiniRoom"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [self.gamePlayView cancelPrepareAction];
                    
                    [[TTRoomModuleCenter defaultCenter] dismissChannelViewWithQuitCurrentRoom:NO];
                    
                } cancelHandler:^{
                    [[NSUserDefaults standardUserDefaults] setObject:@"CPRoomFirstMini" forKey:@"CPMiniRoom"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }];
                
            }else{
                [self.gamePlayView cancelPrepareAction];
                [GetCore(FaceCore) sendDragonWithState:Custom_Noti_Sub_Dragon_Cancel];
                [[TTRoomModuleCenter defaultCenter] dismissChannelViewWithQuitCurrentRoom:NO];
            }
        }else{
            [GetCore(FaceCore) sendDragonWithState:Custom_Noti_Sub_Dragon_Cancel];
            [[TTRoomModuleCenter defaultCenter] dismissChannelViewWithQuitCurrentRoom:NO];
        }
    }else{
        [GetCore(FaceCore) sendDragonWithState:Custom_Noti_Sub_Dragon_Cancel];
        [[TTRoomModuleCenter defaultCenter] dismissChannelViewWithQuitCurrentRoom:NO];
    }
}

// 多人房最小化房间
- (void)miniRoomForGameTiming{
    NSMutableDictionary *messsicDict = [[[NormalRoomGameCache shareNormalGameCache] takeOutMyOwnMessagesWithUid:GetCore(AuthCore).getUid] mutableCopy];
    
    NSArray *allKeyArray = messsicDict.allKeys;
    
    NSMutableArray *gameMessageArray = [NSMutableArray array];
    
    for (int i = 0; i < allKeyArray.count; i++) {
        TTMessageDisplayModel *messageModel = messsicDict[allKeyArray[i]];
        if (!messageModel.message.localExt) {
            [gameMessageArray addObject:messageModel];
            [messsicDict removeObjectForKey:allKeyArray[i]];
        }
    }
    [[NormalRoomGameCache shareNormalGameCache] saveGameMessageFromMeInfo:messsicDict];
    
    if (gameMessageArray.count > 0) {
        if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"firstMiniRoom"] isEqualToString:@"FirstMini"]){
            
            TTAlertConfig *config = [[TTAlertConfig alloc] init];
            config.title = @"提示";
            config.message = @"最小化房间会取消当前游戏发起";
            
            @weakify(self)
            [TTPopup alertWithConfig:config confirmHandler:^{
                @strongify(self)
                [[NSUserDefaults standardUserDefaults] setObject:@"FirstMini" forKey:@"firstMiniRoom"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [self cancelGameAndMiniRoom:gameMessageArray];
                
                
                [GetCore(FaceCore) sendDragonWithState:Custom_Noti_Sub_Dragon_Cancel];
                [[TTRoomModuleCenter defaultCenter] dismissChannelViewWithQuitCurrentRoom:NO];
                
            } cancelHandler:^{
                [[NSUserDefaults standardUserDefaults] setObject:@"FirstMini" forKey:@"firstMiniRoom"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }];
            
        }else{
            
            [self cancelGameAndMiniRoom:gameMessageArray];
            
            [GetCore(FaceCore) sendDragonWithState:Custom_Noti_Sub_Dragon_Cancel];
            [[TTRoomModuleCenter defaultCenter] dismissChannelViewWithQuitCurrentRoom:NO];
        }
    }else{
        [GetCore(FaceCore) sendDragonWithState:Custom_Noti_Sub_Dragon_Cancel];
        [[TTRoomModuleCenter defaultCenter] dismissChannelViewWithQuitCurrentRoom:NO];
    }
    
}

// 取消游戏的方法。最小化和退出房间是一样的
- (void)cancelGameAndMiniRoom:(NSMutableArray *)gameMessageArray{
    for (int i = 0; i < gameMessageArray.count; i++) {
        TTMessageDisplayModel *messageModel = gameMessageArray[i];
        NIMCustomObject *obj = (NIMCustomObject *)messageModel.message.messageObject;
        Attachment *attachment = (Attachment *)obj.attachment;
        TTGameCPPrivateChatModel *model = [TTGameCPPrivateChatModel modelDictionary:attachment.data];
        
        model.status = TTGameStatusTypeInvalid;
        
        messageModel.message.localExt = [model model2dictionary];
        
        [self miniRoomAndCancelMyGameStatusWithMessage:messageModel.message];
        
        [[TTDisplayModelMaker shareMaker] makeRoomNormalGameWithMessage:messageModel.message model:messageModel];
        
        [self.messageView.tableView reloadData];
    }
}

//fengshuo start

//超管踢管理员的时候
- (void)ttReceiveSuperAdminMessageQuitRoomHandle {
    if (GetCore(RoomCoreV2).getCurrentRoomInfo.roomModeType == RoomModeType_Open_Micro_Mode && [GetCore(ArrangeMicCore).arrangeMicModel.myPos intValue] > 0){
        
        [GetCore(ArrangeMicCore) userBegainOrCancleArrangeMicWith:1 operuid:[GetCore(AuthCore) getUid].userIDValue roomUid:GetCore(RoomCoreV2).getCurrentRoomInfo.uid];
        [[TTRoomModuleCenter defaultCenter] dismissChannelViewWithQuitCurrentRoom:YES];
        return ;
        
    }
    
    if (GetCore(RoomCoreV2).currenDragonFaceSendInfo) {
        [GetCore(FaceCore) sendDragonWithState:Custom_Noti_Sub_Dragon_Cancel];
        [[TTRoomModuleCenter defaultCenter] dismissChannelViewWithQuitCurrentRoom:YES];
    }else{
        // 多人房有游戏退出时需要判断清除游戏
        if (self.roomInfo.type == RoomType_Game) { // 普通房
            [self ttCancelGameInviteFromCloseRoom];
        } else if (self.roomInfo.type == RoomType_Love) {
            [[TTRoomModuleCenter defaultCenter] dismissChannelViewWithQuitCurrentRoom:YES];
        } else {
            // 陪伴房
            if ([GetCore(AuthCore) getUid].userIDValue == self.roomInfo.uid) {
                [XCHUDTool showGIFLoading];
                [GetCore(RoomCoreV2)closeRoomWithBlock:self.roomInfo.uid Success:^(UserID uid) {//close
                    [[TTRoomModuleCenter defaultCenter] dismissChannelViewWithQuitCurrentRoom:YES];
                    [TTCPGameView attempDealloc];
                    [XCHUDTool hideHUDInView:self.view];
                } failure:^(NSNumber *resCode, NSString *message) {
                    [[TTRoomModuleCenter defaultCenter] dismissChannelViewWithQuitCurrentRoom:YES];
                    [TTCPGameView attempDealloc];
                    [XCHUDTool hideHUDInView:self.view];
                }];
            }else{
                if (self.roomInfo.isOpenGame) { // 陪伴房开启了游戏，最小化要清除游戏状态
                    if ([self.roomInfo.roomGame[@"status"] integerValue] == 3) {
                        if (GetCore(TTGameStaticTypeCore).selectGameForMe) {
                            [self.gamePlayView cancelPrepareAction];
                        }
                    }
                }
                [TTCPGameView attempDealloc];
                [[TTRoomModuleCenter defaultCenter] dismissChannelViewWithQuitCurrentRoom:YES];
            }
        }
    }
    GetCore(RoomCoreV2).hasChangeGiftEffectControl = NO;
}
//fengshuo end

@end
