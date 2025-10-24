//
//  TTWorldSquareBannerCell.h
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2019/6/28.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  世界广场 banner

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class BannerInfo;
@class TTWorldSquareBannerCell;

@protocol TTWorldSquareBannerCellDelegate<NSObject>

/**
 选中 Banner
 
 @param data 选中的数据源
 */
- (void)didSelectBannerCell:(TTWorldSquareBannerCell *)cell bannerData:(BannerInfo *)data;

@end

///banner 纵横比
extern CGFloat const TTWorldSquareBannerCellBannerAspectRatio;

///顶部留白距离
extern CGFloat const TTWorldSquareBannerCellTopMargin;

///底部留白距离
extern CGFloat const TTWorldSquareBannerCellBottomMargin;

@interface TTWorldSquareBannerCell : UICollectionViewCell
@property (nonatomic, strong) NSArray<BannerInfo *> *bannerModelArray;
@property (nonatomic, assign) id<TTWorldSquareBannerCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
