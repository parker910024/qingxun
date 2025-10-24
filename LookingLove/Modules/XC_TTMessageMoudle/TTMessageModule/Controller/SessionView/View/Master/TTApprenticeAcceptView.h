//
//  TTApprenticeAcceptView.h
//  TTPlay
//
//  Created by Macx on 2019/1/18.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  XCMentoringShipAttachment;
NS_ASSUME_NONNULL_BEGIN
typedef void(^AgreeButtonDidClickBlcok)(void);
typedef void(^RejectButtonDidClickBlcok)(void);
@interface TTApprenticeAcceptView : UIView

/** 拒绝按钮 */
@property (nonatomic, strong) UIButton *rejectButton;
/** 同意按钮 */
@property (nonatomic, strong) UIButton *agreeButton;

@property (nonatomic, strong) XCMentoringShipAttachment * appenticeAcceptAttach;
/** 同意按钮点击的回调 */
@property (nonatomic, strong) AgreeButtonDidClickBlcok agreeButtonDidClickBlcok;
/** 拒绝按钮点击的回调 */
@property (nonatomic, strong) RejectButtonDidClickBlcok rejectButtonDidClickBlcok;
@end

NS_ASSUME_NONNULL_END
