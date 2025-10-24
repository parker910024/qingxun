//
//  NotificationCoreClient.h
//  BberryCore
//
//  Created by chenran on 2017/6/17.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NIMSDK/NIMSDK.h>
@protocol NotificationCoreClient <NSObject>
@optional
- (void)onRecvTeamApplyNoti:(NIMSystemNotification *)notification;
- (void)onRecvTeamApplyRejectNoti:(NIMSystemNotification *)notification;
- (void)onRecvTeamInviteNoti:(NIMSystemNotification *)notification;
- (void)onRecvTeamIviteRejectNoti:(NIMSystemNotification *)notification;
- (void)onRecvFriendAddNoti:(NIMSystemNotification *)notification;

- (void)onRecvCustomChatRoomNoti:(NIMCustomSystemNotification *)notification;
- (void)onRecvCustomP2PNoti:(NIMCustomSystemNotification *)notification;
- (void)onRecvCustomTeamNoti:(NIMCustomSystemNotification *)notification;
@end
