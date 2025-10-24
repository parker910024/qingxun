//
//  AppDelegate.h
//  LookingLove
//
//  Created by KevinWang on 2019/7/24.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImLoginCore.h"
#import "ShareCore.h"
#import "ClientCore.h"
#import "NobleCoreClient.h"
#import "GiftCoreClient.h"
#import "AdCoreClient.h"
#import "GuildCore.h"
#import "GuildCoreClient.h"
#import "UserCore.h"
#import "MentoringShipCoreClient.h"

#import "BaseTabBarViewController.h"

#import "WMAdvertiseView.h"

#import <Bugly/Bugly.h>
// 高德地图
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,BuglyDelegate,AdCoreClient>

/// 是否需要处理远程通知（按照之前代码逻辑搬运，虽然我觉得不需要这个防护）
@property (nonatomic, assign) BOOL needHandlerNotification;

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) BaseTabBarViewController *tabBarController;
@property (nonatomic, assign) NSInteger errorCount;

/** 定位 */
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, copy) AMapLocatingCompletionBlock completionBlock;

@end

