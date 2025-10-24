//
//  XCDynamicAuditAttachment.h
//  XCChatCoreKit
//
//  Created by lvjunhang on 2019/11/29.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  动态审核

#import "Attachment.h"
#import "LayoutParams.h"
#import "MessageLayout.h"
#import "MessageParams.h"

NS_ASSUME_NONNULL_BEGIN

@interface XCDynamicAuditAttachment : Attachment<NIMCustomAttachment, XCCustomAttachmentInfo>
@property (nonatomic, strong) MessageLayout *layout;
@end

NS_ASSUME_NONNULL_END
