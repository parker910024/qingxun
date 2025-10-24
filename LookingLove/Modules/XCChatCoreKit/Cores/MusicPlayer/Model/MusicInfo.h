//
//  MusicInfo.h
//  BberryCore
//
//  Created by demo on 2017/12/19.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"

typedef enum : NSUInteger {
    MP3 = 0,
    M4P = 1,
    WMA = 2,
    WAV = 3
} musicType;

typedef enum : NSUInteger {
    soruce_Location = 0,//本地
    soruce_iTunes = 1
} SoruceType;

@interface MusicInfo : BaseObject

@property(strong, nonatomic) NSString * musicName;
@property(strong, nonatomic) NSString * musicArtists;
@property(strong, nonatomic) NSString * filePath;
@property (assign, nonatomic) musicType type;
@property (assign, nonatomic) SoruceType soruceType;
@property(strong, nonatomic) NSString * musicId;


//以下用于在线播放器
/**
 歌名
 */
@property(strong, nonatomic) NSString * songName;

/**
 歌手
 */
@property(strong, nonatomic) NSString * author;

/**
 上传昵称
 */
@property(strong, nonatomic) NSString * nick;

/**
 专辑
 */
@property(strong, nonatomic) NSString * album;

/**
 在线url
 */
@property(strong, nonatomic) NSString * localUri;

@end
