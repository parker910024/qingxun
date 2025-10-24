//
//  TTRoomLoveModelAttachment.m
//  WanBan
//
//  Created by Lee on 2020/10/22.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import "TTRoomLoveModelAttachment.h"

@implementation TTRoomLoveModelAttachment

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"users" : RoomLoveUser.class};
}

@end
