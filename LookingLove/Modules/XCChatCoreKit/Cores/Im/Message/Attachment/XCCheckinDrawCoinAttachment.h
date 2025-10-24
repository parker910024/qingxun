//
//  XCCheckinDrawCoinAttachment.h
//  XCChatCoreKit
//
//  Created by lvjunhang on 2019/3/29.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  签到瓜分金币

#import "Attachment.h"
#import "XCCustomAttachmentInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface XCCheckinDrawCoinAttachment : Attachment<XCCustomAttachmentInfo>
@property (nonatomic, copy) NSString *nick;//昵称
@property (nonatomic, copy) NSString *goldNum;//金币数
@end

NS_ASSUME_NONNULL_END
