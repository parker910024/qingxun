//
//  TTGameRecordTableViewCell.h
//  TTPlay
//
//  Created by new on 2019/3/20.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *const kMineGameRecordCellConst = @"kMineGameRecordCellConst";

@interface TTMineGameRecordCell : UITableViewCell

@property (nonatomic, strong) NSMutableArray *recordArray;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

NS_ASSUME_NONNULL_END
