//
//  TTMasterSecondTaskView.h
//  TTPlay
//
//  Created by Macx on 2019/1/17.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  师徒任务2消息view

#import <UIKit/UIKit.h>
@class XCMentoringShipAttachment;
NS_ASSUME_NONNULL_BEGIN
typedef void(^SendButtonDidClickBlcok)(void);
@interface TTMasterSecondTaskView : UIView
/** 任务二模型 */
@property (nonatomic, strong) XCMentoringShipAttachment * masterSecondTaskAttach;
/** 拜师礼物模型 */
@property (nonatomic, strong) XCMentoringShipAttachment *apprenticeSendAttachment;

/** 立即赠送按钮点击的回调 */
@property (nonatomic, strong) SendButtonDidClickBlcok sendButtonDidClickBlcok;
@end

NS_ASSUME_NONNULL_END
