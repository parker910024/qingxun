//
//  TTGameRoomViewController+GiftValue.m
//  XC_TTRoomMoudle
//
//  Created by lvjunhang on 2019/4/22.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTGameRoomViewController+GiftValue.h"

#import "RoomGiftValueCore.h"

#import "TTGiftValueAlertView.h"
#import "TTRoomGiftValueGuideView.h"

#import "TTStatisticsService.h"
#import "TTPopup.h"

///退出礼物值不再显示状态保存
static NSString *const kGiftValueQuitStatusStoreKey = @"TTGameRoomViewControllerGiftValueQuitStatus";

///礼物值引导状态保存
static NSString *const kGiftValueGuideStatusStoreKey = @"TTGameRoomViewControllerGiftValueGuideStatus";

///礼物值换麦清空提醒状态保存
static NSString *const kGiftValueShiftMicAlertStatusStoreKey = @"TTGameRoomViewControllerGiftValueShiftMicAlertStatus";

///礼物值下麦清空提醒状态保存
static NSString *const kGiftValueDownMicAlertStatusStoreKey = @"TTGameRoomViewControllerGiftValueDownMicAlertStatus";

///礼物值抱下麦清空提醒状态保存
static NSString *const kGiftValueKickMicAlertStatusStoreKey = @"TTGameRoomViewControllerGiftValueKickMicAlertStatus";

@implementation TTGameRoomViewController (GiftValue)

#pragma mark - Public Methods
/**
 开启礼物值
 */
- (void)c_openGiftValue {
    
    // 轻寻不展示新手引导
    if (projectType() == ProjectType_LookingLove) {
        [XCHUDTool showGIFLoading];
        [GetCore(RoomGiftValueCore) requestRoomGiftValueOpenWithRoomUid:self.roomInfo.uid];
        return;
    }
    // 首次显示引导
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    BOOL hadGuide = [ud boolForKey:kGiftValueGuideStatusStoreKey];
    if (hadGuide) {
        [XCHUDTool showGIFLoading];
        [GetCore(RoomGiftValueCore) requestRoomGiftValueOpenWithRoomUid:self.roomInfo.uid];
        return;
    }
    
    [ud setBool:YES forKey:kGiftValueGuideStatusStoreKey];
    [ud synchronize];
    
    TTRoomGiftValueGuideView *guideView = [[TTRoomGiftValueGuideView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    @KWeakify(self);
    guideView.didFinishGuide = ^{
        @KStrongify(self);
        [XCHUDTool showGIFLoading];
        [GetCore(RoomGiftValueCore) requestRoomGiftValueOpenWithRoomUid:self.roomInfo.uid];
    };
    [[UIApplication sharedApplication].keyWindow addSubview:guideView];
}

/**
 关闭礼物值
 */
- (void)c_closeGiftValue {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults boolForKey:kGiftValueQuitStatusStoreKey]) { // 如果已经有保存不再显示，就直接处理
        [self requestCloseGiftValue];
    } else { // 如果没有，就例行弹窗处理。确定后再进行业务事件
        @weakify(self);
        TTGiftValueAlertView *alertView = [[TTGiftValueAlertView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth - 80, 220) text:GetCore(ImRoomCoreV2).currentRoomInfo.type == RoomType_Love ? @"关闭心动值将会清除当前麦上所有心动值数据，确认关闭吗？" : @"关闭礼物值将会清除当前麦上所有礼物值数据，确认关闭吗？"];
        
        alertView.enterHandler = ^(BOOL notShowNextTime) {
            
            [TTPopup dismiss];
            
            @strongify(self);
            [self requestCloseGiftValue];
            // 如果是不再显示
            if (notShowNextTime) {
                [userDefaults setBool:notShowNextTime forKey:kGiftValueQuitStatusStoreKey];
                [userDefaults synchronize];
            }
        };
        alertView.cancelHandler = ^{
            [TTPopup dismiss];
        };
        
        [TTPopup popupView:alertView style:TTPopupStyleAlert];
    }
}

#pragma mark Clean Gift Value Alert
/**
 清空礼物值换麦弹窗提醒
 
 @param position 新麦位
 */
- (void)c_cleanGiftValueAlertWhenShiftMic:(NSString *)position {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults boolForKey:kGiftValueShiftMicAlertStatusStoreKey]) {
        [GetCore(RoomQueueCoreV2) upMic:position.intValue];
        return;
    }
    
    TTGiftValueAlertView *alertView = [[TTGiftValueAlertView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth - 80, 220) text:GetCore(ImRoomCoreV2).currentRoomInfo.type == RoomType_Love ? @"更换麦位将会清除你当前的心动值，确认更换吗?" : @"更换麦位将会清除你当前的礼物值，确认更换吗?"];
    
    alertView.enterHandler = ^(BOOL notShowNextTime) {
        
        [TTPopup dismiss];
        
        [GetCore(RoomQueueCoreV2) upMic:position.intValue];
        
        // 如果是不再显示
        if (notShowNextTime) {
            [userDefaults setBool:notShowNextTime forKey:kGiftValueShiftMicAlertStatusStoreKey];
            [userDefaults synchronize];
        }
    };
    alertView.cancelHandler = ^{
        [TTPopup dismiss];
    };
    
    [TTPopup popupView:alertView style:TTPopupStyleAlert];
}

/**
 清空礼物值下麦弹窗提醒
 */
- (void)c_cleanGiftValueAlertWhenDownMic {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults boolForKey:kGiftValueDownMicAlertStatusStoreKey]) {
        [GetCore(RoomQueueCoreV2) downMic];
        return;
    }
    
    TTGiftValueAlertView *alertView = [[TTGiftValueAlertView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth - 80, 220) text:GetCore(ImRoomCoreV2).currentRoomInfo.type == RoomType_Love ?
                                       @"下麦将会清除你当前的心动值，确认下麦吗？" :
                                       @"下麦将会清除你当前的礼物值，确认下麦吗？"];
    
    alertView.enterHandler = ^(BOOL notShowNextTime) {
        
        [TTPopup dismiss];
        
        [GetCore(RoomQueueCoreV2) downMic];
        
        // 如果是不再显示
        if (notShowNextTime) {
            [userDefaults setBool:notShowNextTime forKey:kGiftValueDownMicAlertStatusStoreKey];
            [userDefaults synchronize];
        }
    };
    alertView.cancelHandler = ^{
        [TTPopup dismiss];
    };
    
    [TTPopup popupView:alertView style:TTPopupStyleAlert];
}

/**
 清空礼物值抱Ta下麦弹窗提醒
 */
- (void)c_cleanGiftValueAlertWhenKickMic:(UserID)uid postion:(NSString *)position {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults boolForKey:kGiftValueKickMicAlertStatusStoreKey]) {
        [GetCore(RoomQueueCoreV2) kickDownMic:uid position:position.intValue];
        return;
    }
    
    TTGiftValueAlertView *alertView = [[TTGiftValueAlertView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth - 80, 220) text:GetCore(ImRoomCoreV2).currentRoomInfo.type == RoomType_Love ? @"抱Ta下麦清除该用户当前的心动值，确认抱Ta下麦吗？" : @"抱Ta下麦清除该用户当前的礼物值，确认抱Ta下麦吗？"];
    
    alertView.enterHandler = ^(BOOL notShowNextTime) {
        
        [TTPopup dismiss];
        
        [GetCore(RoomQueueCoreV2) kickDownMic:uid position:position.intValue];
        
        // 如果是不再显示
        if (notShowNextTime) {
            [userDefaults setBool:notShowNextTime forKey:kGiftValueKickMicAlertStatusStoreKey];
            [userDefaults synchronize];
        }
    };
    alertView.cancelHandler = ^{
        [TTPopup dismiss];
    };
    
    [TTPopup popupView:alertView style:TTPopupStyleAlert];
}

#pragma mark - Private Methods
/**
 关闭礼物值请求
 */
- (void)requestCloseGiftValue {
    [XCHUDTool showGIFLoading];
    [GetCore(RoomGiftValueCore) requestRoomGiftValueCloseWithRoomUid:self.roomInfo.uid];
}

#pragma mark - RoomGiftValueCoreClient

/**
 关闭房间礼物值开关
 
 @param success 操作是否成功
 @param code 错误码
 @param msg 错误信息
 */
- (void)responseRoomGiftValueClose:(BOOL)success errorCode:(NSNumber *)code msg:(NSString *)msg {
    
    if (!success) {
        [XCHUDTool showErrorWithMessage:msg];
        return;
    }
    
    [XCHUDTool hideHUD];
    
    NSString *describe = [NSString stringWithFormat:@"礼物值开关:%@", @"关闭"];
    [TTStatisticsService trackEvent:TTStatisticsServiceEventRoomGiftValueSwitch eventDescribe:describe];
    
    //这里无需设置，因为 updateView 方法里面有更新了
//    self.positionView.showGiftValue = NO;
}

/**
 开启房间礼物值开关
 
 @param success 操作是否成功
 @param code 错误码
 @param msg 错误信息
 */
- (void)responseRoomGiftValueOpen:(BOOL)success errorCode:(NSNumber *)code msg:(NSString *)msg {
    
    if (!success) {
        [XCHUDTool showErrorWithMessage:msg];
        return;
    }
    
    [XCHUDTool hideHUD];
    
    NSString *describe = [NSString stringWithFormat:@"礼物值开关:%@", @"开启"];
    [TTStatisticsService trackEvent:TTStatisticsServiceEventRoomGiftValueSwitch eventDescribe:describe];
    
    //这里无需设置，因为 updateView 方法里面有更新了
//    self.positionView.showGiftValue = YES;
}

/**
 清除礼物值
 
 @param micUid 被清除对象uid
 @param data 信息
 @param code 错误码
 @param msg 错误信息
 */
- (void)responseRoomGiftValueClean:(UserID)micUid giftValue:(RoomOnMicGiftValue *)data errorCode:(NSNumber *)code msg:(NSString *)msg {

    if (data == nil) {
        [XCHUDTool showErrorWithMessage:msg];
        return;
    }
    
    // 清空埋点
    [TTStatisticsService trackEvent:TTStatisticsServiceEventRoomGiftValueCardClean eventDescribe:@"资料卡片-清除礼物值"];
    
    [TTPopup dismiss];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [XCHUDTool showSuccessWithMessage:@"清除成功"];
    });
}
    
@end
