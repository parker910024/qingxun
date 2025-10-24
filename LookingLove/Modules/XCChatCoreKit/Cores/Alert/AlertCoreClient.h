//
//  AlertCoreClient.h
//  BberryCore
//
//  Created by 卫明何 on 2017/9/26.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlertInfo.h"
#import "AlertCore.h"

@protocol AlertCoreClient <NSObject>
@optional

- (void)requestAlertInfoSuccess:(AlertInfo *)info;
- (void)requestAlertInfoFailth:(NSString *)message;


@end
