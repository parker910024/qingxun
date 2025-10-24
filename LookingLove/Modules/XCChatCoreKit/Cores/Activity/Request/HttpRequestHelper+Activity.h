//
//  HttpRequestHelper+Activity.h
//  BberryCore
//
//  Created by 卫明何 on 2017/10/19.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "HttpRequestHelper.h"
#import "ActivityInfo.h"
#import "ActivityContainInfo.h"

@interface HttpRequestHelper (Activity)

/**
 用户回归接口

 @param invitationCode 邀请码（选填）
 @param uid 用户uid
 @param success 成功
 @param failure 失败
 */
+ (void)getOldUserRegressionActivityGiftWithInvitationCode:(nullable NSString *)invitationCode
                                     uid:(UserID)uid
                                 success:(void (^)(BOOL match))success
                                 failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/**
 查询是否拥有老用户回归活动权限

 @param uid 用户uid
 @param success 成功
 @param failure 失败
 */
+ (void)checkOldUserRegressionActivity:(UserID)uid
                               success:(void (^_Nullable)(BOOL match))success
                               failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/**
 获取活动配置

 @param type 类型
 @param success 成功
 @param failure 失败
 */
+ (void)getActivityWithType:(NSInteger)type
                    success:(void (^)(ActivityInfo *info))success
                    failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/**
 获取活动配置数组

 @param type 类型
 @param success 成功
 @param failure 失败
 */
+ (void)getActivityListWithType:(NSInteger)type
                    success:(void (^)(NSArray<ActivityInfo *> *list))success
                    failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/**
 获取活动配置数组 兔兔 新版用
 
 @param type 类型
 @param success 成功
 @param failure 失败
 */
+ (void)getActivityListWithTuTuType:(NSInteger)type
                        success:(void (^)(ActivityContainInfo *list))success
                        failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/// 获取活动高能暴击倒计时
/// @param completionHander 完成回调
+ (void)getActivityRunawayTimeWithRoomUid:(long long)roomUid
                         CompletionHander:(HttpRequestHelperCompletion _Nullable )completionHander;
@end
