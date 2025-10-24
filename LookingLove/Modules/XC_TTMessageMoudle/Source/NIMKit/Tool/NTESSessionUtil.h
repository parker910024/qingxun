//
//  NTESSessionUtil.h
//  NIMDemo
//
//  Created by ght on 15-1-27.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <NIMSDK/NIMSDK.h>

// 最近会话本地扩展标记类型
typedef NS_ENUM(NSInteger, NTESRecentSessionMarkType){
    // @ 标记
    NTESRecentSessionMarkTypeAt,
    // 置顶标记
    NTESRecentSessionMarkTypeTop,
};

@interface NTESSessionUtil : NSObject


+ (void)addRecentSessionMark:(NIMSession *)session type:(NTESRecentSessionMarkType)type;

+ (void)removeRecentSessionMark:(NIMSession *)session type:(NTESRecentSessionMarkType)type;

+ (BOOL)recentSessionIsMark:(NIMRecentSession *)recent type:(NTESRecentSessionMarkType)type;



-(void)TheThereEstablishmentUsThats;
 
@end
