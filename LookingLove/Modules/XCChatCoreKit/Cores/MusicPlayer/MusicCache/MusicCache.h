//
//  MusicCache.h
//  BberryCore
//
//  Created by demo on 2017/12/25.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYCache.h>
#import "MusicInfo.h"

@interface MusicCache : NSObject
+ (instancetype)shareCache;


//获取音乐信息
- (void)getMusicInfoFromCacheWith:(NSString *)musicId success:(void (^)(MusicInfo *))success;

//缓存音乐信息
- (BOOL)saveMusicInfo:(MusicInfo *) musicInfo;

//批量
- (BOOL)saveMusicInfos:(NSArray<MusicInfo *> *)musicInfos;

//获取音乐信息
- (NSArray *)getAllMusics;

//移除音乐信息
- (BOOL)removeMusicInfo:(MusicInfo *)musicInfo;

//移除所有音乐信息
- (BOOL)removeAllObject;

@end
