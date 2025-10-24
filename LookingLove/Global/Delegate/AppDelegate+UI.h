//
//  AppDelegate+UI.h
//  TuTu
//
//  Created by Mac on 2018/10/29.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "AppDelegate.h"
#import <Foundation/Foundation.h>
#import "ActivityCoreClient.h"
#import "VersionCoreClient.h"
#import "HttpErrorClient.h"
#import "ImRoomCoreClientV2.h"
#import "XCFloatView.h"
#import "TTMasterHintView.h"

@interface AppDelegate (UI)<XCFloatViewDelegate, ActivityCoreClient,GiftCoreClient,NobleCoreClient, VersionCoreClient, HttpErrorClient, ImRoomCoreClientV2, MentoringShipCoreClient, TTMasterHintViewDelegate>

- (void)setAppMainUI;

- (void)onReceiveP2PRedPacket:(RedInfo *)info;

- (void)setupLaunchADView;

@end
