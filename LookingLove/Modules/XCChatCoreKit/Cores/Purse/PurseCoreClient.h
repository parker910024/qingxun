//
//  RechargeCoreClient.h
//  BberryCore
//
//  Created by chenran on 2017/7/1.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZXCInfo.h"
#import "BalanceInfo.h"
#import "WithDrawalInfo.h"
#import "BalanceInfo.h"
#import "CarrotWallet.h"

@protocol PurseCoreClient <NSObject>
@optional
- (void)onRequestRechargeListSuccess:(NSArray *)list;
- (void)onRequestRechargeListFailth;
//- (void)onRequestApplyRechargeSuccess:(NSObject *)charge;
- (void)onRequestApplyRechargeFailth;
- (void)onBalanceInfoUpdate:(BalanceInfo*)balanceInfo;

//MARK:=========苹果支付=========
- (void)addRechargeOrderFail:(NSString *)message; //下单失败
- (void)addRechargeOrderFail:(NSString *)message code:(NSNumber *)code; // 下单失败，根据code 处理业务
- (void)addRechargeOrderSuccess:(NSString *)productID orderID:(NSString *)orderID; //下单success

- (void)entryRequestProductProgressStatus:(BOOL)Status;// 查询商品
- (void)entryRequestProductFail:(NSString *)reason;// 查询商品失败

- (void)entryPurchaseProcessStatus:(XCPaymentStatus)Status; //进入购买流程

- (void)entryCheckReceiptSuccess;//二次验证成功
- (void)entryCheckReceiptFaildWithMessage:(NSString *)message;//二次验证失败

//MARK:=========钱包（绑定xczAccount）============
- (void)bindingZXCStatus:(BOOL)status;//绑定xczAccount
- (void)bindingZXCFailWithMessage:(NSString *)message;//绑定xczAccount失败

//MARK:=========xcGetCF============
- (void)requestZXCInfo:(ZXCInfo *)zxcInfo; //获取xczAccount信息，如果为空即显示绑定xczAccount
- (void)requestZXCInfoFail:(NSString *)message; //获取xczAccount信息失败

- (void)requestWithdrawalsList:(NSArray<WithDrawalInfo *> *)drawalsList; //xcGetCF列表
- (void)requestWithdrawalsListFail:(NSString *)message; //获取xcGetCF列表错误
- (void)requestWithdrawalsSuccess:(NSString *)leftDiamond;//xcGetCF申请成功
- (void)requestWithdrawalsFail:(NSString *)message;//xcGetCF申请失败
- (void)requestWithdrawalsFail:(NSString *)message errorCode:(NSInteger)errorCode;//xcGetCF申请失败
- (void)requestWithdrawalsFailNeedCertified:(NSInteger)errorCode;//xcGetCF申请失败, 需要实名认证
- (void)requestExchangeCornSuccess:(BalanceInfo *)balanceInfo;//xcCF转萌币
- (void)requestExchangeCornFail:(NSString *)message;//xcCF转萌币

//MARK:=========[XCKeyWordTool sharedInstance].xcRedColor xcGetCF===========
- (void)requestRedWithdrawalsSuccess:(NSString *)leftDiamond;//xcGetCF申请成功
- (void)requestRedWithdrawalsFail:(NSString *)message;//xcGetCF申请失败
- (void)requestRedWithdrawalsListSuccess:(NSArray *)list;//请求xcGetCF列表成功
- (void)requestRedWithdrawalsListFailth:(NSString *)message; //[XCKeyWordTool sharedInstance].xcRedColorxcGetCF列表失败

//MARK:=========手机相关==========
- (void)bindingPhoneNumberSuccess;  // 绑定手机号成功
- (void)bindingPhoneNumberFailth:(NSString *)message; //绑定手机号失败
- (void)getSmsSuccess;//获取验证码成功
- (void)getSmsSuccessWithMessage:(NSString *)message;//获取验证码成功
- (void)getSmsFaildWithMessage:(NSString *)message;//获取验证码 失败

- (void)checkSmsSuccess;//交验 验证码正确
- (void)checkSmsFail:(NSString *)message;//交验 验证码失败 可能是错误验证码 也可能是其他

#pragma mark -
#pragma mark 公会线添加萝卜相关  2019年03月26日
- (void)getCarrotNum:(CarrotWallet *)carrotWallet code:(NSNumber *)code message:(NSString *)message;
//MARK:=========首次充值==========
- (void)requestUserIsFirstRecharge:(BOOL)isFirst code:(NSNumber *)code message:(NSString *)message;
@end
