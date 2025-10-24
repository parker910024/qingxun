//
//  ImRemoteTransform.m
//  AFNetworking
//
//  Created by 卫明 on 2018/11/14.
//

#import "ImRemoteTransform.h"
#import "Attachment.h"
#import "PublicChatAtMemberAttachment.h"
#import "GiftInfo.h"

#import "NSString+JsonToDic.h"

#import <NIMSDK/NIMSDK.h>

//core
#import "AuthCore.h"

#import <objc/runtime.h>

@implementation ImRemoteTransform

+ (NSArray<NIMMessage *> *)remoteArrToNIMMessages:(NSArray<ImRemoteMessage *> *)messages {
    NSMutableArray *arr = [NSMutableArray array];
    for (ImRemoteMessage *item in messages) {
        [arr addObject:[self remoteTransformToNIMMessage:item]];
    }
    return arr.reverseObjectEnumerator.allObjects;
}

+ (NIMMessage *)remoteTransformToNIMMessage:(ImRemoteMessage *)remoteMessage {
    NIMMessage *message = [[NIMMessage alloc]init];
    NIMSession *session = [NIMSession session:remoteMessage.roomId type:remoteMessage.eventType == ImRemoteMessageEventType_chatroom?NIMSessionTypeChatroom:NIMSessionTypeChatroom];
    [message setValue:remoteMessage.msgidClient forKey:@"messageId"];
    [message setValue:session forKey:@"session"];
    message.timestamp = [remoteMessage.msgTimestamp integerValue] / 1000.0;
    message.from = remoteMessage.fromAccount;
//    if ([message.from integerValue] == [[GetCore(AuthCore) getUid] integerValue]) {
//        [message setValue:@(YES) forKey:@"isOutgoingMsg"];
//    }else {
//        [message setValue:@(NO) forKey:@"isOutgoingMsg"];
//    }
    
    if ([remoteMessage.msgType isEqualToString:@"TEXT"]) {
        message.text = remoteMessage.attach;
    }else if ([remoteMessage.msgType isEqualToString:@"CUSTOM"]) {
        Attachment *att = [Attachment modelWithJSON:remoteMessage.attach];
        NIMCustomObject *customObject = [[NIMCustomObject alloc]init];
        customObject.attachment = att;
        message.messageObject = customObject;
        message.remoteExt = [NSString dictionaryWithJsonString:remoteMessage.fromExt];
    }
    NIMMessageChatroomExtension *ext = [[NIMMessageChatroomExtension alloc]init];
    ext.roomAvatar = remoteMessage.fromAvator;
    ext.roomNickname = remoteMessage.fromNick;
    ext.roomExt = remoteMessage.ext;
    
    message.messageExt = ext;
    
    return message;
}


@end
