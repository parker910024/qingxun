//
//  TTGameRecordCollectionViewCell.h
//  TTPlay
//
//  Created by new on 2019/3/20.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPGameListModel.h"
#import "TTMineGameListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TTGameRecordCollectionViewCell : UICollectionViewCell

- (void)configModel:(TTMineGameListModel *)model;

@end

NS_ASSUME_NONNULL_END
