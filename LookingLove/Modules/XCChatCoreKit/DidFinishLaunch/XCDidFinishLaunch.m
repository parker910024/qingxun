//
//  XCDidFinishLaunch.m
//  XCChatCoreKit
//
//  Created by Macx on 2019/6/27.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "XCDidFinishLaunch.h"

#import "ActivityCore.h"
#import "BoxCore.h"
#import "AuthCore.h"
#import "FamilyCore.h"
#import "GameCore.h"
#import "GiftCore.h"
#import "TTCPGamePrivateChatCore.h"
#import "ImRoomCoreV2.h"
#import "LogCore.h"
#import "MediaCore.h"
#import "PurseCore.h"
#import "RoomCoreV2.h"
#import "RoomMagicCore.h"
#import "CarCore.h"
#import "ReachabilityCore.h"

@implementation XCDidFinishLaunch
/**
 处理程序启动完毕后, 初始化一些需要初始化的core.
 使用时机, 在BaseTabBarViewController的viewDidAppear方法中初始化
 */
+ (void)didFinishLaunchAction {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            GetCore(ActivityCore);
            GetCore(BoxCore);
            GetCore(AuthCore);
            GetCore(FamilyCore);
            GetCore(GameCore);
            GetCore(GiftCore);
            
            GetCore(TTCPGamePrivateChatCore);
            GetCore(ImRoomCoreV2);
            GetCore(LogCore);
            GetCore(MediaCore);
            GetCore(PurseCore);
            GetCore(RoomCoreV2);
            GetCore(RoomMagicCore);
            GetCore(CarCore);
            GetCore(ReachabilityCore);
        });
    });
}
@end
