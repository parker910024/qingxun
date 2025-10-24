//
//  RechargeInfo.h
//  BberryCore
//
//  Created by chenran on 2017/7/1.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"

@interface RechargeInfo : BaseObject
@property(nonatomic, strong) NSString *chargeProdId;
@property(nonatomic, strong) NSString *prodName;
@property (copy, nonatomic) NSString *prodDesc;
@property(nonatomic, strong) NSNumber *money;
@property(nonatomic, strong) NSNumber *giftGoldNum;
@property(nonatomic, strong) NSString *channel;

/**记录是否被选中*/
@property(nonatomic, assign) bool isSelect;

@end
