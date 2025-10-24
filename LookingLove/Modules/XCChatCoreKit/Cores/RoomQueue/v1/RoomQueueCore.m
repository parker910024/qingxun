////
////  RoomQueueCore.m
////  BberryCore
////
////  Created by 卫明何 on 2017/9/5.
////  Copyright © 2017年 chenran. All rights reserved.
////
//
//#import "RoomQueueCore.h"
//#import "RoomQueueCoreClient.h"
//#import "RoomQueue.h"
//#import "AuthCore.h"
//#import "NSObject+YYModel.h"
//#import <NIMSDK/NIMSDK.h>
//#import "UserCore.h"
//#import "RoomCore.h"
//#import "RoomCoreClient.h"
//
//#import "ImMessageCoreClient.h"
//
//
//#import "ImRoomCoreClientV2.h"
//#import "ImRoomCoreClient.h"
//#import "ImRoomCore.h"
//
//#import "NSDictionary+JSON.h"
//#import "NSString+JsonToDic.h"
//
//#import "RoomQueueAttachment.h"
//
//#import "ImMessageCore.h"
//
//#import "MeetingCore.h"
//
//#import "NSObject+YYModel.h"
//
//#import "MeetingCore.h"
//
//#define MIC_COUNT 8
//#define ROOM_UPDATE_KEY_POSTION @"micPosition"
//#define ROOM_UPDATE_KEY_GENDER @"gender"
//
//@interface RoomQueueCore () <ImRoomCoreClientV2, RoomCoreClient, ImMessageCoreClient>
//@property (assign, nonatomic) BOOL needCloseMicro;
//@property (copy, nonatomic) NSString *position;
//@property (assign, nonatomic) BOOL isReConnect;
//@end
//
//
//@implementation RoomQueueCore
//
//- (instancetype)init {
//    if (self == [super init]) {
//        AddCoreClient(ImRoomCoreClient, self);
//        AddCoreClient(RoomCoreClient, self);
//        AddCoreClient(ImMessageCoreClient, self);
//        AddCoreClient(ImRoomCoreClientV2, self);
//    }
//    return self;
//}
//
//- (void)dealloc {
//    RemoveCoreClientAll(self);
//}
//
////获取队列
//- (void)getRoomMicroMembersWithRoomID:(NSString *)roomId {
//    [GetCore(ImRoomCore)getRoomQueueWithRoomId:roomId];
//}
//
//////更换麦序
////- (void)changeTheMicroSerialWithOldSerial:(NSString *)old new:(NSString *)new roomId:(NSString *)roomId {
////    RoomQueue *queue = [[RoomQueue alloc]init];
////    queue.uid = 0;
////    queue.type = QUEUE_TYPE_FREE;
////    queue.nick = nil;
////    queue.gender = nil;
////    [self updateGameRoomMircoMembersWithRoomID:roomId serial:old queue:queue success:^(BOOL success) {
////
////    } failure:^(NSString *message) {
////
////    }];
////
////    NSString *uid = [GetCore(AuthCore) getUid];
////    UserInfo *info = [GetCore(UserCore)getUserInfo:uid.userIDValue refresh:YES];
////
////    RoomQueue *queue2 = [[RoomQueue alloc]init];
////    queue.uid = [GetCore(AuthCore)getUid].userIDValue;
////    queue.type = QUEUE_TYPE_FREE;
////    queue.nick = info.nick;
////    queue.gender = [NSString stringWithFormat:@"%ld",(long)info.gender];
////    queue.avatar = info.avatar;
////    [self updateGameRoomMircoMembersWithRoomID:roomId serial:new queue:queue2 success:^(BOOL success) {
////
////    } failure:^(NSString *message) {
////
////    }];
////}
//
////下麦
//- (void)downMicro {
//
//    if (GetCore(RoomCore).isInRoom) {
//        UserID uid = [GetCore(AuthCore) getUid].userIDValue;
//        if ([self isOnMicro:uid]) {
//            NSMutableDictionary *updateInfo = [NSMutableDictionary dictionary];
//            NIMChatroomMemberInfoUpdateRequest *request = [[NIMChatroomMemberInfoUpdateRequest alloc]init];
//            request.updateInfo = [NSDictionary dictionaryWithObject:[updateInfo toJSONWithPrettyPrint:YES] forKey:@(NIMChatroomMemberInfoUpdateTagExt)];
//            [GetCore(ImRoomCore) updateMyRoomMemberInfoWithrequest:request];
//        }
//    }
//}
//
////上麦
//- (void)upMircoSerialWithSerial:(NSString *)serial{
//    if (GetCore(RoomCore).isInRoom) {
//        RoomQueue *roomQueue = [self.micQueue objectForKey:serial].roomQueue;
//        if (roomQueue != nil && roomQueue.queueType == QUEUE_TYPE_FREE) {
//            UserID uid = [GetCore(AuthCore) getUid].userIDValue;
//            UserInfo *userInfo = [GetCore(UserCore) getUserInfoInDB:uid];
//            if (userInfo != nil) {
//                NSMutableDictionary *updateInfo = [NSMutableDictionary dictionary];
//                [updateInfo setObject:[NSString stringWithFormat:@"%ld", (long)userInfo.gender] forKey:ROOM_UPDATE_KEY_GENDER];
//                [updateInfo setObject:serial forKey:ROOM_UPDATE_KEY_POSTION];
//                NIMChatroomMemberInfoUpdateRequest *request = [[NIMChatroomMemberInfoUpdateRequest alloc]init];
//                request.updateInfo = [NSDictionary dictionaryWithObject:[updateInfo toJSONWithPrettyPrint:YES] forKey:@(NIMChatroomMemberInfoUpdateTagExt)];
////                RoomQueue *myRoomQueue = [RoomQueue yy_modelWithDictionary:myRoom];
//                [GetCore(ImRoomCore) updateMyRoomMemberInfoWithrequest:request];
//            }
//        }
//    }
//}
//
//
//- (void)upMicro {
//    NSString *position = [self findFreePosition];
//    if (position.length > 0) {
//        [self upMircoSerialWithSerial:position];
//    }
//}
//
//
//
////邀请上麦
//- (void)inviteOnMic:(UserID)uid {
//    if (GetCore(RoomCore).isInRoom) {
//        NSString *position = [self findFreePosition];
//        if (position.length == 0) {
//             NotifyCoreClient(RoomCoreClient, @selector(thereIsNoFreePosition), thereIsNoFreePosition);
//        }else {
//            RoomQueue *roomQueue = [[RoomQueue alloc]init];
//            roomQueue.queueType = QUEUE_TYPE_FREE;
//            RoomQueueAttachment *roomQueueAttachment = [[RoomQueueAttachment alloc]init];
//            //        roomQueueAttachment.first = Custom_Noti_Header_Queue;
//            //        roomQueueAttachment.second = Custom_Noti_Sub_Queue_Invite;
//            roomQueueAttachment.uid = uid;
//            roomQueueAttachment.roomQueue = roomQueue;
//            //        roomQueueAttachment.data = roomQueueAttachment.encodeAttachment;
//            Attachment *attachement = [[Attachment alloc]init];
//            attachement.first = Custom_Noti_Header_Queue;
//            attachement.second = Custom_Noti_Sub_Queue_Invite;
//            attachement.data = roomQueueAttachment.encodeAttachment;
//
//            [GetCore(ImMessageCore)sendCustomMessageAttachement:attachement sessionId:[NSString stringWithFormat:@"%ld",(long)GetCore(RoomCore).currentRoomInfo.roomId] type:NIMSessionTypeChatroom];
//        }
//
//    }
//}
//
////踢人下麦
//- (void)kiedMircoWithUid:(UserID)uid {
//    if (GetCore(RoomCore).isInRoom) {
//        RoomQueue *roomQueue = [[RoomQueue alloc]init];
//        roomQueue.queueType = QUEUE_TYPE_FREE;
//        RoomQueueAttachment *roomQueueAttachment = [[RoomQueueAttachment alloc]init];
//        roomQueueAttachment.uid = uid;
//        roomQueueAttachment.roomQueue = roomQueue;
//
//        Attachment *attachement = [[Attachment alloc]init];
//        attachement.first = Custom_Noti_Header_Queue;
//        attachement.second = Custom_Noti_Sub_Queue_Kick;
//        attachement.data = roomQueueAttachment.encodeAttachment;
//
//        [GetCore(ImMessageCore)sendCustomMessageAttachement:attachement sessionId:[NSString stringWithFormat:@"%ld",(long)GetCore(RoomCore).currentRoomInfo.roomId] type:NIMSessionTypeChatroom];
//    }
//}
//
////锁麦位
//- (void)lockThePositionWithSerial:(NSString *)serial {
//    if (GetCore(RoomCore).isInRoom) {
//        RoomQueue *roomQueue = [self.micQueue objectForKey:serial].roomQueue;
//        if (roomQueue != nil) {
//            roomQueue.queueType = QUEUE_TYPE_LOCK;
//            [self updateGameRoomMircoMembersWithserial:serial queue:roomQueue success:^(BOOL success) {
//
//            } failure:^(NSString *message) {
//
//            }];
//        } else {
//            RoomQueue *roomQueue = [[RoomQueue alloc]init];
//            roomQueue.queueType = QUEUE_TYPE_LOCK;
//            [self updateGameRoomMircoMembersWithserial:serial queue:roomQueue success:^(BOOL success) {
//
//            } failure:^(NSString *message) {
//
//            }];
//        }
//    }
//}
//
////解锁麦序
//- (void)unlockThePositionWithSerial:(NSString *)serial {
//    if (GetCore(RoomCore).isInRoom) {
//        RoomQueue *roomQueue = [self.micQueue objectForKey:serial].roomQueue;
//        if (roomQueue != nil) {
//            roomQueue.queueType = QUEUE_TYPE_FREE;
//            [self updateGameRoomMircoMembersWithserial:serial queue:roomQueue success:^(BOOL success) {
//
//            } failure:^(NSString *message) {
//
//            }];
//        }else {
//            RoomQueue *roomQueue = [[RoomQueue alloc]init];
//            roomQueue.queueType = QUEUE_TYPE_FREE;
//            [self updateGameRoomMircoMembersWithserial:serial queue:roomQueue success:^(BOOL success) {
//
//            } failure:^(NSString *message) {
//
//            }];
//        }
//    }
//}
//
////禁麦
//- (void)muteThePositionWithSerial:(NSString *)serial {
//    if (GetCore(RoomCore).isInRoom) {
//        RoomQueue *roomQueue = [self.micQueue objectForKey:serial].roomQueue;
//        if (roomQueue != nil && !roomQueue.isMute) {
//            roomQueue.isMute = YES;
//            [self updateGameRoomMircoMembersWithserial:serial queue:roomQueue success:^(BOOL success) {
//
//            } failure:^(NSString *message) {
//
//            }];
//        }else if (!roomQueue.isMute) {
//            RoomQueue *roomQueue = [[RoomQueue alloc]init];
//            roomQueue.isMute = YES;
//            [self updateGameRoomMircoMembersWithserial:serial queue:roomQueue success:^(BOOL success) {
//
//            } failure:^(NSString *message) {
//
//            }];
//        }
//    }
//}
//
////解除禁麦
//- (void)activeThePositionWithSerial:(NSString *)serial {
//    if (GetCore(RoomCore).isInRoom) {
//        RoomQueue *roomQueue = [self.micQueue objectForKey:serial].roomQueue;
//        if (roomQueue != nil && roomQueue.isMute) {
//            roomQueue.isMute = NO;
//            [self updateGameRoomMircoMembersWithserial:serial queue:roomQueue success:^(BOOL success) {
//
//            } failure:^(NSString *message) {
//
//            }];
//        }else if (roomQueue != nil && !roomQueue.isMute) {
//            RoomQueue *roomQueue = [[RoomQueue alloc]init];
//            roomQueue.isMute = NO;
//            [self updateGameRoomMircoMembersWithserial:serial queue:roomQueue success:^(BOOL success) {
//
//            } failure:^(NSString *message) {
//
//            }];
//        }
//    }
//
//}
//
//#pragma mark - RoomCoreClient
//- (void)userBeAddBlack:(NIMChatroomMember *)member {
//
//    NSMutableArray *temp2 = [NSMutableArray array];
//    for (NIMChatroomMember *item in self.allMembers) {
//        if (item.userId.userIDValue != member.userId.userIDValue) {
//            [temp2 addObject:item];
//        }
//    }
//    [self fetchMembersSuccess:temp2];
//
//}
//
//- (void)userBeRemoveBlack:(NSString *)userId {
//    NSMutableArray *temp = [NSMutableArray array];
//    for (NIMChatroomMember *item in self.backList) {
//        if (item.userId.userIDValue != userId.userIDValue) {
//            [temp addObject:item];
//        }
//    }
//    self.backList = temp;
//}
//
//- (void)onManagerRemove:(NIMChatroomMember *)member {
//    NSMutableArray *temp = [NSMutableArray array];
//    for (NIMChatroomMember *item in self.allMembers) {
//        if (item.userId.userIDValue != member.userId.userIDValue) {
//            [temp addObject:item];
//        }
//    }
//    if (member.userId.userIDValue == [GetCore(AuthCore)getUid].userIDValue) {
//        self.myMember = member;
//    }
//    if (member.isOnline) {
//        [temp insertObject:member atIndex:0];
//        [self fetchMembersSuccess:temp];
//    }
//}
//
//- (void)onManagerAdd:(NIMChatroomMember *)member {
//    NSMutableArray *temp = [NSMutableArray array];
//    for (NIMChatroomMember *item in self.allMembers) {
//        if (item.userId.userIDValue != member.userId.userIDValue) {
//            [temp addObject:item];
//        }
//    }
//    if (member.userId.userIDValue == [GetCore(AuthCore)getUid].userIDValue) {
//        self.myMember = member;
//    }
//    if (member.isOnline) {
//        [temp insertObject:member atIndex:0];
//        [self fetchMembersSuccess:temp];
//    }
//
//
//}
//
////上麦，下麦，跳坑
//- (void)userInfoUpdateWithInfo:(NIMChatroomMember *)member {
//
//    NSMutableArray *temp = [NSMutableArray array];
//    for (NIMChatroomMember *item in self.allMembers) {
//        if (item.userId.userIDValue != member.userId.userIDValue) {
//            [temp addObject:item];
//        }
//    }
//
//    [temp insertObject:member atIndex:0];
//    [self fetchMembersSuccess:temp];
//
//}
//
//- (void)userInterRoomWith:(NIMChatroomMember *)member {
//
//    NSMutableArray *temp = [NSMutableArray array];
//    for (NIMChatroomMember *item in self.allMembers) {
//        if (item.userId.userIDValue != member.userId.userIDValue) {
//            [temp addObject:item];
//        }
//    }
//
//    if (member.userId.userIDValue == [GetCore(RoomCore)getCurrentRoomInfo].uid) {
//        self.roomOwner = member;
//    }
//
//    [temp insertObject:member atIndex:0];
//    [self fetchMembersSuccess:temp];
//}
//
//- (void)userExitChatRoomWith:(NSString *)userId {
//
//    NSMutableArray *temp = [NSMutableArray array];
//    for (NIMChatroomMember *item in self.allMembers) {
//        if (item.userId.userIDValue != userId.userIDValue) {
//            [temp addObject:item];
//        }
//    }
//    if (userId.userIDValue == self.roomOwner.userId.userIDValue) {
//        self.roomOwner = nil;
//    }
//    [self fetchMembersSuccess:temp];
//
//}
////查询成员成功
//- (void)fetchMembersSuccess:(NSMutableArray *)members {
//    [self resetAllQueue];
//
//    UserID roomOwnerUid = [GetCore(RoomCore)getCurrentRoomInfo].uid;
//    UserID myUid = [GetCore(AuthCore) getUid].userIDValue;
//    NSMutableArray *temp = [NSMutableArray array];
//    for (NIMChatroomMember *item in members) {
//        if (item.userId.userIDValue != roomOwnerUid) {
//            [temp addObject:item];
//        }else {
//            self.roomOwner = item;
//        }
//        if (item.userId.userIDValue == myUid) {
//            self.myMember = item;
//        }
//    }
//    self.allMembers = temp;
//    for (NIMChatroomMember *member in temp) {
//        if (member.roomExt.length > 0 ) {
//            NSDictionary *dic = [NSString dictionaryWithJsonString:member.roomExt];
//            NSString * position =[dic objectForKey:ROOM_UPDATE_KEY_POSTION];
//            NSInteger gender = [[dic objectForKey:ROOM_UPDATE_KEY_GENDER] integerValue];
//
//            if (position.length > 0) {
//                [self.micMembers addObject:member];
//                RoomQueueMemberInfo *info = [self.micQueue objectForKey:position];
//                info.chatRoomMember = member;
////                info.roomQueue = roomQueue;
//                info.gender = gender;
//
//                [self.micQueue safeSetObject:info forKey:position];
//
//                if (member.type == NIMChatroomMemberTypeManager) { //麦上的管理员
//                    [self.mamagerMembers addObject:member];
//                }
//
//
//            }else {
//                if (member.type == NIMChatroomMemberTypeManager) { //麦下的管理员
//                    [self.mamagerMembers addObject:member];
//                }
//                [self.guestMembers addObject:member];
//
//            }
//        }else {
//            if (member.type == NIMChatroomMemberTypeManager) { //不在麦上的管理员
//                [self.mamagerMembers addObject:member];
//            }
//            [self.guestMembers addObject:member];
//        }
//    }
//    self.isLoad = YES;
////    NSLog(@"self.allMembers.count -------- >%lu",(unsigned long)self.allMembers.count);
//    [YYLogger info:@"fixAllMemberSuccess" message:@"success--->stat:%ld",self.allMembers.count];
//    NotifyCoreClient(RoomQueueCoreClient, @selector(fetchRoomUserListSuccess), fetchRoomUserListSuccess);
//}
//
//
//#pragma mark - ImMessageCoreClient
//- (void)onRecvChatRoomCustomMsg:(NIMMessage *)msg {
//    NIMCustomObject *customObject = (NIMCustomObject *)msg.messageObject;
//    if (customObject.attachment) {
//        Attachment *attachment = (Attachment *)customObject.attachment;
//        [self handelCustomerMessage:attachment];
//    }
//}
//
//#pragma mark - ImRoomCoreClient
//
//- (void)onConnectionStateChanged:(NIMChatroomConnectionState)state {
//    if (state == NIMChatroomConnectionStateEnterOK) {
//        RoomInfo *info =[GetCore(RoomCore)getCurrentRoomInfo];
//        if (info != nil) {
//            [self repairMicQueue];
//            [self getRoomMicroMembersWithRoomID:[NSString stringWithFormat:@"%ld",(long)info.roomId]];
//            [GetCore(RoomCore)fetchRoomRegularMembers];
////            if (GetCore(MeetingCore).actor) {
////                NSString * position = [self findPositionByMember:[GetCore(AuthCore) getUid]];
//            if (self.isReConnect) {
//                if (self.position.length > 0) {
//                    if ([self findTheRoomQueueMemberInfo:[GetCore(AuthCore)getUid].userIDValue].roomQueue.queueType == QUEUE_TYPE_FREE) {
//                        [self upMircoSerialWithSerial:self.position];
////                        [GetCore(MeetingCore)joinMeeting:[NSString stringWithFormat:@"%ld",(long)[GetCore(RoomCore)getCurrentRoomInfo].roomId] actor:YES];
//                    }
//                }else {
////                    [GetCore(MeetingCore)joinMeeting:[NSString stringWithFormat:@"%ld",(long)[GetCore(RoomCore)getCurrentRoomInfo].roomId] actor:NO];
//                }
//                self.isReConnect = NO;
//                self.position = nil;
//            }
//
////            }
//        }
//
//    }else if (state == NIMChatroomConnectionStateLoseConnection) {
////        [GetCore(MeetingCore) leaveMeeting:[NSString stringWithFormat:@"%ld",(long)[GetCore(RoomCore)getCurrentRoomInfo].roomId]];
//        if ([self isOnMicro:[GetCore(AuthCore)getUid].userIDValue]) {
//            self.position = [self findPositionByMember:[GetCore(AuthCore) getUid]];
//            self.isReConnect = YES;
//        }
//    }
//}
//
////队列改变
//- (void)onRoomQueueUpdate:(NIMMessage *)message {
//    if (GetCore(RoomCore).isInRoom) {
//        if (message.messageType == NIMMessageTypeNotification) {
//            NIMNotificationObject *notiMsg = (NIMNotificationObject *)message.messageObject;
//            NIMChatroomNotificationContent *content = (NIMChatroomNotificationContent *)notiMsg.content;
//            if (content.eventType == NIMChatroomEventTypeQueueChange) {
//                NSDictionary *temp = (NSDictionary *)content.ext;
//                RoomQueue *roomQueue = [RoomQueue yy_modelWithJSON:[temp objectForKey:NIMChatroomEventInfoQueueChangeItemValueKey]];
//                [self changeMicState:[temp objectForKey:NIMChatroomEventInfoQueueChangeItemKey] roomQueue:roomQueue uid:content.source.userId.userIDValue];
//                RoomQueueMemberInfo *roomQueueMember = [self.micQueue objectForKey:[temp objectForKey:NIMChatroomEventInfoQueueChangeItemKey]];
//                if (roomQueueMember != nil) {
//                    roomQueueMember.roomQueue = roomQueue;
//                    [self.micQueue setObject:roomQueueMember forKey:[temp objectForKey:NIMChatroomEventInfoQueueChangeItemKey]];
//                    NotifyCoreClient(RoomQueueCoreClient, @selector(onMicroQueueUpdate:), onMicroQueueUpdate:self.micQueue);
//                }
//
//            }
//        }
//
//    }
//}
//
////获取麦序
//- (void)onGetRoomQueueSuccess:(NSArray<NSDictionary<NSString *,NSString *> *> *)info {
//    [self resetMicQueueQueueInfo];
//    if (info) {
//        for (NSDictionary *item in info) {
//            NSArray *keys = [item allKeys];
//            for (NSString *key in keys) {
//                if ([key integerValue] < 8 && [key integerValue] >= 0) {
//                    NSString *jsonStr = [item objectForKey:key];
//                    RoomQueue *queue = [RoomQueue yy_modelWithJSON:jsonStr];
//                    RoomQueueMemberInfo *memberInfo = [self.micQueue objectForKey:key];
//                    memberInfo.roomQueue = queue;
//                    [self.micQueue safeSetObject:memberInfo forKey:key];
//                }
//            }
//        }
//
//        NotifyCoreClient(RoomQueueCoreClient, @selector(onMicroQueueUpdate:), onMicroQueueUpdate:self.micQueue);
//    }
//}
////房间信息更新成功
//- (void)onUpdateRoomMemberInfoSuccess:(NIMChatroomMemberInfoUpdateRequest *)request{
//    if (request) {
//        NSString *json = [request.updateInfo objectForKey:@(NIMChatroomMemberInfoUpdateTagExt)];
////        if (json.length > 0) {
//            NSDictionary * dic = [NSString dictionaryWithJsonString:json];
//            NSString * position =[dic objectForKey:ROOM_UPDATE_KEY_POSTION];
//            if (position.length > 0) {
//                if ([self.micQueue objectForKey:position]) {
//                   RoomQueue *roomQueue = [self.micQueue objectForKey:position].roomQueue;
//                    if (self.needCloseMicro) {
//                        if (roomQueue.isMute) {
//                            [GetCore(MeetingCore)setMeetingRole:NO];
////                            [GetCore(MeetingCore)setCloseMicro:YES];
//                        }else {
//                            [GetCore(MeetingCore)setMeetingRole:YES];
//                            [GetCore(MeetingCore)setCloseMicro:YES];
//                        }
//                    }else {
//                        if (roomQueue.isMute) {
//                            [GetCore(MeetingCore)setMeetingRole:NO];
////                            [GetCore(MeetingCore)setCloseMicro:YES];
//                        }else {
//                            [GetCore(MeetingCore)setMeetingRole:YES];
////                            [GetCore(MeetingCore)setCloseMicro:NO];
//                        }
//                    }
//
//                }
//            }else {
//                [GetCore(MeetingCore)setMeetingRole:NO];
////                [GetCore(MeetingCore)setCloseMicro:YES];
//            }
////        }
//        NotifyCoreClient(RoomQueueCoreClient, @selector(onMicroStateChange), onMicroStateChange);
////        [GetCore(RoomCore)fetchRoomMembers]; //刷新游客列表
//    }
//
//}
//
//- (void)onMeInterChatRoomSuccess {
//    [self repairMicQueue];
//
//    if (GetCore(RoomCore).currentRoomInfo.type == RoomType_Game) {
////        for (int i = 0; i <= 7; i++) {
////            RoomQueue *queue = [[RoomQueue alloc]init];
////            [self.microList setObject:queue forKey:[NSString stringWithFormat:@"%d",i]];
////        }
//
//        [self getRoomMicroMembersWithRoomID:[NSString stringWithFormat:@"%ld",(long)GetCore(RoomCore).currentRoomInfo.roomId]];
//    }
//}
//
//
//- (void)onMeExitChatRoomSuccessV2 {
//    self.isRoomOwnerSpeaking = NO;
//    [self.speakMembersUid removeAllObjects];
//    [self.allMembers removeAllObjects];
//    [self.guestMembers removeAllObjects];
//    [self.micMembers removeAllObjects];
//    [self.mamagerUsers removeAllObjects];
//    [self.backListUsers removeAllObjects];
//    self.micQueue = nil;
//    self.myMember = nil;
//    self.roomOwner = nil;
//    self.needCloseMicro = NO;
//    self.isLoad = NO;
//}
//
//#pragma mark - Private
//
//- (NSMutableArray *)findSendGiftMember {
//    NSMutableArray *temp = [NSMutableArray array];
//    if (self.roomOwner != nil) {
//        [temp addObject:self.roomOwner];
//    }
//
//    for (int i = 0; i < MIC_COUNT; i++) {
//         RoomQueueMemberInfo *roomQueueMemberInfo =[self.micQueue objectForKey:[NSString stringWithFormat:@"%d",i]];
//        if (roomQueueMemberInfo.chatRoomMember != nil) {
//            [temp addObject:roomQueueMemberInfo.chatRoomMember];
//        }
//    }
//
//    return temp;
//
//}
//
//
//- (RoomQueueMemberInfo *)findTheRoomQueueMemberInfo:(UserID)uid {
//    NSArray *keys = [self.micQueue allKeys];
//    for (NSString *key in keys) {
//        RoomQueueMemberInfo *info = [self.micQueue objectForKey:key];
//        if (info.chatRoomMember.userId.userIDValue == uid) {
//            return info;
//        }
//    }
//    return nil;
//}
//
//- (void)resetMicQueueChatRoomMember {
//    for (int i = 0 ; i < MIC_COUNT; i++) {
//        RoomQueueMemberInfo *roomQueueMemberInfo = [self.micQueue objectForKey:[NSString stringWithFormat:@"%d",i]];
//        if (roomQueueMemberInfo != nil) {
//            roomQueueMemberInfo.chatRoomMember = nil;
//        }
//
////        [self.micQueue setObject:roomQueueMemberInfo forKey:[NSString stringWithFormat:@"%d",i]];
//
//    }
//}
//
//- (void)resetMicQueueQueueInfo {
//    for (int i = 0 ; i < MIC_COUNT; i++) {
//        RoomQueueMemberInfo *roomQueueMemberInfo = [self.micQueue objectForKey:[NSString stringWithFormat:@"%d",i]];
//        if (roomQueueMemberInfo != nil) {
//            RoomQueue *roomQueue = [[RoomQueue alloc]init];
//            roomQueue.queueType = QUEUE_TYPE_FREE;
//            roomQueue.isMute = NO;
//            roomQueueMemberInfo.roomQueue = roomQueue;
//        }
//
////        [self.micQueue setObject:roomQueueMemberInfo forKey:[NSString stringWithFormat:@"%d",i]];
//    }
//}
//
//- (void)repairMicQueue {
//    for (int i = 0 ; i < MIC_COUNT; i++) {
//        RoomQueue *roomQueue = [[RoomQueue alloc]init];
//        roomQueue.queueType = QUEUE_TYPE_FREE;
//        RoomQueueMemberInfo *roomQueueMemberInfo = [[RoomQueueMemberInfo alloc]init];
//        roomQueueMemberInfo.roomQueue = roomQueue;
//        roomQueueMemberInfo.chatRoomMember = nil;
//        [self.micQueue setObject:roomQueueMemberInfo forKey:[NSString stringWithFormat:@"%d",i]];
//    }
//}
//
//- (void)changeMicState:(NSString *)key roomQueue:(RoomQueue *)roomQueue uid:(UserID)uid  {
//    RoomQueueMemberInfo *roomQueueMemberInfo = [self.micQueue objectForKey:key];
//    if (roomQueueMemberInfo != nil) {
//        NIMChatroomMember *chatRoomMember = roomQueueMemberInfo.chatRoomMember;
//        if (chatRoomMember != nil) {
//            UserID uid = [GetCore(AuthCore) getUid].userIDValue;
//            if (uid == chatRoomMember.userId.userIDValue) {
//                if (roomQueue.isMute) {
//                    [GetCore(MeetingCore) setActor:NO];
//                    [GetCore(MeetingCore) setCloseMicro:YES];
//                    NotifyCoreClient(RoomQueueCoreClient, @selector(onMicroLocked), onMicroLocked);
//                } else {
//                    [GetCore(MeetingCore) setActor:YES];
////                    [GetCore(MeetingCore) setCloseMicro:NO];
//                    NotifyCoreClient(RoomQueueCoreClient, @selector(onMicroUnLocked), onMicroUnLocked);
//                }
//                NotifyCoreClient(RoomQueueCoreClient, @selector(onMicroStateChange), onMicroStateChange);
//            }
//        }
//    }
//}
//
//- (NSString *)findPositionByMember:(NSString *)uid {
//    if (self.micQueue != nil && self.micQueue.count> 0) {
//        NSArray *keys = [self.micQueue allKeys];
//        if (keys.count > 0) {
//            for (NSString *key in keys) {
//                RoomQueueMemberInfo *roomQueue = [self.micQueue objectForKey:key];
//                if (roomQueue.chatRoomMember.userId.userIDValue == uid.userIDValue) {
//                    return key;
//                }
//            }
//        }
//        return nil;
//    }
//    return nil;
//}
//
//- (void)resetAllQueue {
////    self.micQueue = nil;
//    [self resetMicQueueChatRoomMember];
////    [self.allMembers removeAllObjects];
//    [self.guestMembers removeAllObjects];
////    [self.micMembers removeAllObjects];
//    self.micMembers = nil;
//    self.mamagerMembers = nil;
//    self.backList = nil;
//    self.mamagerUsers = nil;
//    self.backListUsers = nil;
////    self.myMember = nil;
////    [self.mamagerMembers removeAllObjects];
//}
//
////- (void)resetMicQueueQueueInfo {
////    self.micQueue = nil;
////}
//
//- (BOOL)isSpeaking:(UserID)uid {
//    if (self.speakMembersUid != nil && self.speakMembersUid.count >0) {
//        if ([self.speakMembersUid containsObject:[NSString stringWithFormat:@"%lld",uid]]) {
//            return YES;
//        }
//    }
//    return NO;
//}
//
//- (NSString *)findFreePosition {
//    if (self.micQueue != nil && self.micQueue.count > 0) {
//        NSArray *keys = [self.micQueue allKeys];
//        if (keys.count > 0) {
//            for (NSString *key in keys) {
//                RoomQueue *roomQueue = [self.micQueue objectForKey:key].roomQueue;
//                NIMChatroomMember *member = [self.micQueue objectForKey:key].chatRoomMember;
//                if (roomQueue.queueType == QUEUE_TYPE_FREE) {
//                    if (!member) {
//                       return key;
//                    }
//                }
//            }
//        }
//    }
//    return nil;
//}
//
//- (NSString *)findThePositionByUid:(UserID)uid {
//    if (uid > 0) {
//        NSArray *keys = [self.micQueue allKeys];
//        if (keys.count > 0) {
//            for (NSString *key in self.micQueue) {
//                NIMChatroomMember *member = [self.micQueue objectForKey:key].chatRoomMember;
//                if (member.userId.userIDValue == uid) {
//                    return key;
//                }
//            }
//        }
//    }
//    return nil;
//}
//
//- (NIMChatroomMember *)findTheMemberByUserId:(UserID)uid {
//    for (NIMChatroomMember *item in self.displayAllMembers) {
//        if (item.userId.userIDValue == uid) {
//            return item;
//        }
//    }
//    return nil;
//}
//
//- (void)handelCustomerMessage:(Attachment *)attachment {
//    if (attachment.first == Custom_Noti_Header_Queue) {
//        RoomQueueAttachment *roomQueueAttachment = [RoomQueueAttachment yy_modelWithJSON:attachment.data];
//        UserID uid = [GetCore(AuthCore) getUid].userIDValue;
//        if (attachment.second == Custom_Noti_Sub_Queue_Invite) {
//            if (uid == roomQueueAttachment.uid) {
//                if (![self isOnMicro:uid]) {
//                    if ([GetCore(RoomCore)getCurrentRoomInfo].type == RoomType_Game) {
//                        self.needCloseMicro = YES;
//                        [self upMicro];
//                    }
//                }
//                NotifyCoreClient(RoomQueueCoreClient, @selector(onMicroBeInvite), onMicroBeInvite);
//            }
//        } else if (attachment.second == Custom_Noti_Sub_Queue_Kick) {
//            if (uid == roomQueueAttachment.uid) {
//                [self downMicro];
//                NotifyCoreClient(RoomQueueCoreClient, @selector(onMicroBeKicked), onMicroBeKicked);
//            }
//        }
//    }
//}
//
///**
// 判断是否在麦上
//
// @param uid 用户ID
// @return YES OR NO
// */
//- (BOOL)isOnMicro:(UserID)uid {
//    if (self.micMembers != nil && self.micMembers.count > 0) {
//        for (int i = 0; i < self.micMembers.count; i ++) {
//            NIMChatroomMember *chatRoomMember = self.micMembers[i];
//            if (chatRoomMember.userId.userIDValue == uid) {
//                return YES;
//            }
//        }
//    }
//    return NO;
//}
//
//- (void)updateGameRoomMircoMembersWithserial:(NSString *)serial
//                                       queue:(RoomQueue *)queue
//                                     success:(void (^)(BOOL success))success
//                                     failure:(void (^)(NSString *message))failure {
//
//    NSString *roomId = [NSString stringWithFormat:@"%ld",(long)GetCore(RoomCore).currentRoomInfo.roomId];
//    NIMChatroomQueueUpdateRequest *request = [[NIMChatroomQueueUpdateRequest alloc]init];
//    request.key = serial;
//    request.value = [queue yy_modelToJSONString];
//    request.roomId = roomId;
//    [[NIMSDK sharedSDK].chatroomManager updateChatroomQueueObject:request completion:^(NSError * _Nullable error) {
//        if (error == nil ) {
//            success(YES);
//        }else {
//            failure(error.description);
//        }
//    }];
//}
//
//#pragma mark - Getter
//
//- (NSMutableArray<NIMChatroomMember *> *)displayAllMembers {
//    if (_displayAllMembers == nil) {
//        _displayAllMembers = [NSMutableArray array];
//
//    }else {
//        if (_displayAllMembers.count > 0) {
//            [_displayAllMembers removeAllObjects];
//        }
//        if (_roomOwner != nil) {
//            [_displayAllMembers addObject:_roomOwner];
//        }
//        if (self.micMembers.count > 0) {
//            [_displayAllMembers addObjectsFromArray:self.micMembers];
//        }
//        if (self.guestMembers.count > 0) {
//            [_displayAllMembers addObjectsFromArray:self.guestMembers];
//        }
//    }
//    return _displayAllMembers;
//}
//
//- (NSMutableDictionary<NSString *,RoomQueueMemberInfo *> *)micQueue {
//    if (_micQueue == nil && _micQueue.count == 0) {
//        _micQueue = [NSMutableDictionary dictionary];
//    }
//    return _micQueue;
//}
//
//- (NSMutableArray<NIMChatroomMember *> *)guestMembers {
//    if (_guestMembers == nil) {
//        _guestMembers = [[NSMutableArray alloc]init];
//    }
//    return _guestMembers;
//}
//
//- (NSMutableArray<NIMChatroomMember *> *)micMembers {
//    if (_micMembers == nil) {
//        _micMembers = [[NSMutableArray alloc]init];
//    }
//    return _micMembers;
//}
//
//- (NSMutableArray<NIMChatroomMember *> *)allMembers {
//    if (_allMembers == nil) {
//        _allMembers = [[NSMutableArray alloc]init];
//    }
//    return _allMembers;
//}
//
//- (NSMutableArray<NIMChatroomMember *> *)mamagerMembers {
//    if (_mamagerMembers == nil) {
//        _mamagerMembers = [[NSMutableArray alloc]init];
//    }
//    return _mamagerMembers;
//}
//
//- (NSMutableArray<NIMChatroomMember *> *)backList {
//    if (_backList == nil) {
//        _backList = [NSMutableArray array];
//    }
//    return _backList;
//}
//
//- (NSMutableArray<NIMUser *> *)backListUsers {
//    if (_backListUsers == nil) {
//        _backListUsers = [NSMutableArray array];
//    }
//    return _backListUsers;
//}
//
//- (NSMutableArray<NIMUser *> *)mamagerUsers {
//    if (_mamagerUsers == nil) {
//        _mamagerUsers = [NSMutableArray array];
//    }
//    return _mamagerUsers;
//}
//
//@end
//
