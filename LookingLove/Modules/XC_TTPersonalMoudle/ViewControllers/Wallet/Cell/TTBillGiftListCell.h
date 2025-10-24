//
//  TTBillGiftListCell.h
//  TuTu
//
//  Created by lee on 2018/11/12.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTBillListEnumConst.h"
NS_ASSUME_NONNULL_BEGIN

@class GiftBillInfo, BaseObject, CarrotGiftInfo;
@interface TTBillGiftListCell : UITableViewCell
@property (nonatomic, strong) GiftBillInfo *giftInfo;
@property (nonatomic, strong) CarrotGiftInfo *carrotInfo;
@property (nonatomic, assign) TTBillListViewType giftType;

- (void)configModel:(__kindof BaseObject *)baseObject;
@end

NS_ASSUME_NONNULL_END
