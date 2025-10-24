//
//  TEACrypto.h
//  Commons
//
//  Created by wuwei on 14/6/10.
//  Copyright (c) 2014年 YY Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TEACrypto : NSObject

+ (NSData *)encryptData:(NSData *)data usingKey:(NSData *)key;
+ (NSData *)decryptData:(NSData *)data usingKey:(NSData *)key;

+ (NSData *)encryptFileAtPath:(NSString *)filePath usingKey:(NSData *)key;
+ (NSData *)decryptFileAtPath:(NSString *)filePath usingKey:(NSData *)key;

@end
