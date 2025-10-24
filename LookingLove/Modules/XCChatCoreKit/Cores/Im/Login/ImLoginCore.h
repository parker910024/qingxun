//
//  ImLoginCore.h
//  BberryCore
//
//  Created by chenran on 2017/4/15.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "BaseCore.h"
#import <Foundation/Foundation.h>

@interface ImLoginCore : BaseCore
- (void)updateApnsToken:(NSData *)token;
- (void)handleRemoteNotification:(NSDictionary *)userInfo;
- (BOOL)isImLogin;
- (BOOL)getImLoginState;
- (void)markNotificationRead;
@end
