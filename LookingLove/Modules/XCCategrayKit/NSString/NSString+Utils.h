//
//  NSString+Utils.h
//  YYMobileFramework
//
//  Created by 小城 on 14-6-24.
//  Copyright (c) 2014年 YY Inc. All rights reserved.
//
#import <UIKit/UIKit.h>
@interface NSString (Utils)

- (uint32_t)unsignedIntValue;

- (uint16_t)unsignedShortValue;


/**
 判断文本中是否有 emoji 表情

 @param string 文本内容
 @return 是否
 */
+ (BOOL)stringContainsEmoji:(NSString *)string;

/**
 文本中包含 emoji 的数量
 
 @param string 文本内容
 @param continuous 是否是连续的 emoji。默认不是，所显示的数量为文本中全部的 emoji 数，默认传空就行。如果是则需要输入正则规则，例如 @"3,5"，所表达的意思是最少连续 emoji，最多 5 个。
 @return  emoji 的数量
 */
+ (NSInteger)countOfStringContainsEmoji:(NSString *)string needContinuous:(NSString *)continuous;

/**
 *  显示诸如  粉丝：3000  粉丝：34.2万
 *
 *  @param number 数量
 *  @param prefix 前缀词，比如"粉丝"
 *
 *  @return 返回拼接后的词
 */
+ (NSString*)numberStringFromNumber:(NSNumber*)number withPrefixString:(NSString*)prefix;

/**
 *  秒数 转换为 xx:xx:xx 的时间格式
 *  比如 输出03:20:34  输入则为 3 * 60 * 60 + 20 * 60 + 34 = 12034
 *
 *  @param second 秒数
 *
 *  @return 返回 转换后的字符串
 */
+ (NSString *)convertTime:(CGFloat)second;

/**
 根据家族币的数量 超过一万 显示万
 @param amountStr 金币的数量
 @return 返回拼接好的字符串
 */
+ (NSString *)changeAsset:(NSString *)amountStr;
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize;

/**
 计算文本高度, 使用的是UILabel的SizeThatFits计算

 @param text 文本
 @param maxSize 显示尺寸
 @param font 字体
 @return 文本尺寸
 */
+ (CGSize)sizeThatFitsWithText:(NSString *)text maxSize:(CGSize)maxSize font:(UIFont *)font;
@end
