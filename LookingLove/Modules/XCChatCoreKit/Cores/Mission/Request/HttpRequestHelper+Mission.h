//
//  HttpRequestHelper+Mission.h
//  XCChatCoreKit
//
//  Created by lee on 2019/3/28.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "HttpRequestHelper.h"

typedef void(^HttpResponseHelperMissionCompletionHandler)(id _Nullable resultObject, NSNumber * _Nullable code, NSString * _Nullable msg);
NS_ASSUME_NONNULL_BEGIN

@interface HttpRequestHelper (Mission)

/**
 获取任务列表
 interface /mission/list
 */
+ (void)requestMissionListAndCompletionHandler:(HttpResponseHelperMissionCompletionHandler)completionHandler;

/**
 请求成就任务列表
 interface mission/achievement/list
 */
+ (void)requestMissionAchievementListAndCompletionHandler:(HttpResponseHelperMissionCompletionHandler)completionHandler;

/**
 任务完成领取奖励
 interface /mission/receive
 
 @param configId 任务id
 @param completionHandler 完成回调
 */
+ (void)requestMissionReceiveByMissionID:(NSString *)configId
                    AndCompletionHandler:(HttpResponseHelperMissionCompletionHandler)completionHandler;

/**
 查询是否可以领取新人有礼
 
 interface  mission/check/new/user
 @param completionHandler 完成回调
 */
+ (void)requestMissionNewUserAndCompletionHandler:(HttpResponseHelperMissionCompletionHandler)completionHandler;
@end

NS_ASSUME_NONNULL_END
