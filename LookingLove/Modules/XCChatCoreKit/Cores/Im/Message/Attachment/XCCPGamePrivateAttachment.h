//
//  XCCPGamePrivateAttachment.h
//  XCChatCoreKit
//
//  Created by new on 2019/2/15.
//  Copyright © 2019 KevinWang. All rights reserved.
//

#import "Attachment.h"
#import "P2PInteractiveAttachment.h"
NS_ASSUME_NONNULL_BEGIN

@interface XCCPGamePrivateAttachment : Attachment<NIMCustomAttachment,XCCustomAttachmentInfo>

@property (nonatomic, strong) NSString * title;

@end

NS_ASSUME_NONNULL_END
