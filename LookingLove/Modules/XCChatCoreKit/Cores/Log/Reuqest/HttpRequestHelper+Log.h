//
//  HttpRequestHelper+Log.h
//  BberryCore
//
//  Created by 卫明何 on 2018/3/13.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "HttpRequestHelper.h"
#import "LogSK.h"

@interface HttpRequestHelper (Log)

+ (void)requestLogSKSuccess:(void (^)(LogSK *sk))success failure:(void (^)(NSNumber *resCode, NSString *message))failure;

@end
