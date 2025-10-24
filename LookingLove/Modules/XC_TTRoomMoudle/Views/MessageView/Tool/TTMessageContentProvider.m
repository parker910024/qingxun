//
//  TTMessageContentProvider.m
//  TTPlay
//
//  Created by 卫明 on 2019/3/7.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTMessageContentProvider.h"

//core
#import "ImMessageCore.h"
#import "ImRoomCoreV2.h"
#import "XCRoomSuperAdminAttachment.h"
//client
#import "RoomMessageClient.h"
#import "RoomCoreClient.h"
#import "ImRoomCoreClientV2.h"

//tool
#import "TTDisplayModelMaker.h"
#import "XCMacros.h"
#import "GCDHelper.h"


#define MessageLimit 1000

@interface TTMessageContentProvider ()
<
    RoomMessageClient,
    ImRoomCoreClientV2
>

@property (strong, nonatomic) NSTimer *notifyChannelTextTimer;//用来通知公屏更新

@end

@implementation TTMessageContentProvider
{
    dispatch_queue_t attQueue;
}

+ (instancetype)shareProvider {
    static dispatch_once_t onceToken;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        AddCoreClient(RoomMessageClient, self);
        AddCoreClient(ImRoomCoreClientV2, self);
        attQueue = dispatch_queue_create("com.tt.room.message.attr", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)dealloc {
    RemoveCoreClientAll(self);
}

#pragma mark - Private method

- (void) _notifyReceiveChannelText:(BOOL)forceOrNot{
    @KWeakify(self);
    dispatch_main_sync_safe(^{
        @KStrongify(self);
        const static float UPDATE_UI_CHANNEL_TEXT_INTERVAL = 0.5; //每0.5s刷新公屏
        if (self.notifyChannelTextTimer == nil) {
            self.notifyChannelTextTimer = [NSTimer scheduledTimerWithTimeInterval:UPDATE_UI_CHANNEL_TEXT_INTERVAL target:self selector:@selector(onDoNotifyReceiveChannelText:) userInfo:nil repeats:NO];
        }
        
        if (forceOrNot) {
            [self.notifyChannelTextTimer fire];
        }
    });
    
}

- (void) onDoNotifyReceiveChannelText:(NSTimer *)timer{
    
    [_notifyChannelTextTimer invalidate];
    _notifyChannelTextTimer = nil;
    if (GetCore(ImRoomCoreV2).currentRoomInfo.isCloseScreen) {
        [self.messages removeAllObjects];
        
        [self.messages addObject:[self makeCloseScreenModel]];
    }
    @KWeakify(self);
    dispatch_main_sync_safe(^{
        @KStrongify(self);
        NotifyCoreClient(RoomCoreClient, @selector(onCurrentRoomMsgUpdate:), onCurrentRoomMsgUpdate:self.messages);
    });
}

#pragma mark - Close Screen

- (TTMessageDisplayModel *)makeCloseScreenModel {
    TTMessageDisplayModel *model = [[TTMessageDisplayModel alloc]init];
    //是超管关闭的公屏的话
    if (GetCore(RoomCoreV2).getCurrentRoomInfo.closeScreenFlag == 1) {
        XCRoomSuperAdminAttachment *attachement = [[XCRoomSuperAdminAttachment alloc]init];
        attachement.first = Custom_Noti_Header_Room_SuperAdmin;
        attachement.second = Custom_Noti_Sub_Room_SuperAdmin_CloseChat;
        NIMMessage *closeMessage = [[NIMMessage alloc]init];
        NIMCustomObject *customObject = [[NIMCustomObject alloc]init];
        customObject.attachment = attachement;
        closeMessage.messageObject = customObject;
        NSString *sessionID = [NSString stringWithFormat:@"%ld",GetCore(ImRoomCoreV2).currentRoomInfo.roomId];
        NIMSession *session = [NIMSession session:sessionID type:NIMSessionTypeChatroom];
        [closeMessage setValue:session forKey:@"session"];
        model.message = closeMessage;
        model = [[TTDisplayModelMaker shareMaker]makeMessageDisplayModelWithMessage:closeMessage];
    }else {
        Attachment *attachement = [[Attachment alloc]init];
        attachement.first = Custom_Noti_Header_Update_RoomInfo;
        attachement.second = Custom_Noti_Sub_Update_RoomInfo_MessageState;
        NIMMessage *closeMessage = [[NIMMessage alloc]init];
        NIMCustomObject *customObject = [[NIMCustomObject alloc]init];
        customObject.attachment = attachement;
        closeMessage.messageObject = customObject;
        NSString *sessionID = [NSString stringWithFormat:@"%ld",GetCore(ImRoomCoreV2).currentRoomInfo.roomId];
        NIMSession *session = [NIMSession session:sessionID type:NIMSessionTypeChatroom];
        [closeMessage setValue:session forKey:@"session"];
        model.message = closeMessage;
        model = [[TTDisplayModelMaker shareMaker]makeMessageDisplayModelWithMessage:closeMessage];
    }
    return model;
}

#pragma mark - ImRoomCoreClientV2

- (void)onMeExitChatRoomSuccessV2 {
    self.messages = nil;
}

#pragma mark - RoomMessageClient

- (void)onReceiveMessageNeedDisplayOnScreen:(NIMMessage *)message {
    
    if ([message.messageObject isKindOfClass:[NIMCustomObject class]]) {
        
        NIMCustomObject *obj = (NIMCustomObject *)message.messageObject;
        Attachment *attachment = (Attachment *)obj.attachment;
        
        //超管关注房主不显示公屏通知
        if (attachment.first == Custom_Noti_Header_Room_Tip &&
            attachment.second == Custom_Noti_Header_Room_Tip_Attentent_Owner) {
            
            UserID uid = [attachment.data[@"uid"] longLongValue];
            UserInfo *userInfo = [GetCore(UserCore) getUserInfoInDB:uid];
            if (userInfo.platformRole == XCUserInfoPlatformRoleSuperAdmin) {
                return;
            }
        }
    }
    
    BOOL force = NO;
    if (self.messages == nil) {
        self.messages = [NSMutableArray array];
        force = YES;
    }
    if (self.messages.count > MessageLimit) {
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, MessageLimit/2)];
        NSArray *needRemoveMsgArray = [self.messages objectsAtIndexes:set];
        
        NotifyCoreClient(RoomCoreClient, @selector(onMessageDidRemoveFromCache:), onMessageDidRemoveFromCache:needRemoveMsgArray);
        [self.messages removeObjectsInArray:needRemoveMsgArray];
    }
    
    @KWeakify(self);
    dispatch_async(attQueue, ^{
        @KStrongify(self);
        [self.messages addObject:[[TTDisplayModelMaker shareMaker] makeMessageDisplayModelWithMessage:message]];
        
        
        [self _notifyReceiveChannelText:force];
    });
    
}

@end
