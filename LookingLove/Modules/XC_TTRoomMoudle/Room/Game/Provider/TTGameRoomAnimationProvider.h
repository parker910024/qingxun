//
//  TTGameRoomAnimationProvider.h
//  TuTu
//
//  Created by KevinWang on 2018/10/30.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UserID.h"

@class TTGameRoomContainerController;
@interface TTGameRoomAnimationProvider : NSObject
//创建礼物动画效果
+ (CAAnimationGroup *)ttCreateGiftAnimation:(CGPoint)center originPoint:(CGPoint)orginPoint destinationPoint:(CGPoint)destinationPoint;

//计算礼物动画坐标
+ (NSDictionary *)ttCreateGiftPosition:(UserID)roomOwnerUid giftRecivieUid:(UserID)giftRecivieUid targetUid:(UserID)targetUid containerController:(TTGameRoomContainerController *)containerController;

//计算房间魔法坐标
+ (NSDictionary *)ttCreateRoomMagicPosition:(UserID)roomOwnerUid giftRecivieUid:(UserID)giftRecivieUid targetUid:(UserID)targetUid containerController:(TTGameRoomContainerController *)containerController;

/// 获取需要显示动画的位置
/// @param positionValue 需要显示动画的坑位 index
/// @param positionPools 所有的坑位集合
/// @param fromView 在显示的 view
+ (CGPoint)getNeedShowAnmationPosition:(NSInteger)positionValue
                         positionPools:(NSMutableArray *)positionPools
                              fromView:(UIView *)fromView;
@end
