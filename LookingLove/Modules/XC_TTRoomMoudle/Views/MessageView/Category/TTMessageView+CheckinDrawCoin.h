//
//  TTMessageView+CheckinDrawCoin.h
//  TTPlay
//
//  Created by lvjunhang on 2019/3/29.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  签到瓜分金币

#import "TTMessageView.h"
#import "XCCheckinDrawCoinAttachment.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTMessageView (CheckinDrawCoin)

/**
 处理签到瓜分到二级金币的公屏通知
 */
- (void)messageCell:(TTMessageTextCell *)cell handleDrawCoinWithModel:(TTMessageDisplayModel *)model;

@end

NS_ASSUME_NONNULL_END
