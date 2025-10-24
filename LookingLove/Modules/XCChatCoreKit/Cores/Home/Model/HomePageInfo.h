//
//  HomePageInfo.h
//  BberryCore
//
//  Created by chenran on 2017/6/26.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "RoomInfo.h"
#import "UserInfo.h"


@interface HomePageInfo : RoomInfo

@property (nonatomic, copy)NSString *avatar;
@property (nonatomic, copy)NSString *nick;
//@property (nonatomic, copy) NSString *tagPict;
@property (nonatomic, copy) NSString *badge;
@property (nonatomic, assign) BOOL isRecom;
//KTV
@property (nonatomic, copy) NSString *singingMusicName;//歌曲名
@property (nonatomic, assign) UserID roomUid;//房主id
@end

