//
//  TTMineGameApproveCell.h
//  TTPlay
//
//  Created by new on 2019/3/26.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CertificationModel.h"

@protocol TTMineGameApproveCellDelegate <NSObject>

- (void)editBtnClickAction:(CertificationModel *)model;

@end

NS_ASSUME_NONNULL_BEGIN

static NSString *const kMineGameApproveCellConst = @"kMineGameApproveCellConst";

@interface TTMineGameApproveCell : UITableViewCell

@property (nonatomic, assign) UserID userID;

@property (nonatomic, strong) CertificationModel *model;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, weak) id<TTMineGameApproveCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
