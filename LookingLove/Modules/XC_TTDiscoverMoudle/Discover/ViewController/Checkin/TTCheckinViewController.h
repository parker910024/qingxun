//
//  TTCheckinViewController.h
//  TTPlay
//
//  Created by lvjunhang on 2019/3/18.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  签到

#import "BaseUIViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTCheckinViewController : BaseUIViewController

@property (nonatomic, copy) NSString *shareImageURL;//分享图片 URL

@property (nonatomic, assign) NSInteger replenishSignDay;//当前补签日期
@property (nonatomic, assign) BOOL isReplenishShare;//是否为分享补签弹窗

@property (nonatomic, copy) void (^signSuccessBlock)(void);//签到成功回调

/**
 分享
 */
- (void)shareButtonTapped;

@end

NS_ASSUME_NONNULL_END
