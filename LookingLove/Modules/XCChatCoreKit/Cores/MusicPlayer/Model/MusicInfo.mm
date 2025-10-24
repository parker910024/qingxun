//
//  MusicInfo.mm
//  BberryCore
//
//  Created by demo on 2017/12/19.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "MusicInfo.h"
#import "WCDBObjc.h"

@implementation MusicInfo
WCDB_IMPLEMENTATION(MusicInfo)

WCDB_SYNTHESIZE(musicName)
WCDB_SYNTHESIZE(musicArtists)
WCDB_SYNTHESIZE(filePath)
WCDB_SYNTHESIZE(type)
WCDB_SYNTHESIZE(soruceType)
WCDB_SYNTHESIZE(musicId)

WCDB_SYNTHESIZE(songName)
WCDB_SYNTHESIZE(author)
WCDB_SYNTHESIZE(nick)
WCDB_SYNTHESIZE(album)
WCDB_SYNTHESIZE(localUri)

WCDB_PRIMARY(musicName)

WCDB_INDEX("_index", musicId)


@end
