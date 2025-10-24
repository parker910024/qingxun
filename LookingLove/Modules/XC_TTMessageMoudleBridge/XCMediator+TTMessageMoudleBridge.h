//
//  XCMediator+TTMessageMoudleBridge.h
//  XC_TTMessageMoudleBridge
//
//  Created by fengshuo on 2019/4/9.
//  Copyright © 2019 fengshuo. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "XCMediator.h"

NS_ASSUME_NONNULL_BEGIN

@interface XCMediator (TTMessageMoudleBridge)
/**
 获取头条|交友大厅控制器
 
 @param page 1为交友大厅 2为头条
 @return 控制器实例
 */
- (UIViewController *)TTMessageMoudle_HeadLineViewContoller:(NSInteger)page;

/** 消息的主控制器*/
- (UIViewController *)ttMessageMoudle_TTMainMessageViewController;
/** 会话列表*/
- (UIViewController *)ttMessageMoudle_TTSessionListViewController;
/**粉丝列表*/
- (UIViewController *)ttMessageMoudle_TTFansViewController;
/** 关注列表*/
- (UIViewController *)ttMessageMoudle_TTFocusViewController;
/** 会话*/
- (UIViewController *)ttMessageMoudle_TTSessionViewController:(long long)uid sessectionType:(NSInteger)type;

/** 会话 话匣子游戏发起*/
- (UIViewController *)ttMessageMoudle_TTSessionViewControllerChatterboxGame:(long long)uid sessectionType:(NSInteger)type withReturnStatistics:(nullable void(^)(void))handle;

/// 会话 撩一下
/// @param uid 聊天对象uid
/// @param handle 开始话匣子游戏回调
- (UIViewController *)ttMessageMoudle_TTSessionViewControllerFlirtToUid:(long long)uid chatterboxStartBlock:(nullable void(^)(void))handle;

/**黑名单*/
- (UIViewController *)ttMessageMoudle_TTSessionBlackListController:(long long)uid;
/** 好友列表*/
- (UIViewController *)ttMessageMoudle_TTFriendListViewController;

/**
 获取联系人列表（好友、关注、粉丝），实现 handle 表示赠送装扮，否则 handle 传 nil
 
 @param handle 选择赠送装扮处理
 @return 控制器实例
 */
- (UIViewController *)TTMessageMoudle_TTMessageContentViewControllerWithSelectSendPresentHandle:(nullable void(^)(NSDictionary *user))handle;

/** 房间内聊天*/
- (UIViewController *)ttMessageMoudle_TTRoomMessageViewController;

/** 公聊大厅的最近的几条记录*/
- (NSMutableArray *)ttMessageMoudle_GetPublicChatRoomMessages;

/** 小世界成员列表*/
- (UIViewController *)ttMessageMoudle_TTLittleWorldMemberViewControllerWith:(NSString *)worldId userType:(NSUInteger)userType;

/** 小世界群聊*/
- (UIViewController *)ttMessageMoudle_TTLittleWorldSessionViewController:(NSString *)sessionId;

/** 获取某个群聊的未读数*/
- (NSInteger)ttMessageMoudle_GetLittleWorldTeamUnreadCountWithSessionId:(NSString *)sessionId;

/** 动态消息列表 */
- (UIViewController *)ttMessageMoudle_TTDynamicMessageViewController;

/// 根据聊天控制器获取 sessionID
/// @param viewController TTSessionViewController
/// @discussion 未传入正确的VC 获取的 sessionID 为 nil
- (NSString *)ttMessageMoudle_GetSessionIdWithSessionViewController:(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
