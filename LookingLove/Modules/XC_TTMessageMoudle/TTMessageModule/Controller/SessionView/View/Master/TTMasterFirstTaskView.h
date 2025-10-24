//
//  TTMasterFirstTaskView.h
//  TTPlay
//
//  Created by Macx on 2019/1/17.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  师徒任务1消息view

#import <UIKit/UIKit.h>

@class XCMentoringShipAttachment;
NS_ASSUME_NONNULL_BEGIN

typedef void(^ReportButtonDidClickBlcok)(void);
typedef void(^FollowButtonDidClickBlcok)(void);
typedef void(^AvatarImageTapBlock)(void);
@interface TTMasterFirstTaskView : UIView

@property (nonatomic, strong) XCMentoringShipAttachment * masterFirstTaskAttach;
/** 关注并打招呼 */
@property (nonatomic, strong) UIButton *followButton;
/** 举报按钮点击的回调 */
@property (nonatomic, copy) ReportButtonDidClickBlcok reportButtonDidClickBlcok;

/** 关注按钮点击的回调 */
@property (nonatomic, copy) FollowButtonDidClickBlcok followButtonDidClickBlcok;

/** 点击头像*/
@property (nonatomic, copy) AvatarImageTapBlock avatarImageTapBlock;
@end

NS_ASSUME_NONNULL_END
