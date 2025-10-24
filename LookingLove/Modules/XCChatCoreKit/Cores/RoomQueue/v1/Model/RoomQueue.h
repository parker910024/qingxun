//
//  RoomQueue.h
//  BberryCore
//
//  Created by 卫明何 on 2017/9/5.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"

typedef NS_ENUM(NSUInteger, RoomQueueType) {
    QUEUE_TYPE_FREE = 0, //空闲
    QUEUE_TYPE_LOCK = 1, //上锁
};


@interface RoomQueue : BaseObject

@property (nonatomic, assign) RoomQueueType queueType;
@property (nonatomic, assign) BOOL isMute;

@end
