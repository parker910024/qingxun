//
//  TTSessionViewController+PrivateGame.m
//  TTPlay
//
//  Created by new on 2019/3/1.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTSessionViewController+PrivateGame.h"
#import "XCCPGamePrivateSysNotiAttachment.h"
#import "TTGameCPPrivateSysNotiModel.h"
#import "TTCPGamePrivateChatCore.h"
#import "TTGameStaticTypeCore.h"
#import "TTCPGameStaticCore.h"
#import <Masonry/Masonry.h>

#import "XCMediator+TTGameModuleBridge.h"
#import "XCMediator+TTRoomMoudleBridge.h"
//#import "TTWkGameViewController.h"
#import "MeetingCore.h"
#import "ImMessageCore.h"
#import "XCCPGamePrivateAttachment.h"
#import "TTGameCPPrivateChatModel.h"

#import "AuthCore.h"
#import "CPGameCore.h"
#import "XCHUDTool.h"
#import "RoomCoreV2.h"


@implementation TTSessionViewController (PrivateGame)


-(void)selectGameWithGameListDelegate:(CPGameListModel *)model{
    if (GetCore(TTGameStaticTypeCore).launchGameSwitch){
        [XCHUDTool showErrorWithMessage:[NSString stringWithFormat:@"%d秒内仅可以发起一次",GetCore(TTCPGameStaticCore).gameFrequency] inView:self.view];
        return;
    }
    [GetCore(TTGameStaticTypeCore) createrTimer];
    [[BaiduMobStat defaultStat]logEvent:@"private_chat_game_choice" eventLabel:@"点击选择游戏（私聊IM）"];
    
    self.listView.hidden = YES;
    
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time = [date timeIntervalSince1970] * 1000;// * 1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    
    XCCPGamePrivateAttachment * shareMent = [[XCCPGamePrivateAttachment alloc] init];
    shareMent.first = Custom_Noti_Header_CPGAME_PrivateChat;
    shareMent.second = Custom_Noti_Sub_CPGAME_PrivateChat_LaunchGame;
    TTCPGameCustomInfo *gameInfo = [TTCPGameCustomInfo modelDictionary:[model model2dictionary]];
    
    TTGameCPPrivateChatModel *launchGameModel = [[TTGameCPPrivateChatModel alloc] init];
    launchGameModel.startTime = timeString.userIDValue;
    launchGameModel.status = TTGameStatusTypeTimeing;
    launchGameModel.time = 60;
    launchGameModel.gameInfo = gameInfo;
    shareMent.data = [launchGameModel model2dictionary];
    
    [GetCore(ImMessageCore) sendCustomMessageAttachement:shareMent sessionId:self.session.sessionId type:NIMSessionTypeP2P];
    
}

// 匹配进来的
- (void)btnClickLaunchGameWithModel:(CPGameListModel *)model{
    
    if (GetCore(TTGameStaticTypeCore).launchGameSwitch){
        [XCHUDTool showErrorWithMessage:[NSString stringWithFormat:@"%d秒内仅可以发起一次",GetCore(TTCPGameStaticCore).gameFrequency] inView:self.view];
        return;
    }
    [GetCore(TTGameStaticTypeCore) createrTimer];
    
    [[BaiduMobStat defaultStat] logEvent:@"private_chat_favorite" eventLabel:@"TA爱玩的游戏"];
#ifdef DEBUG
    NSLog(@"private_chat_favorite");
#else
    
#endif
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time = [date timeIntervalSince1970] * 1000;// * 1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    
    XCCPGamePrivateAttachment * shareMent = [[XCCPGamePrivateAttachment alloc] init];
    shareMent.first = Custom_Noti_Header_CPGAME_PrivateChat;
    shareMent.second = Custom_Noti_Sub_CPGAME_PrivateChat_LaunchGame;
    TTCPGameCustomInfo *gameInfo = [TTCPGameCustomInfo modelDictionary:[model model2dictionary]];
    
    TTGameCPPrivateChatModel *launchGameModel = [[TTGameCPPrivateChatModel alloc] init];
    launchGameModel.startTime = timeString.userIDValue;
    launchGameModel.status = TTGameStatusTypeTimeing;
    launchGameModel.time = 60;
    launchGameModel.gameInfo = gameInfo;
    shareMent.data = [launchGameModel model2dictionary];
    
    [GetCore(ImMessageCore) sendCustomMessageAttachement:shareMent sessionId:self.session.sessionId type:NIMSessionTypeP2P];
}


- (void)gameTimeWasWrongAndRrefresh:(NIMMessage *)message{
    [self uiUpdateMessage:message];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {  // 点击左上角返回
        [GetCore(TTGameStaticTypeCore) destructionTimer];
        if (GetCore(TTCPGamePrivateChatCore).myMessageDic.allKeys.count > 0) {
            XCCPGamePrivateSysNotiAttachment *sysNotificaton = [[XCCPGamePrivateSysNotiAttachment alloc] init];
            sysNotificaton.first = Custom_Noti_Header_CPGAME_PrivateChat_SystemNotification;
            sysNotificaton.second = Custom_Noti_Sub_CPGAME_PrivateChat_SysNoti_CancelGame;
            TTGameCPPrivateSysNotiModel *model = [[TTGameCPPrivateSysNotiModel alloc] init];
            model.msg = @"约战已失效";
            sysNotificaton.data = [model model2dictionary];
            
            [GetCore(ImMessageCore) sendCustomMessageAttachement:sysNotificaton sessionId:self.session.sessionId type:NIMSessionTypeP2P];
        }else{
            // 退出页面，但是本地并没有存到发的消息，这个时候要从游戏列表中取到游戏，然后更新消息状态
            NSArray *array = [GetCore(ImMessageCore) getMessagesInSession:self.session message:nil limit:20];
            for (int i = 0; i < array.count; i++) {
                NIMMessage *myMessage = [array safeObjectAtIndex:i];
                if (![myMessage.messageObject isKindOfClass:NIMCustomObject.class]) {
                    continue;
                }
                NIMCustomObject *object = (NIMCustomObject *)myMessage.messageObject;
                if ([object.attachment isKindOfClass:Attachment.class]) {
                    Attachment *customObject = (Attachment*)object.attachment;
                    if (customObject.first == Custom_Noti_Header_CPGAME_PrivateChat) {
                        if (myMessage.localExt == nil) {
                            if ([myMessage.from isEqualToString:GetCore(AuthCore).getUid]) {
                                XCCPGamePrivateSysNotiAttachment *sysNotificaton = [[XCCPGamePrivateSysNotiAttachment alloc] init];
                                sysNotificaton.first = Custom_Noti_Header_CPGAME_PrivateChat_SystemNotification;
                                sysNotificaton.second = Custom_Noti_Sub_CPGAME_PrivateChat_SysNoti_CancelGame;
                                TTGameCPPrivateSysNotiModel *model = [[TTGameCPPrivateSysNotiModel alloc] init];
                                model.msg = @"约战已失效";
                                sysNotificaton.data = [model model2dictionary];
                                
                                [GetCore(ImMessageCore) sendCustomMessageAttachement:sysNotificaton sessionId:self.session.sessionId type:NIMSessionTypeP2P];
                                return;
                            }
                        }
                    }
                }
                
            }
        }
    }
}

#pragma mark --- TTCPGamePrivateChatClient 私聊游戏的方法 ---
- (void)acceptGameFromPrivateChat:(NSDictionary *)jsonDict GameUrl:(NSString *)gameUrl FromUid:(NIMMessage *)message{
    
    [[BaiduMobStat defaultStat]logEvent:@"private_chat_game_accept" eventLabel:@"点击接受按钮（私聊IM）"];
    self.acceptMessageID = message.messageId;
    
    TTGameCPPrivateChatModel *model = [TTGameCPPrivateChatModel modelDictionary:jsonDict];
    
    // 接受了其中一款游戏，其他游戏要全部变失效。
    NSArray *array = [GetCore(ImMessageCore) getMessagesInSession:self.session message:nil limit:20];
    for (int i = 0; i < array.count; i++) {
        NIMMessage *myMessage = array[i];
        if (![myMessage.messageObject isKindOfClass:NIMCustomObject.class]) {
            continue;
        }
        NIMCustomObject *object = (NIMCustomObject *)myMessage.messageObject;
        if ([object.attachment isKindOfClass:Attachment.class]) {
            XCCPGamePrivateAttachment *customObject = (XCCPGamePrivateAttachment*)object.attachment;
            if (customObject.first == Custom_Noti_Header_CPGAME_PrivateChat) {
                if (myMessage.localExt == nil) {
                    if (![myMessage.messageId isEqualToString:model.uuId]) {
                        TTGameCPPrivateChatModel *launchGameModel = [TTGameCPPrivateChatModel modelDictionary:customObject.data];
                        launchGameModel.status = TTGameStatusTypeInvalid;
                        launchGameModel.uuId = myMessage.messageId;
                        myMessage.localExt = [launchGameModel model2dictionary];
                        [GetCore(ImMessageCore) updateMessage:myMessage
                                                      session:myMessage.session];
                    }
                }
            }
        }
    }
    
    // 我接受了游戏 给对方发送云信自定义系统通知
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NIMCustomSystemNotification *Notification = [[NIMCustomSystemNotification alloc] initWithContent:jsonString];
    [[NIMSDK sharedSDK].systemNotificationManager sendCustomNotification:Notification toSession:self.session completion:nil];
    
    [self enterGameWebViewWithGameUrl:gameUrl];
    
    if (!self.isRoomMessage) {
        if (!GetCore(RoomCoreV2).isInRoom){
            [GetCore(MeetingCore) setCloseMicro:NO];
            [GetCore(MeetingCore) joinMeeting:message.from actor:YES];
        }
    }
}

//  我收到了对方发来的接受游戏的云信系统自定义通知要更新消息
-(void)gameStartFromPrivateChat:(NSDictionary *)dict{
    
    NSString *messageID = dict[@"uuId"];
    self.acceptMessageID = messageID;
    if([GetCore(TTCPGamePrivateChatCore).myMessageDic.allKeys containsObject:messageID]){
        NIMMessage *acceptMessage = [GetCore(TTCPGamePrivateChatCore).myMessageDic objectForKey:messageID];
        
        NIMCustomObject *object = (NIMCustomObject *)acceptMessage.messageObject;
        XCCPGamePrivateAttachment *customObject = (XCCPGamePrivateAttachment*)object.attachment;
        
        TTGameCPPrivateChatModel *launchGameModel = [TTGameCPPrivateChatModel modelDictionary:customObject.data];
        launchGameModel.status = TTGameStatusTypeAccept;
        launchGameModel.uuId = acceptMessage.messageId;
        acceptMessage.localExt = [launchGameModel model2dictionary];
        [GetCore(ImMessageCore) updateMessage:acceptMessage
                                      session:acceptMessage.session];
    }
    
    // 对方接受了我的游戏，其他游戏要全部失效
    NSArray *array = [GetCore(ImMessageCore) getMessagesInSession:self.session message:nil limit:20];
    for (int i = 0; i < array.count; i++) {
        NIMMessage *myMessage = array[i];
        if (![myMessage.messageObject isKindOfClass:NIMCustomObject.class]) {
            continue;
        }
        NIMCustomObject *object = (NIMCustomObject *)myMessage.messageObject;
        if ([object.attachment isKindOfClass:Attachment.class]) {
            Attachment *customObject = (Attachment*)object.attachment;
            if (customObject.first == Custom_Noti_Header_CPGAME_PrivateChat) {
                if (myMessage.localExt == nil) {
                    if (![myMessage.messageId isEqualToString:messageID]) {
                        TTGameCPPrivateChatModel *launchGameModel = [TTGameCPPrivateChatModel modelDictionary:customObject.data];
                        launchGameModel.status = TTGameStatusTypeInvalid;
                        launchGameModel.uuId = myMessage.messageId;
                        myMessage.localExt = [launchGameModel model2dictionary];
                        [GetCore(ImMessageCore) updateMessage:myMessage
                                                      session:myMessage.session];
                    }
                }
            }
        }
    }
    
    
    [self enterGameWebViewWithGameUrl:dict[@"gameUrl"]];
    
    if (!self.isRoomMessage) {
        if (!GetCore(RoomCoreV2).isInRoom){
            [GetCore(MeetingCore) setCloseMicro:NO];
            [GetCore(MeetingCore) joinMeeting:GetCore(AuthCore).getUid actor:YES];
        }
    }
}


-(void)onCPGamePrivateChatList:(NSArray *)listArray{
    self.gameListArray = [NSMutableArray array];
    
    if ([GetCore(TTGameStaticTypeCore).gameID length] > 0){
        // 点击了挑战
        for (int i = 0; i < listArray.count; i++) {
            CPGameListModel *model = listArray[i];
            if ([model.gameId isEqualToString:GetCore(TTGameStaticTypeCore).gameID]) {
                // 挑战的是这一款游戏
                [self selectGameWithGameListDelegate:model];
                GetCore(TTGameStaticTypeCore).gameID = @"";
                break;
            }
        }
    }else{
        for (int i = 0; i < listArray.count; i++) {
            [self.gameListArray addObject:[listArray[i] model2dictionary]];
        }
        [[NSUserDefaults standardUserDefaults] setObject:self.gameListArray forKey:@"gameListArray"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

-(void)gameOverFromPrivateChat:(NSDictionary *)resultData{
    
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
        
        model.msg = [NSString stringWithFormat:@"%@ %@ 战胜了 %@",gameName,winnerString,failersString];
    }
    sysNotificaton.data = [model model2dictionary];
    
    [GetCore(ImMessageCore) sendCustomMessageAttachement:sysNotificaton sessionId:self.session.sessionId type:NIMSessionTypeP2P];
}

//  请求游戏数据
- (void)requestGameListData{
    @KWeakify(self);
    [[GetCore(TTCPGamePrivateChatCore) requestCPGamePrivateChatList:GetCore(AuthCore).getUid.userIDValue PageNum:1 PageSize:30] subscribeError:^(NSError *error) {
        @KStrongify(self);
        [XCHUDTool showErrorWithMessage:error.domain inView:self.view];
    }];
    
}

// 进入游戏
- (void)enterGameWebViewWithGameUrl:(NSString *)gameUrl{
    if ([[self topViewController] isKindOfClass:NSClassFromString(@"TTWkGameViewController")]) {
        NSLog(@"webView已经有了");
        return;
    }
    if (!self.isRoomMessage) {
        if (GetCore(RoomCoreV2).isInRoom){
            if (![self judgeRoomHaveExist]){ //  在房间内，但是房间不存在。说明房间最小化
                [GetCore(RoomCoreV2) closeRoom:GetCore(AuthCore).getUid.userIDValue];
                [[XCMediator sharedInstance] ttRoomMoudle_closeRoomViewController];
            }
        }
    }
    @weakify(self);
    UIViewController *gameVC = [[XCMediator sharedInstance] ttGameMoudle_TTWkGameViewControllerWithUrlStr:gameUrl Watch:NO SuperViewType:@"privateChat" block:^(NSString *typeString,NSString *gameId){
        @strongify(self);
        if ([typeString isEqualToString:@"换个游戏"]) {
            self.listView.hidden = NO;
        }
    }];
    
    [GetCore(TTGameStaticTypeCore) destructionTimer];
    
    [self.navigationController pushViewController:gameVC animated:YES];
    
    
}


- (NSString *)dictionaryToJson:(NSDictionary *)dict{
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        NSLog(@"%@",error);
    } else {
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

// 判断房间是否存在
- (BOOL )judgeRoomHaveExist{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:NSClassFromString(@"TTGameRoomContainerController")]) {
            return YES;
        }else{
            return NO;
        }
    }
    return NO;
}


@end
