//
//  CarCoreClient.h
//  BberryCore
//
//  Created by 卫明何 on 2018/3/7.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserCar.h"

@protocol CarCoreClient <NSObject>
@optional
- (void)userEnterRoomWithDrivingCarEffect:(UserCar *)effect;
@end
