//
//  MusicInfo+WCTTableCoding.h
//  BberryCore
//
//  Created by demo on 2018/1/8.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "MusicInfo.h"
#import "WCDBObjc.h"

@interface MusicInfo (WCTTableCoding) <WCTTableCoding>

WCDB_PROPERTY(musicName)
WCDB_PROPERTY(musicArtists)
WCDB_PROPERTY(filePath)
WCDB_PROPERTY(type)
WCDB_PROPERTY(musicId)
WCDB_PROPERTY(soruceType)


@end
