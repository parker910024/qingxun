//
//  XCMediator+TTGameModuleBridge.h
//  XC_TTGameMoudleBridge
//
//  Created by new on 2019/4/9.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XCMediator.h"

NS_ASSUME_NONNULL_BEGIN

@interface XCMediator (TTGameModuleBridge)

/** 跳转到游戏首页*/
- (UIViewController *)ttGameMoudle_TTGameViewController;

/** 跳转到新游戏模块首页 */
- (UIViewController *)ttGameMoudle_TTNewGameHomeViewController;

/** 跳转到全部游戏*/
- (UIViewController *)ttGameMoudle_TTCompleteGameListViewController;

/** 跳转到找玩友*/
- (UIViewController *)ttGameMoudle_TTGameFindFriendViewController;

/**
 跳转到匹配控制器
 */
- (UIViewController *)ttGameMoudle_TTGameMatchingViewController:(NSDictionary *)dict IsHiddenNav:(BOOL )hiddenNavBar;

/** 跳转到游戏页*/
- (UIViewController *)ttGameMoudle_TTWkGameViewControllerWithUrlStr:(NSString *)gameUrlString Watch:(BOOL)watching SuperViewType:(NSString *)superviewType block:(id)block;

/** 我的声音 */
- (UIViewController *)ttGameMoudle_TTVoiceMyViewController;

/** 声音匹配 */
- (UIViewController *)ttGameMoudle_TTVoiceMatchingViewController;

/** 声音录制*/
- (UIViewController *)ttGameMoudle_TTVoiceRecordViewController;

/** 跳转小世界 */
- (UIViewController *)ttGameMoudle_TTWorldSquareViewController;

/** 跳转小世界客态页
@param isFromRoom 是不是从房间进去的
 */
- (UIViewController *)ttGameMoudle_TTWorldletContainerViewControllerWithWorldId:(NSString *)worldId isFromRoom:(BOOL)isFromRoom;

/// 跳转动态详情
/// @param worldID 所在小世界id
/// @param dynamicID 动态id
/// @param comment 是否评论
- (UIViewController *)ttGameMoudle_TTDynamicDetailViewControllerWithWorldID:(NSString *)worldID
                                                       dynamicID:(NSString *)dynamicID
                                                         comment:(BOOL)comment;

- (UIViewController *)ttGameMoudle_TTDynamicDetailViewControllerWithWorldID:(NSString *)worldID
                                                                  dynamicID:(NSString *)dynamicID
                                                                    comment:(BOOL)comment
                                                                      block:(nullable void(^)(id data, NSInteger type))refreshBlock;

/// 动态广场发布
/// @param refreshBlock 回调刷新
- (UIViewController *)ttGameMoudle_LLPostDynamicViewControllerWithRefresh:(nullable void(^)(void))refreshBlock;

@end

NS_ASSUME_NONNULL_END
