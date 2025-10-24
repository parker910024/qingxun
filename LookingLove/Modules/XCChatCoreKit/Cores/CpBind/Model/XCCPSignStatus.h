//
//  CPSignStatus.h
//  UKiss
//
//  Created by apple on 2018/10/13.
//  Copyright © 2018年 yizhuan. All rights reserved.
//

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface XCCPSignStatus : BaseObject

/**
 自己今天是否已打卡
 */
@property (nonatomic, assign)BOOL uidStatus;
/**
 CP今天是否已打卡
 */
@property (nonatomic, assign)BOOL cpUidStatus;

/**
 打卡天数
 */
@property (nonatomic, copy)NSString *days;

@end

NS_ASSUME_NONNULL_END
