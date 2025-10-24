//
//  RequestOrderInfo.m
//  BberryCore
//
//  Created by chenran on 2017/6/12.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "RequestOrderInfo.h"

@implementation RequestOrderInfo
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass
{
    return @{@"orderInfo" : [OrderInfo class]};
}
@end
