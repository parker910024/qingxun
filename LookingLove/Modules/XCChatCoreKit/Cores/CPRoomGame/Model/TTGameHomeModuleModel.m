//
//  TTGameHomeModuleModel.m
//  XCChatCoreKit
//
//  Created by new on 2019/3/27.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTGameHomeModuleModel.h"
#import "TTHomeV4DetailData.h"

@implementation TTGameHomeModuleModel

+ (NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{@"data": TTHomeV4DetailData.class
             };
}


@end
