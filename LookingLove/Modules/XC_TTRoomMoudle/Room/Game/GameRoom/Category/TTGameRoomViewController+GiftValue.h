//
//  TTGameRoomViewController+GiftValue.h
//  XC_TTRoomMoudle
//
//  Created by lvjunhang on 2019/4/22.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  礼物值

#import "TTGameRoomViewController.h"
#import "RoomGiftValueCoreClient.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTGameRoomViewController (GiftValue)<RoomGiftValueCoreClient>

/**
 开启礼物值
 */
- (void)c_openGiftValue;

/**
 关闭礼物值
 */
- (void)c_closeGiftValue;

#pragma mark Clean Gift Value Alert
/**
 清空礼物值换麦弹窗提醒
 
 @param position 新麦位
 */
- (void)c_cleanGiftValueAlertWhenShiftMic:(NSString *)position;

/**
 清空礼物值下麦弹窗提醒
 */
- (void)c_cleanGiftValueAlertWhenDownMic;

/**
 清空礼物值抱Ta下麦弹窗提醒
 */
- (void)c_cleanGiftValueAlertWhenKickMic:(UserID)uid postion:(NSString *)position;

@end

NS_ASSUME_NONNULL_END
