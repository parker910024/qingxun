//
//  NSData+HexToken.m
//  YYFaceFramework
//
//  Created by zhangji on 9/19/16.
//  Copyright © 2016 com.yy.face. All rights reserved.
//

#import "NSData+HexToken.h"

@implementation NSData (HexToken)

- (NSString *)toHexToken
{
    NSInteger len = [self length];
    Byte* bytes = (Byte* )[self bytes];
    NSString *hexToken = @"";
    for(NSInteger i = 0; i < len; ++i)
    {
        hexToken = [NSString stringWithFormat:@"%@%02x ",hexToken, bytes[i]];
    }
    return hexToken;
}

@end
