//
//  XCRoomGiftValueSyncAttachment.m
//  XCChatCoreKit
//
//  Created by lvjunhang on 2019/4/30.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "XCRoomGiftValueSyncAttachment.h"

@implementation XCRoomGiftValueSyncAttachment

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{@"giftValueVos": RoomOnMicGiftValueDetail.class};
}
@end
