//
//  TTGameFocusTableViewCell.h
//  TTPlay
//
//  Created by new on 2019/3/25.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Attention.h"

@protocol TTGameFocusTableViewCellDelegate <NSObject>

- (void)focusListClieckWithFindFriend;
- (void)focusListClieckWithAttentionModel:(Attention *)model;
- (void)focusListMoreClickWithAttention;

@end

NS_ASSUME_NONNULL_BEGIN

@interface TTGameFocusTableViewCell : UITableViewCell

@property (nonatomic, strong) NSMutableArray<Attention *> *focusArray; // 关注的人。数据源
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, weak) id<TTGameFocusTableViewCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
