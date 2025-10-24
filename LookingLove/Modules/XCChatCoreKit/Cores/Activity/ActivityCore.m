//
//  ActivityCore.m
//  BberryCore
//
//  Created by 卫明何 on 2017/10/19.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "ActivityCore.h"
#import "HttpRequestHelper+Activity.h"
#import "ActivityCoreClient.h"
#import "ImMessageCoreClient.h"
#import "Attachment.h"
#import "AppScoreClient.h"

#import "AuthCore.h"

@interface ActivityCore ()
<
    ImMessageCoreClient
>


@end

@implementation ActivityCore

- (instancetype)init
{
    self = [super init];
    if (self) {

        AddCoreClient(ImMessageCoreClient, self);

    }
    return self;
}

- (void)dealloc {
    RemoveCoreClientAll(self);
}
    
- (void)getActivityForGamePage:(NSInteger)type {
    [HttpRequestHelper getActivityListWithTuTuType:type success:^(ActivityContainInfo *list) {
        if (type == 1) {
            NotifyCoreClient(ActivityCoreClient, @selector(getActivityInfoListWithGamePageSuccess:), getActivityInfoListWithGamePageSuccess:list);
        } else if (type == 2) {
            NotifyCoreClient(ActivityCoreClient, @selector(getActivityInfoListWithGameRoomSuccess:), getActivityInfoListWithGameRoomSuccess:list);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
    }];
}

- (void)getActivity:(NSInteger)type {
    [HttpRequestHelper getActivityWithType:type success:^(ActivityInfo *info) {
        self.activityInfo = info;
        NotifyCoreClient(ActivityCoreClient, @selector(getActivityInfoSuccess), getActivityInfoSuccess);
    } failure:^(NSNumber *resCode, NSString *message) {
        
    }];
    // 不知道这样加 行不行 - -。
    [HttpRequestHelper getActivityListWithType:type success:^(NSArray<ActivityInfo *> *list) {
        NotifyCoreClient(ActivityCoreClient, @selector(getActivityInfoListSuccess:), getActivityInfoListSuccess:list);
    } failure:^(NSNumber *resCode, NSString *message) {
        
    }];
}

- (void)checkOldUserRegressionActivity {
    [HttpRequestHelper checkOldUserRegressionActivity:[GetCore(AuthCore)getUid].userIDValue success:^(BOOL match) {
        NotifyCoreClient(ActivityCoreClient, @selector(onCheckTheOldUserRegressionWithMath:), onCheckTheOldUserRegressionWithMath:match);
    } failure:^(NSNumber *resCode, NSString *message) {
        
    }];
}

- (void)getOldUserRegressionActivityGiftWithCode:(NSString *)invitationCode {
    [HttpRequestHelper getOldUserRegressionActivityGiftWithInvitationCode:invitationCode uid:[GetCore(AuthCore)getUid].userIDValue success:^(BOOL match) {
        NotifyCoreClient(ActivityCoreClient, @selector(onGetTheOldUserRegressionGiftSuccess), onGetTheOldUserRegressionGiftSuccess);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(ActivityCoreClient, @selector(onGetTheOldUserRegressionGiftFailure), onGetTheOldUserRegressionGiftFailure);
    }];
}

/// 获取房间活动暴击倒计时
/// time 2020-02-25
/// @param roomUid 房间 uid
- (void)getActivityRunawayTime:(long long)roomUid {
    [HttpRequestHelper getActivityRunawayTimeWithRoomUid:roomUid CompletionHander:^(id data, NSNumber *code, NSString *msg) {
        NSTimeInterval limitTime = [[data objectForKey:@"limitTime"] doubleValue];
        NSTimeInterval runawayTime = [[data objectForKey:@"runawayTime"] doubleValue];
        
        NotifyCoreClient(ActivityCoreClient, @selector(getActivityRunawayTimeSuccess:limitTime:code:msg:), getActivityRunawayTimeSuccess:runawayTime limitTime:limitTime code:code.integerValue msg:msg);
    }];
}
#pragma mark - ImMessageCoreClient

- (void)onRecvP2PCustomMsg:(NIMMessage *)msg {
    NIMCustomObject *obj = (NIMCustomObject *)msg.messageObject;
    if (obj.attachment != nil && [obj.attachment isKindOfClass:[Attachment class]]) {
        Attachment *attachment = (Attachment *)obj.attachment;
        if (attachment.first == Custom_Noti_Header_RedPacket) {
            RedInfo *info = [RedInfo yy_modelWithJSON:attachment.data];
            NotifyCoreClient(AppScoreClient, @selector(needShowScoreView:), needShowScoreView:SCORE_NEWRED_ACCOUNTNAME);
            NotifyCoreClient(ActivityCoreClient, @selector(onReceiveP2PRedPacket:), onReceiveP2PRedPacket:info);
        }
        
    }
}

@end
