//
//  PhoneCallCore.m
//  BberryCore
//
//  Created by chenran on 2017/5/29.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "PhoneCallCore.h"
#import "PhoneCallCoreClient.h"
#import "ImMessageCore.h"
#import "ImMessageCoreClient.h"
#import "Attachment.h"
#import "GiftReceiveInfo.h"
#import "NSObject+YYModel.h"
#import "GiftCore.h"
#import "UserInfo.h"
#import "UserCore.h"
#import "AuthCore.h"

#import "ImMessageCore.h"
#import "ImMessageCoreClient.h"

#import "CallInfo.h"

#import <AgoraRtcKit/AgoraRtcEngineKit.h>
@interface PhoneCallCore()<ImMessageCoreClient, AgoraRtcEngineDelegate, ImMessageCoreClient>
@property(nonatomic, strong) AgoraRtcEngineKit *engine;
@end

@implementation PhoneCallCore
{
    UInt64 currentCallID;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
//        AddCoreClient(ImMessageCoreClient, self);
//        [[NIMAVChatSDK sharedSDK].netCallManager addDelegate:self];
//        _engine = [AgoraRtcEngineKit sharedEngineWithAppId:@"c5f1fa4878d141f99f3e86ec59f619d9" delegate:self];
    }
    return self;
}

- (void)dealloc
{
//    [[NIMAVChatSDK sharedSDK].netCallManager removeDelegate:self];
//    RemoveCoreClientAll(self);
}

- (UInt64)currentCallID
{
    return currentCallID;
}

- (BOOL)isBusyLine
{
    return currentCallID != 0;
}


- (void) startPhoneCall:(UserID)uid extendMsg:(NSString *)extendMsg
{
//    __block UserID userId = uid;
//    __block NSString *nick = extendMsg;
//    [self.engine disableVideo];
//    [self.engine leaveChannel:^(AgoraRtcStats *stat) {
//        
//    }];
//    
//    [self.engine joinChannelByKey:nil channelName:[NSString stringWithFormat:@"%lld",uid] info:nil uid:uid joinSuccess:^(NSString *channel, NSUInteger uid, NSInteger elapsed) {
//        UserInfo *info = [GetCore(UserCore)getUserInfo:[GetCore(AuthCore) getUid].userIDValue refresh:NO];
//        
//        CallInfo *callInfo = [[CallInfo alloc]init];
//        callInfo.uid = [GetCore(AuthCore)getUid].userIDValue;
//        callInfo.nick = info.nick;
//        
//        Attachment *attachment = [[Attachment alloc]init];
//        attachment.first = Custom_Noti_Header_Calling;
//        attachment.second = Custom_Noti_Sub_Calling_beCall;
//        attachment.data = callInfo.encodeAttchment;
//        
//        [GetCore(ImMessageCore)sendCustomMessageAttachement:attachment sessionId:[NSString stringWithFormat:@"%lld",userId] type:NIMSessionTypeP2P];
//        
//    }];
//    UserInfo *info = [GetCore(UserCore)getUserInfoInDB:[GetCore(AuthCore) getUid].userIDValue];
//    NSString *uidStr = [NSString stringWithFormat:@"%lld",uid];
//    NIMNetCallOption *option = [[NIMNetCallOption alloc] init];
//    option.apnsSound = @"call.caf";
//    option.extendMessage = info.nick;
//
//    [[NIMAVChatSDK sharedSDK].netCallManager start:@[uidStr] type:NIMNetCallMediaTypeAudio option:option completion:^(NSError * _Nullable error, UInt64 callID) {
//        if (error == nil) {
//            currentCallID = callID;
//            NotifyCoreClient(PhoneCallCoreClient, @selector(onStartPhoneCallSuccess:), onStartPhoneCallSuccess:uid);
//        } else {
//            NotifyCoreClient(PhoneCallCoreClient, @selector(onStartPhoneCallFailth), onStartPhoneCallFailth);
//            [GetCore(PhoneCallCore)hangup];
//        }
//    }];
}

- (void)responsePhoneCall:(BOOL)accept
{
    if (currentCallID <= 0) {
        return;
    }
//    [[NIMAVChatSDK sharedSDK].netCallManager response:currentCallID accept:accept option:nil completion:^(NSError * _Nullable error, UInt64 callID) {
//
//    }];
    if (!accept) {
        currentCallID = 0;
    }
}


- (void)hangup
{
    if (currentCallID <= 0) {
        return;
    }
//    [[NIMAVChatSDK sharedSDK].netCallManager hangup:currentCallID];
//    currentCallID = 0;
//    NotifyCoreClient(PhoneCallCoreClient, @selector(onHangup:), onHangup:nil);
//    [self.engine leaveChannel:^(AgoraRtcStats *stat) {
//        if (stat == 0) {
//            CallInfo *callInfo = [[CallInfo alloc]init];
//            callInfo.uid = [GetCore(AuthCore)getUid].userIDValue;
//            callInfo.nick = nil;
//            
//            Attachment *attachment = [[Attachment alloc]init];
//            attachment.first = Custom_Noti_Header_Calling;
//            attachment.second = Custom_Noti_Sub_Calling_deCall;
//            attachment.data = callInfo.encodeAttchment;
//            
//            [GetCore(ImMessageCore)sendCustomMessageAttachement:attachment sessionId:[NSString stringWithFormat:@"%lld",currentCallID] type:NIMSessionTypeP2P];
//            NotifyCoreClient(PhoneCallCoreClient, @selector(onHangup:), onHangup:nil);
//        }
//    }];
}

- (BOOL)setMute:(BOOL)mute
{
    if (currentCallID <= 0) {
        return NO;
    }
//    BOOL result = NO;
//    int state = [self.engine muteLocalAudioStream:mute];
//    if (state == 0) {
//        result = YES;
//    }else{
//        result = NO;
//    }
//    return [[NIMAVChatSDK sharedSDK].netCallManager setMute:mute];
//    return result;
    return YES;
}

- (BOOL)setSpeaker:(BOOL)speaker
{
    if (currentCallID <= 0) {
        return NO;
    }
    BOOL result = NO;
//    int state = [self.engine setEnableSpeakerphone:speaker];
//    if (state == 0) {
//        result = YES;
//    }else{
//        result = NO;
//    }
//    return [[NIMAVChatSDK sharedSDK].netCallManager setSpeaker:speaker];
    return result;
}

//#pragma mark - AgoraRtcEngineDelegate
//
///**
// *  Event of remote user offlined
// *
// *  @param engine The engine kit
// *  @param uid    The remote user id
// *  @param reason Reason of user offline, quit, drop or became audience
// */
//- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOfflineOfUid:
//(NSUInteger)uid reason:(AgoraRtcUserOfflineReason)reason{
//    if (reason == AgoraRtc_UserOffline_Quit) {
//        NSString *uidStr = [NSString stringWithFormat:@"%lu",uid];
//        NotifyCoreClient(PhoneCallCoreClient, @selector(onHangup:), onHangup:uidStr);
//    } else if (reason == AgoraRtc_UserOffline_Dropped) {
//        NotifyCoreClient(PhoneCallCoreClient, @selector(onCallDisconnected), onCallDisconnected);
//    }
//}
//
//- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinedOfUid:
//(NSUInteger)uid elapsed:(NSInteger)elapsed {
//    if (uid == currentCallID) {
//        NotifyCoreClient(PhoneCallCoreClient, @selector(onCallEstablished), onCallEstablished);
//    }
//}

//#pragma mark - ImMessageCoreClient
//- (void)onRecvP2PCustomMsg:(NIMMessage *)msg {
//    NIMCustomObject *obj = (NIMCustomObject *)msg.messageObject;
//    Attachment *attachment = (Attachment *)obj.attachment;
//    if (attachment.first == Custom_Noti_Header_Calling) {
//        CallInfo *info = [CallInfo yy_modelWithDictionary:attachment.data];
//        if (attachment.second == Custom_Noti_Sub_Calling_beCall) {
//            currentCallID = info.uid;
//            NSString *uid = [NSString stringWithFormat:@"%lld",info.uid];
//            if (info.nick == nil) {
//                NotifyCoreClient(PhoneCallCoreClient, @selector(onRecievePhoneCall:), onRecievePhoneCall:uid);
//            } else {
//                //        NotifyCoreClient(PhoneCallCoreClient, @selector(onRecievePhoneCall:extend:), onRecievePhoneCall:caller extend:extendMessage);
//                NSString *uid = [NSString stringWithFormat:@"%lld", info.uid];
//                NotifyCoreClient(PhoneCallCoreClient, @selector(onRecievePhoneCall:uid:extend:), onRecievePhoneCall:uid uid:uid extend:info.nick);
//            }
//        } else if (attachment.second == Custom_Noti_Sub_Calling_deCall){
//            NSString *uidStr = [NSString stringWithFormat:@"%lld",info.uid];
//            NotifyCoreClient(PhoneCallCoreClient, @selector(onHangup:), onHangup:uidStr);
//        }
//    }
//    
//    
//}

#pragma mark - NIMNetCallManagerDelegate

///**
// *  被叫收到呼叫（振铃）
// *
// *  @param callID call id
// *  @param caller 主叫帐号
// *  @param type   呼叫类型
// *  @param extendMessage   扩展消息, 透传主叫发起通话时携带的该信息
// */
//-(void)onReceive:(UInt64)callID from:(NSString *)caller type:(NIMNetCallMediaType)type message:(NSString *)extendMessage
//{
//    if (currentCallID == 0) {
//        currentCallID = callID;
//        if (extendMessage == nil) {
//            NotifyCoreClient(PhoneCallCoreClient, @selector(onRecievePhoneCall:), onRecievePhoneCall:caller);
//        } else {
//            //        NotifyCoreClient(PhoneCallCoreClient, @selector(onRecievePhoneCall:extend:), onRecievePhoneCall:caller extend:extendMessage);
//            NSString *uid = [NSString stringWithFormat:@"%llu", callID];
//            NotifyCoreClient(PhoneCallCoreClient, @selector(onRecievePhoneCall:uid:extend:), onRecievePhoneCall:caller uid:uid extend:extendMessage);
//        }
//    } else {
//        [[NIMAVChatSDK sharedSDK].netCallManager hangup:callID];
//    }
//
//}
//
///**
// *  主叫收到被叫响应
// *
// *  @param callID   call id
// *  @param callee 被叫帐号
// *  @param accepted 是否接听
// */
//- (void)onResponse:(UInt64)callID from:(NSString *)callee accepted:(BOOL)accepted
//{
//    if (callID == currentCallID) {
//        NotifyCoreClient(PhoneCallCoreClient, @selector(onResponsePhoneCall:accept:), onResponsePhoneCall:callee accept:accepted);
//    }
//    if (!accepted) {
//        currentCallID = 0;
//    }
//}
//
///**
// *  对方挂断电话
// *
// *  @param callID call id
// *  @param user   对方帐号
// */
//
//- (void)onHangup:(UInt64)callID by:(NSString *)user
//{
//    if (callID == currentCallID) {
//        NotifyCoreClient(PhoneCallCoreClient, @selector(onHangup:), onHangup:user);
//    }
//    currentCallID = 0;
//}
//
///**
// 点对点通话建立成功
//
// @param callID call id
// */
//- (void)onCallEstablished:(UInt64)callID
//{
//    if (callID == currentCallID) {
//        NotifyCoreClient(PhoneCallCoreClient, @selector(onCallEstablished), onCallEstablished);
//    }
//}
//
///**
// 通话异常断开
//
// @param callID call id
// @param error 断开的原因，如果是 nil 表示正常退出
// */
//- (void)onCallDisconnected:(UInt64)callID withError:(NSError *)error
//{
//    if (callID == currentCallID) {
//        NotifyCoreClient(PhoneCallCoreClient, @selector(onCallDisconnected), onCallDisconnected);
//    } else if (error.code == 20410) {
//        NotifyCoreClient(PhoneCallCoreClient, @selector(onCallDisconnected), onCallDisconnected);
//    }
//    currentCallID = 0;
//}
//
///**
// *  收到对方网络通话控制信息，用于方便通话双方沟通信息
// *
// *  @param callID  相关网络通话的call id
// *  @param user    对方帐号
// *  @param control 控制类型
// */
//- (void)onControl:(UInt64)callID from:(NSString *)user type:(NIMNetCallControlType)control
//{
//    if (callID == currentCallID) {
//        if (control == NIMNetCallControlTypeBusyLine) {
//            NotifyCoreClient(PhoneCallCoreClient, @selector(onBusyLine:), onBusyLine:user);
//        }
//    }
//}
//
///**
// *  当前通话网络状态
// *
// *  @param status 网络状态
// *  @param user   网络状态对应的用户；如果是自己，表示自己的发送网络状态
// */
//- (void)onNetStatus:(NIMNetCallNetStatus)status user:(NSString *)user
//{
//    NotifyCoreClient(PhoneCallCoreClient, @selector(onNetStatus:user:), onNetStatus:status user:user);
//}



@end

