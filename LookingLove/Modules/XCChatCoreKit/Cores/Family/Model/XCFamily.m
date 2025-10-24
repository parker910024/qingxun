//
//  XCFamily.m
//  BberryCore
//
//  Created by 卫明何 on 2018/5/24.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "XCFamily.h"

@implementation XCFamily

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{
             @"games" : XCFamilyModel.class,
             @"members" : XCFamilyModel.class,
             @"groups" : XCFamilyModel.class,
             @"recordMonVos" : XCFamilyMoneyModel.class,
             @"weekRecords": XCFamilyModel.class,
             @"familys": XCFamilyModel.class,
             @"panelList": BannerInfo.class,
             @"advList": BannerInfo.class,
             };
}

@end

