//
//  TTGameListTableViewCell.h
//  TuTu
//
//  Created by new on 2019/1/17.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol TTGameListTableViewCellDelegate <NSObject>

- (void)itemClickWithIndex:(NSInteger )index WithSection:(NSInteger )section;

- (void)moreGameBtnClickActionBackMainPageDeal;

@end

NS_ASSUME_NONNULL_BEGIN

@interface TTGameListTableViewCell : UITableViewCell

@property (nonatomic, assign) NSInteger section;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *welfDataArray; // 声控福利房  数据源
@property (nonatomic, weak) id<TTGameListTableViewCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
