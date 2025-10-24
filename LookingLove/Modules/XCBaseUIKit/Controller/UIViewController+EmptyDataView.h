//
//  UIViewController+EmptyDataView.h
//  XChat
//
//  Created by KevinWang on 2017/11/28.
//  Copyright © 2017年 XC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (EmptyDataView)

- (void)showEmptyDataViewWithTitle:(NSString *)title;
- (void)showEmptyDataViewWithTitle:(NSString *)title complete:(void(^)(void))complete;
- (void)showEmptyDataViewWithTitle:(NSString *)title view:(UIView *)view complete:(void(^)(void))complete;

- (void)removeEmptyDataView;
- (void)removeEmptyDataViewComplete:(void(^)(void))complete;


// ==================new=======================
/**
 展示空数据的View, 默认添加在控制器的view上
 
 @param title  自定义描述标题
 @param image  自定义空图片
 @param enable emptyDataView是否需要交互
 */
- (void)showEmptyDataViewWithTitle:(NSString *)title image:(UIImage *)image;
- (void)showEmptyDataViewWithTitle:(NSString *)title image:(UIImage *)image needInteractionEnabled:(BOOL)enable;

/**
 展示空数据的View, 默认添加在控制器的view上
 
 @param title 自定义描述标题
 @param image 自定义空图片
 @param enable emptyDataView是否需要交互
 @param complete 展示完毕后的回调
 */

- (void)showEmptyDataViewWithTitle:(NSString *)title image:(UIImage *)image complete:(void(^)(void))complete;
- (void)showEmptyDataViewWithTitle:(NSString *)title image:(UIImage *)image needInteractionEnabled:(BOOL)enable complete:(void(^)(void))complete;

/**
 展示空数据的View
 
 @param title 自定义描述标题
 @param image 自定义空图片
 @param view 父控件
 @param enable emptyDataView是否需要交互
 @param complete 展示完毕后的回调
 */
- (void)showEmptyDataViewWithTitle:(NSString *)title image:(UIImage *)image view:(UIView *)view complete:(void(^)(void))complete;
- (void)showEmptyDataViewWithTitle:(NSString *)title image:(UIImage *)image offsetY:(CGFloat)offsetY view:(UIView *)view complete:(void(^)(void))complete;

// 新加一个color 属性 自定义title文字颜色
- (void)showEmptyDataViewWithTitle:(NSString *)title color:(UIColor *)color image:(UIImage *)image offsetY:(CGFloat)offsetY view:(UIView *)view complete:(void(^)(void))complete;
- (void)showEmptyDataViewWithTitle:(NSString *)title image:(UIImage *)image view:(UIView *)view needInteractionEnabled:(BOOL)enable complete:(void(^)(void))complete;


/**
 展示加载失败的View
 
 @param title 自定义描述标题
 @param image 自定义空图片
 */
- (void)showLoadFailViewWithTitle:(NSString *)title image:(UIImage *)image;
- (void)showLoadFailViewWithTitle:(NSString *)title image:(UIImage *)image complete:(void(^)(void))complete;
- (void)showLoadFailViewWithTitle:(NSString *)title image:(UIImage *)image view:(UIView *)view complete:(void(^)(void))complete;

/**
 提示加载失败, 点击重试时会调用此方法, 控制器中请重写此方法, 重新请求数据
 */
- (void)reloadDataWhenLoadFail;
@end
