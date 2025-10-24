//
//  CheckinSignDetail.h
//  AFNetworking
//
//  Created by lvjunhang on 2019/3/25.
//  签到详情

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface CheckinSignDetail : BaseObject
@property (nonatomic, assign) NSInteger totalDay;//累计签到N天
@property (nonatomic, assign) NSInteger isSign;//今天是否已签到(0是未签到,1是已签到)
@property (nonatomic, assign) NSInteger showGoldNum;//展示奖池金额数
@property (nonatomic, copy) NSString *drawGoldDate;//瓜分金币时间
@property (nonatomic, assign) NSInteger isDrawGold;//瓜分金币按钮状态(0是不开启,1是开启未瓜分,2是开启已瓜分)
@property (nonatomic, assign) NSInteger drawGoldNum;//瓜分到的金币数(当isDrawGold不为2时,这字段为空)
@property (nonatomic, assign) NSInteger isSignRemind;//是否开启签到提醒(0未开启,1已开启)
@property (nonatomic, copy) NSString *signPrizeName;//今天签到获取的奖品名
@property (nonatomic, assign) NSInteger signPrizeNum;//今天签到获取的奖品数量
@property (nonatomic, assign) BOOL needSignDialog;//是否需要弹出签到提醒框(true是需要,false是不需要)
@property (nonatomic, assign) NSInteger todaySignDay;//今天是当前轮数中第几天
@property (nonatomic, copy) NSString *prizeDays;//奖励天数(带有单位天，为空时不显示)
@property (nonatomic, copy) NSString *showText;//拼接好的礼物+奖励天数+奖品数量
@property (nonatomic, assign) BOOL canReplenishSign;//是否可以补签，判断补签机会是否用完，用完则补签标记变灰色
@end

NS_ASSUME_NONNULL_END
