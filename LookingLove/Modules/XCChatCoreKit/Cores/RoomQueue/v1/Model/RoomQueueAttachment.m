//
//  RoomQueueAttachment.m
//  BberryCore
//
//  Created by 卫明何 on 2017/9/11.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "RoomQueueAttachment.h"
#import "NSObject+YYModel.h"

@implementation RoomQueueAttachment

- (NSDictionary *)encodeAttachment {
    NSDictionary *dict = @{
                           @"uid"          :  @(self.uid),
                           @"data"    :  @{@"queueType":@(self.roomQueue.queueType),@"isMute":@(self.roomQueue.isMute)},
                           };
    return dict;
}

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    
    return @{@"uid":@"uid",
             @"roomQueue":@"data"};
}

- (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{
             @"roomQueue" : RoomQueue.class
             };
}




@end
