//
//  XCRoomGiftValueSyncAttachment.h
//  XCChatCoreKit
//
//  Created by lvjunhang on 2019/4/30.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  房间礼物值同步

#import "Attachment.h"
#import "RoomOnMicGiftValue.h"

NS_ASSUME_NONNULL_BEGIN

@interface XCRoomGiftValueSyncAttachment : Attachment
@property (nonatomic, copy) NSString *currentTime;//系统时间戳
@property (nonatomic, strong) NSArray<RoomOnMicGiftValueDetail *> *giftValueVos;
@end

NS_ASSUME_NONNULL_END
