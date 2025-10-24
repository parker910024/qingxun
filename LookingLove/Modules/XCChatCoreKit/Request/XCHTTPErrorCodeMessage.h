//
//  MTErrorCodeMessage.h
//  Bberry
//
//  Created by KevinWang on 2018/6/2.
//  Copyright © 2018年 XC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XCHTTPErrorCodeMessage : NSObject

/*
 * 根据错误码匹配错误信息
 */
+ (NSString *)errorMessage:(int)resCode;

@end
