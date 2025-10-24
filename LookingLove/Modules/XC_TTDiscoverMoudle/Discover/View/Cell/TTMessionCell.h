//
//  TTMessionCell.h
//  TTPlay
//
//  Created by lee on 2019/3/20.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MissionInfo.h"
static NSString * _Nonnull const kMessionCellConst = @"kMessionCellConst";
typedef void(^TTMessionCellBtnClickHandler)(P2PInteractive_SkipType skipType, NSString * _Nullable configId);
NS_ASSUME_NONNULL_BEGIN

@interface TTMessionCell : UITableViewCell
@property (nonatomic, strong) MissionInfo *info;
@property (nonatomic, copy) TTMessionCellBtnClickHandler btnClickHandler;
@end

NS_ASSUME_NONNULL_END
