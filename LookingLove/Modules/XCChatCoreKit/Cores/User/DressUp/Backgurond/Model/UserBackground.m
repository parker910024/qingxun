//
//  UserBackground.m
//  BberryCore
//
//  Created by Macx on 2018/6/20.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "UserBackground.h"

@implementation UserBackground



+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"backgroundId" : @"id",
             @"isUsed" : @"used"
             };
}

@end
