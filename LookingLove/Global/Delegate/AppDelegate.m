//
//  AppDelegate.m
//  LookingLove
//
//  Created by KevinWang on 2019/7/24.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+UI.h"
#import "AppDelegate+Config.h"
#import "AppDelegate+TTSDKConfig.h"
#import "AppDelegate+Notification.h"
#import "AppDelegate+Features.h"

#import "TTWKWebCrashConfig.h"

#import "BaseNavigationController.h"

//core
#import "ClientCore.h"
#import "ImLoginCore.h"
#import "ShareCore.h"
#import "AdCore.h"
#import "ImPublicChatroomCore.h"
#import "PublicChatroomMessageCore.h"
#import "VersionCore.h"
#import "LinkedMeCore.h"
#import "PurseCore.h"
#import "FaceCore.h"
#import "NobleCore.h"
#import "ImRoomCoreV2.h"
#import "MentoringShipCore.h"
#import "AuthCore.h"
#import "AuthCoreClient.h"
#import "AppInitClient.h"
#import "ImLoginCore.h"
#import "HostUrlManager.h"

#import "XCMediator+TTAuthModule.h"
#import "TTRoomModuleCenter.h"
#import "TTWKWebViewViewController.h"

#import "XCHtmlUrl.h"

#import <AvoidCrash.h>
#import <SDImageCache.h>


#if TARGET_IPHONE_SIMULATOR//模拟器
//
#elif TARGET_OS_IPHONE//真机

#endif
// hx工具
#import "LookingLoveMain.h"

//tool
#import <BaiduMobStatCodeless/BaiduMobStat.h>
#import "TTStatisticsService.h"
#import "XCMacros.h"

#ifdef DEBUG
#import <DoraemonKit/DoraemonKit.h>
#endif

@interface AppDelegate ()<AuthCoreClient>
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
    #ifdef DEBUG
    //默认
    [[DoraemonManager shareInstance] install];
    #endif
    
    [LookingLoveMain lookingLoveDidFinishLaunchingWithOptions];
    [self launchOpWith:application optional:launchOptions];
    
    return YES;
}


- (void)launchOpWith:(UIApplication *)app optional:(NSDictionary *)optional {
    // 清空角标
    app.applicationIconBadgeNumber = 0;
    
#ifdef DEBUG
    
#else
    [AvoidCrash makeAllEffective];
#endif
    
    [self initNetWork]; // 初始化网络环境
    [self initSDKConfigOnTime]; // 需要第一时间注册的 SDK
    [self setAppMainUI]; // 主控制器
    [self setupLaunchADView]; // 启动广告
    [self tutuInitCore];  // core 监听
    
    [GetCore(LinkedMeCore) initLinkedMEWithLaunchOptions:optional];  // linked
    [GetCore(PurseCore) requestCheckTranscationIds];  // 验证钱包
    
    // 推送注册
    [self initializeUserPushNotificationServiceWithLaunchOptions:optional];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealwithCrashMessage:) name:AvoidCrashNotification object:nil];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"deleteSuperAdmin"];
    
    [[XCMediator sharedInstance] ttAuthModule_authModule]; // 授权页面
    
    [self initSDKConfigLater]; // 可以稍后时间注册的 SDK
    
    [TTWKWebCrashConfig handleWKWebViewCrash]; // webView Crash 收集
    [TTRoomModuleCenter defaultCenter]; // 房间初始化，这个方法比较耗时，所以放在最后处理
}

#pragma mark -
#pragma mark 初始化网络环境
//初始化网络环境
- (void)initNetWork {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if (![userDefault integerForKey:kAppNetWorkEnv]) { //如果没有默认环境 即第一次加载
        [userDefault setInteger:ReleaseType forKey:kAppNetWorkEnv]; //设置默认环境为证实环境 0测试 1正式
    }
}

#pragma mark -
#pragma mark addCoreClient
- (void)tutuInitCore {
    GetCore(ImPublicChatroomCore);
    GetCore(ImLoginCore);
    GetCore(ShareCore);
    GetCore(AdCore);
    GetCore(ClientCore);
    GetCore(MentoringShipCore);
    GetCore(PublicChatroomMessageCore);
    GetCore(GuildCore);
    
    AddCoreClient(AppInitClient, self);
    AddCoreClient(GiftCoreClient, self);
    AddCoreClient(NobleCoreClient, self);
    AddCoreClient(ActivityCoreClient, self);
    AddCoreClient(VersionCoreClient, self);
    AddCoreClient(HttpErrorClient, self);
    AddCoreClient(GuildCoreClient, self);
    AddCoreClient(ImRoomCoreClientV2, self);
    AddCoreClient(MentoringShipCoreClient, self);
    AddCoreClient(AuthCoreClient, self);
}

#pragma mark - AuthCoreClient
- (void)onLoginSuccess {
    // 登录成功后需要请求定位
    [self locationWithCompletionBlock];
}

// 完善用户信息后发出通知
- (void)fullinUserInfoSuccess {
    [self startConfigLocation];
}

#pragma mark -
#pragma mark 崩溃信息收集
- (void)dealwithCrashMessage:(NSNotification *)note {
    //注意:所有的信息都在userInfo中
    //你可以在这里收集相应的崩溃信息进行相应的处理(比如传到自己服务器)
    if (note.userInfo) {
        [[XCLogger shareXClogger]sendLog:@{@"data":[note.userInfo yy_modelToJSONString],EVENT_ID:CNullCrash} error:nil topic:SystemLog logLevel:XCLogLevelError];
        NSLog(@"%@",note.userInfo);
    }
}

//实现深度链接技术
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    //判断是否是通过LinkedME的UrlScheme唤起App
    if ([[url description] rangeOfString:@"click_id"].location != NSNotFound) {
        return [GetCore(LinkedMeCore)judgeDeepLinkWith:url];
    }else if ([[url description] rangeOfString:@"action=h5Login"].location != NSNotFound){
        if (GetCore(AuthCore).isLogin) {
            UINavigationController *nav = self.tabBarController.selectedViewController;
            TTWKWebViewViewController *webVc = [[TTWKWebViewViewController alloc] init];
            webVc.urlString = [NSString stringWithFormat:@"%@?%@",HtmlUrlKey(kWebOauthLoginURL),url.query];
            [nav pushViewController:webVc animated:YES];
        }
    }
    
    return YES;
}

//Universal Links 通用链接实现深度链接技术
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler {
    //判断是否是通过LinkedME的Universal Links唤起App
    if ([[userActivity.webpageURL description] rangeOfString:@"lkme.cc"].location != NSNotFound) {
        return  [GetCore(LinkedMeCore)judgeDeepLinkWithUniversal:userActivity];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [LookingLoveMain lookingLoveApplicationWillResignActive];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [LookingLoveMain lookingLoveApplicationDidEnterBackground];
    self.needHandlerNotification = YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [LookingLoveMain lookingLoveApplicationWillEnterForeground];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [LookingLoveMain lookingLoveApplicationDidBecomeActive];
    
    // 清空角标
    application.applicationIconBadgeNumber = 0;
    
    self.needHandlerNotification = NO;

    [[NIMSDK sharedSDK].systemNotificationManager markAllNotificationsAsRead];
    [GetCore(ImLoginCore) markNotificationRead];

    // 延迟 2s 处理解析暗号操作
    @weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self);
        // 解析暗号
        [self analysisSecretCodeKey];
        
        // 更新地理位置判断，热启动时，同一天只上报一次
        NSDate *locationUpdateDate = [[NSUserDefaults standardUserDefaults] objectForKey:kLastUpdateLocationDateStoreKey];
        if ([locationUpdateDate isKindOfClass:NSDate.class]) {
            BOOL sameDay = [[NSCalendar currentCalendar] isDateInToday:locationUpdateDate];
            if (!sameDay) {
                [self locationWithCompletionBlock];
            }
        }
    });
}

#pragma mark - Notification
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [self handleRemoteNotificationDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError:%@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    [self onReceiveRemoteNotificationWithInfo:userInfo];
    
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark - 内存警告
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    [GetCore(FaceCore)cleanFaceMemoryCache];
    [GetCore(NobleCore)cleanNobleMemoryCache];
    [[SDImageCache sharedImageCache]clearMemory];
    
    [[XCLogger shareXClogger]sendLog:@{EVENT_ID:CMemoryWarning} error:nil topic:SystemLog logLevel:(XCLogLevel)XCLogLevelWarn];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [LookingLoveMain lookingLoveApplicationWillTerminate];
    
    if (GetCore(ImRoomCoreV2).currentRoomInfo) {
        [[BaiduMobStat defaultStat]eventEnd:@"room_length_of_stay_time" eventLabel:@"在房间内停留时长"];
    }    
}

@end

