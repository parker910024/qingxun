//
//  SecretarySystemUIDs.h
//  XCChatCoreKit
//
//  Created by lvjunhang on 2019/12/25.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  小秘书、系统消息UID

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface SecretarySystemUIDs : BaseObject
@property (nonatomic, copy) NSString *secretaryUid;//小秘书发送方uid
@property (nonatomic, copy) NSString *systemMessageUid;//系统消息发送方uid
@end

NS_ASSUME_NONNULL_END
