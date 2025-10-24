//
//  NSMutableAttributedString+Chain.m
//  XCCategrayKit
//
//  Created by KevinWang on 2019/10/25.
//  Copyright © 2019 WUJIE INTERACTIVE. All rights reserved.
//

#import "NSMutableAttributedString+Chain.h"

@implementation NSMutableAttributedString (Chain)

/// 设置字体属性
- (NSMutableAttributedString * (^)(UIFont *))font {
    
    return ^id(UIFont *font) {
        [self addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, self.length)];
        return self;
    };
}
/// 设置字体属性,范围
- (NSMutableAttributedString * (^)(UIFont *, NSRange))rangeFont {
    
    return ^id(UIFont *font, NSRange range) {
        [self addAttribute:NSFontAttributeName value:font range:range];
        return self;
    };
}

/// 设置字体颜色
- (NSMutableAttributedString * (^)(UIColor *))color{
    
    return ^id(UIColor *color){
        [self addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, self.length)];
        return self;
    };
}
/// 设置字体颜色，范围
- (NSMutableAttributedString * (^)(UIColor *, NSRange))rangeColor{
    
    return ^id(UIColor *color, NSRange range){
        [self addAttribute:NSForegroundColorAttributeName value:color range:range];
        return self;
    };
}

@end
