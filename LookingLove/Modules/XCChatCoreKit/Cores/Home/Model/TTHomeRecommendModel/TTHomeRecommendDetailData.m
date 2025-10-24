//
//  TTHomeRecommendDetailData.m
//  AFNetworking
//
//  Created by lvjunhang on 2018/11/13.
//

#import "TTHomeRecommendDetailData.h"

#import <YYModel/YYModel.h>

@interface TTHomeRecommendDetailData ()<YYModel>

@end

@implementation TTHomeRecommendDetailData

+ (NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{@"_id" : @"id"};///Convert id to _id
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"topBannerList" : TTHomeRecommendDetailBannerScroll.class,
             @"panelList" : TTHomeRecommendDetailBannerPanel.class
             };
}

@end

@implementation TTHomeRecommendDetailBannerScroll

@end

@implementation TTHomeRecommendDetailBannerPanel

@end
