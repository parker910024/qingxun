//
//  NSString+Regex.h
//  YYMobileFramework
//
//  Created by wuwei on 14/6/11.
//  Copyright (c) 2014年 YY Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Regex)

/*!
 @method			matchesRegex:options:
 @discussion		This method determines whether the pattern is matched.
 @param pattern		The regular expression to be used.
 @param options		The options to be used.
 @return			A boolean value denoting whether the pattern was matched.
 @see				http://developer.apple.com/library/ios/#documentation/Foundation/Reference/NSRegularExpression_Class/Reference/Reference.html
 @see				http://quickies.seriot.ch/index.php?id=279
 */
- (BOOL)matchesRegex: (NSString *)pattern options:(NSRegularExpressionOptions)options;

- (BOOL)isPhoneNumber;

- (BOOL)isPureNumber;

+ (BOOL)isEmpty:(NSString *) str;

/** 判断用户输入的密码是否符合规范，符合规范的密码要求：
1. 长度大于8位
2. 密码中必须同时包含数字和字母
*/
- (BOOL)judgePassWordLegal;
@end
