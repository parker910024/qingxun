//
//  PublicChatroomMessageCore.m
//  XCChatCoreKit
//
//  Created by 卫明 on 2018/11/1.
//

#import "PublicChatroomMessageCore.h"

//core
#import "ImPublicChatroomCore.h"

//SDK
#import <NIMSDK/NIMSDK.h>

#import "PublicChatroomMessageClient.h"

//attachment
#import "Attachment.h"

#import "MessageCollection.h"

@interface PublicChatroomMessageCore ()
<
    NIMChatManagerDelegate
>


@end

@implementation PublicChatroomMessageCore

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NIMSDK sharedSDK].chatManager addDelegate:self];
    }
    return self;
}

- (void)dealloc {
    [[NIMSDK sharedSDK].chatManager removeDelegate:self];
}

#pragma mark - NIMChatManagerDelegate

- (void)onRecvMessages:(NSArray<NIMMessage *> *)messages {
    if (messages.count <= 0) {
        return;
    }
    for (NIMMessage *message in messages) {
        //收到的是公聊大厅的消息
        if (message.session.sessionType == NIMSessionTypeChatroom && [message.session.sessionId integerValue] == GetCore(ImPublicChatroomCore).publicChatroomId && (message.messageType == NIMMessageTypeText || message.messageType == NIMMessageTypeCustom)) {
            NotifyCoreClient(PublicChatroomMessageClient, @selector(onPublicChatroomMessageUpdate:), onPublicChatroomMessageUpdate:message);
        }
        
        if (message.messageType == NIMMessageTypeCustom) {
            NIMCustomObject *obj = (NIMCustomObject *)message.messageObject;
            if (obj.attachment && [obj.attachment isKindOfClass:[Attachment class]]) {
                Attachment *attachment = (Attachment *)obj.attachment;
                if (attachment.first == Custom_Noti_Header_PublicChatroom) {
                    if (attachment.second == Custom_Noti_Sub_PublicChatroom_Send_Gift) {
                        GiftAllMicroSendInfo *info = [GiftAllMicroSendInfo yy_modelWithDictionary:attachment.data];
                        NotifyCoreClient(PublicChatroomMessageClient, @selector(onReceiveGiftInPublicChatRoom:), onReceiveGiftInPublicChatRoom:info);
                    }else if (attachment.second == Custom_Noti_Sub_PublicChatroom_Send_Private_At){
                        NotifyCoreClient(PublicChatroomMessageClient, @selector(onPublicChatroomMessageUpdate:), onPublicChatroomMessageUpdate:message);
                    }
                }
            }
        }
    }
}

- (void)willSendMessage:(NIMMessage *)message {
    if ([message.session.sessionId integerValue] == GetCore(ImPublicChatroomCore).publicChatroomId) {
        
        NotifyCoreClient(PublicChatroomMessageClient, @selector(onPublicChatroomMessageUpdate:), onPublicChatroomMessageUpdate:message);
        
        if (message.messageType == NIMMessageTypeCustom) {
            NIMCustomObject *obj = (NIMCustomObject *)message.messageObject;
            if (obj.attachment && [obj.attachment isKindOfClass:[Attachment class]]) {
                Attachment *attachment = (Attachment *)obj.attachment;
                if (attachment.first == Custom_Noti_Header_PublicChatroom) {
                    if (attachment.second == Custom_Noti_Sub_PublicChatroom_Send_Gift) {
                        GiftAllMicroSendInfo *info = [GiftAllMicroSendInfo yy_modelWithDictionary:attachment.data];
                        NotifyCoreClient(PublicChatroomMessageClient, @selector(onReceiveGiftInPublicChatRoom:), onReceiveGiftInPublicChatRoom:info);
                    }
                }
            }
        }
    }
}

- (void)sendMessage:(NIMMessage *)message didCompleteWithError:(NSError *)error {
    NSLog(@"%@",error);
}

#pragma mark - private method

- (void)fetchHistoryMessageByChatroomId:(NSString *)chatroomId count:(NSInteger)count startTime:(NSTimeInterval)startTime {
    NIMHistoryMessageSearchOption *option = [[NIMHistoryMessageSearchOption alloc]init];
    option.limit = count;
    option.startTime = startTime;
    option.order = NIMMessageSearchOrderDesc;
    option.messageTypes = @[@(NIMMessageTypeText),@(NIMMessageTypeCustom)];
    [[NIMSDK sharedSDK].chatroomManager fetchMessageHistory:chatroomId option:option result:^(NSError * _Nullable error, NSArray<NIMMessage *> * _Nullable messages) {
        NotifyCoreClient(PublicChatroomMessageClient, @selector(onFetchHistoryMessageSuccess:startTime:count:), onFetchHistoryMessageSuccess:messages startTime:startTime count:count);
    }];
}

@end
