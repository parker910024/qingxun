//
//  NotificationCore.m
//  BberryCore
//
//  Created by chenran on 2017/6/17.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "NotificationCore.h"
#import "NotificationCoreClient.h"
#import <NIMSDK/NIMSDK.h>
#import "TTGameCPPrivateChatModel.h"
#import "TTCPGamePrivateChatClient.h"
#import "TTCPGameOverAndSelectClient.h"
#import "APNSCoreClient.h"
#import "RoomCoreClient.h"

#import "UserCore.h"
#import "AuthCore.h"
#import "ImRoomCoreV2.h"
#import "ImMessageCoreClient.h"


#import "NSDictionary+JSON.h"
#import "NobleSourceTool.h"



@interface NotificationCore()<NIMSystemNotificationManagerDelegate>
@end

@implementation NotificationCore

+ (void)load{
    GetCore(NotificationCore);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NIMSDK sharedSDK].systemNotificationManager addDelegate:self];
    }
    return self;
}

- (void)dealloc
{
    [[NIMSDK sharedSDK].systemNotificationManager removeDelegate:self];
}

#pragma mark -NIMSystemNotificationManagerDelegate
- (void)onReceiveSystemNotification:(NIMSystemNotification *)notification
{
    if (notification.type == NIMSystemNotificationTypeTeamApply) {
        NotifyCoreClient(NotificationCoreClient, @selector(onRecvTeamApplyNoti:), onRecvTeamApplyNoti:notification);
    } else if (notification.type == NIMSystemNotificationTypeTeamApplyReject) {
        NotifyCoreClient(NotificationCoreClient, @selector(onRecvTeamApplyRejectNoti:), onRecvTeamApplyRejectNoti:notification);
    } else if (notification.type == NIMSystemNotificationTypeTeamInvite) {
        NotifyCoreClient(NotificationCoreClient, @selector(onRecvTeamInviteNoti:), onRecvTeamInviteNoti:notification);
    } else if (notification.type == NIMSystemNotificationTypeTeamIviteReject) {
        NotifyCoreClient(NotificationCoreClient, @selector(onRecvTeamIviteRejectNoti:), onRecvTeamIviteRejectNoti:notification);
    } else if (notification.type == NIMSystemNotificationTypeFriendAdd) {
        NotifyCoreClient(NotificationCoreClient, @selector(onRecvFriendAddNoti:), onRecvFriendAddNoti:notification);
    }
}

- (void)onReceiveCustomSystemNotification:(NIMCustomSystemNotification *)notification
{
    if (notification.receiverType == NIMSessionTypeP2P) {
        if (notification.content != nil) {
            NSData *jsonData = [notification.content dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
            if(err) {
                NotifyCoreClient(NotificationCoreClient, @selector(onRecvCustomP2PNoti:), onRecvCustomP2PNoti:notification);
                NSLog(@"json解析失败：%@",err);
                return;
            }
            if ([dic[@"first"] intValue] == 29) { // 游戏匹配
                if ([dic isKindOfClass:[NSDictionary class]]) {
                    NotifyCoreClient(APNSCoreClient, @selector(onMatchingPeopleAndData:), onMatchingPeopleAndData:dic);
                }else{
                    NotifyCoreClient(APNSCoreClient, @selector(onMatchingPeopleFailed), onMatchingPeopleFailed);
                }
            }else if ([dic[@"first"] intValue] == 35) { // 找玩友匹配
                if ([dic[@"second"] intValue] == 351) {
                    NotifyCoreClient(APNSCoreClient, @selector(onFindFriendMatchingWithData:), onFindFriendMatchingWithData:dic);
                }
            } else if ([dic[@"first"] intValue] == 36){
                NotifyCoreClient(APNSCoreClient, @selector(onOppositeSexMatchingWithData:), onOppositeSexMatchingWithData:dic);
            } else if ([dic[@"first"] integerValue] == 48) {
                // 青少年模式下，房间在线时长达到上限
                if ([dic[@"second"] integerValue] == 481) {
                    NotifyCoreClient(RoomCoreClient, @selector(roomOnLineTimsMaxWithMessage:), roomOnLineTimsMaxWithMessage:dic[@"data"][@"msg"]);
                }
            } else if ([dic[@"first"] integerValue] == Custom_Noti_Header_NameplateNoti) {
                // 更改铭牌收到的消息
                if ([dic[@"second"] integerValue] == Custom_Noti_Sub_NameplateNoti_RoomUpdate) {
                    NotifyCoreClient(ImMessageCoreClient, @selector(onUpdateNameplate), onUpdateNameplate);
     
//                    [[GetCore(UserCore)getUserInfoByRac:[GetCore(AuthCore) getUid].userIDValue refresh:YES]subscribeNext:^(id x) {
//                        if (x) {
//                            //    UserInfo *userInfo = (UserInfo *)x;
//
//
//                        }
//                    }];

                }
            } else if (dic[@"gameType"]) { //  游戏结束之后，再来一局，换个游戏，换个对手
                if ([dic[@"gameType"] intValue] == 1) {
                    NotifyCoreClient(TTCPGameOverAndSelectClient, @selector(receiveAgainGameAction), receiveAgainGameAction);
                }else if ([dic[@"gameType"] intValue] == 3){
                    NotifyCoreClient(TTCPGameOverAndSelectClient, @selector(sendAgreePlayGameAgainAction), sendAgreePlayGameAgainAction);
                }else if ([dic[@"gameType"] intValue] == 4){
                    NotifyCoreClient(TTCPGameOverAndSelectClient, @selector(receiveAnotherOneLiveGameAction), receiveAnotherOneLiveGameAction);
                }
            } else if (dic[@"faceUrl"]) {
                NotifyCoreClient(TTCPGameOverAndSelectClient, @selector(receiveAnotherOneSendFaceAcitonWithFaceString:), receiveAnotherOneSendFaceAcitonWithFaceString:dic[@"faceUrl"]);
            } else {
                TTGameCPPrivateChatModel *model = [TTGameCPPrivateChatModel modelDictionary:dic];
                if (model.uuId.length > 0 && model.gameInfo) { // 私聊发起游戏
                    NotifyCoreClient(TTCPGamePrivateChatClient, @selector(gameStartFromPrivateChat:), gameStartFromPrivateChat:dic);
                }else{
                    NotifyCoreClient(NotificationCoreClient, @selector(onRecvCustomP2PNoti:), onRecvCustomP2PNoti:notification);
                }
            }
        }else{
            NotifyCoreClient(NotificationCoreClient, @selector(onRecvCustomP2PNoti:), onRecvCustomP2PNoti:notification);
        }
    } else if (notification.receiverType == NIMSessionTypeTeam) {
        NotifyCoreClient(NotificationCoreClient, @selector(onRecvCustomTeamNoti:), onRecvCustomTeamNoti:notification);
    } else if (notification.receiverType == NIMSessionTypeChatroom) {
        NotifyCoreClient(NotificationCoreClient, @selector(onRecvCustomChatRoomNoti:), onRecvCustomChatRoomNoti:notification);
    }
}
@end
