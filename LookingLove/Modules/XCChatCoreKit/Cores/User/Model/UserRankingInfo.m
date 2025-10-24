//
//  UserRankingInfo.m
//  BberryCore
//
//  Created by Macx on 2018/5/22.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "UserRankingInfo.h"

@implementation UserRankingInfo

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{
             @"dayRankings":UserInfo.class,
             @"weekRankings":UserInfo.class,
             @"totalRankings":UserInfo.class,
             };
}

@end
