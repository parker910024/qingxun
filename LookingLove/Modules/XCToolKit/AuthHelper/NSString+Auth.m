//
//  NSString+Auth.m
//  Pods
//
//  Created by Jarvis Zeng on 2019/4/13.
//

#import "NSString+Auth.h"

@implementation NSString (Auth)
/**
 * 密码是否为数字和字母混合, 允许包含有数字和字母的字符
 */
- (BOOL)isPasswordStrong {
    // 不允许含 emoji
    if ([self isContainsEmoji]) {
        return false;
    }
    
    // digital
    NSRange digitalRange = [self rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]];
    // letter
    NSRange letterRange = [self rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]];
    
    if (digitalRange.location != NSNotFound && letterRange.location != NSNotFound) {
        return true;
    }
    
    return false;
}

/**
 * 是否在范围内
 */
- (BOOL)isLengthInRange:(NSInteger)min max:(NSInteger)max {
    return self.length >= min && self.length <= max;
}

/**
 * emoji 检查
 */
- (BOOL)isContainsEmoji {
    __block BOOL containsEmoji = NO;
    
    [self enumerateSubstringsInRange:NSMakeRange(0,
                                                 [self length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *substring,
                                       NSRange substringRange,
                                       NSRange enclosingRange,
                                       BOOL *stop)
     {
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs &&
             hs <= 0xdbff)
         {
             if (substring.length > 1)
             {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc &&
                     uc <= 0x1f9c0)
                 {
                     containsEmoji = YES;
                 }
             }
         }
         else if (substring.length > 1)
         {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3 ||
                 ls == 0xfe0f ||
                 ls == 0xd83c)
             {
                 containsEmoji = YES;
             }
         }
         else
         {
             // non surrogate
             if (0x2100 <= hs &&
                 hs <= 0x27ff)
             {
                 containsEmoji = YES;
             }
             else if (0x2B05 <= hs &&
                      hs <= 0x2b07)
             {
                 containsEmoji = YES;
             }
             else if (0x2934 <= hs &&
                      hs <= 0x2935)
             {
                 containsEmoji = YES;
             }
             else if (0x3297 <= hs &&
                      hs <= 0x3299)
             {
                 containsEmoji = YES;
             }
             else if (hs == 0xa9 ||
                      hs == 0xae ||
                      hs == 0x303d ||
                      hs == 0x3030 ||
                      hs == 0x2b55 ||
                      hs == 0x2b1c ||
                      hs == 0x2b1b ||
                      hs == 0x2b50)
             {
                 containsEmoji = YES;
             }
         }
     }];
    
    return containsEmoji;
}

@end
