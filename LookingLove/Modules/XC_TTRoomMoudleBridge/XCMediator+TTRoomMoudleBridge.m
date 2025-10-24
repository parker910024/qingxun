//
//  XCMediator+TTRoomMoudleBridge.m
//  XC_TTRoomMoudleBridge
//
//  Created by KevinWang on 2019/4/9.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "XCMediator+TTRoomMoudleBridge.h"

@implementation XCMediator (TTRoomMoudleBridge)

- (void)ttRoomMoudle_presentRoomViewControllerWithRoomUid:(long long)roomUid{
    
    [self ttRoomMoudle_presentRoomViewControllerWithRoomUid:roomUid andNeedEdgeGesture:NO];
}

/// 进入指定房间(只有'随机进入嗨聊房'和'派对匹配'需要)
/// @param roomUid 房主uid
/// @param needEdgeGesture 是否需要滑动切换房间的手势
- (void)ttRoomMoudle_presentRoomViewControllerWithRoomUid:(long long)roomUid andNeedEdgeGesture:(BOOL)needEdgeGesture {
    NSDictionary * params = @{@"roomUid" : @(roomUid),
                              @"needEdgeGesture" : @(needEdgeGesture)};
    [self performTarget:@"TTRoomModule" action:@"TTRoomModulePresentRoomViewController" params:params shouldCacheTarget:NO];
}

/**
 师徒任务3, 徒弟进入指定房间  注意是徒弟进入房间调用此方法
 @param roomUid 房主uid
 @param masterUid 师傅的uid
 @param apprenticeUid 徒弟的uid
 */
- (void)ttRoomMoudle_presentRoomViewControllerWithRoomUid:(long long)roomUid masterUid:(long long)masterUid apprenticeUid:(long long)apprenticeUid {
    NSDictionary * params = @{
                              @"roomUid" : @(roomUid),
                              @"masterUid" : @(masterUid),
                              @"apprenticeUid" : @(apprenticeUid)
                              };
    [self performTarget:@"TTRoomModule" action:@"TTRoomModulePresentRoomViewController" params:params shouldCacheTarget:NO];
}

- (void)ttRoomMoudle_openMyRoomByType:(NSInteger)roomType{
    NSDictionary * params = @{@"roomType" : @(roomType)};
    [self performTarget:@"TTRoomModule" action:@"TTRoomModuleOpenRoomViewController" params:params shouldCacheTarget:NO];
}

- (void)ttRoomMoudle_maxRoomViewController:(NSDictionary *)roomInfo{
    
    [self performTarget:@"TTRoomModule" action:@"TTRoomModuleMaxRoomViewController" params:roomInfo shouldCacheTarget:NO];
}

/**
 点击悬浮球关闭房间
 */
- (void)ttRoomMoudle_closeRoomViewController{
    
    [self performTarget:@"TTRoomModule" action:@"TTRoomModuleCloseRoomViewController" params:nil shouldCacheTarget:NO];
}


/**
 最小化房间
 
 @param completeBlock 完成后的block
 */
- (void)ttRoomMoudle_minRoomViewControllerCompleteBlock:(id)completeBlock {
    
    NSDictionary *params = @{@"block" : completeBlock};
    [self performTarget:@"TTRoomModule" action:@"TTRoomModuleMinRoomViewController" params:params shouldCacheTarget:NO];
}

/**
 小世界开启派对房
 */
- (void)ttRoomMoudle_presentRoomViewControllerWithWorldId:(long long)worldId {
    NSDictionary * params = @{
                              @"worldId" : @(worldId),
                              };
    [self performTarget:@"TTRoomModule" action:@"TTRoomModulePresentRoomViewController" params:params shouldCacheTarget:NO];
}

/**
 小世界开启派对房
 */
- (void)ttRoomMoudle_presentRoomViewControllerWithType:(NSInteger)roomType worldId:(long long)worldId {
    NSDictionary * params = @{
                              @"worldId" : @(worldId),
                              @"roomType" : @(roomType)
                              };
    [self performTarget:@"TTRoomModule" action:@"TTRoomModuleOpenRoomViewController" params:params shouldCacheTarget:NO];
}

@end
