//
//  CustomProtolInfo.h
//  BberryCore
//
//  Created by chenran on 2017/6/21.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"

typedef enum {
    Custom_Type_Request_Order = 1,//发起订单
}CustomType;

@interface CustomProtolInfo : BaseObject
@property (nonatomic ,assign)CustomType customType;
@property (nonatomic, strong)NSString *extendMsg;
@end
