//
//  CheckinReplenish.h
//  XCChatCoreKit
//
//  Created by lvjunhang on 2019/5/7.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  补签

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface CheckinReplenish : BaseObject

/**
 增加的金币奖池数
 */
@property (nonatomic, assign) NSUInteger signGoldNum;
/**
 奖品名称
 */
@property (nonatomic, copy) NSString *prizeName;
/**
 第几次补签
 */
@property (nonatomic, copy) NSString *replenishSignNum;

@end

NS_ASSUME_NONNULL_END
