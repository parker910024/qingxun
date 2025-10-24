//
//  TTGuildIncomeStatisticTableHeaderView.h
//  TuTu
//
//  Created by lvjunhang on 2019/1/19.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define BGIMAGE_ASPECT_RATIO 81/345.0f

typedef void(^SelectDayActionBlock)(void);

@interface TTGuildIncomeStatisticTableHeaderView : UIView
@property (nonatomic, copy) SelectDayActionBlock selectDayActionBlock;

@property (nonatomic, strong) NSDate *selectDate;//当前选中的时间

@property (nonatomic, strong) NSDate *startDate;//按周统计时，周一的时间
@property (nonatomic, strong) NSDate *endDate;//按周统计时，周日的时间

@property (nonatomic, assign) BOOL isWeek;

#pragma mark - Public Methods
/**
 设置金币数量

 @param number 金币数量
 */
- (void)setupTotalNumber:(NSInteger)number;

/**
 设置日期区间

 @param start 开始时间
 @param endTime 结束时间
 */
- (void)configDateStartTime:(NSString *)start endTime:(NSString *)endTime;
@end


NS_ASSUME_NONNULL_END
