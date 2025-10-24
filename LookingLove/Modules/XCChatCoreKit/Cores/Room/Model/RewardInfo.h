//
//  RewardInfo.h
//  BberryCore
//
//  Created by chenran on 2017/5/27.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"

@interface RewardInfo : BaseObject
@property(nonatomic, strong) NSString *rewardId;
@property(nonatomic, assign) UserID uid;
@property(nonatomic, assign) NSInteger rewardMoney;
@property(nonatomic, assign) NSInteger servDura;
@end
