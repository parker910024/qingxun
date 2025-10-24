//
//  XCCountdownView.h
//  XCRoomMoudle
//
//  Created by JarvisZeng on 2019/5/8.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XCCountdownView : UIView
- (void)updateTimeLeft:(int)timeLeft; // 更新倒计时
- (void)stopCountdown; // 活动结束，停止计时
@end

NS_ASSUME_NONNULL_END
