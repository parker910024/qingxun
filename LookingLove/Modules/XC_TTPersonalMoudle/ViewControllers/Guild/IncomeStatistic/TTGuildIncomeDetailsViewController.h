//
//  TTGuildIncomeDetailsViewController.h
//  TuTu
//
//  Created by lee on 2019/1/21.
//  Copyright © 2019 YiZhuan. All rights reserved.
//
// 收入明细

#import "BaseUIViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class GuildIncomeTotalVos;
@interface TTGuildIncomeDetailsViewController : BaseUIViewController
@property (nonatomic, strong) GuildIncomeTotalVos *totalInfo;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;
@end

NS_ASSUME_NONNULL_END
