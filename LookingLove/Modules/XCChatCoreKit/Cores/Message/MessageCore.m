//
//  MessageCore.m
//  XCChatCoreKit
//
//  Created by lvjunhang on 2019/11/8.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "MessageCore.h"

#import "HttpRequestHelper+MessageCore.h"

#import "AuthCore.h"
#import "MessageCoreClient.h"
#import "NotificationCoreClient.h"
#import "ImLoginCoreClient.h"

#import "Attachment.h"

@interface MessageCore ()<NotificationCoreClient, ImLoginCoreClient>

@end

@implementation MessageCore

#pragma mark - Life Cycle
- (void)dealloc {
    RemoveCoreClientAll(self);
}

- (instancetype)init {
    self = [super init];
    if (self) {
        AddCoreClient(NotificationCoreClient, self);
        AddCoreClient(ImLoginCoreClient, self);
    }
    return self;
}

#pragma mark - ImLoginCoreClient
- (void)onImLogoutSuccess {
    //退出登录清空当前用户的动态未读数
    self.unread = nil;
}

#pragma mark - NotificationCoreClient
- (void)onRecvCustomP2PNoti:(NIMCustomSystemNotification *)notification {
    
    if (notification.content == nil || notification.content.length == 0) {
        return;
    }
    
    Attachment *attachment = [Attachment modelWithJSON:notification.content];
    if ([attachment isKindOfClass:Attachment.class] ||
        attachment.first == Custom_Noti_Header_Dynamic ||
        attachment.second == Custom_Noti_Sub_Dynamic_Unread_Update) {
        
        //动态消息个数更新通知
        DynamicMessageUnread *unread = [DynamicMessageUnread modelWithJSON:attachment.data];
        if ([unread isKindOfClass:DynamicMessageUnread.class]) {
            
            self.unread = unread;
            NotifyCoreClient(MessageCoreClient, @selector(onUpdateDynamicMessageCount:), onUpdateDynamicMessageCount:self.unread);
        }
    }
}

#pragma mark - Request
/// 获取一条打招呼消息
/// @param toUid 目标uid
/// @param completion 完成回调
- (void)requestMessageGreetingToUid:(NSString *)toUid completion:(void(^)(NSString * _Nullable greeting, NSNumber * _Nullable code, NSString * _Nullable msg))completion {
    
    NSDictionary *params = @{@"toUid": toUid,
                             @"uid": GetCore(AuthCore).getUid ?: @""};
    
    [HttpRequestHelper request:@"/greet/msg/getOne"
                        method:HttpRequestHelperMethodPOST
                        params:params
                    completion:^(id data, NSNumber *code, NSString *msg) {
        
        NSString *greeting = nil;
        if ([data isKindOfClass:NSString.class]) {
            greeting = data;
        }
        
        !completion ?: completion(greeting, code, msg);
    }];
}

/// 请求动态消息未读数
- (void)requestMessageDynamicUnreadCount {
    
    //未登陆不请求
    if (![GetCore(AuthCore) isLogin]) {
        return;
    }
    
     NSDictionary *params = @{@"uid": GetCore(AuthCore).getUid ?: @""};
        
     [HttpRequestHelper request:@"interactive/unreadCount"
                         method:HttpRequestHelperMethodPOST
                         params:params
                     completion:^(id data, NSNumber *code, NSString *msg) {
           
           BOOL errOccur = code != nil || msg != nil;
           DynamicMessageUnread *model = nil;
           if (!errOccur) {
               model = [DynamicMessageUnread modelWithJSON:data];
           }
           
           self.unread = model;
           
           NotifyCoreClient(MessageCoreClient, @selector(onUpdateDynamicMessageCount:), onUpdateDynamicMessageCount:model);
       }];
    }

/**
获取互动消息列表
*/
- (void)requestMessageDynamicListWithId:(NSString *)dynamicId pageSize:(NSInteger)pageSize {
    
    [HttpRequestHelper requestMessageDynamicListWithId:dynamicId pageSize:pageSize completion:^(id data, NSNumber *code, NSString *msg) {
        
        NSArray *list = [NSArray yy_modelArrayWithClass:[DynamicMessage class] json:data];
        NotifyCoreClient(MessageCoreClient, @selector(responseMessageDynamicList:code:msg:), responseMessageDynamicList:list code:code msg:msg);
    }];
}

/// 清空互动消息
/// @param completion 完成回调
- (void)requestMessageDynamicClearCompletion:(void(^)(BOOL success, NSNumber * _Nullable code, NSString * _Nullable msg))completion {
    
    NSDictionary *params = @{@"uid": GetCore(AuthCore).getUid ?: @""};
       
       [HttpRequestHelper request:@"interactive/clear"
                           method:HttpRequestHelperMethodPOST
                           params:params
                       completion:^(id data, NSNumber *code, NSString *msg) {
           
           !completion ?: completion(code==nil, code, msg);
       }];
}

#pragma mark - Lazy Load
- (DynamicMessageUnread *)unread {
    if (_unread) {
        return _unread;
    }
    
    //未初始化时请求数据
    [self requestMessageDynamicUnreadCount];
    
    return nil;
}

@end
