//
//  HomeV5Category.m
//  XCChatCoreKit
//
//  Created by lvjunhang on 2019/6/5.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  

#import "HomeV5Category.h"

@implementation HomeV5CategoryDetailListItem

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"cid" : @"id"};
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [self yy_modelEncodeWithCoder:coder];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder {
    return [self yy_modelInitWithCoder:coder];
}

@end

@implementation HomeV5CategoryDetail
+ (NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{@"opts": HomeV5CategoryDetailListItem.class,
             };
}
@end

@implementation HomeV5Category
+ (NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{@"firstPageBannerVos": BannerInfo.class,
             @"allVo": HomeV5CategoryDetail.class,
             @"topBanners": BannerInfo.class
             };
}
@end
