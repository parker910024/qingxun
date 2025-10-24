//
//  VoiceBottlePiaModel.m
//  XCChatCoreKit
//
//  Created by fengshuo on 2019/6/5.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "VoiceBottlePiaModel.h"

@implementation VoiceBottlePiaModel

+ (NSDictionary *)modelCustomPropertyMapper {
    // 将pId映射到key为id的数据字段
    return @{@"pid":@"id"};
}

@end
