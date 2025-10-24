//
//  RoomQueueCustomAttachment.m
//  BberryCore
//
//  Created by Mac on 2017/12/19.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "RoomQueueCustomAttachment.h"

@implementation RoomQueueCustomAttachment

- (NSDictionary *)encodeAttachment {
    NSDictionary *dict = @{
                           @"uid"             :  @(self.uid),
                           @"micPosition"     :  @(self.micPosition),
                           @"handleNick"      : self.handleNick,
                           @"targetNick"      : self.targetNick,
                           @"handleUid"       :@(self.handleUid),
                           @"data"    :  @{@"posState":@(self.microState.posState),
                                           @"micState":@(self.microState.micState),
                                           @"position":@(self.microState.position)
                                           },
                           };
    return dict;
}

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    
    return @{@"uid":@"uid",
             @"microState":@"data"};
}

- (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{
             @"microState" : MicroState.class
             };
}

@end
