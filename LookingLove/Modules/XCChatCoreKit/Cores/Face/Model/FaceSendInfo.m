//
//  FaceSendInfo.m
//  BberryCore
//
//  Created by 卫明何 on 2017/9/29.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "FaceSendInfo.h"
#import "FaceInfo.h"
#import "FaceReceiveInfo.h"
#import "NSObject+YYModel.h"

@implementation FaceSendInfo


- (NSDictionary *)encodeAttachemt {
    NSDictionary *dict = @{
                           @"data"          :  self.data,
                           @"uid"           :  @(self.uid)
                           };
    return dict;
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{
             @"data"       : [FaceReceiveInfo class],
             };
}


@end
