//
//  CPBindCore.m
//  UKiss
//
//  Created by apple on 2018/9/29.
//  Copyright © 2018年 yizhuan. All rights reserved.
//

#import "CPBindCore.h"
#import "CPBindCoreClient.h"
#import "HttpRequestHelper+CPBind.h"

@implementation CPBindCore

- (void)requestCPBindWithUniqueCode:(NSString *)code withRecomUniqueCode:(NSString *)recomUniqueCode{

    [HttpRequestHelper requestCPBindWithUniqueCode:code  recomUniqueCode:recomUniqueCode success:^{
        NotifyCoreClient(CPBindCoreClient, @selector(requestCPBindInfoSuccess), requestCPBindInfoSuccess)
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        NotifyCoreClient(CPBindCoreClient, @selector(requestCPBindInfoFailth:), requestCPBindInfoFailth:message);
    }];
}

- (void)requestCPUnBindWithByUid{
    [HttpRequestHelper requestCPUnBindSuccess:^{
        NotifyCoreClient(CPBindCoreClient, @selector(requestCPUnBindInfoSuccess), requestCPUnBindInfoSuccess)
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        NotifyCoreClient(CPBindCoreClient, @selector(requestCPUnBindInfoFailth:), requestCPUnBindInfoFailth:message);
    }];
}

- (void)requestCPOnlineWithUid:(NSString *)uid
                     coupleUid:(NSString *)coupleUid
                        roomId:(NSString *)roomId {
    [HttpRequestHelper requestCPOnlineWithUid:uid coupleUid:coupleUid roomId:roomId Success:^(CPOnline * _Nonnull cpOnline) {
        NotifyCoreClient(CPBindCoreClient, @selector(requestCPOnlineSuccess:), requestCPOnlineSuccess:cpOnline)
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        NotifyCoreClient(CPBindCoreClient, @selector(requestCPOnlineFailth:), requestCPOnlineFailth:message);
    }];
}

- (void)requestCPOnlineFinishWithUid:(NSString *)uid
                           coupleUid:(NSString *)coupleUid
                              roomId:(NSString *)roomId {
    [HttpRequestHelper requestCPOnlineFinishWithUid:uid coupleUid:coupleUid roomId:roomId Success:^(XCRedPckageModel * _Nonnull onlineFinish) {
        NotifyCoreClient(CPBindCoreClient, @selector(requestCPOnlineFinishSuccess:),requestCPOnlineFinishSuccess:onlineFinish);
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        NotifyCoreClient(CPBindCoreClient, @selector(requestCPOnlineFinishFailth:), requestCPOnlineFinishFailth:message);
    }];
}

- (void)requestCPOnlineAddAccompanyWithUid:(NSString *)uid type:(NSString *)type {
    [HttpRequestHelper requestCPOnlineAddAccompanyWithUid:uid type:type Success:^(int accompanyValue , int  addValue) {
        NotifyCoreClient(CPBindCoreClient, @selector(requestCPOnlineAddAccompanySuccess:addValue:),requestCPOnlineAddAccompanySuccess:accompanyValue addValue:addValue);

    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        NotifyCoreClient(CPBindCoreClient, @selector(requestCPOnlineAddAccompanyFailth:), requestCPOnlineAddAccompanyFailth:message);
    }];
}

- (void)requestCPOnlineGetInfoWithUid:(NSString *)uid {
    [HttpRequestHelper requestCPOnlineGetInfoWithUid:uid Success:^(NSString * _Nonnull lastLoginTime) {
        NotifyCoreClient(CPBindCoreClient, @selector(requestCPOnlineGetInfoSuccess:),requestCPOnlineGetInfoSuccess:lastLoginTime);
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        NotifyCoreClient(CPBindCoreClient, @selector(requestCPOnlineGetInfoFailth:), requestCPOnlineGetInfoFailth:message);
    }];
}

- (void)requestCPOnlineTextModeWithUid:(NSString *)Uid {
    [HttpRequestHelper requestCPOnlineTextModeWithUid:Uid Success:^{
         NotifyCoreClient(CPBindCoreClient, @selector(requestCPOnlineTextSuccess),requestCPOnlineTextSuccess);
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
         NotifyCoreClient(CPBindCoreClient, @selector(requestCPOnlineTextFailth:),requestCPOnlineTextFailth:message);
    }];
}

- (void)requestCPLeaveRoomAndSyncTimeUid:(NSString *)uid
                                 coupleUid:(NSString *)coupleUid
                                  roomId:(NSInteger)roomId
                                  leavediffer:(long)leavediffer {
    [HttpRequestHelper requestCPLeaveRoomAndSyncTimeUid:uid coupleUid:coupleUid roomId:roomId leavediffer:leavediffer Success:^{
        NotifyCoreClient(CPBindCoreClient, @selector(requestCPLeaveRoomAndSyncTimeSuccess),requestCPLeaveRoomAndSyncTimeSuccess);
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        NotifyCoreClient(CPBindCoreClient, @selector(requestCPLeaveRoomAndSyncTimeFailth:),requestCPLeaveRoomAndSyncTimeFailth:message);

    }];
}

- (void)requestCPRoomSyncTimeUid:(NSString *)uid
                       coupleUid:(NSString *)coupleUid
                          roomId:(NSInteger)roomId {
    if (coupleUid.integerValue <= 0) return;//没有cp对象
    [HttpRequestHelper requestCPRoomSyncTimeUid:uid coupleUid:coupleUid roomId:roomId Success:^{
        NotifyCoreClient(CPBindCoreClient, @selector(requestCPRoomSyncTimeSuccess),requestCPRoomSyncTimeSuccess);
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        NotifyCoreClient(CPBindCoreClient, @selector(requestCPRoomSyncTimeFailth:),requestCPRoomSyncTimeFailth:message);
    }];
}
@end
