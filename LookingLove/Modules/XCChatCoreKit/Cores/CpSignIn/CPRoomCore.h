//
//  CPRoomCore.h
//  UKiss
//
//  Created by apple on 2018/10/13.
//  Copyright © 2018年 yizhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseCore.h"

NS_ASSUME_NONNULL_BEGIN

@interface CPRoomCore : BaseCore



/**
 签到日历列表

 @param uid uid
 */
- (void)requestCPRoomUserSignInlistWithByUid:(NSString *)uid;

/**
 //每日签到接口/打卡记录
 */
- (void)requestCPRoomSignInWithByUid:(UserID)uid;


/**
 每天是否是每天第一次启动
 */
- (void)requestCPRoomDayFirstWithByUid:(UserID)uid;

/**
 今天的打卡状态/记录
 */
- (void)requestCPRoomSignInStatusWithByUid:(UserID)uid;

/**
 打卡提醒
 */
- (void)requestCPRoomSignInRemindWithByUid:(UserID)uid;

/**
 推送给自己的cp，xx回到爱窝
 */
- (void)requestCPRoomBackRoomWithByUid:(NSString *)uid;

@end

NS_ASSUME_NONNULL_END
