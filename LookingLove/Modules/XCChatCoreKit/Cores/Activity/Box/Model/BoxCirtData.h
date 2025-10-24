//
//  BoxCirtData.h
//  XCChatCoreKit
//
//  Created by KevinWang on 2019/4/14.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "BaseObject.h"

typedef enum : NSUInteger {
    BoxCirtActivityStatus_UnStart=1,//未开始
    BoxCirtActivityStatus_Start,//活动开始
    BoxCirtActivityStatus_Finshed,//活动结束
} BoxCirtActivityStatus;//服务端返回活动状态



NS_ASSUME_NONNULL_BEGIN

@interface BoxCirtData : BaseObject

/**
 活动的时间点，活动的唯一标识
 */
@property (nonatomic, copy) NSString *timePoint;

/**
 活动状态. 1-未开始 2-进行中 3-已结束
 */
@property (nonatomic, assign) BoxCirtActivityStatus status;

/**
 活动总时长，单位秒（目前是30分钟）
 */
@property (nonatomic, assign) int totalTime;

/**
 活动已经开始的时间，单位秒
 */
@property (nonatomic, assign) int alreadyStartedTime;

@end

NS_ASSUME_NONNULL_END
