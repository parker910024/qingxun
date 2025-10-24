//
//  NIMKitCore.h
//  BberryCore
//
//  Created by 卫明何 on 2017/10/16.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "BaseCore.h"

@interface NIMKitCore : BaseCore

//注入布局
- (void)initLayoutConfig;

//注入解码器
- (void)initCustomerMsgDecoder;

@end
