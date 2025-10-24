//
//  ArrangeMicModel.m
//  XCChatCoreKit
//
//  Created by gzlx on 2018/12/13.
//  Copyright © 2018年 KevinWang. All rights reserved.
//

#import "ArrangeMicModel.h"

@implementation ArrangeMicModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{
             @"queue":UserInfo.class,
             };
}


@end
