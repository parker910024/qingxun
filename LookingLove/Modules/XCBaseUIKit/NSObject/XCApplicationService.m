//
//  XCApplicationService.m
//  XCBaseUIKit
//
//  Created by KevinWang on 2018/9/7.
//  Copyright © 2018年 KevinWang. All rights reserved.
//

#import "XCApplicationService.h"

@implementation XCApplicationService

+ (instancetype)defaultService {
    
    static dispatch_once_t onceToken = 0;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}



@end
