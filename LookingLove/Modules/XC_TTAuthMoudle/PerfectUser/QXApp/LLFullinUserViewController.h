//
//  LLFullinUserViewController.h
//  XC_TTAuthMoudle
//
//  Created by apple on 2019/7/25.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "BaseUIViewController.h"
#import "UserCore.h"

@class AppleAccountInfo;

NS_ASSUME_NONNULL_BEGIN

@interface LLFullinUserViewController : BaseUIViewController

/**
 是否选择是男性
 */
@property (nonatomic, assign) BOOL isMan;
//用于判断是不是第三方登录
@property (strong, nonatomic) WeChatUserInfo *weChatInfo;
@property (strong, nonatomic) QQUserInfo *qqInfo;
@property (nonatomic, strong) AppleAccountInfo *appleInfo;

@end

NS_ASSUME_NONNULL_END
