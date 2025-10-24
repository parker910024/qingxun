//
//  UserHeadWear.m
//  BberryCore
//
//  Created by Macx on 2018/5/11.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "UserHeadWear.h"

@implementation UserHeadWear


+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"isUsed" : @"used"
             };
}

- (CGFloat)frameDurations {
    return self.timeInterval/1000.0;
}
@end
