//
//  HttpRequestHelper+Face.h
//  BberryCore
//
//  Created by 卫明何 on 2017/9/29.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "HttpRequestHelper.h"

@interface HttpRequestHelper (Face)



/**
 获取表情

 @param success 成功
 @param failure 失败
 */
+ (void)getTheFaceListsuccess:(void (^)(NSArray *faceList))success
                      failure:(void (^)(NSNumber *resCode, NSString *message))failure;



/**
 获取表情Json

 @param success 成功
 @param failure 失败
 */
+ (void)getTheFaceJson:(void (^)(NSArray *))success failure:(void (^)(NSNumber *, NSString *))failure;


@end
