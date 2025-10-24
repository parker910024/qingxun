//
//  CheckinRewardTotalNotice.h
//  AFNetworking
//
//  Created by lvjunhang on 2019/3/25.
//  累计奖励预告

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface CheckinRewardTotalNotice : BaseObject
@property (nonatomic, assign) NSInteger signRewardConfigId;//奖励配置id
@property (nonatomic, copy) NSString *icon;//奖品图片
@property (nonatomic, assign) NSInteger isReceive;//是否领取(0为未领取,1为领取)
@property (nonatomic, copy) NSString *signRewardName;//奖品名称
@property (nonatomic, assign) NSInteger signDays;//累计签到天数
@end

NS_ASSUME_NONNULL_END
