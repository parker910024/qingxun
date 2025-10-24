//
//  CheckinRewardTodayNotice.h
//  AFNetworking
//
//  Created by lvjunhang on 2019/3/25.
//  每日签到奖励预告

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface CheckinRewardTodayNotice : BaseObject
@property (nonatomic, assign) NSInteger signRewardConfigId;//奖励配置id
@property (nonatomic, copy) NSString *icon;//奖片图片
@property (nonatomic, assign) NSInteger isReceive;//是否已领取(0是未领取,1是已领取)
@property (nonatomic, copy) NSString *signRewardName;//奖品名称
@property (nonatomic, assign) NSInteger signDays;//第几天签到
@property (nonatomic, assign) BOOL canReplenishSign;//是否可以补签，没到日期不显示补签标记
@property (nonatomic, assign) NSInteger signType;//补签类型，1正常签到，2补签
@end

NS_ASSUME_NONNULL_END
