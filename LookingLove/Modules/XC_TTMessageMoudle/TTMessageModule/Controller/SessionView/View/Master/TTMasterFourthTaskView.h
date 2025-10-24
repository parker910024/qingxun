//
//  TTMasterFourthTaskView.h
//  TTPlay
//
//  Created by Macx on 2019/1/18.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  XCMentoringShipAttachment;
NS_ASSUME_NONNULL_BEGIN
typedef void(^FourthInviteButtonDidClickBlcok)(void);
@interface TTMasterFourthTaskView : UIView
/** 发送邀请 */
@property (nonatomic, strong) UIButton *inviteButton;

@property (nonatomic, strong) XCMentoringShipAttachment * masterFourthTaskAttach;

/** 发送邀请按钮点击的block */
@property (nonatomic, strong) FourthInviteButtonDidClickBlcok inviteButtonDidClickBlcok;
@end

NS_ASSUME_NONNULL_END
