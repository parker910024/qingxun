//
//  TTDiscoverHeadBannerCell.h
//  TTPlay
//
//  Created by lee on 2019/3/29.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class DiscoveryBannerInfo;

@protocol TTDiscoverHeadBannerCellDelegate <NSObject>

- (void)onBannerCellClickHandler:(DiscoveryBannerInfo *)info;

@end

@interface TTDiscoverHeadBannerCell : UICollectionViewCell
@property (nonatomic, strong) NSArray<DiscoveryBannerInfo *> *headBannerArray;
@property (nonatomic, weak) id<TTDiscoverHeadBannerCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
