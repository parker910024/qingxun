//
//  MessageCollection.m
//  XCChatCoreKit
//
//  Created by KevinWang on 2019/7/17.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "MessageCollection.h"
#import "HttpRequestHelper.h"
#import "ClientCore.h"
#import "ImRoomCoreV2.h"

static NSString *const messageCollectionUrl = @"https://statistics.wimhe.com";
static NSString *const messageCollectionMethod = @"v1/messageCollection/imMsg";

@interface MessageCollection()

@property (nonatomic, copy) NSDictionary *messageCollectionDict;

@property (nonatomic, assign) int size;
@end

@implementation MessageCollection

- (void)sendMessageCollectionRequestWithMessage:(NIMMessage *)message firstAttachment:(int)firstAttachment {
    
    if (GetCore(ClientCore).reportSwitch) {
        
        int remoteDataLength;
        if (message.remoteExt) {
           NSData *remoteData = [NSJSONSerialization dataWithJSONObject:message.remoteExt options:0 error:nil];
            remoteDataLength = (int)remoteData.length;
        }else {
            remoteDataLength = 0;
        }
        
        int messageTextDataLength;
        if (message.text) {
            NSData *messageTextData = [message.text dataUsingEncoding:NSUTF8StringEncoding];
            messageTextDataLength = (int)messageTextData.length;
        }else {
            messageTextDataLength = 0;
        }
        
        int messageSize = (int)(messageTextDataLength + sizeof(message.messageObject) + remoteDataLength);
        
        self.messageCollectionDict = @{
                                    @"uid":@([message.from intValue]),
                                    @"sessionType":@(message.session.sessionType),
                                    @"sessionId":@([message.session.sessionId intValue]),
                                    @"packetSize":@(messageSize),
                                    @"messageType":@(message.messageType),
                                    @"chatroomMemberNumber":@(GetCore(ImRoomCoreV2).onlineNumber),
                                    @"attachementId":@(firstAttachment)
                                    };
        [self sendMessageCollectionRequest];
    }
}

- (void)messageCollectionRequestByPullQueueWithArray:(NSArray *)array {
    
    if (GetCore(ClientCore).reportSwitch&&array!=nil) {
    
        dispatch_queue_t queue = dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        __weak typeof(self)weakSelf = self;
        dispatch_async(queue, ^{
            weakSelf.size = 0;
            for (NSDictionary *dict in array) {
                NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
                weakSelf.size += (int)data.length;
            }
        
        weakSelf.messageCollectionDict = @{
                                        @"uid":@([GetCore(ImRoomCoreV2).myMember.userId intValue]),
                                        @"sessionType":@(2),
                                        @"sessionId":@([GetCore(ImRoomCoreV2).currentChatRoom.roomId intValue]),
                                        @"packetSize":@(weakSelf.size),
                                        @"messageType":@(100),
                                        @"chatroomMemberNumber":@(GetCore(ImRoomCoreV2).onlineNumber),
                                        @"attachementId":@(0)
                                        };
        [weakSelf sendMessageCollectionRequest];
        });
    }
}

- (void)sendMessageCollectionRequest {
    
//    [HttpRequestHelper POST:messageCollectionUrl method:messageCollectionMethod params:self.messageCollectionDict success:^(id data) {
//
//
//
//    } failure:^(NSNumber *resCode, NSString *message) {
//
//
//
//    }];
}

- (NSDictionary *)messageCollectionDict {
    
    if (!_messageCollectionDict) {
        
        _messageCollectionDict = [NSDictionary dictionary];
    }
    return _messageCollectionDict;
}

@end
