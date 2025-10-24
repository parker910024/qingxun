//
//  TTMp4PlayerClient.h
//  CeEr
//
//  Created by jiangfuyuan on 2021/8/4.
//  Copyright © 2021 WUJIE INTERACTIVE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@protocol TTMp4PlayerClient <NSObject>

/// mp4播放完成的回调
/// @param container 当前播放Mp4的View
- (void)viewDidStopPlayWithView:(UIView *)container;

@end

NS_ASSUME_NONNULL_END
