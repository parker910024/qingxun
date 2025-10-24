//
//  BalanceInfoStorage.m
//  BberryCore
//
//  Created by chenran on 2017/7/8.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "BalanceInfoStorage.h"
#define kFileName @"BalanceInfo.data"
#define kDataKey @"balanceInfo"

@implementation BalanceInfoStorage

+(NSString *) getFilePath{
    
    NSArray *array =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[array objectAtIndex:0] stringByAppendingPathComponent:kFileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
    }
    return path;
}

+ (BalanceInfo *)getCurrentBalanceInfo
{
    NSData *data = [[NSData alloc] initWithContentsOfFile:[self getFilePath]];
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    //解档出数据模型
    BalanceInfo *info = [unarchiver decodeObjectForKey:kDataKey];
    [unarchiver finishDecoding];//一定不要忘记finishDecoding，否则会报错
    return info;
}

+ (void)saveBalanceInfo:(BalanceInfo *)balanceInfo
{
    if (balanceInfo == nil) {
        balanceInfo = [[BalanceInfo alloc] init];
    }
    
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:balanceInfo forKey:kDataKey];
    [archiver finishEncoding];
    [data writeToFile:[self getFilePath] atomically:YES];
}
@end
