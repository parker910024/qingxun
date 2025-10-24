//
//  MicroState.h
//  BberryCore
//
//  Created by KevinWang on 2018/8/22.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "BaseObject.h"

typedef NS_ENUM(NSUInteger, MicroPosState) {
    MicroPosStateFree = 0, //空闲
    MicroPosStateLock = 1, //上锁
};
typedef NS_ENUM(NSUInteger, MicroMicState) {
    MicroMicStateOpen = 0, //开麦
    MicroMicStateClose = 1, //静音
};


@interface MicroState : BaseObject
@property (nonatomic, assign) int position;
@property (nonatomic, assign) MicroPosState posState;
@property (nonatomic, assign) MicroMicState micState;
@property (nonatomic, assign) long expiredTime; //倒计时过期时间
@property (nonatomic, assign) UserID uid;//目标坑位用户id

@end
