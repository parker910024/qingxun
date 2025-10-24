//
//  TTPositionViewUIProtocol.h
//  TTPositionView
//
//  Created by fengshuo on 2019/5/16.
//  Copyright © 2019 fengshuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RoomInfo.h"
#import "RoomQueueCoreClient.h"
NS_ASSUME_NONNULL_BEGIN

//房间坑位的样式(坑位的个数)
typedef enum : NSUInteger {
    //默认的 九个坑位的
    TTRoomPositionViewLayoutStyleNormal,
    //cp房 两个坑位的
    TTRoomPositionViewLayoutStyleCP,
    // 相亲房
    TTRoomPositionViewLayoutStyleLove,
} TTRoomPositionViewLayoutStyle;


//坑位对应的不同的模式
typedef enum : NSUInteger {
    //普通的模式
    TTRoomPositionViewTypeNormal,
    //CP
    TTRoomPositionViewTypeCP,
    //CP游戏房
    TTRoomPositionViewTypeCPGame,
    //房间PK
    TTRoomPositionViewTypePK,
    //礼物值
    TTRoomPositionViewTypeGiftValue,
    //房主离开
    TTRoomPositionViewTypeOwnerLeave,
    //  相亲房。9个坑位 布局不同
    TTRoomPositionViewTypeLove,
} TTRoomPositionViewType;

@protocol TTPositionViewUIProtocol <NSObject>
@optional
- (void)positionViwLayoutSubViews;
/** 坑位销毁的时候*/
- (void)positionViewDelloc;
/** 是不是显示土豪位*/
- (void)isShowPositionVipViewWithRoomInfor:(RoomInfo *)info;

/** 房间信息更新的时候 更新房主离开模式*/
- (void)configRoonInfoUpdateToUpOwnerPositionView;

/** 重置所有坑位礼物值*/
- (void)resetAllPositionItemGiftValue;

/** 清空关闭离开模式后房主位遗留的礼物值*/
- (void)clearOwnerPositionGiftValueWhenOffLeaveMode;

/** 坑位布局*/
- (void)updateRoomPositionTypeWith:(TTRoomPositionViewType)positonViewType;

/** 相亲房房间信息变更*/
- (void)onCurrentRoomInfoUpdate;

/** 进入房间成功 */
- (void)enterChatRoomSuccess;

// 相亲房当管理员在主持麦位。被取消管理员或者是普通用户在主持麦位被设置了管理员
- (void)updateCurrentUserRole:(BOOL)isManager;

#pragma mark  获取我自己是否上麦的状态
// 获取我自己是否上麦的状态
- (void)getRoomOnMicStatus:(RoomQueueUpateType)type position:(int)position;
@end

NS_ASSUME_NONNULL_END
