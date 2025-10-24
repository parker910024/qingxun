//
//  BoxOpenBoxEnergyInfo.h
//  XCChatCoreKit
//
//  Created by JarvisZeng on 2019/5/13.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "BaseObject.h"

@interface BoxOpenBoxUserEnergy : BaseObject
@property (nonatomic, assign) int uid; // 用户 uid
@property (nonatomic, assign) int curEnergy; // 当前能量值
@property (nonatomic, assign) int expireDays; // 剩余天数
@end


@interface BoxOpenBoxEnergyInfo : BaseObject
@property (nonatomic, copy) NSArray *energyRanges; // 能量范围
@property (nonatomic, strong) BoxOpenBoxUserEnergy *userEnergy; // 用户当前能量数据
@end

