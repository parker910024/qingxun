//
//  HttpHeaderUtility.h
//  YYMobileFramework
//
//  Created by zhangji on 6/29/15.
//  Copyright (c) 2015 YY Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpHeaderUtility : NSObject

+ (NSString *)getContentType:(NSString *)fileType;

@end
