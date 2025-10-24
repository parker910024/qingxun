//
//  TTPositionVipView.h
//  TTPositionView
//
//  Created by fengshuo on 2019/5/20.
//  Copyright © 2019 fengshuo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTPositionVipView : UIView
/** 坑位的默认图*/
@property (nonatomic,strong) UIImageView *positionSeatImageView;
/** VIP的坑位光圈*/
@property (nonatomic,strong) UIImageView *positionVipImageView;
/** 开始转动*/
- (void)positionVipStartAnimation;
/** 结束转动*/
- (void)positionVipStopAnimation;
/** 隐藏土豪位*/
- (void)hiddenPositionVipView;
/** 显示土豪位*/
- (void)showPositionVipView;
@end

NS_ASSUME_NONNULL_END
