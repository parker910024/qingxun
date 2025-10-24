//
//  TTMentoringInviteView.h
//  TTPlay
//
//  Created by gzlx on 2019/2/18.
//  Copyright © 2019年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MentoringInviteModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^EnterButtonBlock)(UIButton * sender);
typedef void(^AvatarImageTapBlock)(void);
@interface TTMentoringInviteView : UIView
/** 进入的*/
@property (nonatomic, strong) UIButton * enterButton;

@property (nonatomic, strong) MentoringInviteModel * inviteModel;
/**立即进入*/
@property (nonatomic, copy) EnterButtonBlock didClickEnterButton;
/** 点击头像*/
@property (nonatomic, copy) AvatarImageTapBlock avatarImageTapBlock;
@end

NS_ASSUME_NONNULL_END
