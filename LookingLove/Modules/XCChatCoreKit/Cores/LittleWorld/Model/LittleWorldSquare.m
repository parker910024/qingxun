//
//  LittleWorldSquare.m
//  XCChatCoreKit
//
//  Created by lvjunhang on 2019/7/4.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "LittleWorldSquare.h"

@implementation LittleWorldSquare

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    
    return @{@"banners": BannerInfo.class,
             @"types": LittleWorldSquareClassify.class
             };
}

@end

@implementation LittleWorldSquareClassify

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"typeId": @"id"};
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    
    return @{@"worlds": LittleWorldListItem.class,
             };
}
@end
