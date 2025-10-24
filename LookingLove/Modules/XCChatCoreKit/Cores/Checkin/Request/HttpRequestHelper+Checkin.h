//
//  HttpRequestHelper+Checkin.h
//  AFNetworking
//
//  Created by lvjunhang on 2019/3/25.
//

#import "HttpRequestHelper.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^HttpRequestHelperCheckinCompletion)(id _Nullable data, NSNumber * _Nullable code, NSString * _Nullable msg);

@interface HttpRequestHelper (Checkin)

/**
 签到分享统计接口
 
 @param completion 完成回调
 */
+ (void)requestCheckinShareOnCompletion:(HttpRequestHelperCheckinCompletion)completion;

/**
 领取累计奖励
 
 @param configId 奖励配置id
 @param completion 完成回调
 */
+ (void)requestCheckinReceiveTotalRewardWithConfigId:(NSString *)configId completion:(HttpRequestHelperCheckinCompletion)completion;

/**
 瓜分金币
 
 @param completion 完成回调
 */
+ (void)requestCheckinDrawOnCompletion:(HttpRequestHelperCheckinCompletion)completion;

/**
 每日签到奖励预告
 
 @param completion 完成回调
 */
+ (void)requestCheckinRewardTodayNoticeOnCompletion:(HttpRequestHelperCheckinCompletion)completion;

/**
 获取签到详情
 
 @param completion 完成回调
 */
+ (void)requestCheckinSignDetailOnCompletion:(HttpRequestHelperCheckinCompletion)completion;

/**
 签到接口
 
 @param completion 完成回调
 */
+ (void)requestCheckinSignOnCompletion:(HttpRequestHelperCheckinCompletion)completion;

/**
 累计奖励预告
 
 @param completion 完成回调
 */
+ (void)requestCheckinRewardTotalNoticeOnCompletion:(HttpRequestHelperCheckinCompletion)completion;

/**
 瓜分金币通知栏
 
 @param completion 完成回调
 */
+ (void)requestCheckinDrawNoticeOnCompletion:(HttpRequestHelperCheckinCompletion)completion;

/**
 签到提醒(开启/关闭)
 
 @param completion 完成回调
 */
+ (void)requestCheckinSignRemindOnCompletion:(HttpRequestHelperCheckinCompletion)completion;

/**
 获取签到分享图片
 
 @param shareType 分享类型：1普通，2领取礼物，3瓜分金币
 @param day 天数
 @param reward 奖励
 @param completion 完成回调
 */
+ (void)requestCheckinShareImageWithType:(NSInteger)shareType
                                     day:(NSString *)day
                                  reward:(NSString *)reward
                              completion:(HttpRequestHelperCheckinCompletion)completion;

/**
 获取补签信息
 
 @param signDay 第几天补签
 */
+ (void)requestCheckinReplenishInfoWithSignDay:(NSUInteger)signDay
                                    completion:(HttpRequestHelperCheckinCompletion)completion;

/**
 补签
 
 @param signDay 第几天补签
 */
+ (void)requestCheckinReplenishWithSignDay:(NSUInteger)signDay
                                completion:(HttpRequestHelperCheckinCompletion)completion;
@end

NS_ASSUME_NONNULL_END
