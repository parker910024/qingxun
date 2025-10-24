//
//  LLGameHomeContainerViewController+Checkin.h
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2019/7/25.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "LLGameHomeContainerViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLGameHomeContainerViewController (Checkin)

/**
 请求签到详情接口
 */
- (void)requestSignDetail;

/**
 显示签到页面
 */
- (void)showCheckinView;

/**
 移除签到页面
 */
- (void)dismissCheckinView;

@end

NS_ASSUME_NONNULL_END
