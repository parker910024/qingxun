//
//  RoomMagicInfo.m
//  BberryCore
//
//  Created by Mac on 2018/3/16.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "RoomMagicInfo.h"

@implementation RoomMagicInfo
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"targetUsers" : [UserInfo class],
             @"giftValueVos" : [RoomOnMicGiftValueDetail class]
             };
    
}
@end
