//
//  RedPageDetailInfo.h
//  BberryCore
//
//  Created by 卫明何 on 2017/9/23.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"

@interface RedPageDetailInfo : BaseObject

@property (assign, nonatomic) UserID uid;
@property (copy, nonatomic) NSString *shareCount;
@property (copy, nonatomic) NSString *packetNum;
@property (copy, nonatomic) NSString *packetCount;
@property (copy, nonatomic) NSString *registerCout;
@property (copy, nonatomic) NSString *chargeBonus;
@end
