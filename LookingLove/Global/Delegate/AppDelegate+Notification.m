//
//  AppDelegate+Notification.m
//  LookingLove
//
//  Created by lvjunhang on 2019/12/26.
//  Copyright © 2019 WUJIE INTERACTIVE. All rights reserved.
//

#import "AppDelegate+Notification.h"

#import "TTServiceCore.h"
#import "APNSCore.h"

#import <UMPush/UMessage.h>

@implementation AppDelegate (Notification)

- (void)initializeUserPushNotificationServiceWithLaunchOptions:(NSDictionary *)launchOptions {
    //友盟、云信推送SDK无需在此初始化，暂时留空
    
    // 友盟推送注册（实际触发的用户推送权限弹窗的入口）
    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:nil completionHandler:^(BOOL granted, NSError * _Nullable error) {
    }];
    
    //启动应用触发推送消息处理，具体触发事件不清楚，这里搬运之前业务逻辑
    NSDictionary *launchOptionsRemoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (launchOptionsRemoteNotification != nil) {
        [GetCore(APNSCore) handleRemoteNotification:launchOptionsRemoteNotification];
    }
}

- (void)handleRemoteNotificationDeviceToken:(NSData *)deviceToken {
    
    //友盟注册token
    [UMessage registerDeviceToken:deviceToken];

    [GetCore(ImLoginCore) updateApnsToken:deviceToken];
//    [GetCore(TTServiceCore) updateDeviceTokenWith:deviceToken];
    
    //用户可以在这个方法里面获取devicetoken
    NSString *deviceStr = @"";
    if (@available(iOS 13.0, *)) {
        if (![deviceToken isKindOfClass:[NSData class]]) return;
        const unsigned *tokenBytes = (const unsigned *)[deviceToken bytes];
        deviceStr = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                              ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                              ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                              ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    } else {
        deviceStr = [NSString stringWithFormat:@"%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
         stringByReplacingOccurrencesOfString: @">" withString: @""]
                                                      stringByReplacingOccurrencesOfString: @" " withString: @""]];
    }
    
    NSLog(@"当前设备的 deviceToken 为 ：%@ ", deviceStr);
}

- (void)onReceiveRemoteNotificationWithInfo:(NSDictionary *)userInfo {
    if (userInfo.count == 0) {
        return;
    }
    
    [UMessage setAutoAlert:NO];
    [UMessage didReceiveRemoteNotification:userInfo];
    
    if (self.needHandlerNotification) {
        //推送消息处理最终落地都在这里面
        [GetCore(APNSCore) handleRemoteNotification:userInfo];
    }
}

@end
