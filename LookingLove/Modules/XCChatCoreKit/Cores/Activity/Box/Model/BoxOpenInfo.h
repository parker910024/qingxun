//
//  BoxOpenInfo.h
//  XCChatCoreKit
//
//  Created by JarvisZeng on 2019/5/13.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "BaseObject.h"
#import "BoxCirtData.h"
#import "BoxOpenBoxEnergyInfo.h"

typedef enum : NSUInteger {
    XCBoxType_Normal = 0, // 普通宝箱
    XCBoxType_Diamond = 1 // 钻石宝箱
} XCBoxType;

NS_ASSUME_NONNULL_BEGIN

@interface BoxOpenInfo : BaseObject
@property (nonatomic, strong) BoxCirtData *openBoxCritAct; // 宝箱暴击活动
@property (nonatomic, strong) BoxOpenBoxEnergyInfo *openBoxEnergyAct; // 宝箱能量活动
@end

NS_ASSUME_NONNULL_END
