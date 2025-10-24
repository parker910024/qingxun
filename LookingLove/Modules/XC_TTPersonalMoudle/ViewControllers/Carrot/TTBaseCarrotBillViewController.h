//
//  TTBaseCarrotBillViewController.h
//  TTPlay
//
//  Created by lee on 2019/3/27.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "BaseTableViewController.h"

typedef NS_ENUM(NSUInteger, CarrotBillListType) {
    CarrotBillListTypeGiftOut = 1,
    CarrotBillListTypeGiftIn = 2,
};

NS_ASSUME_NONNULL_BEGIN

@interface TTBaseCarrotBillViewController : BaseTableViewController
@property (nonatomic, assign) CarrotBillListType listType;
/** 刷新数据 */
- (void)reloadDateByDate:(NSDate *)date;
// 滑动到顶部
- (void)scrollToTop;
@end

NS_ASSUME_NONNULL_END
