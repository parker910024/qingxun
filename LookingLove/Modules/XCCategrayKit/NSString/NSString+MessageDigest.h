//
//  NSString+MessageDigest.h
//  Commons
//
//  Created by wuwei on 14/6/10.
//  Copyright (c) 2014年 YY Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MessageDigest)

- (NSString *)MD2;
- (NSString *)MD4;
- (NSString *)MD5;

- (NSString *)SHA1;
- (NSString *)SHA224;
- (NSString *)SHA256;
- (NSString *)SHA384;
- (NSString *)SHA512;

@end
