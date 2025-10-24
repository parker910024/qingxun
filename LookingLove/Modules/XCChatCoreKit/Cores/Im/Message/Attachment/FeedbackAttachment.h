//
//  FeedbackAttachment.h
//  XCChatCoreKit
//
//  Created by lvjunhang on 2020/5/9.
//  Copyright © 2020 YiZhuan. All rights reserved.
//  举报反馈

#import "Attachment.h"
#import "XCCustomAttachmentInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface FeedbackAttachment : Attachment<XCCustomAttachmentInfo>
@property (nonatomic, assign) NSInteger replyType;//类型 0 -- 举报, 1 -- 反馈
@property (nonatomic, copy) NSString *reply;//回复内容
@property (nonatomic, copy) NSString *msg;//消息第一句
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *erbanNo;//用户id
@property (nonatomic, copy) NSString *nick;//用户昵称
@property (nonatomic, copy) NSString *content;//举报/反馈内容
@property (nonatomic, strong) NSArray *imgList;//图片url

@end

NS_ASSUME_NONNULL_END
