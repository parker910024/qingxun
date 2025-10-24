//
//  XCMediator+TTMessageMoudleBridge.m
//  XC_TTMessageMoudleBridge
//
//  Created by fengshuo on 2019/4/9.
//  Copyright © 2019 fengshuo. All rights reserved.
//

#import "XCMediator+TTMessageMoudleBridge.h"

@implementation XCMediator (TTMessageMoudleBridge)
- (UIViewController *)TTMessageMoudle_HeadLineViewContoller:(NSInteger)page {
    return [self performTarget:@"TTPublicChatroomMoudle" action:@"TTHeadLineVireController" params:@{@"page":@(page)} shouldCacheTarget:YES];
}

/** 消息的主控制器*/
- (UIViewController *)ttMessageMoudle_TTMainMessageViewController{
    return [self performTarget:@"TTMessageMoudle" action:@"TTMainMessageViewController" params:nil shouldCacheTarget:NO];
}

- (UIViewController *)ttMessageMoudle_TTSessionListViewController{
    return [self performTarget:@"TTMessageMoudle" action:@"TTSessionListViewController" params:nil shouldCacheTarget:NO];
}


- (UIViewController *)ttMessageMoudle_TTFansViewController{
    return [self performTarget:@"TTMessageMoudle" action:@"TTFansViewController" params:nil shouldCacheTarget:NO];
}

- (UIViewController *)ttMessageMoudle_TTFocusViewController{
    return [self performTarget:@"TTMessageMoudle" action:@"TTFocusViewController" params:nil shouldCacheTarget:NO];
}

- (UIViewController *)ttMessageMoudle_TTSessionViewController:(long long)uid sessectionType:(NSInteger)type {
    if (0 > type || type > 2) {
        type = 0;
    }
    NSDictionary * params = @{@"uid":@(uid), @"NIMSessionType":@(type)};
    return [self performTarget:@"TTMessageMoudle" action:@"TTSessionViewController" params:params shouldCacheTarget:NO];
}

- (UIViewController *)ttMessageMoudle_TTSessionViewControllerChatterboxGame:(long long)uid sessectionType:(NSInteger)type withReturnStatistics:(nullable void(^)(void))handle {
    if (0 > type || type > 2) {
        type = 0;
    }
    NSDictionary * params = @{@"uid":@(uid), @"NIMSessionType":@(type),@"handle": handle};
    return [self performTarget:@"TTMessageMoudle" action:@"TTSessionViewControllerChatterboxGame" params:params shouldCacheTarget:NO];
}

/// 会话 撩一下
/// @param uid 聊天对象uid
/// @param handle 开始话匣子游戏回调
- (UIViewController *)ttMessageMoudle_TTSessionViewControllerFlirtToUid:(long long)uid chatterboxStartBlock:(nullable void(^)(void))handle {
    
    NSDictionary * params = @{@"uid":@(uid).stringValue, @"handle": handle};
    return [self performTarget:@"TTMessageMoudle" action:@"TTSessionViewControllerFlirt" params:params shouldCacheTarget:NO];
}

- (UIViewController *)ttMessageMoudle_TTSessionBlackListController:(long long)uid{
    NSDictionary * params = @{@"uid":@(uid)};
    return [self performTarget:@"TTMessageMoudle" action:@"TTSessionBlackListController" params:params shouldCacheTarget:YES];
}

- (UIViewController *)ttMessageMoudle_TTFriendListViewController{
    return [self performTarget:@"TTMessageMoudle" action:@"TTFriendListViewController" params:nil shouldCacheTarget:YES];
}

- (UIViewController *)TTMessageMoudle_TTMessageContentViewControllerWithSelectSendPresentHandle:(nullable void(^)(NSDictionary *user))handle {
    
    NSDictionary *params = @{};
    if (handle) {
        params = @{@"handle": handle};
    }
    return [self performTarget:@"TTMessageMoudle" action:@"TTMessageContentViewController" params:params shouldCacheTarget:YES];
}

/** 房间内聊天*/
- (UIViewController *)ttMessageMoudle_TTRoomMessageViewController{
    return [self performTarget:@"TTMessageMoudle" action:@"TTRoomMessageViewController" params:nil shouldCacheTarget:YES];
}


/** 公聊大厅的最近的几条记录*/
- (NSMutableArray *)ttMessageMoudle_GetPublicChatRoomMessages{
    return [self performTarget:@"TTMessageMoudle" action:@"GetPublicChatRoomMessages" params:nil shouldCacheTarget:YES];
}

/** 小世界成员列表*/
- (UIViewController *)ttMessageMoudle_TTLittleWorldMemberViewControllerWith:(NSString *)worldId userType:(NSUInteger)userType {
    NSDictionary * params;
    if (worldId && worldId.length > 0) {
        params = @{@"worldId":worldId, @"userType":@(userType)};
    }
    return [self performTarget:@"TTMessageMoudle" action:@"TTLittleWorldMemberViewController" params:params shouldCacheTarget:YES];
}
/** 小世界群聊*/
- (UIViewController *)ttMessageMoudle_TTLittleWorldSessionViewController:(NSString *)sessionId {
    NSDictionary * params;
    if (sessionId && sessionId.length > 0) {
        params = @{@"sessionId":sessionId};
    }
    return [self performTarget:@"TTMessageMoudle" action:@"TTLittleWorldSessionViewController" params:params shouldCacheTarget:YES];
}

/** 获取某个群聊的未读数*/
- (NSInteger)ttMessageMoudle_GetLittleWorldTeamUnreadCountWithSessionId:(NSString *)sessionId {
    NSDictionary * params = @{@"sessionId":sessionId};
    NSDictionary * unReadDic = [self performTarget:@"TTMessageMoudle" action:@"GetLittleWorldTeamUnreadCountWithSessionId" params:params shouldCacheTarget:NO];
    return [unReadDic[@"count"] integerValue];
}

/** 动态消息列表 */
- (UIViewController *)ttMessageMoudle_TTDynamicMessageViewController {
    return [self performTarget:@"TTMessageMoudle" action:@"TTDynamicMessageViewController" params:nil shouldCacheTarget:YES];
}

/// 根据聊天控制器获取 sessionID
/// @param viewController TTSessionViewController
/// @discussion 未传入正确的VC 获取的 sessionID 为 nil
- (NSString *)ttMessageMoudle_GetSessionIdWithSessionViewController:(UIViewController *)viewController {
    if (viewController == nil) {
        return nil;
    }
    
    return [self performTarget:@"TTMessageMoudle" action:@"GetSessionIdWithSessionViewController" params:@{@"vc": viewController} shouldCacheTarget:YES];
}

@end
