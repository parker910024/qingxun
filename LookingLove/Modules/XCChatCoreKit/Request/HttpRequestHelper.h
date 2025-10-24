//
//  HttpRequestHelper.h
//  Bberry
//
//  Created by KevinWang on 2018/6/2.
//  Copyright © 2018年 XC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XCMacros.h"
#import "UserID.h"
#import "NSMutableDictionary+Safe.h"
#import "NSArray+Safe.h"

typedef NS_ENUM(NSUInteger, HttpRequestHelperMethod) {
    HttpRequestHelperMethodPOST,
    HttpRequestHelperMethodGET,
    HttpRequestHelperMethodPUT,
    HttpRequestHelperMethodDELETE
};

typedef NS_ENUM(NSUInteger, HttpRequestHelperUploadFileType) {//上传文件类型
    HttpRequestHelperUploadFileTypePic = 1,//1-图片文件
    HttpRequestHelperUploadFileTypeVoice = 2,//2-语音文件
    HttpRequestHelperUploadFileTypeVideo = 3,//3-视频文件
};

typedef NS_ENUM(NSUInteger, HttpRequestHelperUploadBizType) {//上传业务类型
    HttpRequestHelperUploadBizTypeUserVoice = 1,//1-用户声音
    HttpRequestHelperUploadBizTypeUserAvatar = 2,//2-用户头像
    HttpRequestHelperUploadBizTypeUserAlbum = 3,//3-个人相册
    HttpRequestHelperUploadBizTypeDynamic = 4,//4-动态
    HttpRequestHelperUploadBizTypeFamily = 5,//5-家族
    HttpRequestHelperUploadBizTypeLittleWorld = 6,//6-小世界
    HttpRequestHelperUploadBizTypeHallGroup = 7,//7-厅群
    HttpRequestHelperUploadBizTypeFamilyGroup = 8,//8-家族群
    HttpRequestHelperUploadBizTypeReport = 9,//9-用户举报
    HttpRequestHelperUploadBizTypeFeedback = 10,//10-意见反馈
};

static dispatch_once_t onceToken;

typedef void(^HttpRequestHelperCompletion)(id data, NSNumber *code, NSString *msg);

@interface HttpRequestHelper : NSObject

+ (void)resetClient;

//async
+ (void)GET:(NSString *)method
     params:(NSDictionary *)params
    success:(void (^)(id data))success
    failure:(void (^)(NSNumber *resCode, NSString *message))failure;

+ (void)GET:(NSString *)interfaceUrl
     method:(NSString *)method
     params:(NSDictionary *)params
    success:(void (^)(id data))success
    failure:(void (^)(NSNumber *resCode, NSString *message))failure;


+ (void)POST:(NSString *)method
     params:(NSDictionary *)params
    success:(void (^)(id data))success
    failure:(void (^)(NSNumber *resCode, NSString *message))failure;

+ (void)POST:(NSString *)interfaceUrl
      method:(NSString *)method
      params:(NSDictionary *)params
     success:(void (^)(id data))success
     failure:(void (^)(NSNumber *resCode, NSString *message))failure;

+ (void)DELETE:(NSString *)method
      params:(NSDictionary *)params
     success:(void (^)(id data))success
     failure:(void (^)(NSNumber *resCode, NSString *message))failure;

+ (void)PUT:(NSString *)method
     params:(NSDictionary *)params
    success:(void (^)(id data))success
    failure:(void (^)(NSNumber *resCode, NSString *message))failure;

+ (void)POSTImage:(NSString *)method
           params:(NSDictionary *)params
          success:(void (^)(id data))success
          failure:(void (^)(NSNumber *resCode, NSString *message))failure;


+ (void)request:(NSString *)url
         method:(HttpRequestHelperMethod)method
         params:(NSDictionary *)params
        success:(void (^)(id data))success
        failure:(void (^)(NSNumber *resCode, NSString *message))failure;

//request:method:params:success:failure: 的另一种调用形式，内部调用了该方法
+ (void)request:(NSString *)path
         method:(HttpRequestHelperMethod)method
         params:(NSDictionary *)params
     completion:(HttpRequestHelperCompletion)completion;

+ (NSString *)InterfaceUrl:(NSString *)url;

/// 发布小世界动态专用接口 Post 请求参数放入到 body 里 使用 application/json 类型传递
/// @param path 请求地址
/// @param params 参数
/// @param success 成功回调
/// @param failure 失败回调
+ (void)postDynamic:(NSString *)path
             params:(NSDictionary *)params
            success:(void (^)(id data))success
            failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/// 文件上传，注意目前只处理了图片上传
/// @param file 文件源，图片类型传数组【NSArray<UIImage *> *】
/// @param fileType 文件类型
/// @param bizType 业务类型
+ (void)uploadFile:(id)file
          fileType:(HttpRequestHelperUploadFileType)fileType
           bizType:(HttpRequestHelperUploadBizType)bizType
           success:(void (^)(id data))success
           failure:(void (^)(NSNumber *resCode, NSString *message))failure;

///文件下载
///@param urlPath 下载路径
///@param filePath  保存路径
+ (void)handelDownloadWithFileUrlPath:(NSString *)urlPath
                         saveFilePath:(NSString *)filePath
                              success:(void (^)(NSURLResponse *response, NSURL *filePath))success
                                 fail:(void (^)(NSInteger *resCode, NSString *message))failure;

@end
