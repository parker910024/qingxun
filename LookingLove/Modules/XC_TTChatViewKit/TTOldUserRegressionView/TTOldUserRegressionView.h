//
//  TuTuOldUserRegressionView.h
//  XCErBan
//
//  Created by 卫明 on 2018/10/29.
//  Copyright © 2018 TuTu. All rights reserved.
//  老用户回归

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//是否已显示老用户回归储存标识符
extern NSString *const TTOldUserRegressionViewShowStatusStoreKey;

@interface TTOldUserRegressionView : UIView

+ (void)show;

@end

NS_ASSUME_NONNULL_END
