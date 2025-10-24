//
//  RoomMagicInfoStorage.m
//  BberryCore
//
//  Created by Mac on 2018/3/16.
//  Copyright © 2018年 chenran. All rights reserved.
//

#define kRoomMagicFileName @"RoomMagicInfoList.data"
#define kRoomMagicDataKey @"RoomMagicInfos"

#import "RoomMagicInfoStorage.h"
#import "RoomMagicInfo.h"
#import "NSObject+YYModel.h"
#import <SDWebImage/UIImageView+WebCache.h>



@implementation RoomMagicInfoStorage


+(NSString *) getFilePath{
    
    NSArray *array =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[array objectAtIndex:0] stringByAppendingPathComponent:kRoomMagicFileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
    }
    return path;
}

+ (NSMutableArray *)getRoomMagicInfos{
    
    NSData *data = [[NSData alloc] initWithContentsOfFile:[self getFilePath]];
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSMutableArray *roomMagicInfos = [NSMutableArray array];
    NSString *str = [unarchiver decodeObjectForKey:kRoomMagicDataKey];
    if (str.length > 0) {
        roomMagicInfos = [[NSArray yy_modelArrayWithClass:[RoomMagicInfo class] json:str] mutableCopy];
    }
    [unarchiver finishDecoding];
    return roomMagicInfos;
}

+ (void) saveRoomMagicInfos:(NSString *)json{
    
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:json forKey:kRoomMagicDataKey];
    [archiver finishEncoding];
    [data writeToFile:[self getFilePath] atomically:YES];
}

@end
