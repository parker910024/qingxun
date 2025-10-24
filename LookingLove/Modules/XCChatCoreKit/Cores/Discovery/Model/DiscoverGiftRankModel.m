//
//  DiscoverGiftRankModel.m
//  XCChatCoreKit
//
//  Created by gzlx on 2018/8/29.
//  Copyright © 2018年 KevinWang. All rights reserved.
//

#import "DiscoverGiftRankModel.h"


@implementation DiscoverGiftRankModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{
             @"stars":DiscoverStarModel.class,
             };
}

@end
