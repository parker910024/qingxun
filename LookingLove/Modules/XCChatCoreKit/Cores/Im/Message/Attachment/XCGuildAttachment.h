//
//  XCGuildAttachment.h
//  XCChatCoreKit
//
//  Created by lvjunhang on 2019/1/15.
//  Copyright © 2019 KevinWang. All rights reserved.
//  公会管理 自定义云信消息内容

#import "MessageBussiness.h"

/**
 消息状态

 - XCGuildAttachmentStatusUntreated: 未处理
 - XCGuildAttachmentStatusAgree: 已同意
 - XCGuildAttachmentStatusReject: 已拒绝
 - XCGuildAttachmentStatusExpired: 已过期
 - XCGuildAttachmentStatusProcessed: 已处理
 */
typedef NS_ENUM(NSUInteger, XCGuildAttachmentStatus) {
    XCGuildAttachmentStatusUntreated = 1,
    XCGuildAttachmentStatusAgree = 2,
    XCGuildAttachmentStatusReject = 3,
    XCGuildAttachmentStatusExpired = 4,
    XCGuildAttachmentStatusProcessed = 5,
};

//操作面板固定高度
extern CGFloat const XCGuildAttachmentPanelHeight;

@interface XCGuildAttachment : MessageBussiness
@property (nonatomic, assign) XCGuildAttachmentStatus msgStatus;

#pragma mark - Public Methods
//操作面板高度
- (CGFloat)panelViewHeight;

@end
