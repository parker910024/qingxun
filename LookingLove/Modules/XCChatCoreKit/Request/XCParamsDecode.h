//
//  XCParamsDecode.h
//  BberryCore
//
//  Created by 卫明何 on 2018/5/4.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFHTTPSessionManager.h>
#import "BaseObject.h"

@interface XCParamsDecode : BaseObject

/**
 加密方法

 @param method method
 @param params 参数
 */
+ (NSMutableDictionary *)decodeParams:(NSString *)method params:(NSMutableDictionary *)params client:(AFHTTPSessionManager *)client formatter:(NSDateFormatter *)formatter;

+ (NSString *)xcSign:(NSMutableDictionary *)dic method:(NSString *)method;
@end
