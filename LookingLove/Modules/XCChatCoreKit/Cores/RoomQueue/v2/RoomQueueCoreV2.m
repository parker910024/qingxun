//
//  RoomQueueCoreV2.m
//  BberryCore
//
//  Created by Mac on 2017/12/8.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "RoomQueueCoreV2.h"
#import "RoomQueueCoreClient.h"
#import <NIMSDK/NIMSDK.h>

#import "AuthCore.h"
#import "UserCore.h"
#import "MeetingCore.h"
#import "RoomCoreV2.h"
#import "RoomCoreClient.h"
#import "ImMessageCore.h"
#import "ImMessageCoreClient.h"
#import "ImRoomCoreV2.h"
#import "ImRoomCoreClient.h"
#import "ImRoomCoreClientV2.h"
#import "NobleCore.h"
#import "XCHUDTool.h"
#import "RoomGiftValueCore.h"
#import "TTBlindDateCore.h"

#import "XCInviteMicAttachment.h"

#import "HttpRequestHelper+Room.h"
#import "HttpRequestHelper+RoomQueue.h"
#import "NSObject+YYModel.h"
#import "NSDictionary+JSON.h"
#import "NSString+JsonToDic.h"

#define MIC_COUNT 9

@interface RoomQueueCoreV2()<
ImRoomCoreClient,
ImRoomCoreClientV2,
RoomCoreClient,
ImMessageCoreClient
>
@property (nonatomic, strong) NSMutableDictionary *micQueue;
@property (copy, nonatomic) NSString *position;
@property (assign, nonatomic) BOOL isReConnect;
@end

@implementation RoomQueueCoreV2
- (instancetype)init {
    if (self == [super init]) {
        AddCoreClient(ImRoomCoreClient, self);
        AddCoreClient(ImRoomCoreClientV2, self);
        AddCoreClient(RoomCoreClient, self);
        AddCoreClient(ImMessageCoreClient, self);
        
    }
    return self;
}

- (void)dealloc {
    RemoveCoreClientAll(self);
}

#pragma mark - ImRoomCoreClientV2
- (void)onGetRoomQueueSuccessV2:(NSMutableDictionary*)info{
    self.micQueue = info;

    //reset
    if (self.isReConnect && self.position.length > 0) {
        ChatRoomMicSequence *sequence = [self.micQueue objectForKey:self.position];
        if (GetCore(RoomCoreV2).getCurrentRoomInfo.roomModeType == RoomModeType_Open_Micro_Mode) {
            //只要是麦位上没有人的话就让他 重新上麦
            if (!sequence.chatRoomMember) {
                [self upMic:self.position.intValue isReConnect:YES];
            } else {
                if (sequence.chatRoomMember.userId.userIDValue == GetCore(AuthCore).getUid.userIDValue) {
                    sequence.chatRoomMember = nil;
                    sequence.userInfo = nil;
                    [self upMic:self.position.intValue isReConnect:YES];
                }
            }
        }else{
            if (sequence.microState.posState == MicroPosStateFree) {
                if (!sequence.chatRoomMember) {
                    sequence.userInfo = nil;
                    [self upMic:self.position.intValue isReConnect:YES];
                } else {
                    if (sequence.chatRoomMember.userId.userIDValue == GetCore(AuthCore).getUid.userIDValue) {
                        sequence.chatRoomMember = nil;
                        sequence.userInfo = nil;
                        [self upMic:self.position.intValue isReConnect:YES];
                    }
                }
            }
        }
        self.isReConnect = NO;
        self.position = nil;
    }
}

//user进入
- (void)onUserInterChatRoom:(NIMMessage *)message {
    if (message.messageType == NIMMessageTypeNotification) {
        NIMNotificationObject *notiMsg = (NIMNotificationObject *)message.messageObject;
        NIMChatroomNotificationContent *content = (NIMChatroomNotificationContent *)notiMsg.content;
        if (content.eventType == NIMChatroomEventTypeEnter) {
            NIMChatroomNotificationMember *tempMember = content.targets[0];
            if (tempMember.userId.userIDValue == GetCore(AuthCore).getUid.userIDValue) {
                if (self.isReConnect) {
                    RoomInfo *roomInfo = GetCore(ImRoomCoreV2).currentRoomInfo;
                    [self connectionNIMWithRoomInfo:roomInfo];
                }
            }
            
        }
    }
}

//user exit  onlinecount-1
- (void)onUserExitChatRoom:(NIMMessage *)message{
    if (message.messageType == NIMMessageTypeNotification) {
        NIMNotificationObject *notiMsg = (NIMNotificationObject *)message.messageObject;
        NIMChatroomNotificationContent *content = (NIMChatroomNotificationContent *)notiMsg.content;
        if (content.eventType == NIMChatroomEventTypeExit ||content.eventType == NIMChatroomEventTypeKicked) {
            NIMChatroomNotificationMember *tempMember = content.targets[0];
            if (tempMember.userId.userIDValue == GetCore(ImRoomCoreV2).currentRoomInfo.uid
                ) {
                GetCore(ImRoomCoreV2).roomOwner = nil;
            }
            NSString *position = [self findThePositionByUid:tempMember.userId.userIDValue];
            
            ChatRoomMicSequence *micsequence = [self.micQueue objectForKey:position];
            micsequence.userInfo = nil;
            micsequence.chatRoomMember = nil;
            
            NotifyCoreClient(ImRoomCoreClientV2, @selector(onGetRoomQueueSuccessV2:), onGetRoomQueueSuccessV2:self.micQueue);
        }
    }
}

//上下麦
- (void)onRoomQueueUpdate:(NIMMessage *)message{
    if (message.messageType == NIMMessageTypeNotification) {
        NIMNotificationObject *notiMsg = (NIMNotificationObject *)message.messageObject;
        NIMChatroomNotificationContent *content = (NIMChatroomNotificationContent *)notiMsg.content;
        if (content.eventType == NIMChatroomEventTypeQueueChange) {
            
            NSDictionary *temp = (NSDictionary *)content.ext;
            UserInfo *userInfo = [UserInfo yy_modelWithJSON:[temp objectForKey:NIMChatroomEventInfoQueueChangeItemValueKey]];
            
            //用户所在旧麦位，为空表示上麦，有值表示换麦或更新麦位信息
            NSString *oldPosition;
            
            //去重复 如果该uid在房间先清空
            for (ChatRoomMicSequence *sequence in self.micQueue.allValues) {
                if (userInfo.uid == sequence.userInfo.uid) {
                    oldPosition = @(sequence.microState.position).stringValue;
                    sequence.userInfo = nil;
                    sequence.chatRoomMember = nil;
                }
            }
            
            if ([temp[NIMChatroomEventInfoQueueChangeTypeKey] intValue] == 1) {//上麦
                
                ChatRoomMicSequence *sequence = [self.micQueue objectForKey:[temp objectForKey:NIMChatroomEventInfoQueueChangeItemKey]];
                if (sequence.userInfo && sequence.userInfo.uid == GetCore(AuthCore).getUid.userIDValue) {
                    //被踢，关闭声网
                    NotifyCoreClient(RoomQueueCoreClient, @selector(onMicroBeSqueezedOut), onMicroBeSqueezedOut);
                    [GetCore(MeetingCore)setMeetingRole:NO];
                }
                sequence.userInfo = userInfo;
                
                NSString *position = [temp objectForKey:NIMChatroomEventInfoQueueChangeItemKey];
                [self setUpMicStateWith:position userInfo:userInfo];
                
                //当新旧麦位不一致时，才发送更新上麦通知
                if (!oldPosition || position.integerValue != oldPosition.integerValue) {
                    NotifyCoreClient(RoomQueueCoreClient, @selector(onRoomQueueUpdate:position:type:), onRoomQueueUpdate:userInfo.uid position:position.intValue type:RoomQueueUpateTypeAdd);
                }

                NSMutableArray *uids = [NSMutableArray array];
                for (ChatRoomMicSequence *sequence in GetCore(ImRoomCoreV2).micQueue.allValues) {
                    if(sequence.userInfo){
                        [uids addObject:[NSString stringWithFormat:@"%lld",sequence.userInfo.uid]];
                    }
                }
                
                NIMChatroomNotificationMember *tempMember = content.targets[0];
                if (![uids containsObject:tempMember.userId]) {
                    [uids addObject:tempMember.userId];
                }
                [GetCore(ImRoomCoreV2) queryChartRoomMembersWithUids:uids];

                [GetCore(MeetingCore).engine muteRemoteAudioStream:userInfo.uid mute:false];
                
            }else{//下麦
                NSString *position = [temp objectForKey:NIMChatroomEventInfoQueueChangeItemKey];
                [self setUpMicStateWith:position userInfo:userInfo];
                
                NotifyCoreClient(RoomQueueCoreClient, @selector(onRoomQueueUpdate:position:type:), onRoomQueueUpdate:userInfo.uid position:position.intValue type:RoomQueueUpateTypeRemove);
                NotifyCoreClient(ImRoomCoreClientV2, @selector(onGetRoomQueueSuccessV2:), onGetRoomQueueSuccessV2:self.micQueue);
            }
            
        }
    }
}



//麦序状态
- (void)onRoomInfoUpdate:(NIMMessage *)message{
    if (GetCore(RoomCoreV2).isInRoom) {
        if (message.messageType == NIMMessageTypeNotification) {
            NIMNotificationObject *notiMsg = (NIMNotificationObject *)message.messageObject;
            NIMChatroomNotificationContent *content = (NIMChatroomNotificationContent *)notiMsg.content;
            if (content.eventType == NIMChatroomEventTypeInfoUpdated) {
                NSDictionary *roomInfoDictionary = [NSString dictionaryWithJsonString:content.notifyExt];
                
                int type = [roomInfoDictionary[@"type"] intValue];
                switch (type) {
                    case 1:{
                        RoomInfo *roomInfo = [RoomInfo yy_modelWithJSON:roomInfoDictionary[@"roomInfo"]];
                        GetCore(ImRoomCoreV2).currentRoomInfo = roomInfo;
                        NotifyCoreClient(RoomCoreClient, @selector(onGameRoomInfoUpdateSuccess:eventType:), onGameRoomInfoUpdateSuccess:roomInfo eventType:RoomUpdateEventTypeOther);
                        }
                        break;
                        
                    case 2:{
                        MicroState *microState = [MicroState yy_modelWithJSON:roomInfoDictionary[@"micInfo"]];
                        [self changeMicState:[NSString stringWithFormat:@"%d",microState.position] roomQueue:microState uid:content.source.userId.userIDValue];
                        ChatRoomMicSequence *micSequence = [self.micQueue objectForKey:[NSString stringWithFormat:@"%d",microState.position]];
                        if (micSequence != nil) {
                            micSequence.microState = microState;
                            NotifyCoreClient(RoomQueueCoreClient, @selector(onMicroQueueUpdate:), onMicroQueueUpdate:self.micQueue);
                        }

                    }
                        break;
                        //更新了房间信息 也更新了麦序的信息
                    case 3:{
               
                        RoomInfo *roomInfo = [RoomInfo yy_modelWithJSON:roomInfoDictionary[@"roomInfo"]];
                        GetCore(ImRoomCoreV2).currentRoomInfo = roomInfo;
                        NotifyCoreClient(RoomCoreClient, @selector(onGameRoomInfoUpdateSuccess:eventType:), onGameRoomInfoUpdateSuccess:roomInfo eventType:RoomUpdateEventTypeOther);
                        
                        NSArray * array = [NSArray yy_modelArrayWithClass:[MicroState class] json:roomInfoDictionary[@"micInfo"]];
                        if (array && array.count > 0) {
                            for (MicroState * microState in array) {
                                [self changeMicState:[NSString stringWithFormat:@"%d",microState.position] roomQueue:microState uid:content.source.userId.userIDValue];
                                ChatRoomMicSequence *micSequence = [self.micQueue objectForKey:[NSString stringWithFormat:@"%d",microState.position]];
                                if (micSequence != nil) {
                                    micSequence.microState = microState;
                                    NotifyCoreClient(RoomQueueCoreClient, @selector(onMicroQueueUpdate:), onMicroQueueUpdate:self.micQueue);
                                }
                            }
                        }
                    }
                        break;
                }
            }
        }

    }
}

//收到聊天室成员主动更新了聊天室的角色信息通知
- (void)onReceiveChatRoomMemberInfoUpdateMessages:(NIMMessage *)message {
    NotifyCoreClient(RoomCoreClient, @selector(onMicroStateChange), onMicroStateChange);
    if (message.messageType == NIMMessageTypeNotification) {
        NIMNotificationObject *notiMsg = (NIMNotificationObject *)message.messageObject;
        NIMChatroomNotificationContent *content = (NIMChatroomNotificationContent *)notiMsg.content;
        if (content.eventType == NIMChatroomEventTypeMemberUpdateInfo) {//  聊天室成员主动更新了聊天室的角色信息
            NIMChatroomNotificationMember *tempMember = content.targets[0];
            NIMChatroomMembersByIdsRequest *request = [[NIMChatroomMembersByIdsRequest alloc]init];
            request.roomId = [NSString stringWithFormat:@"%ld",GetCore(ImRoomCoreV2).currentRoomInfo.roomId];
            request.userIds = @[tempMember.userId];
            [[NIMSDK sharedSDK].chatroomManager fetchChatroomMembersByIds:request completion:^(NSError * _Nullable error, NSArray<NIMChatroomMember *> * _Nullable members) {
                if (error == nil) {
                    if (members.count > 0) {
                        
                        NSString *position = [self findThePositionByUid:[NSString stringWithFormat:@"%@",members.firstObject.userId].userIDValue];
                        ChatRoomMicSequence *micSequence = GetCore(ImRoomCoreV2).micQueue[position];
                        micSequence.chatRoomMember = members.firstObject;
                        if (micSequence) {
                            [GetCore(ImRoomCoreV2).micQueue setValue:micSequence forKey:position];
                        }
                        NotifyCoreClient(RoomQueueCoreClient, @selector(onMicroQueueUpdate:), onMicroQueueUpdate:GetCore(ImRoomCoreV2).micQueue);
                    }
                }else {

                }
            }];
        }
    }
}


- (void)onMeExitChatRoomSuccessV2 {
    self.micQueue = nil;
    self.myMember = nil;
    self.needCloseMicro = NO;
    
}
#pragma mark - 断网重连
- (void)onConnectionStateChanged:(NIMChatroomConnectionState)state{
    if (state == NIMChatroomConnectionStateEnterOK) {
        RoomInfo *roomInfo = GetCore(ImRoomCoreV2).currentRoomInfo;
        if (roomInfo != nil) {
            if (self.isReConnect) {
                [[BaiduMobStat defaultStat]logEvent:@"event_reconnection_room_chat" eventLabel:@"重连聊天室"];
            } else {
                [self connectionNIMWithRoomInfo:roomInfo];
            }
        }
    } else if (state == NIMChatroomConnectionStateLoseConnection) {
        //recode position
        if ([self isOnMicro:[GetCore(AuthCore)getUid].userIDValue]) {
            self.position = [self findThePositionByUid:[GetCore(AuthCore) getUid].userIDValue];
            self.isReConnect = YES;
        }
        
    }
}

- (void)connectionNIMWithRoomInfo:(RoomInfo *)roomInfo {
    //roomQueue
    [[GetCore(ImRoomCoreV2) rac_queryQueueWithRoomId:[NSString stringWithFormat:@"%ld",(long)roomInfo.roomId]] subscribeNext:^(id x) {
        
        NSArray *micQueueInfo = (NSArray *)x;
        NSMutableArray *uids = [NSMutableArray array];
        for (NSDictionary *item in micQueueInfo) {
            UserInfo *userInfo = [UserInfo yy_modelWithJSON:item.allValues.firstObject];
            NSString *position = item.allKeys.firstObject;
            ChatRoomMicSequence *sequence = [self.micQueue objectForKey:position];
            sequence.userInfo = userInfo;
            if (userInfo) {
                [uids addObject:[NSString stringWithFormat:@"%lld",userInfo.uid]];
            }
            
        }
        
        //micState  根据roomid从云信获取chatroom
        [[GetCore(ImRoomCoreV2) rac_fetchChatRoomInfoByRoomId:GetCore(ImRoomCoreV2).currentChatRoom.roomId] subscribeNext:^(id x) {
            
            NIMChatroom *chatroom = (NIMChatroom *)x;
            NSDictionary *micInfo = [NSString dictionaryWithJsonString:chatroom.ext];
            NSDictionary *micDictionary = [NSString dictionaryWithJsonString:micInfo[@"micQueue"]];
            
            for (NSString *position in micDictionary.allKeys) {
                MicroState *state = [MicroState yy_modelWithJSON:micDictionary[position]];
                ChatRoomMicSequence *sequence = [self.micQueue objectForKey:position];
                sequence.microState = state;
            }
            
            [GetCore(ImRoomCoreV2) queryChartRoomMembersWithUids:uids];
        }];
        
    }];
}

#pragma mark - ImMessageCoreClient
- (void)onRecvChatRoomCustomMsg:(NIMMessage *)msg {
    
    NIMCustomObject *customObject = (NIMCustomObject *)msg.messageObject;
    if (customObject.attachment) {
        Attachment *attachment = (Attachment *)customObject.attachment;
        [self handelCustomerChatRoomMessage:attachment];
    }
}

#pragma mark - puble method

- (BOOL)getChatRoomConnectState {
    return self.isReConnect;
}

//解除麦位封锁
- (void)freeMicPlace:(int)position{
    if (GetCore(RoomCoreV2).isInRoom) {
        [self handleMicPlace:position state:0];
    }
}
//封锁麦位
- (void)lockMicPlace:(int)position{
    if (GetCore(RoomCoreV2).isInRoom) {
        [self handleMicPlace:position state:1];
    }
}

//封锁麦位 带block
- (void)lockMicPlace:(int)position success:(void (^)(BOOL success))success {
    if (GetCore(RoomCoreV2).isInRoom) {
         UserID uid = GetCore(ImRoomCoreV2).currentRoomInfo.uid;
        [HttpRequestHelper micPlace:position roomOwnerUid:uid state:1 success:^{
            [GetCore(RoomCoreV2) recordSuperAdminOperate:SuperAdminOperateTypeLockMic superAdminUid:[GetCore(AuthCore).getUid userIDValue] roomUid:GetCore(RoomCoreV2).getCurrentRoomInfo.uid targetUid:nil];
            success(YES);
        } failure:^(NSNumber *resCode, NSString *message) {
            success(NO);
        }];
    }
}

//1：锁坑位，0取消锁（即取消锁坑位）
- (void)handleMicPlace:(int)position state:(int)state{
    UserID uid = GetCore(ImRoomCoreV2).currentRoomInfo.uid;
    [HttpRequestHelper micPlace:position roomOwnerUid:uid state:state success:^{
    } failure:^(NSNumber *resCode, NSString *message) {
    }];
}

//麦位静音 带回调 超管操作
- (void)closeMic:(int)position success:(void (^) (BOOL success))success {
    if (GetCore(RoomCoreV2).isInRoom) {
        UserID uid = GetCore(ImRoomCoreV2).currentRoomInfo.uid;
        [HttpRequestHelper micState:position roomOwnerUid:uid state:1 success:^{
            [GetCore(RoomCoreV2) recordSuperAdminOperate:SuperAdminOperateTypeCloseMic superAdminUid:[GetCore(AuthCore).getUid userIDValue] roomUid:GetCore(RoomCoreV2).getCurrentRoomInfo.uid targetUid:nil];
            success(YES);
        } failure:^(NSNumber *resCode, NSString *message) {
            success(NO);
        }];
    }
}

//麦位静音
- (void)closeMic:(int)position{
    if (GetCore(RoomCoreV2).isInRoom) {

        MicroState *microState = [[self.micQueue objectForKey:[NSString stringWithFormat:@"%d",position]] microState];
        UserInfo *userInfo = [[self.micQueue objectForKey:[NSString stringWithFormat:@"%d",position]] userInfo];
        NIMChatroomMember *member = [[self.micQueue objectForKey:[NSString stringWithFormat:@"%d",position]] chatRoomMember];
        if (userInfo && member && microState.micState == MicroMicStateOpen) {

            BOOL hasPrevent = [self hasPrevent:userInfo.uid position:[NSString stringWithFormat:@"%d",position]];
            if (hasPrevent) {
                NotifyCoreClient(RoomQueueCoreClient, @selector(thisUserIsBePrevent:), thisUserIsBePrevent:BePreventTypecloseMic);
                return;
            }
        }
//        if (micstate.micState == MicroMicStateClose) {
    
            [self handleMicState:position state:1];


    }
}
//取消麦位静音
- (void)openMic:(int)position{
    if (GetCore(RoomCoreV2).isInRoom) {

        [self handleMicState:position state:0];

    }
}
//1：锁麦，0开麦（即取消锁麦）
- (void)handleMicState:(int)position state:(int)state{
    UserID uid = GetCore(ImRoomCoreV2).currentRoomInfo.uid;
    [HttpRequestHelper micState:position roomOwnerUid:uid state:state success:^{
        NotifyCoreClient(RoomQueueCoreClient, @selector(handleCloseMicPlaceSuccessWithPosition:state:), handleCloseMicPlaceSuccessWithPosition:position state:state);
    } failure:^(NSNumber *resCode, NSString *message) {
    }];
}

//下麦
- (void)downMic {
    [self downMicAndIsExitRoom:NO];
}

// 退出房间下麦
- (void)downMicAndIsExitRoom:(BOOL)exitRoom {
    if (GetCore(RoomCoreV2).isInRoom) {
        UserID uid = [GetCore(AuthCore) getUid].userIDValue;
        if ([self isOnMicro:uid]) {
            NSString *position = [self findThePositionByUid:uid];
        
            //NIMSDK
            if (position) {
                [self removeChatroomQueueWithPosition:position uid:uid kickMicType:nil exitRoom:exitRoom success:^(BOOL success) {
                    
                    [[BaiduMobStat defaultStat] eventEnd:@"room_time_of_user_on_wheat" eventLabel:@"当前用户在麦上的时间"];
                } failure:^(NSString *message) {
                }];
            }
        }
    }
}

//上指定麦
- (void)upMic:(int)position invite:(BOOL)isInvite {
    [self upMic:position invite:isInvite isReConnect:NO];
}

- (void)upMic:(int)position invite:(BOOL)isInvite isReConnect:(BOOL)isReConnect {

    UserInfo *userInfo = [[GetCore(ImRoomCoreV2).micQueue objectForKey:[NSString stringWithFormat:@"%d",position]] userInfo];
    NIMChatroomMember *member = [[self.micQueue objectForKey:[NSString stringWithFormat:@"%d",position]] chatRoomMember];
    
    if (userInfo && member) {
        return;
    }

    if (GetCore(RoomCoreV2).isInRoom) {
        if ((GetCore(ImRoomCoreV2).currentRoomInfo.type == RoomType_Game || GetCore(ImRoomCoreV2).currentRoomInfo.type == RoomType_Love) && GetCore(ImRoomCoreV2).isLoading) {
            
            return;

        }
        
        NotifyCoreClient(CPGameCoreClient, @selector(suddenUpMic), suddenUpMic);
        
        MicroState *micstate = [[self.micQueue objectForKey:[NSString stringWithFormat:@"%d",position]] microState];
        UserID uid = [GetCore(AuthCore) getUid].userIDValue;
         UserInfo *userInfo = [GetCore(UserCore) getUserInfoInDB:uid];
        [[GetCore(ImRoomCoreV2) rac_queryChartRoomMemberByUid:[NSString stringWithFormat:@"%lld",uid]] subscribeNext:^(id x) {
            NIMChatroomMember *member = (NIMChatroomMember *)x;
            
            if (member.type == NIMChatroomMemberTypeManager || member.type == NIMChatroomMemberTypeCreator) {
                [self updateChatroomQueueWithPosition:[NSString stringWithFormat:@"%d",position] userInfo:userInfo isReConnect:isReConnect success:^(BOOL success) {
                    [[BaiduMobStat defaultStat] eventStart:@"room_time_of_user_on_wheat" eventLabel:@"当前用户在麦上的时间"];
                } failure:^(NSString *message) {
                }];
            }else{
                if (micstate.posState == MicroPosStateFree || isInvite) {
                    if (userInfo != nil) {
                        [self updateChatroomQueueWithPosition:[NSString stringWithFormat:@"%d",position] userInfo:userInfo isReConnect:isReConnect success:^(BOOL success) {
                            [[BaiduMobStat defaultStat] eventStart:@"room_time_of_user_on_wheat" eventLabel:@"当前用户在麦上的时间"];
                        } failure:^(NSString *message) {
                            
                        }];
                    }
                }
            }
        }];
    }
}

- (void)upMic:(int)position{
    [self upMic:position isReConnect:NO];
}

/// 上麦
/// @param position 麦位
/// @param isReConnect 是否是断网重连
- (void)upMic:(int)position isReConnect:(BOOL)isReConnect {
    if (GetCore(ImRoomCoreV2).currentRoomInfo.type == RoomType_Love) {
        if (position == 0 || position == 1 || position == 2 || position == 3) {
            if ([GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue].gender == 2) {
                [self upMic:position invite:NO isReConnect:isReConnect];
            } else {
                [XCHUDTool showErrorWithMessage:@"这是女嘉宾席哦~"];
            }
        } else if (position == 4 || position == 5 || position == 6 || position == 7) {
            if ([GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue].gender == 1) {
                [self upMic:position invite:NO isReConnect:isReConnect];
            } else {
                [XCHUDTool showErrorWithMessage:@"这是男嘉宾席哦~"];
            }
        } else {
            [self upMic:position invite:NO isReConnect:isReConnect];
        }
    } else {
        [self upMic:position invite:NO isReConnect:isReConnect];
    }
}

//上一个空闲麦
- (void)upFreeMic{
    NSString *position = [self findFreePosition];
    if (position.length > 0) {
        [self upMic:[position intValue]];
    }
}

//踢它下麦 有回调
- (void)kickDownMic:(UserID)uid position:(int)position success:(void (^) (NSString * nick,  UserID uid))kickDownBlock {
    if (GetCore(RoomCoreV2).isInRoom) {
        NSString *pos = [NSString stringWithFormat:@"%d",position];
        ChatRoomMicSequence *sequence = [GetCore(ImRoomCoreV2).micQueue objectForKey:pos];
        NSString *nick = sequence.userInfo.nick;
        if (pos) {
            [self removeChatroomQueueWithPosition:pos uid:uid success:^(BOOL success) {
                //NIMSDK
                kickDownBlock(nick, uid);
                [[BaiduMobStat defaultStat] eventStart:@"user_kicked_event" eventLabel:@"用户被踢"];
                [GetCore(RoomCoreV2) recordSuperAdminOperate:SuperAdminOperateTypeDownkMic superAdminUid:[GetCore(AuthCore).getUid userIDValue] roomUid:GetCore(RoomCoreV2).getCurrentRoomInfo.uid targetUid:uid];
            } failure:^(NSString *message) {
            }];
        }
    }
}

//踢它下麦
- (void)kickDownMic:(UserID)uid position:(int)position {
    [self kickDownMic:uid position:position kickRoom:NO isBlack:NO];
}

// 拉黑踢下麦
- (void)kickDownMic:(UserID)uid position:(int)position isBlack:(BOOL)isBlack {
    [self kickDownMic:uid position:position kickRoom:NO isBlack:isBlack];
}

/// 抱人下麦
/// @param uid 用户uid
/// @param position 坑位
/// @param kickRoom 是否是踢出房间
- (void)kickDownMic:(UserID)uid position:(int)position kickRoom:(BOOL)kickRoom isBlack:(BOOL)isBlack {
    [self kickDownMic:uid position:position kickRoom:kickRoom isBlack:isBlack success:nil];
}
- (void)kickDownMic:(UserID)uid position:(int)position kickRoom:(BOOL)kickRoom isBlack:(BOOL)isBlack success:(void(^)(void))kickDownBlock {
    if (GetCore(RoomCoreV2).isInRoom) {
    
        NSString *pos = [NSString stringWithFormat:@"%d",position];
        ChatRoomMicSequence *sequence = [GetCore(ImRoomCoreV2).micQueue objectForKey:pos];
        NSString *nick = sequence.userInfo.nick;
        
        BOOL hasPrevent = [self hasPrevent:uid position:pos];
        // 如果有权限且不是踢出房间
        if (hasPrevent && !kickRoom) {
            NotifyCoreClient(RoomQueueCoreClient, @selector(thisUserIsBePrevent:), thisUserIsBePrevent:BePreventTypeDownMic);
            return;
        }
        
        if (pos) {
            NSInteger kickMicType = 1;
            if (isBlack) {
                kickMicType = 2;
            }
            if (kickRoom) {
                kickMicType = 3;
            }
            [self removeChatroomQueueWithPosition:pos uid:uid kickMicType:kickMicType exitRoom:NO success:^(BOOL succes) {
                if (kickDownBlock) {
                    kickDownBlock();
                }
                [[BaiduMobStat defaultStat] eventStart:@"user_kicked_event" eventLabel:@"用户被踢"];
            } failure:^(NSString *message) {
                if (kickDownBlock) {
                    kickDownBlock();
                }
            }];
        }
    }
}

//邀请上指定麦位
- (void)inviteUpMic:(UserID)uid postion:(NSString *)position{
    if (GetCore(ImRoomCoreV2).currentRoomInfo.type == RoomType_Love) {
        [self _loveRoomInviteOnMic:uid postion:position];
    } else {
       //NIMSDK
       [self inviteOnMic:uid postion:position];
    }
}

//邀请上空闲麦
- (void)inviteUpFreeMic:(UserID)uid{
    if (GetCore(RoomCoreV2).isInRoom) {
        NSString *position = [self findFreePosition];
        if (position.length == 0) {
            NotifyCoreClient(RoomCoreClient, @selector(thereIsNoFreePosition), thereIsNoFreePosition);
        }else {
            [self inviteUpMic:uid postion:position];
        }
    }
}

//邀请上锁定的麦（排麦的时候）
- (void)inviteUpLockMic:(UserID)uid{
    [self inviteUpLockMic:uid gender:0];
}

/**
 邀请上锁定的麦（排麦的时候）相亲房使用

 @param uid 用户uid
 */
- (void)inviteUpLockMic:(UserID)uid gender:(UserGender)gender {
    if (GetCore(RoomCoreV2).isInRoom) {
        NSString * position = [self _findGenderPositionBySequence:gender];
        if (position.length == 0) {
            NotifyCoreClient(RoomCoreClient, @selector(thereIsNoLockPosition), thereIsNoLockPosition);
        }else{
            [self inviteUpMic:uid postion:position];
        }
    }
}

//判断是否在麦上
- (BOOL)isOnMicro:(UserID)uid{
//    NSArray *micMembers = [GetCore(ImRoomCoreV2).micMembers copy] ;
//    if (micMembers != nil && micMembers.count > 0) {
//        for (int i = 0; i < micMembers.count; i ++) {
//            NIMChatroomMember *chatRoomMember = micMembers[i];
//            if (chatRoomMember.userId.userIDValue == uid) {
//                return YES;
//            }
//        }
//    }
//    return NO;
    NSArray *chatRoomMicSequences = [GetCore(ImRoomCoreV2).micQueue allValues] ;
    if (chatRoomMicSequences != nil && chatRoomMicSequences.count > 0) {
        for (int i = 0; i < chatRoomMicSequences.count; i ++) {
            ChatRoomMicSequence *chatRoomMicSequence = chatRoomMicSequences[i];
            if (chatRoomMicSequence.userInfo.uid == uid) {
                return YES;
            }
        }
    }
    return NO;
}
//通过uid判断麦位
- (NSString *)findThePositionByUid:(UserID)uid {
    if (uid > 0) {
        NSArray *keys = [self.micQueue allKeys];
        if (keys.count > 0) {
            for (NSString *key in self.micQueue.allKeys) {
                NIMChatroomMember *member = [[self.micQueue objectForKey:key] chatRoomMember];
                if (member.userId.userIDValue == uid) {
                    return key;
                }
            }
        }
    }
    return nil;
}
//通过uid查找member
- (NIMChatroomMember *)findTheMemberByUserId:(UserID)uid{
    NSArray *keys = [self.micQueue allKeys];
    for (NSString *key in keys) {
        ChatRoomMicSequence *info = [self.micQueue objectForKey:key];
        if (info.chatRoomMember.userId.userIDValue == uid) {
            return info.chatRoomMember;
        }
    }
    return nil;
}

//通过uid查找麦序信息
- (ChatRoomMicSequence *)findTheRoomQueueMemberInfo:(UserID)uid{
    NSArray *keys = [self.micQueue allKeys];
    for (NSString *key in keys) {
        ChatRoomMicSequence *info = [self.micQueue objectForKey:key];
        if (info.chatRoomMember.userId.userIDValue == uid) {
            return info;
        }
    }
    return nil;
}


- (NSMutableArray *)findSendGiftMember {
    NSMutableArray *temp = [NSMutableArray array];
    for (int i = 0; i < MIC_COUNT; i++) {
        ChatRoomMicSequence *sequence =[self.micQueue objectForKey:[NSString stringWithFormat:@"%d",i-1]];
        if (sequence.chatRoomMember != nil && sequence.chatRoomMember.userId.userIDValue == self.roomOwner.userId.userIDValue) {
            [temp addObject:sequence];
        }
        if (sequence.chatRoomMember != nil && sequence.chatRoomMember.userId.userIDValue != self.roomOwner.userId.userIDValue) {
            [temp addObject:sequence];
        }
    }
    return temp;
}

- (void)openMicServeTimer:(int)position seconds:(int)seconds{
    
    [HttpRequestHelper requestOpenMic:position serveTimer:seconds success:^() {
        
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        
    }];
}


- (void)closeMicServeTimer:(UserID)uid position:(int)position{
    
    [HttpRequestHelper requestCloseMicServeTimer:uid position:position success:^{
        
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        
    }];
}

/// 通过接口上麦
/// @param micUid 麦位用户uid
/// @param roomUid 房间uid
/// @param position 坑位
/// @param reconnect 是否是重连上麦
- (RACSignal *)onUpRoomMic:(UserID)micUid roomUid:(NSInteger)roomUid position:(NSInteger)position reconnect:(BOOL)reconnect {
    [self closeMicServeTimer:micUid position:position];
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [HttpRequestHelper onUpRoomMic:micUid roomUid:roomUid reconnect:reconnect position:position  success:^(BOOL success) {
            [subscriber sendNext:@(success)];
            [subscriber sendCompleted];
        } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
            NSError *error = [NSError errorWithDomain:message code:resCode.integerValue userInfo:nil];
            [subscriber sendError:error];
        }];
        return nil;
    }];
    
}

/// 通过接口下麦
/// @param micUid 麦位用户uid
/// @param roomUid 房间uid
/// @param position 坑位
/// @param kickMicType  抱下麦类型(1 -- 房间抱下麦, 2 -- 拉黑报下麦, 3-- 踢出房间)
/// @param outRoom 是否是退出房间下麦
- (RACSignal *)onDownRoomMic:(UserID)micUid roomUid:(NSInteger)roomUid position:(NSInteger)position kickMicType:(NSInteger)kickMicType outRoom:(BOOL)outRoom {
    [self closeMicServeTimer:micUid position:position];
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [HttpRequestHelper onDownRoomMic:micUid roomUid:roomUid position:position kickMicType:kickMicType outRoom:outRoom success:^(BOOL success) {
            [subscriber sendNext:@(success)];
            [subscriber sendCompleted];
        } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
            NSError *error = [NSError errorWithDomain:message code:resCode.integerValue userInfo:nil];
            [subscriber sendError:error];
        }];
        return nil;
    }];
    
}

#pragma mark - private method
//查询是否拥有防踢 防禁麦权限
- (BOOL)hasPrevent:(UserID)uid position:(NSString *)pos{

    ChatRoomMicSequence *sequence = GetCore(ImRoomCoreV2).micQueue[pos];
    NSDictionary *dic = [NSString dictionaryWithJsonString:sequence.chatRoomMember.roomExt];
    NSString *uidString = [NSString stringWithFormat:@"%lld",uid];
    SingleNobleInfo *nobleInfo = [SingleNobleInfo yy_modelWithJSON:dic[uidString]];
    
    NSString *level = [NSString stringWithFormat:@"%ld",nobleInfo.level];
    NobleInfo *info = GetCore(NobleCore).privilegeDict[level];
    
    return info.privilegeInfo.prevent;
}

//上麦后设置角色
- (void)setUpMicStateWith:(NSString *)position userInfo:(UserInfo*)userInfo{
    if (position) {
      
        ChatRoomMicSequence *sequence = [self.micQueue objectForKey:position];
        if (sequence && sequence.userInfo.uid == GetCore(AuthCore).getUid.userIDValue) {
            MicroState *state = [[self.micQueue objectForKey:position] microState];
            
                if (self.needCloseMicro) {
                    if (state.micState == MicroMicStateClose) {
                        [GetCore(MeetingCore)setMeetingRole:NO];
                    }else {
                        [GetCore(MeetingCore)setMeetingRole:YES];
                        [GetCore(MeetingCore)setCloseMicro:YES];
                    }
                }else {
                    if (state.micState == MicroMicStateClose) {
                        [GetCore(MeetingCore)setMeetingRole:NO];
                        
                    }else {
                        [GetCore(MeetingCore)setMeetingRole:YES];
                    }
                }
        }else{
            if (userInfo.uid == GetCore(AuthCore).getUid.userIDValue) {
                [GetCore(MeetingCore)setMeetingRole:NO];
            }
            
        }
    }else {
        [GetCore(MeetingCore)setMeetingRole:NO];
    }
}

- (NSString *)findFreePosition {
    if (self.micQueue != nil && self.micQueue.allKeys.count > 0) {
        NSArray *keys = [self.micQueue allKeys];
        if (keys.count > 0) {
            for (NSString *key in keys) {
                if (GetCore(ImRoomCoreV2).currentRoomInfo.type == RoomType_CP) {
                    if (key.intValue < 1) {
                        NIMChatroomMember *member = [[self.micQueue objectForKey:key] chatRoomMember];
                        UserInfo *userInfo = [[self.micQueue objectForKey:key] userInfo];
                        if (!member && !userInfo) {
                            return key;
                        }
                    }
                }else{
                    NIMChatroomMember *member = [[self.micQueue objectForKey:key] chatRoomMember];
                    UserInfo *userInfo = [[self.micQueue objectForKey:key] userInfo];
                    if (!member && !userInfo) {
                        return key;
                    }
                }
            }
        }
    }
    return nil;
}
//查看锁定的麦序（排麦模式中使用）
- (NSString *)findLockPosition {
    // 默认的排麦模式，不需要处理性别相关
    return [self _findGenderPositionBySequence:0];
}

/// 按性别和顺序查找坑位
/// @param gender 性别
- (NSString *)_findGenderPositionBySequence:(UserGender)gender {
    if ([self micQueue] != nil && self.micQueue.allKeys.count > 0) {
        NSArray *keys = [self.micQueue allKeys];
        NSArray *result = [keys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj1 compare:obj2]; //升序
        }];
        if (result.count > 0) {
            NSMutableArray *resultArray = [result mutableCopy];
            if (result.count == 9) { // 秀场厅排麦过滤大头
                [resultArray removeObject:@"-1"];
            }
            
            // 如果是
            if (gender == UserInfo_Female) {
                [resultArray removeLastObject];
                [resultArray removeLastObject];
                [resultArray removeLastObject];
                [resultArray removeLastObject];
            } else if (gender == UserInfo_Male) {
                [resultArray removeObjectAtIndex:0];
                [resultArray removeObjectAtIndex:0];
                [resultArray removeObjectAtIndex:0];
                [resultArray removeObjectAtIndex:0];
            }
            for (NSString *key in resultArray) {
                NIMChatroomMember *member = [[self.micQueue objectForKey:key] chatRoomMember];
                UserInfo *userInfo = [[self.micQueue objectForKey:key] userInfo];
                MicroState * micstatus= [[self.micQueue objectForKey:key] microState];
                if (![key isEqualToString:@"-1"] && !member && !userInfo && micstatus.posState ==MicroPosStateLock) {
                    return key;
                    break;
                }
            }
        }
    }
    return nil;
}


- (void)handelCustomerChatRoomMessage:(Attachment *)attachment {

   // NIMSDK
    if (attachment.first == Custom_Noti_Header_Queue) {
        RoomQueueCustomAttachment *roomQueueAttachment = [RoomQueueCustomAttachment yy_modelWithJSON:attachment.data];
        UserID uid = [GetCore(AuthCore) getUid].userIDValue;
        if (attachment.second == Custom_Noti_Sub_Queue_Invite) {
            if (uid == roomQueueAttachment.uid) {
                if (GetCore(ImRoomCoreV2).currentRoomInfo.type == RoomType_Game || GetCore(ImRoomCoreV2).currentRoomInfo.type == RoomType_CP || GetCore(ImRoomCoreV2).currentRoomInfo.type == RoomType_Love) {
                    if (![self isOnMicro:uid]) {
                        self.needCloseMicro = YES;
                        [self upMic:roomQueueAttachment.micPosition invite:YES];
                    }
                   
                }else{
                    
                }
                NotifyCoreClient(RoomQueueCoreClient, @selector(onMicroBeInvite), onMicroBeInvite);
            }
        } else if (attachment.second == Custom_Noti_Sub_Queue_Kick) {
            if (uid == roomQueueAttachment.uid) {
                NotifyCoreClient(RoomQueueCoreClient, @selector(onMicroBeKicked), onMicroBeKicked);
            }
        }
    }
}

- (void)changeMicState:(NSString *)key roomQueue:(MicroState *)microState uid:(UserID)uid  {
    ChatRoomMicSequence *micSequence = [self.micQueue objectForKey:key];
    if (micSequence != nil) {
        NIMChatroomMember *chatRoomMember = micSequence.chatRoomMember;
        if (chatRoomMember != nil) {
            UserID uid = [GetCore(AuthCore) getUid].userIDValue;
            if (uid == chatRoomMember.userId.userIDValue) {
                if (microState.micState == MicroMicStateClose) {
                    [GetCore(MeetingCore) setActor:NO];
                    [GetCore(MeetingCore) setCloseMicro:YES];
                    NotifyCoreClient(RoomQueueCoreClient, @selector(onMicroLocked), onMicroLocked);
                } else {
                    [GetCore(MeetingCore) setActor:YES];
                    [GetCore(MeetingCore) setMeetingRole:YES];
                    [GetCore(MeetingCore) setCloseMicro:YES];
                    NotifyCoreClient(RoomQueueCoreClient, @selector(onMicroUnLocked), onMicroUnLocked);
                }
                NotifyCoreClient(RoomQueueCoreClient, @selector(onMicroStateChange), onMicroStateChange);
            }
        }
    }
}
#pragma mark - NIMSDK
/*
 CP房游戏匹配，匹配到机器人 要抱机器人上麦
 @param userInfo 机器人的用户信息
 @param position 坑位索引
 
 */
//通过NIMSDK修改队列上麦
- (void)updateChatroomQueueWithPosition:(NSString *)position
                                       userInfo:(UserInfo *)userInfo
                                     success:(void (^)(BOOL success))successBlock
                                     failure:(void (^)(NSString *message))failure {
    [self updateChatroomQueueWithPosition:position userInfo:userInfo isReConnect:NO success:successBlock failure:failure];
}
- (void)updateChatroomQueueWithPosition:(NSString *)position
                                       userInfo:(UserInfo *)userInfo
                                    isReConnect:(BOOL)isReConnect
                                     success:(void (^)(BOOL success))successBlock
                                     failure:(void (^)(NSString *message))failure {
    //清空该uid之前在队列中的信息
    if ([self isOnMicro:userInfo.uid]) {
        if (position) {
            NSString *findOldPosition = [self findThePositionByUid:userInfo.uid];
            [self removeChatroomQueueWithPosition:findOldPosition uid:userInfo.uid success:^(BOOL success) {
                [[self onUpRoomMic:userInfo.uid roomUid:GetCore(ImRoomCoreV2).currentRoomInfo.uid position:position.integerValue reconnect:isReConnect] subscribeNext:^(id  _Nullable x) {
                    successBlock(YES);
                    NotifyCoreClient(RoomQueueCoreClient, @selector(onMicroUpMicSuccessWithPosition:uid:isReConnect:), onMicroUpMicSuccessWithPosition:position uid:userInfo.uid isReConnect:isReConnect);
                } error:^(NSError * _Nullable error) {
                    failure(error.domain);
                }];
//                NIMChatroomQueueUpdateRequest *request = [[NIMChatroomQueueUpdateRequest alloc]init];
//                request.key = position;
//                //不能用userinfo 直接json， 云信会限制长度
//                UserInfo *newUserInfo = [[UserInfo alloc] init];
//                newUserInfo.uid = userInfo.uid;
//                newUserInfo.nick = userInfo.nick;
//                newUserInfo.avatar = userInfo.avatar;
//                newUserInfo.gender = userInfo.gender;
//                newUserInfo.groupType = userInfo.groupType;
//                request.value = [newUserInfo yy_modelToJSONString];
//                request.roomId = [NSString stringWithFormat:@"%d",(int)GetCore(ImRoomCoreV2).currentRoomInfo.roomId];
//                request.transient = YES;
//                [[NIMSDK sharedSDK].chatroomManager updateChatroomQueueObject:request completion:^(NSError * _Nullable error) {
//                    if (error == nil ) {
//                        successBlock(YES);
//                        NotifyCoreClient(RoomQueueCoreClient, @selector(onMicroUpMicSuccessWithPosition:uid:isReConnect:), onMicroUpMicSuccessWithPosition:position uid:userInfo.uid isReConnect:isReConnect);
//                    }else {
//                        failure(error.description);
//                    }
//                }];
            } failure:^(NSString *message) {
                NotifyCoreClient(RoomQueueCoreClient, @selector(onMicroUpMicFail), onMicroUpMicFail);
            }];
        }
    } else {
        [[self onUpRoomMic:userInfo.uid roomUid:GetCore(ImRoomCoreV2).currentRoomInfo.uid position:position.integerValue reconnect:isReConnect] subscribeNext:^(id  _Nullable x) {
            successBlock(YES);
            NotifyCoreClient(RoomQueueCoreClient, @selector(onMicroUpMicSuccessWithPosition:uid:isReConnect:), onMicroUpMicSuccessWithPosition:position uid:userInfo.uid isReConnect:isReConnect);
        } error:^(NSError * _Nullable error) {
            failure(error.domain);
        }];
//        NIMChatroomQueueUpdateRequest *request = [[NIMChatroomQueueUpdateRequest alloc]init];
//        request.key = position;
//        //不能用userinfo 直接json， 云信会限制长度
//        UserInfo *newUserInfo = [[UserInfo alloc] init];
//        newUserInfo.uid = userInfo.uid;
//        newUserInfo.nick = userInfo.nick;
//        newUserInfo.avatar = userInfo.avatar;
//        newUserInfo.gender = userInfo.gender;
//        newUserInfo.groupType = userInfo.groupType;
//        request.value = [newUserInfo yy_modelToJSONString];
//        request.roomId = [NSString stringWithFormat:@"%d",(int)GetCore(ImRoomCoreV2).currentRoomInfo.roomId];
//        request.transient = YES;
//        [[NIMSDK sharedSDK].chatroomManager updateChatroomQueueObject:request completion:^(NSError * _Nullable error) {
//            if (error == nil ) {
//                successBlock(YES);
//                NotifyCoreClient(RoomQueueCoreClient, @selector(onMicroUpMicSuccessWithPosition:uid:isReConnect:), onMicroUpMicSuccessWithPosition:position uid:userInfo.uid isReConnect:isReConnect);
//            }else {
//                failure(error.description);
//            }
//        }];
    }
    
}

//通过NIMSDK修改队列下麦
- (void)removeChatroomQueueWithPosition:(NSString *)position
                                    uid:(UserID)uid
                                success:(void (^)(BOOL success))success
                                failure:(void (^)(NSString *message))failure {
    [self removeChatroomQueueWithPosition:position uid:uid kickMicType:nil exitRoom:NO success:^(BOOL succes) {
        success(YES);
    } failure:^(NSString *message) {
        failure(message);
    }];
}

- (void)removeChatroomQueueWithPosition:(NSString *)position
                                      uid:(UserID)uid
                            kickMicType:(NSInteger)kickMicType
                               exitRoom:(BOOL)exitRoom
                                success:(void (^)(BOOL succes))success
                                failure:(void (^)(NSString *message))failure {
    if (position) {
        [[self onDownRoomMic:uid roomUid:GetCore(ImRoomCoreV2).currentRoomInfo.uid position:position.integerValue kickMicType:kickMicType outRoom:exitRoom] subscribeNext:^(id  _Nullable x) {
            success(YES);
            if (uid == GetCore(AuthCore).getUid.userIDValue) {
//                NotifyCoreClient(RoomGiftValueCoreClient, @selector(responseRoomGiftValueStatusDownMic:errorCode:msg:), responseRoomGiftValueStatusDownMic:YES errorCode:nil msg:nil);
            }
        } error:^(NSError * _Nullable error) {
            failure(error.domain);
            if (uid == GetCore(AuthCore).getUid.userIDValue) {
//                NotifyCoreClient(RoomGiftValueCoreClient, @selector(responseRoomGiftValueStatusDownMic:errorCode:msg:), responseRoomGiftValueStatusDownMic:NO errorCode:nil msg:nil);
            }
        }];
    }
//    NIMChatroomQueueRemoveRequest *request = [[NIMChatroomQueueRemoveRequest alloc]init];
//    request.key = position;
//    request.roomId = [NSString stringWithFormat:@"%d",(int)GetCore(ImRoomCoreV2).currentRoomInfo.roomId];
//    if (position) {
//        [[NIMSDK sharedSDK].chatroomManager removeChatroomQueueObject:request completion:^(NSError * _Nullable error, NSDictionary<NSString *,NSString *> * _Nullable element) {
//            if (error == nil ) {
//                success(YES);
//                if (uid == GetCore(AuthCore).getUid.userIDValue) {
////                    NotifyCoreClient(RoomQueueCoreClient, @selector(onMicroDownMicSuccessWithPosition:), onMicroDownMicSuccessWithPosition:position);
//                    UserID roomUID = GetCore(ImRoomCoreV2).currentRoomInfo.uid;
//                    [GetCore(RoomGiftValueCore) requestRoomGiftValueStatusDownMicWithRoomUid:roomUID micUid:GetCore(AuthCore).getUid.userIDValue position:position];
//                    if (GetCore(ImRoomCoreV2).currentRoomInfo.type == RoomType_Love) {
//                        [GetCore(TTBlindDateCore) requestLoveRoomDownMicWithRoomUid:GetCore(ImRoomCoreV2).currentRoomInfo.uid uid:GetCore(AuthCore).getUid.userIDValue position:position.integerValue];
//                    }
//                }
//            }else {
//                failure(error.description);
//                [GetCore(ImRoomCoreV2) queryQueueWithRoomId:[NSString stringWithFormat:@"%d",(int)GetCore(ImRoomCoreV2).currentRoomInfo.roomId]];
//            }
//        }];
//    }
}

// 相亲房邀请上麦
- (void)_loveRoomInviteOnMic:(long long)uid postion:(NSString *)position {
    int positionValue = position.intValue;
    @weakify(self);
    if (positionValue == 0 || positionValue == 1 || positionValue == 2 || positionValue == 3) {
        [[GetCore(UserCore) getUserInfoByUid:uid refresh:YES] subscribeNext:^(id  _Nullable x) {
            UserInfo *info = x;
            @strongify(self);
            if (info.gender == UserInfo_Female) {
                [self inviteOnMic:uid postion:position];
            } else {
                [XCHUDTool showErrorWithMessage:@"这是女嘉宾席哦~"];
                return;
            }
        }];
    } else if (positionValue == 4 || positionValue == 5 || positionValue == 6 || positionValue == 7) {
        [[GetCore(UserCore) getUserInfoByUid:uid refresh:YES] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            UserInfo *info = x;
            if (info.gender == UserInfo_Male) {
                [self inviteOnMic:uid postion:position];
            } else {
                [XCHUDTool showErrorWithMessage:@"这是男嘉宾席哦~"];
                return;
            }
        }];
    } else {
        [self inviteOnMic:uid postion:position];
    }
}

//邀请上麦
- (void)inviteOnMic:(UserID)uid postion:(NSString *)position{
    //判断用户是否在房间
    if (GetCore(RoomCoreV2).isInRoom) {
        [[self onUpRoomMic:uid roomUid:GetCore(ImRoomCoreV2).currentRoomInfo.uid position:position.integerValue reconnect:NO] subscribeNext:^(id  _Nullable x) {
            
        } error:^(NSError * _Nullable error) {
            
        }];
//        MicroState *state = [[MicroState alloc]init];
//        state.position = position.intValue;
//        RoomQueueCustomAttachment *roomQueueAttachment = [[RoomQueueCustomAttachment alloc]init];
//        roomQueueAttachment.uid = uid;
//        roomQueueAttachment.microState = state;
//        roomQueueAttachment.micPosition = position.intValue;
//        roomQueueAttachment.handleNick = GetCore(ImRoomCoreV2).myMember.roomNickname;
//
//        if (GetCore(RoomCoreV2).getCurrentRoomInfo.roomModeType == RoomModeType_Open_Micro_Mode) {
//            state.posState = MicroPosStateLock;
//            [[GetCore(UserCore) getUserInfoByUid:uid refresh:NO] subscribeNext:^(id x) {
//                UserInfo * infor = x;
//                NSString *nick = infor.nick && infor.nick.length > 0  ? infor.nick: @"";
//                roomQueueAttachment.targetNick = nick;
//                Attachment *attachement = [[Attachment alloc]init];
//                attachement.first = Custom_Noti_Header_Queue;
//                attachement.second = Custom_Noti_Sub_Queue_Invite;
//                attachement.data = roomQueueAttachment.encodeAttachment;
//                [GetCore(ImMessageCore) sendCustomMessageAttachement:attachement sessionId:[NSString stringWithFormat:@"%ld",(long)GetCore(ImRoomCoreV2).currentRoomInfo.roomId] type:NIMSessionTypeChatroom];
//            }];
//
//        }else{
//            state.posState = MicroPosStateFree;
//            roomQueueAttachment.targetNick = @"";
//            Attachment *attachement = [[Attachment alloc]init];
//            attachement.first = Custom_Noti_Header_Queue;
//            attachement.second = Custom_Noti_Sub_Queue_Invite;
//            attachement.data = roomQueueAttachment.encodeAttachment;
//
//            [GetCore(ImMessageCore) sendCustomMessageAttachement:attachement sessionId:[NSString stringWithFormat:@"%ld",(long)GetCore(ImRoomCoreV2).currentRoomInfo.roomId] type:NIMSessionTypeChatroom];
//        }

        
        
    }
}

//踢人下麦
- (void)kiedMircoWithUid:(UserID)uid targetNick:(NSString *)targetNick{

    if (uid==0) {
        return;
    }

//    if (GetCore(RoomCoreV2).isInRoom) {
//        MicroState *state = [[MicroState alloc]init];
//        state.posState = MicroPosStateFree;
//
//        RoomQueueCustomAttachment *roomQueueAttachment = [[RoomQueueCustomAttachment alloc]init];
//        roomQueueAttachment.uid = uid;
//        roomQueueAttachment.microState = state;
//        roomQueueAttachment.handleNick = GetCore(ImRoomCoreV2).myMember.roomNickname;
//        roomQueueAttachment.targetNick = targetNick;
//        roomQueueAttachment.handleUid = GetCore(AuthCore).getUid.userIDValue;
//
//        Attachment *attachement = [[Attachment alloc]init];
//        attachement.first = Custom_Noti_Header_Queue;
//        attachement.second = Custom_Noti_Sub_Queue_Kick;
//        attachement.data = roomQueueAttachment.encodeAttachment;
//
//        [GetCore(ImMessageCore) sendCustomMessageAttachement:attachement sessionId:[NSString stringWithFormat:@"%ld",(long)GetCore(ImRoomCoreV2).currentRoomInfo.roomId] type:NIMSessionTypeChatroom];
//    }
}

#pragma mark - Getter & Setter
- (NSMutableDictionary *)micQueue{
    return GetCore(ImRoomCoreV2).micQueue;
}

- (NIMChatroomMember *)myMember{
    return GetCore(ImRoomCoreV2).myMember;
}

- (NIMChatroomMember *)roomOwner{
    return GetCore(ImRoomCoreV2).roomOwner;
}

- (NIMChatroomMember *)myLastMember {
    return GetCore(ImRoomCoreV2).myLastMember;
};


@end
