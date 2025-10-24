//
//  HttpRequestHelper+Bill.h
//  BberryCore
//
//  Created by 卫明何 on 2017/9/18.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "HttpRequestHelper.h"
#import "BalanceInfo.h"
#import "RedPageDetailInfo.h"
#import "WithdrawalShowInfo.h"
#import "CPMyAccountInfo.h"

@interface HttpRequestHelper (Bill)

/**
 获取[XCKeyWordTool sharedInstance].xcRedColor页面详情
 */
+ (void)getRedPageDetailInfoSuccess:(void (^)(RedPageDetailInfo *))success
                            failure:(void (^)(NSNumber *, NSString *))failure;


/**
 礼物支出

 @param pageNo 页码
 @param time 时间戳
 @param pageSize 每页的大小
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)getGiftOutBillWithPageNo:(NSInteger)pageNo
                   time:(NSString *)time
               pageSize:(NSInteger)pageSize
                    Success:(void (^)(NSMutableArray *,NSMutableArray *))success
                    failure:(void (^)(NSNumber *, NSString *))failure;


/**
 礼物收入

 @param pageNo 页码
 @param time 时间戳
 @param pageSize 每页大小
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)getGiftInBillWithPageNo:(NSInteger)pageNo
                           time:(NSString *)time
                       pageSize:(NSInteger)pageSize
                        Success:(void (^)(NSMutableArray *,NSMutableArray *))success
                        failure:(void (^)(NSNumber *, NSString *))failure;

/**
 密聊记录
 
 @param pageNo 页码
 @param time 时间戳
 @param pageSize 每页大小
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)getChatBillWithPageNo:(NSInteger)pageNo
                           time:(NSString *)time
                       pageSize:(NSInteger)pageSize
                        Success:(void (^)(NSMutableArray *,NSMutableArray *))success
                        failure:(void (^)(NSNumber *, NSString *))failure;

/**
 充值记录
 
 @param pageNo 页码
 @param time 时间戳
 @param pageSize 每页大小
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)getRechargeBillWithPageNo:(NSInteger)pageNo
                         time:(NSString *)time
                     pageSize:(NSInteger)pageSize
                      Success:(void (^)(NSMutableArray *, NSMutableArray *))success
                      failure:(void (^)(NSNumber *, NSString *))failure;

/**
 getCF记录
 
 @param pageNo 页码
 @param time 时间戳
 @param pageSize 每页大小
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)getWithdrawlBillWithPageNo:(NSInteger)pageNo
                         time:(NSString *)time
                     pageSize:(NSInteger)pageSize
                      Success:(void (^)(NSMutableArray *, NSMutableArray *))success
                      failure:(void (^)(NSNumber *, NSString *))failure;



/**
贵族开通记录
 
 @param pageNo 页码
 @param time 时间戳
 @param pageSize 每页大小
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)getNobleBillWithPageNo:(NSInteger)pageNo
                          time:(NSString *)time
                      pageSize:(NSInteger)pageSize
                       Success:(void(^)(NSMutableArray *arr,NSMutableArray *keys))success
                       failure:(void(^)(NSNumber *resCode,NSString *message))failure;

/**
 [XCKeyWordTool sharedInstance].xcRedColorxcGetCF
 
 @param pageNo 页码
 @param time 时间戳
 @param pageSize 每页大小
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)getRedWithdrawlBillWithPageNo:(NSInteger)pageNo
                                 time:(NSString *)time
                             pageSize:(NSInteger)pageSize
                              Success:(void (^)(NSMutableArray *, NSMutableArray *))success
                              failure:(void (^)(NSNumber *, NSString *))failure;



/**
 [XCKeyWordTool sharedInstance].xcRedColor记录
 
 @param pageNo 页码
 @param date 时间戳
 @param pageSize 每页大小
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)getRedBillWithPageNo:(NSInteger)pageNo
                        date:(NSString *)date
                    pageSize:(NSInteger)pageSize
                     Success:(void (^)(NSMutableArray *, NSMutableArray *))success
                     failure:(void (^)(NSNumber *, NSString *))failure;


/*
 [XCKeyWordTool sharedInstance].xcExchangeMethod码充值
 */
+ (void)requestExchangeCodeRechargeWithCode:(NSString *)code
                                    Success:(void(^)(BalanceInfo *))success
                                    failure:(void(^)(NSNumber *, NSString *))failure;


/*
 getCF记录展示
 */
+ (void)requestExchangeWithdrawalShowInfoSuccess:(void(^)(NSMutableArray *))success
                                    failure:(void(^)(NSNumber *, NSString *))failure;


/**
 CP我的账号金额信息
 */
+ (void)requestCPMyAccountSuccess:(void (^)(CPMyAccountInfo *accountInfo))success failure:(void (^)(NSNumber *code, NSString *message))failure;
/**
 CP我的账号个人金额信息
 */
+ (void)requestCPMyselfAccountSuccess:(void (^)(CPMyAccountInfo *accountInfo))success failure:(void (^)(NSNumber *code, NSString *message))failure;



/**
 cp收入明细
 
 @param pageNum 页码
 @param pageSize 每页大小
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)requestRewardDetailWithPageNum:(NSInteger)pageNum
                       pageSize:(NSInteger)pageSize
                        Success:(void (^)(NSArray *))success
                        failure:(void (^)(NSString *))failure;

/*
 getCF是否
 */
+ (void)requestCPAccountCanDrawal:(void (^)( NSString *message))success failure:(void (^)(NSNumber *code, NSString *message))failure;

@end
