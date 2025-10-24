//
//  HttpRequestHelper+Client.h
//  BberryCore
//
//  Created by 卫明何 on 2018/1/8.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "HttpRequestHelper.h"

@interface HttpRequestHelper (Client)

/**
 获取App初始化参数
 
 @param success 成功
 @param failure 失败
 */
+ (void)getTheClientInit:(void (^)(NSDictionary *initData))success failure:(void (^)(NSNumber *resCode, NSString *message))failure;
+ (void)getTheClientInitWithHostName:(NSString *)hostName success:(void (^)(NSDictionary *initData))success failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 回调结果至百度信息流api
 
 @param success 成功
 @param failure 失败
 */
+ (void)appInitObserveBaiduCallBackWithSuccess:(void (^)(NSDictionary * dic))success failure:(void (^) (NSString * message, NSNumber * code))failure;

#pragma mark -
#pragma mark GameHomeV5 上传用户地理位置信息
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
                          failure:(void (^) (NSString *message, NSNumber *code))failure;

// 请求客服配置
+ (void)requestCustomerConfig:(HttpRequestHelperCompletion)completion;

@end
