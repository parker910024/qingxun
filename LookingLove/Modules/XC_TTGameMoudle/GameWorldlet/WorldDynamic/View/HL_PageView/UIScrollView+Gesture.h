//
//  UIScrollView+Gesture.h
//  LTChat
//
//  Created by apple on 2019/7/31.
//  Copyright © 2019 wujie. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (Gesture)
///是否支持多手势滑动
@property (nonatomic, assign) BOOL isMultiGesture;

@end

NS_ASSUME_NONNULL_END
