//
//  TTCarDressUpEmptyCell.h
//  TuTu
//
//  Created by lee on 2018/11/20.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTMineInfoEnumConst.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TTCarDressUpEmptyCellDelegate <NSObject>

- (void)onCellBtnClickAction:(UIButton *)btn;

@end

@interface TTCarDressUpEmptyCell : UICollectionViewCell

@property (nonatomic, weak) id<TTCarDressUpEmptyCellDelegate> delegate;
@property (nonatomic, assign) TTMineInfoViewStyle emptyStyle;

@end

NS_ASSUME_NONNULL_END
