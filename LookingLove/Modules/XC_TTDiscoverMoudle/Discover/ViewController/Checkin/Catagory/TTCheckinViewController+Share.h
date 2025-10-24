//
//  TTCheckinViewController+Share.h
//  TTPlay
//
//  Created by lvjunhang on 2019/3/21.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTCheckinViewController.h"
#import "XCShareView.h"
#import "ShareCoreClient.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTCheckinViewController (Share)<XCShareViewDelegate, ShareCoreClient>

/**
 分享签到图片
 */
- (void)shareCheckinImage;

@end

NS_ASSUME_NONNULL_END
