//
//  CheckinReplenishInfo.h
//  XCChatCoreKit
//
//  Created by lvjunhang on 2019/5/7.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  补签信息

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface CheckinReplenishInfo : BaseObject

/**
 类型，1：分享，2，支付萝卜
 */
@property (nonatomic, assign) NSUInteger type;
/**
 价格
 */
@property (nonatomic, assign) NSUInteger price;

@end

NS_ASSUME_NONNULL_END
