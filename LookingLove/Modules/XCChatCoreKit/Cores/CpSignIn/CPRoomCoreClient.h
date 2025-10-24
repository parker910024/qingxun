//
//  CPRoomCoreClient.h
//  UKiss
//
//  Created by apple on 2018/10/13.
//  Copyright © 2018年 yizhuan. All rights reserved.
//
#import "XCCPSignStatus.h"
@class CPSignInlistModel;
@class XCRedPckageModel;

@protocol CPRoomCoreClient <NSObject>

@optional


/**签到列表请求成功*/
- (void)requestCPRoomUserSignInlistSuccess:(CPSignInlistModel *)signInlistModel;
- (void)requestCPRoomUserSignInlistFailth:(NSString *)message;

/**
    每日签到接口/打卡记录
 */
- (void)requestCPRoomSignInSuccess:(XCRedPckageModel *)signInInfo;
- (void)requestCPRoomSignInFailth:(NSString *)message;

/**
 每天是否是每天第一次启动
 */
- (void)requestCPRoomDayFirstSuccess:(BOOL)isFirst;
- (void)requestCPRoomDayFirstFailth:(NSString *)message;

/**
 今天的打卡状态/记录
 */
- (void)requestCPRoomSignInStatusSuccess:(XCCPSignStatus *)cPSignStatus;
- (void)requestCPRoomSignInStatusFailth:(NSString *)message;


/**
 打卡提醒
 */
- (void)requestCPRoomSignInRemindSuccess;
- (void)requestCPRoomSignInRemindFailth:(NSString *)message;

/**
 回到爱窝
 */
- (void)requestCPRoomBackRoomSuccess;
- (void)requestCPRoomBackRoomFailth:(NSString *)message;
@end
