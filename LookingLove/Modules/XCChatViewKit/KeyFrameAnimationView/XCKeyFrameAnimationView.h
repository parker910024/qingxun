//
//  XCKeyFrameAnimationView.h
//  XCChatViewKit
//
//  Created by KevinWang on 2019/3/3.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XCKeyFrameAnimationView : UIView
/** 资源数组*/
@property (nonatomic, strong)  NSArray<UIImage *> *animationImages;
/** 动画时间*/
@property (nonatomic, assign) NSTimeInterval animationDuration;
/** 重复次数*/
@property (nonatomic, assign) NSInteger animationRepeatCount;
@property (nonatomic, assign, getter=isAnimating) BOOL animating;

/** start*/
- (void)startAnimating;
/** stop*/
- (void)stopAnimating;

@end

NS_ASSUME_NONNULL_END
