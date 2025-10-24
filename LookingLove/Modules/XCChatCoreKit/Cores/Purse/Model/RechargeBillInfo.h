//
//  RechargeBillInfo.h
//  BberryCore
//
//  Created by 卫明何 on 2017/9/20.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"

@interface RechargeBillInfo : BaseObject

@property (strong, nonatomic)NSString *money;
@property (strong, nonatomic)NSString *goldNum;
@property (assign, nonatomic)double recordTime;
@property (strong, nonatomic)NSString *showStr;
//@property (assign, nonatomic)NSInteger expendType;
@property (nonatomic, strong) NSString *objType;  // 54主播赠送金币，55受赠金币

@end
