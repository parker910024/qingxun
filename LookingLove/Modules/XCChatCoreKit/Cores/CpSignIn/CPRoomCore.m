//
//  CPRoomCore.m
//  UKiss
//
//  Created by apple on 2018/10/13.
//  Copyright © 2018年 yizhuan. All rights reserved.
//

#import "CPRoomCore.h"
#import "HttpRequestHelper+CPRoom.h"
#import "CPRoomCoreClient.h"

@implementation CPRoomCore


- (void)requestCPRoomUserSignInlistWithByUid:(NSString *)uid {
    [HttpRequestHelper requestCPRoomUserSignInlistWithByUid:uid success:^(CPSignInlistModel * _Nonnull signInlistModel) {
        NotifyCoreClient(CPRoomCoreClient, @selector(requestCPRoomUserSignInlistSuccess:), requestCPRoomUserSignInlistSuccess:signInlistModel)
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        NotifyCoreClient(CPRoomCoreClient, @selector(requestCPRoomUserSignInlistFailth:), requestCPRoomUserSignInlistFailth:message)
    }];
}

/**
 //每日签到接口/打卡记录
 */
- (void)requestCPRoomSignInWithByUid:(UserID)uid{
    
    [HttpRequestHelper requestCPRoomSignInWithByUid:uid success:^(XCRedPckageModel * _Nonnull signInInfo) {
        NotifyCoreClient(CPRoomCoreClient, @selector(requestCPRoomSignInSuccess:), requestCPRoomSignInSuccess:signInInfo)
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        NotifyCoreClient(CPRoomCoreClient, @selector(requestCPRoomSignInFailth:), requestCPRoomSignInFailth:message)
    }];
}


/**
 每天是否是每天第一次启动
 */
- (void)requestCPRoomDayFirstWithByUid:(UserID)uid{
    
    [HttpRequestHelper requestCPRoomDayFirstWithByUid:uid success:^(BOOL isFirst) {
        NotifyCoreClient(CPRoomCoreClient, @selector(requestCPRoomDayFirstSuccess:), requestCPRoomDayFirstSuccess:isFirst)
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        NotifyCoreClient(CPRoomCoreClient, @selector(requestCPRoomDayFirstFailth:), requestCPRoomDayFirstFailth:message)
    }];
}

/**
 今天的打卡状态/记录
 */
- (void)requestCPRoomSignInStatusWithByUid:(UserID)uid{
    
    [HttpRequestHelper requestCPRoomSignInStatusWithByUid:uid success:^(XCCPSignStatus * _Nonnull signStatus) {
        NotifyCoreClient(CPRoomCoreClient, @selector(requestCPRoomSignInStatusSuccess:), requestCPRoomSignInStatusSuccess:signStatus)
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        NotifyCoreClient(CPRoomCoreClient, @selector(requestCPRoomSignInStatusFailth:), requestCPRoomSignInStatusFailth:message)
    }];
}

/**
 打卡提醒
 */
- (void)requestCPRoomSignInRemindWithByUid:(UserID)uid{
    [HttpRequestHelper requestCPRoomSignInRemindWithByUid:uid success:^{
        NotifyCoreClient(CPRoomCoreClient, @selector(requestCPRoomSignInRemindSuccess), requestCPRoomSignInRemindSuccess)
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        NotifyCoreClient(CPRoomCoreClient, @selector(requestCPRoomSignInRemindFailth:), requestCPRoomSignInRemindFailth:message)
    }];
}

- (void)requestCPRoomBackRoomWithByUid:(NSString *)uid {
    [HttpRequestHelper requestCPRoomBackRoomWithByUid:uid success:^{
        NotifyCoreClient(CPRoomCoreClient, @selector(requestCPRoomBackRoomSuccess), requestCPRoomBackRoomSuccess);
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        NotifyCoreClient(CPRoomCoreClient, @selector(requestCPRoomBackRoomFailth:), message);
    }];
}

@end
