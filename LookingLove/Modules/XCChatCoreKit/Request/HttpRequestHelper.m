//
//  HttpRequestHelper.m
//  Bberry
//
//  Created by KevinWang on 2018/6/2.
//  Copyright © 2018年 XC. All rights reserved.
//


#import "HttpRequestHelper.h"
#import <AFNetworking.h>
#import <AFNetworkReachabilityManager.h>

#import "HttpErrorClient.h"
#import "PurseCore.h"
#import "AuthCore.h"
#import "BalanceErrorClient.h"
#import "AlertCoreClient.h"
#import "AuthCoreClient.h"
#import "XCHtmlUrl.h"

#import "ErrorInfo.h"
#import "HostUrlManager.h"
#import "XCParamsDecode.h"
#import "XCHTTPErrorCodeMessage.h"
#import "AFHTTPSessionManager+Config.h"
#import "LocalTimeAdjustManager.h"
#import "HttpRequestDataHandle.h"
#import "NSString+JsonToDic.h"


static NSString * const kResponseResultKey = @"code";
static NSString * const kResponseDataKey = @"data";
static NSString * const kResponseDateKey = @"date";
static NSString * const kResponseReasonKey = @"reason";
static NSString * const kResponseMessageKey = @"message";
static NSString * const kResponseTimesTampKey = @"timestamp";

static NSDateFormatter *dateFormatter() {
    static NSDateFormatter *formatter = nil;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init] ;
        
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
        //设置时区,这个对于时间的处理有时很重要
        
        NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
        
        [formatter setTimeZone:timeZone];
        
    });
    return formatter;
}

typedef NS_ENUM(NSInteger, HttpResponseResult) {
    HttpResponseSuccess = 200,
    //TODO
};

@implementation HttpRequestHelper

+(AFHTTPSessionManager *)requestManager{
    
    static AFHTTPSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
#ifdef DEBUG

#else
        config.connectionProxyDictionary = @{};
#endif
        manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:config];
        manager.requestSerializer.timeoutInterval = 15;
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer.HTTPShouldHandleCookies = YES;
        // 客户端是否信任非法证书
        manager.securityPolicy.allowInvalidCertificates = YES;
        AFSecurityPolicy *securityPolicy= [AFSecurityPolicy defaultPolicy];
        manager.securityPolicy = securityPolicy;
        // 是否在证书域字段中验证域名
        [manager.securityPolicy setValidatesDomainName:NO];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain",@"image/jpeg",@"image/png", nil];        
    });
    
    return manager;
    
}

+(AFHTTPSessionManager *)requestMessageCollectionManager{
    
    static AFHTTPSessionManager *messageCollectionManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
#ifdef DEBUG
        
#else
        config.connectionProxyDictionary = @{};
#endif
        messageCollectionManager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:config];
        messageCollectionManager.requestSerializer.timeoutInterval = 15;
        messageCollectionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        messageCollectionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        messageCollectionManager.requestSerializer.HTTPShouldHandleCookies = YES;
        // 客户端是否信任非法证书
        messageCollectionManager.securityPolicy.allowInvalidCertificates = YES;
        AFSecurityPolicy *securityPolicy= [AFSecurityPolicy defaultPolicy];
        messageCollectionManager.securityPolicy = securityPolicy;
        // 是否在证书域字段中验证域名
        [messageCollectionManager.securityPolicy setValidatesDomainName:NO];
        messageCollectionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain",@"image/jpeg",@"image/png", nil];
    });
    
    return messageCollectionManager;
    
}

#pragma mark - public

+ (void)request:(NSString *)url
         method:(HttpRequestHelperMethod)method
         params:(NSDictionary *)params
        success:(void (^)(id data))success
        failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    
    switch (method) {
            case HttpRequestHelperMethodGET:
        {
            [self GET:url params:params success:success failure:failure];
        }
            break;
            case HttpRequestHelperMethodPOST:
        {
            [self POST:url params:params success:success failure:failure];
        }
            break;
            case HttpRequestHelperMethodDELETE:
        {
            [self DELETE:url params:params success:success failure:failure];
        }
            break;
            case HttpRequestHelperMethodPUT:
        {
            [self PUT:url params:params success:success failure:failure];
        }
            break;
    }
}


+ (void)GET:(NSString *)method
     params:(NSDictionary *)params
    success:(void (^)(id data))success
    failure:(void (^)(NSNumber *resCode, NSString *message))failure{
  
    NSString *url = [HostUrlManager shareInstance].hostUrl;
    [self GET:url method:method params:params success:success failure:failure];
    
}

+ (void)GET:(NSString *)interfaceUrl method:(NSString *)method params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSNumber *, NSString *))failure {
    
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == 0) {
        //延时解决抛出异常“recusively call the same service clients.”
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NotifyCoreClient(HttpErrorClient, @selector(networkDisconnect), networkDisconnect);
        });
    }
    
    AFHTTPSessionManager *manager = [HttpRequestHelper requestManager];
    [HttpRequestHelper setCookie];
    [HttpRequestHelper showActive];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@",interfaceUrl,method];
    //参数加密
    params = [XCParamsDecode decodeParams:method params:[params mutableCopy] client:manager formatter:dateFormatter()];
    //配置公共参数
    params = [AFHTTPSessionManager configBaseParmars:params];
    
    
#ifdef DEBUG
    NSLog(@"url:%@,parameter:%@",url,params);
#endif
    
    [manager GET:url parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [HttpRequestHelper handelSuccessRequest:method sessionDataTask:task responseObject:responseObject success:success fail:failure];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [HttpRequestHelper handelFailRequest:method sessionDataTask:task err:error fail:failure];
    }];
}

+ (void)POST:(NSString *)method
      params:(NSDictionary *)params
     success:(void (^)(id data))success
     failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    
    NSString *url = [HostUrlManager shareInstance].hostUrl;
    
    [self POST:url method:method params:params success:success failure:failure];
}

+ (void)POST:(NSString *)interfaceUrl
      method:(NSString *)method
      params:(NSDictionary *)params
     success:(void (^)(id data))success
     failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == 0) {
        //延时解决抛出异常“recusively call the same service clients.”
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NotifyCoreClient(HttpErrorClient, @selector(networkDisconnect), networkDisconnect);
        });
    }
    
    AFHTTPSessionManager *manager;
    if (![interfaceUrl containsString:[HostUrlManager shareInstance].hostUrl]) {
        
        manager = [HttpRequestHelper requestMessageCollectionManager];
        
    }else {
        
        manager = [HttpRequestHelper requestManager];
    }
    [HttpRequestHelper removeCookie];
    [HttpRequestHelper setCookie];
    [HttpRequestHelper showActive];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@",interfaceUrl,method];
    //参数加密
    params = [XCParamsDecode decodeParams:method params:[params mutableCopy] client:manager formatter:dateFormatter()];
    //配置公共参数
    params = [AFHTTPSessionManager configBaseParmars:params];
    
#ifdef DEBUG
    NSLog(@"url:%@,parameter:%@",url,params);
#endif
    [manager POST:url parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [HttpRequestHelper handelSuccessRequest:method sessionDataTask:task responseObject:responseObject success:success fail:failure];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [HttpRequestHelper handelFailRequest:method sessionDataTask:task err:error fail:failure];

    }];
}


+ (void)request:(NSString *)path
         method:(HttpRequestHelperMethod)method
         params:(NSDictionary *)params
     completion:(HttpRequestHelperCompletion)completion {
    
    //filter path first '/' character
    if ([path hasPrefix:@"/"]) {
        path = [path substringFromIndex:1];
    }
    
    [self request:path method:method params:params success:^(id data) {
        if (completion) {
            completion(data, nil, nil);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (completion) {
            completion(nil, resCode, message);
        }
    }];
}

/// 发布小世界动态专用接口 Post 请求参数放入到 body 里 使用 application/json 类型传递
/// @param path 请求地址
/// @param params 参数
/// @param success 成功回调
/// @param failure 失败回调
+ (void)postDynamic:(NSString *)path
             params:(NSDictionary *)params
            success:(void (^)(id data))success
            failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    
     if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == 0) {
            NotifyCoreClient(HttpErrorClient, @selector(networkDisconnect), networkDisconnect);
        }
    
        NSString *url = [HostUrlManager shareInstance].hostUrl;
    
        AFHTTPSessionManager *manager;
        if (![path containsString:[HostUrlManager shareInstance].hostUrl]) {
            
            manager = [HttpRequestHelper requestMessageCollectionManager];
            
        }else {
            
            manager = [HttpRequestHelper requestManager];
        }
        [HttpRequestHelper removeCookie];
        [HttpRequestHelper setCookie];
        [HttpRequestHelper showActive];
        
        NSString *urlPath = [NSString stringWithFormat:@"%@/%@",url,path];
        //参数加密
        NSDictionary *baseParams = [XCParamsDecode decodeParams:path params:nil client:manager formatter:dateFormatter()];
        //配置公共参数
        baseParams = [AFHTTPSessionManager configBaseParmars:baseParams];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
    
    #ifdef DEBUG
        NSLog(@"url:%@,parameter:%@",urlPath, params);
    #endif
    
    __block NSString *requestUrl = @"";
    [baseParams.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *value = baseParams[obj];
        requestUrl = [requestUrl stringByAppendingString:[NSString stringWithFormat:@"%@=%@&", obj, value]];
    }];
    
    urlPath = [NSString stringWithFormat:@"%@?%@", urlPath, requestUrl];
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlPath parameters:baseParams error:nil];
    request.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];

    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [request setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];

    [[manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (responseObject) {
            [HttpRequestHelper handelSuccessRequest:urlPath sessionDataTask:nil responseObject:responseObject success:success fail:failure];
        }
        if (error) {
            [HttpRequestHelper handelFailRequest:urlPath sessionDataTask:nil err:error fail:failure];
        }
    }] resume];
}

+ (void)DELETE:(NSString *)method
        params:(NSDictionary *)params
       success:(void (^)(id data))success
       failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == 0) {
        NotifyCoreClient(HttpErrorClient, @selector(networkDisconnect), networkDisconnect);
    }
    
    AFHTTPSessionManager *manager = [HttpRequestHelper requestManager];
    [HttpRequestHelper setCookie];
    [HttpRequestHelper showActive];
    NSString *url = [HttpRequestHelper InterfaceUrl:method];
    //参数加密
    params = [XCParamsDecode decodeParams:method params:[params mutableCopy] client:manager formatter:dateFormatter()];
    //配置公共参数
    params = [AFHTTPSessionManager configBaseParmars:params];
    
    [manager DELETE:url parameters:params headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [HttpRequestHelper handelSuccessRequest:method sessionDataTask:task responseObject:responseObject success:success fail:failure];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [HttpRequestHelper handelFailRequest:method sessionDataTask:task err:error fail:failure];
    }];

}

+ (void)PUT:(NSString *)method
        params:(NSDictionary *)params
       success:(void (^)(id data))success
       failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == 0) {
        NotifyCoreClient(HttpErrorClient, @selector(networkDisconnect), networkDisconnect);
    }
    
    AFHTTPSessionManager *manager = [HttpRequestHelper requestManager];
    [HttpRequestHelper setCookie];
    [HttpRequestHelper showActive];
    NSString *url = [HttpRequestHelper InterfaceUrl:method];
    //参数加密
    params = [XCParamsDecode decodeParams:method params:[params mutableCopy] client:manager formatter:dateFormatter()];
    //配置公共参数
    params = [AFHTTPSessionManager configBaseParmars:params];
    
    [manager PUT:url parameters:params headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [HttpRequestHelper handelSuccessRequest:method sessionDataTask:task responseObject:responseObject success:success fail:failure];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [HttpRequestHelper handelFailRequest:method sessionDataTask:task err:error fail:failure];
    }];
    
}

+ (void)POSTImage:(NSString *)method
           params:(NSDictionary *)params
          success:(void (^)(id data))success
          failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == 0) {
        NotifyCoreClient(HttpErrorClient, @selector(networkDisconnect), networkDisconnect);
    }
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
#ifdef DEBUG
    
#else
    config.connectionProxyDictionary = @{};
#endif
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config];
    manager.requestSerializer.timeoutInterval = 15;
    manager.responseSerializer = [AFImageResponseSerializer serializer];
    manager.requestSerializer.HTTPShouldHandleCookies = YES;
    // 客户端是否信任非法证书
    manager.securityPolicy.allowInvalidCertificates = YES;
    AFSecurityPolicy *securityPolicy= [AFSecurityPolicy defaultPolicy];
    manager.securityPolicy = securityPolicy;
    // 是否在证书域字段中验证域名
    [manager.securityPolicy setValidatesDomainName:NO];
    
    [HttpRequestHelper removeCookie];
    [HttpRequestHelper setCookie];
    [HttpRequestHelper showActive];
    
    NSString *url = [HttpRequestHelper InterfaceUrl:method];
    //参数加密
    params = [XCParamsDecode decodeParams:method params:[params mutableCopy] client:manager formatter:dateFormatter()];
    //配置公共参数
    params = [AFHTTPSessionManager configBaseParmars:params];
    
    [manager POST:url  parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [HttpRequestHelper saveCookie];
        [HttpRequestHelper setCookie];
        [HttpRequestHelper hideActive];
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [HttpRequestHelper handelFailRequest:method sessionDataTask:task err:error fail:failure];
    }];
}

/// 文件上传，注意目前只处理了图片上传
/// @param file 文件源，图片类型传数组【NSArray<UIImage *> *】
/// @param fileType 文件类型
/// @param bizType 业务类型
+ (void)uploadFile:(id)file
          fileType:(HttpRequestHelperUploadFileType)fileType
           bizType:(HttpRequestHelperUploadBizType)bizType
           success:(void (^)(id data))success
           failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == 0) {
        //延时解决抛出异常“recusively call the same service clients.”
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NotifyCoreClient(HttpErrorClient, @selector(networkDisconnect), networkDisconnect);
        });
    }
    
    NSString *method = @"file/upload";
    NSString *url = [NSString stringWithFormat:@"%@/%@", [HostUrlManager shareInstance].hostUrl, method];
    NSDictionary *params = @{@"fileType": @(fileType),
                             @"busType": @(bizType),
    };

    AFHTTPSessionManager *manager = [HttpRequestHelper requestManager];

    [HttpRequestHelper removeCookie];
    [HttpRequestHelper setCookie];
    [HttpRequestHelper showActive];

    //参数加密
    params = [XCParamsDecode decodeParams:method params:[params mutableCopy] client:manager formatter:dateFormatter()];
    //配置公共参数
    params = [AFHTTPSessionManager configBaseParmars:params];
    
    [manager POST:url parameters:params headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (fileType == HttpRequestHelperUploadFileTypePic) {
            NSArray *images = (NSArray<UIImage *> *)file;
            for (UIImage *image in images) {
                NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
                [formData appendPartWithFileData:imageData
                                            name:@"files"
                                        fileName:@"iOSImageUpload"
                                        mimeType:@"image/jpeg"];
            }
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [HttpRequestHelper handelSuccessRequest:method sessionDataTask:task responseObject:responseObject success:success fail:failure];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [HttpRequestHelper handelFailRequest:method sessionDataTask:task err:error fail:failure];
    }];
}

+ (void)handelDownloadWithFileUrlPath:(NSString *)urlPath
                         saveFilePath:(NSString *)filePath
                              success:(void (^)(NSURLResponse *response, NSURL *filePath))success
                                 fail:(void (^)(NSInteger *resCode, NSString *message))failure{
    NSURL *fullPath = [NSURL fileURLWithPath:filePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlPath]];
    AFHTTPSessionManager *manager = [HttpRequestHelper requestManager];

    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request
                            progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                                return fullPath;
                            }
                   completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (error) {
            if (failure) {
                failure(error.code ,error.domain);
            }
        } else {
            if (success) {
                success(response,filePath);
            }
        }
    }];
    [task resume];

}


+ (void)resetClient {
    onceToken = 0;
    [GetCore(AuthCore) logout];
}

#pragma mark - private
#pragma mark - handleData
+ (void)handelSuccessRequest:(NSString *)method sessionDataTask:(NSURLSessionDataTask * _Nonnull)task responseObject:(id _Nullable)responseObject success:(void (^)(id data))success fail:(void (^)(NSNumber *resCode, NSString *message))failure{
    [HttpRequestHelper saveCookie];
    [HttpRequestHelper setCookie];
    [HttpRequestHelper hideActive];
    

    NSNumber *resCode = [responseObject valueForKey:kResponseResultKey];
    
    if ([[responseObject allKeys] containsObject:kResponseTimesTampKey]) {
        long timeTamp = [[responseObject valueForKey:kResponseTimesTampKey] longValue];
        [LocalTimeAdjustManager shareManager].offset = timeTamp - [self getlocalNowTimeTimestamp];
    }
    
    if ([resCode integerValue] == HttpResponseSuccess) {
        id data = [responseObject valueForKey:kResponseDataKey];
        if (success) {
            success(data);
        }
    }else{
        
        NSString *message = [responseObject valueForKey:kResponseMessageKey];
        
        [[HttpRequestDataHandle defaultHandle] handleRequestSuccessData:method response:responseObject];
        
        if (failure) {
            failure(resCode, message);
        }
    }
}

+ (void)handelFailRequest:(NSString *)method sessionDataTask:(NSURLSessionDataTask * _Nonnull)task err:(NSError * _Nullable)error fail:(void (^)(NSNumber *resCode, NSString *message))failure{
    [HttpRequestHelper hideActive];
    
    NSData *errorData = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
    NSString *info = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
    ErrorInfo *errorInfo = [ErrorInfo modelWithJSON:info];
    
    if (errorInfo != nil) {
        NSInteger code = errorInfo.code.integerValue;

        if (code == 401) {
            NotifyCoreClient(HttpErrorClient, @selector(onTicketInvalid), onTicketInvalid);
            if (failure) {
                failure(errorInfo.code, errorInfo.message);
            }
            return;
        }
        
        //登录的时候 三次输错需要验证码  @fengshuo
        if ((projectType() == ProjectType_TuTu ||
             projectType() == ProjectType_Pudding ||
             projectType() == ProjectType_LookingLove ||
             projectType() == ProjectType_Planet)
            && [method isEqualToString:@"oauth/token"]
            && errorInfo.codeVerify == 1) {
            
            NotifyCoreClient(AuthCoreClient, @selector(onloginImputFailNeedVerifcial), onloginImputFailNeedVerifcial);
        }
        
        [[HttpRequestDataHandle defaultHandle] handleRequestFailData:method errorInfo:errorInfo];
        if (failure) {
            failure(errorInfo.code, errorInfo.message);
        }
    } else {
        if (error.code == -1009) {
            if (failure) {
                failure(nil, @"网络异常，请检查网络后重试");
            }
        } else {
            if (failure) {
                failure(nil, [NSString stringWithFormat:@"服务器异常%@", error.localizedDescription]);
            }
        }
    }
 
}

+(long)getlocalNowTimeTimestamp{
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormatter() setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];
    
    return (long)[datenow timeIntervalSince1970]*1000;
    
}

#pragma mark - host
+(NSString *)InterfaceUrl:(NSString *)url{
    
    NSString *urlstring = [NSString stringWithFormat:@"%@/%@",[HostUrlManager shareInstance].hostUrl,url];
    return urlstring;
}


#pragma mark - Cookie
+ (void)saveCookie{
    NSURL *mainURL = [NSURL URLWithString:[HostUrlManager shareInstance].hostUrl];
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:mainURL];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
    [HttpRequestHelper setCookie:data];
}

+ (void)setCookie{
    NSData *cookiesdata = [HttpRequestHelper getCookie];
    
    if([cookiesdata length]) {
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
        NSHTTPCookie *cookie;
        for (cookie in cookies) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        }
    }
    
}

+ (void)removeCookie{
    NSData *cookiesdata = [HttpRequestHelper getCookie];
    if([cookiesdata length]) {
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
        NSHTTPCookie *cookie;
        for (cookie in cookies) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kCookie];
    }
}

static NSString *kCookie = @"APPCookie";
+ (void )setCookie:(NSData *)cookie{
    if(cookie == nil){
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kCookie];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:cookie forKey:kCookie];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSData *)getCookie{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kCookie];
}


#pragma mark - network state
+ (void)showActive {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    });
}

+ (void)hideActive {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    });
}

@end

