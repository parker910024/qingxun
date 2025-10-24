//
//  TTRechargeViewCell.h
//  TuTu
//
//  Created by lee on 2018/11/5.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RechargeInfo;
@interface TTRechargeViewCell : UICollectionViewCell

@property (nonatomic, strong) RechargeInfo *rechargeInfo;
@property (nonatomic, assign) BOOL isSelected;

@end

NS_ASSUME_NONNULL_END
