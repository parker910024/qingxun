//
//  MusicCache.m
//  BberryCore
//
//  Created by demo on 2017/12/25.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "MusicCache.h"
#import "XCMusicDBManager.h"

#define CACHENAME @"XCMusicCache"

@interface MusicCache()

//@property (nonatomic, strong) YYCache * yyCache;
@property (nonatomic, strong) XCMusicDBManager * musicDBManager;

@end

@implementation MusicCache

- (instancetype)init
{
    self = [super init];
    if (self) {
       // self.yyCache = [YYCache cacheWithName:CACHENAME];
        self.musicDBManager = [XCMusicDBManager defaultManager];
    }
    return self;
}

+ (instancetype)shareCache
{
    static dispatch_once_t onceToken = 0;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];

    });
    return instance;
}

- (void)getMusicInfoFromCacheWith:(NSString *)musicId success:(void (^)(MusicInfo *))success{
  
                [[XCMusicDBManager defaultManager]getMusicWithMusicID:musicId success:^(MusicInfo *musicInfo) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (musicInfo) {
                            success(musicInfo);

                        }else {

                        }

                    });

                }];

    
}

- (BOOL)saveMusicInfo:(MusicInfo *)musicInfo {

    return [self.musicDBManager insertMusic:musicInfo];

}

- (BOOL)saveMusicInfos:(NSArray<MusicInfo *> *)musicInfos {
    
    return [self.musicDBManager insertMusics:musicInfos];
    
}


- (NSArray *)getAllMusics {
    return [self.musicDBManager getAllMusics];
}

- (BOOL)removeMusicInfo:(MusicInfo *)musicInfo {
    
    return [self.musicDBManager deletMusic:musicInfo];
    
}

- (BOOL)removeAllObject {
    
   return [self.musicDBManager deletAllMusics];
}

@end
