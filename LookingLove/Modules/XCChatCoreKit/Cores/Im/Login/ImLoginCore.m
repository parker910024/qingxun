//
//  ImLoginCore.m
//  BberryCore
//
//  Created by chenran on 2017/4/15.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "ImLoginCore.h"

#import <NIMSDK/NIMSDK.h>

#import "AuthCore.h"
#import "AuthCoreClient.h"
#import "ImLoginCoreClient.h"
#import "PurseCore.h"
#import "NIMKitCore.h"
#import "NotificationCoreClient.h"

#import "HostUrlManager.h"
#import "XCLogger.h"

@interface ImLoginCore()<AuthCoreClient, NIMLoginManagerDelegate>
@property (nonatomic, strong) NSData *apnsToken;
@property (nonatomic, assign) BOOL isImLogined;
@end

@implementation ImLoginCore



- (instancetype)init
{
    self = [super init];
    if (self) {
        AddCoreClient(AuthCoreClient, self);
        AddCoreClient(NotificationCoreClient,self);
#ifdef DEBUG

        EnvironmentType env = [[NSUserDefaults standardUserDefaults]integerForKey:kAppNetWorkEnv];

        if (env==DevType){
            [[NIMSDK sharedSDK] registerWithAppID:keyWithType(KeyType_NetEase, YES) cerName:keyWithType(KeyType_APNSCer, YES)];
        }else if (env==TestType){
            NSString *key = keyWithType(KeyType_NetEase, YES);
            NSString *c = keyWithType(KeyType_APNSCer, YES);
            [[NIMSDK sharedSDK] registerWithAppID:key cerName:c];
        }else if (env==Pre_ReleaseType){
             [[NIMSDK sharedSDK] registerWithAppID:keyWithType(KeyType_NetEase, NO) cerName:keyWithType(KeyType_APNSCer, NO)];
        }else if (env==ReleaseType){
             [[NIMSDK sharedSDK] registerWithAppID:keyWithType(KeyType_NetEase, NO) cerName:keyWithType(KeyType_APNSCer, NO)];
        }else{
            //默认是测试环境
            [[NIMSDK sharedSDK] registerWithAppID:keyWithType(KeyType_NetEase, YES) cerName:keyWithType(KeyType_APNSCer, YES)];
        }
#else
        [[NIMSDK sharedSDK] registerWithAppID:keyWithType(KeyType_NetEase, NO) cerName:keyWithType(KeyType_APNSCer, NO)];
#endif
        
        [NIMSDKConfig sharedConfig].enabledHttpsForInfo = NO;
        [[NIMSDK sharedSDK].loginManager addDelegate:self];
        [self registerAPNs];
    }
    return self;
}

- (void)dealloc
{
    RemoveCoreClient(AuthCoreClient, self);
    RemoveCoreClient(NotificationCoreClient,self);
    [[NIMSDK sharedSDK].loginManager removeDelegate:self];
}

- (void)registerAPNs
{
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerForRemoteNotifications)])
    {
        UIUserNotificationType types = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound |      UIRemoteNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        UIRemoteNotificationType types = UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound |        UIRemoteNotificationTypeBadge;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];
    }
    
}

- (void)handleRemoteNotification:(NSDictionary *)userInfo
{
    if (userInfo != nil && userInfo.count > 0) {
        NotifyCoreClient(ImLoginCoreClient, @selector(onRecieveRemoteNotification:), onRecieveRemoteNotification:userInfo);
    }
}

#pragma mark - NotificationCoreClient
- (void)onRecvCustomP2PNoti:(NIMCustomSystemNotification *)notification{
    if (notification.apnsPayload != nil && notification.apnsPayload.count>0) {
        NotifyCoreClient(ImLoginCoreClient, @selector(onRecieveRemoteNotification:), onRecieveRemoteNotification:notification.apnsPayload);        
    }
}

- (BOOL)isImLogin
{
    return [[NIMSDK sharedSDK].loginManager isLogined];
}

- (void)updateApnsToken:(NSData *)token
{
    self.apnsToken = token;
}

#pragma -mark AuthCoreClient
- (void)onLoginSuccess
{
    NSString *uid = [GetCore(AuthCore) getUid];
    NSString *token = [GetCore(AuthCore) getNetEaseToken];
    
    NIMAutoLoginData *data = [[NIMAutoLoginData alloc] init];
    data.account = uid;
    data.token = token;
    NSLog("uid:%@, token:%@", uid, token);
    data.forcedMode = NO;
    [[NIMSDK sharedSDK].loginManager autoLogin:data];
    [[NIMSDK sharedSDK].systemNotificationManager markAllNotificationsAsRead];
    [self markNotificationRead];
}

- (void)onLogout
{
    [[NIMSDK sharedSDK].loginManager logout:^(NSError * _Nullable error) {
        if (error == nil) {
            [[XCLogger shareXClogger]sendLog:@{EVENT_ID:CImLogin} error:nil topic:IMLog logLevel:XCLogLevelVerbose];

            NotifyCoreClient(ImLoginCoreClient, @selector(onImLogoutSuccess), onImLogoutSuccess);
        } else {
            [[XCLogger shareXClogger]sendLog:@{EVENT_ID:CImLogin} error:error topic:IMLog logLevel:XCLogLevelError];
            [[XCLogger shareXClogger]sendLog:@{EVENT_ID:CImLogin} error:error topic:IMLog logLevel:XCLogLevelError];
        }
        
    }];
}

#pragma mark - Private Method

- (BOOL)getImLoginState {
    return self.isImLogined;
}

#pragma -mark 云信sdk
- (void)onLogin:(NIMLoginStep)step
{
    NSLog("===>onLogin step: %@", @(step));
    if (step == NIMLoginStepLoginOK) {
        //        [GetCore(PurseCore)isAuditing];
        self.isImLogined = YES;

        [[NIMSDK sharedSDK] updateApnsToken:self.apnsToken];
        NotifyCoreClient(ImLoginCoreClient, @selector(onImLoginSuccess), onImLoginSuccess);
        [[XCLogger shareXClogger]sendLog:@{EVENT_ID:CImLogin} error:nil topic:IMLog logLevel:XCLogLevelVerbose];
    } else if (step == NIMLoginStepSyncOK) {
        NotifyCoreClient(ImLoginCoreClient, @selector(onImSyncSuccess), onImSyncSuccess);
    }else if (step == NIMLoginStepLoseConnection) {
        self.isImLogined = NO;
    }else if (step == NIMLoginStepLinkFailed) {
        self.isImLogined = NO;\
    }
}

- (void)onAutoLoginFailed:(NSError *)error
{
    NSString *uid = [GetCore(AuthCore) getUid];
    NSString *token = [GetCore(AuthCore) getNetEaseToken];
    [[[NIMSDK sharedSDK] loginManager] login:uid token:token completion:^(NSError * _Nullable error) {
        if (error != nil) {
            
            [[XCLogger shareXClogger]sendLog:@{EVENT_ID:CImLogin} error:error topic:IMLog logLevel:XCLogLevelError];
            NotifyCoreClient(ImLoginCoreClient, @selector(onImLoginFailth), onImLoginFailth);
        } else {
            [[XCLogger shareXClogger]sendLog:@{EVENT_ID:CImLogin} error:nil topic:IMLog logLevel:XCLogLevelVerbose];
        }
    }];
}

- (void)onKick:(NIMKickReason)code clientType:(NIMLoginClientType)clientType
{
    NotifyCoreClient(ImLoginCoreClient, @selector(onImKick), onImKick);
}

- (void)markNotificationRead {
    [[NIMSDK sharedSDK].apnsManager registerBadgeCountHandler:^NSUInteger{
        return 0;
    }];
}

- (BOOL)judgeTheEnv {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault integerForKey:kAppNetWorkEnv] == ReleaseType) {
        return YES;
    } else {
        return NO;
    }
}


//
//#pragma mark - HomeCoreClient
//- (void)networkReconnect {
//    if ([GetCore(AuthCore)getTicket]) {
//        [self onLoginSuccess];
//    }
//}

@end
