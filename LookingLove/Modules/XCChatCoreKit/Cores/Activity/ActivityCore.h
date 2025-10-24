//
//  ActivityCore.h
//  BberryCore
//
//  Created by 卫明何 on 2017/10/19.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "BaseCore.h"
#import "ActivityInfo.h"

@interface ActivityCore : BaseCore

@property (strong, nonatomic) ActivityInfo *activityInfo;
@property (nonatomic, strong) NSArray<ActivityInfo *> *activityInfoList;
//获取房间活动
- (void)getActivity:(NSInteger)type;

//获取首页活动
- (void)getActivityForGamePage:(NSInteger)type;
    
/**
 校验是否符合老用户回归
 */
- (void)checkOldUserRegressionActivity;

/**
 绑定老用户邀请关系

 @param invitationCode 邀请码
 */
- (void)getOldUserRegressionActivityGiftWithCode:(NSString *)invitationCode;

/// 获取房间活动暴击倒计时
/// time 2020-02-25
/// @param roomUid 房间 uid
- (void)getActivityRunawayTime:(long long)roomUid;

@end
