//
//  HttpRequestHelper+File.h
//  BberryCore
//
//  Created by gzlx on 2017/7/25.
//  Copyright © 2017年 chenran. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "HttpRequestHelper.h"
#import "UserPhoto.h"
#import "UploadImage.h"

@interface HttpRequestHelper (File)

#pragma mark - QiNiu Upload
/*
 * Upload Image
 */
+ (void)uploadImage:(UIImage *)image
              named:(NSString *)imageName
              token:(NSString *)token
            success:(void (^)(NSString *key, NSDictionary *resp))success
            failure:(void (^)(NSNumber *resCode, NSString *message))failure;

+ (void)uploadFile:(NSData *)fileData
             named:(NSString *)imageName
             token:(NSString *)token
           success:(void (^)(NSString *key, NSDictionary *resp))success
           failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/*
 * Upload file
 */
+ (void)uploadSoundDataFile:(NSString *)filePath
             token:(NSString *)token
           success:(void (^)(NSString *key, NSDictionary *resp))success
           failure:(void (^)(NSNumber *resCode, NSString *message))failure;
@end
