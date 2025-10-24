//
//  Target_TTMessageMoudle.h
//  TuTu
//
//  Created by gzlx on 2018/11/14.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Target_TTMessageMoudle : NSObject
/** 消息的主控制器*/
- (UIViewController *)Action_TTMainMessageViewController;
/** 会话列表*/
- (UIViewController *)Action_TTSessionListViewController;
/**粉丝列表*/
- (UIViewController *)Action_TTFansViewController;
/** 关注列表*/
- (UIViewController *)Action_TTFocusViewController;
/** 会话*/
- (UIViewController *)Action_TTSessionViewController:(NSDictionary *)params;

/** 会话 开启话匣子*/
- (UIViewController *)Action_TTSessionViewControllerChatterboxGame:(NSDictionary *)params;

/** 会话 撩一下 */
- (UIViewController *)Action_TTSessionViewControllerFlirt:(NSDictionary *)params;

/**黑名单*/
- (UIViewController *)Action_TTSessionBlackListController:(NSDictionary *)params;
/** 好友列表*/
- (UIViewController *)Action_TTFriendListViewController;

/** 联系人列表（好友、关注、粉丝）控制器*/
- (UIViewController *)Action_TTMessageContentViewController:(NSDictionary *)params;

/** 房间内聊天*/
- (UIViewController *)Action_TTRoomMessageViewController;

/** 获得公聊大厅最近的几条记录*/
- (NSMutableArray *)Action_GetPublicChatRoomMessages;
/** 小世界成员列表*/
- (UIViewController *)Action_TTLittleWorldMemberViewController:(NSDictionary *)params;

/** 小世界群聊*/
- (UIViewController *)Action_TTLittleWorldSessionViewController:(NSDictionary *)params;

/** 获取群聊消息的未读数*/
- (NSDictionary *)Action_GetLittleWorldTeamUnreadCountWithSessionId:(NSDictionary *)params;

/** 动态消息列表 */
- (UIViewController *)Action_TTDynamicMessageViewController;

/// 根据聊天控制器获取 sessionID
/// @param params @{@"vc" : TTSessionViewController}
/// @discussion 未传入正确的VC 获取的 sessionID 为 nil
- (NSString *)Action_GetSessionIdWithSessionViewController:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
