//
//  XCCheckinNoticeAttachment.h
//  XCChatCoreKit
//
//  Created by lvjunhang on 2019/3/28.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  签到提醒

#import "Attachment.h"
#import "XCCustomAttachmentInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface XCCheckinNoticeAttachment : Attachment<XCCustomAttachmentInfo>
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@end

NS_ASSUME_NONNULL_END
