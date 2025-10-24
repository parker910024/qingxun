//
//  AnchorOrderStatus.m
//  XCChatCoreKit
//
//  Created by lvjunhang on 2020/4/27.
//  Copyright © 2020 YiZhuan. All rights reserved.
//

#import "AnchorOrderStatus.h"

@implementation AnchorOrderStatus

@end

@implementation AnchorOrderInfo

- (void)setOrderValidTime:(NSString *)orderValidTime {
    _orderValidTime = orderValidTime;
    
    //testing
//    orderValidTime = @"20";
    
    if (orderValidTime.integerValue > 0) {
        self.orderFinalValidDate = [NSDate dateWithTimeIntervalSinceNow:orderValidTime.integerValue];
    }
}
@end
