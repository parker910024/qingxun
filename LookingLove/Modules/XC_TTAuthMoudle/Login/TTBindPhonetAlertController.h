//
//  TTBindPhonetAlertController.h
//  XC_TTAuthMoudle
//
//  Created by JarvisZeng on 2019/4/16.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "BaseUIViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^DismissBlcok)(void);
@interface TTBindPhonetAlertController : BaseUIViewController

/**
 * 控制器消失的回调
 */
@property (nonatomic, strong) DismissBlcok dismissBlcok;
@end

NS_ASSUME_NONNULL_END
