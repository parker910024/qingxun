//
//  UIButton+EnlargeTouchArea.h
//  XCCategrayKit
//
//  Created by Macx on 2018/8/30.
//  Copyright © 2018年 KevinWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (EnlargeTouchArea)

//图片frmae
@property (strong, nonatomic) NSValue *imageFrame;
//标题frmae
@property (strong, nonatomic) NSValue *titleFrame;

/**
 通过 hitTest:withEvent: 扩大btn的点击范围
 注：填写的都是 在button 原frame 上面 扩大的对应的值

 @param top 顶部 扩大的值
 @param right 右边  扩大的值
 @param bottom 底部  扩大的值
 @param left 左边  扩大的值
 */
- (void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;

/**
 扩大按钮点击范围
 
 @discussion setEnlargeEdgeWithTop:right:bottom:left:方法的包装
 */
- (void)enlargeTouchArea:(UIEdgeInsets)insets;

@end
