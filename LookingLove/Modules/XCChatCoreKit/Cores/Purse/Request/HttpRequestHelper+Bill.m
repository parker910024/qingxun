//
//  HttpRequestHelper+Bill.m
//  BberryCore
//
//  Created by 卫明何 on 2017/9/18.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "HttpRequestHelper+Bill.h"
#import "AuthCore.h"
#import "NSObject+YYModel.h"
#import "GiftBillInfo.h"
#import "ChatBillInfo.h"
#import "RechargeBillInfo.h"
#import "WithDrawlBillInfo.h"
#import "RedBillInfo.h"
#import "NobleBillInfo.h"
#import "CPMyAccountListInfo.h"

#import "NSString+JsonToDic.h"
#import "YYUtility.h"

#import "PLTimeUtil.h"

@implementation HttpRequestHelper (Bill)

+ (void)getRedPageDetailInfoSuccess:(void (^)(RedPageDetailInfo *))success failure:(void (^)(NSNumber *, NSString *))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *method = @"statpacket/get";
    NSString *uid = [GetCore(AuthCore)getUid];
    NSString *ticket = [GetCore(AuthCore)getTicket];
    if (uid.length > 0) {
        [params setObject:uid forKey:@"uid"];
    }
    
    if (ticket.length > 0) {
        [params setObject:ticket forKey:@"ticket"];
    }
    
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        RedPageDetailInfo *info = [RedPageDetailInfo yy_modelWithJSON:data];
        success(info);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

+ (void)getGiftInBillWithPageNo:(NSInteger)pageNo time:(NSString *)time pageSize:(NSInteger)pageSize Success:(void (^)(NSMutableArray *,NSMutableArray *))success failure:(void (^)(NSNumber *, NSString *))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    //NSString *method = @"personbill/list";
    NSString * method = @"billrecord/get";
    NSString *uid = [GetCore(AuthCore)getUid];
    NSString *ticket = [GetCore(AuthCore)getTicket];
    [params setObject:ticket forKey:@"ticket"];
    
    NSInteger type = 2;
    [params setObject:@(type) forKey:@"type"];
    [params setObject:uid forKey:@"uid"];
    [params setObject:@(pageNo) forKey:@"pageNo"];
    [params setObject:@(pageSize) forKey:@"pageSize"];
    
    if (time.length > 0) {
        [params setObject:time forKey:@"date"];
    }
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        
        NSArray *billList = data[@"billList"];
       // NSInteger pageCount = [data[@"pageCount"] integerValue];
        NSMutableArray *keysList = [NSMutableArray array];
        NSMutableArray *dataArr = [NSMutableArray array];
        for (NSDictionary *item in billList) {
            NSArray *subKeys = [item allKeys];
            NSString *key = subKeys[0];
            NSArray *oneDayArr = [NSArray yy_modelArrayWithClass:[GiftBillInfo class] json:[item objectForKey:key]];
            NSString *finallyKey = [PLTimeUtil getDateWithYYMMDD:key];
            [keysList addObject:finallyKey];
            [dataArr addObject:oneDayArr];
        }
        success(dataArr, keysList);
        
//        NSArray *keys = [data allKeys];
//        NSMutableArray *arr = [NSMutableArray array];
//        NSMutableArray *finallyKeys = [NSMutableArray array];
//        for (NSString *key in keys) {
//            if (![key isEqualToString:@"pageCount"]) {
//                NSArray *tempArr = [NSArray yy_modelArrayWithClass:[GiftBillInfo class] json:[data objectForKey:key]];
//                [arr addObject:[tempArr mutableCopy]];
//                NSString *finallyKey = [PLTimeUtil getDateWithYYMMDD:key];
//                [finallyKeys addObject:finallyKey];
//            }
//        }
//
//
//        success(arr,finallyKeys);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}


+ (void)getGiftOutBillWithPageNo:(NSInteger)pageNo time:(NSString *)time pageSize:(NSInteger)pageSize Success:(void (^)(NSMutableArray *, NSMutableArray *))success failure:(void (^)(NSNumber *, NSString *))failure {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    //NSString *method = @"personbill/list";
    NSString * method = @"billrecord/get";
    NSString *uid = [GetCore(AuthCore)getUid];
    NSInteger type = 1;
    NSString *ticket = [GetCore(AuthCore)getTicket];
    [params setObject:ticket forKey:@"ticket"];
    [params setObject:@(type) forKey:@"type"];
    [params setObject:uid forKey:@"uid"];
    [params setObject:@(pageNo) forKey:@"pageNo"];
    //[params setObject:@(time) forKey:@"date"];
    [params setObject:@(pageSize) forKey:@"pageSize"];
    
    if (time.length > 0) {
        [params setObject:time forKey:@"date"];
    }
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        NSLog(@"%@",data);
        NSArray *billList = data[@"billList"];
        //NSInteger pageCount = [data[@"pageCount"] integerValue];
        NSMutableArray *keysList = [NSMutableArray array];
        NSMutableArray *dataArr = [NSMutableArray array];
        for (NSDictionary *item in billList) {
            NSArray *subKeys = [item allKeys];
            NSString *key = subKeys[0];
            NSArray *oneDayArr = [NSArray yy_modelArrayWithClass:[GiftBillInfo class] json:[item objectForKey:key]];
            NSString *finallyKey = [PLTimeUtil getDateWithYYMMDD:key];
            [keysList addObject:finallyKey];
            [dataArr addObject:oneDayArr];
        }
        success(dataArr, keysList);
        
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

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
                      Success:(void (^)(NSMutableArray *, NSMutableArray *))success
                      failure:(void (^)(NSNumber *, NSString *))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    //NSString *method = @"personbill/list";
    NSString * method = @"billrecord/get";
    NSString *uid = [GetCore(AuthCore)getUid];
    NSInteger type = 3;
    NSString *ticket = [GetCore(AuthCore)getTicket];
    [params setObject:ticket forKey:@"ticket"];
    [params setObject:@(type) forKey:@"type"];
    [params setObject:uid forKey:@"uid"];
    [params setObject:@(pageNo) forKey:@"pageNo"];
    [params setObject:@(pageSize) forKey:@"pageSize"];
    
    if (time.length > 0) {
        [params setObject:time forKey:@"date"];
    }
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        
        NSArray *billList = data[@"billList"];
        NSInteger pageCount = [data[@"pageCount"] integerValue];
        NSMutableArray *keysList = [NSMutableArray array];
        NSMutableArray *dataArr = [NSMutableArray array];
        for (NSDictionary *item in billList) {
            NSArray *subKeys = [item allKeys];
            NSString *key = subKeys[0];
            NSArray *oneDayArr = [NSArray yy_modelArrayWithClass:[ChatBillInfo class] json:[item objectForKey:key]];
            NSString *finallyKey = [PLTimeUtil getDateWithYYMMDD:key];
            [keysList addObject:finallyKey];
            [dataArr addObject:oneDayArr];
        }
        success(dataArr, keysList);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

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
                          failure:(void (^)(NSNumber *, NSString *))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    //NSString *method = @"personbill/list";
    NSString *method = @"billrecord/get";
    NSString *uid = [GetCore(AuthCore)getUid];
    NSString *ticket = [GetCore(AuthCore)getTicket];
    [params setObject:ticket forKey:@"ticket"];
    NSInteger type = 4;
    [params setObject:@(type) forKey:@"type"];
    [params setObject:uid forKey:@"uid"];
    [params setObject:@(pageNo) forKey:@"pageNo"];
    [params setObject:@(pageSize) forKey:@"pageSize"];
    
    if (time.length > 0) {
        [params setObject:time forKey:@"date"];
    }
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        
        NSArray *billList = data[@"billList"];
        NSInteger pageCount = [data[@"pageCount"] integerValue];
        NSMutableArray *keysList = [NSMutableArray array];
        NSMutableArray *dataArr = [NSMutableArray array];
        for (NSDictionary *item in billList) {
            NSArray *subKeys = [item allKeys];
            NSString *key = subKeys[0];
            NSArray *oneDayArr = [NSArray yy_modelArrayWithClass:[RechargeBillInfo class] json:[item objectForKey:key]];
            NSString *finallyKey = [PLTimeUtil getDateWithYYMMDD:key];
            [keysList addObject:finallyKey];
            [dataArr addObject:oneDayArr];
        }
        success(dataArr, keysList);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

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
                           failure:(void (^)(NSNumber *, NSString *))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
   // NSString *method = @"personbill/list";
    NSString *method = @"billrecord/get";
    NSString *uid = [GetCore(AuthCore)getUid];
    NSInteger type = 5;
    NSString *ticket = [GetCore(AuthCore)getTicket];
    [params setObject:ticket forKey:@"ticket"];
    [params setObject:@(type) forKey:@"type"];
    [params setObject:uid forKey:@"uid"];
    [params setObject:@(pageNo) forKey:@"pageNo"];
    [params setObject:@(pageSize) forKey:@"pageSize"];
    
    if (time > 0) {
        [params setObject:time forKey:@"date"];
    }
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        
        NSArray *billList = data[@"billList"];
        NSInteger pageCount = [data[@"pageCount"] integerValue];
        NSMutableArray *keysList = [NSMutableArray array];
        NSMutableArray *dataArr = [NSMutableArray array];
        for (NSDictionary *item in billList) {
            NSArray *subKeys = [item allKeys];
            NSString *key = subKeys[0];
            NSArray *oneDayArr = [NSArray yy_modelArrayWithClass:[WithDrawlBillInfo class] json:[item objectForKey:key]];
            NSString *finallyKey = [PLTimeUtil getDateWithYYMMDD:key];
            [keysList addObject:finallyKey];
            [dataArr addObject:oneDayArr];
        }
        success(dataArr, keysList);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}



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
                       failure:(void(^)(NSNumber *resCode,NSString *message))failure{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString * method = @"noble/record/get";
    NSString *uid = [GetCore(AuthCore)getUid];
    NSString *ticket = [GetCore(AuthCore)getTicket];
    [params setObject:uid forKey:@"uid"];
    [params setObject:ticket forKey:@"ticket"];
    [params setObject:@(pageNo) forKey:@"pageNo"];
    [params setObject:@(pageSize) forKey:@"pageSize"];
    
    if (time > 0) {
        [params setObject:time forKey:@"date"];
    }
    [HttpRequestHelper GET:method params:params success:^(id data) {
        NSArray * billList = data[@"billList"];
        NSMutableArray *keysList = [NSMutableArray array];
        NSMutableArray *dataArr = [NSMutableArray array];
        for (NSDictionary *item in billList) {
            NSArray *subKeys = [item allKeys];
            NSString *key = subKeys[0];
            NSArray *oneDayArr = [NSArray yy_modelArrayWithClass:[NobleBillInfo class] json:[item objectForKey:key]];
            NSString *finallyKey = [PLTimeUtil getDateWithYYMMDD:key];
            [keysList addObject:finallyKey];
            [dataArr addObject:oneDayArr];
        }
        success(dataArr, keysList);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
    
}




/*
 [XCKeyWordTool sharedInstance].xcRedColor
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
                           failure:(void (^)(NSNumber *, NSString *))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    // NSString *method = @"personbill/list";
    NSString *method = @"packetrecord/deposit";
    NSString *uid = [GetCore(AuthCore)getUid];
    //NSInteger type = 5;
    NSString *ticket = [GetCore(AuthCore)getTicket];
    [params setObject:ticket forKey:@"ticket"];
    //[params setObject:@(type) forKey:@"type"];
    [params setObject:uid forKey:@"uid"];
    [params setObject:@(pageNo) forKey:@"pageNo"];
    [params setObject:@(pageSize) forKey:@"pageSize"];
    
    if (time > 0) {
        [params setObject:time forKey:@"date"];
    }
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        
        NSArray *billList = data[@"billList"];
        NSInteger pageCount = [data[@"pageCount"] integerValue];
        NSMutableArray *keysList = [NSMutableArray array];
        NSMutableArray *dataArr = [NSMutableArray array];
        for (NSDictionary *item in billList) {
            NSArray *subKeys = [item allKeys];
            NSString *key = subKeys[0];
            NSArray *oneDayArr = [NSArray yy_modelArrayWithClass:[RedBillInfo class] json:[item objectForKey:key]];
            NSString *finallyKey = [PLTimeUtil getDateWithYYMMDD:key];
            [keysList addObject:finallyKey];
            [dataArr addObject:oneDayArr];
        }
        success(dataArr, keysList);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}




/**
 [XCKeyWordTool sharedInstance].xcRedColor记录
 
 @param pageNo 页码
 @param time 时间戳
@param pageSize 每页大小
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)getRedBillWithPageNo:(NSInteger)pageNo
                        date:(NSString *)date
                    pageSize:(NSInteger)pageSize
                     Success:(void (^)(NSMutableArray *, NSMutableArray *))success
                     failure:(void (^)(NSNumber *, NSString *))failure {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //NSString *method = @"personbill/redpacket";
    NSString *method = @"packetrecord/get";
    NSString *uid = [GetCore(AuthCore)getUid];
    //NSInteger type = 2;
    NSString *ticket = [GetCore(AuthCore)getTicket];
    [params setObject:ticket forKey:@"ticket"];
    //[params setObject:@(type) forKey:@"type"];
    [params setObject:uid forKey:@"uid"];
    [params setObject:@(pageNo) forKey:@"pageNo"];
    [params setObject:@(pageSize) forKey:@"pageSize"];
    
    if (date > 0) {
         [params setObject:date forKey:@"date"];
    }
    [HttpRequestHelper GET:method params:params success:^(id data) {
        NSArray *billList = data[@"billList"];
        //NSArray * billList = data;
        //NSLog(@"数据啊：%@",[billList objectAtIndex:0]);
        //id bill = [billList objectAtIndex:0];
        //NSInteger pageCount = [data[@"pageCount"] integerValue];
        NSMutableArray *keysList = [NSMutableArray array];
        NSMutableArray *dataArr = [NSMutableArray array];
        for (NSDictionary *item in billList) {
            NSArray *subKeys = [item allKeys];
            NSString *key = subKeys[0];
            NSArray *oneDayArr = [NSArray yy_modelArrayWithClass:[RedBillInfo class] json:[item objectForKey:key]];
            NSString *finallyKey = [PLTimeUtil getDateWithYYMMDD:key];
            
            if (finallyKey != nil) {
                [keysList addObject:finallyKey];
            }
            
            if (oneDayArr != nil) {
                [dataArr addObject:oneDayArr];
            }
            
        }
        success(dataArr, keysList);
    } failure:^(NSNumber *resCode, NSString *message) {

    }];
    
}

/*
 [XCKeyWordTool sharedInstance].xcExchangeMethod码充值
 */
+ (void)requestExchangeCodeRechargeWithCode:(NSString *)code
                                    Success:(void(^)(BalanceInfo *))success
                                    failure:(void(^)(NSNumber *, NSString *))failure{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    NSString * method = @"redeemcode/use";
    NSString * uid = [GetCore(AuthCore) getUid];
    NSString *ticket = [GetCore(AuthCore)getTicket];
    [params setObject:code forKey:@"code"];
    [params setObject:uid forKey:@"uid"];
    [params setObject:ticket forKey:@"ticket"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
            //NSString * goldNum = data;
        BalanceInfo * balanceInfo = [BalanceInfo yy_modelWithJSON:data];
        success(balanceInfo);
    } failure:^(NSNumber *resCode, NSString *message) {
        //failure(message);
        failure(resCode,message);
    }];
    
}

/*
 
 */
+ (void)requestExchangeWithdrawalShowInfoSuccess:(void (^)(NSMutableArray *))success failure:(void (^)(NSNumber *, NSString *))failure{
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    NSString * method = @"redpacket/drawlist";
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        NSArray * array = [NSArray yy_modelArrayWithClass:[WithdrawalShowInfo class] json:data];
        NSMutableArray * showInfoList = [array mutableCopy];
        success(showInfoList);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode,message);
    }];
}

/**
 CP我的账号共同金额信息
 */
+ (void)requestCPMyAccountSuccess:(void (^)(CPMyAccountInfo *accountInfo))success failure:(void (^)(NSNumber *code, NSString *message))failure{
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    NSString * method = @"user/myAccount";
    NSString * uid = [GetCore(AuthCore) getUid];
    [params setObject:uid forKey:@"uid"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        CPMyAccountInfo * accountInfo = [CPMyAccountInfo yy_modelWithDictionary:data];
        success(accountInfo);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode,message);
    }];
}
/**
 CP我的个人账号信息
 */
+ (void)requestCPMyselfAccountSuccess:(void (^)(CPMyAccountInfo *accountInfo))success failure:(void (^)(NSNumber *code, NSString *message))failure{
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    NSString * method = @"users/account/balance";
    NSString * uid = [GetCore(AuthCore) getUid];
    [params setObject:uid forKey:@"uid"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        CPMyAccountInfo * accountInfo = [CPMyAccountInfo yy_modelWithDictionary:data];
        success(accountInfo);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode,message);
    }];
}


+ (void)requestRewardDetailWithPageNum:(NSInteger)pageNum
                          pageSize:(NSInteger)pageSize
                           Success:(void (^)(NSArray *))success
                           failure:(void (^)(NSString *))failure{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    NSString * method = @"reward/detail";
    NSString * uid = [GetCore(AuthCore) getUid];
    [params setObject:uid forKey:@"uid"];
    [params setObject:@(pageNum) forKey:@"pageNum"];
    [params setObject:@(pageSize) forKey:@"pageSize"];

    [HttpRequestHelper GET:method params:params success:^(id data) {
        NSArray * array = [NSArray yy_modelArrayWithClass:[CPMyAccountListInfo class] json:data];
        success(array);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(message);
    }];
    
}

+ (void)requestCPAccountCanDrawal:(void (^)( NSString *message))success failure:(void (^)(NSNumber *code, NSString *message))failure{
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    NSString * method = @"user/withdraw";
    NSString * uid = [GetCore(AuthCore) getUid];
    [params setObject:uid forKey:@"uid"];
    [params setObject:@"30" forKey:@"money"];

    [HttpRequestHelper POST:method params:params success:^(id data) {
        success([data objectForKey:@"desc"]);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode,message);
    }];
}

@end
