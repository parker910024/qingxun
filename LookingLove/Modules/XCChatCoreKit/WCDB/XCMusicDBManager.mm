//
//  XCMusicDBManager.mm
//  BberryCore
//
//  Created by demo on 2018/1/8.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "XCMusicDBManager.h"
#import "MusicInfo+WCTTableCoding.h"
#import "AuthCore.h"
#import "CommonFileUtils.h"
#import "WCDBObjc.h"

static XCMusicDBManager * instance = nil;
static NSString * const MusicTable = @"music";

@interface XCMusicDBManager ()
@property (nonatomic, strong) WCTDatabase *dataBase;
@property (nonatomic, strong) WCTTable    *table;

@end

@implementation XCMusicDBManager
{
    dispatch_queue_t writeQueue;
}

#pragma mark - Life Cycle
+ (XCMusicDBManager *)defaultManager {
    if (instance) {
        return instance;
    }
    @synchronized (self) {
        if (instance == nil) {
            instance = [[XCMusicDBManager alloc] init];
            [instance creatMusicDB];
        }
    }
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        writeQueue = dispatch_queue_create("com.yy.face.YYFace.MusicDb", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}


#pragma mark - CreatOrUpdate
- (void)creatOrUpdateMusic:(MusicInfo *)music complete:(void (^)(void))complete {
    dispatch_async(writeQueue, ^{
        [_table insertOrReplaceObject:music];
        if (complete) {
            complete();
        }
    });
}

- (void)creatOrUpdateMusics:(NSArray *)musics {
    if (musics.count > 0) {
        dispatch_async(writeQueue, ^{
            [_table insertOrReplaceObjects:musics];
        });
    }
}


#pragma mark - Creat MusicDB
- (BOOL)creatMusicDB {
    
//    [WCTStatistics SetGlobalErrorReport:^(WCTError *error) {
//
//    }];
    
    [WCTDatabase globalTraceError:^(WCTError * _Nonnull error) {
            
    }];
    
    NSString *databasePath = [self getDBPath];
    //    if (![CommonFileUtils isFileExists:databasePath]) {
    _dataBase = [[WCTDatabase alloc] initWithPath:databasePath];
    //    }
    
        
    BOOL isExist = [_dataBase tableExists:NSStringFromClass(MusicInfo.class)];
    if (!isExist) {
        
        BOOL result = [_dataBase createTable:NSStringFromClass(MusicInfo.class) withClass:MusicInfo.class];
        if (result) {
            
            _table = [_dataBase getTable:NSStringFromClass(MusicInfo.class) withClass:MusicInfo.class];
        }
    }else {
        _table = [_dataBase getTable:NSStringFromClass(MusicInfo.class) withClass:MusicInfo.class];
    }
    return YES;
}

- (NSString *)getDBPath {
    NSString *path = [NSString stringWithFormat:@"Documents/database/%@",@"music"];
    NSString *databasePath = [NSHomeDirectory() stringByAppendingPathComponent:path];
    NSString *dbName = [NSString stringWithFormat:@"%@.db",@"music"];
    databasePath = [databasePath stringByAppendingPathComponent:dbName];
    return databasePath;
}

+ (void)destroy {
    instance = nil;
}


#pragma mark - Insert
- (BOOL)insertMusic:(MusicInfo *)music {

    return [_dataBase insertOrReplaceObject:music intoTable:NSStringFromClass(MusicInfo.class)];
}

- (BOOL)insertMusics:(NSArray<MusicInfo*> *)musics {
    return [_dataBase insertOrReplaceObjects:musics intoTable:NSStringFromClass(MusicInfo.class)];

}

#pragma mark - Update
- (BOOL)updateMusic:(MusicInfo *)music {
//    return [_table updateRowsOnProperties:MusicInfo.allProperties
//                               withObject:music
//                                    where:MusicInfo.musicId == music.musicId];
    return [_table updateProperties:MusicInfo.allProperties toObject:music where:MusicInfo.musicId == music.musicId];
    
}

#pragma mark - Delete
- (BOOL)deletMusic:(MusicInfo *)music {
    return [_table deleteObjectsWhere:MusicInfo.musicId == music.musicId];
}

- (BOOL)deletAllMusics {
    return [_table deleteObjects];
}


#pragma mark - Select
- (void)getMusicWithMusicID:(NSString *)musicID success:(void (^)(MusicInfo *))success {
    dispatch_async(writeQueue, ^{
        //        [_table insertOrReplaceObject:user];
        MusicInfo *info = [_table getObjectWhere:MusicInfo.musicId == musicID];
        
        success(info);
    });
    //    return ;
}

- (MusicInfo *)getMusicWithMusicID:(NSString *)musicID {
    return [_table getObjectWhere:MusicInfo.musicId == musicID];
}

- (NSArray<MusicInfo *> *)getMusicsWithMusicIDs:(NSArray *)musicIDs {
    
    NSMutableArray *musics = [NSMutableArray array];
    for (NSString *musicId in musicIDs) {
        MusicInfo *musicInfo = [self getMusicWithMusicID:musicId];
        [musics addObject:musicInfo];
    }
    return musics;
}

- (NSArray *)getAllMusics {
    return [_table getObjects];
}


@end
