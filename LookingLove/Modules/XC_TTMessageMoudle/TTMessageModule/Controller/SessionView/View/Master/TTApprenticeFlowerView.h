//
//  TTApprenticeFlowerView.h
//  TTPlay
//
//  Created by Macx on 2019/1/18.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XCMentoringShipAttachment;
NS_ASSUME_NONNULL_BEGIN
typedef void(^ThanksButtonDidClickBlcok)(void);
typedef void(^RewardButtonDidClickBlcok)(void);
@interface TTApprenticeFlowerView : UIView
@property (nonatomic, strong) XCMentoringShipAttachment * appenticeFlowerAttach;

/** 答谢按钮点击的回调 */
@property (nonatomic, strong) ThanksButtonDidClickBlcok thanksButtonDidClickBlcok;
/** 回赠按钮点击的回调 */
@property (nonatomic, strong) RewardButtonDidClickBlcok rewardButtonDidClickBlcok;
@end

NS_ASSUME_NONNULL_END
