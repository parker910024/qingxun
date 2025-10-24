//
//  TTHomeV4Data.m
//  AFNetworking
//
//  Created by lvjunhang on 2019/2/15.
//

#import "TTHomeV4Data.h"
#import "TTHomeV4DetailData.h"

@implementation TTHomeV4Data
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"data" : TTHomeV4DetailData.class,
             };
}
@end
