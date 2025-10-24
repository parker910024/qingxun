//
//  UIButton+EnlargeTouchArea.m
//  XCCategrayKit
//
//  Created by Macx on 2018/8/30.
//  Copyright © 2018年 KevinWang. All rights reserved.
//

#import "UIButton+EnlargeTouchArea.h"
#import <objc/runtime.h>

@implementation UIButton (EnlargeTouchArea)


//定义常量 必须是C语言字符串
static const char *imageFrameStr = "imageFrame";
static const char *titleFrameStr = "titleFrame";

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method newImageMethod = class_getInstanceMethod(self, @selector(new_imageRectForContentRect:));
        Method oldImageMethod = class_getInstanceMethod(self, @selector(imageRectForContentRect:));
        method_exchangeImplementations(newImageMethod, oldImageMethod);
        
        Method newTitleMethod = class_getInstanceMethod(self, @selector(new_titleRectForContentRect:));
        Method oldTitleMethod = class_getInstanceMethod(self, @selector(titleRectForContentRect:));
        method_exchangeImplementations(newTitleMethod, oldTitleMethod);
    });
}

- (void)setImageFrame:(NSValue *)imageFrame{
    objc_setAssociatedObject(self, imageFrameStr, imageFrame, OBJC_ASSOCIATION_RETAIN);
}

- (NSValue *)imageFrame{
    return objc_getAssociatedObject(self, imageFrameStr);
}

- (void)setTitleFrame:(NSValue *)titleFrame{
    objc_setAssociatedObject(self, titleFrameStr, titleFrame, OBJC_ASSOCIATION_RETAIN);
}

- (NSValue *)titleFrame{
    return objc_getAssociatedObject(self, titleFrameStr);
}

- (CGRect)new_imageRectForContentRect:(CGRect)contentRect{
    if (CGRectEqualToRect(self.imageFrame.CGRectValue, CGRectZero)) {
        return [self new_imageRectForContentRect:contentRect];
    }
    return self.imageFrame.CGRectValue;
}

- (CGRect)new_titleRectForContentRect:(CGRect)contentRect{
    if (CGRectEqualToRect(self.titleFrame.CGRectValue, CGRectZero)) {
        return [self new_titleRectForContentRect:contentRect];
    }
    return self.titleFrame.CGRectValue;
}



static char topNameKey;
static char rightNameKey;
static char bottomNameKey;
static char leftNameKey;

- (void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left
{
    objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:top], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:right], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:bottom], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:left], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)enlargeTouchArea:(UIEdgeInsets)insets
{
    [self setEnlargeEdgeWithTop:insets.top
                          right:insets.right
                         bottom:insets.bottom
                           left:insets.left];
}

- (CGRect)enlargedRect
{
    NSNumber* topEdge = objc_getAssociatedObject(self, &topNameKey);
    NSNumber* rightEdge = objc_getAssociatedObject(self, &rightNameKey);
    NSNumber* bottomEdge = objc_getAssociatedObject(self, &bottomNameKey);
    NSNumber* leftEdge = objc_getAssociatedObject(self, &leftNameKey);
    if (topEdge && rightEdge && bottomEdge && leftEdge)
    {
        return CGRectMake(self.bounds.origin.x - leftEdge.floatValue,
                          self.bounds.origin.y - topEdge.floatValue,
                          self.bounds.size.width + leftEdge.floatValue + rightEdge.floatValue,
                          self.bounds.size.height + topEdge.floatValue + bottomEdge.floatValue);
    }
    else
    {
        return self.bounds;
    }
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event
{
    if(self.hidden) return nil;
    CGRect rect = [self enlargedRect];
    if (CGRectEqualToRect(rect, self.bounds))
    {
        return [super hitTest:point withEvent:event];
    }
    return CGRectContainsPoint(rect, point) ? self : nil;
}

@end
