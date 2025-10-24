//
//  UIView+MultipleIndicator.h
//  YY2
//
//  Created by graoke on 13-11-15.
//  Copyright (c) 2013年 YY Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (MultipleIndicator)

@property (nonatomic, strong, readonly) NSMutableDictionary *indicatorLayers;

- (void)addIndicatorWithKey:(id)key;
- (void)removeIndicatorWithKey:(id)key;

- (void)resetIndicatorOrigin:(CGPoint)indicatorOrigin forkey:(id)key;
- (CGPoint)getindicatorOriginForkey:(id)key;

@end
