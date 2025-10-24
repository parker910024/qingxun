//
//  TTPopupServiceProtocol.h
//  XC_TTChatViewKit
//
//  Created by lvjunhang on 2019/5/21.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTPopupConstants.h"

typedef NS_ENUM(NSUInteger, TTPopupShowType) {
    TTPopupShowType_FadeIn = 1,
    TTPopupShowTypeDefault = 8,
};

@class UIView;

@protocol TTPopupServiceProtocol <NSObject>

/**
 弹窗样式，默认：TTPopupStyleAlert
 */
@property (nonatomic, assign) TTPopupStyle style;

/**
 弹窗优先级权重，默认：TTPopupPriorityNormal
 
 @discussion 权重越高在弹窗队列的优先级越高，即优先弹出；相同权重按先来后到原则
 */
@property (nonatomic, assign) TTPopupPriority priority;

/**
 自定义视图内容，默认：nil
 
 @discussion 如果未配置，或 contentView 未继承自 UIView 及其子类，将忽略该弹窗
 */
@property (nonatomic, strong) UIView *contentView;

/**
 背景蒙层透明度，默认：0x000000 0.3 alpha
 
 @discussion 由于第三方原因，暂不支持蒙层颜色修改
 */
@property (nonatomic, assign) CGFloat maskBackgroundAlpha;

/**
 点击蒙层是否消除弹窗，默认：YES
 */
@property (nonatomic, assign) BOOL shouldDismissOnBackgroundTouch;

/**
 弹窗消失回调，isDismissOnBackgroundTouch 区分是否点击蒙层触发
 */
@property (nonatomic, copy) void (^didFinishDismissHandler)(BOOL isDismissOnBackgroundTouch);

/**
 弹窗显示成功回调
 */
@property (nonatomic, copy) void (^didFinishShowingHandler)(void);

/**
 重复弹窗过滤，默认：NO
 
 @discussion 设置过滤时，队列中将不会出现相同过滤标识的弹窗
 过滤标识通过 #<filterIdentifier> 设置
 */
@property (nonatomic, assign) BOOL shouldFilterPopup;

/**
 过滤标识，默认：nil
 */
@property (nonatomic, copy) NSString *filterIdentifier;

/**
 显示动画类型, 默认是 default
 */
@property (nonatomic, assign) TTPopupShowType showType;
@end
