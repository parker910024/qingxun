//
//  ImLoginClient.h
//  BberryCore
//
//  Created by chenran on 2017/5/5.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ImLoginCoreClient <NSObject>
@optional
- (void)onImLoginSuccess;
- (void)onImSyncSuccess;
- (void)onImLogoutSuccess;
- (void)onImLoginFailth;
- (void)onImKick;
- (void)onRecieveRemoteNotification:(NSDictionary *)payload;
@end
