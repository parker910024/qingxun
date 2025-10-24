//
//  LogCore.h
//  BberryCore
//
//  Created by 卫明何 on 2018/3/14.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "BaseCore.h"
#import "LogSK.h"

@interface LogCore : BaseCore
@property (nonatomic, strong)LogSK *sk;

- (void)requestLogSk;

@end
