//
//  HttpRequestHelper+ImFriend.h
//  XCChatCoreKit
//
//  Created by lvjunhang on 2019/12/24.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "HttpRequestHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface HttpRequestHelper (ImFriend)

/// 获取小秘书、系统消息UID
+ (void)requestSecretarySystemUIDsWithCompletion:(HttpRequestHelperCompletion)completion;

@end

NS_ASSUME_NONNULL_END
