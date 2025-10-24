//
//  MissionCore.m
//  XCChatCoreKit
//
//  Created by lee on 2019/3/28.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "MissionCore.h"
#import "HttpRequestHelper+Mission.h"
// model
#import "MissionInfo.h"
#import "MissionCoreClient.h"
@implementation MissionCore

/**
 获取任务列表
 interface /mission/list
 */
- (void)requestMissionList {
    [HttpRequestHelper requestMissionListAndCompletionHandler:^(id  _Nullable resultObject, NSNumber * _Nullable code, NSString * _Nullable msg) {

        NSArray *list = [NSArray yy_modelArrayWithClass:MissionInfo.class json:resultObject];
        NotifyCoreClient(MissionCoreClient, @selector(getMissionList:code:message:), getMissionList:list code:code.integerValue message:msg);
    }];
}

/**
 请求专属任务列表
 interface mission/achievement/list
 */
- (void)requestMissionAchievementList {
    [HttpRequestHelper requestMissionAchievementListAndCompletionHandler:^(id  _Nullable resultObject, NSNumber * _Nullable code, NSString * _Nullable msg) {
        NSArray *list = [NSArray yy_modelArrayWithClass:MissionInfo.class json:resultObject];
        NotifyCoreClient(MissionCoreClient, @selector(getMissionAchievementList:code:message:), getMissionAchievementList:list code:code.integerValue message:msg);
    }];
}

/**
 任务完成领取奖励
 
 @param configId 任务id
 */
- (void)requestMissionReceiveByMissionID:(NSString *)configId {
    [HttpRequestHelper requestMissionReceiveByMissionID:configId AndCompletionHandler:^(id  _Nullable resultObject, NSNumber * _Nullable code, NSString * _Nullable msg) {

        BOOL isSuccess = code == nil && msg == nil;
        
        NotifyCoreClient(MissionCoreClient, @selector(getMissionReceive:code:message:), getMissionReceive:isSuccess code:code.integerValue message:msg);
    }];
}

/**
 任务完成领取奖励
 
 @param configId 任务id
 @param type 1 是每日任务 2 是成就任务
 */
- (void)requestMissionReceiveByMissionID:(NSString *)configId type:(NSInteger)type {
    [HttpRequestHelper requestMissionReceiveByMissionID:configId AndCompletionHandler:^(id  _Nullable resultObject, NSNumber * _Nullable code, NSString * _Nullable msg) {
        
        BOOL isSuccess = code == nil && msg == nil;
        
        NotifyCoreClient(MissionCoreClient, @selector(getMissionReceive:type:code:message:), getMissionReceive:isSuccess type:type code:code.integerValue message:msg);
    }];
}

/**
 查询是否可以领取新人有礼
 
 interface  mission/check/new/user
 */
- (void)requestMissionNewUser {
    [HttpRequestHelper requestMissionNewUserAndCompletionHandler:^(id  _Nullable resultObject, NSNumber * _Nullable code, NSString * _Nullable msg) {
        
        if ([resultObject isKindOfClass:[NSDictionary class]]) {
            BOOL isSuccess = [[resultObject objectForKey:@"hasNewUser"] boolValue];
            NSInteger configID = [[resultObject objectForKey:@"configId"] integerValue];
            NotifyCoreClient(MissionCoreClient, @selector(getMissionNewUser:configID:code:message:), getMissionNewUser:isSuccess configID:configID code:code.integerValue message:msg);
        }
    }];
}
@end
