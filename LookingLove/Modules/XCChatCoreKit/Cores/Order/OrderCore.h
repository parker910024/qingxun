//
//  OrderCore.h
//  BberryCore
//
//  Created by chenran on 2017/6/12.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "BaseCore.h"
#import "OrderInfo.h"

@interface OrderCore : BaseCore
@property (nonatomic, strong)OrderInfo *current;
@property (assign, nonatomic) BOOL showBadge;

- (void)requestOrderList:(UserID)uid;
- (void)requestOrderStart:(OrderInfo *)orderInfo;
- (void)startPhoneCallTimer:(int)minutes;
- (void)requestFinishOrder:(NSString*)orderId;
- (void)setBadgeStore:(BOOL)show;
@end
