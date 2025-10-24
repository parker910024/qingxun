//
//  TTCPGameStaticCore.h
//  XCChatCoreKit
//
//  Created by new on 2019/2/27.
//  Copyright © 2019 KevinWang. All rights reserved.
//

#import "BaseCore.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTCPGameStaticCore : BaseCore


@property (nonatomic, assign) BOOL gameSwitch; // 游戏开关
@property (nonatomic, assign) BOOL roomGameSwitch; // 非陪伴房的游戏入口开关
@property (nonatomic, assign) int gameTime; // 游戏发起倒计时有效期
@property (nonatomic, assign) int gameFrequency; // 游戏发起间隔时间
@property (nonatomic, assign) BOOL gameRankSwitch; // 游戏榜单开关


@end

NS_ASSUME_NONNULL_END
