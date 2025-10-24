//
//  AdCoreClient.h
//  BberryCore
//
//  Created by 卫明何 on 2018/1/3.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UserUpGradeInfo.h"

@protocol AdCoreClient <NSObject>

- (void)onReceiveTurntableMessage;
- (void)onReceiveUserUpGradeMessage:(UserUpGradeInfo *)upGradeInfo type:(UserUpgradeViewType)type;


@end
