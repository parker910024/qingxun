//
//  TTPublicChatroomMessageProvider.m
//  TuTu
//
//  Created by 卫明 on 2018/11/1.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTPublicChatroomMessageProvider.h"

//client
#import "PublicChatroomCoreClient.h"
#import "PublicChatroomMessageClient.h"
#import "TTPublicChatroomMessageProtocol.h"
#import "ImPublicChatroomClient.h"
#import "VersionCore.h"

//core
#import "PublicChatroomCore.h"
#import "PublicChatroomMessageCore.h"
#import "ImPublicChatroomCore.h"

//helper
#import "PublicChatroomMessageHelper.h"
#import "TTPublicChatDataHelper.h"

//model
#import "TTTimestampModel.h"

//refresh
#import "UITableView+Refresh.h"

//nimkit
#import "NIMKit.h"
#import "NIMKitInfoFetchOption.h"

@interface TTPublicChatroomMessageProvider ()
<
PublicChatroomCoreClient,
PublicChatroomMessageClient,
ImPublicChatroomClient
>

@property (nonatomic,assign) NSInteger homePageHistoryCount;

@property (nonatomic,assign) NSTimeInterval lastMessageStamp;

@property (strong, nonatomic) dispatch_queue_t attrQueue;

@end

@implementation TTPublicChatroomMessageProvider
{
    NSTimer *_notifyChannelTextTimer;//用来通知公屏更新
}
+ (instancetype)shareProvider {
    static dispatch_once_t onceToken;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        AddCoreClient(PublicChatroomCoreClient, self);
        AddCoreClient(PublicChatroomMessageClient, self);
        AddCoreClient(ImPublicChatroomClient, self);
        _attrQueue = dispatch_queue_create("com.tutu.attributedString", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)dealloc {
    RemoveCoreClientAll(self);
}

#pragma mark - ImPublicChatroomClient
//进入公聊大厅成功
- (void)onPublicChatRoomSuccess:(NIMChatroom *)chatroom {
    [self.modelMessages removeAllObjects];
    [GetCore(PublicChatroomMessageCore)fetchHistoryMessageByChatroomId:[NSString stringWithFormat:@"%ld",(long)GetCore(ImPublicChatroomCore).publicChatroomId] count:15 startTime:0];
}

#pragma mark - PublicChatroomCoreClient

#pragma mark - PublicChatroomMessageClient
//获取云信历史消息成功
- (void)onFetchHistoryMessageSuccess:(NSArray<NIMMessage *> *)messages startTime:(NSTimeInterval)startTime count:(NSInteger)count {
    messages = messages.reverseObjectEnumerator.allObjects;
    self.lastMessageStamp = messages.firstObject.timestamp;
    for (NIMMessage *message in messages) {
        [self onPublicChatroomMessageUpdate:message];
    }
}

- (void)onPublicChatroomMessageUpdate:(NIMMessage *)message {
//    @weakify(self);
//    dispatch_async(self.attrQueue, ^{
//        @strongify(self);
        if ([message.session.sessionId integerValue] == GetCore(ImPublicChatroomCore).publicChatroomId && message.session.sessionType == NIMSessionTypeChatroom) {
            
            if (GetCore(VersionCore).loadingData) {
                NIMCustomObject *obj = (NIMCustomObject *)message.messageObject;
                if ([obj.attachment isKindOfClass:[Attachment class]]) {
                    Attachment *att = (Attachment *)obj.attachment;
                    if (att.first == Custom_Noti_Header_Red) {
                        return;
                    }
                }
            }
            
            NIMMessageModel *messageModel = [[NIMMessageModel alloc]initWithMessage:message];
            dispatch_main_sync_safe(^{
                [self addMessageAttrToArray:messageModel];
            });
        }
//    });
    
    if (message.messageType == NIMMessageTypeCustom && message.messageObject) {
        NIMCustomObject *customObject = (NIMCustomObject *)message.messageObject;
        if ([message.messageObject isKindOfClass:[NIMCustomObject class]]) {
            //自定义消息附件是Attachment类型且有值
            if (customObject.attachment != nil && [customObject.attachment isKindOfClass:[Attachment class]]) {
                Attachment *att = (Attachment *)customObject.attachment;
                if (att.first == Custom_Noti_Header_PublicChatroom) {
                    if (att.second == Custom_Noti_Sub_PublicChatroom_Send_Private_At) {
                        NIMKitInfoFetchOption *option = [[NIMKitInfoFetchOption alloc] init];
                        option.message = message;
                        NIMKitInfo *userinfo = [[NIMKit sharedKit].provider infoByUser:message.from option:option];
                        NotifyCoreClient(TTPublicChatroomMessageProtocol, @selector(onCurrentPublicChatroomSomeBodyAtYou:), onCurrentPublicChatroomSomeBodyAtYou:userinfo.showName);
                    }
                }
            }
        }
    }
}

#pragma mark - private

- (void)addMessageAttrToArray:(id)message {
    
    BOOL force = NO;
    if (self.modelMessages == nil) {
        self.modelMessages = [NSMutableArray array];
        force = YES;
    }
    
    if (self.modelMessages.count > 50) {
        //            NIMMessage *message = self.messages.firstObject;
        [self.modelMessages removeObjectAtIndex:0];
    }
    [self.modelMessages addObject:message];
    
    [self _notifyReceiveChannelText:force];
    
}

- (void)_notifyReceiveChannelText:(BOOL)forceOrNot{
    
    const static float UPDATE_UI_CHANNEL_TEXT_INTERVAL = 3; //每3s刷新公屏
    if (_notifyChannelTextTimer == nil) {
        _notifyChannelTextTimer = [NSTimer scheduledTimerWithTimeInterval:UPDATE_UI_CHANNEL_TEXT_INTERVAL target:self selector:@selector(onDoNotifyReceiveChannelText:) userInfo:nil repeats:NO];
    }
    
    if (forceOrNot) {
        [_notifyChannelTextTimer fire];
    }
}

- (void)onDoNotifyReceiveChannelText:(NSTimer *)timer{
    
    [_notifyChannelTextTimer invalidate];
    _notifyChannelTextTimer = nil;
    
    NotifyCoreClient(TTPublicChatroomMessageProtocol, @selector(onCurrentPublicChatroomMessageUpdate:), onCurrentPublicChatroomMessageUpdate:self.modelMessages);
}

- (void)handleCustomMessage:(NIMMessage *)message {
    
}

- (void)fetchHistoryMessageByChatroomId:(NSString *)chatroomId
                                  count:(NSInteger)count
                              startTime:(NSTimeInterval)startTime {
    [GetCore(PublicChatroomMessageCore)fetchHistoryMessageByChatroomId:chatroomId count:count startTime:startTime];
}

#pragma mark = getter & setter


- (NSMutableArray *)modelMessages {
    if (!_modelMessages) {
        _modelMessages = [NSMutableArray array];
    }
    return _modelMessages;
}

@end
