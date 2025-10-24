//
//  XCMediator+TTHomeMoudle.h
//  TuTu
//
//  Created by Macx on 2018/10/29.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "XCMediator.h"
#import <UIKit/UIKit.h>

@interface XCMediator (TTHomeMoudle)
/**
 首页控制器
 */
- (UIViewController *)ttHomeMoudle_homeContainerViewController;

/**
 家族控制器
 */
- (UIViewController *)ttHomeMoudle_familyViewController;

/**
 搜索控制器
 
 @param isPresent 是否是个人页, zen送跳转
 @param block zen送点击的回调
 // 搜索页面, 个人页装扮跳过来 zen送 按钮点击的回调 === 需要和个人模块商量的一致 == 参数为uid, 昵称
 typedef void(^TTSearchPresentDidClickBlock)(long long, NSString *);
 @return vc
 */
- (UIViewController *)ttHomeMoudleBridge_searchRoomController:(BOOL)isPresent block:(id)block;

/**
 modal出搜索控制器, 点击cell时dismissBlock回调
 
 @param dismissBlock typedef void(^DismissAndDidClickPersonBlcok)(long long uid);
 @return vc
 */
- (UIViewController *)ttHomeMoudleBridge_modalSearchRoomControllerWithBlock:(id)dismissBlock;

// modal出搜索控制器,包含历史搜索记录和进房记录, 点击cell时dismissBlock回调 dismissBlock:typedef void(^DismissAndDidClickPersonBlcok)(long long uid);
- (UIViewController *)ttHomeMoudleBridge_modalRecordSearchRoomControllerWithBlock:(id)dismissBlock;

// modal出搜索控制器，包含历史搜索记录和进房记录，包含进房回调
- (UIViewController *)ttHomeMoudleBridge_modalRecordSearchRoomControllerWithDismissHandler:(void(^)(long long uid))dismissHandler enterRoomHandler:(void(^)(long long roomUid))enterRoomHandler;

// 模厅邀请用户 push搜索VC
- (UIViewController *)ttHomeMoudleBridge_inviteSearchRoomController;

// 是否是模厅内部搜索 push搜索VC
- (UIViewController *)ttHomeMoudleBridge_hallSearchSearchRoomController;
@end
