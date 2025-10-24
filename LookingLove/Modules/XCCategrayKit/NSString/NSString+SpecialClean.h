//
//  NSString+SpecialClean.h
//  YYMobileFramework
//
//  Created by JianchengShi on 2015/1/15.
//  Copyright (c) 2015年 YY Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SpecialClean)

/// 去除首部空格
- (NSString *)cleanLeftSpace;

/// 去除尾部空格
- (NSString *)cleanRightSpace;

/// 去除首尾空格
- (NSString *)cleanSpace;

/// 去除首尾空格和换行
- (NSString *)cleanSpaceAndWrap;

/// 去除字符串首部连续字符（如空格） [NSCharacterSet whitespaceCharacterSet]
- (NSString *)stringByTrimmingLeftCharactersInSet:(NSCharacterSet *)characterSet;

/// 去除字符串尾部连续字符（如空格） [NSCharacterSet whitespaceCharacterSet]
- (NSString *)stringByTrimmingRightCharactersInSet:(NSCharacterSet *)characterSet;

- (NSString *)cleanSpecialText;

@end
