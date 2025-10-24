//
//  ArrangeMicCore.m
//  XCChatCoreKit
//
//  Created by gzlx on 2018/12/13.
//  Copyright © 2018年 KevinWang. All rights reserved.
//

#import "ArrangeMicCore.h"
#import "AuthCore.h"
#import "HttpRequestHelper+ArrangeMic.h"
#import "ArrangeMicCoreClient.h"
#import "ImMessageCore.h"
#import "ImMessageCoreClient.h"
#import "RoomInfo.h"
#import "RoomCoreV2.h"
#import "XCArrangeMicAttachment.h"


@interface ArrangeMicCore()<ImMessageCoreClient>

@end

@implementation ArrangeMicCore

- (void)dealloc{
    RemoveCoreClientAll(self);
}

- (instancetype)init{
    if (self = [super init]) {
        AddCoreClient(ImMessageCoreClient, self);
    }
    return self;
}

/**
 管理房间内麦序的状态 是不是开启排麦模式
 @param status NO 是关闭 YES 是开启
 @param roomUid 房主的Uid
 */
- (void)managerRoomMiacStatusWith:(BOOL)status roomUid:(UserID)roomUid{
    UserID userId = [GetCore(AuthCore) getUid].userIDValue;
    [HttpRequestHelper openOrCloseArrangeMicWith:roomUid operUid:userId arrangeStatus:status success:^(NSDictionary * _Nonnull arrangeMicStatus) {
        [[BaiduMobStat defaultStat]logEvent:@"room_open_platoon_click" eventLabel:@"开启排麦模式"];
        NotifyCoreClient(ArrangeMicCoreClient, @selector(roomeOpenOrCloseArrangeMicSuccess:status:), roomeOpenOrCloseArrangeMicSuccess:arrangeMicStatus status:status);
    } fail:^(NSString * _Nonnull message, NSNumber * _Nonnull failCode) {
        NotifyCoreClient(ArrangeMicCoreClient, @selector(roomeOpenOrCloseArrangeMicFail:status:), roomeOpenOrCloseArrangeMicFail:message status:status);
    }];
}

/**
 取消排麦/开始排麦
 @param status 0 开始排麦 1 取消排麦
 */
- (void)userBegainOrCancleArrangeMicWith:(int)status operuid:(UserID)operuid roomUid:(UserID)roomUid{
    [HttpRequestHelper beginOrCancleArrangeMicWith:roomUid operUid:operuid userStatus:status success:^(NSDictionary * _Nonnull stateDic) {
        NotifyCoreClient(ArrangeMicCoreClient, @selector(begainOrCancleArrangeMicSuccess:status:), begainOrCancleArrangeMicSuccess:stateDic status:status);
    } failure:^(NSString * _Nonnull message, NSNumber * _Nonnull failCode) {
        NotifyCoreClient(ArrangeMicCoreClient, @selector(begainOrCancleArrangeMicFail:status:), begainOrCancleArrangeMicFail:message status:status);
    }];
}

/**
 获取排麦的列表
 */
- (void)getArrangeMicList:(UserID)roomUid status:(int)status page:(int)page pageSize:(int)pageSize{
    UserID userid = [GetCore(AuthCore) getUid].userIDValue;
    [HttpRequestHelper getUserArrangeMicListWith:roomUid operUid:userid page:page pageSize:pageSize success:^(ArrangeMicModel * _Nonnull model) {
        self.arrangeMicModel = model;
        NotifyCoreClient(ArrangeMicCoreClient, @selector(getArrangeMicListSuccess:status:), getArrangeMicListSuccess:model status:status);
    } failure:^(NSString * _Nonnull message, NSNumber * _Nonnull failureCode) {
        self.arrangeMicModel = nil;
        NotifyCoreClient(ArrangeMicCoreClient, @selector(getArrangeMicListFail:status:), getArrangeMicListFail:message status:status);
    }];
}

/**
 获取排麦的长度
 */
- (void)getArrangeMicListSizeWith:(UserID)roomUid{
    [HttpRequestHelper getUserArrangeMicListSizeWith:roomUid success:^(NSNumber * _Nonnull count) {
        self.arrangeMicCount = [count intValue];
        NotifyCoreClient(ArrangeMicCoreClient, @selector(getArrangeMicListSizeSuccess:), getArrangeMicListSizeSuccess:[count intValue]);
    } failure:^(NSString * _Nonnull message, NSNumber * _Nonnull failureCode) {
        self.arrangeMicCount = -1;
        NotifyCoreClient(ArrangeMicCoreClient, @selector(getArrangeMicListSizeFail:), getArrangeMicListSizeFail:message);
    }];
    
}


- (void)onRecvChatRoomCustomMsg:(NIMMessage *)msg{
    if (msg.messageType == NIMMessageTypeCustom) {
        NIMCustomObject *obj = (NIMCustomObject *)msg.messageObject;
        Attachment *attachment = (Attachment *)obj.attachment;
        RoomInfo * infor = [GetCore(RoomCoreV2) getCurrentRoomInfo];
        if (attachment.first == Custom_Noti_Header_ArrangeMic) {
            if (infor.roomModeType == RoomModeType_Open_Micro_Mode && GetCore(RoomCoreV2).isInRoom) {
                if (attachment.second == Custom_Noti_Header_ArrangeMic_Non_Empty || attachment.second == Custom_Noti_Header_ArrangeMic_Empty ||  attachment.second == Custom_Noti_Header_ArrangeMic_Mode_Close || attachment.second == Custom_Noti_Header_ArrangeMic_Mode_Open || attachment.second == Custom_Noti_Header_ArrangeMic_Up_Mic){
                    if (attachment.second == Custom_Noti_Header_ArrangeMic_Mode_Close) {
                        self.arrangeMicModel = nil;
                    }
                   //队列从无人排麦到有人排麦)
                    NotifyCoreClient(ArrangeMicCoreClient, @selector(roomArrangeMicStatusChangeWith:), roomArrangeMicStatusChangeWith:attachment.second);
                }
            }
        }else if(attachment.first == Custom_Noti_Header_Queue) {
            if (attachment.second == Custom_Noti_Sub_Queue_Invite && infor.roomModeType == RoomModeType_Open_Micro_Mode && GetCore(RoomCoreV2).isInRoom) {
                XCArrangeMicAttachment * arrangeAtt = [XCArrangeMicAttachment yy_modelWithJSON:attachment.data];
                [self userBegainOrCancleArrangeMicWith:1 operuid:[arrangeAtt.uid userIDValue] roomUid:infor.uid];
            }
        }
    }
}

- (void)onSendChatRoomMessageSuccess:(NIMMessage *)msg{
    if (msg.messageType == NIMMessageTypeCustom) {
        NIMCustomObject *obj = (NIMCustomObject *)msg.messageObject;
        Attachment *attachment = (Attachment *)obj.attachment;
        RoomInfo * infor = [GetCore(RoomCoreV2) getCurrentRoomInfo];
        if (attachment.first == Custom_Noti_Header_Queue && attachment.second == Custom_Noti_Sub_Queue_Invite) {
            if (infor.roomModeType == RoomModeType_Open_Micro_Mode) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    NotifyCoreClient(ArrangeMicCoreClient, @selector(embracUserToMicSendMessageSuccess), embracUserToMicSendMessageSuccess);
                });
            }
        }
    }
}

@end
