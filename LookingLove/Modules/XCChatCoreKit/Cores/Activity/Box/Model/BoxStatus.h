//
//  BoxStatus.h
//  XCChatCoreKit
//
//  Created by JarvisZeng on 2019/5/10.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

/// 钻石宝箱活动状态 model
@interface BoxStatus : BaseObject
@property (nonatomic, assign) BOOL opening; // 钻石宝箱的活动是否正在开放
@property (nonatomic, copy) NSString *startTime; // 活动开始时间
@property (nonatomic, copy) NSString *endTime; // 活动结束时间
@end

NS_ASSUME_NONNULL_END
