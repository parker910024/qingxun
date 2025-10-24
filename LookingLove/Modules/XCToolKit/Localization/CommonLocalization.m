//
//  CommonLocalization.m
//  Commons
//
//  Created by daixiang on 13-10-9.
//  Copyright (c) 2013年 YY Inc. All rights reserved.
//

#import "CommonLocalization.h"

#define NOT_FOUND @"!@#$NoTFouNd%^&*"

NSString *getLocalizedString(NSString *key)
{
    return getLocalizedStringFromTable(key, nil, @"");
}

NSString *getLocalizedStringFromTable(NSString *key, NSString *table, __unused NSString *comment)
{
    return getLocalizedStringFromTableWithFallback(key, table, @"", comment);
}

NSString *getLocalizedStringFromTableWithFallback(NSString *key, NSString *table, NSString *fallback, __unused NSString *comment)
{
    if (!key)
        return @"";
    
    static NSBundle *fallBackBundle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"zh-Hans" ofType:@"lproj"];
        fallBackBundle = [NSBundle bundleWithPath:path];
    });
    
    NSString *value = [[NSBundle mainBundle] localizedStringForKey:key value:NOT_FOUND table:table];
    
    if (!value || [value isEqualToString:NOT_FOUND])
        value = [fallBackBundle localizedStringForKey:key value:fallback table:table];
    
    return value;
}
