//
//  TTGoddessBannerCell.h
//  AFNetworking
//
//  Created by lvjunhang on 2019/6/3.
//  banner 展示

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

///banner 纵横比
extern CGFloat const TTGoddessBannerCellBannerAspectRatio;

@class BannerInfo;
@protocol TTGoddessViewDelegate;

@interface TTGoddessBannerCell : UITableViewCell
@property (nonatomic, assign) id<TTGoddessViewDelegate> delegate;
@property (nonatomic, strong) NSArray<BannerInfo *> *bannerModelArray;

@end

NS_ASSUME_NONNULL_END
