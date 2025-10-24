//
//  DataUtils.m
//  YYFaceAuth
//
//  Created by chenran on 16/10/18.
//  Copyright © 2016年 zhangji. All rights reserved.
//
#define kFileName @"GiftInfoList.data"
#define kDataKey @"giftInfos"
#import "GiftInfoStorage.h"
#import "GiftInfo.h"
#import "NSObject+YYModel.h"
#import <SDWebImage/UIImageView+WebCache.h>



@implementation GiftInfoStorage

+(NSString *) getFilePath{
    
    NSArray *array =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[array objectAtIndex:0] stringByAppendingPathComponent:kFileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
    }
    return path;
}

+ (NSMutableArray *)getGiftInfos
{
    NSData *data = [[NSData alloc] initWithContentsOfFile:[self getFilePath]];
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    //解档出数据模型
    NSMutableArray *giftInfos = [NSMutableArray array];
    NSString *str = [unarchiver decodeObjectForKey:kDataKey];
    if (str.length > 0) {
        giftInfos = [[NSArray yy_modelArrayWithClass:[GiftInfo class] json:str] mutableCopy];
    }
    [unarchiver finishDecoding];//一定不要忘记finishDecoding，否则会报错
    return giftInfos;
}

+ (void)saveGiftInfos:(NSString *)json
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:json forKey:kDataKey];
    [archiver finishEncoding];
    [data writeToFile:[self getFilePath] atomically:YES];
}
@end
