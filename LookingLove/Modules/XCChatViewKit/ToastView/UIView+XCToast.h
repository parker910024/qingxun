//
//  UIView+Toast.h
//  YYMobile
//
//  Created by 武帮民 on 14-7-21.
//  Copyright (c) 2014年 YY.inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YYToastPosition)
{
    YYToastPositionBottom,
    YYToastPositionBottomWithTabbar,
    YYToastPositionCenter,
    YYToastPositionTop,
    YYToastPositionAboveKeyboard,
    YYToastPositionBottomWithRecordButton,
    
    YYToastPositionDefault = YYToastPositionBottom,
};

@interface UIView (XCToast)

// 展示Toast
- (void)showToastView:(UIView *)toast
             duration:(CGFloat)interval
             position:(YYToastPosition)position;

- (void)showToastView:(UIView *)toast
             duration:(CGFloat)interval
             position:(YYToastPosition)position
             animated:(BOOL)animated;

- (void)showToastView:(UIView *)toastView
             duration:(CGFloat)interval
             position:(YYToastPosition)position
userInteractionEnabled:(BOOL)userInteractionEnabled
             animated:(BOOL)animated;

- (void)showToastView:(UIView *)toastView
             duration:(CGFloat)interval
             position:(YYToastPosition)position
userInteractionEnabled:(BOOL)userInteractionEnabled;

/**
 *  显示提示视图，视图的位置将使用 toastView 的 frame 值
 *
 *  @param toastView 待显示的提示视图
 *  @param interval  提示视图显示的时间间隔
 *  @param animated  显示时是否带动画
 */
- (void)showToastView:(UIView *)toastView
             duration:(CGFloat)interval
             animated:(BOOL)animated;


// 隐藏 Toast
- (void)hideToastView;

- (void)hideToastViewAnimated:(BOOL)animated;


@end

@interface UIView (HudToast)

/**
 * message : 需要显示的文本
 * text : 需要高亮显示的文本
 * color : 高亮文本颜色
 * position: 需要显示的位置
 */
+ (void)showToastInKeyWindow:(NSString *)message;
+ (void)showToastInKeyWindow:(NSString *)message duration:(CGFloat)interval;
+ (void)showToastInKeyWindow:(NSString *)message
                    duration:(CGFloat)interval
                    position:(YYToastPosition)position;

- (void)showToast:(NSString *)message;
- (void)showToast:(NSString *)message
         position:(YYToastPosition)position;
- (void)showToastWithMessage:(NSString *)message
                    duration:(CGFloat)interval
                    position:(YYToastPosition)position;

- (void)showToast:(NSString *)message
    highlightText:(NSString *)text
   highlightColor:(UIColor *)color;

- (void)showToast:(NSString *)message
    highlightText:(NSString *)text
   highlightColor:(UIColor *)color
         position:(YYToastPosition)position;


/**
 显示Toast兼容旧版本接口

 @param success 文案
 */
+ (void)showSuccess:(NSString *)success;

/**
 显示Toast兼容旧版本接口

 @param success 文案
 @param view 显示的view
 */
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

/**
 显示Toast兼容旧版本接口
 
 @param error 文案
 */
+ (void)showError:(NSString *)error;

/**
 显示Toast兼容旧版本接口
 
 @param error 文案
 @param view 显示的view
 */
+ (void)showError:(NSString *)error toView:(UIView *)view;

/**
 显示Toast兼容旧版本Loading接口
 
 @param message 文案
 */
+ (void)showMessage:(NSString *)message;


/**
 显示Toast兼容旧版本Loading接口   限时 2.5s 消失
 
 @param message 文案
 */
+ (void)showMessageCPGame:(NSString *)message WithDruation:(CGFloat )duration;

/**
 显示Toast兼容旧版本Loading接口
 
 @param message 文案
 @param view 显示的view
 */
+ (void)showMessage:(NSString *)message toView:(UIView *)view;

/**
 隐藏Toast兼容旧版本接口
*/
+ (void)hideHUD;

/**
 隐藏Toast兼容旧版本接口
 
 @param view 显示的view
 */
+ (void)hideHUDForView:(UIView *)view;

@end


@interface UIView (LoadingToast)

// view中间 显示一个正在加载的动画
- (void)showLoadingToast;
- (void)showLoadingToastDuration:(CGFloat)interval;
- (void)showLoadingToastDuration:(CGFloat)interval completion:(void (^)(void))completion;
//坐标加偏移量
- (void)showLoadingToastWithOffsetY:(NSInteger)offsetY;

/**
 显示加载Toast（实例方法）

 @param interval 显示时常
 @param msg 文案
 */
- (void)showLoadingToastDuration:(CGFloat)interval msg:(NSString *)msg;

/**
 显示加载Toast（类方法）
 
 @param interval 显示时常
 @param msg 文案
 */
+ (void)showLoadingToastDuration:(CGFloat)interval msg:(NSString *)msg;

/**
 显示加载Toast（类方法）
 
 @param interval 显示时常
 */
+ (void)showLoadingToastDuration:(CGFloat)interval;

/**
 隐藏Toast
 */
+ (void)hideToastView;

@end

@interface UIView (EmptyToast)

/** 是否需要开启交互，默认为NO。一般用于被展位图遮挡视图 UI 之后，无法进行事件响应的处理 */
@property (nonatomic, assign) BOOL emptyViewInteractionEnabled;

- (void)showToast:(NSString*)message duration:(CGFloat)dur position:(YYToastPosition)position image:(UIImage*)image;

- (void)showEmptyContentToastWithTitle:(NSString *)title;
- (void)showEmptyContentToastWithTitle:(NSString *)title andImage:(UIImage *)image;
- (void)showEmptyContentToastWithTitle:(NSString *)title tapBlock:(void (^)(void))tapBlock;

- (void)showEmptyContentToastWithAttributeString:(NSAttributedString *)attrStr;
- (void)showEmptyContentToastWithAttributeString:(NSAttributedString *)attrStr tapBlock:(void (^)(void))tapBlock;
- (void)showNoSearchResultToastWithSearchKey:(NSString *)searchKey tapBlock:(void (^)(void))tapBlock;


- (void)showNetworkDisconnectToastWithPosition:(YYToastPosition)position;
+ (void)showNetworkDisconnectToastInKeyWindowWithPosition:(YYToastPosition)position;

- (void)showNetworkErrorToastWithTitle:(NSString *)title;
- (void)showNetworkErrorToastWithTitle:(NSString *)title tapBlock:(void (^)(void))tapBlock;

@end
