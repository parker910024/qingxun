//
//  AuctionInfo.m
//  BberryCore
//
//  Created by chenran on 2017/5/27.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "AuctionInfo.h"
#import "NSObject+YYModel.h"
@implementation AuctionInfo
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass
{
    return @{@"rivals" : [AuctionUserInfo class]
             };
}
@end
