//
//  XCLittleWorldAutoQuitAttachment.h
//  XCChatCoreKit
//
//  Created by Lee on 2019/10/31.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "Attachment.h"
#import "XCCustomAttachmentInfo.h"
#import "MessageLayout.h"
#import "MessageParams.h"

NS_ASSUME_NONNULL_BEGIN

@interface XCLittleWorldAutoQuitAttachment : Attachment<NIMCustomAttachment,XCCustomAttachmentInfo>

@property (nonatomic, strong) MessageLayout *layout;
@property (nonatomic, strong) MessageParams *parrms;

@end

NS_ASSUME_NONNULL_END
