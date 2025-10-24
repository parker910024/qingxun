//
//  NSString+Utils.m
//  YYMobileFramework
//
//  Created by 小城 on 14-6-24.
//  Copyright (c) 2014年 YY Inc. All rights reserved.
//
#import "NSString+Utils.h"

@implementation NSString (Utils)

static NSNumberFormatter* numberFormatter()
{
    static id formatter = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        formatter = [[NSNumberFormatter alloc] init];
    });
    return formatter;
}


- (uint32_t)unsignedIntValue
{
    NSNumber *number = nil;
    @synchronized(numberFormatter()) {
        NSNumberFormatter * formatter = numberFormatter();
        number = [formatter numberFromString:self];
    }
    return [number unsignedIntValue];
}

- (uint16_t)unsignedShortValue {
    
    NSNumber *number = nil;
    @synchronized(numberFormatter()) {
        NSNumberFormatter * formatter = numberFormatter();
        number = [formatter numberFromString:self];
    }
    return [number unsignedShortValue];
}

+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
             
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    return returnValue;
}


/**
 文本中包含 emoji 的数量
 
 @param string 文本内容
 @param continuous 是否是连续的 emoji。默认不是，所显示的数量为文本中全部的 emoji 数，默认传空就行。如果是则需要输入正则规则，例如 @"3,5"，所表达的意思是最少连续 emoji，最多 5 个。
 @return  emoji 的数量
 */
+ (NSInteger)countOfStringContainsEmoji:(NSString *)string needContinuous:(NSString *)continuous {
    // 此处正则代表着有文本中有多少 emoji， 最少连续三个，最多不设上限
    NSString *pattern = @"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f]";
    if (continuous) {
        pattern = [NSString stringWithFormat:@"%@%@", pattern,continuous];
    }
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    // 匹配到符合规则的数量大于 0 就暂且认为是暗号邀请码，可以调用接口
    NSInteger nums = [regex numberOfMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, [string length])];
    return nums;
}

+ (NSString*)numberStringFromNumber:(NSNumber*)number withPrefixString:(NSString*)prefix{
    if (number == nil)
    {
        return nil;
    }
    NSString *tmpPrefix = prefix;
    if (prefix != nil && ![prefix isEqualToString:@""])
    {
        tmpPrefix = [NSString stringWithFormat:@"%@：", prefix];
    }
    else
    {
        tmpPrefix = @"";
    }
    NSString *ret = [NSString stringWithFormat:@"%@%@", tmpPrefix, number];
    if (number.unsignedIntValue / 10000 >= 1)
    {
        ret = [NSString stringWithFormat:@"%@%.1f万", tmpPrefix, number.unsignedIntValue / 10000.0];
    }
    return ret;
}

+ (NSString *)convertTime:(CGFloat)second{
    NSUInteger hour = second/3600;
    NSUInteger minute = (second - hour * 3600)/60;
    NSUInteger seconds = (second - hour * 3600 - minute * 60);
    
    NSString *hourFormat = (hour >= 10 ? @"%lu" : @"0%lu");
    NSString *minuteFormat = (minute >= 10 ? @":%lu" : @":0%lu");
    NSString *secondFormat = (seconds >= 10 ? @":%lu" : @":0%lu");
    
    return [NSString stringWithFormat:[[hourFormat stringByAppendingString:minuteFormat] stringByAppendingString:secondFormat], hour, minute, seconds];
}

#pragma mark - 把大长串的数字做单位处理
+ (NSString *)changeAsset:(NSString *)amountStr
{
    if (amountStr && ![amountStr isEqualToString:@""])
    {
        double num = [amountStr doubleValue];
        if (num<10000)
        {
            return amountStr;
        }else{
            NSString *str = [NSString stringWithFormat:@"%.2f",num/10000.0];
            NSRange range = [str rangeOfString:@"."];
            str = [str substringToIndex:range.location+3];
            if ([str hasSuffix:@".0"]){
                return [NSString stringWithFormat:@"%@万",[str substringToIndex:str.length-2]];
            }else{
                return [NSString stringWithFormat:@"%@万",str];
            }
        }
    }else{
        return @"0";
    }
}

+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

+ (CGSize)sizeThatFitsWithText:(NSString *)text maxSize:(CGSize)maxSize font:(UIFont *)font {
    UILabel *label = [UILabel new];
    label.font = font;
    label.numberOfLines = 0;
    label.text = text;
    CGSize size = [label sizeThatFits:maxSize];
    return size;
}
@end
