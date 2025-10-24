//
//  TTGameListCollectionViewCell.h
//  TuTu
//
//  Created by new on 2019/1/21.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPGameListModel.h"
#import "CPGameHomeBannerModel.h"

@protocol TTGameListCollectionViewCellDelegate <NSObject>

- (void)moreGameBtnClickAction;

@end

NS_ASSUME_NONNULL_BEGIN

@interface TTGameListCollectionViewCell : UICollectionViewCell

- (void)configData:(NSArray *)array WithIndexPath:(NSInteger )row;

- (void)configWelfDataModel:(CPGameHomeBannerModel *)model;

- (void)configCompleteGameData:(NSArray *)array WithIndexPath:(NSInteger )row;

@property (nonatomic, weak) id<TTGameListCollectionViewCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
