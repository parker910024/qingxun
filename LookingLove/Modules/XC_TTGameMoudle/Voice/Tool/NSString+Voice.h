//
//  NSString+Voice.h
//  XC_TTGameMoudle
//
//  Created by Macx on 2019/6/6.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Voice)
/**
 将数量格式化为字符串 万之后用xx.xx万显示并保留小数点2位，最多显示9999万+；

 @param number 数值
 @return 格式化后的字符串
 */
+ (NSString *)countNumberFormatStr:(NSInteger)number;
@end

NS_ASSUME_NONNULL_END
