//
//  TTGameViewController+Request.h
//  TTPlay
//
//  Created by new on 2019/3/25.
//  Copyright © 2019 YiZhuan. All rights reserved.
//


#import "TTGameViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTGameViewController (Request)

- (void)requestData:(int)page;

- (UIView *)customHeaderView;

/**
 请求签到详情接口
 */
- (void)requestSignDetail;

@end

NS_ASSUME_NONNULL_END
