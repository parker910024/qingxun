//
//  RoomCategoryData.m
//  XCChatCoreKit
//
//  Created by lvjunhang on 2019/2/20.
//  Copyright © 2019 KevinWang. All rights reserved.
//

#import "RoomCategoryData.h"
#import "TTHomeV4DetailData.h"
#import "BannerInfo.h"

@implementation RoomCategoryData
+ (NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{@"rooms": TTHomeV4DetailData.class,
             @"banner": BannerInfo.class
             };
}

@end
