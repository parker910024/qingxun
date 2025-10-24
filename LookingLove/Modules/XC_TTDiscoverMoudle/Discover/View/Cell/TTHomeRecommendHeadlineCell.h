//
//  TTHomeRecommendHeadlineCell.h
//  TuTu
//
//  Created by lvjunhang on 2018/10/30.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TTHomeRecommendData, TTHomeRecommendDetailData, DiscoveryHeadLineNews;
@protocol TTHomeRecommendCellDelegate;

@protocol TTHomeRecommendHeadlineCellDelegate <NSObject>

// 点击cell上的cell的方法传递出来
- (void)onCellDidSelectLineNewsCellAction;

@end

@interface TTHomeRecommendHeadlineCell : UICollectionViewCell
@property (nonatomic, strong) TTHomeRecommendData *dataModel;
@property (nonatomic, assign) id<TTHomeRecommendHeadlineCellDelegate> delegate;
@property (nonatomic, strong) NSArray<DiscoveryHeadLineNews *> *lineNews;
@end

NS_ASSUME_NONNULL_END
