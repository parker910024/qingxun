//
//  BalanceErrorClient.h
//  BberryCore
//
//  Created by chenran on 2017/7/8.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BalanceErrorClient <NSObject>
@optional
/** 钱包余额不足 */
- (void)onBalanceNotEnough;
/** 萝卜钱包余额不足 */
- (void)onCarrotBalanceNotEnough;
@end
