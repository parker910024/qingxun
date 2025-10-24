//
//  XCNumberTool.h
//  Allo
//
//  Created by apple on 2019/1/28.
//  Copyright © 2019 yizhuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XCNumberTool : NSObject

/**
 获取个位数
 */
+ (NSInteger)getUnits:(NSInteger)targetInt;

/**
 获取十位数
 */
+ (NSInteger)getTens:(NSInteger)targetInt;

/**
 获取百位数
 */
+ (NSInteger)getHundreds:(NSInteger)targetInt;

/**
 获取千位数
 */
+ (NSInteger)getThousands:(NSInteger)targetInt;

@end

NS_ASSUME_NONNULL_END
