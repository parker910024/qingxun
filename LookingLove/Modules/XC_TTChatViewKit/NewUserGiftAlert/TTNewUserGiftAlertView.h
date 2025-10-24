//
//  TTNewUserGiftAlertView.h
//  XC_TTChatViewKit
//
//  Created by lee on 2019/7/3.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^didFinishHandler)(void);

@interface TTNewUserGiftAlertView : UIView

@property (nonatomic, copy) didFinishHandler finishHandler;

/** 改变按钮状态 */
- (void)changeConfirmButtonState;

@end

NS_ASSUME_NONNULL_END
