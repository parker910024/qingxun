//
//  LLPersonalViewCell.h
//  XC_TTPersonalMoudle
//
//  Created by lee on 2019/7/25.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class TTPersonalCellModel;

@interface LLPersonalViewCell : UICollectionViewCell

@property (nonatomic, strong) TTPersonalCellModel *model;

@end

NS_ASSUME_NONNULL_END
