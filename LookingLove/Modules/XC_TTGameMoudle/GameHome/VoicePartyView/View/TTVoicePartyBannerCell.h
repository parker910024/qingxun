//
//  TTVoicePartyBannerCell.h
//  AFNetworking
//
//  Created by lvjunhang on 2019/6/5.
//  语音派对 banner

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class BannerInfo;
@class TTVoicePartyBannerCell;

@protocol TTVoicePartyBannerCellDelegate<NSObject>

/**
 选中 Banner
 
 @param data 选中的数据源
 */
- (void)didSelectBannerCell:(TTVoicePartyBannerCell *)cell bannerData:(BannerInfo *)data;

@end

///banner 纵横比
extern CGFloat const TTVoicePartyBannerCellBannerAspectRatio;

///底部留白距离
extern CGFloat const TTVoicePartyBannerCellBottomMargin;

@interface TTVoicePartyBannerCell : UICollectionViewCell
@property (nonatomic, strong) NSArray<BannerInfo *> *bannerModelArray;
@property (nonatomic, assign) id<TTVoicePartyBannerCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
