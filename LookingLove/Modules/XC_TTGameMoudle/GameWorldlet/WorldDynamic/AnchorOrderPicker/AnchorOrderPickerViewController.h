//
//  AnchorOrderPickerViewController.h
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2020/4/28.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//  主播下单

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class AnchorOrderInfo;

@interface AnchorOrderPickerViewController : BaseTableViewController

@property (nonatomic, copy) void (^orderHandler)(AnchorOrderInfo *order);

@end

NS_ASSUME_NONNULL_END
