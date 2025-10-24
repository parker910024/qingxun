//
//  CheckinDraw.h
//  AFNetworking
//
//  Created by lvjunhang on 2019/3/25.
//  瓜分金币模型

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN


@interface CheckinDraw: BaseObject
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) NSInteger round;//当前轮数
@property (nonatomic, assign) NSInteger goldNum;//瓜分的金币数
@property (nonatomic, assign) NSInteger createTime;
@property (nonatomic, assign) NSInteger roundId;//当前轮数id
@property (nonatomic, assign) NSInteger goldPoolId;//瓜分到的奖池奖品id
@property (nonatomic, assign) NSInteger level;//瓜分到的奖品等级
@property (nonatomic, assign) NSInteger uid;//用户id
@end

NS_ASSUME_NONNULL_END
