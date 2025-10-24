//
//  XCRedAuthorityAttachment.h
//  XCChatCoreKit
//
//  Created by lvjunhang on 2020/7/27.
//  Copyright © 2020 YiZhuan. All rights reserved.
//  红包权限认证

#import "Attachment.h"

NS_ASSUME_NONNULL_BEGIN

@interface XCRedAuthorityAttachment : Attachment
/// 是否隐藏红包
@property (nonatomic, assign) BOOL hideRedPacket;
@end

NS_ASSUME_NONNULL_END
