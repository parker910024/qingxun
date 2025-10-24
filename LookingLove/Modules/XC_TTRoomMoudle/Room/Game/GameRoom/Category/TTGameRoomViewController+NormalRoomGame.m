//
//  TTGameRoomViewController+NormalRoomGame.m
//  TTPlay
//
//  Created by new on 2019/3/2.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTGameRoomViewController+NormalRoomGame.h"
#import "UIView+NTES.h"
#import "ImMessageCore.h"
#import "TTGameCPPrivateChatModel.h"
#import "XCCPGamePrivateAttachment.h"
#import "XCCPGamePrivateSysNotiAttachment.h"
#import "TTCPGamePrivateChatCore.h"
#import "TTCPGameOverAndSelectClient.h"
#import "TTCPGameStaticCore.h"

#import "XCMediator+TTGameModuleBridge.h"
#import "XCCurrentVCStackManager.h"
#import "LLPostDynamicViewController.h"
#import "BaseNavigationController.h"

#import "TTRoomKTVAlerView.h"
#import "TTDisplayModelMaker.h"
#import "TTDisplayModelMaker+RoomNormalGame.h"
#import "NormalRoomGameCache.h"
#import "TTHalfWebAlertView.h"
#import "TTPopup.h"
#import "TTStatisticsService.h"
#import "TTBlindDateResultView.h"

@implementation TTGameRoomViewController (NormalRoomGame)

- (void)normalRoomOperGameModel{
    if (!self.listView) {
        self.listView = [[TTCPGameListView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, self.view.height) WithListType:TTGameListNormalRoom];
        self.listView.delegate = self;
        [self.view addSubview:self.listView];
    }else{
        [self.listView showListViewAndRefreshData];
        [self.view bringSubviewToFront:self.listView];
    }
    
}

- (void)clickRoomGameItem:(CPGameListModel *)model {
    // [TTPopup dismiss];
     if ([model.status isEqualToString:@"3"]) {
         [XCHUDTool showErrorWithMessage:@"游戏已下架"];
         return;
     }
  
     if (self.gameView.hidden == NO && self.gameView.gameInfo) {
         if (![self.gameView.gameInfo.gameId isEqualToString:model.gameId]) {
             [TTStatisticsService trackEvent:@"game_Open_other_games" eventDescribe:@"成功开启其他游戏"];
             TTAlertConfig * config = [[TTAlertConfig alloc] init];
             config.title = @"提示";
             config.message = [NSString stringWithFormat:@"开启%@将会关闭%@游戏，确认开启吗？",model.gameName,self.gameView.gameInfo.gameName];
             config.confirmButtonConfig.title = @"确定";
             config.cancelButtonConfig.title = @"关闭";
             [TTPopup alertWithConfig:config confirmHandler:^{
                 @weakify(self)
                 [GetCore(TTCPGamePrivateChatCore)requestGameCloseByGameId:self.gameView.gameInfo.gameId roomUid:GetCore(ImRoomCoreV2).currentRoomInfo.uid Success:^(void) {
                     @strongify(self)
                     self.gameView.gameInfo = nil;
                     self.gameView.hidden = YES;
                     @weakify(self)
                     [GetCore(TTCPGamePrivateChatCore)requestGameDetailGameId:model.gameId roomUid:GetCore(ImRoomCoreV2).currentRoomInfo.uid Success:^(CPGameListModel *model) {
                         @strongify(self)
     //                    self.gameView.gameInfo = model;
     //                    self.gameView.hidden = NO;
                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                             [self showGameHalfWbeView:model.gameUrl];
                         });
                         
                     } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {

                     }];
                 } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {

                 }];

             } cancelHandler:^{
             }];
         } else {
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [self showGameHalfWbeView:self.gameView.gameInfo.gameUrl];
             });
            
         }
     } else {
         if ([self.gameView.gameInfo.gameName containsString:@"真心话大冒险"]) {
             [TTStatisticsService trackEvent:@"mp_room_more_game_choose" eventDescribe:@"真心话大冒险_成功开始游戏"];
         } else if ([self.gameView.gameInfo.gameName containsString:@"鳄鱼拔牙"]) {
             [TTStatisticsService trackEvent:@"mp_room_more_game_choose" eventDescribe:@"鳄鱼拔牙_成功开始游戏"];
         }
       //  [TTStatisticsService trackEvent:@"room_more_game_choose" eventDescribe:@"派对游戏_启动游戏"];
         @weakify(self)
         [GetCore(TTCPGamePrivateChatCore)requestGameDetailGameId:model.gameId roomUid:GetCore(ImRoomCoreV2).currentRoomInfo.uid  Success:^(CPGameListModel *model) {
             @strongify(self)
 //            self.gameView.gameInfo = model;
 //            self.gameView.hidden = NO;

             [self showGameHalfWbeView:model.gameUrl];
         } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {

         }];
     }
}

-(void)clickItem:(CPGameListModel *)model{
 
    GetCore(TTCPGamePrivateChatCore).publicChatType = NO;
    // 发起游戏之前，先取消掉自己上次发的游戏
    [self cancelMyGameForSelectGameAgain];
    
    [[BaiduMobStat defaultStat]logEvent:@"mp_room_game_choice" eventLabel:@"点击选择游戏（多人房）"];
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time = [date timeIntervalSince1970] * 1000;// * 1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    
    TTCPGameCustomInfo *gameInfo = [TTCPGameCustomInfo modelDictionary:[model model2dictionary]];
    
    XCCPGamePrivateAttachment *attachement = [[XCCPGamePrivateAttachment alloc] init];
    attachement.first = Custom_Noti_Header_CPGAME_PrivateChat;
    attachement.second = Custom_Noti_Sub_CPGAME_PrivateChat_LaunchGame;
    
    TTGameCPPrivateChatModel *cpAtt = [[TTGameCPPrivateChatModel alloc] init];
    cpAtt.startTime = timeString.userIDValue;
    cpAtt.status = TTGameStatusTypeTimeing;
    cpAtt.time = 60;
    cpAtt.gameInfo = gameInfo;
    cpAtt.startUid = GetCore(AuthCore).getUid.userIDValue;
    cpAtt.nick = [GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue].nick;
    attachement.data = [cpAtt model2dictionary];
    [GetCore(ImMessageCore) sendCustomMessageAttachement:attachement sessionId:[NSString stringWithFormat:@"%ld",(long)GetCore(ImRoomCoreV2).currentRoomInfo.roomId] type:NIMSessionTypeChatroom];
    
}

- (void)cancelMyGameForSelectGameAgain{
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
}

- (void)miniRoomAndCancelMyGameStatusWithMessage:(NIMMessage *)message{
    [self.listView destructionTimer];
    
    NIMCustomObject *obj = (NIMCustomObject *)message.messageObject;
    Attachment *attachment = (Attachment *)obj.attachment;
    
    TTGameCPPrivateChatModel *model = [TTGameCPPrivateChatModel modelWithJSON:attachment.data];
    
    model.status = TTGameStatusTypeInvalid;
    model.uuId = message.messageId;
    
    message.localExt = [model model2dictionary];
    
    XCCPGamePrivateSysNotiAttachment *sysNotificaton = [[XCCPGamePrivateSysNotiAttachment alloc] init];
    sysNotificaton.first = Custom_Noti_Header_CPGAME_PublicChat_Respond;
    sysNotificaton.second = Custom_Noti_Sub_CPGAME_PublicChat_Respond_Cancel;
    sysNotificaton.data = [model model2dictionary];
    [GetCore(ImMessageCore) sendCustomMessageAttachement:sysNotificaton sessionId:[NSString stringWithFormat:@"%ld",(long)GetCore(ImRoomCoreV2).currentRoomInfo.roomId] type:NIMSessionTypeChatroom];
}

- (void)messageTableView:(TTMessageView *)messageTableView updateRoomNormalGameMessage:(TTMessageDisplayModel *)messageModel{
    
    [self.listView destructionTimer];
    
    NIMCustomObject *obj = (NIMCustomObject *)messageModel.message.messageObject;
    Attachment *attachment = (Attachment *)obj.attachment;
    
    TTGameCPPrivateChatModel *model = [TTGameCPPrivateChatModel modelWithJSON:attachment.data];
    
    model.status = TTGameStatusTypeInvalid;
    model.uuId = messageModel.message.messageId;
    
    messageModel.message.localExt = [model model2dictionary];
    
    //  自己手动取消游戏时。删除掉自己本地记载的发送的这条消息
    NSMutableDictionary *messsicDict = [[[NormalRoomGameCache shareNormalGameCache] takeOutMyOwnMessagesWithUid:GetCore(AuthCore).getUid] mutableCopy];
    
    [messsicDict removeObjectForKey:messageModel.message.messageId];
    
    [[NormalRoomGameCache shareNormalGameCache] removeGameMessageFromMeInfo:messsicDict];
    
    [self.messageView.tableView reloadData];
    
    XCCPGamePrivateSysNotiAttachment *sysNotificaton = [[XCCPGamePrivateSysNotiAttachment alloc] init];
    sysNotificaton.first = Custom_Noti_Header_CPGAME_PublicChat_Respond;
    sysNotificaton.second = Custom_Noti_Sub_CPGAME_PublicChat_Respond_Cancel;
    sysNotificaton.data = [model model2dictionary];
    [GetCore(ImMessageCore) sendCustomMessageAttachement:sysNotificaton sessionId:[NSString stringWithFormat:@"%ld",(long)GetCore(ImRoomCoreV2).currentRoomInfo.roomId] type:NIMSessionTypeChatroom];
}

// 收到对方主动取消游戏
- (void)onReceiveCPGamePublicChatGameCancelMessageSuccess:(NIMMessage *)message{
    
    NIMCustomObject *obj = (NIMCustomObject *)message.messageObject;
    
    XCCPGamePrivateSysNotiAttachment *attachment = (XCCPGamePrivateSysNotiAttachment *)obj.attachment;
    
    TTGameCPPrivateChatModel *model = [TTGameCPPrivateChatModel modelDictionary:attachment.data];
    
    model.status = TTGameStatusTypeInvalid;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i < self.messageView.messages.count; i++) {
            TTMessageDisplayModel *messageModel = self.messageView.messages[i];
            if ([messageModel.message.messageId isEqualToString:model.uuId]) {
                messageModel.message.localExt = [model model2dictionary];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[TTDisplayModelMaker shareMaker] makeRoomNormalGameWithMessage:messageModel.message model:messageModel];
                    [self.messageView.tableView reloadData];
                });
            }
        }
    });
}

- (void)gameOverFromNormalRoomChat:(NSDictionary *)resultData{
    
    [[GetCore(CPGameCore) requestGameOverGameWithChatResult:[self dictionaryToJson:resultData] WithMessageID:self.acceptMessageID] subscribeError:^(NSError *error) {
        [XCHUDTool showErrorWithMessage:error.domain];
    }];
    
}

- (void)messageTableView:(TTMessageView *)messageTableView updateRoomNormalGameForAcceptMessage:(TTMessageDisplayModel *)messageModel{
    
    GetCore(TTGameStaticTypeCore).acceptGameFromNormalRoom = YES;
    
    [self.listView destructionTimer];
    
    self.acceptMessageID = messageModel.message.messageId;
    
    [[BaiduMobStat defaultStat]logEvent:@"mp_room_game_accept" eventLabel:@"点击接受按钮"];
    
    NIMCustomObject *obj = (NIMCustomObject *)messageModel.message.messageObject;
    
    XCCPGamePrivateAttachment *attachment = (XCCPGamePrivateAttachment *)obj.attachment;
    
    TTGameCPPrivateChatModel *model = [TTGameCPPrivateChatModel modelDictionary:attachment.data];
    
    [[GetCore(TTCPGamePrivateChatCore) requestGameUrlFromPrivateChatUid:messageModel.message.from.userIDValue Name:model.nick ReceiveUid:GetCore(AuthCore).getUid.userIDValue ReceiveName:[GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue].nick GameId:model.gameInfo.gameId ChannelId:model.gameInfo.gameChannel MessageId:messageModel.message.messageId] subscribeNext:^(id x) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 我接受了别人的游戏，要把自己的游戏全部置位已失效
            [self cancelMyGameForAcceptGame];
            
            model.status = TTGameStatusTypeAccept;
            model.acceptUid = GetCore(AuthCore).getUid.userIDValue;
            messageModel.message.localExt = [model model2dictionary];
            
            [[TTDisplayModelMaker shareMaker] makeRoomNormalGameWithMessage:messageModel.message model:messageModel];
            [self.messageView.tableView reloadData];
            
            XCCPGamePrivateSysNotiAttachment *customAtt = [[XCCPGamePrivateSysNotiAttachment alloc] init];
            customAtt.first = Custom_Noti_Header_CPGAME_PublicChat_Respond;
            customAtt.second = Custom_Noti_Sub_CPGAME_PublicChat_Respond_Accept;
            model.gameUrl = x[@"gameUrl"];
            model.status = TTGameStatusTypeAccept;
            model.startUid = messageModel.message.from.userIDValue;
            model.uuId = messageModel.message.messageId;
            customAtt.data = [model model2dictionary];
            
            [GetCore(ImMessageCore) sendCustomMessageAttachement:customAtt sessionId:[NSString stringWithFormat:@"%ld",(long)GetCore(ImRoomCoreV2).currentRoomInfo.roomId] type:NIMSessionTypeChatroom];
            
            @weakify(self);
            UIViewController *gameVC = [[XCMediator sharedInstance] ttGameMoudle_TTWkGameViewControllerWithUrlStr:x[@"receiveGameUrl"] Watch:NO SuperViewType:@"publicRoom" block:^(NSString *typeString,NSString *gameId){
                @strongify(self);
                if ([typeString isEqualToString:@"换个游戏"]) {
                    self.listView = [[TTCPGameListView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, self.view.height) WithListType:TTGameListNormalRoom];
                    self.listView.delegate = self;
                    [self.view addSubview:self.listView];
                }else if ([typeString isEqualToString:@"换个对手"]){
                    [self sendGameCustomMessage:messageModel.message WithGameId:gameId];
                }
            }];
            
            
            
            [self.listView destructionTimer];
            [self.navigationController pushViewController:gameVC animated:YES];
            
        });
    } error:^(NSError *error) {
        
        if (error.code == 20004) {
            dispatch_async(dispatch_get_main_queue(), ^{
                GetCore(TTGameStaticTypeCore).acceptGameFromNormalRoom = NO;
                TTRoomKTVAlerView *alertView = [[TTRoomKTVAlerView alloc] initWithFrame:CGRectMake(0, 0, 295, 182) title:@"提示" subTitle:nil attrMessage:nil message:@"游戏已经开始，是否进入观战" backgroundMessage:nil cancel:^{
                    [TTPopup dismiss];
                } ensure:^{
                    
                    TTGameCPPrivateChatModel *custonModel = [TTGameCPPrivateChatModel modelWithJSON:attachment.data];
                    
                    [[GetCore(TTCPGamePrivateChatCore) requestWatchGameWith:GetCore(AuthCore).getUid.userIDValue GameId:custonModel.gameInfo.gameId ChannelId:custonModel.gameInfo.gameChannel MessageId:messageModel.message.messageId] subscribeError:^(NSError *error) {
                        [XCHUDTool showErrorWithMessage:error.domain];
                    }];
                    [TTPopup dismiss];
                }];
                
                [TTPopup popupView:alertView style:TTPopupStyleAlert];
            });
        }else if (error.code == 20003 || error.code == 20002){
            model.status = TTGameStatusTypeAccept;
            model.acceptUid = GetCore(AuthCore).getUid.userIDValue;
            messageModel.message.localExt = [model model2dictionary];
            [[TTDisplayModelMaker shareMaker] makeRoomNormalGameWithMessage:messageModel.message model:messageModel];
            [self.messageView.tableView reloadData];
            
            [XCHUDTool showErrorWithMessage:error.domain];
        }
        
        
    }];
}



- (void)sendGameCustomMessage:(NIMMessage *)message WithGameId:(NSString *)gameId{
    
    GetCore(TTCPGamePrivateChatCore).publicChatType = NO;
    
    CPGameListModel *gameInfoModel = [[CPGameListModel alloc] init];
    
    for (int i = 0; i < GetCore(TTGameStaticTypeCore).privateMessageArray.count; i++) {
        CPGameListModel *gameModel = [CPGameListModel modelWithJSON:GetCore(TTGameStaticTypeCore).privateMessageArray[i]];
        if ([gameModel.gameId isEqualToString:gameId]) {
            gameInfoModel = gameModel;
        }
    }
    
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time = [date timeIntervalSince1970] * 1000;// * 1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    
    XCCPGamePrivateAttachment * shareMent = [[XCCPGamePrivateAttachment alloc] init];
    shareMent.first = Custom_Noti_Header_CPGAME_PrivateChat;
    shareMent.second = Custom_Noti_Sub_CPGAME_PrivateChat_LaunchGame;
    TTCPGameCustomInfo *gameInfo = [TTCPGameCustomInfo modelDictionary:[gameInfoModel model2dictionary]];
    
    TTGameCPPrivateChatModel *launchGameModel = [[TTGameCPPrivateChatModel alloc] init];
    launchGameModel.startTime = timeString.userIDValue;
    launchGameModel.status = TTGameStatusTypeTimeing;
    launchGameModel.time = 60;
    launchGameModel.gameInfo = gameInfo;
    launchGameModel.startUid = GetCore(AuthCore).getUid.userIDValue;
    launchGameModel.nick = [GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue].nick;
    shareMent.data = [launchGameModel model2dictionary];
    [GetCore(ImMessageCore) sendCustomMessageAttachement:shareMent sessionId:[NSString stringWithFormat:@"%ld",(long)GetCore(ImRoomCoreV2).currentRoomInfo.roomId] type:NIMSessionTypeChatroom];
}

// 收到对方接受游戏的通知
- (void)onReceiveCPGamePublicChatAcceptGameMessageSuccess:(NIMMessage *)message{
    
    [self.listView destructionTimer];
    
    NIMCustomObject *obj = (NIMCustomObject *)message.messageObject;
    
    XCCPGamePrivateSysNotiAttachment *attachment = (XCCPGamePrivateSysNotiAttachment *)obj.attachment;
    
    TTGameCPPrivateChatModel *model = [TTGameCPPrivateChatModel modelDictionary:attachment.data];
    
    self.acceptMessageID = model.uuId;
    
    if (model.startUid == GetCore(AuthCore).getUid.userIDValue) { // 对方接受的是我的游戏。我进入游戏
        
        //  对方接受我的游戏时。删除掉自己本地记载的发送的这条消息
        NSMutableDictionary *messsicDict = [[[NormalRoomGameCache shareNormalGameCache] takeOutMyOwnMessagesWithUid:GetCore(AuthCore).getUid] mutableCopy];
        
        [messsicDict removeObjectForKey:message.messageId];
        
        [[NormalRoomGameCache shareNormalGameCache] removeGameMessageFromMeInfo:messsicDict];
        
        for (int i = 0; i < self.messageView.messages.count; i++) {
            TTMessageDisplayModel *messageModel = self.messageView.messages[i];
            if ([messageModel.message.messageId isEqualToString:model.uuId]) {
                messageModel.message.localExt = [model model2dictionary];
                [[TTDisplayModelMaker shareMaker] makeRoomNormalGameWithMessage:messageModel.message model:messageModel];
                [self.messageView.tableView reloadData];
            }
        }
        
        @weakify(self);
        UIViewController *gameVC = [[XCMediator sharedInstance] ttGameMoudle_TTWkGameViewControllerWithUrlStr:model.gameUrl Watch:NO SuperViewType:@"publicRoom" block:^(NSString *typeString,NSString *gameId){
            @strongify(self);
            if ([typeString isEqualToString:@"换个游戏"]) {
                self.listView = [[TTCPGameListView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, self.view.height) WithListType:TTGameListNormalRoom];
                self.listView.delegate = self;
                [self.view addSubview:self.listView];
            }else if ([typeString isEqualToString:@"换个对手"]){
                [self sendGameCustomMessage:message WithGameId:gameId];
            }
        }];
        
        
        [self.listView destructionTimer];
        
        [self.navigationController pushViewController:gameVC animated:YES];
    }else{
        // 有人接受了游戏。但是这个游戏不是我发起的。这条消息在我这里要变为观战
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            for (int i = 0; i < self.messageView.messages.count; i++) {
                TTMessageDisplayModel *messageModel = self.messageView.messages[i];
                if ([messageModel.message.messageId isEqualToString:model.uuId]) {
                    messageModel.message.localExt = [model model2dictionary];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[TTDisplayModelMaker shareMaker] makeRoomNormalGameWithMessage:messageModel.message model:messageModel];
                        [self.messageView.tableView reloadData];
                    });
                    
                }
            }
        });
    }
    
}


// 观战
- (void)gameStartAndMatchGame:(NSString *)matchUrlString{
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:NSClassFromString(@"TTWkGameViewController")]) {
            NSLog(@"webView已经有了");
            return;
        }
    }
    
    UIViewController *gameVC = [[XCMediator sharedInstance] ttGameMoudle_TTWkGameViewControllerWithUrlStr:matchUrlString Watch:YES SuperViewType:@"" block:^(NSString *typeString,NSString *gameId){
    }];
    
    [self.navigationController pushViewController:gameVC animated:YES];
    
}

- (void)cancelMyGameForAcceptGame{
    
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

- (NSString *)dictionaryToJson:(NSDictionary *)dict{
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    return mutStr;
}

- (void)showGameHalfWbeView:(NSString *)url {
    if (![TTPopup hasShowPopup]) {
        //半屏webview
        TTHalfWebAlertView *alert = [[TTHalfWebAlertView alloc] init];
        alert.tag = 666;
        alert.closeButtonImage = [UIImage imageNamed:@"room_half_web_game_close"];
       
        if (url) {
            alert.url = [NSURL URLWithString:url];
        }
        alert.backgroundColor = [UIColor clearColor];
        alert.webVCBgColor = [UIColor clearColor];
        @weakify(self)
        alert.gameDismissRequestHandler = ^{
            [TTStatisticsService trackEvent:@"game_minimize_window" eventDescribe:@"最小化"];
            @strongify(self)
         
            self.gameView.hidden = YES;
            self.gameView.gameInfo = nil;
            [TTPopup dismiss];
        };
        alert.dismissRequestHandler = ^() {
            
            [TTPopup dismiss];
        };
        [TTPopup popupView:alert style:TTPopupStyleAlert];
    }
}

- (void)removeWebVIew {
    [TTPopup dismiss];
}

#pragma mark -RoomCoreClient
- (void)messageTableView:(TTMessageView *)messageTableView enterRoomGameWithModel:(TTMessageDisplayModel *)messageModel {
    if (self.gameView.gameInfo) {
        self.gameView.hidden = NO;
        NIMChatroomMember *myMember = GetCore(ImRoomCoreV2).myMember;
        BOOL isCreator = myMember.type == NIMChatroomMemberTypeCreator;
        BOOL isManager = myMember.type == NIMChatroomMemberTypeManager;
        if(isCreator || isManager) {
            self.gameView.showDeleteBtn = YES;
        } else {
            self.gameView.showDeleteBtn = NO;
        }
    }
    NIMCustomObject *obj = (NIMCustomObject *)messageModel.message.messageObject;
    Attachment *attachment = (Attachment *)obj.attachment;
    CPGameListModel *gameModel = [CPGameListModel modelWithJSON:attachment.data];
    if (gameModel.openSkip) {
        [self showGameHalfWbeView:gameModel.gameUrl];
    }

}


- (void)responseRoomGame:(Attachment *)data {
    CPGameListModel *gameModel = [CPGameListModel modelWithJSON:data.data];
    if (gameModel.gameStatus == 1) {
        self.gameView.gameInfo = [CPGameListModel modelWithJSON:data.data];
        self.gameView.hidden = NO;
        NIMChatroomMember *myMember = GetCore(ImRoomCoreV2).myMember;
        BOOL isCreator = myMember.type == NIMChatroomMemberTypeCreator;
        BOOL isManager = myMember.type == NIMChatroomMemberTypeManager;
        if(isCreator || isManager) {
            self.gameView.showDeleteBtn = YES;
        } else {
            self.gameView.showDeleteBtn = NO;
        }
        if (gameModel.needDisplay) {
            for (int i = 0; i<gameModel.memberList.count; i++) {
                UserID uid = [gameModel.memberList[i] userIDValue];
                    if (uid == GetCore(AuthCore).getUid.userIDValue) {
                        [self showGameHalfWbeView:gameModel.gameUrl];
                    }
            }
        }
        
        
    } else  if (gameModel.gameStatus == 3) {
        self.gameView.gameInfo = nil;
        self.gameView.hidden = YES;
        if (gameModel.endGameType == 1) {
            [self removeWebVIew];
        } else if (gameModel.endGameType == 2) {
            if (gameModel.uid != [[GetCore(AuthCore)getUid] userIDValue]) {
                [self removeWebVIew];
            }
        }

    } else  if (gameModel.gameStatus == 2) {
        if (gameModel.needDisplay) {
            if (gameModel.uid == GetCore(AuthCore).getUid.userIDValue) {
                [self showGameHalfWbeView:gameModel.gameUrl];
            }
        }

    }
    
}
#pragma mark - WBGameViewDelegate
- (void)onClickCloseGameBtn:(CPGameListModel *)gameInfo {
    if ([gameInfo.gameName containsString:@"真心话大冒险"]) {
        [TTStatisticsService trackEvent:@"game_talk_end" eventDescribe:@"真心话大冒险_结束游戏"];
    } else if ([gameInfo.gameName containsString:@"鳄鱼拔牙"]) {
        [TTStatisticsService trackEvent:@"game_tooth_end" eventDescribe:@"鳄鱼拔牙_结束游戏"];
    }
    TTAlertConfig * config = [[TTAlertConfig alloc] init];
    config.title = @"提示";
    config.message = [NSString stringWithFormat:@"是否关闭%@游戏",gameInfo.gameName];
    config.confirmButtonConfig.title = @"确定";
    config.cancelButtonConfig.title = @"关闭";
    [TTPopup alertWithConfig:config confirmHandler:^{
        @weakify(self)
        [GetCore(TTCPGamePrivateChatCore)requestGameCloseByGameId:gameInfo.gameId roomUid:GetCore(ImRoomCoreV2).currentRoomInfo.uid Success:^(void) {
            @strongify(self)
            self.gameView.gameInfo = nil;
            self.gameView.hidden = YES;
        } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {

        }];
    } cancelHandler:^{
    }];

}

- (void)onClickWBGameView:(CPGameListModel *)gameInfo {
    [TTStatisticsService trackEvent:@"mp_room_more_game_choose" eventDescribe:@"派对游戏_展开面板"];
    
    [self showGameHalfWbeView:gameInfo.gameUrl];
}

// 相亲房相亲结果通知（动画)
- (void)onRecvBlindDateResult:(RoomLoveModelSuccess *)model {
    
    TTBlindDateResultView *view = [[TTBlindDateResultView alloc] init];
    [view handleResult:model];
    view.shareHandler = ^(UIImage * _Nonnull img) {
        if (!img) {
            return;
        }
        
        if ([TTPopup hasShowPopup]) {
            //因为分享页可能会有弹窗，所以这里要先将弹窗消失掉
            [TTPopup dismiss];
        }
        
        [TTStatisticsService trackEvent:@"room_blinddate_share" eventDescribe:@"分享到动态"];
        LLPostDynamicViewController *vc = [[LLPostDynamicViewController alloc] initWithImages:@[img]];
        BaseNavigationController *navVC = [[BaseNavigationController alloc] initWithRootViewController:vc];
        // iOS 13 也需要全屏展示
        navVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [[XCCurrentVCStackManager shareManager].getCurrentVC presentViewController:navVC animated:YES completion:nil];
    };
    [UIApplication.sharedApplication.keyWindow addSubview:view];
}


@end
