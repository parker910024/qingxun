//
//  PurseBillCoreClient.h
//  BberryCore
//
//  Created by 卫明何 on 2017/9/18.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RedPageDetailInfo.h"
#import "BalanceInfo.h"
#import "CPMyAccountInfo.h"

@protocol PurseBillCoreClient <NSObject>
@optional

//礼物支出
- (void)getOutGiftListSuccess:(NSMutableArray *)list keys:(NSMutableArray *)keys pageNo:(NSInteger)pageNo;
- (void)getOutGiftListFailth:(NSString *)message;

//礼物收入
- (void)getInGiftListSuccess:(NSMutableArray *)list keys:(NSMutableArray *)keys pageNo:(NSInteger)pageNo;
- (void)getInGiftListFailth:(NSString *)message;

//密聊
- (void)getChatListSuccess:(NSMutableArray *)list keys:(NSMutableArray *)keys pageNo:(NSInteger)pageNo;
- (void)getChatListFailth:(NSString *)message;

//充值
- (void)getRechargeListSuccess:(NSMutableArray *)list keys:(NSMutableArray *)keys pageNo:(NSInteger)pageNo;
- (void)getRechargeListFailth:(NSString *)message;

//xcGetCF
- (void)getWithdrawlListSuccess:(NSMutableArray *)list keys:(NSMutableArray *)keys pageNo:(NSInteger)pageNo;
- (void)getWithdrawlListFailth:(NSString *)message;

//贵族
- (void)getNobleBillListSuccess:(NSMutableArray *)list keys:(NSMutableArray *)keys pageNo:(NSInteger)pageNo;
- (void)getNobleBillListFailth:(NSString *)message;

//[XCKeyWordTool sharedInstance].xcRedColor
- (void)getRedWithdrawlListSuccess:(NSMutableArray *)list keys:(NSMutableArray *)keys pageNo:(NSInteger)pageNo;

- (void)getRedWithdrawlListFailth:(NSString *)message;


- (void)getRedGiftListSuccess:(NSMutableArray *)list keys:(NSMutableArray *)keys pageNo:(NSInteger)pageNo;
- (void)getRedGiftListFailth:(NSString *)message;

- (void)getRedPageInfoSuccess;
- (void)RedPageDetailInfoFailth:(NSString *)message;

- (void)requestCodeExchangeSuccess:(BalanceInfo *)balanceInfo;
- (void)requestCodeExchangeFailth:(NSString *)message;

- (void)requestWithdrawalShowInfoSuccess:(NSMutableArray *)showInfoList;
- (void)requestWithdrawalShowInfoFailth:(NSString *)message;

- (void)requestCPMyAccountSuccess:(CPMyAccountInfo *)accountInfo;
- (void)requestCPMyAccountFailth:(NSString *)message;


- (void)requestCPMySelfAccountSuccess:(CPMyAccountInfo *)accountInfo;
- (void)requestCPMySelfAccountFailth:(NSString *)message;
/**
 cp收入明细
 */
- (void)onRewardDetailWithSuccess:(NSArray *)list;
- (void)onRewardDetailFailth:(NSString *)message;

- (void)onCPAccountCanDrawalSuccess:(NSString *)message;
- (void)onCPAccountCanDrawalFailth:(NSString *)message;

#pragma mark -
#pragma mark 兔兔玩友公会线添加萝卜礼物相关 2019-03-27
/** 获取萝卜礼物 */
- (void)getCarrotGiftListSuccess:(NSMutableArray *)list keys:(NSMutableArray *)keys pageNo:(NSInteger)pageNo code:(NSNumber *)code message:(NSString *)message;
/** 获取萝卜账单记录 */
- (void)getCarrotGiftBliiListSuccess:(NSMutableArray *)list keys:(NSMutableArray *)keys pageNo:(NSInteger)pageNo code:(NSNumber *)code message:(NSString *)message listType:(NSInteger)listType;

@end
