//
//  HttpRequestHelper+Face.m
//  BberryCore
//
//  Created by 卫明何 on 2017/9/29.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "HttpRequestHelper+Face.h"
#import "NSObject+YYModel.h"
#import "FaceInfo.h"
#import "FaceConfigInfo.h"
#import "YYWebResourceDownloader.h"
#import "FaceCore.h"
#import "NSString+JsonToDic.h"
#import "DESEncrypt.h"
#import "AdCore.h"

#define DESSalt @"pk4wwipi3ygeg4jmfwd4xaau6li878zg"

@implementation HttpRequestHelper (Face)

+ (void)getTheFaceListsuccess:(void (^)(NSArray *))success failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"face/list";
    [HttpRequestHelper GET:method params:nil success:^(id data) {
        NSArray *listData = data[@"faces"];
        NSArray *faces = [NSArray yy_modelArrayWithClass:[FaceInfo class] json:listData];
        success(faces);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

+ (void)getTheFaceJson:(void (^)(NSArray *))success failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"client/init";
    [HttpRequestHelper GET:method params:nil success:^(id data) {
        NSString *json = data[@"faceJson"][@"json"];
        GetCore(AdCore).splash = [AdInfo yy_modelWithJSON:data[@"splashVo"]];
        NSString *deJson = [DESEncrypt decryptUseDES:json key:@"pk4wwipi3ygeg4jmfwd4xaau6li878zg"];
        data = [NSString dictionaryWithJsonString:deJson];
        
        if (data) {
            NSArray *arr = [NSArray yy_modelArrayWithClass:[FaceConfigInfo class] json:data[@"faces"]];
            GetCore(FaceCore).version = [NSString stringWithFormat:@"%@",data[@"version"]];
            GetCore(FaceCore).zipMd5 = [[NSString stringWithFormat:@"%@",data[@"zipMd5"]] uppercaseString];
            GetCore(FaceCore).zipUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",data[@"zipUrl"]]];
            
            success(arr);
            
        }else {
            failure(@(999999),@"数据解析失败");
        }
        
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}



@end
