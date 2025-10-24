//
//  XCMediator+TTRoomMoudleBridge.h
//  XC_TTRoomMoudleBridge
//
//  Created by KevinWang on 2019/4/9.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "XCMediator.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XCMediator (TTRoomMoudleBridge)

/**
 进入指定房间
 @param roomUid 房主uid
 */
- (void)ttRoomMoudle_presentRoomViewControllerWithRoomUid:(long long)roomUid;
    
/// 进入指定房间(只有'随机进入嗨聊房'和'派对匹配'需要)
/// @param roomUid 房主uid
/// @param needEdgeGesture 是否需要滑动切换房间的手势
- (void)ttRoomMoudle_presentRoomViewControllerWithRoomUid:(long long)roomUid andNeedEdgeGesture:(BOOL)needEdgeGesture;

/**
 师徒任务3, 徒弟进入指定房间  注意是徒弟进入房间调用此方法
 @param roomUid 房主uid
 @param masterUid 师傅的uid
 @param apprenticeUid 徒弟的uid
 */
- (void)ttRoomMoudle_presentRoomViewControllerWithRoomUid:(long long)roomUid masterUid:(long long)masterUid apprenticeUid:(long long)apprenticeUid;

/**
 开启自己的房间
 @param roomType 房间类型
 1 拍卖房
 2 轻聊房
 3 轰趴房
 */
- (void)ttRoomMoudle_openMyRoomByType:(NSInteger)roomType;


/**
 点击悬浮球进入房间
 @param roomInfo 通过RoomInfo模型转字典获取
 */
- (void)ttRoomMoudle_maxRoomViewController:(NSDictionary *)roomInfo;

/**
 点击悬浮球关闭房间
 */
- (void)ttRoomMoudle_closeRoomViewController;

/**
 最小化房间

 @param completeBlock 完成后的block
 */
- (void)ttRoomMoudle_minRoomViewControllerCompleteBlock:(id)completeBlock;

/**
 小世界开启派对房
 */
- (void)ttRoomMoudle_presentRoomViewControllerWithType:(NSInteger)roomType worldId:(long long)worldId;
@end

NS_ASSUME_NONNULL_END
