//
//  TTGameRoomViewController+LittleWorldMessage.h
//  XC_TTRoomMoudle
//
//  Created by apple on 2019/7/12.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTGameRoomViewController.h"
#import "LittleWorldCoreClient.h"
#import "PraiseCoreClient.h"
#import "LittleWorldWoreToastClient.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTGameRoomViewController (LittleWorldMessage)<LittleWorldCoreClient,LittleWorldWoreToastClient, PraiseCoreClient>
/** 是不是展示返回群聊的那个按钮*/
- (void)showBackChatGroup;

/** 在公屏上展示 小世界 信息 (关注房主) */
- (void)showLittleWorldAttendRoomMessage;
/** 在公屏上展示 小世界 信息 (邀请加入小世界) */
- (void)showLittleWorldMessage;

@end

NS_ASSUME_NONNULL_END
