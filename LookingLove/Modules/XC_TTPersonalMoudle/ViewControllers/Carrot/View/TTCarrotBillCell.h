//
//  TTCarrotBillCell.h
//  TTPlay
//
//  Created by lee on 2019/3/27.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CarrotGiftInfo;
static NSString *const kTTCarrotBillCellConst = @"kTTCarrotBillCellConst";
NS_ASSUME_NONNULL_BEGIN

@interface TTCarrotBillCell : UITableViewCell
@property (nonatomic, strong) CarrotGiftInfo *carrotInfo;
@end

NS_ASSUME_NONNULL_END
