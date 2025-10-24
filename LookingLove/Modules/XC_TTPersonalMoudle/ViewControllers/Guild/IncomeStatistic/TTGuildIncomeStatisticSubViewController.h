//
//  TTGuildIncomeStatisticSubViewController
//  TuTu
//
//  Created by lvjunhang on 2019/1/19.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  收入统计管理器子控制器

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

/**
 公会收入统计类型

 - TTGuildIncomeStatisticTypeDay: 按日
 - TTGuildIncomeStatisticTypeWeek: 按周
 */
typedef NS_ENUM(NSUInteger, TTGuildIncomeStatisticType) {
    TTGuildIncomeStatisticTypeDay,
    TTGuildIncomeStatisticTypeWeek,
};

@interface TTGuildIncomeStatisticSubViewController : BaseTableViewController
@property (nonatomic, assign) TTGuildIncomeStatisticType type;
@end

NS_ASSUME_NONNULL_END
