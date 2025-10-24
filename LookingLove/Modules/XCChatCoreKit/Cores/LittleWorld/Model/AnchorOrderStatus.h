//
//  AnchorOrderStatus.h
//  XCChatCoreKit
//
//  Created by lvjunhang on 2020/4/27.
//  Copyright © 2020 YiZhuan. All rights reserved.
//  主播订单状态

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@class AnchorOrderInfo;

@interface AnchorOrderStatus : BaseObject
@property (nonatomic, copy) NSString *tips;//派单文案说明，只要有一个人有订单就显示
@property (nonatomic, strong) AnchorOrderInfo *workOrder;//认证主播的派单，没有派单返回空

@end

@interface AnchorOrderInfo : BaseObject
@property (nonatomic, copy) NSString *orderPrice;//订单的价格
@property (nonatomic, assign) NSInteger orderDuration;//订单的陪玩时长（分钟)
@property (nonatomic, copy) NSString *orderType;//订单的类型
@property (nonatomic, copy) NSString *orderValidTime;//订单的有效时长（剩余秒数）

/// 最终有效时间，客户端自有字段
/// 根据订单剩余秒数orderValidTime生成
@property (nonatomic, copy) NSDate *orderFinalValidDate;

@end

NS_ASSUME_NONNULL_END
