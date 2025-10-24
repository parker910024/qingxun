//
//  HttpRequestHelper+version.m
//  BberryCore
//
//  Created by 卫明何 on 2017/11/9.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "HttpRequestHelper+version.h"
#import "VersionInfo.h"
#import "AuthCore.h"

@implementation HttpRequestHelper (version)

//查询版本状态
+ (void)checkLoadingWithVersion:(NSString *)version success:(void (^)(VersionInfo *info))success failure:(void (^)(NSNumber *, NSString *))failure {
    
    NSString *method = @"version/get";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:version forKey:@"version"];
    [params safeSetObject:GetCore(AuthCore).getUid forKey:@"uid"];

    
    [HttpRequestHelper GET:method params:params success:^(id data) {
//        VersionInfo *versionInfo = [VersionInfo yy_modelWithJSON:data];
        VersionInfo *versionInfo = [VersionInfo modelWithJSON:data];
        //        BOOL result = [(NSNumber *)data boolValue];
        //        1线上版本,2审核中版本,3强制更新版本,4建议更新版本,5已删除版本
        success(versionInfo);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

+ (void)vestBagShowErBanLoginSuccess:(void (^)(id message))success failure:(void (^)(NSNumber *, NSString *))failure{
    NSString *method = @"version/get/tips";
    [HttpRequestHelper GET:method params:nil success:^(id data) {
        if (projectType() == ProjectType_LookingLove || projectType() == ProjectType_Planet) {
            VersionInfo *model = [VersionInfo modelWithJSON:data];
            success(model);
        } else {
            NSString *dataString = data;
            success(dataString);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}



@end
