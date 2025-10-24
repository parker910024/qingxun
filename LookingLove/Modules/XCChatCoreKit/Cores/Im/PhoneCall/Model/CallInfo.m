//
//  CallInfo.m
//  BberryCore
//
//  Created by 卫明何 on 2017/9/13.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "CallInfo.h"

@implementation CallInfo

- (NSDictionary *)encodeAttchment {
    NSDictionary *dict = @{
                           @"nick": self.nick,
                           @"uid":@(self.uid)};
    return dict;
}

@end
