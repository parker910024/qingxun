//
//  LLBindPhonetAlertController.h
//  XC_TTAuthMoudle
//
//  Created by apple on 2019/7/29.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "BaseUIViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^DismissBlcok)(void);

@interface LLBindPhonetAlertController : UIViewController

/**
 * 控制器消失的回调
 */
@property (nonatomic, strong) DismissBlcok dismissBlcok;

@end

NS_ASSUME_NONNULL_END
