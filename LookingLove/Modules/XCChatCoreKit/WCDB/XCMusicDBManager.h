//
//  XCMusicDBManager.h
//  BberryCore
//
//  Created by demo on 2018/1/8.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "musicInfo.h"

@interface XCMusicDBManager : NSObject

#pragma mark - Life Cycle
+ (XCMusicDBManager *)defaultManager;
+ (void)destroy;

#pragma mark - CreatOrUpdate

- (void)creatOrUpdateMusic:(MusicInfo *)music complete:(void (^)(void))complete;
- (void)creatOrUpdateMusics:(NSArray *)musics;

#pragma mark - Insert

//单条数据插入
- (BOOL)insertMusic:(MusicInfo *)music;
//批量插入
- (BOOL)insertMusics:(NSArray<MusicInfo*> *)musics;

#pragma mark - Update
- (BOOL)updateMusic:(MusicInfo *)music;

#pragma mark - Delete
- (BOOL)deletMusic:(MusicInfo *)music;
- (BOOL)deletAllMusics;

#pragma mark - Select
- (void)getMusicWithMusicID:(NSString *)musicID success:(void (^)(MusicInfo *musicInfo))success;
- (MusicInfo *)getMusicWithMusicID:(NSString *)musicID;
- (NSArray<MusicInfo *> *)getMusicsWithMusicIDs:(NSArray *)musicIDs;
- (NSArray *)getAllMusics;

@end
