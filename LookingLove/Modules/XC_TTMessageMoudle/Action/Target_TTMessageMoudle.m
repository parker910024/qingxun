//
//  Target_TTMessageMoudle.m
//  TuTu
//
//  Created by gzlx on 2018/11/14.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "Target_TTMessageMoudle.h"
#import "TTMainMessageViewController.h"
#import "TTSessionListViewController.h"
#import "TTFansViewController.h"
#import "TTFocusViewController.h"
#import "TTSessionViewController.h"
#import "TTFriendListViewController.h"
#import "TTSessionViewController.h"
#import "TTSessionBlackListController.h"
#import "TTMessageContentViewController.h"
#import "TTRoomMessageViewController.h"
#import <Masonry/Masonry.h>
#import "XCMacros.h"
#import "TTPublicChatroomMessageProvider.h"
#import "TTLittleWorldMemberViewController.h"
#import "TTLittleWorldSessionViewController.h"
#import "TTMessageContainerViewController.h"
#import "TTDynamicMessageViewController.h"

@implementation Target_TTMessageMoudle
/** 消息的主控制器*/
- (UIViewController *)Action_TTMainMessageViewController{
    if (projectType() == ProjectType_LookingLove || projectType() == ProjectType_Planet) {
        TTMessageContainerViewController * vc = [[TTMessageContainerViewController alloc] init];
        return vc;
    } else {
        TTMainMessageViewController * viewController = [[TTMainMessageViewController alloc] init];
        return viewController;
    }
}

/** 会话列表*/
- (UIViewController *)Action_TTSessionListViewController{
    TTSessionListViewController * listVC = [[TTSessionListViewController alloc] init];
    return listVC;
}
/**粉丝列表*/
- (UIViewController *)Action_TTFansViewController{
    TTFansViewController * fansVC= [[TTFansViewController alloc] init];
    fansVC.type = MessageVCType_Default;
    fansVC.title = @"粉丝";
    return fansVC;
}
/** 关注列表*/
- (UIViewController *)Action_TTFocusViewController{
    TTFocusViewController * focusVC =[[TTFocusViewController alloc] init];
    focusVC.title = @"关注";
    focusVC.type = MessageVCType_Default;
    return focusVC;
}
/** 会话*/
- (UIViewController *)Action_TTSessionViewController:(NSDictionary *)params {
    NIMSessionType type = NIMSessionTypeP2P;
    if (!params[@"NIMSessionType"]) {
        type = NIMSessionTypeP2P;
    } else {
        type = [params[@"NIMSessionType"] integerValue];
    }
    NIMSession *session = [NIMSession session:[NSString stringWithFormat:@"%@", params[@"uid"]] type:type];
    TTSessionViewController *vc = [[TTSessionViewController alloc] initWithSession:session];
    return vc;
}

/** 会话 开启话匣子*/
- (UIViewController *)Action_TTSessionViewControllerChatterboxGame:(NSDictionary *)params {
    
    NIMSessionType type = NIMSessionTypeP2P;
    if (!params[@"NIMSessionType"]) {
        type = NIMSessionTypeP2P;
    } else {
        type = [params[@"NIMSessionType"] integerValue];
    }
    NIMSession *session = [NIMSession session:[NSString stringWithFormat:@"%@", params[@"uid"]] type:type];
    
    TTSessionViewController *vc = [[TTSessionViewController alloc] initWithSession:session];
    [vc chatterBoxHello];
    
    void (^handler)(void) = params[@"handle"];
    if (handler) {
        vc.chatterboxGamePointHandler = [handler copy];
    }
    return vc;
}

/** 会话 撩一下 */
- (UIViewController *)Action_TTSessionViewControllerFlirt:(NSDictionary *)params {
    
    NSString *destinationUID = [params objectForKey:@"uid"];
    void (^handler)(void) = params[@"handle"];
    NIMSession *session = [NIMSession session:destinationUID type:NIMSessionTypeP2P];
    
    TTSessionViewController *vc = [[TTSessionViewController alloc] initWithSession:session];
    [vc chatterBoxHello];
    [vc flirtSayHi];
    
    if (handler) {
        vc.chatterboxGamePointHandler = [handler copy];
    }
    
    return vc;
}

/**黑名单*/
- (UIViewController *)Action_TTSessionBlackListController:(NSDictionary *)params{
    TTSessionBlackListController * blackListVC = [[TTSessionBlackListController alloc] init];
    blackListVC.uid = [[NSString stringWithFormat:@"%@", params[@"uid"]] userIDValue];
    return blackListVC;
}
/** 好友列表*/
- (UIViewController *)Action_TTFriendListViewController{
    TTFriendListViewController * friendVC = [[TTFriendListViewController alloc] init];
    friendVC.type =  MessageVCType_Default;
    return friendVC;
}

/** 联系人列表（好友、关注、粉丝）控制器*/
- (UIViewController *)Action_TTMessageContentViewController:(NSDictionary *)params {
    
    TTMessageContentViewController *vc = [[TTMessageContentViewController alloc] init];
    
    void (^selectSendPresentBlock)(NSDictionary *user) = params[@"handle"];
    if (selectSendPresentBlock) {
        vc.selectPresentBlock = [selectSendPresentBlock copy];
    }
    
    return vc;
}

/** 房间内聊天*/
- (UIViewController *)Action_TTRoomMessageViewController{
    TTRoomMessageViewController * roomMessageViewContoller = [[TTRoomMessageViewController alloc] init];
    return roomMessageViewContoller;
}

/** 获得公聊大厅最近的几条记录*/
- (NSMutableArray *)Action_GetPublicChatRoomMessages {
    return [TTPublicChatroomMessageProvider shareProvider].modelMessages;
}

/** 小世界成员列表*/
- (UIViewController *)Action_TTLittleWorldMemberViewController:(NSDictionary *)params {
    TTLittleWorldMemberViewController * member = [[TTLittleWorldMemberViewController alloc] init];
    member.worldId = [params[@"worldId"] userIDValue];
    member.type = [params[@"userType"] userIDValue];
    return member;
}

/** 小世界群聊*/
- (UIViewController *)Action_TTLittleWorldSessionViewController:(NSDictionary *)params {
    NIMSession * session = [NIMSession session:params[@"sessionId"] type:NIMSessionTypeTeam];
    TTLittleWorldSessionViewController *vc = [[TTLittleWorldSessionViewController alloc] initWithSession:session];
    return vc;
}

/** 获取群聊消息的未读数*/
- (NSDictionary *)Action_GetLittleWorldTeamUnreadCountWithSessionId:(NSDictionary *)params {
    NSString * sessionId = params[@"sessionId"];
    if (sessionId) {
        NIMSession * session = [NIMSession session:sessionId type:NIMSessionTypeTeam];
        NIMRecentSession * recentSession =  [[NIMSDK sharedSDK].conversationManager recentSessionBySession:session];
        return @{@"count":@(recentSession.unreadCount)};
    } else {
        return @{@"count":@"0"};
    }
}

/** 动态消息列表 */
- (UIViewController *)Action_TTDynamicMessageViewController {
    return [[TTDynamicMessageViewController alloc] init];
}

/// 根据聊天控制器获取 sessionID
/// @param params @{@"vc" : TTSessionViewController}
/// @discussion 未传入正确的VC 获取的 sessionID 为 nil
- (NSString *)Action_GetSessionIdWithSessionViewController:(NSDictionary *)params {
    TTSessionViewController *vc = params[@"vc"];
    
    if ([vc isKindOfClass:[TTSessionViewController class]]) {
        return vc.session.sessionId;
    }
    
    return nil;
}

@end
