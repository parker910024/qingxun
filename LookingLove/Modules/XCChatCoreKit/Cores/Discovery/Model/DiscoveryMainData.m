//
//  DiscoveryMainData.m
//  AFNetworking
//
//  Created by lee on 2019/3/30.
//

#import "DiscoveryMainData.h"

@implementation DiscoveryMainData

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"bannerVos" : DiscoveryBannerInfo.class,
             @"banners" : DiscoverTofuInfo.class,
             @"topLineVos" : DiscoveryHeadLineNews.class};
}
@end
