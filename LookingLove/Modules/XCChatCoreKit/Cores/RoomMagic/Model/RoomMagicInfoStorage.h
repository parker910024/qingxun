//
//  RoomMagicInfoStorage.h
//  BberryCore
//
//  Created by Mac on 2018/3/16.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RoomMagicInfoStorage : NSObject

+ (NSMutableArray *)getRoomMagicInfos;

+ (void) saveRoomMagicInfos:(NSString *)json;

@end
