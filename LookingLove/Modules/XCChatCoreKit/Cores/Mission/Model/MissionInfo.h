//
//  MissionInfo.h
//  XCChatCoreKit
//
//  Created by lee on 2019/3/28.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "BaseObject.h"
#import "P2PInteractiveAttachment.h"
//状态：0.未完成；1.已完成未领取；2.已完成已领取

/**
 任务状态类型

 - MissionStatusUndone: 0.未完成
 - MissionStatusDoneUnreceive: 1.已完成未领取
 - MissionStatusDoneReceive: 2.已完成已领取
 */
typedef NS_ENUM(NSUInteger, MissionStatus) {
    /**  - MissionStatusUndone: 0.未完成 */
    MissionStatusUndone = 0,
    /**  - MissionStatusDoneUnreceive: 1.已完成未领取 */
    MissionStatusDoneUnreceive = 1,
    /**  - MissionStatusDoneReceive: 2.已完成已领取 */
    MissionStatusDoneReceive = 2,
};

/**
 跳转类型

 - MissionSkipType_AppPage: 跳转App页面
 - MissionSkipType_AlertGuide: 弹窗提醒
 */
typedef NS_ENUM(NSUInteger, MissionSkipType) {
    MissionSkipType_AppPage = 1,
    MissionSkipType_AlertGuide = 2,
};

NS_ASSUME_NONNULL_BEGIN

@interface MissionInfo : BaseObject
@property (nonatomic, copy) NSString *configId;
/** 任务名称 */
@property (nonatomic, copy) NSString *name;
/** 当前任务完成数 */
@property (nonatomic, copy) NSString *current;
/** 任务目标任务数 */
@property (nonatomic, copy) NSString *target;
/** 任务描述 */
@property (nonatomic, copy) NSString *descriptionStr;
/** 奖品数量 */
@property (nonatomic, copy) NSString *prizeNum;
/** 奖品名称 */
@property (nonatomic, copy) NSString *prizeName;
/** 任务状态 */
@property(nonatomic, assign) MissionStatus status;
//跳转类型：1.跳app页面 2 弹窗提醒
@property(nonatomic, assign) MissionSkipType skipType;
//跳转类型值：26.签到 29.游戏tab页
@property(nonatomic, assign) P2PInteractive_SkipType routerType;
//跳转值
@property (nonatomic, assign) NSInteger routerValue;
/** 奖品图标 */
@property (nonatomic, copy) NSString *prizeIcon;
/** 奖品图片 */
@property (nonatomic, copy) NSString *prizePic;
/** 成功领取提示     */
@property (nonatomic, copy) NSString *tips;
/** 版本支持：0.不支持；1.支持     */
@property (nonatomic, assign) BOOL support;
/** prizeType 奖励类型 12. 萝卜，虽然目前都是萝卜奖励，但为了以后方便拓展，判断prizeType = 12的时候，才去刷新萝卜数量*/
@property (nonatomic, assign) NSInteger prizeType;
/** 弹窗引导的图片 url */
@property (nonatomic, copy) NSString *stepPic;
@end

NS_ASSUME_NONNULL_END
