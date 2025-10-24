//
//  XCBoxCirtProgressView.h
//  XC_MSRoomMoudle
//
//  Created by KevinWang on 2019/4/14.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static int kProgressViewWidth = 180;

@interface XCBoxCirtProgressView : UIView

- (void)startProgressWithTotalTime:(int)totalTime alreadyStartedTime:(int)alreadyStartedTime;

- (void)endTimer;

@end

NS_ASSUME_NONNULL_END
