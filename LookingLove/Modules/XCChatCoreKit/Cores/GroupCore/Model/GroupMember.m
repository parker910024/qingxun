//
//  GroupMember.m
//  BberryCore
//
//  Created by gzlx on 2018/7/19.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "GroupMember.h"

@implementation GroupMember

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{
             @"memberList" : GroupMemberModel.class,
             };
}
@end
