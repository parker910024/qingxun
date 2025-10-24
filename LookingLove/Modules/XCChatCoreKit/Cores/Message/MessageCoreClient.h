//
//  MessageCoreClient.h
//  XCChatCoreKit
//
//  Created by lvjunhang on 2019/11/8.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  消息模块core

#import <Foundation/Foundation.h>
#import "DynamicMessage.h"
#import "DynamicMessageUnread.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MessageCoreClient <NSObject>
@optional;

/// 动态消息个数更新通知
- (void)onUpdateDynamicMessageCount:(nullable DynamicMessageUnread *)count;

/// 动态消息列表
- (void)responseMessageDynamicList:(NSArray<DynamicMessage *> *)data code:(NSNumber *)errorCode msg:(NSString *)msg;
@end

NS_ASSUME_NONNULL_END
