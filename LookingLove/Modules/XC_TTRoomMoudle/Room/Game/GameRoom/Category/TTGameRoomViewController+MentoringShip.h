//
//  TTGameRoomViewController+MentoringShip.h
//  TTPlay
//
//  Created by gzlx on 2019/2/18.
//  Copyright © 2019年 YiZhuan. All rights reserved.
//

#import "TTGameRoomViewController.h"
#import "MentoringShipCoreClient.h"
#import "TTMasterTimeView.h"

#import "AuthCoreClient.h"
NS_ASSUME_NONNULL_BEGIN

@interface TTGameRoomViewController (MentoringShip)<MentoringShipCoreClient, TTMasterTimeViewDelegate, AuthCoreClient>

/**师傅给徒弟发送邀请的链接 */
- (void)masterSendInviteToApprentice;

@end

NS_ASSUME_NONNULL_END
