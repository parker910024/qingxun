//
//  CheckinCore.h
//  AFNetworking
//
//  Created by lvjunhang on 2019/3/25.
//  签到core

#import "BaseCore.h"

NS_ASSUME_NONNULL_BEGIN

@interface CheckinCore : BaseCore

/**
 签到分享统计接口
 */
- (void)requestCheckinShare;

/**
 领取累计奖励
 
 @param configId 奖励配置id
 */
- (void)requestCheckinReceiveTotalRewardWithConfigId:(NSString *)configId;

/**
 瓜分金币
 */
- (void)requestCheckinDraw;

/**
 每日签到奖励预告
 */
- (void)requestCheckinRewardTodayNotice;

/**
 获取签到详情
 */
- (void)requestCheckinSignDetail;

/**
 签到接口
 */
- (void)requestCheckinSign;

/**
 累计奖励预告
 */
- (void)requestCheckinRewardTotalNotice;

/**
 瓜分金币通知栏
 */
- (void)requestCheckinDrawNotice;

/**
 签到提醒(开启/关闭)
 */
- (void)requestCheckinSignRemind;

/**
 获取签到分享图片
 
 @param shareType 分享类型：1普通，2领取礼物，3瓜分金币
 @param day 天数
 @param reward 奖励
 */
- (void)requestCheckinShareImageWithType:(NSInteger)shareType
                                     day:(NSString *)day
                                  reward:(NSString *)reward;

/**
 获取补签信息
 
 @param signDay 第几天补签
 */
- (void)requestCheckinReplenishInfoWithSignDay:(NSUInteger)signDay;

/**
 补签
 
 @param signDay 第几天补签
 */
- (void)requestCheckinReplenishWithSignDay:(NSUInteger)signDay;

@end

NS_ASSUME_NONNULL_END
