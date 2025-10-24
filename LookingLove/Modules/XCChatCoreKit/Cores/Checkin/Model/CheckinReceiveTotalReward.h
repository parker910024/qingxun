//
//  CheckinReceiveTogalReward.h
//  AFNetworking
//
//  Created by lvjunhang on 2019/4/1.
//  领取累计奖励成功后返回模型

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface CheckinReceiveTotalReward : BaseObject
@property (nonatomic, assign) NSInteger signDays;//累计奖励的天数，第几天才可以领取，用于分享好友时使用
@property (nonatomic, copy) NSString *prizePic;//奖片图片
@property (nonatomic, copy) NSString *prizeDays;//奖励天数(带有单位天，为空时不显示)
@property (nonatomic, copy) NSString *prizeName;//奖品名称
@property (nonatomic, assign) NSInteger num;//奖励数量
@property (nonatomic, copy) NSString *showText;//拼接好的礼物+奖励天数+奖品数量
@end

NS_ASSUME_NONNULL_END
