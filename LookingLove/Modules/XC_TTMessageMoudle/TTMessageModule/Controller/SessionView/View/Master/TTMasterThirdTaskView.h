//
//  TTMasterThirdTaskView.h
//  TTPlay
//
//  Created by Macx on 2019/1/17.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  师徒任务3消息view

#import <UIKit/UIKit.h>

@class XCMentoringShipAttachment;
NS_ASSUME_NONNULL_BEGIN

typedef void(^InviteButtonDidClickBlcok)(void);
@interface TTMasterThirdTaskView : UIView
/** 邀请进房 */
@property (nonatomic, strong) UIButton *inviteButton;

@property (nonatomic, strong) XCMentoringShipAttachment * masterThirdTaskAttach;

/** 邀请进房按钮点击的回调 */
@property (nonatomic, strong) InviteButtonDidClickBlcok inviteButtonDidClickBlcok;
@end

NS_ASSUME_NONNULL_END
