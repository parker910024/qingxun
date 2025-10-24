//
//  TTDisplayModelMaker+CheckinDrawCoin.h
//  TTPlay
//
//  Created by lvjunhang on 2019/4/8.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  签到瓜分二级金币通知

#import "TTDisplayModelMaker.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTDisplayModelMaker (CheckinDrawCoin)

- (TTMessageDisplayModel *)makeCheckinDrawCoinContentWithMessage:(NIMMessage *)message model:(TTMessageDisplayModel *)model;

@end

NS_ASSUME_NONNULL_END
