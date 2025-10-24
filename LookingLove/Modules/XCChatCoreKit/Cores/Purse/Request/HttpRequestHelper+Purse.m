//
//  HttpRequestHelper+Recharge.m
//  BberryCore
//
//  Created by chenran on 2017/7/1.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "HttpRequestHelper+Purse.h"
#import "GTMBase64.h"
#import "AuthCore.h"
#import "RedWithdrawalsListInfo.h"
#import "DESEncrypt.h"
@implementation HttpRequestHelper (Purse)
/**
 萌声  KTV 版本 修改 统一 短信验证获取
 
获取短信验证码

@param mobileNum 手机号码
@param type 短信类型(1、注册短信 2、登录短信 3、找回/修改密码 4、绑定手机 5、绑定xczAccount 6、验证绑定手机 7、xcz密码验证手机)
@param success 成功
@param failure 失败
*/
+ (void)getCodeWithMobileNum:(NSString *)mobileNum type:(NSInteger)type Success:(void (^)(BOOL))success failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"sms/getCode";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:mobileNum forKey:@"mobile"];
    NSString *uid = [GetCore(AuthCore) getUid];
    [params setObject:uid forKey:@"uid"];
    [params setObject:@(type) forKey:@"type"];
    NSString *ticket = [GetCore(AuthCore) getTicket];
    [params setObject:ticket forKey:@"ticket"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success(YES);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode,message);
    }];
}

+ (void)requestRedWithdrawals:(NSString *)drawalsID paymentPwd:(NSString *)paymentPwd success:(void (^)(BOOL, NSString *))success failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"redpacket/withdraw";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:drawalsID forKey:@"packetId"];
    NSString *ticket = [GetCore(AuthCore)getTicket];
    NSString *uid = [GetCore(AuthCore)getUid];
    [params setObject:ticket forKey:@"ticket"];
    [params setObject:uid forKey:@"uid"];
    [params setObject:[DESEncrypt encryptUseDES:paymentPwd key:keyWithType(KeyType_PwdEncode, NO)] forKey:@"paymentPwd"];
    
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        NSString *packetNum = [NSString stringWithFormat:@"%@",data[@"packetNum"]];
        success(YES, packetNum);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

+ (void)requestRedWithdrawalsListSuccess:(void (^)(NSArray *))success failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"redpacket/list";
    
    [HttpRequestHelper GET:method params:nil success:^(id data) {
//        NSArray *list = [NSArray yy_modelArrayWithClass:[RedWithdrawalsListInfo class] json:data];
        NSArray *list = [RedWithdrawalsListInfo modelsWithArray:data];
        success(list);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

+ (void)requestChargeListWith:(IAPChannelType)channelType success:(void (^)(NSArray *))success failure:(void (^)(NSNumber *, NSString *))failure
{
    NSString *method = @"chargeprod/list";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(channelType) forKey:@"channelType"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {

        NSArray *rechargeList = [RechargeInfo modelsWithArray:data];
        success(rechargeList);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+ (void)requestApplyRecharge:(NSString *)chargeProdId channel:(NSString *)channel success:(void (^)(NSObject *))success failure:(void (^)(NSNumber *, NSString *))failure
{
    NSString *method = @"charge/apply";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString* uid = [GetCore(AuthCore) getUid];
    NSString *ticket = [GetCore(AuthCore) getTicket];
    [params setObject:ticket forKey:@"ticket"];
    [params setObject:uid forKey:@"uid"];
    [params setObject:chargeProdId forKey:@"chargeProdId"];
    [params setObject:channel forKey:@"payChannel"];
    [params setObject:[YYUtility ipAddress] forKey:@"clientIp"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success(data);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+ (void)requestBalanceInfo:(UserID)uid success:(void (^)(BalanceInfo *))success failure:(void (^)(NSNumber *, NSString *))failure
{
    NSString *method = @"purse/query";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *ticket = [GetCore(AuthCore) getTicket];
    [params setObject:ticket forKey:@"ticket"];
    [params setObject:@(uid) forKey:@"uid"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {

        BalanceInfo *balanceInfo = [BalanceInfo modelWithJSON:data];
        success(balanceInfo);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+ (void)checkReceiptWithData:(NSData *)jsonData
                     orderID:(NSString *)orderID
               transcationId:(NSString *)transcationId
                     success:(void (^)(NSString *))success
                     failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *receiptBase64 = [[NSString alloc] initWithData:[GTMBase64 encodeData:jsonData] encoding:NSUTF8StringEncoding];
    
    NSString *method = @"verify/setiap";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *uid = [GetCore(AuthCore) getUid];
    NSString *ticket = [GetCore(AuthCore) getTicket];
    [params setObject:receiptBase64 forKey:@"receipt"];
    [params setObject:@"true" forKey:@"chooseEnv"];
    [params safeSetObject:orderID forKey:@"chargeRecordId"];
    [params safeSetObject:transcationId forKey:@"transcationId"];
    [params setObject:uid forKey:@"uid"];
    [params setObject:ticket forKey:@"ticket"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success(data);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}


//内购下单
+ (void)requestInAppRechargeWithChargeProdId:(NSString *)chargeProdId success:(void (^)(BOOL , NSString *))success failure:(void (^)(NSNumber *, NSString *))failure {
    
    [self requestInAppRechargeWithAppleType:ApplyRechargeType_IAP appProductId:chargeProdId serverProductdId:nil shopProductType:0 success:success failure:failure];
}

/**
 苹果下单
 
 @param applyType
 @param appProductId   苹果产品id
 @param serverProductdId  服务端产品id(applyType为shop时传)
 @param shopProductType  商城类型(applyType为shop时传)
 @param success 成功
 @param failure 失败
 */
+ (void)requestInAppRechargeWithAppleType:(ApplyRechargeType)appleType
                             appProductId:(NSString *)appProductId
                         serverProductdId:(NSString *)serverProductdId
                          shopProductType:(ShopProductType)shopProductType
                                  success:(void (^)(BOOL, NSString *))success
                                  failure:(void (^)(NSNumber *, NSString *))failure{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *method = @"order/placeV2";
    if (projectType() == ProjectType_MengSheng || projectType() == ProjectType_BB ) {
        method = @"order/place";
    }
    
    if (appleType == ApplyRechargeType_Shop) {
        method = @"order/place_shop";
        [params setObject:serverProductdId forKey:@"productId"];
        [params setObject:@(shopProductType) forKey:@"productType"];
    }
    [params setObject:[GetCore(AuthCore) getTicket] forKey:@"ticket"];
    [params setObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params setObject:appProductId forKey:@"chargeProdId"];
    [params setObject:[YYUtility ipAddress] forKey:@"clientIp"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        NSString *orderid = (NSString *)data[@"recordId"];
        success(YES,orderid);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
    
}

//申请
+ (void)requestWithdrawals:(NSString *)drawalsID paymentPwd:(NSString *)paymentPwd success:(void (^)(BOOL, NSString *))success failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"withDraw/withDrawCash";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString* uid = [GetCore(AuthCore) getUid];
    NSString *ticket = [GetCore(AuthCore) getTicket];
    [params setObject:ticket forKey:@"ticket"];
    [params setObject:drawalsID forKey:@"pid"];
    [params setObject:uid forKey:@"uid"];
    [params setObject:[DESEncrypt encryptUseDES:paymentPwd key:keyWithType(KeyType_PwdEncode, NO)] forKey:@"paymentPwd"];
    
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        NSString *left = (NSString *)data[@"diamondNum"];
        success(data,left);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

//绑定xczAccount
+ (void)bindingZXCWithZXCAccount:(NSString *)account accountName:(NSString *)accountName verifyCode:(NSString *)verifyCode success:(void (^)(BOOL))success failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"withDraw/bound2";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString* uid = [GetCore(AuthCore) getUid];
    NSString *ticket = [GetCore(AuthCore) getTicket];
    
    [params setObject:ticket forKey:@"ticket"];
    [params setObject:verifyCode forKey:@"code"];
    [params setObject:account forKey:@"zxcAccount"];
    [params setObject:accountName forKey:@"zxcAccountName"];
    [params setObject:uid forKey:@"uid"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {

        success(data);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

//请求列表
+ (void)requestWithdrawalsListSuccess:(void (^)(NSArray<WithDrawalInfo *> *))success failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"withDraw/findList";
    [HttpRequestHelper GET:method params:nil success:^(id data) {
//        NSArray *drawalList = [NSArray yy_modelArrayWithClass:[WithDrawalInfo class] json:data];
        NSArray *drawalList = [WithDrawalInfo modelsWithArray:data];
        success(drawalList);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

+(void)requestExchangeCorn:(NSInteger)cornNumber paymentPwd:(NSString *)paymentPwd success:(void (^)(BalanceInfo *data))success failure:(void(^)(NSNumber *resCode, NSString *message))failure {
    NSString *method = @"change/gold";
    NSString *ticket = [GetCore(AuthCore) getTicket];
    NSString *uid = [GetCore(AuthCore) getUid];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:uid forKey:@"uid"];
    [params setObject:ticket forKey:@"ticket"];
    [params setObject:@(cornNumber) forKey:@"diamondNum"];
    [params setObject:[DESEncrypt encryptUseDES:paymentPwd key:keyWithType(KeyType_PwdEncode, NO)] forKey:@"paymentPwd"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
//        BalanceInfo *info = [BalanceInfo yy_modelWithJSON:data];
        BalanceInfo *info = [BalanceInfo modelWithJSON:data];
        success(info);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode,message);
    }];
}

//请求xczAccount信息

+ (void)requestZXCInforequestZXCInfoSuccess:(void (^)(ZXCInfo *data))success failure:(void(^)(NSNumber *resCode, NSString *message))failure {
    NSString *method = @"withDraw/exchange2";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *uid = [GetCore(AuthCore) getUid];
    [params setObject:uid forKey:@"uid"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
//        ZXCInfo *info = [ZXCInfo yy_modelWithJSON:data];
        ZXCInfo *info = [ZXCInfo modelWithJSON:data];

        success(info);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

//获取手机验证码
+ (void)getMsmWithType:(NSInteger)type Success:(void (^)(BOOL, NSString *))success failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"withDraw/getSms";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *uid = [GetCore(AuthCore) getUid];
    [params setObject:uid forKey:@"uid"];
    [params setObject:[GetCore(AuthCore)getTicket] forKey:@"ticket"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        NSString *msg = data[@"message"];
        success(YES,msg);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

//获取xczAccount手机验证码 目前只适用哈哈 耳伴
+ (void)getPayMsmWithSuccess:(void (^)(BOOL, NSString *))success failure:(void (^)(NSNumber *, NSString *))failure{
    NSString *method = @"withDraw/verification/code";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *uid = [GetCore(AuthCore) getUid];
    [params setObject:uid forKey:@"uid"];
    [params setObject:[GetCore(AuthCore)getTicket] forKey:@"ticket"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        NSString *msg = data[@"message"];
        success(YES,msg);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

//20180912获取手机验证码 业务类型，必填，1注册，2登录，3重设密码，4绑定手机，5绑定xczAccount，6重设xcz密码，7解绑手机
+ (void)getPhoneMsmCode:(NSString *)phoneNum type:(NSInteger)type Success:(void (^)(BOOL, NSString *))success failure:(void (^)(NSNumber *, NSString *))failure{
    NSString *method = @"sms/code";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *uid = [GetCore(AuthCore) getUid];
    [params safeSetObject:@(type) forKey:@"type"];
    [params safeSetObject:uid forKey:@"uid"];
    [params safeSetObject:phoneNum forKey:@"phone"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        NSString *msg = data[@"message"];
        success(YES,msg);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

//通过手机号获取验证码
+ (void)getCodeWithPhoneNum:(NSString *)phoneNum Success:(void (^)(BOOL))success failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"withDraw/phoneCode";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:phoneNum forKey:@"phone"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success(YES);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode,message);
    }];
}




/**
 获取短信验证码

 @param mobileNum 手机号码
 @param type 类型
 @param checkExists 是否需要校验 手机号码是否已被绑定
 @param success 成功
 @param failure 失败
 */
+ (void)getCodeWithMobileNum:(NSString *)mobileNum type:(NSInteger)type isCheckExists:(BOOL)checkExists Success:(void (^)(BOOL))success failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"sms/getCode";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:mobileNum forKey:@"mobile"];
    [params setObject:@(checkExists) forKey:@"checkExists"];
    NSString *uid = [GetCore(AuthCore) getUid];
    [params setObject:uid forKey:@"uid"];
    [params setObject:@(type) forKey:@"type"];
    NSString *ticket = [GetCore(AuthCore) getTicket];
    [params setObject:ticket forKey:@"ticket"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success(YES);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode,message);
    }];
}



/**
 校验手机验证码接口
 
 @param mobile 手机号码
 @param code 验证码
 @param success 成功
 @param failure 失败
 */
+ (void)checkMobileCodeWithMobile:(NSString *)mobile code:(NSString *)code Success:(void (^)(BOOL))success failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"sms/verify";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:mobile forKey:@"mobile"];
    [params setObject:code forKey:@"code"];
    NSString *uid = [GetCore(AuthCore) getUid];
    [params setObject:uid forKey:@"uid"];
    NSString *ticket = [GetCore(AuthCore) getTicket];
    [params setObject:ticket forKey:@"ticket"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success(YES);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode,message);
    }];
}




//绑定手机
+ (void)bindingPhoneNumber:(NSString *)phoneNum verifyCode:(NSString *)verifyCode Success:(void (^)(BOOL))success failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"withDraw/phone";
    NSString *ticket = [GetCore(AuthCore) getTicket];
    NSString *uid = [GetCore(AuthCore) getUid];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:uid forKey:@"uid"];
    [params setObject:ticket forKey:@"ticket"];
    [params setObject:phoneNum forKey:@"phone"];
    [params setObject:verifyCode forKey:@"code"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success(YES);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode,message);
    }];

}

//二次扫描未验证通过的订单
+ (void)requestCheckTranscationIds:(NSString *)transcationIds success:(void (^)(BOOL res))success failure:(void (^)(NSNumber *, NSString *))failure{
    
    NSString *method = @"verify/checkIOSChargeRecord";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:transcationIds forKey:@"transcationId"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success(YES);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode,message);
    }];
}

@end

