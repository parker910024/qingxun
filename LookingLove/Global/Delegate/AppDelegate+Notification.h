//
//  AppDelegate+Notification.h
//  LookingLove
//
//  Created by lvjunhang on 2019/12/26.
//  Copyright © 2019 WUJIE INTERACTIVE. All rights reserved.
//  消息推送处理

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (Notification)

/**
 * 注册用户的推送权限
 * @discussion 同时初始化第三方推送SDK，该接口是实际触发的用户推送权限弹窗的入口
 */
- (void)initializeUserPushNotificationServiceWithLaunchOptions:(NSDictionary *)launchOptions;

/**
 * 处理远程推送的deviceToken
 * @discussion 该接口将deviceToken上传到第三方服务器，以便第三方能通过APNs推送通知到本机
 */
- (void)handleRemoteNotificationDeviceToken:(NSData *)deviceToken;

/**
 * 收到推送后处理
 */
- (void)onReceiveRemoteNotificationWithInfo:(NSDictionary *)userInfo;

@end

NS_ASSUME_NONNULL_END
