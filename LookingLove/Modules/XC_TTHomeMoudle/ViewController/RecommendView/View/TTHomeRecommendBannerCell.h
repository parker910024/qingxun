//
//  TTHomeRecommendBannerCell.h
//  TTPlay
//
//  Created by lvjunhang on 2019/2/18.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

///banner 纵横比
extern CGFloat const TTHomeRecommendBannerCellBannerAspectRatio;

@class TTHomeV4DetailData, BannerInfo;
@protocol PDHomeRecommendCellDelegate;

@interface TTHomeRecommendBannerCell : UITableViewCell

///这两个数据源，二选一
@property (nonatomic, strong, nullable) NSArray<TTHomeV4DetailData *> *dataModelArray;
@property (nonatomic, strong, nullable) NSArray<BannerInfo *> *bannerModelArray;

@property (nonatomic, assign) id<PDHomeRecommendCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
