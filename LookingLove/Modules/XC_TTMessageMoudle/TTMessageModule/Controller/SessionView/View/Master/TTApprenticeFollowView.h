//
//  TTApprenticeFollowView.h
//  TTPlay
//
//  Created by Macx on 2019/1/18.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  师徒任务中, 徒弟关注师傅view

#import <UIKit/UIKit.h>

@class XCMentoringShipAttachment;
NS_ASSUME_NONNULL_BEGIN

typedef void(^ApprenticeReportButtonDidClickBlcok)(void);
typedef void(^AvatarImageTapBlock)(void);
@interface TTApprenticeFollowView : UIView
@property (nonatomic, strong) XCMentoringShipAttachment * apprenticeFollowAttach;
/** 举报按钮点击的回调 */
@property (nonatomic, strong) ApprenticeReportButtonDidClickBlcok reportButtonDidClickBlcok;
/** 点击头像回调*/
@property (nonatomic, copy) AvatarImageTapBlock avatarImageBlock;
@end

NS_ASSUME_NONNULL_END
