//
//  TTPublicChatroomMessageDataProvider.m
//  TuTu
//
//  Created by 卫明 on 2018/11/12.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTPublicChatroomMessageDataProvider.h"
#import "Attachment.h"
#import "VersionCore.h"

@interface TTPublicChatroomMessageDataProvider ()

@property (nonatomic,copy) NSString *roomId;

@end

@implementation TTPublicChatroomMessageDataProvider

- (instancetype)initWithChatroom:(NSString *)roomId {
    self = [super init];
    if (self)
    {
        _roomId = roomId;
    }
    return self;
}

- (void)pullDown:(NIMMessage *)firstMessage handler:(NIMKitDataProvideHandler)handler {
    NIMHistoryMessageSearchOption *option = [[NIMHistoryMessageSearchOption alloc]init];
    option.startTime = firstMessage.timestamp;
    option.limit = 10;
    option.messageTypes = @[@(NIMMessageTypeText),@(NIMMessageTypeCustom)];
    [[NIMSDK sharedSDK].chatroomManager fetchMessageHistory:self.roomId option:option result:^(NSError * _Nullable error, NSArray<NIMMessage *> * _Nullable messages) {
        NSMutableArray *dataArray = [NSMutableArray arrayWithArray:messages];
        for (int i = 0; i < dataArray.count; i++) {
            NIMMessage *message = dataArray[i];
            NIMCustomObject *obj = (NIMCustomObject *)message.messageObject;
            Attachment *attachment = (Attachment *)obj.attachment;
            if (attachment.first == Custom_Noti_Header_CPGAME_PublicChat_Respond) {
                [dataArray removeObject:message];
                i--;
            }
            if (attachment.first == Custom_Noti_Header_CPGAME_PrivateChat_SystemNotification) {
                if (attachment.second == Custom_Noti_Sub_CPGAME_PrivateChat_SysNoti_CancelGame) {
                    [dataArray removeObject:message];
                    i--;
                }
            }
            
            if (GetCore(VersionCore).loadingData) {
                if (attachment.first == Custom_Noti_Header_Red) {
                    [dataArray removeObject:message];
                    i--;
                }
            }
        }
        handler(error,dataArray.reverseObjectEnumerator.allObjects);
    }];
}

@end
