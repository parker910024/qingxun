//
//  HttpRequestHelper+Recharge.h
//  BberryCore
//
//  Created by chenran on 2017/7/1.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "HttpRequestHelper.h"
#import "RechargeInfo.h"
#import "BalanceInfo.h"
#import "WithDrawalInfo.h"
#import "ZXCInfo.h"
#import "PurseCore.h"

@interface HttpRequestHelper (Purse)

#pragma mark - 支付

/**
 获取充值产品列表
 
 @param success 成功
 @param failure 失败
 */
+(void)requestChargeListWith:(IAPChannelType)channelType
                     success:(void (^)(NSArray *rechargeInfo))success
                     failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 充值
 
 @param chargeProdId 产品id
 @param channel 渠道
 @param success 成功
 @param failure 失败
 */
+ (void)requestApplyRecharge:(NSString *)chargeProdId channel:(NSString *)channel
                     success:(void (^)(NSObject* charge))success
                     failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 苹果内购下单（服务端）
 
 @param chargeProdId 内购商品ID
 @param success 成功
 @param failure 失败
 */
+ (void)requestInAppRechargeWithChargeProdId:(NSString *)chargeProdId
                                     success:(void (^)(BOOL , NSString *))success
                                     failure:(void (^)(NSNumber *, NSString *))failure;

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
                                  success:(void (^)(BOOL , NSString *))success
                                  failure:(void (^)(NSNumber *, NSString *))failure;

/**
 苹果内购二次验证
 
 @param jsonData 购买成功同步返回的收据数据
 @param success 成功
 @param failure 失败
 */
+ (void)checkReceiptWithData:(NSData *)jsonData
                     orderID:(NSString *)orderID
               transcationId:(NSString *)transcationId
                     success:(void (^)(NSString *orderStatus))success
                     failure:(void(^)(NSNumber *resCode, NSString *message))failure;


/**
 二次扫描未验证通过的订单
 @param transcationIds transcationIds
 @param success 成功
 @param failure 失败
 */
+ (void)requestCheckTranscationIds:(NSString *)transcationIds
                           success:(void (^)(BOOL res))success
                           failure:(void (^)(NSNumber *resCode, NSString *message))failure;










/**
 萌声  KTV 版本 修改 统一 短信验证获取
 
 获取短信验证码
 
 @param mobileNum 手机号码
 @param type 短信类型(1、注册短信 2、登录短信 3、找回/修改密码 4、绑定手机 5、绑定xczAccount 6、验证绑定手机 7、xcz密码验证手机)
 @param success 成功
 @param failure 失败
 */
+ (void)getCodeWithMobileNum:(NSString *)mobileNum type:(NSInteger)type Success:(void (^)(BOOL))success failure:(void (^)(NSNumber *, NSString *))failure;

/**
 发起xcGetCF申请
 
 @param drawalsID getCF ID
 */

+ (void)requestRedWithdrawals:(NSString *)drawalsID
                   paymentPwd:(NSString *)paymentPwd
                      success:(void (^)(BOOL, NSString *))success
                      failure:(void (^)(NSNumber *, NSString *))failure;

/**
 获取[XCKeyWordTool sharedInstance].xcRedColor列表
 
 @param success 成功
 @param failure 失败
 */
+ (void)requestRedWithdrawalsListSuccess:(void (^)(NSArray *list))success failure:(void (^)(NSNumber *, NSString *))failure;
/**
 通过手机号获取验证码

 @param phoneNum 手机号
 @param success 成功
 @param failure 失败
 */
+ (void)getCodeWithPhoneNum:(NSString *)phoneNum
                    Success:(void (^)(BOOL))success
                    failure:(void (^)(NSNumber *, NSString *))failure;

/**
 绑定手机号

 @param phoneNum 手机号
 @param success 成功
 @param failure 失败
 */
+ (void)bindingPhoneNumber:(NSString *)phoneNum
                verifyCode:(NSString *)verifyCode
                   Success:(void (^)(BOOL))success
                   failure:(void (^)(NSNumber *, NSString *))failure;


/**
 获取手机验证码

 @param type 类型
 @param success 成功
 @param failure 失败
 */
+ (void)getMsmWithType:(NSInteger)type
               Success:(void (^)(BOOL, NSString *))success
               failure:(void (^)(NSNumber *, NSString *))failure;

/**
 获取绑定 xczAccount 手机号验证码 目前只适用哈哈
 */
+ (void)getPayMsmWithSuccess:(void (^)(BOOL, NSString *))success failure:(void (^)(NSNumber *, NSString *))failure ;



/**
 //20180912获取手机验证码 业务类型，必填，1注册，2登录，3重设密码，4绑定手机，5绑定xczAccount，6重设xcz密码，7解绑手机(验证已绑定手机)

 @param type 类型
 @param success 成功
 @param failure 失败
 */
+ (void)getPhoneMsmCode:(NSString *)phoneNum type:(NSInteger)type Success:(void (^)(BOOL, NSString *))success failure:(void (^)(NSNumber *, NSString *))failure;

/**
 获取短信验证码
 
 @param mobileNum 手机号码
 @param type 短信类型(1、注册短信 2、登录短信 3、找回/修改密码 4、绑定手机 5、绑定xczAccount 6、验证绑定手机)
 @param checkExists 是否需要校验 手机号码是否已被绑定
 @param success 成功
 @param failure 失败
 */
+ (void)getCodeWithMobileNum:(NSString *)mobileNum type:(NSInteger)type isCheckExists:(BOOL)checkExists Success:(void (^)(BOOL))success failure:(void (^)(NSNumber *, NSString *))failure;



/**
 校验手机验证码接口

 @param mobile 手机号码
 @param code 验证码
 @param success 成功
 @param failure 失败
 */
+ (void)checkMobileCodeWithMobile:(NSString *)mobile code:(NSString *)code Success:(void (^)(BOOL))success failure:(void (^)(NSNumber *, NSString *))failure;




/**
 查询列表

 @param success 成功
 @param failure 失败
 */
+ (void)requestWithdrawalsListSuccess:(void (^)(NSArray<WithDrawalInfo *> *data))success
                              failure:(void(^)(NSNumber *resCode, NSString *message))failure;

/**
 查询xczAccount信息 如果没有即为空

 @param success 成功
 @param failure 失败
 */
+ (void)requestZXCInforequestZXCInfoSuccess:(void (^)(ZXCInfo *data))success
                                    failure:(void(^)(NSNumber *resCode, NSString *message))failure;


/**
 xcCF转萌币

 @param cornNumber 萌币数
 @param paymentPwd 二级密码
 @param success 成功
 @param failure 失败
 */
+(void)requestExchangeCorn:(NSInteger)cornNumber
                paymentPwd:(NSString *)paymentPwd
                   success:(void (^)(BalanceInfo *data))success failure:(void(^)(NSNumber *resCode, NSString *message))failure;

/**
 绑定xczAccount

 @param account 账户
 @param accountName 用户真实姓名
 @param verifyCode 验证码
 @param success 成功
 @param failure 失败
 */

+ (void)bindingZXCWithZXCAccount:(NSString *)account
                    accountName:(NSString *)accountName
                    verifyCode:(NSString *)verifyCode
                        success:(void (^)(BOOL success))success
                        failure:(void(^)(NSNumber *resCode, NSString *message))failure;


/**
 发起申请

 @param drawalsID getCF ID
 @param paymentPwd 二级密码
 */
+ (void)requestWithdrawals:(NSString *)drawalsID
                paymentPwd:(NSString *)paymentPwd
                   success:(void (^)(BOOL withdrawalsStatus, NSString *leftDiamond))success
                   failure:(void(^)(NSNumber *resCode, NSString *message))failure;




/**
 获余额信息

 @param uid 用户ui
 @param success 成功
 @param failure 失败
 */
+ (void)requestBalanceInfo:(UserID)uid
                   success:(void (^)(BalanceInfo* balance))success
                   failure:(void (^)(NSNumber *resCode, NSString *message))failure;



@end
