//
//  DiscoveryMainData.h
//  AFNetworking
//
//  Created by lee on 2019/3/30.
//

#import "BaseObject.h"
#import "DiscoveryHeadLineNews.h"
#import "DiscoverTofuInfo.h"
#import "DiscoveryBannerInfo.h"
#import "XCFamily.h"

NS_ASSUME_NONNULL_BEGIN

@interface DiscoveryMainData : BaseObject
@property (nonatomic, strong) NSArray<DiscoveryHeadLineNews *> *topLineVos;
@property (nonatomic, strong) NSArray<DiscoverTofuInfo *> *banners;
@property (nonatomic, strong) NSArray<DiscoveryBannerInfo *> *bannerVos;
@property (nonatomic, strong) XCFamily *family;
@end

NS_ASSUME_NONNULL_END
