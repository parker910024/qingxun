//
//  XCMediator+TTGameModuleBridge.m
//  XC_TTGameMoudleBridge
//
//  Created by new on 2019/4/9.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "XCMediator+TTGameModuleBridge.h"

@implementation XCMediator (TTGameModuleBridge)
/** 跳转到游戏首页*/
- (UIViewController *)ttGameMoudle_TTGameViewController{
    return [self performTarget:@"TTGameModule" action:@"TTGameViewController" params:nil shouldCacheTarget:NO];
}

- (UIViewController *)ttGameMoudle_TTNewGameHomeViewController {
    return [self performTarget:@"TTGameModule" action:@"TTNewGameHomeViewController" params:nil shouldCacheTarget:NO];
}

/** 跳转到全部游戏*/
- (UIViewController *)ttGameMoudle_TTCompleteGameListViewController{
    return [self performTarget:@"TTGameModule" action:@"TTCompleteGameListViewController" params:nil shouldCacheTarget:NO];
}

/** 跳转到找玩友*/
- (UIViewController *)ttGameMoudle_TTGameFindFriendViewController{
    return [self performTarget:@"TTGameModule" action:@"TTGameFindFriendViewController" params:nil shouldCacheTarget:NO];
}


/**
 跳转到匹配控制器
 */
- (UIViewController *)ttGameMoudle_TTGameMatchingViewController:(NSDictionary *)dict IsHiddenNav:(BOOL )hiddenNavBar {
    NSDictionary *params = @{@"model" : dict, @"hiddenNavBar" : @(hiddenNavBar)};
    return [self performTarget:@"TTGameModule" action:@"TTGameMatchingViewController" params:params shouldCacheTarget:NO];
}

/** 跳转到游戏页*/
- (UIViewController *)ttGameMoudle_TTWkGameViewControllerWithUrlStr:(NSString *)gameUrlString Watch:(BOOL)watching SuperViewType:(NSString *)superviewType block:(id)block{
    
    NSDictionary *params = @{@"gameUrlString" : gameUrlString, @"watching" : @(watching), @"superviewType" : superviewType, @"block" : block};
    return [self performTarget:@"TTGameModule" action:@"TTWkGameViewController" params:params shouldCacheTarget:NO];
    
}

/** 我的声音 */
- (UIViewController *)ttGameMoudle_TTVoiceMyViewController {
    return [self performTarget:@"TTGameModule" action:@"TTVoiceMyViewController" params:nil shouldCacheTarget:NO];
}

/** 声音匹配 */
- (UIViewController *)ttGameMoudle_TTVoiceMatchingViewController {
    return [self performTarget:@"TTGameModule" action:@"TTVoiceMatchingViewController" params:nil shouldCacheTarget:NO];
}

/** 声音录制*/
- (UIViewController *)ttGameMoudle_TTVoiceRecordViewController {
    return [self performTarget:@"TTGameModule" action:@"TTVoiceRecordViewController" params:nil shouldCacheTarget:NO];
}

/** 跳转小世界*/
- (UIViewController *)ttGameMoudle_TTWorldSquareViewController {
    return [self performTarget:@"TTGameModule" action:@"TTWorldSquareViewController" params:nil shouldCacheTarget:NO];
}

/** 跳转小世界客态页 */
- (UIViewController *)ttGameMoudle_TTWorldletContainerViewControllerWithWorldId:(NSString *)worldId isFromRoom:(BOOL)isFromRoom {
    NSDictionary *params = @{@"worldId" : worldId, @"isFromRoom":@(isFromRoom)};
    return [self performTarget:@"TTGameModule" action:@"TTWorldletContainerViewController" params:params shouldCacheTarget:NO];
}
/// 跳转动态详情
/// @param worldID 所在小世界id
/// @param dynamicID 动态id
/// @param comment 是否评论
- (UIViewController *)ttGameMoudle_TTDynamicDetailViewControllerWithWorldID:(NSString *)worldID
                                                                  dynamicID:(NSString *)dynamicID
                                                                    comment:(BOOL)comment {
    return [self ttGameMoudle_TTDynamicDetailViewControllerWithWorldID:worldID dynamicID:dynamicID comment:comment block:nil];
}

- (UIViewController *)ttGameMoudle_TTDynamicDetailViewControllerWithWorldID:(NSString *)worldID
                                                                  dynamicID:(NSString *)dynamicID
                                                                    comment:(BOOL)comment
                                                                      block:(nullable void(^)(id data, NSInteger type))refreshBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"worldID" : worldID, @"dynamicID" : dynamicID, @"comment" : @(comment)}];
    [params setValue:refreshBlock forKey:@"dynamicChangeCallBack"];
    return [self performTarget:@"TTGameModule" action:@"LLDynamicDetailViewController" params:params shouldCacheTarget:NO];
}

/// 动态广场发布
/// @param refreshBlock 回调刷新
- (UIViewController *)ttGameMoudle_LLPostDynamicViewControllerWithRefresh:(nullable void(^)(void))refreshBlock {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:refreshBlock forKey:@"refreshDynamicBlock"];
    return [self performTarget:@"TTGameModule" action:@"LLPostDynamicViewController" params:params shouldCacheTarget:NO];
}

@end
