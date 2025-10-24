//
//  LogSK.h
//  BberryCore
//
//  Created by 卫明何 on 2018/3/14.
//  Copyright © 2018年 chenran. All rights reserved.
//


#import "BaseObject.h"

@interface LogSK : BaseObject

@property (nonatomic, copy)NSString *accessKeyId;
@property (nonatomic, copy)NSString *accessKeySecret;
@property (nonatomic, copy)NSString *securityToken;
@property (nonatomic, copy)NSString *expiration;

@end
