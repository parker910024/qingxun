//
//  NobleCoreClient.h
//  BberryCore
//
//  Created by 卫明何 on 2018/1/13.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SingleNobleInfo.h"
#import "NobleBroadcastInfo.h"
#import "BalanceInfo.h"

@protocol NobleCoreClient <NSObject>

@optional
- (void)onNobleUserEnterChatRoomSuccess:(SingleNobleInfo *)nobleInfo andNick:(NSString *)nick;

/*
 查询房间贵族列表
 */
- (void)onRequestRoomNobleUserListSuccess:(NSArray *)list;
- (void)onRequestRoomNobleUserListFailth:(NSString *)msg;
- (void)onReceiveNobleBoardcast:(NobleBroadcastInfo *)nobleinfo;


//=========苹果支付=========
- (void)addNobleRechargeOrderFail:(NSString *)message; //下单失败
- (void)entryNobleRequestProductProgressStatus:(BOOL)Status;// 查询商品


- (void)entryNoblePurchaseProcessStatus:(XCPaymentStatus)Status; //进入购买流程

- (void)entryNobleCheckReceiptSuccess;//二次验证成功
- (void)entryNobleCheckReceiptFaildWithMessage:(NSString *)message;//二次验证失败
@end
