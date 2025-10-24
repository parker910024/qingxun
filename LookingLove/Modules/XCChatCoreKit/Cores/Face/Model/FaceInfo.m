//
//  FaceInfo.m
//  BberryCore
//
//  Created by 卫明何 on 2017/9/29.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "FaceInfo.h"

@implementation FaceInfo

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{
             @"children"       : FaceInfo.class,
             };
}

@end
