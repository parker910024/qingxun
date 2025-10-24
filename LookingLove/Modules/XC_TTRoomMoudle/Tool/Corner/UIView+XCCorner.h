//
//  UIView+XCCorner.h
//  XCChatViewKit
//
//  Created by KevinWang on 2019/6/19.
//  Copyright © 2019 WUJIE INTERACTIVE. All rights reserved.


#import <UIKit/UIKit.h>
@class XCCorner;

@interface UIView (XCCorner)

/**
 Add corner to a UIView instance
 给一个UIView对象添加圆角
 @param handler Deal the properities of corner, see XCCorner.
 corner的属性，看XCCorner的介绍
 @warning If you pass nil or clearColor to both 'fillColor' and 'borderColor' params in corner, this method will do nothing.
 如果在corner对象中，fillColor 和 borderColor 都被设置为 nil 或者 clearColor，这个方法什么都不会做。
 */
- (void)updateCornerRadius:(void(^)(XCCorner *corner))handler;

@end
