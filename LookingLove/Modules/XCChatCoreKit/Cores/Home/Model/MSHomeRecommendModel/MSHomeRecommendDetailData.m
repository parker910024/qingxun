//
//  MSHomeRecommendDetailData.m
//  AFNetworking
//
//  Created by lvjunhang on 2018/12/21.
//

#import "MSHomeRecommendDetailData.h"

@implementation MSHomeRecommendDetailData
+ (NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{@"_id" : @"id"};///Convert id to _id
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"topBannerList" : MSHomeRecommendDetailBannerScroll.class,
             @"panelList" : MSHomeRecommendDetailBannerPanel.class
             };
}

@end

@implementation MSHomeRecommendDetailBannerScroll

@end

@implementation MSHomeRecommendDetailBannerPanel

@end
