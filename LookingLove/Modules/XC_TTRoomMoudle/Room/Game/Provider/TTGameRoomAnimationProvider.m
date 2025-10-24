//
//  TTGameRoomAnimationProvider.m
//  TuTu
//
//  Created by KevinWang on 2018/10/30.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTGameRoomAnimationProvider.h"
#import "TTGameRoomContainerController.h"

//core
#import "RoomCoreV2.h"
#import "RoomQueueCoreV2.h"


@implementation TTGameRoomAnimationProvider


+ (CAAnimationGroup *)ttCreateGiftAnimation:(CGPoint)center originPoint:(CGPoint)orginPoint destinationPoint:(CGPoint)destinationPoint{
    
    CAKeyframeAnimation *animation0 = [CAKeyframeAnimation animation];
    animation0.duration = 0.8;
    animation0.keyPath = @"transform.scale";
    animation0.values = @[@1.0,@1.5,@2.0,@1.5];
    animation0.repeatCount = 1;
    animation0.calculationMode = kCAAnimationCubic;
    animation0.removedOnCompletion = NO;
    animation0.fillMode = kCAFillModeForwards;
    
    CAKeyframeAnimation *animation1 = [CAKeyframeAnimation animation];
    animation1.duration = 0.8;
    animation1.beginTime = 0.8;
    animation1.keyPath = @"transform.scale";
    animation1.values = @[@1.5,@2.0,@2.5,@3.0];
    animation1.repeatCount = 1;
    animation1.calculationMode = kCAAnimationCubic;
    animation1.removedOnCompletion = NO;
    animation1.fillMode = kCAFillModeForwards;
    
    
    CAKeyframeAnimation *animation2 = [CAKeyframeAnimation animation];
    animation2.duration = 0.8;
    animation2.beginTime = 0.8;
    animation2.keyPath = @"position";
    animation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];;
    animation2.values = @[[NSValue valueWithCGPoint:orginPoint],[NSValue valueWithCGPoint:CGPointMake(center.x ,center.y)]];
    animation2.repeatCount = 1;
    animation2.removedOnCompletion = NO;
    animation2.fillMode = kCAFillModeForwards;
    
    CAKeyframeAnimation *animation3 = [CAKeyframeAnimation animation];
    animation3.duration = 0.8;
    animation3.beginTime = 2.6;//0.8+0.8+1
    animation3.keyPath = @"transform.scale";
    animation3.values = @[@3,@2.5,@2,@1.5,@1];
    animation3.repeatCount = 1;
    
    CAKeyframeAnimation *animation4 = [CAKeyframeAnimation animation];
    animation4.duration = 0.8;
    animation4.beginTime = 2.6;
    animation4.keyPath = @"position";
    animation4.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation4.values = @[[NSValue valueWithCGPoint:CGPointMake(center.x ,center.y)],[NSValue valueWithCGPoint:destinationPoint]];
    animation4.repeatCount = 1;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 3.2;
    group.animations = @[animation0,animation1,animation2, animation3,animation4];
    group.repeatCount = 1;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    
    return group;
}

+ (NSDictionary *)ttCreateGiftPosition:(UserID)roomOwnerUid
                        giftRecivieUid:(UserID)giftRecivieUid
                             targetUid:(UserID)targetUid
                   containerController:(TTGameRoomContainerController *)containerController {
    
    CGPoint starPoint;
    CGPoint destinationPoint;
    NSMutableDictionary *postionDictionary = [NSMutableDictionary dictionary];
    
    if (targetUid == roomOwnerUid &&
        giftRecivieUid == roomOwnerUid) { //房主自己刷给自己
        
        starPoint = GetCore(RoomCoreV2).avatarPosition;
        destinationPoint = GetCore(RoomCoreV2).avatarPosition;
        
    } else {
        NSString *destinationPosition = [GetCore(RoomQueueCoreV2) findThePositionByUid:targetUid];
        NSString *originPosition = [GetCore(RoomQueueCoreV2) findThePositionByUid:giftRecivieUid];
        
        NSMutableArray *arr = GetCore(RoomCoreV2).positionArr;
        
        if (destinationPosition) {//收礼物的人在麦序上
            destinationPoint = [self getNeedShowAnmationPosition:[destinationPosition integerValue]+1
                                                   positionPools:arr
                                                        fromView:containerController.roomController.roomPositionView];
        } else {
            // 收礼物的人不在麦序上。房主开启离开模式
            if (GetCore(RoomCoreV2).getCurrentRoomInfo.leaveMode) {
                // 当开启了离开模式时的麦序，直接获取房主坑位
                destinationPoint = [self getNeedShowAnmationPosition:0
                                                       positionPools:arr
                                                            fromView:containerController.roomController.roomPositionView];
            } else {
                destinationPoint = CGPointMake(containerController.roomController.IDAndOnlineLabel.center.x, containerController.roomController.IDAndOnlineLabel.center.y);
            }
        }
        
        if (originPosition) { //发送人在麦序上
            starPoint = [self getNeedShowAnmationPosition:[originPosition integerValue]+1
                                            positionPools:arr
                                                 fromView:containerController.roomController.roomPositionView];
            
        } else {//发送人不在麦序上
            starPoint = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, 64);
        }
    }
    [postionDictionary safeSetObject:[NSValue valueWithCGPoint:starPoint] forKey:@"start"];
    [postionDictionary safeSetObject:[NSValue valueWithCGPoint:destinationPoint] forKey:@"end"];
    return postionDictionary;
}

+ (NSDictionary *)ttCreateRoomMagicPosition:(UserID)roomOwnerUid giftRecivieUid:(UserID)giftRecivieUid targetUid:(UserID)targetUid containerController:(TTGameRoomContainerController *)containerController{
    
    CGPoint starPoint;
    CGPoint destinationPoint;
    NSMutableDictionary *postionDictionary = [NSMutableDictionary dictionary];
    
    if (targetUid == roomOwnerUid && giftRecivieUid == roomOwnerUid) { //房主自己刷给自己
        
        starPoint =  GetCore(RoomCoreV2).avatarPosition;
        destinationPoint = GetCore(RoomCoreV2).avatarPosition;
        
    } else {
        
        NSString *destinationPosition = [GetCore(RoomQueueCoreV2) findThePositionByUid:targetUid];
        NSString *originPosition = [GetCore(RoomQueueCoreV2) findThePositionByUid:giftRecivieUid];
        
        NSMutableArray *arr = GetCore(RoomCoreV2).positionArr;
        
        if (destinationPosition) {//收礼物的人在麦序上
            
           destinationPoint = [self getNeedShowAnmationPosition:[destinationPosition integerValue]+1
                                                  positionPools:arr
                                                       fromView:containerController.roomController.roomPositionView];
        } else {
            
            // 收礼物的人不在麦序上。房主开启离开模式
            if (GetCore(RoomCoreV2).getCurrentRoomInfo.leaveMode) {
                // 当开启了离开模式时的麦序，直接获取房主坑位
                destinationPoint = [self getNeedShowAnmationPosition:0
                                                       positionPools:arr
                                                            fromView:containerController.roomController.roomPositionView];
            } else {
                destinationPoint = CGPointMake(containerController.roomController.IDAndOnlineLabel.center.x, containerController.roomController.IDAndOnlineLabel.center.y);
            }
        }
        
        if (originPosition) { //发送人在麦序上
           starPoint = [self getNeedShowAnmationPosition:[originPosition integerValue]+1
                                           positionPools:arr
                                                fromView:containerController.roomController.roomPositionView];
        } else {//发送人不在麦序上
            
            starPoint = CGPointMake([UIScreen mainScreen].bounds.size.width -20, [UIScreen mainScreen].bounds.size.height-10);
        }
    }
    
    [postionDictionary safeSetObject:[NSValue valueWithCGPoint:starPoint] forKey:@"start"];
    [postionDictionary safeSetObject:[NSValue valueWithCGPoint:destinationPoint] forKey:@"end"];
    
    return postionDictionary;
}

#pragma mark - private Method

/// 获取需要显示动画的位置
/// @param positionValue 需要显示动画的坑位 index
/// @param positionPools 所有的坑位集合
/// @param fromView 在显示的 view
+ (CGPoint)getNeedShowAnmationPosition:(NSInteger)positionValue
                         positionPools:(NSMutableArray *)positionPools
                              fromView:(UIView *)fromView {
    
    NSValue *pointValue = [positionPools safeObjectAtIndex:positionValue];
    CGPoint point = [pointValue CGPointValue];

    CGPoint lastPoint = [fromView convertPoint:point toView:nil];
    return lastPoint;
}

@end
