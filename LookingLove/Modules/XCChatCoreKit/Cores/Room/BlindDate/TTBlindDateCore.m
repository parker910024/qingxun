//
//  TTBlindDateCore.m
//  WanBan
//
//  Created by jiangfuyuan on 2020/10/20.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import "TTBlindDateCore.h"
#import "TTBlindDateCoreClient.h"
#import "HttpRequestHelper+TTBlindDate.h"
#import "XCHUDTool.h"
#import "ImRoomCoreV2.h"

@interface TTBlindDateCore ()

@property (nonatomic, strong) dispatch_source_t selectLoveTimer; // 倒计时 计时器
@property (nonatomic, assign) NSInteger timerTime;

@end

@implementation TTBlindDateCore

// 创建倒计时
- (void)createSelectLoveTimer:(NSString *)startTime {
    RoomInfo *info = GetCore(ImRoomCoreV2).currentRoomInfo;
    
    if (info.remainderTime.integerValue <= 0) {
        if (self.selectLoveTimer) {
            dispatch_source_cancel(self.selectLoveTimer);
            self.selectLoveTimer = nil;
        }
        return;
    }
    @weakify(self);
    if (!self.selectLoveTimer) {
        self.timerTime = info.remainderTime.integerValue;
        dispatch_queue_t global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        self.selectLoveTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, global);
        
        dispatch_source_set_timer(self.selectLoveTimer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
        
        dispatch_source_set_event_handler(self.selectLoveTimer, ^{
            @strongify(self);
            //1. 每调用一次 时间-1s
            self.timerTime--;
            dispatch_async(dispatch_get_main_queue(), ^{
                @strongify(self);
                NotifyCoreClient(TTBlindDateCoreClient, @selector(countDownTimer:), countDownTimer:self.timerTime);
                if (self.timerTime <= 0) {
                    dispatch_source_cancel(self.selectLoveTimer);
                    self.selectLoveTimer = nil;
                }
            });
        });
        dispatch_resume(self.selectLoveTimer);
    }
}

// 停止倒计时
- (void)stopTimer {
    if (self.selectLoveTimer) {
        dispatch_source_cancel(self.selectLoveTimer);
        self.selectLoveTimer = nil;
    }
}

/// 更新相亲流程
/// @param roomUid 房间uid
/// @param uid 用户uid
/// @param position 用户麦位
/// @param procedure   当前流程  流程(1 -- 自我介绍, 2 -- 心动选择, 3 -- 心动公布, 4 -- 重新自我介绍)
- (void)updateLoveRoomProcedureWithRoomUid:(UserID)roomUid uid:(UserID)uid position:(NSInteger)position procedure:(NSInteger)procedure {

    [HttpRequestHelper updateLoveRoomProcedureWithRoomUid:roomUid uid:uid position:position procedure:procedure success:^(BOOL success) {
        
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        if (resCode.integerValue == 90004) {
            NotifyCoreClient(TTBlindDateCoreClient, @selector(updateLoveRoomProcedureFailure:), updateLoveRoomProcedureFailure:message);
        } else if (resCode.integerValue == 90003) {
            [XCHUDTool showErrorWithMessage:message];
        }
    }];
}

/// 相亲房上麦
/// @param roomUid 房间uid
/// @param uid 用户uid
/// @param position 用户麦位
- (void)requestLoveRoomUpMicWithRoomUid:(UserID)roomUid uid:(UserID)uid position:(NSInteger)position {
    [HttpRequestHelper requestLoveRoomUpMicWithRoomUid:roomUid uid:uid position:position success:^(BOOL success) {
        
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        
    }];
}

/// 相亲房下麦
/// @param roomUid 房间uid
/// @param uid 用户uid
/// @param position 用户麦位
- (void)requestLoveRoomDownMicWithRoomUid:(UserID)roomUid uid:(UserID)uid position:(NSInteger)position {
    [HttpRequestHelper requestLoveRoomDownMicWithRoomUid:roomUid uid:uid position:position success:^(BOOL success) {
        
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        
    }];
}

/// 相亲房选择心动
/// @param roomUid 房间uid
/// @param uid 用户uid
/// @param position 用户麦位
/// @param choosePosition 选择对象麦位
/// @param chooseUid 选择对象uid
- (void)requestLoveRoomChooseLoveWithRoomUid:(UserID)roomUid uid:(UserID)uid position:(NSInteger)position choosePosition:(NSInteger)choosePosition chooseUid:(UserID)chooseUid {
    [HttpRequestHelper requestLoveRoomChooseLoveWithRoomUid:roomUid uid:uid position:position choosePosition:choosePosition chooseUid:chooseUid success:^(BOOL success) {
        
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        
    }];
}


/// 相亲房公布心动
/// @param roomUid 房间uid
/// @param uid 操作人员uid
/// @param position 操作人员麦位
/// @param choosePosition  被公布人的麦位
/// @param chooseUid 被公布人的uid
/// @param targetPosition 被公布人选择人的uid
/// @param targetMic 被公布人选择人的麦位
- (void)requestLoveRoomPublicLoveWithRoomUid:(UserID)roomUid uid:(UserID)uid position:(NSInteger)position choosePosition:(NSInteger)choosePosition chooseUid:(UserID)chooseUid targetPosition:(NSString *)targetPosition targetMic:(NSString *)targetMic {
    [HttpRequestHelper requestLoveRoomPublicLoveWithRoomUid:roomUid uid:uid position:position choosePosition:choosePosition chooseUid:chooseUid success:^(BOOL success) {
        NotifyCoreClient(TTBlindDateCoreClient, @selector(updateLoveRoomPublicLoveWithPosition:choosePosition:chooseMic:), updateLoveRoomPublicLoveWithPosition:@(choosePosition).stringValue choosePosition:targetPosition chooseMic:targetMic);
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        
    }];
}

@end
