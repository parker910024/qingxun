//
//  VoiceBottleCore.m
//  XCChatCoreKit
//
//  Created by fengshuo on 2019/6/5.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "VoiceBottleCore.h"
#import "HttpRequestHelper+VoiceBottle.h"
#import "AuthCore.h"
#import "VoiceBottleCoreClient.h"
#import "Attachment.h"
#import "XCGameVoiceBottleAttachment.h"
#import "NotificationCoreClient.h"

@implementation VoiceBottleCore

- (void)dealloc{
    RemoveCoreClientAll(self);
}

- (id)init{
    if (self = [super init]) {
        AddCoreClient(NotificationCoreClient, self);
    }
    return self;
}


/** 录音的时候 获取剧本的内容*/
- (void)getVoiceBottlePiaWhenRecord {
    [HttpRequestHelper voliceBottleGetPiaWith:GetCore(AuthCore).getUid.userIDValue pageSize:30 type:VoicePiaType_song success:^(NSArray * _Nonnull array) {
        NotifyCoreClient(VoiceBottleCoreClient, @selector(getVoicePiaWhenRecordSuccess:), getVoicePiaWhenRecordSuccess:array);
    } failure:^(NSNumber * _Nonnull rescode, NSString * _Nonnull message) {
        NotifyCoreClient(VoiceBottleCoreClient, @selector(getVoicePiaWhenRecordFail:), getVoicePiaWhenRecordFail:message);
    }];
}

/** 获取声音匹配列表 */
- (void)requestVoiceMatchingListWithGender:(NSInteger)gender pageSize:(NSInteger)pageSize {
    [HttpRequestHelper requestVoiceMatchingListWithGender:gender pageSize:pageSize success:^(NSArray * _Nonnull array) {
        NotifyCoreClient(VoiceBottleCoreClient, @selector(requestVoiceMatchingListSuccess:), requestVoiceMatchingListSuccess:array);
    } failure:^(NSNumber * _Nonnull rescode, NSString * _Nonnull message) {
        NotifyCoreClient(VoiceBottleCoreClient, @selector(requestVoiceMatchingListFail:errorCode:), requestVoiceMatchingListFail:message errorCode:rescode);
    }];
}

/** 声音喜欢or不喜欢请求 */
- (void)sendVoiceLikeRequestWithVoiceId:(NSInteger)voiceId isLike:(BOOL)isLike {
    [HttpRequestHelper sendVoiceLikeRequestWithVoiceId:voiceId isLike:isLike success:^{
        NotifyCoreClient(VoiceBottleCoreClient, @selector(sendVoiceLikeRequestSuccess), sendVoiceLikeRequestSuccess);
    } failure:^(NSNumber * _Nonnull rescode, NSString * _Nonnull message) {
        NotifyCoreClient(VoiceBottleCoreClient, @selector(sendVoiceLikeRequestFail:errorCode:), sendVoiceLikeRequestFail:message errorCode:rescode);
    }];
}

/** 增加声音播放次数 */
- (void)addVoicePlayCountRequestWithVoiceId:(UserID)voiceId voiceUid:(UserID)voiceUid {
    [HttpRequestHelper addVoicePlayCountRequestWithVoiceId:voiceId voiceUid:voiceUid success:^{
        
    } failure:^(NSNumber * _Nonnull rescode, NSString * _Nonnull message) {
        
    }];
}

/** 请求我的声音列表 */
- (void)requestMyVoiceList {
    [HttpRequestHelper requestMyVoiceListWithSuccess:^(NSArray * _Nonnull array) {
        NotifyCoreClient(VoiceBottleCoreClient, @selector(requestMyVoiceListSuccess:), requestMyVoiceListSuccess:array);
    } failure:^(NSNumber * _Nonnull rescode, NSString * _Nonnull message) {
        NotifyCoreClient(VoiceBottleCoreClient, @selector(requestMyVoiceListFail:errorCode:), requestMyVoiceListFail:message errorCode:rescode);
    }];
}

/** 查询旧版本个人介绍声音 */
- (void)requestOldVoiceIntroduce {
    [HttpRequestHelper requestOldVoiceIntroduceWithSuccess:^(NSDictionary * _Nonnull dict) {
        NotifyCoreClient(VoiceBottleCoreClient, @selector(requestOldVoiceIntroduceSuccess:), requestOldVoiceIntroduceSuccess:dict);
    } failure:^(NSNumber * _Nonnull rescode, NSString * _Nonnull message) {
        NotifyCoreClient(VoiceBottleCoreClient, @selector(requestOldVoiceIntroduceFail:errorCode:), requestOldVoiceIntroduceFail:message errorCode:rescode);
    }];
}

/**
 同步旧版本个人介绍声音到声音瓶子
 */
- (void)sendOldVoiceIntroduceSyncVoiceBottle:(NSInteger)voiceId {
    [HttpRequestHelper sendOldVoiceIntroduceSyncVoiceBottle:voiceId success:^{
        NotifyCoreClient(VoiceBottleCoreClient, @selector(sendOldVoiceIntroduceSyncVoiceBottleSuccess), sendOldVoiceIntroduceSyncVoiceBottleSuccess);
    } failure:^(NSNumber * _Nonnull rescode, NSString * _Nonnull message) {
        NotifyCoreClient(VoiceBottleCoreClient, @selector(sendOldVoiceIntroduceSyncVoiceBottleFail:errorCode:), sendOldVoiceIntroduceSyncVoiceBottleFail:message errorCode:rescode);
    }];
}

- (void)uploadVoiceWith:(NSString *)voiceUrl voiceLength:(int)voiceLength piaId:(UserID)piaId voiceId:(UserID)voiceId {
    [HttpRequestHelper updateVoiceToServiceWith:GetCore(AuthCore).getUid.userIDValue voiceUrl:voiceUrl voiceLength:voiceLength piaId:piaId type:0 voiceId:voiceId success:^(VoiceBottleModel * _Nonnull model) {
        NotifyCoreClient(VoiceBottleCoreClient, @selector(recordVoiceCompleteWithVoiceBottleModel:), recordVoiceCompleteWithVoiceBottleModel:model);
    } failure:^(NSNumber * _Nonnull rescode, NSString * _Nonnull message) {
        NotifyCoreClient(VoiceBottleCoreClient, @selector(uploadVoiceBottleFail:), uploadVoiceBottleFail:message);
    }];
}

- (void)onRecvCustomP2PNoti:(NIMCustomSystemNotification *)notification{
    Attachment *attachment = [Attachment yy_modelWithJSON:notification.content];
    if (attachment.first == Custom_Noti_Header_Game_VoiceBottle){
        XCGameVoiceBottleAttachment * mentoringAttach = [XCGameVoiceBottleAttachment yy_modelWithJSON:attachment.data];
        [self createNimmessageWith:attachment sessionUid:mentoringAttach.voiceUid];
        
    }
}


//创建一个消息回话 并且保存到本地
- (void)createNimmessageWith:(Attachment *)attachment sessionUid:(UserID)sessionUid{
    NIMMessage * message = [[NIMMessage alloc] init];
    NIMCustomObject * customObject = [[NIMCustomObject alloc] init];
    customObject.attachment = attachment;
    message.messageObject = customObject;
    message.localExt = [attachment model2dictionary];
    message.from = [NSString stringWithFormat:@"%lld", sessionUid];
    NIMSession * session =  [NIMSession session:[NSString stringWithFormat:@"%lld", sessionUid] type:NIMSessionTypeP2P];
    [message setValue:session forKey:@"session"];
    NSArray * messages = @[message];
    [[NIMSDK sharedSDK].conversationManager saveMessage:message forSession:session completion:^(NSError * _Nullable error) {
        if (error== nil) {
            NotifyCoreClient(VoiceBottleCoreClient, @selector(addMeesageToChatUIWith:), addMeesageToChatUIWith:messages);
        }
    }];
}

@end
