//
//  NSMutableAttributedString+Chain.h
//  XCCategrayKit
//
//  Created by KevinWang on 2019/10/25.
//  Copyright © 2019 WUJIE INTERACTIVE. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableAttributedString (Chain)

/// 设置字体属性
- (NSMutableAttributedString * (^)(UIFont *font))font;
/// 设置指定范围字体属性
- (NSMutableAttributedString * (^)(UIFont *font, NSRange range))rangeFont;


/// 设置字体颜色
- (NSMutableAttributedString * (^)(UIColor *color))color;
/// 设置指定范围字体颜色
- (NSMutableAttributedString * (^)(UIColor *color, NSRange range))rangeColor;

@end

NS_ASSUME_NONNULL_END
