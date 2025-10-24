//
//  TTRollView.h
//  AFNetworking
//
//  Created by apple on 2019/7/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WBRollView : UIView

@property (nonatomic, readonly) UILabel *marqueeLabel;
@property (nonatomic, strong) UIColor *color;

/// 文字重复滚动，默认：YES
@property (nonatomic, assign) BOOL repectAnimation;

//重启动画
- (void)startAnimation;


/// 停止动画
/// @param duration 是否需要延时停止动画
- (void)stopAnimation:(CGFloat)duration;
@end

NS_ASSUME_NONNULL_END
