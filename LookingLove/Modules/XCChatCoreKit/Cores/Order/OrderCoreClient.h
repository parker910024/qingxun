//
//  OrderCoreClient.h
//  BberryCore
//
//  Created by chenran on 2017/6/12.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderInfo.h"
@protocol OrderCoreClient <NSObject>
@optional
- (void)onOrderStartRequest:(NSString *)uid from:(NSString *)from;

- (void)onRequestOrderListSuccess:(NSArray *)orderList;
- (void)onRequestOrderListFailth:(NSString *)msg;
- (void)updateTimer:(NSString *)time;
- (void)endTimer;

- (void)onRequestFinishOrderSuccess;
- (void)onRequestFinishOrderFailth;

- (void)needShowBadge;
@end
