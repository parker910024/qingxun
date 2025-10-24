
//
//  ImRoomCoreV2.m
//  BberryCore
//
//  Created by Mac on 2017/12/8.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "ImRoomCoreV2.h"
#import "ImRoomCoreClient.h"
#import "ImRoomCoreClientV2.h"

#import "AuthCore.h"
#import "UserCore.h"
#import "RoomCoreV2.h"
#import "MeetingCore.h"

#import "ImMessageCore.h"
#import "ImMessageCoreClient.h"
#import "ImLoginCore.h"
#import "ImLoginCoreClient.h"
#import "PhoneCallCoreClient.h"
#import "AppScoreClient.h"
#import "ImPublicChatroomCore.h"

#import <NSObject+YYModel.h>
#import "NSMutableDictionary+Safe.h"
#import "NSString+JsonToDic.h"
#import "NSDictionary+JSON.h"
#import "NobleSourceTool.h"
#import "XCLogger.h"

#import "MessageCollection.h"
#import "ImRoomExtMapKey.h"

#define MIC_COUNT(Type) [self roomTypecpORnormal:Type]

//聊天室成员平台角色拓展字段
NSString *const XCChatroomMemberExtPlatformRole = @"platformRole";

//房间在线人数校准最大值
static NSInteger const XCRoomOnlineMemberAdjustMaximum = 10;

@interface ImRoomCoreV2()<NIMChatroomManagerDelegate, ImMessageCoreClient, ImLoginCoreClient, PhoneCallCoreClient>
@property (nonatomic, assign) int state;//记录刷新的方式
@property (nonatomic, strong) NSTimer *onLineTimer;//获取在线人数/10s

/**
 当前房间超管ID集合
 */
@property (nonatomic, strong) NSMutableSet<NSString *> *superAdmins;

@end

@implementation ImRoomCoreV2

//  给宏定义赋值
-(NSInteger )roomTypecpORnormal:(RoomType )type{
    if (type == RoomType_CP) {
        return 2;
    }else if (type == RoomType_Game){
        return 9;
    }else{
        return 9;
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        AddCoreClient(ImMessageCoreClient, self);
        AddCoreClient(ImLoginCoreClient, self);
        AddCoreClient(PhoneCallCoreClient, self);
        [[NIMSDK sharedSDK].chatroomManager addDelegate:self];
    }
    return self;
}

- (void)dealloc{
    RemoveCoreClient(ImMessageCoreClient, self);
    RemoveCoreClient(ImLoginCoreClient, self);
    RemoveCoreClient(PhoneCallCoreClient, self);
    [[NIMSDK sharedSDK].chatroomManager removeDelegate:self];
}


#pragma mark - ImLoginCoreClient
- (void)onImKick{
    if (self.currentChatRoom != nil) {
        [self exitChatRoom:self.currentChatRoom.roomId.integerValue];
    }
}

- (void)onImLogoutSuccess{
    if (self.currentChatRoom != nil) {
        [self exitChatRoom:self.currentChatRoom.roomId.integerValue];
    }
}

#pragma mark - NIMChatroomManagerDelegate
- (void)chatroomBeKicked:(NIMChatroomBeKickedResult *)result{
    if (projectType() == ProjectType_LookingLove && result.ext && [[[[NSString dictionaryWithJsonString:result.ext] objectForKey:@"role"] stringValue] isEqualToString:@"1"]) {
         NotifyCoreClient(ImRoomCoreClient, @selector(onUserBeKicked:kickResult:), onUserBeKicked:result.roomId kickResult:result);
    }else {
       NotifyCoreClient(ImRoomCoreClient, @selector(onUserBeKicked:reason:), onUserBeKicked:result.roomId reason:result.reason);
    }
   
    self.currentChatRoom = nil;
    self.currentRoomInfo = nil;
    [[XCLogger shareXClogger]sendLog:@{EVENT_ID:CImKick,@"uid":[GetCore(AuthCore) getUid],@"room_id":result.roomId} error:nil topic:IMLog logLevel:(XCLogLevel)XCLogLevelVerbose];
}


- (void)chatroom:(NSString *)roomId connectionStateChanged:(NIMChatroomConnectionState)state{
    [[XCLogger shareXClogger]sendLog:@{EVENT_ID:CImChannel,@"room_id":roomId,@"roomUid":[NSString stringWithFormat:@"%lld",self.currentRoomInfo.uid],@"type":@"3"} error:nil topic:IMLog logLevel:XCLogLevelVerbose];
    NotifyCoreClient(ImRoomCoreClient, @selector(onConnectionStateChanged:), onConnectionStateChanged:state);
}

- (void)chatroom:(NSString *)roomId autoLoginFailed:(NSError *)error{
}

#pragma mark - PhoneCallCoreClient
- (void)onStartPhoneCallSuccess:(UserID)callUid{
    if (self.currentChatRoom !=nil) {
        [self exitChatRoom:self.currentChatRoom.roomId.integerValue];
    }
}

- (void)onResponsePhoneCall:(NSString *)from accept:(BOOL)accept{
    if (accept && self.currentChatRoom != nil) {
        [self exitChatRoom:self.currentChatRoom.roomId.integerValue];
    }
}



#pragma mark - ImMessageCoreClient
- (void)onRecvChatRoomNotiMsg:(NIMMessage *)msg{
    if ([msg.session.sessionId integerValue] == GetCore(ImRoomCoreV2).currentRoomInfo.roomId) {
        NIMNotificationObject *notiMsg = (NIMNotificationObject *)msg.messageObject;
        
        NIMChatroomNotificationContent *content = (NIMChatroomNotificationContent *)notiMsg.content;
        switch (content.eventType) {
            case NIMChatroomEventTypeEnter:
                [self handleNotificationMessage:msg];
                break;
            case NIMChatroomEventTypeExit: {
                UserInfo *inf = [GetCore(UserCore)getUserInfoInDB:msg.from.userIDValue];
                if (inf.platformRole == XCUserInfoPlatformRoleSuperAdmin) {
                    [self.superAdmins removeObject:msg.from];
                } else {
                    self.onlineNumber -= 1;
                }

                NotifyCoreClient(ImRoomCoreClient, @selector(onUserExitChatRoom:), onUserExitChatRoom:msg);
            }
                break;
            case NIMChatroomEventTypeAddBlack:
                self.onlineNumber -= 1;
                NotifyCoreClient(ImRoomCoreClient, @selector(onUserBeAddBlack:), onUserBeAddBlack:msg);
                break;
            case NIMChatroomEventTypeRemoveBlack:
                NotifyCoreClient(ImRoomCoreClient, @selector(onUserBeRemoveBlack:), onUserBeRemoveBlack:msg);
                break;
            case NIMChatroomEventTypeAddMute:
                break;
            case NIMChatroomEventTypeRemoveMute:
                break;
            case NIMChatroomEventTypeMemberUpdateInfo://修改自己ext字段
                NotifyCoreClient(ImRoomCoreClient, @selector(onReceiveChatRoomMemberInfoUpdateMessages:), onReceiveChatRoomMemberInfoUpdateMessages:msg);
                break;
            case NIMChatroomEventTypeRemoveManager:
                [self handleNotificationMessage:msg];
                NotifyCoreClient(ImRoomCoreClient, @selector(managerRemove:), managerRemove:msg);
                break;
            case NIMChatroomEventTypeAddManager:
                [self handleNotificationMessage:msg];
                NotifyCoreClient(ImRoomCoreClient, @selector(managerAdd:), managerAdd:msg);
                break;
            case NIMChatroomEventTypeKicked:
                self.onlineNumber -= 1;
                NotifyCoreClient(ImRoomCoreClient, @selector(onUserExitChatRoom:), onUserExitChatRoom:msg);
                NotifyCoreClient(ImRoomCoreClient, @selector(onUserBeKicked:), onUserBeKicked:msg);
                break;
            case NIMChatroomEventTypeInfoUpdated://麦序状态，房间信息，房间背景
                NotifyCoreClient(ImRoomCoreClient, @selector(onRoomInfoUpdate:), onRoomInfoUpdate:msg);
                break;
            case NIMChatroomEventTypeQueueChange://队列上下麦
                NotifyCoreClient(ImRoomCoreClient, @selector(onRoomQueueUpdate:), onRoomQueueUpdate:msg);
                break;
            default:
                break;
        }
    } else if ([msg.session.sessionId integerValue] == GetCore(ImPublicChatroomCore).publicChatroomId) {
        NIMNotificationObject *notiMsg = (NIMNotificationObject *)msg.messageObject;
        
        NIMChatroomNotificationContent *content = (NIMChatroomNotificationContent *)notiMsg.content;
        
        switch (content.eventType) {
            case NIMChatroomEventTypeAddMuteTemporarily:
                NotifyCoreClient(ImRoomCoreClient, @selector(onUserHaveBannedForChatRoom:), onUserHaveBannedForChatRoom:msg);
                break;
            default:
                break;
        }
    }
}

// 收到更新铭牌的信息，更新自己的member
- (void)onUpdateNameplate {
    [[GetCore(UserCore) getUserInfoByRac:[GetCore(AuthCore) getUid].userIDValue refresh:YES]subscribeNext:^(id x) {
        if (x) {
            UserInfo *userInfo = (UserInfo *)x;
            NSMutableDictionary *roomExtDict = [NSMutableDictionary dictionary];
            NSDictionary *ext = [NSString dictionaryWithJsonString:self.myMember.roomExt];
            if (!ext) {
                ext = [NSDictionary new];
            }
            NSMutableDictionary *userDict = [ext objectForKey:GetCore(AuthCore).getUid];
            if (userInfo.nameplate) {
                [userDict safeSetObject:userInfo.nameplate.fixedWord forKey:ImRoomExtKeyOfficialAnchorCertificationName];
                [userDict safeSetObject:userInfo.nameplate.iconPic forKey:ImRoomExtKeyOfficialAnchorCertificationIcon];
            } else {
                [userDict removeObjectForKey:ImRoomExtKeyOfficialAnchorCertificationName];
                [userDict removeObjectForKey:ImRoomExtKeyOfficialAnchorCertificationIcon];
            }
            [roomExtDict safeSetObject:userDict forKey:GetCore(AuthCore).getUid];
            self.myMember.roomExt = [roomExtDict toJSONWithPrettyPrint:YES];
        }
    }];
}

#pragma mark - puble method
- (void)enterChatRoom:(NSInteger )roomId{
    if (roomId <= 0) {
        return;
    }
    if (roomId == self.currentChatRoom.roomId.integerValue && projectType() != ProjectType_VKiss) {
        return;
    }
    self.isLoading = YES;
    
    NIMChatroomEnterRequest *request = [[NIMChatroomEnterRequest alloc] init];
    request.roomId = [NSString stringWithFormat:@"%ld", (long)roomId];

    NSLog(@"NIMChatroomEnterRequest ===== %@",request);
    UserInfo *userInfo = [GetCore(UserCore)getUserInfoInDB:[GetCore(AuthCore) getUid].userIDValue];
//    [GetCore(UserCore)getUserInfo:[GetCore(AuthCore) getUid].userIDValue refresh:YES success:^(UserInfo *userInfo) {
        SingleNobleInfo *nobleInfo = userInfo.nobleUsers;
        LevelInfo *levelInfo = userInfo.userLevelVo;
        UserCar *carInfo = userInfo.carport;
        
        //设置ext
        NSMutableDictionary *extSource = [NSMutableDictionary dictionary];
    
        //贵族ext
        if (nobleInfo && nobleInfo.level > 0) {
        
            extSource = [NobleSourceTool sortStringWithNobleInfo:nobleInfo];
            //移除多余的信息(云信有限制)
            [extSource removeObjectForKey:@"zoneBg"];
            [extSource removeObjectForKey:@"cardBg"];
            [extSource removeObjectForKey:@"expire"];
            [extSource removeObjectForKey:@"recomCount"];
        }
        //defUser
        [extSource safeSetObject:@(userInfo.defUser) forKey:@"defUser"];
        [extSource safeSetObject:userInfo.erbanNo forKey:@"erbanNo"];
        [extSource safeSetObject:@(userInfo.platformRole) forKey:XCChatroomMemberExtPlatformRole];

        //headwear
        if (userInfo.userHeadwear.effect.length && userInfo.userHeadwear.status == Headwear_Status_ok) {
            [extSource safeSetObject:userInfo.userHeadwear.effect forKey:@"pic"];
            [extSource safeSetObject:@(userInfo.userHeadwear.timeInterval) forKey:@"timeInterval"];
        }
        //level
        if (levelInfo) {
            [extSource safeSetObject:userInfo.userLevelVo.charmUrl forKey:@"charmUrl"];
            [extSource safeSetObject:userInfo.userLevelVo.experUrl forKey:@"experUrl"];
        }
        //new
        if (userInfo.newUser) {
            [extSource safeSetObject:@YES forKey:@"newUser"];
        }
        //pretty
        if (userInfo.hasPrettyErbanNo) {
            [extSource safeSetObject:@YES forKey:@"hasPrettyErbanNo"];
        }
        //tag
        if (userInfo.userTagList) {
            [extSource safeSetObject:userInfo.userTagList forKey:@"userTagList"];
        }
        //car
        if (carInfo) {
            [extSource safeSetObject:carInfo.name forKey:@"carName"];
        }
    
        //官方主播认证（认证名称和图片背景）
        if (userInfo.nameplate) {
            [extSource safeSetObject:userInfo.nameplate.fixedWord forKey:ImRoomExtKeyOfficialAnchorCertificationName];
            [extSource safeSetObject:userInfo.nameplate.iconPic forKey:ImRoomExtKeyOfficialAnchorCertificationIcon];
        }
    
        //从哪里进入房间
        if (GetCore(RoomCoreV2).fromType != JoinRoomFromType_Other) {
            [extSource safeSetObject:@(GetCore(RoomCoreV2).fromType) forKey:@"fromType"];
            [extSource safeSetObject:GetCore(RoomCoreV2).fromNick forKey:@"workAuthor"];
        }
    
    
        if (nobleInfo || levelInfo) {
            //{uid:extSource}
            NSMutableDictionary *ext = [NSMutableDictionary dictionaryWithObject:extSource forKey:[GetCore(AuthCore) getUid]];
            request.roomExt = [ext yy_modelToJSONString];
        }
    
        
        [[NIMSDK sharedSDK].chatroomManager enterChatroom:request completion:^(NSError * _Nullable error, NIMChatroom * _Nullable chatroom, NIMChatroomMember * _Nullable me) {
            
            if (error == nil) {

                if (chatroom == nil) {
                    NotifyCoreClient(ImRoomCoreClient, @selector(onMeInterChatRoomFailth), onMeInterChatRoomFailth);
                    return ;
                }
                
                [[BaiduMobStat defaultStat]eventStart:@"room_length_of_stay_time" eventLabel:@"在房间内停留时长"];
                [[BaiduMobStat defaultStat]logEvent:@"room_into" eventLabel:@"进入房间次数"];
                
                self.myMember = me;

                NSDictionary *info = [NSString dictionaryWithJsonString:chatroom.ext];
                self.currentRoomInfo = [RoomInfo yy_modelWithJSON:info[@"roomInfo"]];
                self.currentRoomInfo.roomId = [chatroom.roomId integerValue]; //需要重新赋值 服务端有时候会出问题，然后不返回roomid
                self.currentChatRoom = chatroom;
                
                NotifyCoreClient(ImRoomCoreClient, @selector(onMeInterChatRoomSuccess), onMeInterChatRoomSuccess);
                
                if (me.userId.userIDValue == self.currentRoomInfo.uid) {
                    self.roomOwner = me;
                    NotifyCoreClient(AppScoreClient, @selector(needShowScoreView:), needShowScoreView:SCORE_ONCEOPENROOM_ACCOUNTNAME);
                }else {
                    NotifyCoreClient(AppScoreClient, @selector(needShowScoreView:), needShowScoreView:SCORE_ONCEINTERROOM_ACCOUNTNAME);
                    [[self rac_queryChartRoomMemberByUid:[NSString stringWithFormat:@"%lld",self.currentRoomInfo.uid]] subscribeNext:^(id x) {
                        NIMChatroomMember *roomOwner = x;
                        if (roomOwner.isOnline) {
                            self.roomOwner = roomOwner;
                        }
                    }];
                }
                
                [self repairMicQueue];
                
                NSDictionary *micDictionary = [NSString dictionaryWithJsonString:info[@"micQueue"]];
                for (NSString *position in micDictionary.allKeys) {
                    
                    MicroState *state = [MicroState yy_modelWithJSON:micDictionary[position]];
                    ChatRoomMicSequence *sequence = [self.micQueue objectForKey:position];
                    sequence.microState = state;
                }
                
                [self queryQueueWithRoomId:self.currentChatRoom.roomId];
                [self fetchRoomRegularMembers];
                
                //超管进房加入超管集合
                if ([self isSuperAdminMember:me]) {
                    [self.superAdmins addObject:me.userId];
                }
                
                //校正在线人数
                [self adjustOnlineNumberWithRefreshSuperAdmins:NO];
                
                //定时查询云信在线人数
                self.onLineTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(updateOnLineNmuber) userInfo:nil repeats:YES];
                
                [[XCLogger shareXClogger]sendLog:@{EVENT_ID:CImChannel,@"uid":[GetCore(AuthCore) getUid],@"room_id":[NSString stringWithFormat:@"%ld",(long)roomId],@"roomUid":chatroom.creator,@"type":@"1"} error:nil topic:IMLog logLevel:(XCLogLevel)XCLogLevelVerbose];
                
            } else {
                
                if (error.code == 13) {
                    NotifyCoreClient(ImRoomCoreClient, @selector(onMeInterChatRoomBadNetWork), onMeInterChatRoomBadNetWork)
                }else if (error.code == 404) {//房间不存在
                    NotifyCoreClient(ImRoomCoreClient, @selector(onMeInterChatRoomFailth), onMeInterChatRoomFailth);
                }else if (error.code == 408) {//超时
                    NotifyCoreClient(ImRoomCoreClient, @selector(onMeInterChatRoomFailth), onMeInterChatRoomFailth);
                }else if (error.code == 13002) {
                    NotifyCoreClient(ImRoomCoreClient, @selector(onMeInterChatRoomFailth), onMeInterChatRoomFailth);
                }else if (error.code == 13003) {//黑名单
                    NotifyCoreClient(ImRoomCoreClient, @selector(onMeInterChatRoomInBlackList), onMeInterChatRoomInBlackList);
                }else {
                    NotifyCoreClient(ImRoomCoreClient, @selector(onMeInterChatRoomBadNetWork), onMeInterChatRoomBadNetWork)
                } //408超时
                self.currentRoomInfo = nil;
                self.currentChatRoom = nil;
                NSString *roomUid = chatroom.creator ? chatroom.creator : @"";
                [[XCLogger shareXClogger]sendLog:@{EVENT_ID:CImChannel,@"uid":[GetCore(AuthCore) getUid],@"room_id":[NSString stringWithFormat:@"%ld",(long)roomId],@"roomUid":roomUid,@"type":@"1"} error:error topic:IMLog logLevel:(XCLogLevel)XCLogLevelError];
            }
        }];
//    } failure:^(NSError *error) {
//        NSLog(@"%@",error);
//    }];

}

- (void)exitChatRoom:(NSInteger)roomId{
    NSString *roomuid = [[NSString alloc]init];
    roomuid = [self.roomOwner.userId copy];

    if (self.currentRoomInfo.uid == GetCore(AuthCore).getUid.userIDValue) {
        self.roomOwner = nil;
    }
    [GetCore(RoomCoreV2) reportUserOuterRoom];
    if (self.currentChatRoom == nil || roomId != self.currentChatRoom.roomId.integerValue ) {
        NotifyCoreClient(ImRoomCoreClientV2, @selector(onMeExitChatRoomSuccessV2), onMeExitChatRoomSuccessV2);
        [self.onLineTimer invalidate];
        [self resetAllQueue];
        self.currentRoomInfo = nil;
        return;
    }
    [[NIMSDK sharedSDK].chatroomManager exitChatroom:[NSString stringWithFormat:@"%ld", roomId] completion:^(NSError * _Nullable error) {
        self.currentChatRoom = nil;
        self.currentRoomInfo = nil;
        [self.onLineTimer invalidate];
        [self resetAllQueue];
        NotifyCoreClient(ImRoomCoreClientV2, @selector(onMeExitChatRoomSuccessV2), onMeExitChatRoomSuccessV2);
        if (!error) {
            [[BaiduMobStat defaultStat]eventEnd:@"room_length_of_stay_time" eventLabel:@"在房间内停留时长"];
            [[XCLogger shareXClogger]sendLog:@{EVENT_ID:CImChannel,@"uid":[GetCore(AuthCore) getUid],@"room_id":[NSString stringWithFormat:@"%ld",(long)roomId],@"type":@"2"} error:nil topic:IMLog logLevel:(XCLogLevel)XCLogLevelVerbose];
        }else {
            [[XCLogger shareXClogger]sendLog:@{EVENT_ID:CImChannel,@"uid":[GetCore(AuthCore) getUid],@"room_id":[NSString stringWithFormat:@"%ld",(long)roomId],@"type":@"2"} error:error topic:IMLog logLevel:(XCLogLevel)XCLogLevelError];
        }
    }];
}

//提出房间 带回调的
- (void)kickUser:(UserID)beKickedUid  successBlcok:(void (^)(BOOL success))successBlcok {
    NIMChatroomMemberKickRequest *request = [[NIMChatroomMemberKickRequest alloc] init];
    request.roomId = self.currentChatRoom.roomId;
    request.userId = [NSString stringWithFormat:@"%lld",beKickedUid];
    request.notifyExt = [@{@"reason":@"kick",@"account":[NSString stringWithFormat:@"%lld",beKickedUid],@"handleUid":[GetCore(AuthCore) getUid], @"role":[NSNumber numberWithInteger:1]} yy_modelToJSONString];
    [[NIMSDK sharedSDK].chatroomManager kickMember:request completion:^(NSError * _Nullable error) {
        if (!error) {
            successBlcok(YES);
            [[XCLogger shareXClogger]sendLog:@{EVENT_ID:CImKick,@"handleUid":[GetCore(AuthCore) getUid],@"uid":[NSString stringWithFormat:@"%lld",beKickedUid]} error:nil topic:IMLog logLevel:(XCLogLevel)XCLogLevelVerbose];
            [GetCore(RoomCoreV2) recordSuperAdminOperate:SuperAdminOperateTypeTickRoom superAdminUid:[GetCore(AuthCore).getUid userIDValue] roomUid:GetCore(RoomCoreV2).getCurrentRoomInfo.uid targetUid:beKickedUid];
        }else {
            successBlcok(NO);
            [[XCLogger shareXClogger]sendLog:@{EVENT_ID:CImKick,@"handleUid":[GetCore(AuthCore) getUid],@"uid":[NSString stringWithFormat:@"%lld",beKickedUid]} error:error topic:IMLog logLevel:(XCLogLevel)XCLogLevelError];
        }
    }];
}

//kick
- (void)kickUser:(UserID)beKickedUid{
    NIMChatroomMemberKickRequest *request = [[NIMChatroomMemberKickRequest alloc] init];
    request.roomId = self.currentChatRoom.roomId;
    request.userId = [NSString stringWithFormat:@"%lld",beKickedUid];
    request.notifyExt = [@{@"reason":@"kick",@"account":[NSString stringWithFormat:@"%lld",beKickedUid],@"handleUid":[GetCore(AuthCore) getUid]} yy_modelToJSONString];
    [[NIMSDK sharedSDK].chatroomManager kickMember:request completion:^(NSError * _Nullable error) {
        if (!error) {

            [[GetCore(UserCore) getUserInfoByRac:beKickedUid refresh:NO] subscribeNext:^(id x) {
                UserInfo *member = (UserInfo *)x;
                
                ChatRoomQueueNotifyModel *notifyModel = [[ChatRoomQueueNotifyModel alloc] init];
                notifyModel.handleNick = self.myMember.roomNickname;
                notifyModel.handleUid = self.myMember.userId.userIDValue;
                notifyModel.targetUid =beKickedUid;
                notifyModel.targetNick = member.nick;
                notifyModel.uid = beKickedUid;
                Attachment *attachment = [[Attachment alloc] init];
                attachment.first = Custom_Noti_Header_Kick;
                attachment.second = Custom_Noti_Sub_Kick_BeKicked;
                attachment.data = [notifyModel model2dictionary];
                NSString *sessionID = [NSString stringWithFormat:@"%ld",self.currentRoomInfo.roomId];
                [GetCore(ImMessageCore) sendCustomMessageAttachement:attachment sessionId:sessionID type:NIMSessionTypeChatroom];
            }];
            [[XCLogger shareXClogger]sendLog:@{EVENT_ID:CImKick,@"handleUid":[GetCore(AuthCore) getUid],@"uid":[NSString stringWithFormat:@"%lld",beKickedUid]} error:nil topic:IMLog logLevel:(XCLogLevel)XCLogLevelVerbose];
        }else {
            [[XCLogger shareXClogger]sendLog:@{EVENT_ID:CImKick,@"handleUid":[GetCore(AuthCore) getUid],@"uid":[NSString stringWithFormat:@"%lld",beKickedUid]} error:error topic:IMLog logLevel:(XCLogLevel)XCLogLevelError];
        }
        NSLog(@"%@",error);
    }];
}

//修改我的聊天室个人信息（等级，贵族)
- (void)updateMyRoomMemberInfoWithrequest:(NIMChatroomMemberInfoUpdateRequest *)request {
    request.needNotify = YES;
    request.roomId = self.currentChatRoom.roomId;
    __block NIMChatroomMemberInfoUpdateRequest * updateRequest = request;
    [[NIMSDK sharedSDK].chatroomManager updateMyChatroomMemberInfo:request completion:^(NSError * _Nullable error) {
        if (error == nil) {
            NotifyCoreClient(ImRoomCoreClient, @selector(onUpdateRoomMemberInfoSuccess:), onUpdateRoomMemberInfoSuccess:updateRequest);
        }else {
            NotifyCoreClient(ImRoomCoreClient, @selector(onUpdateRoomMemberInfoFailth:), onUpdateRoomMemberInfoFailth:error.code);
        }
    }];
}

- (void)updateMyMemberInfoWithrequest:(NIMChatroomMemberInfoUpdateRequest *)request {
    NIMChatroomMembersByIdsRequest *request2 = [[NIMChatroomMembersByIdsRequest alloc]init];
    request2.roomId = [NSString stringWithFormat:@"%ld",GetCore(ImRoomCoreV2).currentRoomInfo.roomId];
    NSString *userId = [GetCore(AuthCore) getUid];
    request2.userIds = @[userId];
    
    [[NIMSDK sharedSDK].chatroomManager fetchChatroomMembersByIds:request2 completion:^(NSError * _Nullable error, NSArray<NIMChatroomMember *> * _Nullable members) {
        if (error == nil) {
            NSLog(@"!!!!!!%@",self.myMember);
            if (members.count > 0) {
                
                self.myMember.roomExt = members.firstObject.roomExt;
                
//                NSString *position = [GetCore(RoomQueueCoreV2) findThePositionByUid:[GetCore(AuthCore) getUid].userIDValue];
//                ChatRoomMicSequence *micSequence = GetCore(ImRoomCoreV2).micQueue[position];
//                micSequence.chatRoomMember = members.firstObject;
//                NotifyCoreClient(RoomQueueCoreClient, @selector(onMicroQueueUpdate:), onMicroQueueUpdate:GetCore(ImRoomCoreV2).micQueue);
            }
        }else {
            
        }
    }];
}

/// 临时成员的数据处理
- (void)handleChatroomTempMembers {
    @weakify(self);
    [[self requestChatroomTempMembersSignal] subscribeNext:^(NSArray<NIMChatroomMember *> * _Nullable members) {
        
        @strongify(self);
        self.tempMembers = members;
        [self.guestMembers removeAllObjects];
        [self.guestMembers addObjectsFromArray:[self removeMicMember:[members mutableCopy]]];
        
        [self.displayMembers addObjectsFromArray:[self.guestMembers copy]];
        [self.noMicMembers addObjectsFromArray:[self.guestMembers copy]];
        
        NotifyCoreClient(ImRoomCoreClientV2, @selector(responseChatroomMembersSuccess), responseChatroomMembersSuccess);
    } error:^(NSError *error) {
        NotifyCoreClient(ImRoomCoreClientV2, @selector(responseChatroomMembersError:), responseChatroomMembersError:error);
    }];
}

/// 普通成员的数据处理
- (void)handleChatroomRegularMembers:(NSArray *)members {
    [self.onLineManagerMembers removeAllObjects];
    [self.allManagers removeAllObjects];
    [self.normalMembers removeAllObjects];
    [self.backLists removeAllObjects];
    
    NSArray *sortArray = [members sortedArrayUsingComparator:^NSComparisonResult(NIMChatroomMember *obj1, NIMChatroomMember *obj2) {
        return (NSComparisonResult)(obj2.enterTimeInterval > obj1.enterTimeInterval);
    }];
    
    for (NIMChatroomMember *item in sortArray) {
        if (item.type == NIMChatroomMemberTypeManager) {
            [self.allManagers addObject:item];
            if (item.isOnline) {
                [self.onLineManagerMembers addObject:item];
            }
        }else if (item.type == NIMChatroomMemberTypeNormal){
            if (item.isOnline) {
                [self.normalMembers addObject:item];
            }
        }else if (item.isInBlackList) {
            [self.backLists addObject:item];
        }
    }
    
    //manager
    [self.displayMembers addObjectsFromArray:[self removeMicMember:self.onLineManagerMembers]];
    [self.noMicMembers addObjectsFromArray:[self removeMicMember:self.onLineManagerMembers]];
    //normal
    [self.displayMembers addObjectsFromArray:[self removeMicMember:self.normalMembers]];
    [self.noMicMembers addObjectsFromArray:[self removeMicMember:self.normalMembers]];
}

/**
 当前房间在线用户列表请求响应，当前兔兔使用，create by @lvjunhang

 @discussion 第一页包含麦序与固定成员
 @param isRefresh 是否刷新数据
 */
- (void)requestChatRoomOnlineMembersWithRefresh:(BOOL)isRefresh {
    
    [self.displayMembers removeAllObjects];
    
    if (!isRefresh) {
        self.lastChatroomMember = self.tempMembers.lastObject;
        [self handleChatroomTempMembers];
        return;
    }
    
    self.lastChatroomMember = nil;
    
    //owner
    if (self.roomOwner != nil && ![self isOnMicro:self.currentRoomInfo.uid]) {
        [self.displayMembers addObject:self.roomOwner];
    }
    
    @weakify(self);
    [[self rac_queryQueueWithRoomId:self.currentChatRoom.roomId] subscribeNext:^(NSArray * _Nullable info) {
        @strongify(self);
        
        //mic
        for (NSDictionary *item in info) {
            UserInfo *userInfo = [UserInfo modelWithJSON:item.allValues.firstObject];
            NSString *position = item.allKeys.firstObject;
            ChatRoomMicSequence *sequence = [self.micQueue objectForKey:position];
            sequence.userInfo = userInfo;
        }
        
        [self.displayMembers addObjectsFromArray:[self getMicMembersFromMicQueue]];
        
        [[self requestChatroomRegularMembersSignal] subscribeNext:^(NSArray *members) {
            
            [self handleChatroomRegularMembers:members];
            [self handleChatroomTempMembers];
            
        } error:^(NSError *error) {
            NotifyCoreClient(ImRoomCoreClientV2, @selector(responseChatroomMembersError:), responseChatroomMembersError:error);
        }];
        
    } error:^(NSError *error) {
        NotifyCoreClient(ImRoomCoreClientV2, @selector(responseChatroomMembersError:), responseChatroomMembersError:error);
    }];
}

/**
 当前房间未上麦用户列表请求响应，当前兔兔使用，create by @lvjunhang
 
 @discussion 第一页包含麦序与固定成员
 @param isRefresh 是否刷新数据
 */
- (void)requestChatRoomNoMicMembersWithRefresh:(BOOL)isRefresh {
    
    [self.noMicMembers removeAllObjects];
    
    if (!isRefresh) {
        self.lastChatroomMember = self.tempMembers.lastObject;
        [self handleChatroomTempMembers];
        return;
    }
    
    self.lastChatroomMember = nil;
    
    //owner
    if (self.roomOwner != nil && ![self isOnMicro:self.currentRoomInfo.uid]) {
        [self.noMicMembers addObject:self.roomOwner];
    }
    
    @weakify(self);
    [[self requestChatroomRegularMembersSignal] subscribeNext:^(NSArray *members) {
        
        @strongify(self);
        [self handleChatroomRegularMembers:members];
        [self handleChatroomTempMembers];
        
    } error:^(NSError *error) {
        NotifyCoreClient(ImRoomCoreClientV2, @selector(responseChatroomMembersError:), responseChatroomMembersError:error);
    }];
}

//通过页数查询聊天室成员，第一页包含麦序与固定成员
- (void)queryChatRoomMembersWithPage:(int)page state:(int)state{
    self.state = state;
    [self.displayMembers removeAllObjects];
    if (page ==1) {
        //owner
        if (self.roomOwner != nil && ![self isOnMicro:self.currentRoomInfo.uid]) {
            [self.displayMembers addObject:self.roomOwner];
        }
        [[self rac_queryQueueWithRoomId:self.currentChatRoom.roomId] subscribeNext:^(id x) {
            //mic
            NSArray *micQueueInfo = (NSArray *)x;
            for (NSDictionary *item in micQueueInfo) {
                UserInfo *userInfo = [UserInfo modelWithJSON:item.allValues.firstObject];
                NSString *position = item.allKeys.firstObject;
                ChatRoomMicSequence *sequence = [self.micQueue objectForKey:position];
                sequence.userInfo = userInfo;
            }
            [self.displayMembers addObjectsFromArray:[self getMicMembersFromMicQueue]];
            
            [self fetchRoomRegularMembers];
            
            self.lastChatroomMember = nil;
            
        }];
        
    }else{
        self.lastChatroomMember = self.tempMembers.lastObject;
        [self fetchTempRoomMember];
    }
    
}

- (void)queryNoMicChatRoomMembersWithPage:(int)page state:(int)state{
    self.state = state;
    [self.noMicMembers removeAllObjects];
    if (page==1) {
        if (self.roomOwner != nil && ![self isOnMicro:self.currentRoomInfo.uid]) {
            [self.noMicMembers addObject:self.roomOwner];
        }
        
        [self fetchRoomRegularMembers];
        self.lastChatroomMember = nil;
    }else{
        self.lastChatroomMember = self.tempMembers.lastObject;
        [self fetchTempRoomMember];
    }
}

- (RACSignal *)rac_queryQueueWithRoomId:(NSString *)roomId{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[NIMSDK sharedSDK].chatroomManager fetchChatroomQueue:roomId completion:^(NSError * _Nullable error, NSArray<NSDictionary<NSString *,NSString *> *> * _Nullable info) {
            if (error == nil) {
                if (info.count>0) {
                    [GetCore(MessageCollection) messageCollectionRequestByPullQueueWithArray:info];
                }
                [subscriber sendNext:info];
                [subscriber sendCompleted];
            }else {
                [subscriber sendError:error];
            }
        }];
        return nil;
    }];
}

//拿麦序成员
- (void)queryQueueWithRoomId:(NSString *)roomId{
    [[NIMSDK sharedSDK].chatroomManager fetchChatroomQueue:roomId completion:^(NSError * _Nullable error, NSArray<NSDictionary<NSString *,NSString *> *> * _Nullable info) {
        if (error == nil && info!= nil) {
            NSMutableArray *uids = [NSMutableArray array];
            for (NSDictionary *item in info) {
                UserInfo *userInfo = [UserInfo modelWithJSON:item.allValues.firstObject];
                NSString *position = item.allKeys.firstObject;
                ChatRoomMicSequence *sequence = [self.micQueue objectForKey:position];
                sequence.userInfo = userInfo;
                if (userInfo) {
                    [uids addObject:[NSString stringWithFormat:@"%lld",userInfo.uid]];
                }
            }

            if (info.count>0) {
                [GetCore(MessageCollection) messageCollectionRequestByPullQueueWithArray:info];
            }
#warning modify by kevin 优化房间头像显示 2019-4-3
            NotifyCoreClient(ImRoomCoreClient, @selector(onGetPreRoomQueueSuccessV2:), onGetPreRoomQueueSuccessV2:self.micQueue);
//            [self queryChartRoomMembersWithUids:uids];
        } else {
            NotifyCoreClient(ImRoomCoreClient, @selector(onGetRoomQueueFailth:), onGetRoomQueueFailth:error.description);
        }
    }];
}

//根据uids获取对应的NIMChatroomMember
- (void)queryChartRoomMembersWithUids:(NSArray *)uids {
    NIMChatroomMembersByIdsRequest *request = [[NIMChatroomMembersByIdsRequest alloc]init];
    request.roomId = self.currentChatRoom.roomId;
    request.userIds = [NSMutableArray arrayWithArray:uids];
    @weakify(self);
    [[NIMSDK sharedSDK].chatroomManager fetchChatroomMembersByIds:request completion:^(NSError * _Nullable error, NSArray<NIMChatroomMember *> * _Nullable members) {

        @strongify(self);
        if (error == nil) {
            if (members) {
                for (NIMChatroomMember *member in members) {
                    for (ChatRoomMicSequence *sequence in self.micQueue.allValues) {
                        if (sequence.userInfo.uid == member.userId.intValue) {
                            sequence.chatRoomMember = member;
                            break;
                        }
                    }
                }
                
                for (ChatRoomMicSequence *sequence in self.micQueue.allValues) {
                    if (sequence.chatRoomMember==nil) {
                        continue;
                    }
                    if (![uids containsObject:sequence.chatRoomMember.userId]) {
                        sequence.userInfo = nil;
                        sequence.chatRoomMember=nil;
                    }
                }
                
            }else{
                [self resetMicQueueChatRoomMember];
            }
        }else{
            if (uids.count==0) {
                [self resetMicQueueChatRoomMember];
            }
        }

        [self performSelector:@selector(setLoading) withObject:nil afterDelay:1.3];

        NotifyCoreClient(ImRoomCoreClientV2, @selector(onGetRoomQueueSuccessV2:), onGetRoomQueueSuccessV2:self.micQueue);
    }];
}

- (void)queryManagerorBackList{
    [self fetchRoomRegularMembers];
}


//设置/取消管理员
- (void)markManagerList:(UserID)userID enable:(BOOL)enable{
    NIMChatroomMemberUpdateRequest *request = [[NIMChatroomMemberUpdateRequest alloc]init];
    request.roomId = [NSString stringWithFormat:@"%ld",(long)self.currentRoomInfo.roomId];
    request.userId = [NSString stringWithFormat:@"%lld",userID];
    request.enable = enable;
    [[NIMSDK sharedSDK].chatroomManager markMemberManager:request completion:^(NSError * _Nullable error) {
        if (error != nil) {

        }else {
        }
    }];
}
//设置/取消黑名单
- (void)markBlackList:(UserID)userID enable:(BOOL)enable{
    NIMChatroomMemberUpdateRequest *request = [[NIMChatroomMemberUpdateRequest alloc]init];
    request.roomId = [NSString stringWithFormat:@"%ld",(long)self.currentRoomInfo.roomId];
    request.userId = [NSString stringWithFormat:@"%lld",userID];
    request.enable = enable;
    [[NIMSDK sharedSDK].chatroomManager updateMemberBlack:request completion:^(NSError * _Nullable error) {
        
        [self fetchRoomRegularMembers];//更新黑名单
        if (error == nil && enable) {
            
            [[self rac_queryChartRoomMemberByUid:[NSString stringWithFormat:@"%lld",userID]] subscribeNext:^(id x) {
                NIMChatroomMember *member = (NIMChatroomMember *)x;
                
                ChatRoomQueueNotifyModel *notifyModel = [[ChatRoomQueueNotifyModel alloc] init];
                notifyModel.handleNick = self.myMember.roomNickname;
                notifyModel.handleUid = self.myMember.userId.userIDValue;
                notifyModel.targetUid =userID;
                notifyModel.targetNick = member.roomNickname;
                notifyModel.uid = userID;
                Attachment *attachment = [[Attachment alloc] init];
                attachment.first = Custom_Noti_Header_Kick;
                attachment.second = Custom_Noti_Sub_Kick_BlackList;
                attachment.data = [notifyModel model2dictionary];
                NSString *sessionID = [NSString stringWithFormat:@"%ld",self.currentRoomInfo.roomId];
                [GetCore(ImMessageCore) sendCustomMessageAttachement:attachment sessionId:sessionID type:NIMSessionTypeChatroom];
            }];
        } else {
            // 统计超管解除拉黑操作
            [GetCore(RoomCoreV2) recordSuperAdminOperate:SuperAdminOperateTypeUnBlack superAdminUid:GetCore(AuthCore).getUid.userIDValue roomUid:GetCore(RoomCoreV2).getCurrentRoomInfo.uid targetUid:userID];
        }
    }];
}

//根据uid获取chartroommember
- (RACSignal *)rac_queryChartRoomMemberByUid:(NSString *)uid {
    if (uid == nil || uid.length<=0) {
        return nil;
    }
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NIMChatroomMembersByIdsRequest *request = [[NIMChatroomMembersByIdsRequest alloc]init];
        request.roomId = self.currentChatRoom.roomId;
        request.userIds = @[uid];
        [[NIMSDK sharedSDK].chatroomManager fetchChatroomMembersByIds:request completion:^(NSError * _Nullable error, NSArray<NIMChatroomMember *> * _Nullable members) {
            
            if (error == nil) {
                [subscriber sendNext:members.firstObject];
                [subscriber sendCompleted];
            }else {
                [subscriber sendNext:nil];
            }
            
        }];
        return nil;
    }];
}


//NIMUser
- (RACSignal *)rac_fetchMemberUserInfoByUid:(NSString *)uid {
    if (uid == nil || uid.length<=0) {
        return nil;
    }
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NIMUser *user = [[NIMSDK sharedSDK].userManager userInfo:uid];//从本地获取用户资料
        if (user.userInfo) {
            [subscriber sendNext:user];
            [subscriber sendCompleted];
        }else {
            NSArray *uids = @[uid];
            //从云信服务器批量获取用户资料
            [[NIMSDK sharedSDK].userManager fetchUserInfos:uids completion:^(NSArray<NIMUser *> * _Nullable users, NSError * _Nullable error) {
                if (error == nil) {
                    [subscriber sendNext:users[0]];
                    [subscriber sendCompleted];
                }else {
                    [subscriber sendError:error];
                }
                
            }];
        }
        return nil;
    }];
}

- (RACSignal *)rac_fetchChatRoomInfoByRoomId:(NSString *)roomId {
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [[NIMSDK sharedSDK].chatroomManager fetchChatroomInfo:roomId completion:^(NSError * _Nullable error, NIMChatroom * _Nullable chatroom) {
            
            if (error==nil) {
                
                self.currentChatRoom.onlineUserCount = chatroom.onlineUserCount;
                [self adjustOnlineNumberWithRefreshSuperAdmins:YES];
                
                [subscriber sendNext:chatroom];
                [subscriber sendCompleted];
            } else {
                [subscriber sendError:error];
            }
        }];
        return nil;
    }];
}


//判断是否在房间
- (BOOL)isInRoom {
    if (_currentRoomInfo != nil) {
        return YES;
    }else {
        return NO;
    }
}
//判断是否在房间黑名单
- (BOOL)isInBackList:(UserID)uid{
    for (NIMChatroomMember *member in self.backLists) {
        if (member.userId.userIDValue == uid) {
            return YES;
        }
    }
    return NO;
}

//发送消息
- (void)sendMessage:(NSString *)message{
    NSString *sessionId = [NSString stringWithFormat:@"%ld", self.currentRoomInfo.roomId];
    
    if (sessionId.length > 0) {
        NSString *nick = [GetCore(UserCore) getUserInfoInDB:[GetCore(AuthCore) getUid].userIDValue].nick;
        [GetCore(ImMessageCore) sendTextMessage:message nick:nick sessionId:sessionId type:NIMSessionTypeChatroom];
    }
}
//发送P2P消息
- (void)sendP2pWithMessage:(NSString *)message{
    if (self.p2pUid > 0) {
        NSString *nick = [GetCore(UserCore) getUserInfoInDB:[GetCore(AuthCore) getUid].userIDValue].nick;
        NSString *sessionId = [NSString stringWithFormat:@"%lld", self.p2pUid];
        [GetCore(ImMessageCore) sendTextMessage:message nick:nick sessionId:sessionId type:NIMSessionTypeP2P];
    }
}

/**发送消息给陌生人对象（P2P）*/
- (void)sendP2pStrangerWithMessage:(NSString *)message{
    if (self.p2pUid > 0) {
        NSString *nick = [GetCore(UserCore) getUserInfoInDB:[GetCore(AuthCore) getUid].userIDValue].communityNick;
        NSString *sessionId = [NSString stringWithFormat:@"%lld", self.p2pUid];
        [GetCore(ImMessageCore) sendStrangerTextMessage:message nick:nick sessionId:sessionId type:NIMSessionTypeP2P];
    }
}
#pragma mark - private method

- (NSMutableDictionary *)queryOnMicroMemberExt {
    NSMutableDictionary *memberExt = [[NSMutableDictionary alloc]init];
    for (NIMChatroomMember *item in self.micMembers) {
        if (item.roomExt.length > 0) {
            NSMutableDictionary *nobleDic = [[NSString dictionaryWithJsonString:item.roomExt] mutableCopy];
            NSMutableDictionary *realExt = [nobleDic objectForKey:item.userId];
            [realExt removeObjectForKey:@"banner"];
            [realExt removeObjectForKey:@"open_effect"];
            [realExt removeObjectForKey:@"halo"];
            [realExt removeObjectForKey:@"headwear"];
            [realExt removeObjectForKey:@"recommend"];
            [realExt removeObjectForKey:@"pic"];
            [realExt removeObjectForKey:@"cardbg"];
            [realExt removeObjectForKey:@"zonebg"];
            [realExt removeObjectForKey:@"blindDate"];
            
            [memberExt setValuesForKeysWithDictionary:nobleDic];
        }
    }
    return memberExt;
}

- (void)setLoading {
    self.isLoading = NO;
}

- (void)updateOnLineNmuber {
    //计数器
    //updateOnLineNmuber十秒走一次，所以clockCount等于6倍数时即为一分钟
    static NSInteger clockCount = -1;
    clockCount++;
    
    @weakify(self)
    [[NIMSDK sharedSDK].chatroomManager fetchChatroomInfo:self.currentChatRoom.roomId completion:^(NSError * _Nullable error, NIMChatroom * _Nullable chatroom) {
        
        @strongify(self)
        
        //每一分钟调整
        if (clockCount % 6 == 0) {
            self.currentChatRoom.onlineUserCount = chatroom.onlineUserCount;
            [self adjustOnlineNumberWithRefreshSuperAdmins:YES];
            return;
        }
        
        NSInteger count = chatroom.onlineUserCount - self.superAdmins.count;
        self.onlineNumber = count >= 0 ? count : 0;
        
        NotifyCoreClient(ImRoomCoreClientV2, @selector(onCurrentRoomOnLineUserCountUpdate), onCurrentRoomOnLineUserCountUpdate);
    }];
}

/**
 在线人数调整，考虑到超管需对在线人数进行调整
 固定成员列表和临时成员列表都要过滤超管
 
 @param refresh 是否清空超管集合
 */
- (void)adjustOnlineNumberWithRefreshSuperAdmins:(BOOL)refresh {
    
    //大于校准阈值，不进行超管人数校准
    if (self.currentChatRoom.onlineUserCount > XCRoomOnlineMemberAdjustMaximum) {
        
        self.onlineNumber = self.currentChatRoom.onlineUserCount;
        NotifyCoreClient(ImRoomCoreClientV2, @selector(onCurrentRoomOnLineUserCountUpdate), onCurrentRoomOnLineUserCountUpdate);
        return;
    }
    
    if (refresh) {
        [self.superAdmins removeAllObjects];
    }
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    
    @weakify(self);
    //临时成员列表筛选
    [[self requestChatroomTempMembersSignal] subscribeNext:^(NSArray *members) {
       
        @strongify(self);
        [self filterSuperAdminForMembers:members];
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    //固定成员列表筛选
    [[self requestChatroomRegularMembersSignal] subscribeNext:^(NSArray *members) {
        
        @strongify(self);
        [self filterSuperAdminForMembers:members];
        dispatch_group_leave(group);
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        //校正在线人数，减去超管人数
        self.onlineNumber = self.currentChatRoom.onlineUserCount - self.superAdmins.count;
        
        NotifyCoreClient(ImRoomCoreClientV2, @selector(onCurrentRoomOnLineUserCountUpdate), onCurrentRoomOnLineUserCountUpdate);
    });
}

- (void)setOnlineNumber:(NSInteger)onlineNumber {
    _onlineNumber = onlineNumber;
    
    if (onlineNumber == 1) {
        ;
    }
}

/**
 从成员列表中筛选出超管，并加入超管集合
 */
- (void)filterSuperAdminForMembers:(NSArray<NIMChatroomMember *> *)members {
    
    for (NIMChatroomMember *member in members) {
        if (member.isOnline && member.roomExt) {
            if ([self isSuperAdminMember:member]) {
                [self.superAdmins addObject:member.userId];
            }
        }
    }
}

/**
 判断成员是否为超管
 
 @discussion 由于只有在线成员roomExt有值，仅对在线成员有效
 */
- (BOOL)isSuperAdminMember:(NIMChatroomMember *)member {
    
    if (member.roomExt == nil) {
        return NO;
    }
    
    NSDictionary *ext = [NSString dictionaryWithJsonString:member.roomExt];
    NSDictionary *memberInfo = [ext objectForKey:member.userId];
    NSNumber *platformRole = [memberInfo valueForKey:XCChatroomMemberExtPlatformRole];
    
    return platformRole && platformRole.intValue == XCUserInfoPlatformRoleSuperAdmin;
}

//获取所有有固定成员（管理与黑名单）
- (void)fetchRoomRegularMembers {
    
    @weakify(self);
    
    NIMChatroomMemberRequest *request = [[NIMChatroomMemberRequest alloc]init];
    request.roomId = [NSString stringWithFormat:@"%ld",(long)self.currentRoomInfo.roomId];
    request.type = NIMChatroomFetchMemberTypeRegular;
    request.limit = 200;
    
    [[NIMSDK sharedSDK].chatroomManager fetchChatroomMembers:request completion:^(NSError * _Nullable error, NSArray<NIMChatroomMember *> * _Nullable members) {
        
        if (error) {
            NotifyCoreClient(ImRoomCoreClientV2, @selector(fetchAllRegularMemberError:), fetchAllRegularMemberError:error);
            return;
        }
        
        @strongify(self);

        NSArray *sortReuslt = [members sortedArrayUsingComparator:^NSComparisonResult(NIMChatroomMember *obj1, NIMChatroomMember *obj2) {
            return (NSComparisonResult)(obj2.enterTimeInterval > obj1.enterTimeInterval);
        }];
        
        [self.onLineManagerMembers removeAllObjects];
        [self.allManagers removeAllObjects];
        [self.normalMembers removeAllObjects];
        [self.backLists removeAllObjects];
        [self.superAdmins removeAllObjects];

        for (NIMChatroomMember *item in sortReuslt) {
            if (item.type == NIMChatroomMemberTypeManager) {
                [self.allManagers addObject:item];
                if (item.isOnline) {
                    [self.onLineManagerMembers addObject:item];
                }
            } else if (item.type == NIMChatroomMemberTypeNormal) {
                if (item.isOnline) {
                    [self.normalMembers addObject:item];
                }
            } else if (item.isInBlackList) {
                [self.backLists addObject:item];
            }
        }
        
        //manager
        [self.displayMembers addObjectsFromArray:[self removeMicMember:self.onLineManagerMembers]];
        [self.noMicMembers addObjectsFromArray:[self removeMicMember:self.onLineManagerMembers]];
        //normal
        [self.displayMembers addObjectsFromArray:[self removeMicMember:self.normalMembers]];
        [self.noMicMembers addObjectsFromArray:[self removeMicMember:self.normalMembers]];
        [self fetchTempRoomMember];
        
        NotifyCoreClient(ImRoomCoreClientV2, @selector(fetchAllRegularMemberSuccess), fetchAllRegularMemberSuccess);
    }];
}

/**
 获取聊天室固定成员，包括创建者,管理员,普通等级用户,受限用户(禁言+黑名单)

 @discussion 移植自函数：fetchRoomRegularMembers
 */
- (RACSignal *)requestChatroomRegularMembersSignal {
    
    if (self.currentChatRoom == nil) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendError:nil];
            [subscriber sendCompleted];
            return nil;
        }];
    }
    
    NIMChatroomMemberRequest *request = [[NIMChatroomMemberRequest alloc] init];
    request.roomId = @(self.currentRoomInfo.roomId).stringValue;
    request.type = NIMChatroomFetchMemberTypeRegular;
    request.limit = 200;
    
    return [self requestChatroomMembersSignalWithRequest:request];
}

/**
 聊天室临时成员，只有在线时才能在列表中看到,数量无上限
 
 @discussion 移植自函数：fetchTempRoomMember
 */
- (RACSignal *)requestChatroomTempMembersSignal {
    
    if (self.currentChatRoom == nil) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendError:nil];
            [subscriber sendCompleted];
            return nil;
        }];
    }
    
    NIMChatroomMemberRequest *request = [[NIMChatroomMemberRequest alloc]init];
    request.roomId = @(self.currentRoomInfo.roomId).stringValue;
    request.lastMember = self.lastChatroomMember;
    request.type = NIMChatroomFetchMemberTypeTemp;
    request.limit = 50;

    return [self requestChatroomMembersSignalWithRequest:request];
}

/**
 查询聊天室成员
 
 @discussion 仅筛选成员，无排序等其他功能
 @param request 查询条件
 @return 查询信号
 */
- (RACSignal *)requestChatroomMembersSignalWithRequest:(NIMChatroomMemberRequest *)request {
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        if (request == nil) {
            
            NSAssert(NO, @"NIMChatroomMemberRequest Can't be nil");

            [subscriber sendError:nil];
            [subscriber sendCompleted];
            return nil;
        }
        
        [[NIMSDK sharedSDK].chatroomManager fetchChatroomMembers:request completion:^(NSError * _Nullable error, NSArray<NIMChatroomMember *> * _Nullable members) {
            
            if (error) {
                [subscriber sendError:error];
            } else {
                [subscriber sendNext:members];
                [subscriber sendCompleted];
            }
        }];
        
        return nil;
    }];
}

//聊天室临时成员
- (void)fetchTempRoomMember {
    NIMChatroomMemberRequest *request = [[NIMChatroomMemberRequest alloc]init];
    request.roomId = [NSString stringWithFormat:@"%ld",(long)self.currentRoomInfo.roomId];
    request.lastMember = self.lastChatroomMember;
    request.type = NIMChatroomFetchMemberTypeTemp;//聊天室临时成员，只有在线时才能在列表中看到,数量无上限
    request.limit = 50;
    @weakify(self);
    [[NIMSDK sharedSDK].chatroomManager fetchChatroomMembers:request completion:^(NSError * _Nullable error, NSArray<NIMChatroomMember *> * _Nullable members) {
        @strongify(self);
        if (error == nil) {
            NSArray *sortReuslt = members;
            self.tempMembers = members;
            [self.guestMembers removeAllObjects];
            [self.guestMembers addObjectsFromArray:[self removeMicMember:[sortReuslt mutableCopy]]];
            
            [self.displayMembers addObjectsFromArray:self.guestMembers];
            [self.noMicMembers addObjectsFromArray:self.guestMembers];
            
            NotifyCoreClient(ImRoomCoreClientV2, @selector(fetchRoomUserListSuccess:), fetchRoomUserListSuccess:self.state);
        } else {
            NotifyCoreClient(ImRoomCoreClientV2, @selector(fetchRoomUserListSuccess:), fetchRoomUserListSuccess:self.state);
        }
        
    }];
}


- (void)handleNotificationMessage:(NIMMessage *)message{
    if (message.messageType == NIMMessageTypeNotification) {
        NIMNotificationObject *notiMsg = (NIMNotificationObject *)message.messageObject;
        NIMChatroomNotificationContent *content = (NIMChatroomNotificationContent *)notiMsg.content;
        if (content.eventType == NIMChatroomEventTypeAddManager||content.eventType == NIMChatroomEventTypeRemoveManager) {//设置为管理员
            NIMChatroomNotificationMember *tempMember = content.targets[0];
            [[self rac_queryChartRoomMemberByUid:tempMember.userId] subscribeNext:^(id x) {
                NIMChatroomMember *member = (NIMChatroomMember *)x;
                if (member.userId.userIDValue == [GetCore(AuthCore)getUid].userIDValue) {
                    self.myLastMember = self.myMember;
                    self.myMember = member;
                }
                
            }];
        }else if (content.eventType == NIMChatroomEventTypeEnter) {
            NIMChatroomNotificationMember *tempMember = content.targets[0];
            [[self rac_queryChartRoomMemberByUid:tempMember.userId] subscribeNext:^(id x) {
                
                NIMChatroomMember *member = (NIMChatroomMember *)x;
                
                if (member && member.userId.userIDValue != [GetCore(AuthCore)getUid].userIDValue) {
                    
                    if ([self isSuperAdminMember:member]) {
                        [self.superAdmins addObject:member.userId];
                    } else {
                        self.onlineNumber += 1;
                    }
                }
                
                if (member.type == NIMChatroomMemberTypeCreator) {
                    self.roomOwner = member;
                }
                
                NSDictionary *nobleDic = [NSString dictionaryWithJsonString:member.roomExt];
                SingleNobleInfo *nobleInfo = [SingleNobleInfo yy_modelWithJSON:nobleDic[member.userId]];
                if (!nobleInfo.enterHide) {
                    NotifyCoreClient(ImRoomCoreClient, @selector(onUserInterChatRoom:), onUserInterChatRoom:message);
                }
                
            }];
        }
    }
}

//去除麦上的成员
- (NSArray *)removeMicMember:(NSMutableArray *)array{
    NSArray *arrayFilter = [self getMicMembersFromMicQueue];
    if (arrayFilter.count <= 0) {
        return [array copy];
    }
    NSMutableArray *temp = [NSMutableArray arrayWithArray:array];
    NSMutableArray *delMembers = [NSMutableArray array];
    [temp enumerateObjectsUsingBlock:^(NIMChatroomMember *member, NSUInteger idx, BOOL * _Nonnull stop) {
        for (NIMChatroomMember *filterMember in arrayFilter) {
            if ([member.userId isEqualToString:filterMember.userId]) {
                [delMembers addObject:member];
            }
        }
    }];
    
    return [self delSameItem:temp inArray:delMembers];
}

- (NSArray *)delSameItem:(NSMutableArray *)array inArray:(NSMutableArray *)filter{
    NSMutableSet *set = [[NSMutableSet alloc] initWithArray:array];
    NSMutableSet *filterSet = [[NSMutableSet alloc] initWithArray:filter];
    [set minusSet:filterSet];
    return set.allObjects;
}

//判断是否在麦上
- (BOOL)isOnMicro:(UserID)uid{
    NSArray *micMembers = [self getMicMembersFromMicQueue];
    if (micMembers != nil && micMembers.count > 0) {
        for (int i = 0; i < micMembers.count; i ++) {
            NIMChatroomMember *chatRoomMember = micMembers[i];
            if (chatRoomMember.userId.userIDValue == uid) {
                return YES;
            }
        }
    }
    return NO;
}

//获取麦上人
- (NSArray *)getMicMembersFromMicQueue{
    NSMutableArray *temp = [NSMutableArray array];
    NIMChatroomMember *roomOwnerMember = nil;
    for (ChatRoomMicSequence *sequence in self.micQueue.allValues) {
        if (sequence.chatRoomMember != nil && sequence.userInfo != nil) {
            if (sequence.chatRoomMember.type == NIMChatroomMemberTypeCreator) {
                roomOwnerMember = sequence.chatRoomMember;
            }else{
                if (sequence.chatRoomMember.type == NIMChatroomMemberTypeManager) {
                    [temp insertObject:sequence.chatRoomMember atIndex:0];
                }else {
                    [temp addObject:sequence.chatRoomMember];
                }
                
            }
            
        }
    }
    if (roomOwnerMember) {
        [temp insertObject:roomOwnerMember atIndex:0];
    }
    return [temp copy];
}

//绑定麦序
- (void)repairMicQueue {
    for (int i = 0 ; i < MIC_COUNT(self.currentRoomInfo.type); i++) {
        MicroState *state = [[MicroState alloc]init];
        state.posState = MicroPosStateFree;
        state.micState = MicroMicStateOpen;
        ChatRoomMicSequence *micSequence = [[ChatRoomMicSequence alloc]init];
        micSequence.microState = state;
        micSequence.chatRoomMember = nil;
        micSequence.userInfo = nil;
        [self.micQueue setObject:micSequence forKey:[NSString stringWithFormat:@"%d",i-1]];
    }
}

//重置member
- (void)resetMicQueueChatRoomMember {
    for (int i = 0 ; i < MIC_COUNT(self.currentRoomInfo.type); i++) {
        ChatRoomMicSequence *micSequence = [self.micQueue objectForKey:[NSString stringWithFormat:@"%d",i-1]];
        if (micSequence != nil) {
            micSequence.chatRoomMember = nil;
            micSequence.userInfo = nil;
        }
    }
}
//重置麦序
- (void)resetMicQueueQueueInfo {
    for (int i = 0 ; i < MIC_COUNT(self.currentRoomInfo.type); i++) {
        ChatRoomMicSequence *micSequence = [self.micQueue objectForKey:[NSString stringWithFormat:@"%d",i-1]];
        if (micSequence != nil) {
            MicroState *state = [[MicroState alloc]init];
            state.posState = MicroPosStateFree;
            state.micState = MicroMicStateOpen;
            micSequence.microState = state;
        }
    }
}

//重置all array
- (void)resetAllQueue {
    [self resetMicQueueChatRoomMember];
    [self resetMicQueueQueueInfo];
    [self.displayMembers removeAllObjects];
    [self.onLineManagerMembers removeAllObjects];
    [self.guestMembers removeAllObjects];
    [self.allManagers removeAllObjects];
    [self.backLists removeAllObjects];
    [self.micMembers removeAllObjects];
    [self.micMembersNoRoomOwner removeAllObjects];
    [self.noMicMembers removeAllObjects];
    self.roomOwner = nil;
    self.lastChatroomMember = nil;
}

/** 重置定时器*/
- (void)invalidateTimer {
    [self.onLineTimer invalidate];
}

/**
 房间是否能开启礼物值
 */
- (BOOL)canOpenGiftValue {
    
    if (self.currentRoomInfo == nil) {
        return NO;
    }
    
    BOOL isCPRoom = self.currentRoomInfo.type == RoomType_CP;
    
    /// CP 房不能开启礼物值
    return !isCPRoom;
}

/**
 房间是否已开启礼物值
 
 @discussion 房间模式能够开启礼物值，且打开了礼物值功能
 */
- (BOOL)hasOpenGiftValue {
    return [self canOpenGiftValue] && self.currentRoomInfo.showGiftValue;
}

#pragma mark - Getter & Setter

- (void)setCurrentRoomInfo:(RoomInfo *)currentRoomInfo{
    
    _currentRoomInfo = currentRoomInfo;
    NotifyCoreClient(ImRoomCoreClientV2, @selector(onCurrentRoomInfoChanged), onCurrentRoomInfoChanged);
}

- (NSMutableArray<NIMChatroomMember *> *)displayMembers{
    if (!_displayMembers) {
        _displayMembers = [NSMutableArray array];
    }
    return _displayMembers;
}
- (NSMutableArray<NIMChatroomMember *> *)onLineManagerMembers{
    if (!_onLineManagerMembers) {
        _onLineManagerMembers = [NSMutableArray array];
    }
    return _onLineManagerMembers;
}
- (NSMutableArray<NIMChatroomMember *> *)guestMembers{
    if (!_guestMembers) {
        _guestMembers = [NSMutableArray array];
    }
    return _guestMembers;
}
- (NSMutableArray<NIMChatroomMember *> *)allManagers{
    if (!_allManagers) {
        _allManagers = [NSMutableArray array];
    }
    return _allManagers;
}
- (NSMutableArray<NIMChatroomMember *> *)backLists{
    if (!_backLists) {
        _backLists = [NSMutableArray array];
    }
    return _backLists;
}

- (NSMutableDictionary<NSString *,ChatRoomMicSequence *> *)micQueue{
    if (!_micQueue) {
        _micQueue = [NSMutableDictionary dictionary];
    }
    return _micQueue;
}

- (NSMutableArray<NIMChatroomMember *> *)micMembers{
    if (!_micMembers) {
        _micMembers = [NSMutableArray array];
    }else{
        [_micMembers removeAllObjects];
    }
    [_micMembers addObjectsFromArray:[self getMicMembersFromMicQueue]];
    return _micMembers;
}
- (NSMutableArray<NIMChatroomMember *> *)micMembersNoRoomOwner{
    if (!_micMembersNoRoomOwner) {
        _micMembersNoRoomOwner = [NSMutableArray array];
    }else{
        [_micMembersNoRoomOwner removeAllObjects];
    }
    [_micMembersNoRoomOwner addObjectsFromArray:[self getMicMembersFromMicQueue]];
    @KWeakify(self)
    [_micMembersNoRoomOwner enumerateObjectsUsingBlock:^(NIMChatroomMember * _Nonnull member, NSUInteger idx, BOOL * _Nonnull stop) {
        @KStrongify(self)
        if (self.currentRoomInfo.type != RoomType_Game || self.currentRoomInfo.type != RoomType_CP) {
            if (member.userId.userIDValue == self.currentRoomInfo.uid) {
                [self.micMembersNoRoomOwner removeObject:member];
                *stop = YES;
            }
        }
    }];
    return _micMembersNoRoomOwner;
}

- (NSMutableArray<NIMChatroomMember *> *)noMicMembers{
    if (!_noMicMembers) {
        _noMicMembers = [NSMutableArray array];
    }
    return _noMicMembers;
}
- (NSMutableArray<NIMChatroomMember *> *)normalMembers{
    if (!_normalMembers) {
        _normalMembers = [NSMutableArray array];
    }
    return _normalMembers;
}

- (NSMutableSet<NSString *> *)superAdmins {
    if (!_superAdmins) {
        _superAdmins = [NSMutableSet set];
    }
    return _superAdmins;
}

@end

