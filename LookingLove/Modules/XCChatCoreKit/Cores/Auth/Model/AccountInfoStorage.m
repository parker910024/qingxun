//
//  DataUtils.m
//  YYFaceAuth
//
//  Created by chenran on 16/10/18.
//  Copyright © 2016年 zhangji. All rights reserved.
//
#define kFileName @"AccountInfo.data"
#define kFileName1 @"AccountInfo_visitor.data"
#define kDataKey @"accountInfo"
#define kDataKey1 @"accountInfo_visitor"
#import "AccountInfoStorage.h"

@implementation AccountInfoStorage

+(NSString *) getFilePath{
    
    NSArray *array =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[array objectAtIndex:0] stringByAppendingPathComponent:kFileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
    }
    return path;
}

+(NSString *) getFilePath1{
    
    NSArray *array =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[array objectAtIndex:0] stringByAppendingPathComponent:kFileName1];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
    }
    return path;
}

+ (AccountInfo *)getCurrentAccountInfo
{
    NSData *data = [[NSData alloc] initWithContentsOfFile:[self getFilePath]];
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    //解档出数据模型
    AccountInfo *info = [unarchiver decodeObjectForKey:kDataKey];
    [unarchiver finishDecoding];//一定不要忘记finishDecoding，否则会报错
    return info;
}

+ (void)saveAccountInfo:(AccountInfo *)accountInfo
{
    if (accountInfo == nil) {
        accountInfo = [[AccountInfo alloc] init];
    }
    
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:accountInfo forKey:kDataKey];
    [archiver finishEncoding];
    [data writeToFile:[self getFilePath] atomically:YES];
}
@end
