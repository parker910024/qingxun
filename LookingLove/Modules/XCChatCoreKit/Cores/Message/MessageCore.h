//
//  MessageCore.h
//  XCChatCoreKit
//
//  Created by lvjunhang on 2019/11/8.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  消息模块core

#import "BaseCore.h"

#import "DynamicMessageUnread.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessageCore : BaseCore

/// 动态消息未读数
@property (nonatomic, strong, nullable) DynamicMessageUnread *unread;

/// 获取一条打招呼消息
/// @param toUid 目标uid
/// @param completion 完成回调
- (void)requestMessageGreetingToUid:(NSString *)toUid completion:(void(^)(NSString * _Nullable greeting, NSNumber * _Nullable code, NSString * _Nullable msg))completion;

/// 请求动态消息未读数
- (void)requestMessageDynamicUnreadCount;

/**
获取互动消息列表
 
 @params dynamicId 小于该id的记录（服务端根据id降序查询），无则表示获取所有未读记录
*/
- (void)requestMessageDynamicListWithId:(NSString *)dynamicId pageSize:(NSInteger)pageSize;

/// 清空互动消息
/// @param completion 完成回调
- (void)requestMessageDynamicClearCompletion:(void(^)(BOOL success, NSNumber * _Nullable code, NSString * _Nullable msg))completion;

@end

NS_ASSUME_NONNULL_END
