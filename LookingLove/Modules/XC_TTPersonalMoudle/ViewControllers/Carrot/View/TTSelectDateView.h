//
//  TTSelectDateView.h
//  TTPlay
//
//  Created by lee on 2019/3/15.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 选择日期样式

 - selectDateTypeToady: 选择今天
 - selectDateTypeChooseDay: 选择一个日期
 */
typedef NS_ENUM(NSUInteger, selectDateType) {
    selectDateTypeToady = 0,
    selectDateTypeChooseDay = 1,
};
typedef void(^DateViewSelectTodayHandler)(selectDateType dateType);

@interface TTSelectDateView : UIView

@property (nonatomic, assign) selectDateType dateType;
@property (nonatomic, copy) DateViewSelectTodayHandler selecteDayHandler;
@property (nonatomic, copy) NSString *todayText;
@end

NS_ASSUME_NONNULL_END
