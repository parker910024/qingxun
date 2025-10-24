//
//  TTPublicNIMChatroomController+PublicGame.m
//  TTPlay
//
//  Created by new on 2019/3/2.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTPublicNIMChatroomController+PublicGame.h"
//#import "TTWkGameViewController.h"
#import "XCCurrentVCStackManager.h"
#import "XCMediator+TTGameModuleBridge.h"
#import "XCMediator+TTRoomMoudleBridge.h"

#import "TTCPGameOverAndSelectClient.h"
#import "TTGameCPPrivateChatModel.h"
#import "PublicGameCache.h"
#import "CPGameCore.h"
#import "XCCPGamePrivateSysNotiAttachment.h"
#import "TTGameCPPrivateSysNotiModel.h"
#import "XCCPGamePrivateAttachment.h"
#import "XCHUDTool.h"
#import "TTCPGamePrivateChatCore.h"
#import "AuthCore.h"
#import "UserCore.h"
#import "MeetingCore.h"
#import "PublicChatroomCore.h"
#import "CPGameListModel.h"
#import "RoomCoreV2.h"
@implementation TTPublicNIMChatroomController (PublicGame)


#pragma mark --- TTCPGamePrivateChatClient 各种接受游戏，取消游戏，游戏结束的处理 ----
- (void)acceptGameFromPublicChatGameUrl:(NSString *)gameUrl FromUid:(NIMMessage *)message{
    
    [[BaiduMobStat defaultStat]logEvent:@"public_chat_game_accept" eventLabel:@"点击接受按钮"];
    if (!message) {
        [XCHUDTool showErrorWithMessage:@"游戏发生错误" inView:self.view];
    }
    self.acceptMessageID = message.messageId;
    
    [[NSUserDefaults standardUserDefaults] setObject:message.messageId forKey:@"messageID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self enterGameWebView:gameUrl WithMessage:message];
    
    [GetCore(MeetingCore) setCloseMicro:NO];
    [GetCore(MeetingCore) joinMeeting:message.from actor:YES];
    
}

- (void)sendGameCustomMessage:(NIMMessage *)message{
    
    GetCore(TTCPGamePrivateChatCore).publicChatType = YES;
    
    NIMCustomObject *obj = (NIMCustomObject *)message.messageObject;
    Attachment *attachment = (Attachment *)obj.attachment;
    TTGameCPPrivateChatModel *model = [TTGameCPPrivateChatModel modelDictionary:attachment.data];
    
    CPGameListModel *gameInfoModel = [CPGameListModel modelDictionary:[model.gameInfo model2dictionary]];
    
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
    [GetCore(PublicChatroomCore) onSendPublicChatGameMessage:shareMent];
}

// 我接收到了。对面接受游戏的消息。
- (void)onReceiveCPGamePublicChatAcceptGameMessageSuccess:(NIMMessage *)message{
    
    NIMCustomObject *object = (NIMCustomObject *)message.messageObject;
    
    if ([object.attachment isKindOfClass:Attachment.class]) {
        Attachment *attachment = (Attachment *)object.attachment;
        
        TTGameCPPrivateChatModel *model = [TTGameCPPrivateChatModel modelDictionary:attachment.data];
        
        NIMMessage *locationMessage = [[PublicGameCache sharePublicGameCache] selectGameInfo:model.uuId];
        
        self.acceptMessageID = model.uuId;
        
        [[NSUserDefaults standardUserDefaults] setObject:model.uuId forKey:@"messageID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        locationMessage.localExt = [model model2dictionary];
        
        [[PublicGameCache sharePublicGameCache] changeGameInfo:locationMessage];
        
        if (attachment.first == Custom_Noti_Header_CPGAME_PublicChat_Respond) {
            if (attachment.second == Custom_Noti_Sub_CPGAME_PublicChat_Respond_Accept) {
                if (model.startUid == GetCore(AuthCore).getUid.userIDValue) {
                    //                    NSLog(@"我是游戏发起人，对方接受的是我的游戏");
                    [self enterGameWebView:model.gameUrl WithMessage:message];
                    
                    [GetCore(MeetingCore) setCloseMicro:NO];
                    [GetCore(MeetingCore) joinMeeting:GetCore(AuthCore).getUid actor:YES];
                }else{
                    [self uiUpdateMessage:locationMessage];
                }
            }
        }
    }
}

- (void)enterGameWebView:(NSString *)gameUrl WithMessage:(NIMMessage *)message{
    if ([[self topViewController] isKindOfClass:NSClassFromString(@"TTWkGameViewController")]) {
        NSLog(@"webView已经有了");
        return;
    }
    if (GetCore(RoomCoreV2).isInRoom){
        if (GetCore(ImRoomCoreV2).currentRoomInfo.uid == GetCore(AuthCore).getUid.userIDValue) {
            [GetCore(RoomCoreV2) closeRoom:GetCore(AuthCore).getUid.userIDValue];
        }else{
            [[XCMediator sharedInstance] ttRoomMoudle_closeRoomViewController];
        }
    }
    
    @weakify(self);
    UIViewController *gameVC = [[XCMediator sharedInstance] ttGameMoudle_TTWkGameViewControllerWithUrlStr:gameUrl Watch:NO SuperViewType:@"publicChat" block:^(NSString *typeString,NSString *gameId){
        @strongify(self);
        if ([typeString isEqualToString:@"换个游戏"]) {
            self.listView.hidden = NO;
        }else if ([typeString isEqualToString:@"换个对手"]){
            [self sendGameCustomMessage:message];
        }
    }];

    //                    NotifyCoreClient(TTCPGameOverAndSelectClient, @selector(enterGamePageDestructionTimer), enterGamePageDestructionTimer);
    [self.listView destructionTimer];
    
    [self.navigationController pushViewController:gameVC animated:YES];
}

- (void)onCPGamePrivateChatList:(NSArray *)listArray{
    self.gameListArray = [NSMutableArray array];
    for (int i = 0; i < listArray.count; i++) {
        [self.gameListArray addObject:[listArray[i] model2dictionary]];
    }
    [[NSUserDefaults standardUserDefaults] setObject:self.gameListArray forKey:@"gameListArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)gameOverFromPublicChat:(NSDictionary *)resultData{
    @KWeakify(self);
    [[GetCore(CPGameCore) requestGameOverGameWithChatResult:[self dictionaryToJson:resultData] WithMessageID:self.acceptMessageID] subscribeError:^(NSError *error) {
        @KStrongify(self);
        [XCHUDTool showErrorWithMessage:error.domain inView:self.view];
    }];
    
    NSString *gameName;
    TTCPGameCustomInfo *privateModel = [TTCPGameCustomInfo modelWithJSON:resultData[@"result"]];
    
    NSMutableArray *dataArray = [[[NSUserDefaults standardUserDefaults] objectForKey:@"gameListArray"] mutableCopy];
    
    for (int i =0; i < dataArray.count; i++) {
        CPGameListModel *model = [CPGameListModel modelDictionary:dataArray[i]];
        if ([model.gameId isEqualToString:privateModel.gameId]) {
            gameName = model.gameName;
            break;
        }
    }
    
    XCCPGamePrivateSysNotiAttachment *sysNotificaton = [[XCCPGamePrivateSysNotiAttachment alloc] init];
    sysNotificaton.first = Custom_Noti_Header_CPGAME_PrivateChat_SystemNotification;
    sysNotificaton.second = Custom_Noti_Sub_CPGAME_PrivateChat_SysNoti_GameOver;
    
    TTGameCPPrivateSysNotiModel *model = [[TTGameCPPrivateSysNotiModel alloc] init];
    
    if ([privateModel.resultType isEqualToString:@"draw"]) { // 平局
        NSString *myNickString;
        NSString *youNickString;
        if (privateModel.roomId == [[privateModel.users safeObjectAtIndex:0][@"uid"] userIDValue]) {
            if (privateModel.roomId == GetCore(AuthCore).getUid.userIDValue) {
                myNickString = [privateModel.users safeObjectAtIndex:0][@"name"];
                youNickString = [privateModel.users safeObjectAtIndex:1][@"name"];
            }else{
                myNickString = [privateModel.users safeObjectAtIndex:1][@"name"];
                youNickString = [privateModel.users safeObjectAtIndex:0][@"name"];
            }
        }else{
            if (privateModel.roomId == GetCore(AuthCore).getUid.userIDValue) {
                myNickString = [privateModel.users safeObjectAtIndex:1][@"name"];
                youNickString = [privateModel.users safeObjectAtIndex:0][@"name"];
            }else{
                myNickString = [privateModel.users safeObjectAtIndex:0][@"name"];
                youNickString = [privateModel.users safeObjectAtIndex:1][@"name"];
            }
        }
        
        model.msg = [NSString stringWithFormat:@"【%@】%@ 对战 %@ 为平局",gameName,myNickString,youNickString];
        
    }else{ // 不是平局
        
        NSString *winnerString = [privateModel.winners safeObjectAtIndex:0][@"name"];
        
        NSString *failersString = [privateModel.failers safeObjectAtIndex:0][@"name"];
        
        model.msg = [NSString stringWithFormat:@"【%@】 %@ 战胜了 %@",gameName,winnerString,failersString];
        
    }
    sysNotificaton.data = [model model2dictionary];
    [GetCore(PublicChatroomCore) onSendPublicChatGameOverMessage:sysNotificaton];
}


- (void)gameStartAndMatchGame:(NSString *)matchUrlString{
    
    if ([[self topViewController] isKindOfClass:NSClassFromString(@"TTWkGameViewController")]) {
        NSLog(@"webView已经有了");
        return;
    }
    
    UIViewController *gameVC = [[XCMediator sharedInstance] ttGameMoudle_TTWkGameViewControllerWithUrlStr:matchUrlString Watch:YES SuperViewType:@"publicChat" block:^(NSString *typeString,NSString *gameId){
        
    }];
    
    [self.navigationController pushViewController:gameVC animated:YES];
}


- (void)gameFailureAndRefreshTableView:(NIMMessage *)message{
    NIMCustomObject *obj = (NIMCustomObject *)message.messageObject;
    
    XCCPGamePrivateAttachment *attachment = (XCCPGamePrivateAttachment *)obj.attachment;
    
    TTGameCPPrivateChatModel *model = [[TTGameCPPrivateChatModel alloc] init];
    
    if (message.localExt) {
        model = [TTGameCPPrivateChatModel modelDictionary:message.localExt];
    }else{
        model = [TTGameCPPrivateChatModel modelDictionary:attachment.data];
    }
    
    if (!model) {
        [XCHUDTool showErrorWithMessage:@"游戏已经失效" inView:self.view];
        if (message.localExt) {
            NIMMessage *locationMessage = [[PublicGameCache sharePublicGameCache] selectGameInfo:message.messageId];
            TTGameCPPrivateChatModel *locationModel = [TTGameCPPrivateChatModel modelDictionary:locationMessage.localExt];
            locationModel.status = TTGameStatusTypeInvalid;
            locationMessage.localExt = [locationModel model2dictionary];
            [[PublicGameCache sharePublicGameCache] changeGameInfo:locationMessage];
            [self uiUpdateMessage:locationMessage];
        }
        return;
    }
    
    
    [GetCore(MeetingCore) joinMeeting:message.from actor:NO];
    
    @KWeakify(self);
    [[GetCore(TTCPGamePrivateChatCore) requestWatchGameWith:GetCore(AuthCore).getUid.userIDValue GameId:model.gameInfo.gameId ChannelId:model.gameInfo.gameChannel MessageId:message.messageId] subscribeError:^(NSError *error) {@KStrongify(self);
        [XCHUDTool showErrorWithMessage:error.domain inView:self.view];
    }];
    
}


// 我收到游戏结束的回调，对面赢了
- (void)onReceiveCPGamePublicChatGameOverMessageSuccess:(NIMMessage *)message{
    
    NIMCustomObject *obj = (NIMCustomObject *)message.messageObject;
    
    [self.tableView reloadData];
    
}

// 对方退出，游戏取消
- (void)onReceiveCPGamePublicChatGameCancelMessageSuccess:(NIMMessage *)message{
    NIMCustomObject *obj = (NIMCustomObject *)message.messageObject;
    
    XCCPGamePrivateSysNotiAttachment *attachment = (XCCPGamePrivateSysNotiAttachment *)obj.attachment;
    
    TTGameCPPrivateChatModel *model = [TTGameCPPrivateChatModel modelDictionary:attachment.data];
    
    NIMMessage *locationMessage = [[PublicGameCache sharePublicGameCache] selectGameInfo:model.uuId];
    
    NIMCustomObject *locationObj = (NIMCustomObject *)locationMessage.messageObject;
    
    Attachment *locationAchment = (Attachment *)locationObj.attachment;
    
    TTGameCPPrivateChatModel *locationModel = [TTGameCPPrivateChatModel modelDictionary:locationAchment.data];
    
    locationModel.status = TTGameStatusTypeInvalid;
    
    locationMessage.localExt = [locationModel model2dictionary];
    
    [[PublicGameCache sharePublicGameCache] changeGameInfo:locationMessage];
    
    [self uiUpdateMessage:locationMessage];
}


- (void)gameTimeWasWrongAndRrefresh:(NIMMessage *)message{
    [self uiUpdateMessage:message];
}

- (void)watchGameOverFromNormalRoom:(NIMMessage *)message{
    [self uiUpdateMessage:message];
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
