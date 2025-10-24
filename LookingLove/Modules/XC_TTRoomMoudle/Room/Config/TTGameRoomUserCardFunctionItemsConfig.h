//
//  TTGameRoomUserCardFunctionItemsConfig.h
//  TuTu
//
//  Created by KevinWang on 2018/12/1.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
//item
#import "TTUserCardFunctionItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTGameRoomUserCardFunctionItemsConfig : NSObject

//是不是管理员
+ (RACSignal *)getFunctionItemsInGameRoomWithUid:(UserID)uid isSuperAdmin:(BOOL)isSuperAdmin;

+ (RACSignal *)getFunctionItemsInGameRoomWithUid:(UserID)uid;

+ (RACSignal *)getCenterFunctionItemsInGameRoomWithUid:(UserID)uid isGaming:(BOOL)isGameing;
//是不是管理员
+ (RACSignal *)getCenterFunctionItemsInGameRoomWithUid:(UserID)uid isGaming:(BOOL)isGameing isSuperAdmin:(BOOL)isSuperAdmin;
/**
 清空礼物值抱Ta下麦弹窗提醒 是不是超管
 */
+ (void)cleanGiftValueAlertWhenKickMic:(UserID)uid postion:(NSString *)position isSuperAdmin:(BOOL)isSuperAdmin;


@end

NS_ASSUME_NONNULL_END
