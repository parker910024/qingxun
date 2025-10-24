//
//  NSBundle+Source.m
//  XC_HaHaSourceMoudle
//
//  Created by Macx on 2018/9/7.
//  Copyright © 2018年 卫明何. All rights reserved.
//

#import "NSBundle+Source.h"

@implementation NSBundle (Source)

+ (instancetype)source_Bundle {
    static NSBundle *refreshBundle = nil;
    if (refreshBundle == nil) {
        // 这里不使用mainBundle是为了适配pod 1.x和0.x
//        refreshBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[XC_default class]] pathForResource:@"Source" ofType:@"bundle"]];
        refreshBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"Source" ofType:@"bundle"]];
    }
    return refreshBundle;
}

+ (NSString *)xc_localizedStringForKey:(NSString *)key
{
    return [self xc_localizedStringForKey:key value:nil];
}

+ (NSString *)xc_localizedStringForKey:(NSString *)key value:(NSString *)value
{
    static NSBundle *bundle = nil;
    if (bundle == nil) {
        NSString *language = [NSLocale preferredLanguages].firstObject;
        if ([language hasPrefix:@"en"]) {
            language = @"en";
        } else if ([language hasPrefix:@"zh"]) {
            if ([language rangeOfString:@"Hans"].location != NSNotFound) {
                language = @"zh-Hans"; // 简体中文
            } else {
//                language = @"zh-Hant"; // 繁體中文
                language = @"zh-Hans"; // 繁體中文
            }
        } else {
            language = @"en";
        }
        
        bundle = [NSBundle bundleWithPath:[[NSBundle source_Bundle] pathForResource:language ofType:@"lproj"]];
    }
    value = [bundle localizedStringForKey:key value:value table:nil];
    return [[NSBundle mainBundle] localizedStringForKey:key value:value table:nil];
}

@end
