//
//  TTGameRoomViewController+CPGameView.m
//  TuTu
//
//  Created by new on 2019/1/10.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTGameRoomViewController+CPGameView.h"
#import "TTGameRoomViewController+Private.h"

#import "ShareModelInfor.h"
#import "ShareCore.h"
#import "XCMediator.h"
#import "ImMessageCore.h"
#import "TTCPGameCustomModel.h"
#import "CPGameCoreClient.h"
#import "XCRedAuthorityAttachment.h"

#import "XCMediator+TTDiscoverModuleBridge.h"
#import "XCMediator+TTGameModuleBridge.h"
#import "TTPopup.h"
#import "TTStatisticsService.h"

#import "TTRoomKTVAlerView.h"
#import "TTRoomSettingsInputAlertView.h"
#import "TTGameRoomViewController+OppositeSex.h"
#import "TTGameRoomViewController+Red.h"

@implementation TTGameRoomViewController (CPGameView)


- (void)onSendCPGameMessageSuccess:(NIMMessage *)msg {
    NSLog(@"打开的回调");
    //    [GetCore(RoomCoreV2) addMessageToArray:msg];
}


-(void)onRecvChatRoomCustomMsg:(NIMMessage *)msg{
    NIMCustomObject *obj = (NIMCustomObject *)msg.messageObject;
    Attachment *att = (Attachment *)obj.attachment;
    

    
    TTCPGameCustomModel *modelCP = [TTCPGameCustomModel yy_modelWithJSON:att.data];
    
    if (modelCP.gameInfo) {
        for (int i = 0; i < GetCore(TTGameStaticTypeCore).privateMessageArray.count; i++) {
            CPGameListModel *gameModel = [CPGameListModel modelWithJSON:GetCore(TTGameStaticTypeCore).privateMessageArray[i]];
            if ([gameModel.gameId isEqualToString:modelCP.gameInfo.gameId]) {
                if (att.first == Custom_Noti_Header_CPGAME) {
                    TTCPGameCustomModel *cpAtt = [TTCPGameCustomModel yy_modelWithJSON:att.data];
                    self.isShowMessage = YES;
                    if (att.second == Custom_Noti_Sub_CPGAME_Select) { // 选择游戏
                        if ([GetCore(RoomQueueCoreV2) isOnMicro:GetCore(AuthCore).getUid.userIDValue]){
                            [self.gamePlayView selectGameAciton:cpAtt];;
                        }else{
                            [self.gamePlayView audienceCanReadyGameAction:cpAtt];
                        }
                        
                    } else if (att.second == Custom_Noti_Sub_CPGAME_Prepare) { // 接受邀请
                        [self.gamePlayView acceptGameBeginActionWithModel:cpAtt];
                    } else if (att.second == Custom_Noti_Sub_CPGAME_Start) {  //  游戏开始
                        if ([GetCore(RoomQueueCoreV2) isOnMicro:GetCore(AuthCore).getUid.userIDValue]){
                            [self.gamePlayView acceptGameBeginActionWithModel:cpAtt]; // 安卓直接游戏开始
                        }else{
                            
                            [self.gamePlayView HaveChoiceGameAndOtherPartyAcceptUI];
                            @KWeakify(self);
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                @KStrongify(self);
                                [self.gamePlayView gameBeginAudienceCanSeeGameAction];
                            });
                        }
                        
                    }
                }
                break;
            } else {
                self.isShowMessage = NO;
            }
        }
    }
    
    if (att.first == Custom_Noti_Header_CPGAME) {
        TTCPGameCustomModel *cpAtt = [TTCPGameCustomModel yy_modelWithJSON:att.data];
        if (self.isShowMessage) {
            if (att.second == Custom_Noti_Sub_CPGAME_End) { // 游戏结束
                if ([cpAtt.gameResultInfo.resultType isEqualToString:@"not_draw"]) {
                    if ([GetCore(RoomQueueCoreV2) isOnMicro:GetCore(AuthCore).getUid.userIDValue]){
                        [self.gamePlayView gamefailerAction:cpAtt];
                    }else{
                        [self.gamePlayView gameOverAudienceCanSeeGameAction:cpAtt];
                    }
                }else{
                    if ([GetCore(RoomQueueCoreV2) isOnMicro:GetCore(AuthCore).getUid.userIDValue]){
                        [self.gamePlayView gameOverAndNobodyWin:[cpAtt model2dictionary]];
                    }else{
                        [self.gamePlayView gameOverAndICanNotWatchWhoWin:cpAtt];
                    }
                }
            }
        }
        if (att.second == Custom_Noti_Sub_CPGAME_Cancel_Prepare) { // 取消准备
            if ([GetCore(RoomQueueCoreV2) isOnMicro:GetCore(AuthCore).getUid.userIDValue]){
                [self.gamePlayView refuseAction];
            }else{
                [self.gamePlayView audienceCanSeeGameAction:nil];
            }
        } else if (att.second == Custom_Noti_Sub_CPGAME_Open) {
            if (![GetCore(RoomQueueCoreV2) isOnMicro:GetCore(AuthCore).getUid.userIDValue]){
                [self.gamePlayView audienceCanSeeGameAction:nil];
            }else{
                [self.gamePlayView refuseAction];
            }
        }
    } else if (att.first == Custom_Noti_Header_RoomActivityHot) { // 活动暴击倒计时
        [self.roomActivityCycleTopLeftView countDownTimer:[att.data[@"limitTime"] integerValue]];
    }
}

#pragma mark - 设置房间红包
-  (void)setRedbag:(NIMChatroomMember *)mineMember isClose:(BOOL)isClose {
    if ([self isSuperAdmin]) {
        [XCHUDTool showErrorWithMessage:@"超管不能进行红包操作"];
        return;
    }
    
    if (mineMember.type == NIMChatroomMemberTypeManager) {
        [GetCore(RoomCoreV2) updateGameRoomInfo:@{@"closeRedPacket" : @(isClose)} type:UpdateRoomInfoTypeManager];
    }else if (mineMember.type == NIMChatroomMemberTypeCreator){
        [GetCore(RoomCoreV2) updateGameRoomInfo:@{@"closeRedPacket" : @(isClose)} type:UpdateRoomInfoTypeUser];
    }
    
    [TTStatisticsService trackEvent:@"room_red_paper_setting" eventDescribe:isClose ? @"关" : @"开"];
}

#pragma mark  - 进房限制
- (void)setEnterRoomPermissions:(NIMChatroomMember *)mineMember {
    
    @weakify(self);
    NSMutableArray *items = [NSMutableArray array];
    
    [items addObject:[TTActionSheetConfig normalTitle:@"仅邀请进入" selectColorType:[self.roomInfo.limitType isEqualToString:@"isInvite"] ? TTItemSelectHighLight : TTItemSelectNormal clickAction:^{
        @strongify(self)
        GetCore(TTGameStaticTypeCore).shareRoomOrInviteType = TTShareRoomOrInviteFriendStatus_Invite;
        ShareModelInfor * model = [[ShareModelInfor alloc] init];
        model.currentVC = self;
        model.roomInfor = self.roomInfo;
        model.shareType = Custom_Noti_Sub_Share_Room;
        [GetCore(ShareCore) reloadShareModel:model];
        UIViewController * controller = [[XCMediator sharedInstance] ttDiscoverMoudle_TTFamilyShareContainViewController];
        [self.navigationController pushViewController:controller animated:YES];
        [[BaiduMobStat defaultStat] logEvent:@"roomcp_roomlimit_inv_click" eventLabel:@"仅邀请进入"];
    }]];
    
    [items addObject:[TTActionSheetConfig normalTitle:@"仅好友进入" selectColorType:[self.roomInfo.limitType isEqualToString:@"isFriend"] ? TTItemSelectHighLight : TTItemSelectNormal clickAction:^{
        @strongify(self)
        NSDictionary *params = @{@"title": self.roomInfo.title ?: @"",
                                 @"roomPwd": @"",
                                 @"tagId": @(self.roomInfo.tagId),
                                 @"limitType":@"isFriend",
                                 };
        
        if (mineMember.type == NIMChatroomMemberTypeManager) {
            [GetCore(RoomCoreV2) updateGameRoomInfo:params
                                               type:UpdateRoomInfoTypeManager
                                 hasAnimationEffect:self.roomInfo.hasAnimationEffect
                                       audioQuality:self.roomInfo.audioQuality
                                          eventType:RoomUpdateEventTypeOther];
        }else if (mineMember.type == NIMChatroomMemberTypeCreator){
            [GetCore(RoomCoreV2) updateGameRoomInfo:params
                                               type:UpdateRoomInfoTypeUser
                                 hasAnimationEffect:self.roomInfo.hasAnimationEffect
                                       audioQuality:self.roomInfo.audioQuality
                                          eventType:RoomUpdateEventTypeOther];
        }
        
        [[BaiduMobStat defaultStat] logEvent:@"roomcp_roomlimit_fri_click" eventLabel:@"仅好友进入"];
        [XCHUDTool showSuccessWithMessage:@"设置成功"];
    }]];
    
    [items addObject:[TTActionSheetConfig normalTitle:@"仅密码进入" selectColorType:[self.roomInfo.limitType isEqualToString:@"lock"] ? TTItemSelectHighLight : TTItemSelectNormal clickAction:^{
        @strongify(self)
        [[BaiduMobStat defaultStat] logEvent:@"roomcp_roomlimit_paw_click" eventLabel:@"仅密码进入"];
        
        TTRoomSettingsInputAlertView *alertShow = [[TTRoomSettingsInputAlertView alloc] init];
        alertShow.title = @"房间密码";
        alertShow.placeholder = @"请输入房间密码";
        alertShow.content = self.roomInfo.roomPwd;
        alertShow.maxCount = 8;
        alertShow.minCount = 1;
        alertShow.keyboardType = UIKeyboardTypeNumberPad;
        
        [alertShow showAlertWithCompletion:^(NSString * _Nonnull content) {
            
            NSDictionary *params = @{@"title": self.roomInfo.title ?: @"",
                                     @"roomPwd": content ?: @"",
                                     @"tagId": @(self.roomInfo.tagId),
                                     @"limitType":@"lock",
                                     };
            if (mineMember.type == NIMChatroomMemberTypeManager) {
                [GetCore(RoomCoreV2) updateGameRoomInfo:params
                                                   type:UpdateRoomInfoTypeManager
                                     hasAnimationEffect:self.roomInfo.hasAnimationEffect
                                           audioQuality:self.roomInfo.audioQuality
                                              eventType:RoomUpdateEventTypeOther];
            }else if (mineMember.type == NIMChatroomMemberTypeCreator){
                [GetCore(RoomCoreV2) updateGameRoomInfo:params
                                                   type:UpdateRoomInfoTypeUser
                                     hasAnimationEffect:self.roomInfo.hasAnimationEffect
                                           audioQuality:self.roomInfo.audioQuality
                                              eventType:RoomUpdateEventTypeOther];
            }
            
        } dismiss:^{
            
        }];
    }]];
    
    [items addObject:[TTActionSheetConfig normalTitle:@"取消限制" clickAction:^{
        NSDictionary *params = @{@"title": self.roomInfo.title ?: @"",
                                 @"roomPwd": @"",
                                 @"tagId": @(self.roomInfo.tagId),
                                 @"limitType":@"",
                                 };
        if (mineMember.type == NIMChatroomMemberTypeManager || mineMember.type == NIMChatroomMemberTypeCreator) {
            UpdateRoomInfoType infoType;
            if (mineMember.type == NIMChatroomMemberTypeManager) {
                infoType = UpdateRoomInfoTypeManager;
            } else {
                infoType = UpdateRoomInfoTypeUser;
            }
            [GetCore(RoomCoreV2) updateGameRoomInfo:params
                                               type:infoType
                                 hasAnimationEffect:self.roomInfo.hasAnimationEffect
                                       audioQuality:self.roomInfo.audioQuality
                                          eventType:RoomUpdateEventTypeOther];
        }
    }]];
    
    [TTPopup actionSheetWithItems:items.copy];
}

#pragma mark --- CPGameCoreClient ---

// 两个人在房间里面玩游戏
-(void)onCPRoomGameUrl:(NSString *)gameUrlString{
    
    [XCHUDTool showGIFLoading];
    @KWeakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @KStrongify(self);
        [XCHUDTool hideHUD];
        if ([[self topViewController] isKindOfClass:NSClassFromString(@"TTWkGameViewController")]) {
            NSLog(@"webView已经有了");
            return;
        }
        UIViewController *gameVC = [[XCMediator sharedInstance] ttGameMoudle_TTWkGameViewControllerWithUrlStr:gameUrlString Watch:NO SuperViewType:@"room" block:^(NSString *typeString,NSString *gameId){
        }];
        [self.navigationController pushViewController:gameVC animated:YES];
        
        self.miniRoomButton.userInteractionEnabled = YES;
        [self.gamePlayView refuseAction];
        
    });
}

// 从外面进入游戏
- (void)enterFromOutOfRoom:(NSString *)gameString{
    [XCHUDTool hideHUD];
    if ([[self topViewController] isKindOfClass:NSClassFromString(@"TTWkGameViewController")]) {
        NSLog(@"webView已经有了");
        return;
    }
    UIViewController *gameVC = [[XCMediator sharedInstance] ttGameMoudle_TTWkGameViewControllerWithUrlStr:gameString Watch:NO SuperViewType:@"room" block:^(NSString *typeString,NSString *gameId){
    }];
    [self.navigationController pushViewController:gameVC animated:YES];
    self.miniRoomButton.userInteractionEnabled = YES;
    [self.gamePlayView refuseAction];
}


//  请求观战链接
- (void)onCPRoomUrlWithWatchGame:(NSString *)watchGameUrl{
    
    UIViewController *gameVC = [[XCMediator sharedInstance] ttGameMoudle_TTWkGameViewControllerWithUrlStr:watchGameUrl Watch:YES SuperViewType:@"room" block:^(NSString *typeString,NSString *gameId){
    }];
    [self.navigationController pushViewController:gameVC animated:YES];
}


- (void)inviteFriendFromGameModel{
    GetCore(TTGameStaticTypeCore).shareRoomOrInviteType = TTShareRoomOrInviteFriendStatus_Invite;
    ShareModelInfor * model = [[ShareModelInfor alloc] init];
    model.currentVC = self;
    model.roomInfor = self.roomInfo;
    model.shareType = Custom_Noti_Sub_Share_Room;
    [GetCore(ShareCore) reloadShareModel:model];
    UIViewController * controller = [[XCMediator sharedInstance] ttDiscoverMoudle_TTFamilyShareContainViewController];
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (void)closeGameModel{
    [self gameCloseRoomCPMode];
}

//更改 游戏 模式 改变布局 进入游戏模式
- (void)CpOpenGameChangeCpMode{
    
    [self getGameList];
    
    TTCPGameCustomModel *cppAtt = [[TTCPGameCustomModel alloc] init];
    cppAtt.nick = [GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue].nick;
    
    NIMMessage *message = [[NIMMessage alloc]init];
    NIMCustomObject *customObject = [[NIMCustomObject alloc]init];
    Attachment *attachment = [[Attachment alloc] init];
    attachment.first = Custom_Noti_Header_CPGAME;
    attachment.second = Custom_Noti_Sub_CPGAME_Open;
    attachment.data = [cppAtt model2dictionary];
    customObject.attachment = attachment;
    message.messageObject = customObject;
    
    [GetCore(ImMessageCore) sendCustomMessageAttachement:attachment sessionId:[NSString stringWithFormat:@"%ld",(long)GetCore(ImRoomCoreV2).currentRoomInfo.roomId] type:NIMSessionTypeChatroom];
    
    // 只要是开启游戏面板，游戏就回归初始状态
    [self.gamePlayView refuseAction];
}

- (void)CpCloseGameChangeCpMode{
    
    TTCPGameCustomModel *cppAtt = [[TTCPGameCustomModel alloc] init];
    cppAtt.nick = [GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue].nick;
    
    NIMMessage *message = [[NIMMessage alloc]init];
    NIMCustomObject *customObject = [[NIMCustomObject alloc]init];
    Attachment *attachment = [[Attachment alloc] init];
    attachment.first = Custom_Noti_Header_CPGAME;
    attachment.second = Custom_Noti_Sub_CPGAME_Close;
    attachment.data = [cppAtt model2dictionary];
    customObject.attachment = attachment;
    message.messageObject = customObject;
    //    [GetCore(RoomCoreV2) onSendChatRoomMessageSuccess:message];
    
    [GetCore(ImMessageCore) sendCustomMessageAttachement:attachment sessionId:[NSString stringWithFormat:@"%ld",(long)GetCore(ImRoomCoreV2).currentRoomInfo.roomId] type:NIMSessionTypeChatroom];
    
}



- (void)gameOpenRoomCPMode{
    NIMChatroomMember *mineMember = GetCore(RoomQueueCoreV2).myMember;
    
    //房主才能开启游戏模式
    if(mineMember.type == NIMChatroomMemberTypeCreator) {
        
        NSString *promptString = @"即将开启快玩模式，你准备好了吗？";
        @KWeakify(self);
        TTRoomKTVAlerView *twiceView = [[TTRoomKTVAlerView alloc] initWithFrame:CGRectMake(0, 0, 295, 182) title:@"提示" subTitle:nil attrMessage:nil message:promptString backgroundMessage:nil cancel:^{
            [TTPopup dismiss];
        } ensure:^{
            @KStrongify(self);
            self.firstEnterRoom = YES;
            [[GetCore(CPGameCore) GameOpenCPModeWithRoomUid:[NSString stringWithFormat:@"%lld",self.roomInfo.uid]] subscribeError:^(NSError *error) {
                [XCHUDTool showErrorWithMessage:error.domain];
            } completed:^{
                // 开启游戏面板。游戏进入选择中
                [[GetCore(CPGameCore) requestGameRoomid:self.roomInfo.uid WithGameStatus:2 GameId:@"" gameName:@"" StartUid:@""] subscribeError:^(NSError *error) {
                    [XCHUDTool showErrorWithMessage:error.domain];
                }];
                
                [self CpOpenGameChangeCpMode];  // 开启游戏面板
            }];
            [TTPopup dismiss];
            
        }];
        [TTPopup popupView:twiceView style:TTPopupStyleAlert];
    }
    
}


- (void)gameCloseRoomCPMode{
    NIMChatroomMember *mineMember = GetCore(RoomQueueCoreV2).myMember;
    
    //房主才能关闭游戏模式
    if(mineMember.type == NIMChatroomMemberTypeCreator) {
        @KWeakify(self);
        TTRoomKTVAlerView *twiceView = [[TTRoomKTVAlerView alloc] initWithFrame:CGRectMake(0, 0, 295, 182) title:@"提示" subTitle:nil attrMessage:nil message:@"确定不再玩一会儿？" backgroundMessage:nil cancel:^{
            [TTPopup dismiss];
        } ensure:^{
            @KStrongify(self);
            self.firstEnterRoom = NO;
            [TTPopup dismiss];
            
            // 即将要关闭游戏模式。先移出匹配池。
            if ([self.roomInfo.roomGame[@"status"] intValue] == 3) {
                [self.gamePlayView RemovedFromMatchPool];
            }
            
            [[GetCore(CPGameCore) GameCloseCPModeWithRoomUid:[NSString stringWithFormat:@"%lld",self.roomInfo.uid]] subscribeError:^(NSError *error) {
                [XCHUDTool showErrorWithMessage:error.domain];
            } completed:^{
                [self CpCloseGameChangeCpMode];  // 关闭游戏面板
            }];
            
        }];
        [TTPopup popupView:twiceView style:TTPopupStyleAlert];
    }
}

//  关闭游戏模式，并且无弹窗，为了方便和KTV模式的无声切换
- (void)closeCPModel{
    if (self.roomInfo.isOpenGame) {
        self.firstEnterRoom = NO;
        // 开启了KTV模式。游戏模式默认关闭，关闭前移出匹配池
        if ([self.roomInfo.roomGame[@"status"] intValue] == 3) {
            [self.gamePlayView RemovedFromMatchPool];
        }
        @KWeakify(self);
        [[GetCore(CPGameCore) GameCloseCPModeWithRoomUid:[NSString stringWithFormat:@"%lld",self.roomInfo.uid]] subscribeError:^(NSError *error) {
            [XCHUDTool showErrorWithMessage:error.domain];
        } completed:^{
            @KStrongify(self);
            [self CpCloseGameChangeCpMode];  // 关闭游戏面板
        }];
    }
}

#pragma mark --- 匹配到机器人，抱他上麦 ---

- (void)HoldRobotOnTheMic{
    // 机器人id
    NSString *robotId = [[NSUserDefaults standardUserDefaults] objectForKey:@"Robot"];
    
    [[GetCore(UserCore) getUserInfoByRac:robotId.userIDValue refresh:YES] subscribeNext:^(id x) {
        
        UserInfo *info = x;
        TTCPGameCustomModel *cpAtt = [[TTCPGameCustomModel alloc] init];
        cpAtt.nick = info.nick;
        
        Attachment *attachement = [[Attachment alloc]init];
        attachement.first = Custom_Noti_Header_CPGAME;
        attachement.second = Custom_Noti_Sub_CPGAME_Ai_Enter;
        attachement.data = [cpAtt model2dictionary];
        [GetCore(ImMessageCore) sendCustomMessageAttachement:attachement sessionId:[NSString stringWithFormat:@"%ld",(long)GetCore(ImRoomCoreV2).currentRoomInfo.roomId] type:NIMSessionTypeChatroom];
        
        [GetCore(RoomQueueCoreV2) updateChatroomQueueWithPosition:@"0" userInfo:x success:^(BOOL success) {
            NSLog(@"抱成功了");
        } failure:^(NSString *message) {
            NSLog(@"抱失败了");
        }];
        
    }];
    
}

#pragma mark  --- 献给无聊上下麦的人 ---
-(void)downMic{
    self.firstEnterRoom = YES;
}

-(void)suddenUpMic{
    self.secondEnterRoom = YES;
}

-(void)getGameList{
    
    [[GetCore(CPGameCore) requestCPGameList:[NSString stringWithFormat:@"%lld",self.roomInfo.uid] PageNum:1 PageSize:30] subscribeError:^(NSError *error) {
        [XCHUDTool showErrorWithMessage:error.domain];
    } completed:^{
        
    }];;
    
}


//  进入房间的回调
- (void)enterCPRoomSuccess{
    self.onWheatType = YES;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"outOfMatchEnterYouRoom"] isKindOfClass:[NSDictionary class]]) {
#pragma mark --- 匹配到真人之后对方的方法 ----
        // 如果存放的是字典。说明是匹配进来的 都是由房主对方的人发云信自定义消息 机器人除外
        NSInteger matchTypeNumber = [[[NSUserDefaults standardUserDefaults] objectForKey:@"matchType"] integerValue];
        
        if (matchTypeNumber == 292) {
            
            NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"matchGameData"];
            
            CPGameListModel *model = [CPGameListModel modelDictionary:dict];
            
            NotifyCoreClient(CPGameCoreClient, @selector(matchGameAndGameData:), matchGameAndGameData:model);
            
            TTCPGameCustomInfo *gameInfo = [TTCPGameCustomInfo modelDictionary:[model model2dictionary]];
            
            TTCPGameCustomModel *cpAtt = [[TTCPGameCustomModel alloc] init];
            cpAtt.gameInfo = gameInfo;
            
            Attachment *attachement = [[Attachment alloc]init];
            attachement.first = Custom_Noti_Header_CPGAME;
            attachement.second = Custom_Noti_Sub_CPGAME_Start; // 跟随安卓 实际还要调
            attachement.data = [cpAtt model2dictionary];
            [GetCore(ImMessageCore) sendCustomMessageAttachement:attachement sessionId:[NSString stringWithFormat:@"%ld",(long)GetCore(ImRoomCoreV2).currentRoomInfo.roomId] type:NIMSessionTypeChatroom];
        }
        
        NSDictionary *dictData = [[NSUserDefaults standardUserDefaults] objectForKey:@"outOfMatchEnterYouRoom"];
        NSString *gameUrlString;
        if ([dictData[@"player1"][@"uid"] userIDValue] == GetCore(AuthCore).getUid.userIDValue) {
            // player1 是我的信息
            gameUrlString = dictData[@"player1"][@"gameUrl"];
        }else{
            // player2 是我的信息
            gameUrlString = dictData[@"player2"][@"gameUrl"];
        }
        
        [self enterFromOutOfRoom:gameUrlString];
        
    }
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"outOfMatchEnterMyRoom"] isKindOfClass:[NSDictionary class]])  {
        //  如果这个方法走了。代表只有两种情况。第一种是，两个人都是外部匹配。并且我是房主。第二种是我匹配到了机器人，有机器人ID作为区别
        
        //  第一种情况 匹配到机器人
        NSString *robotId = [[NSUserDefaults standardUserDefaults] objectForKey:@"Robot"];
        if ([robotId integerValue] > 0) {
#pragma mark --- 匹配到机器人之后自己的方法 ----
            //  只要是外部匹配进来的。就会拿到这个值。保存的是游戏信息
            
            NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"matchGameData"];
            
            CPGameListModel *model = [CPGameListModel modelDictionary:dict];
            
            NotifyCoreClient(CPGameCoreClient, @selector(matchGameAndGameData:), matchGameAndGameData:model);
            
            [[GetCore(CPGameCore) requestGameRoomid:self.roomInfo.uid WithGameStatus:5 GameId:model.gameId gameName:model.gameName StartUid:GetCore(AuthCore).getUid] subscribeError:^(NSError *error) {
                [XCHUDTool showErrorWithMessage:error.domain];
            }];
            
            
            NSDictionary *dictData = [[NSUserDefaults standardUserDefaults] objectForKey:@"outOfMatchEnterMyRoom"];
            NSString *myOwn;
            if ([dictData[@"player1"][@"uid"] userIDValue] == GetCore(AuthCore).getUid.userIDValue) {
                // player1 是我的信息
                myOwn = dictData[@"player1"][@"gameUrl"];
            }else{
                // player2 是我的信息
                myOwn = dictData[@"player2"][@"gameUrl"];
            }
            if (myOwn.length > 0) {
                // 如果匹配的是机器人。自己进入游戏界面
                [self enterFromOutOfRoom:myOwn];
            }
            [self HoldRobotOnTheMic]; // 抱机器人上麦
        } else {
#pragma mark --- 匹配到真人之后自己的方法 ----
            NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"matchGameData"];
            
            CPGameListModel *model = [CPGameListModel modelDictionary:dict];
            
            NotifyCoreClient(CPGameCoreClient, @selector(matchGameAndGameData:), matchGameAndGameData:model);
            
            [[GetCore(CPGameCore) requestGameRoomid:self.roomInfo.uid WithGameStatus:5 GameId:model.gameId gameName:model.gameName StartUid:GetCore(AuthCore).getUid] subscribeError:^(NSError *error) {
                [XCHUDTool showErrorWithMessage:error.domain];
            }];
            
            NSDictionary *dictData = [[NSUserDefaults standardUserDefaults] objectForKey:@"outOfMatchEnterMyRoom"];
            NSString *gameUrlString;
            if ([dictData[@"player1"][@"uid"] userIDValue] == GetCore(AuthCore).getUid.userIDValue) {
                // player1 是我的信息
                gameUrlString = dictData[@"player1"][@"gameUrl"];
            }else{
                // player2 是我的信息
                gameUrlString = dictData[@"player2"][@"gameUrl"];
            }
            
            [self enterFromOutOfRoom:gameUrlString];
            
        }
    }
    
    self.miniRoomButton.userInteractionEnabled = YES;
    
    if (GetCore(TTGameStaticTypeCore).checkType) { // 审核中状态
        
        GetCore(TTGameStaticTypeCore).checkType = NO;
        
        [self checkTypeStatus];
    }
}

#pragma mark -- 审核中匹配 ---
- (void)checkTypeStatus {
    self.firstEnterRoom = YES;
    @KWeakify(self);
    [[GetCore(CPGameCore) GameOpenCPModeWithRoomUid:[NSString stringWithFormat:@"%lld",self.roomInfo.uid]] subscribeError:^(NSError *error) {
        [XCHUDTool showErrorWithMessage:error.domain];
    } completed:^{
        @KStrongify(self);
        // 开启游戏面板。游戏进入选择中
        [[GetCore(CPGameCore) requestGameRoomid:self.roomInfo.uid WithGameStatus:2 GameId:@"" gameName:@"" StartUid:@""] subscribeError:^(NSError *error) {
            [XCHUDTool showErrorWithMessage:error.domain];
        }];
        
        [self CpOpenGameChangeCpMode];  // 开启游戏面板
        
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"matchGameData"];
        
        CPGameListModel *model = [CPGameListModel modelDictionary:dict];
        
        NSString *robotId = [[NSUserDefaults standardUserDefaults] objectForKey:@"Robot"];
        
        [GetCore(CPGameCore) requestGameUrlUid:GetCore(AuthCore).getUid.userIDValue Name:[GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue].nick Roomid:GetCore(RoomCoreV2).getCurrentRoomInfo.roomId GameId:model.gameId ChannelId:model.gameChannel AiUId:robotId.userIDValue];
    }];
}

//  上坑回调
- (void)connectRoomKengWeiSuccess{
    self.firstEnterRoom = YES;
    self.secondEnterRoom = YES;
    if (self.roomInfo.type == RoomType_CP) {
        NIMChatroomMember *mineMember = GetCore(RoomQueueCoreV2).myMember;
        if (mineMember.type == NIMChatroomMemberTypeCreator) {
            if ([GetCore(RoomQueueCoreV2) isOnMicro:self.roomInfo.uid]) {
                
            }else{
                if (self.insuranceBOOL) {
                    
                }else{
                    [GetCore(RoomQueueCoreV2) upMic:-1];
                }
            }
            
            NSArray *array = GetCore(RoomQueueCoreV2).findSendGiftMember;
            if (array.count == 2) {
                // 有人在这个时候上麦了，两个坑位上都有人了，移出异性匹配池
                [self removeOppositeSexMatchPool];
            } else {
                if (self.roomInfo.limitType.length <= 0) {
                    [self addOppositeSexMatchPool];
                }
            }
            
            NSString *userString = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserBeLiveMic"];
            if ([userString isEqualToString:@"userLive"]) {
                // 房主踢人下麦，或者抱人下麦。走这里
                NSLog(@"房主踢人下麦，或者抱人下麦。房主走这里");
                [self removeOppositeSexMatchPool];
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"UserBeLiveMic"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
            if (self.roomInfo.isOpenGame) {
                if ([self.roomInfo.roomGame[@"status"] intValue] == 3) {
                    // 游戏进入准备中，如果有一个麦位为自由麦，那么已经加入了匹配池
                    NSArray *array = GetCore(RoomQueueCoreV2).findSendGiftMember;
                    if (array.count == 2) {
                        // 有人在这个时候上麦了，两个坑位上都有人了，移出匹配池 并且准备进入游戏模式了。不能进行其他操作了
                        [self.gamePlayView RemovedFromMatchPool];
                    }else{
                        [[GetCore(CPGameCore) requestGameRoomid:GetCore(RoomCoreV2).getCurrentRoomInfo.uid WithGameStatus:1 GameId:@"" gameName:@"" StartUid:@""] subscribeError:^(NSError *error) {
                            [XCHUDTool showErrorWithMessage:error.domain];
                        } completed:^{
                            
                        }];
                        [self.gamePlayView refuseAction];
                    }
                }
                NSString *userString = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserBeLiveMic"];
                if ([userString isEqualToString:@"userLive"]) {
                    // 房主踢人下麦，或者抱人下麦。走这里
                    NSLog(@"房主踢人下麦，或者抱人下麦。房主走这里");
                    [[GetCore(CPGameCore) requestGameRoomid:GetCore(RoomCoreV2).getCurrentRoomInfo.uid WithGameStatus:1 GameId:@"" gameName:@"" StartUid:@""] subscribeError:^(NSError *error) {
                        [XCHUDTool showErrorWithMessage:error.domain];
                    } completed:^{
                        
                    }];
                    [self.gamePlayView refuseAction];
                    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"UserBeLiveMic"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }
            return;
        }else{
            if (self.onWheatType) {
                if ([GetCore(RoomQueueCoreV2) isOnMicro:GetCore(AuthCore).getUid.userIDValue]) {
                    self.onWheatType = YES;
                }else{
                    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"outOfMatchEnterYouRoom"] isKindOfClass:[NSDictionary class]]) {
                        // 我是从外面匹配进来的 并且我不是房主，我进入了别人的房间，那么默认上的麦位是 0
                        [GetCore(RoomQueueCoreV2) upMic:0];
                        self.onWheatType = NO;
                    }else{
                        // 否则那就是正常进入房间，或者是房间内的游戏匹配到了外部匹配的我。此时房主已经在麦上。我只要上一个空闲麦位就行了
                        NSArray *array = GetCore(RoomQueueCoreV2).findSendGiftMember;
                        if (array.count == 2) {
                            [GetCore(RoomQueueCoreV2) upFreeMic];
                        } else if (array.count < 2) {
                            if ([GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue].platformRole != XCUserInfoPlatformRoleSuperAdmin) {
                                [GetCore(RoomQueueCoreV2) upMic:0];
                            }
                        }
                        self.onWheatType = NO;
                    }
                }
            }
        }
        
        if ([GetCore(RoomQueueCoreV2) isOnMicro:GetCore(AuthCore).getUid.userIDValue]) {
            if (self.roomInfo.isOpenGame) { // 麦上
                if (self.secondEnterRoom) {
                    switch ([self.roomInfo.roomGame[@"status"] intValue]) {
                        case 1:
                            //  游戏无状态
                            self.secondEnterRoom = NO;
                            [self.gamePlayView refuseAction];
                            break;
                        case 2:
                            // 游戏选择中
                            self.secondEnterRoom = NO;
                            [self.gamePlayView refuseAction];
                            break;
                        case 3:{
                            // 游戏准备中
                            self.secondEnterRoom = NO;
                            TTCPGameCustomInfo *info = [TTCPGameCustomInfo modelWithJSON:self.roomInfo.roomGame];
                            for ( int i = 0; i < GetCore(TTGameStaticTypeCore).privateMessageArray.count; i++) {
                                CPGameListModel *dataModel = [CPGameListModel modelDictionary:GetCore(TTGameStaticTypeCore).privateMessageArray[i]];
                                if ([dataModel.gameId isEqualToString:info.gameId]) {
                                    TTCPGameCustomModel *model = [[TTCPGameCustomModel alloc] init];
                                    model.gameInfo = [TTCPGameCustomInfo modelDictionary:[dataModel model2dictionary]];
                                    [self.gamePlayView selectGameAciton:model];
                                    break;
                                }
                            }
                            break;}
                        case 4:
                            //  准备中，目前已经报废，安卓未使用
                            break;
                        case 5:
                            //  游戏中不可能有人上麦
                            break;
                        default:
                            break;
                    }
                }
            }
        }else{
            if (self.roomInfo.isOpenGame) { // 麦下
                if (self.firstEnterRoom) {
                    switch ([self.roomInfo.roomGame[@"status"] intValue]) {
                        case 1:
                            self.firstEnterRoom = NO;
                            [self.gamePlayView audienceCanSeeGameAction:nil];
                            break;
                        case 2:
                            //  游戏选择中
                            self.firstEnterRoom = NO;
                            [self.gamePlayView audienceCanSeeGameAction:nil];
                            break;
                        case 3:{
                            //  游戏准备中
                            self.firstEnterRoom = NO;
                            if (GetCore(RoomQueueCoreV2).findSendGiftMember.count != 2) {
                                [[GetCore(CPGameCore) requestGameRoomid:GetCore(RoomCoreV2).getCurrentRoomInfo.uid WithGameStatus:1 GameId:@"" gameName:@"" StartUid:@""] subscribeError:^(NSError *error) {
                                    [XCHUDTool showErrorWithMessage:error.domain];
                                } completed:^{
                                    
                                }];
                                
                                if (GetCore(TTGameStaticTypeCore).selectGameForMe) {
                                   
                                   @KWeakify(self); dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                        @KStrongify(self);
                                        [self.gamePlayView downMicWithGameSeleter];
                                    });
                                }
                                //                                TTCPGameCustomModel *cpAtt = [[TTCPGameCustomModel alloc] init];
                                //                                cpAtt.nick = [GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue].nick;
                                //
                                //                                Attachment *attachement = [[Attachment alloc]init];
                                //                                attachement.first = Custom_Noti_Header_CPGAME;
                                //                                attachement.second = Custom_Noti_Sub_CPGAME_Cancel_Prepare;
                                //                                attachement.data = [cpAtt model2dictionary];
                                //                                [GetCore(ImMessageCore) sendCustomMessageAttachement:attachement sessionId:[NSString stringWithFormat:@"%ld",(long)GetCore(ImRoomCoreV2).currentRoomInfo.roomId] type:NIMSessionTypeChatroom];
                                [self.gamePlayView audienceCanReadyGameAction:nil];
                            }else{
                                [self.gamePlayView audienceCanReadyGameAction:nil];
                            }
                            break;}
                        case 4:
                            //  已准备
                            break;
                        case 5:
                            // 游戏开始
                            self.firstEnterRoom = NO;
                            [self.gamePlayView gameBeginAudienceCanSeeGameAction];
                            break;
                        default:
                            break;
                    }
                }
            }
        }
    }
}

- (void)updateGameStatusForUI{
    switch ([self.roomInfo.roomGame[@"status"] intValue]){
        case 1:
            break;
            
        case 2:
            break;
            
        case 3:{
            if ([GetCore(RoomQueueCoreV2) isOnMicro:GetCore(AuthCore).getUid.userIDValue]) {
                TTCPGameCustomInfo *info = [TTCPGameCustomInfo modelWithJSON:self.roomInfo.roomGame];
                TTCPGameCustomModel *model = [[TTCPGameCustomModel alloc] init];
                model.gameInfo = info;
                [self.gamePlayView selectGameAciton:model];
            }else{
                [self.gamePlayView audienceCanReadyGameAction:nil];
            }
            
            break;
        }
            
        default:
            break;
    }
}

- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

@end
