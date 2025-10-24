//
//  XCTopicNotiAttachment.h
//  XCChatCoreKit
//
//  Created by zoey on 2019/3/4.
//  Copyright © 2019年 YiZhuan. All rights reserved.
//

#import "P2PInteractiveAttachment.h"
#import "XCCustomAttachmentInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface XCTopicNotiAttachment : P2PInteractiveAttachment<NIMCustomAttachment,XCCustomAttachmentInfo>
@property (nonatomic,strong) NSString                   *createTime;//显示标题
@end

NS_ASSUME_NONNULL_END
