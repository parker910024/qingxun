//
//  TTRedDrawView.h
//  XC_TTRoomMoudle
//
//  Created by lvjunhang on 2020/5/14.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//  抢红包

#import <UIKit/UIKit.h>
#import "TTRedDrawResultView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TTRedDrawViewAction) {//红包列表操作类型
    TTRedDrawViewActionClose,//关闭
    TTRedDrawViewActionDraw,//抢红包
    TTRedDrawViewActionFocus,//关注
    TTRedDrawViewActionSend,//发红包
    TTRedDrawViewActionRecord,//红包记录
};

@class TTRedDrawView;

@protocol TTRedDrawViewDelegate <NSObject>
/// 抢红包的操作
- (void)redDrawView:(TTRedDrawView *)view didAction:(TTRedDrawViewAction)action;
@end

@class RoomRedDetail;

@interface TTRedDrawView : UIView
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIView *drawBgView;

@property (nonatomic, weak) id<TTRedDrawViewDelegate> delegate;
@property (nonatomic, strong) RoomRedDetail *model;

/// 显示动画
- (void)showAnimation;

/// 显示抢红包结果动画
- (void)showDrawResultAnimationWithView:(TTRedDrawResultView *)drawResultView;

@end

NS_ASSUME_NONNULL_END
