//
//  HttpRequestHelper+version.h
//  BberryCore
//
//  Created by 卫明何 on 2017/11/9.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "HttpRequestHelper.h"
#import "VersionInfo.h"

@interface HttpRequestHelper (version)

/**
 查询当前版本号是否有在审核

 @param version 版本号
 @param success 成功
 @param failure 失败
 */
+ (void)checkLoadingWithVersion:(NSString *)version success:(void (^)(VersionInfo *info))success failure:(void(^)(NSNumber *resCode, NSString *message))failure;

/**
 兔兔是不是显示耳伴账号密码可以登录

 @param inforDic 成功
 @param failure 失败
 */
+ (void)vestBagShowErBanLoginSuccess:(void (^)(id message))success failure:(void (^)(NSNumber *, NSString *))failure;
@end
