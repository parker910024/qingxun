//
//  ActivityCoreClient.h
//  BberryCore
//
//  Created by 卫明何 on 2017/10/19.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActivityInfo.h"
#import "RedInfo.h"
#import "ActivityContainInfo.h"

@protocol ActivityCoreClient <NSObject>
@optional
- (void)getActivityInfoSuccess;
- (void)getActivityInfoListSuccess:(NSArray<ActivityInfo *> *)list;
- (void)getActivityInfoListWithGameRoomSuccess:(ActivityContainInfo *)list;
- (void)getActivityInfoListWithGamePageSuccess:(ActivityContainInfo *)list;
- (void)onReceiveP2PRedPacket:(RedInfo *)info;

/// 获取活动暴击倒计时成功
/// @param runawayTime 活动开始时间戳 例如: 1582533719014
/// @param limitTime 持续时间 例如: 180s
- (void)getActivityRunawayTimeSuccess:(NSTimeInterval)runawayTime limitTime:(NSInteger)limitTime code:(NSInteger)code msg:(NSString *)msg;
//老用户回归活动
- (void)onCheckTheOldUserRegressionWithMath:(BOOL)isMatch;
- (void)onGetTheOldUserRegressionGiftSuccess;
- (void)onGetTheOldUserRegressionGiftFailure;
@end
