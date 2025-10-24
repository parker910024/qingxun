//
//  PurseBillCore.h
//  BberryCore
//
//  Created by 卫明何 on 2017/9/18.
//  Copyright © 2017年 chenran. All rights reserved.
//
//  账单

#import "BaseCore.h"
#import "RedPageDetailInfo.h"
@interface PurseBillCore : BaseCore

@property (nonatomic, strong) RedPageDetailInfo *redPageDetailInfo;

/**
 礼物支出

 @param pageNo 页码
 @param time 时间戳
 @param pageSize 每页大小
 */
- (void)getOutGiftListPageNo:(NSInteger)pageNo time:(NSString *)time pageSize:(NSInteger)pageSize;


/**
 礼物收入

 @param pageNo 页码
 @param time 时间戳
 @param pageSize 每页大小
 */
- (void)getInGiftListPageNo:(NSInteger)pageNo time:(NSString *)time pageSize:(NSInteger)pageSize;


/**
 密聊记录

 @param pageNo 页码
 @param time 时间戳
 @param pageSize 每页大小
 */
- (void)getChatListPageNo:(NSInteger)pageNo time:(NSString *)time pageSize:(NSInteger)pageSize;

/**
 充值记录
 
 @param pageNo 页码
 @param time 时间戳
 @param pageSize 每页大小
 */
- (void)getRechargeListPageNo:(NSInteger)pageNo time:(NSString *)time pageSize:(NSInteger)pageSize;

/**
 getCF记录
 
 @param pageNo 页码
 @param time 时间戳
 @param pageSize 每页大小
 */
- (void)getWithDrawlListPageNo:(NSInteger)pageNo time:(NSString *)time pageSize:(NSInteger)pageSize;

/*
 贵族开通记录
 @param pageNo 页码
 @param time 时间戳
 @param pageSize 每页大小
 */
- (void)getNobleListPageNo:(NSInteger)pageNo time:(NSString *)time pageSize:(NSInteger)pageSize;


/*
 [XCKeyWordTool sharedInstance].xcRedColor
 
 @param pageNo 页码
 @param time 时间戳
 @param pageSize 每页大小
 */
- (void)getRedWithDrawlListPageNo:(NSInteger)pageNo time:(NSString *)time pageSize:(NSInteger)pageSize;


/**
 [XCKeyWordTool sharedInstance].xcRedColor记录
 
 @param pageNo 页码
 @param date 时间戳
 @param pageSize 每页大小
 */
- (void)getRedListPageNo:(NSInteger)pageNo date:(NSString *)date pageSize:(NSInteger)pageSize;


/**
 获取[XCKeyWordTool sharedInstance].xcRedColor页面详情
 */
- (void)getRedPageInfo;

//[XCKeyWordTool sharedInstance].xcExchangeMethod码充值
- (void)requestExchangeWithCode:(NSString *)exchangeCode;

/**
 getCF记录展示
 */
- (void)getWithdrawalShowInfo;


/**
 CP我的账号金额信息
 */
- (void)requestCPMyAccount;

/**
 CP我的账号个人信息
 */
- (void)requestCPMySelfAccount;
/**
 cp收入明细
 
 @param pageNum 页码
 @param date yyyy-MM-dd
 @param pageSize 每页大小
 */
- (void)requestInRewardListpageNum:(NSInteger)pageNum pageSize:(NSInteger)pageSize;


/**
 cp 是否可以ti
 */
- (void)requestCPAccountCanDrawal;

#pragma mark -
#pragma mark 兔兔玩友公会线添加萝卜礼物相关 2019-03-27

/**
 萝卜礼物记录
 interface  /gift/radish/record/get
 @param type 1赠送，2收入
 @param date 时间戳
 @param pageNo 页码
 @param pageSize 每页数量
 */
- (void)getCarrotGiftList:(NSInteger)type
                   pageNo:(NSInteger)pageNo
                     date:(NSString *)date
                 pageSize:(NSInteger)pageSize;

/**
 萝卜账单记录
 interface /radish/bill/record/get
 @param type 1支出，2收入
 @param pageNo 页码
 @param date 时间戳
 @param pageSize 每页数量
 */
- (void)getCarrotBliiList:(NSInteger)type
                   pageNo:(NSInteger)pageNo
                     date:(NSString *)date
                 pageSize:(NSInteger)pageSize;
@end
