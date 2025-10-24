//
//  TTMusicPlayerSlider.m
//  TuTu
//
//  Created by 卫明 on 2018/11/22.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTMusicPlayerSlider.h"

@interface TTMusicPlayerSlider ()

#define thumbOrgin_x 10
#define thumbOrgin_y 20


@property (nonatomic,assign) CGRect lastRect;

@end

@implementation TTMusicPlayerSlider

- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value {
    
    rect.origin.x = rect.origin.x;
    rect.size.width = rect.size.width ;
    CGRect result = [super thumbRectForBounds:bounds trackRect:rect value:value];
    
    self.lastRect = result;
    return result;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    UIView *result = [super hitTest:point withEvent:event];
    if (point.x < 0 || point.x > self.bounds.size.width){
        
        return result;
        
    }
    
    if ((point.y >= -thumbOrgin_y) && (point.y < self.lastRect.size.height + thumbOrgin_y)) {
        float value = 0.0;
        value = point.x - self.bounds.origin.x;
        value = value/self.bounds.size.width;
        
        value = value < 0? 0 : value;
        value = value > 1? 1: value;
        
        value = value * (self.maximumValue - self.minimumValue) + self.minimumValue;
        [self setValue:value animated:YES];
    }
    return result;
    
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    BOOL result = [super pointInside:point withEvent:event];
    if (!result && point.y > -10) {
        if ((point.x >= self.lastRect.origin.x - thumbOrgin_x) && (point.x <= (self.lastRect.origin.x + self.lastRect.size.width + thumbOrgin_x)) && (point.y < (self.lastRect.size.height + thumbOrgin_y))) {
            result = YES;
        }
        
    }
    return result;
}

@end
