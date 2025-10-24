//
//  RoomRedConfig.h
//  XCChatCoreKit
//
//  Created by lvjunhang on 2020/5/13.
//  Copyright © 2020 YiZhuan. All rights reserved.
//  红包配置信息

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface RoomRedConfig : BaseObject
@property (nonatomic, assign) int minAmount;
@property (nonatomic, assign) int maxAmount;
@property (nonatomic, assign) int minNum;
@property (nonatomic, assign) int maxNum;
@property (nonatomic, strong) NSArray *requireTypeList;
@property (nonatomic, copy) NSString *defaultNotifyText;
@property (nonatomic, assign) BOOL feeSwitch;
@property (nonatomic, assign) double feeRate;
@end

NS_ASSUME_NONNULL_END
