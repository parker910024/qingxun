//
//  RoomMagicWallInfo.h
//  BberryCore
//
//  Created by 卫明何 on 2018/3/19.
//  Copyright © 2018年 chenran. All rights reserved.
//
//  魔法墙


#import "BaseObject.h"

@interface RoomMagicWallInfo : BaseObject

/**
 魔法表情id
 */
@property (nonatomic, strong) NSString *magicId;

/**
 魔法表情名字
 */
@property (nonatomic, strong) NSString *magicName;

/**
 魔法表情icon
 */
@property (nonatomic, strong) NSString *magicIcon;

/**
 收到魔法表情的数量
 */
@property (nonatomic, strong) NSString *amount;


@end

