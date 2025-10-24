//
//  DiscoverTofuInfo.h
//  XCChatCoreKit
//
//  Created by lee on 2019/3/30.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "BaseObject.h"
#import "P2PInteractiveAttachment.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, TofuSkipType) {
    TofuSkipTypeWebH5 = 1,  // h5
    TofuSkipTypeRoom = 2,   // 房间
    TofuSkipTypeGame = 3,   // 游戏
    TofuSkipTypeHeadWear = 4, // 头饰
    TofuSkipTypeJumpAppVC = 5, // 跳转App内，根据 routerType
};

typedef NS_ENUM(NSUInteger, SkipAppVcType) {
    SkipAppVcTypeCheckIn = 1, //签到
    SkipAppVcTypeMission = 2 , // 任务
};


@interface DiscoverTofuInfo : BaseObject
@property (nonatomic, copy) NSString *bannerID;
@property (nonatomic, copy) NSString *param;
@property(nonatomic, assign) TofuSkipType type;

/** 大图 */
@property (nonatomic, copy) NSString *pic;
/** 小图 */
@property (nonatomic, copy) NSString *minPic;
/** app跳转类型 */
@property (nonatomic, assign) P2PInteractive_SkipType routerType;
/** 活动类型，1：签到，2：任务     */
@property (nonatomic, assign) SkipAppVcType activityType;
/** app跳转类型参数 */
@property (nonatomic, copy) NSString *routerValue;
/** 今日未完成的任务数量 */
@property (nonatomic, copy) NSString *missionNum;
/** 名称 */
@property (nonatomic, copy) NSString *name;
/** 今日是否已经签到 */
@property(nonatomic, assign) BOOL signStatus;

@end

NS_ASSUME_NONNULL_END
