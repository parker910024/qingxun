//
//  OnLineNobleInfo.m
//  BberryCore
//
//  Created by Mac on 2018/1/17.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "OnLineNobleInfo.h"

@implementation OnLineNobleInfo

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{
             @"nobleUsers" : SingleNobleInfo.class};
}


@end
