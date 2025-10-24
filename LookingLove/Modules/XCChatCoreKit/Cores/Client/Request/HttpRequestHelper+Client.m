//
//  HttpRequestHelper+Client.m
//  BberryCore
//
//  Created by 卫明何 on 2018/1/8.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "HttpRequestHelper+Client.h"
#import "YYUtility.h"
#import "AuthCore.h"
#import "HostUrlManager.h"

@implementation HttpRequestHelper (Client)

+ (void)getTheClientInit:(void (^)(NSDictionary *))success failure:(void (^)(NSNumber *, NSString *))failure {
    
    [self getTheClientInitWithHostName:[HostUrlManager shareInstance].hostUrl success:success failure:failure];
}

+ (void)getTheClientInitWithHostName:(NSString *)hostName success:(void (^)(NSDictionary *))success failure:(void (^)(NSNumber *, NSString *))failure {
    
    NSString *method = @"client/init";
    
    [HttpRequestHelper GET:hostName method:method params:nil success:^(id data) {
        success(data);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

/**
回调结果至百度信息流api

 @param success 成功
 @param failure 失败
 */
+ (void)appInitObserveBaiduCallBackWithSuccess:(void (^)(NSDictionary * dic))success failure:(void (^) (NSString * message, NSNumber * code))failure{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    NSString * idfa = [YYUtility idfa];
    NSString * method = @"observe/baidu/callback";
    [params safeSetObject:idfa forKey:@"id"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success(data);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(message, resCode);
    }];
}

/**
 上传用户地理位置接口

 @param address 地址信息
 @param adcode 城市编码
 @param longitude 经度
 @param latitude 纬度
 */
+ (void)uploadUserLocationAddress:(NSString *)address
                           adcode:(NSString *)adcode
                        longitude:(double)longitude
                         latitude:(double)latitude
                          success:(void (^)(BOOL success))success
                          failure:(void (^) (NSString *message, NSNumber *code))failure {
    
    NSString * method = @"user/address/save";

    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params safeSetObject:GetCore(AuthCore).getUid forKey:@"uid"];
    [params safeSetObject:address forKey:@"address"];
    [params safeSetObject:adcode forKey:@"adcode"];
    [params safeSetObject:@(longitude) forKey:@"longitude"];
    [params safeSetObject:@(latitude) forKey:@"latitude"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        !success ?: success(YES);
    } failure:^(NSNumber *resCode, NSString *message) {
        !failure ?: failure(message, resCode);
    }];
}

// 请求客服配置
+ (void)requestCustomerConfig:(HttpRequestHelperCompletion)completion {
    [HttpRequestHelper request:@"customer/getInfo" method:HttpRequestHelperMethodGET params:nil completion:completion];
}
@end
