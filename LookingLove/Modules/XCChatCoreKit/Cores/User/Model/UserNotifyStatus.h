//
//  UserNotifyStatus.h
//  XCChatCoreKit
//
//  Created by lvjunhang on 2020/3/16.
//  Copyright © 2020 YiZhuan. All rights reserved.
//  用户消息通知状态（设置-消息通知）

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserNotifyStatus : BaseObject
@property (nonatomic, assign) BOOL sysMsgNotify;//系统消息通知
@property (nonatomic, assign) BOOL interactiveMsgNotify;//互动消息通知
@end

NS_ASSUME_NONNULL_END
