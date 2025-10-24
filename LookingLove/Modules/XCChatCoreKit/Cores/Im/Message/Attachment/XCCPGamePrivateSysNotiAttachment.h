//
//  XCCPGamePrivateSysNotiAttachment.h
//  XCChatCoreKit
//
//  Created by new on 2019/2/19.
//  Copyright © 2019 KevinWang. All rights reserved.
//

#import "Attachment.h"
#import "XCCustomAttachmentInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface XCCPGamePrivateSysNotiAttachment : Attachment<NIMCustomAttachment,XCCustomAttachmentInfo>

@property (nonatomic, strong) NSString *msg;

@end

NS_ASSUME_NONNULL_END
