//
//  PurseBillCore.m
//  BberryCore
//
//  Created by 卫明何 on 2017/9/18.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "PurseBillCore.h"
#import "HttpRequestHelper+bill.h"
#import "HttpRequestHelper+Carrot.h"
#import "PurseBillCoreClient.h"
#import "PurseCoreClient.h"
#import "PurseCore.h"
#import "NSString+JsonToDic.h"
#import "YYUtility.h"

#import "PLTimeUtil.h"
// model
#import "CarrotGiftInfo.h"

@implementation PurseBillCore


- (void)getOutGiftListPageNo:(NSInteger)pageNo time:(NSString *)time pageSize:(NSInteger)pageSize {
    [HttpRequestHelper getGiftOutBillWithPageNo:pageNo time:time pageSize:pageSize Success:^(NSMutableArray *arr,NSMutableArray *keys) {
        NotifyCoreClient(PurseBillCoreClient, @selector(getOutGiftListSuccess:keys:pageNo:), getOutGiftListSuccess:arr keys:keys pageNo:pageNo);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(PurseBillCoreClient, @selector(getOutGiftListFailth:), getOutGiftListFailth:message);
    }];
}

- (void)getInGiftListPageNo:(NSInteger)pageNo time:(NSString *)time pageSize:(NSInteger)pageSize {
    [HttpRequestHelper getGiftInBillWithPageNo:pageNo time:time pageSize:pageSize Success:^(NSMutableArray *arr,NSMutableArray *keys) {
        NotifyCoreClient(PurseBillCoreClient, @selector(getInGiftListSuccess:keys:pageNo:), getInGiftListSuccess:arr keys:keys pageNo:pageNo);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(PurseBillCoreClient, @selector(getOutGiftListFailth:), getInGiftListFailth:message);
    }];
}

/**
 密聊记录
 
 @param pageNo 页码
 @param time 时间戳
 @param pageSize 每页大小
 */
- (void)getChatListPageNo:(NSInteger)pageNo time:(NSString *)time pageSize:(NSInteger)pageSize  {
    [HttpRequestHelper getChatBillWithPageNo:pageNo time:time pageSize:pageSize Success:^(NSMutableArray *arr,NSMutableArray *keys) {
        NotifyCoreClient(PurseBillCoreClient, @selector(getChatListSuccess:keys:pageNo:), getChatListSuccess:arr keys:keys pageNo:pageNo);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(PurseBillCoreClient, @selector(getChatListFailth:), getChatListFailth:message);
    }];
}

/**
 充值记录
 
 @param pageNo 页码
 @param time 时间戳
 @param pageSize 每页大小
 */
- (void)getRechargeListPageNo:(NSInteger)pageNo time:(NSString *)time pageSize:(NSInteger)pageSize {
    [HttpRequestHelper getRechargeBillWithPageNo:pageNo time:time pageSize:pageSize Success:^(NSMutableArray *arr,NSMutableArray *keys) {
        
        NotifyCoreClient(PurseBillCoreClient, @selector(getRechargeListSuccess:keys:pageNo:), getRechargeListSuccess:arr keys:keys pageNo:pageNo);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(PurseBillCoreClient, @selector(getRechargeListFailth:), getRechargeListFailth:message);
    }];
}

/**
 getCF记录
 
 @param pageNo 页码
 @param time 时间戳
 @param pageSize 每页大小
 */
- (void)getWithDrawlListPageNo:(NSInteger)pageNo time:(NSString *)time pageSize:(NSInteger)pageSize {
    [HttpRequestHelper getWithdrawlBillWithPageNo:pageNo time:time pageSize:pageSize Success:^(NSMutableArray *arr,NSMutableArray *keys) {
        NotifyCoreClient(PurseBillCoreClient, @selector(getWithdrawlListSuccess:keys:pageNo:), getWithdrawlListSuccess:arr keys:keys pageNo:pageNo);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(PurseBillCoreClient, @selector(getWithdrawlListFailth:), getWithdrawlListFailth:message);
    }];
}



/**
 贵族开通记录
 @param pageNo 页码
 @param time 时间戳
 @param pageSize 每页大小
 */
- (void)getNobleListPageNo:(NSInteger)pageNo time:(NSString *)time pageSize:(NSInteger)pageSize{
    [HttpRequestHelper getNobleBillWithPageNo:pageNo time:time pageSize:pageSize Success:^(NSMutableArray *arr, NSMutableArray *keys) {
        NotifyCoreClient(PurseBillCoreClient,@selector(getNobleBillListSuccess:keys:pageNo:), getNobleBillListSuccess:arr keys:keys pageNo:pageNo);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(PurseBillCoreClient, @selector(getNobleBillListFailth:), getNobleBillListFailth:message);
    }];
}

/**
 [XCKeyWordTool sharedInstance].xcRedColor
 
 @param pageNo 页码
 @param time 时间戳
 @param pageSize 每页大小
 */
- (void)getRedWithDrawlListPageNo:(NSInteger)pageNo time:(NSString *)time pageSize:(NSInteger)pageSize{
    [HttpRequestHelper getRedWithdrawlBillWithPageNo:pageNo time:time pageSize:pageSize Success:^(NSMutableArray *arr,NSMutableArray *keys) {
        NotifyCoreClient(PurseBillCoreClient, @selector(getRedWithdrawlListSuccess:keys:pageNo:), getRedWithdrawlListSuccess:arr keys:keys pageNo:pageNo);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(PurseBillCoreClient, @selector(getRedWithdrawlListFailth:), getRedWithdrawlListFailth:message);
    }];
}



/**
 [XCKeyWordTool sharedInstance].xcRedColor记录
 
 @param pageNo 页码
 @param date 时间戳

 */
- (void)getRedListPageNo:(NSInteger)pageNo date:(NSString *)date pageSize:(NSInteger)pageSize{
    [HttpRequestHelper getRedBillWithPageNo:pageNo date:date pageSize:pageSize Success:^(NSMutableArray *arr,NSMutableArray *keys) {
        NotifyCoreClient(PurseBillCoreClient, @selector(getRedGiftListSuccess:keys:pageNo:), getRedGiftListSuccess:arr keys:keys pageNo:pageNo);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(PurseBillCoreClient, @selector(getRedGiftListFailth:), getRedGiftListFailth:message);
    }];
}


/**
 获取[XCKeyWordTool sharedInstance].xcRedColor详情界面数据
 */
- (void)getRedPageInfo {
    [HttpRequestHelper getRedPageDetailInfoSuccess:^(RedPageDetailInfo *info) {
        self.redPageDetailInfo = info;
        NotifyCoreClient(PurseBillCoreClient, @selector(getRedPageInfoSuccess), getRedPageInfoSuccess);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(PurseBillCoreClient, @selector(RedPageDetailInfoFailth:), RedPageDetailInfoFailth:message);
    }];
}


/*
 [XCKeyWordTool sharedInstance].xcExchangeMethod码充值
 */

- (void)requestExchangeWithCode:(NSString *)exchangeCode{
    [HttpRequestHelper requestExchangeCodeRechargeWithCode:exchangeCode Success:^(BalanceInfo * balanceInfo) {
        NotifyCoreClient(PurseBillCoreClient, @selector(requestCodeExchangeSuccess:),requestCodeExchangeSuccess:balanceInfo);
        GetCore(PurseCore).balanceInfo = balanceInfo;
        NotifyCoreClient(PurseCoreClient, @selector(onBalanceInfoUpdate:), onBalanceInfoUpdate:balanceInfo);
    } failure:^(NSNumber * resCode, NSString * message) {
        NotifyCoreClient(PurseBillCoreClient, @selector(requestCodeExchangeFailth:), requestCodeExchangeFailth:message);
    }];
}


/*
 getCF记录展示
 */
- (void)getWithdrawalShowInfo{
    [HttpRequestHelper requestExchangeWithdrawalShowInfoSuccess:^(NSMutableArray * showInfoList) {
        NotifyCoreClient(PurseBillCoreClient, @selector(requestWithdrawalShowInfoSuccess:), requestWithdrawalShowInfoSuccess:showInfoList)
    } failure:^(NSNumber * resCode, NSString * message) {
        NotifyCoreClient(PurseBillCoreClient, @selector(requestWithdrawalShowInfoFailth:), requestWithdrawalShowInfoFailth:message);
    }];
}

/**
 CP我的账号金额信息
 */
- (void)requestCPMyAccount{
    [HttpRequestHelper requestCPMyAccountSuccess:^(CPMyAccountInfo *accountInfo) {
        NotifyCoreClient(PurseBillCoreClient, @selector(requestCPMyAccountSuccess:), requestCPMyAccountSuccess:accountInfo)
    } failure:^(NSNumber *code, NSString *message) {
        NotifyCoreClient(PurseBillCoreClient, @selector(requestCPMyAccountFailth:), requestCPMyAccountFailth:message)
    }];
}

/**
 CP我的账号个人金额信息
 */
- (void)requestCPMySelfAccount{
    [HttpRequestHelper requestCPMyselfAccountSuccess:^(CPMyAccountInfo *accountInfo) {
        NotifyCoreClient(PurseBillCoreClient, @selector(requestCPMySelfAccountSuccess:), requestCPMySelfAccountSuccess:accountInfo)
    } failure:^(NSNumber *code, NSString *message) {
        NotifyCoreClient(PurseBillCoreClient, @selector(requestCPMySelfAccountFailth:), requestCPMySelfAccountFailth:message)
    }];
}

- (void)requestInRewardListpageNum:(NSInteger)pageNum pageSize:(NSInteger)pageSize{
    [HttpRequestHelper requestRewardDetailWithPageNum:pageNum pageSize:pageSize Success:^(NSArray *list) {
        NotifyCoreClient(PurseBillCoreClient, @selector(onRewardDetailWithSuccess:), onRewardDetailWithSuccess:list);
    } failure:^(NSString *msg) {
        NotifyCoreClient(PurseBillCoreClient, @selector(onRewardDetailFailth:), onRewardDetailFailth:msg);
    }];
}

- (void)requestCPAccountCanDrawal{
    [HttpRequestHelper requestCPAccountCanDrawal:^(NSString *message) {
        NotifyCoreClient(PurseBillCoreClient, @selector(onCPAccountCanDrawalSuccess:), onCPAccountCanDrawalSuccess:message);
    } failure:^(NSNumber *code, NSString *message) {
        NotifyCoreClient(PurseBillCoreClient, @selector(onCPAccountCanDrawalFailth:), onCPAccountCanDrawalFailth:message);
    }];
}

#pragma mark -
#pragma mark 兔兔玩友公会线添加萝卜礼物相关 2019-03-27

/**
 萝卜礼物记录
 
 @param type giftType 1赠送，2收入
 @param date 时间戳
 @param pageNo 页码
 @param pageSize 每页数量
 */
- (void)getCarrotGiftList:(NSInteger)type
                   pageNo:(NSInteger)pageNo
                     date:(NSString *)date
                 pageSize:(NSInteger)pageSize {
    [HttpRequestHelper requestCarrotGiftWityType:type time:date pageNo:pageNo pageSize:pageSize andCompletionBlock:^(id  _Nullable resultObject, NSNumber * _Nullable code, NSString * _Nullable msg) {
        if (![resultObject isKindOfClass:[NSDictionary class]]) {
            NotifyCoreClient(PurseBillCoreClient, @selector(getCarrotGiftListSuccess:keys:pageNo:code:message:), getCarrotGiftListSuccess:nil keys:nil pageNo:0 code:code message:msg);
            return ;
        }
        
        NSArray * billList = resultObject[@"billList"];
        NSMutableArray *keysList = [NSMutableArray array];
        NSMutableArray *dataArr = [NSMutableArray array];
    
        [billList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           
            NSArray *subKeys = [obj allKeys];
            NSString *key = subKeys[0];
            NSArray *oneDayArr = [NSArray yy_modelArrayWithClass:[CarrotGiftInfo class] json:[obj objectForKey:key]];
            NSString *finallyKey = [PLTimeUtil getDateWithYYMMDD:key];
            [keysList addObject:finallyKey];
            [dataArr addObject:oneDayArr];
        }];
        
        NotifyCoreClient(PurseBillCoreClient, @selector(getCarrotGiftListSuccess:keys:pageNo:code:message:), getCarrotGiftListSuccess:dataArr keys:keysList pageNo:pageNo code:code message:msg);
    }];
}

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
                 pageSize:(NSInteger)pageSize {
    [HttpRequestHelper requestCarrotGiftBillWityType:type time:date pageNo:pageNo pageSize:pageSize andCompletionBlock:^(id  _Nullable resultObject, NSNumber * _Nullable code, NSString * _Nullable msg) {
        if (![resultObject isKindOfClass:[NSDictionary class]]) {
            NotifyCoreClient(PurseBillCoreClient, @selector(getCarrotGiftBliiListSuccess:keys:pageNo:code:message:listType:), getCarrotGiftBliiListSuccess:nil keys:nil pageNo:pageNo code:code message:msg listType:type);
            return ;
        }
        
        NSArray * billList = resultObject[@"billList"];
        NSMutableArray *keysList = [NSMutableArray array];
        NSMutableArray *dataArr = [NSMutableArray array];
        
        [billList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSArray *subKeys = [obj allKeys];
            NSString *key = subKeys[0];
            NSArray *oneDayArr = [NSArray yy_modelArrayWithClass:[CarrotGiftInfo class] json:[obj objectForKey:key]];
            NSString *finallyKey = [PLTimeUtil getDateWithYYMMDD:key];
            [keysList addObject:finallyKey];
            [dataArr addObject:oneDayArr];
        }];
        
        NotifyCoreClient(PurseBillCoreClient, @selector(getCarrotGiftBliiListSuccess:keys:pageNo:code:message:listType:), getCarrotGiftBliiListSuccess:dataArr keys:keysList pageNo:pageNo code:code message:msg listType:type);
    }];
}
@end
