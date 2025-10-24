//
//  UserCar.m
//  BberryCore
//
//  Created by 卫明何 on 2018/2/27.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "UserCar.h"

@implementation UserCar

- (instancetype)init{
    if (self = [super init]) {
        self.expireDate = -1;
    }
    return self;
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"isUsed" : @"using",
             @"carID" : @"id"
             };
}

@end

@implementation UserCarKey


@end
