//
//  ActivityContainInfo.m
//  AFNetworking
//
//  Created by User on 2019/5/7.
//

#import "ActivityContainInfo.h"

@implementation ActivityContainInfo

+ (NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{@"list": ActivityInfo.class
             };
}

@end
