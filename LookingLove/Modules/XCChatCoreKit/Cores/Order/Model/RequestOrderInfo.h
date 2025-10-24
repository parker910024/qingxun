//
//  RequestOrderInfo.h
//  BberryCore
//
//  Created by chenran on 2017/6/12.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderInfo.h"
#import "BaseObject.h"

@interface RequestOrderInfo : BaseObject
@property(nonatomic, assign) UserID requestUid;
@property(nonatomic, strong) NSString *nick;
@property(nonatomic, strong) OrderInfo *orderInfo;
@end
