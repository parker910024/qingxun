//
//  LittleWolrdMember.m
//  AFNetworking
//
//  Created by fengshuo on 2019/7/4.
//

#import "LittleWolrdMember.h"

@implementation LittleWorldMemberModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    
    return @{@"records": LittleWolrdMember.class,
             };
}

@end


@implementation LittleWolrdMember

@end
