//
//  RechargeCore.h
//  BberryCore
//
//  Created by chenran on 2017/7/1.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "BaseCore.h"
#import "BalanceInfo.h"
#import "CarrotWallet.h"


typedef enum : NSUInteger {
    IAPChannelType_TT = 4,
    IAPChannelType_BB = 5,
    IAPChannelType_HHPlay = 6,
    IAPChannelType_MSYY = 7, //2019.3.12最新萌声
    IAPChannelType_LookingLove = 8, //轻寻
    IAPChannelType_Planet = 9, //hello处CP
    IAPChannelType_Other = 3,
} IAPChannelType;


@interface PurseCore : BaseCore

@property (nonatomic, strong) CarrotWallet *carrotWallet; // 萝卜钱包
@property(nonatomic, strong)BalanceInfo *balanceInfo;
@property (nonatomic,assign) double exchangeGoldRate;
@property (nonatomic, strong) NSDictionary * taxDic;//xcGetCF的时候税率
@property (assign , nonatomic) int minDisplayCount;//显示最小金额
/**
 兼容方法，默认channelType为3
 */
- (void)requestRechargeList;

/**
 请求充值产品新方法，channelType需要另外传
 */
- (void)requestRechargeListWithChannelType:(IAPChannelType)channelType;
/**
 iap channel参数已作废
 */
- (void)requestApplyRecharge:(NSString *)chargeProdId channel:(NSString *)channel;

- (void)requestBalanceInfo:(UserID)uid;
- (void)requestRedWithdrawalsList; //[XCKeyWordTool sharedInstance].xcRedColor列表
- (void)requestExchangeCorn:(NSInteger)cornNumber;
- (void)requestCheckTranscationIds;//验证transcation
- (void)requestUserIsFirstRecharge; // 用户是否第一次充值

/**
 苹果支付

 @param applyType
 @param appProductId   苹果产品id
 @param serverProductdId  服务端产品id(applyType为shop时传)
 @param shopProductType  商城类型(applyType为shop时传)
 */
- (void)requestApplyRecharge:(ApplyRechargeType)applyType
                appProductId:(NSString *)appProductId
            serverProductdId:(NSString *)serverProductdId
             shopProductType:(ShopProductType)shopProductType;


/**
 萌声  KTV 版本 修改 统一 短信验证获取
 
 获取短信验证码
 
 @param mobileNum 手机号码
 @param type 短信类型(1、注册短信 2、登录短信 3、找回/修改密码 4、绑定手机 5、绑定xczAccount 6、验证绑定手机 7、xcz密码验证手机)
 */
- (void)getCodeWithMobileNum:(NSString *)mobileNum type:(NSInteger)type;

/**
 获取验证码
 */
- (void)getSmsWithType:(NSInteger)type;

/**
 货币[XCKeyWordTool sharedInstance].xcExchangeMethod

 @param cornNumber [XCKeyWordTool sharedInstance].xcExchangeMethod的额度
 @param paymentPwd 二级密码
 */
- (void)requestExchangeCorn:(NSInteger)cornNumber paymentPwd:(NSString *)paymentPwd;
/**
 绑定手机号

 @param phoneNum 手机号
 */
- (void)bindingPhoneNum:(NSString *)phoneNum verifyCode:(NSString *)verifyCode;

/**
 通过手机号获取验证码

 @param phoneNum 手机号
 */
- (void)getCodeWithPhoneNum:(NSString *)phoneNum;

/**
 获取验证码
 */
- (void)getSmsWithType:(NSInteger)type;

/**
 获取xczAccount手机验证码 目前只适用哈哈
 */
- (void)getPaySms;

/**
 //20180912获取手机验证码
 
 @param phoneNum 手机
 @param type 类型 必填，1注册，2登录，3重设密码，4绑定手机，5绑定xczAccount，6重设xcz密码，7解绑手机
 */
- (void)getCodeWithPhoneNum:(NSString *)phoneNum type:(NSInteger)type;
/**
 通过手机获取验证码
 
 @param moblie 手机
 @param type 短信类型(1、注册短信 2、登录短信 3、找回/修改密码 4、绑定手机 5、绑定xczAccount 6、验证绑定手机)
 @param checkExits 是否校验手机 已绑定过
 */
- (void)getMoblieCodeWithMoblieNum:(NSString *)moblie type:(NSInteger)type isCheckExits:(BOOL)checkExits;

/**
 校验手机验证码接口
 
 @param moblieNum 手机号码
 @param code 验证码
 */
- (void)checkMoblieCodeWithMoblie:(NSString *)moblieNum code:(NSString *)code;

/**
 绑定xczAccount

 @param account 账号
 @param accountName 用户名
 */

- (void)bindingZXCWithAccount:(NSString *)account accountName:(NSString *)accountName verifyCode:(NSString *)verifyCode;




/**
 查询并且购买内购商品

 @param productID 服务器返回的productID
 */
- (void)requestInAppPurseProductAndBuy:(NSString *)productID;


/**
 请求xcGetCF列表
 */
- (void)requestWithdrawalsList;

/**
 查询用户xczAccount信息
 */
- (void)requestZXCInfo;


/**
 发起xcGetCF申请

 @param drawalsId getCF ID
 @param paymentPwd 二级密码
 */
- (void)requestWithdrawalsWithID:(NSString *)drawalsId paymentPwd:(NSString *)paymentPwd;

/**
 发起xcGetCF
 
 @param redWithdrawalsID getCF
 */
- (void)requestRedWithdrawalsWithID:(NSString *)redWithdrawalsID paymentPwd:(NSString *)paymentPwd;

#pragma mark -
#pragma mark 公会线添加

/**
 获取钱包萝卜数

 @param currencyType 货币类型，1：萝卜 0：金币
 */
- (void)requestCarrotWalletWithType:(NSInteger)currencyType;

@end
