//
//  LLQuickLoginCTMobileController.h
//  XC_TTAuthMoudle
//
//  Created by lee on 2020/3/24.
//  Copyright © 2020 YiZhuan. All rights reserved.
//

#import "BaseUIViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLQuickLoginCTMobileController : BaseUIViewController

// token
@property (nonatomic, copy) NSString *token;
/// 当前使用运营商的电话号码
@property (nonatomic, copy) NSString *securityPhone;
@end

NS_ASSUME_NONNULL_END
