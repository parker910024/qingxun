//
//  XCFamilyMoneyModel.m
//  BberryCore
//
//  Created by gzlx on 2018/6/4.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "XCFamilyMoneyModel.h"

@implementation XCFamilyMoneyModel


+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{
             @"list" : XCFamilyModel.class
             };
}

@end

