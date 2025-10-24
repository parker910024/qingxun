//
//  HttpRequestHelper+File.m
//  BberryCore
//
//  Created by gzlx on 2017/7/25.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "HttpRequestHelper+File.h"

#import "AuthCore.h"
#import "UserCore.h"
#import "UserPhoto.h"
#import <QiniuSDK.h>

@implementation HttpRequestHelper (File)

#pragma mark - QiNiu Upload
+ (void)uploadImage:(UIImage *)image
              named:(NSString *)imageName
              token:(NSString *)token
            success:(void (^)(NSString *key, NSDictionary *resp))success
            failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
        builder.zone = [QNFixedZone zone1];
        if (projectType() == ProjectType_VKiss){//华南 zone2
            builder.zone = [QNFixedZone zone2];
        }
    }];
    QNUploadManager *upManager = [[QNUploadManager alloc] initWithConfiguration:config];
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    [upManager putData:data key:imageName token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        
        if (resp) {
            success(key,resp);
        }else{
            failure(@(info.statusCode),info.error.localizedDescription);
        }
    } option:nil];
}

+ (void)uploadFile:(NSData *)fileData
              named:(NSString *)imageName
              token:(NSString *)token
            success:(void (^)(NSString *key, NSDictionary *resp))success
            failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
        builder.zone = [QNFixedZone zone1];
    }];
    QNUploadManager *upManager = [[QNUploadManager alloc] initWithConfiguration:config];
    [upManager putData:fileData key:imageName token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        NSLog(@"info %@",info);
        NSLog(@"resp %@",resp);
        NSLog(@"key %@",key);
        
        if (resp) {
            success(key,resp);
        }else{
            failure(@(info.statusCode),info.error.localizedDescription);
        }
    } option:nil];
}

+ (void)uploadSoundDataFile:(NSString *)filePath
                      token:(NSString *)token
                    success:(void (^)(NSString *key, NSDictionary *resp))success
                    failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
        builder.zone = [QNFixedZone zone2];
    }];
    QNUploadManager *upManager = [[QNUploadManager alloc] initWithConfiguration:config];
    [upManager putFile:filePath key:nil token:token  complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        NSLog(@"info %@",info);
        NSLog(@"resp %@",resp);
        NSLog(@"key %@",key);
        
        if (resp) {
            success(key,resp);
        }else{
            failure(@(info.statusCode),info.error.localizedDescription);
        }
    } option:nil];

}

@end
