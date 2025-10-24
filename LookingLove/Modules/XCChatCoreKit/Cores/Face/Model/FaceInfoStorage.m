//
//  FaceInfoStorage.m
//  BberryCore
//
//  Created by 卫明何 on 2017/9/29.
//  Copyright © 2017年 chenran. All rights reserved.
//

#define kFileName @"FaceInfoList.data"
#define kDataKey @"faceInfos"
#define EncodeKey @"pk4wwipi3ygeg4jmfwd4xaau6li878zg"


#import "FaceInfoStorage.h"
#import "FaceInfo.h"
#import "NSObject+YYModel.h"
#import "DESEncrypt.h"
#import "SSCustomKeychain.h"
#import "FaceConfigInfo.h"

@implementation FaceInfoStorage

+ (NSString *)getFilePath {
    NSArray *array =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[array objectAtIndex:0] stringByAppendingPathComponent:kFileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
    }
    return path;
}

+ (NSMutableArray *)getFaceInfos{
    
    NSMutableArray *faceInfos = [NSMutableArray array];
    NSString *encodeJson = [SSCustomKeychain passwordForService:@"json" account:@"face"];
    NSString *decodeJson = [DESEncrypt decryptUseDES:encodeJson key:EncodeKey];
    if (decodeJson.length > 0) {
        faceInfos = [[NSArray yy_modelArrayWithClass:[FaceConfigInfo class] json:decodeJson] mutableCopy];
    }
    return faceInfos;
}

+ (void)saveFaceInfos:(NSString *)json {
    NSString *encodeJson = [DESEncrypt encryptUseDES:json key:EncodeKey];
    [SSCustomKeychain setPassword:encodeJson forService:@"json" account:@"face"];
}

@end
