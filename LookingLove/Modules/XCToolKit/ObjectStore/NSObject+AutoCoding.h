//
//  NSObject+AutoCoding.h
//  YYMobileFramework
//
//  Created by wuwei on 14/6/13.
//  Copyright (c) 2014年 YY Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (AutoCoding) <NSSecureCoding>

// Coding
+ (NSDictionary *)codableProperties;
- (void)setWithCoder:(NSCoder *)aDecoder;

// Properties access
- (NSDictionary *)codableProperties;
- (NSDictionary *)dictionaryRepresentation;

// Loading / Saving
+ (instancetype)objectWithContentsOfFile:(NSString *)path;
- (BOOL)writeToFile:(NSString *)filePath atomically:(BOOL)useAuxiliaryFile;

@end