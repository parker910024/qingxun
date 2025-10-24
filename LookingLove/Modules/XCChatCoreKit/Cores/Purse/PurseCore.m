//
//  RechargeCore.m
//  BberryCore
//
//  Created by chenran on 2017/7/1.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "PurseCore.h"
#import "PurseCoreClient.h"
#import "HttpRequestHelper+Purse.h"
#import "HttpRequestHelper+Carrot.h"

#import "AuthCore.h"
#import "BalanceInfoStorage.h"
#import "AuthCoreClient.h"
#import "NotificationCoreClient.h"
#import "Attachment.h"
#import "NSObject+YYModel.h"

#import "IAPHelper.h"
#import "IAPShare.h"

#import "YYUtility.h"
#import "VersionCore.h"
#import "CommonFileUtils.h"
#import "NSDictionary+JSON.h"
#import "AppScoreClient.h"
#import "UserCore.h"

@interface PurseCore()<AuthCoreClient, NotificationCoreClient>

@end
@implementation PurseCore

- (instancetype)init
{
    self = [super init];
    if (self) {
        AddCoreClient(AuthCoreClient, self);
        AddCoreClient(NotificationCoreClient, self);
        _balanceInfo = [BalanceInfoStorage getCurrentBalanceInfo];
        if (_balanceInfo == nil) {
            _balanceInfo = [[BalanceInfo alloc] init];
        }
    }
    return self;
}


- (void)dealloc
{
    RemoveCoreClient(AuthCoreClient, self);
    RemoveCoreClient(NotificationCoreClient, self);
}


#pragma mark - 支付相关

- (void)requestRechargeList{
    [self requestRechargeListWithChannelType:IAPChannelType_Other];
}

- (void)requestRechargeListWithChannelType:(IAPChannelType)channelType {
    [HttpRequestHelper requestChargeListWith:channelType success:^(NSArray *rechargeInfo) {
        NotifyCoreClient(PurseCoreClient, @selector(onRequestRechargeListSuccess:), onRequestRechargeListSuccess:rechargeInfo);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(PurseCoreClient, @selector(onRequestRechargeListFailth), onRequestRechargeListFailth);
    }];
    
}


- (void)requestApplyRecharge:(NSString *)chargeProdId channel:(NSString *)channel{
    
    [self requestApplyRecharge:ApplyRechargeType_IAP appProductId:chargeProdId serverProductdId:nil shopProductType:0];
    
}



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
             shopProductType:(ShopProductType)shopProductType{
    
    [HttpRequestHelper requestInAppRechargeWithAppleType:applyType appProductId:appProductId serverProductdId:serverProductdId shopProductType:shopProductType success:^(BOOL orderStatus, NSString *orderID) {
        
        if (orderStatus) {
            
            //============================================下单成功调起苹果支付======================================
            
            
            NSSet* dataSet = [[NSSet alloc] initWithObjects:appProductId, nil];
            
            [IAPShare sharedHelper].iap = [[IAPHelper alloc] initWithProductIdentifiers:dataSet];
            
            [[IAPShare sharedHelper].iap requestProductsWithCompletion:^(SKProductsRequest *request, SKProductsResponse *response) {
                
                if (response != nil && response.products.count) {
                    NotifyCoreClient(PurseCoreClient, @selector(entryRequestProductProgressStatus:), entryRequestProductProgressStatus:YES);
                } else if (!response.products.count) {
                    
                    NotifyCoreClient(PurseCoreClient, @selector(entryRequestProductFail:), entryRequestProductFail:@"请求内购产品失败，无产品数量");
                } else if (!response) {
                    
                    NotifyCoreClient(PurseCoreClient, @selector(entryRequestProductFail:), entryRequestProductFail:@"请求内购产品失败，内购无响应");
                } else {
                    NotifyCoreClient(PurseCoreClient, @selector(entryRequestProductProgressStatus:), entryRequestProductProgressStatus:NO);
                }
                
                if (response.products.firstObject) {
                    [[IAPShare sharedHelper].iap buyProduct:response.products.firstObject orderId:orderID onCompletion:^(SKPaymentTransaction *transcation) {//transactionIdentifier
                        
                        NSLog(@"%@",transcation.error.description);
                        
                        switch(transcation.transactionState) {
                            case SKPaymentTransactionStatePurchased: {
                                NSLog(@"付款完成状态, 要做出相关的处理");
                                NSData *receipt = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]];
                                
                                NSArray *array = [CommonFileUtils readObjectFromUserDefaultWithKey:@"kIPATranscationIdsKey"];
                                NSMutableArray *arrM = [NSMutableArray arrayWithArray:array];
                                NSString *encodeStr = [receipt base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
                                NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
                                [dictionary safeSetObject:transcation.transactionIdentifier forKey:@"transcationId"];
                                [dictionary safeSetObject:encodeStr forKey:@"recipt"];
                                [dictionary safeSetObject:orderID forKey:@"orderId"];
                                
                                [arrM addObject:dictionary];
                                [CommonFileUtils writeObject:arrM toUserDefaultWithKey:@"kIPATranscationIdsKey"];
                                
                                [[SKPaymentQueue defaultQueue] finishTransaction:transcation];
                                NotifyCoreClient(PurseCoreClient, @selector(entryPurchaseProcessStatus:), entryPurchaseProcessStatus:XCPaymentStatusPurchased);
                                //同步返回购买成功后，需要请求服务器二次校验
                                [HttpRequestHelper checkReceiptWithData:receipt orderID:orderID transcationId:transcation.transactionIdentifier success:^(NSString *orderStatus) {
                                    
                                    [self handleTransaction:transcation];
                                    [self requestBalanceInfo:[GetCore(AuthCore)getUid].userIDValue];
                                    [[BaiduMobStat defaultStat]logEvent:@"recharge_click" eventLabel:@"金币充值"];
                                    NotifyCoreClient(PurseCoreClient, @selector(entryCheckReceiptSuccess), entryCheckReceiptSuccess);
                                } failure:^(NSNumber *resCode, NSString *message) {
                                    NSLog(@"message%@",message);
                                    [self handleTransaction:transcation];
                                    NotifyCoreClient(PurseCoreClient, @selector(entryCheckReceiptFaildWithMessage:), entryCheckReceiptFaildWithMessage:message);
                                }];
                                break;
                            }
                            case SKPaymentTransactionStateRestored: {
                                NSLog(@"恢复状态, 要做出相关的处理");
                                [[SKPaymentQueue defaultQueue] finishTransaction:transcation];
                                break;
                            }
                            case SKPaymentTransactionStateFailed: {
                                [[SKPaymentQueue defaultQueue] finishTransaction:transcation];
                                NSLog(@"购买失败");
                                NotifyCoreClient(PurseCoreClient, @selector(entryPurchaseProcessStatus:), entryPurchaseProcessStatus:XCPaymentStatusFailed);
                                break;
                            }
                            case SKPaymentTransactionStatePurchasing: {
                                NSLog(@"正在购买中");
                                NotifyCoreClient(PurseCoreClient, @selector(entryPurchaseProcessStatus:), entryPurchaseProcessStatus:XCPaymentStatusPurchasing);
                                break;
                            }
                            default: {
                                [[SKPaymentQueue defaultQueue] finishTransaction:transcation];
                                NotifyCoreClient(PurseCoreClient, @selector(entryPurchaseProcessStatus:), entryPurchaseProcessStatus:XCPaymentStatusDeferred);
                                NSLog(@"其它");
                            }
                        }
                        
                    }];
                }
                
            }];
            
            
        }
        
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(PurseCoreClient, @selector(addRechargeOrderFail:), addRechargeOrderFail:message);
        
        /**
         ====== 2019年08月07日 青少年模式下充值限额 ======
         
         需要在开启青少年模式后，限制用户充值的数量
         由于旧版的 api 上没有提供 code 这一参数，所以新加回调带上 code 参数。
         code = 25000 的时候，代表当日充值已达上限。无法充值。弹窗警告。
         兼容旧版。两个回调都需要调用，除非全部替换成新版失败回调。
         目前仅在 「哈哈」「萌声」 项目中使用。
         */
        NotifyCoreClient(PurseCoreClient, @selector(addRechargeOrderFail:code:), addRechargeOrderFail:message code:resCode);
    }];
    
    
}

- (void)requestCheckTranscationIds{
    
    NSArray *array = [CommonFileUtils readObjectFromUserDefaultWithKey:@"kIPATranscationIdsKey"];
    
    
    if (array.count>0) {
        [HttpRequestHelper requestCheckTranscationIds:[array yy_modelToJSONString] success:^(BOOL res) {
            [CommonFileUtils deleteObjectFromUserDefaultWithKey:@"kIPATranscationIdsKey"];
        } failure:^(NSNumber *resCode, NSString *message) {
            //todo
        }];
    }
    
}



- (void)requestBalanceInfo:(UserID)uid{
    
    @weakify(self)
    [HttpRequestHelper requestBalanceInfo:uid success:^(BalanceInfo *balance) {
        @strongify(self)
        balance.goldNum = [NSString stringWithFormat:@"%.2f",balance.goldNum.intValue * 1.0];
        self.balanceInfo = balance;
        [BalanceInfoStorage saveBalanceInfo:balance];
        [[XCLogger shareXClogger]sendLog:@{@"uid":[GetCore(AuthCore) getUid],EVENT_ID:CPurse} error:nil topic:BussinessLog logLevel:XCLogLevelVerbose];
        NotifyCoreClient(PurseCoreClient, @selector(onBalanceInfoUpdate:), onBalanceInfoUpdate:balance);
        [[XCLogger shareXClogger]sendLog:@{@"uid":[GetCore(AuthCore) getUid],EVENT_ID:CPurse} error:nil topic:BussinessLog logLevel:XCLogLevelVerbose];
    } failure:^(NSNumber *resCode, NSString *message) {
        NSDictionary *userInfo1 = [NSDictionary dictionaryWithObjectsAndKeys:message, NSLocalizedDescriptionKey,nil];
        NSError *error = [[NSError alloc]initWithDomain:NSCocoaErrorDomain code:[resCode integerValue] userInfo:userInfo1];
        [[XCLogger shareXClogger]sendLog:@{EVENT_ID:CPurse,@"uid":[GetCore(AuthCore)getUid]} error:error topic:BussinessLog logLevel:XCLogLevelError];
    }];
}




/**
 萌声  KTV 版本 修改 统一 短信验证获取
 
 获取短信验证码
 
 @param mobileNum 手机号码
 @param type 短信类型(1、注册短信 2、登录短信 3、找回/修改密码 4、绑定手机 5、绑定xczAccount 6、验证绑定手机 7、xcz密码验证手机)
 */
- (void)getCodeWithMobileNum:(NSString *)mobileNum type:(NSInteger)type {
    [HttpRequestHelper getCodeWithMobileNum:mobileNum type:type Success:^(BOOL success) {
        [GetCore(AuthCore) openCountdown];
        NotifyCoreClient(PurseCoreClient, @selector(getSmsSuccess), getSmsSuccess);
    } failure:^(NSNumber *errorCode, NSString *message) {
        NotifyCoreClient(PurseCoreClient, @selector(getSmsFaildWithMessage:), getSmsFaildWithMessage:message);
    }];
}






//获取xcGetCF列表
- (void)requestWithdrawalsList {
    [HttpRequestHelper requestWithdrawalsListSuccess:^(NSArray<WithDrawalInfo *> *data) {
        NotifyCoreClient(PurseCoreClient, @selector(requestWithdrawalsList:), requestWithdrawalsList:data);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(PurseCoreClient, @selector(requestWithdrawalsListFail:), requestWithdrawalsListFail:message);
    }];
}
//绑定xczAccount
- (void)bindingZXCWithAccount:(NSString *)account accountName:(NSString *)accountName verifyCode:(NSString *)verifyCode {
    
    [HttpRequestHelper bindingZXCWithZXCAccount:account accountName:accountName verifyCode:verifyCode success:^(BOOL success) {
        NotifyCoreClient(PurseCoreClient, @selector(bindingZXCStatus:), bindingZXCStatus:success);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(PurseCoreClient, @selector(bindingZXCFailWithMessage:), bindingZXCFailWithMessage:message);
        
    }];
}

//获取xczAccount信息

- (void)requestZXCInfo {
    [HttpRequestHelper requestZXCInforequestZXCInfoSuccess:^(ZXCInfo *data) {
        NotifyCoreClient(PurseCoreClient, @selector(requestZXCInfo:), requestZXCInfo:data);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(PurseCoreClient, @selector(requestZXCInfoFail:), requestZXCInfoFail:message);
    }];
}

- (void)requestExchangeCorn:(NSInteger)cornNumber paymentPwd:(NSString *)paymentPwd {
    @weakify(self)
    
    [HttpRequestHelper requestExchangeCorn:cornNumber paymentPwd:paymentPwd success:^(BalanceInfo *data) {
        NotifyCoreClient(PurseCoreClient, @selector(requestExchangeCornSuccess:), requestExchangeCornSuccess:data )
        @strongify(self)
        self.balanceInfo = data;
        [[BaiduMobStat defaultStat]logEvent:@"exchange_click" eventLabel:@"兑换金币"];
        NotifyCoreClient(PurseCoreClient, @selector(onBalanceInfoUpdate:), onBalanceInfoUpdate:data);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(PurseCoreClient, @selector(requestExchangeCornFail:), requestExchangeCornFail:message);
    }];
}

//xcGetCF申请

- (void)requestWithdrawalsWithID:(NSString *)drawalsId paymentPwd:(NSString *)paymentPwd {
    [HttpRequestHelper requestWithdrawals:drawalsId paymentPwd:paymentPwd success:^(BOOL withdrawalsStatus, NSString *leftDiamond) {
        [[BaiduMobStat defaultStat]logEvent:@"account_withdraw_click" eventLabel:@"提现按钮"];
        NotifyCoreClient(PurseCoreClient, @selector(requestWithdrawalsSuccess:), requestWithdrawalsSuccess:leftDiamond);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(PurseCoreClient, @selector(requestWithdrawalsFail:), requestWithdrawalsFail:message);
        NotifyCoreClient(PurseCoreClient, @selector(requestWithdrawalsFail:errorCode:), requestWithdrawalsFail:message errorCode:[resCode integerValue]);
    }];
}

- (void)requestRedWithdrawalsWithID:(NSString *)redWithdrawalsID paymentPwd:(NSString *)paymentPwd{
    [HttpRequestHelper requestRedWithdrawals:redWithdrawalsID paymentPwd:paymentPwd success:^(BOOL withdrawalsStatus, NSString *leftDiamond) {
        NotifyCoreClient(PurseCoreClient, @selector(requestRedWithdrawalsSuccess:), requestRedWithdrawalsSuccess:leftDiamond);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(PurseCoreClient, @selector(requestRedWithdrawalsFail:), requestRedWithdrawalsFail:message);
    }];
}

//获取验证码
- (void)getSmsWithType:(NSInteger)type {
    [HttpRequestHelper getMsmWithType:type Success:^(BOOL isSuccess,NSString *msg) {
        NotifyCoreClient(PurseCoreClient, @selector(getSmsSuccessWithMessage:), getSmsSuccessWithMessage:msg);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(PurseCoreClient, @selector(getSmsFaildWithMessage:), getSmsFaildWithMessage:message);
    }];
}

//获取xczAccount手机验证码
- (void)getPaySms {
    [HttpRequestHelper getPayMsmWithSuccess:^(BOOL isSuccess,NSString *msg) {
        NotifyCoreClient(PurseCoreClient, @selector(getSmsSuccessWithMessage:), getSmsSuccessWithMessage:msg);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(PurseCoreClient, @selector(getSmsFaildWithMessage:), getSmsFaildWithMessage:message);
    }];
}
/**
 //20180912获取手机验证码 业务类型，必填，1注册，2登录，3重设密码，4绑定手机，5绑定xczAccount，6重设xcz密码，7解绑手机(验证已绑定手机)
 */
- (void)getCodeWithPhoneNum:(NSString *)phoneNum type:(NSInteger)type{
    [HttpRequestHelper getPhoneMsmCode:(NSString *)phoneNum type:type Success:^(BOOL isSuccess,NSString *msg) {
        NotifyCoreClient(PurseCoreClient, @selector(getSmsSuccessWithMessage:), getSmsSuccessWithMessage:msg);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(PurseCoreClient, @selector(getSmsFaildWithMessage:), getSmsFaildWithMessage:message);
        
    }];
}

//通过手机号获取验证码
- (void)getCodeWithPhoneNum:(NSString *)phoneNum {
    [HttpRequestHelper getCodeWithPhoneNum:phoneNum Success:^(BOOL success) {
        NotifyCoreClient(PurseCoreClient, @selector(getSmsSuccess), getSmsSuccess);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(PurseCoreClient, @selector(getSmsFaildWithMessage:), getSmsFaildWithMessage:message);
    }];
}


/**
 通过手机获取验证码
 
 @param moblie 手机
 @param type 短信类型(1、注册短信 2、登录短信 3、找回/修改密码 4、绑定手机 5、绑定xczAccount 6、验证绑定手机)
 @param checkExits 是否校验手机 已绑定过
 */
- (void)getMoblieCodeWithMoblieNum:(NSString *)moblie type:(NSInteger)type isCheckExits:(BOOL)checkExits {
    [HttpRequestHelper getCodeWithMobileNum:moblie type:type isCheckExists:checkExits Success:^(BOOL success) {
        NotifyCoreClient(PurseCoreClient, @selector(getSmsSuccess), getSmsSuccess);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(PurseCoreClient, @selector(getSmsFaildWithMessage:), getSmsFaildWithMessage:message);
    }];
}




/**
 校验手机验证码接口
 
 @param moblieNum 手机号码
 @param code 验证码
 */
- (void)checkMoblieCodeWithMoblie:(NSString *)moblieNum code:(NSString *)code  {
    [HttpRequestHelper  checkMobileCodeWithMobile:moblieNum code:code Success:^(BOOL success) {
        NotifyCoreClient(PurseCoreClient, @selector(checkSmsSuccess), checkSmsSuccess);
    } failure:^(NSNumber *code, NSString *msg) {
        NotifyCoreClient(PurseCoreClient, @selector(checkSmsFail:), checkSmsFail:msg);
    }];
}



//绑定手机号
- (void)bindingPhoneNum:(NSString *)phoneNum verifyCode:(NSString *)verifyCode {
    [HttpRequestHelper bindingPhoneNumber:phoneNum verifyCode:verifyCode Success:^(BOOL success) {
        UserExtensionRequest *request = [[UserExtensionRequest alloc]init];
        request.needRefresh = YES;
        request.type = QueryUserInfoExtension_Full;
        [[GetCore(UserCore)queryExtensionUserInfoByWithUserID:[GetCore(AuthCore) getUid].userIDValue requests:@[request]]subscribeNext:^(id x) {
            NotifyCoreClient(PurseCoreClient, @selector(bindingPhoneNumberSuccess), bindingPhoneNumberSuccess);
        }];
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(PurseCoreClient, @selector(bindingPhoneNumberFailth:), bindingPhoneNumberFailth:message);
    }];
}
//获取[XCKeyWordTool sharedInstance].xcRedColor xcGetCF列表
- (void)requestRedWithdrawalsList {
    [HttpRequestHelper requestRedWithdrawalsListSuccess:^(NSArray *list) {
        NotifyCoreClient(PurseCoreClient, @selector(requestRedWithdrawalsListSuccess:), requestRedWithdrawalsListSuccess:list);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(PurseCoreClient, @selector(requestRedWithdrawalsListFailth:), requestRedWithdrawalsListFailth:message);
    }];
}

#pragma mark -
#pragma mark 公会线添加

/**
 获取钱包萝卜数
 
 @param currencyType 货币类型，1：萝卜 0：金币
 */
- (void)requestCarrotWalletWithType:(NSInteger)currencyType {
    [HttpRequestHelper requestCarrotWalletWithType:currencyType andCompletionBlock:^(id  _Nullable resultObject, NSNumber * _Nullable code, NSString * _Nullable msg) {
        CarrotWallet *model = [CarrotWallet yy_modelWithJSON:resultObject];
        self.carrotWallet = model;
        NotifyCoreClient(PurseCoreClient, @selector(getCarrotNum:code:message:), getCarrotNum:model code:code message:msg);
    }];
}

- (void)requestUserIsFirstRecharge {
    [HttpRequestHelper requestUserIsFirstRechargeAndCompletionBlock:^(id  _Nullable resultObject, NSNumber * _Nullable code, NSString * _Nullable msg) {
        NotifyCoreClient(PurseCoreClient, @selector(requestUserIsFirstRecharge:code:message:), requestUserIsFirstRecharge:[resultObject boolValue] code:code message:msg);
    }];
}

#pragma mark - AuthCoreClient
- (void)onLoginSuccess
{
    UserID uid = [GetCore(AuthCore) getUid].userIDValue;
    NSString *ticket = [GetCore(AuthCore) getTicket];
    if (ticket.length>1 && uid>0) {
        //        [self requestBalanceInfo:uid];
    }
    
}

- (void)onKicked
{
    self.balanceInfo = [[BalanceInfo alloc] init];
    [BalanceInfoStorage saveBalanceInfo:nil];
}

- (void)onLogout
{
    self.balanceInfo = [[BalanceInfo alloc] init];
    [BalanceInfoStorage saveBalanceInfo:nil];
}

#pragma mark - NotificationCoreClient
- (void)onRecvCustomP2PNoti:(NIMCustomSystemNotification *)notification{
    
    Attachment *attachment = [Attachment yy_modelWithJSON:notification.content];
    if (attachment.first == Custom_Noti_Header_Account){
        if (attachment.second == Custom_Noti_Sub_Account_Changed) {
            BalanceInfo *info = [BalanceInfo modelDictionary:attachment.data];
            self.balanceInfo = info;
            [BalanceInfoStorage saveBalanceInfo:info];
            NotifyCoreClient(PurseCoreClient, @selector(onBalanceInfoUpdate:), onBalanceInfoUpdate:info);
        }
    }
}

#pragma mark - private method
- (void)handleTransaction:(SKPaymentTransaction *)transcation{
    NSArray *array = [CommonFileUtils readObjectFromUserDefaultWithKey:@"kIPATranscationIdsKey"];
    NSMutableArray *arrM = [NSMutableArray arrayWithArray:array];
    NSMutableArray *temp = [NSMutableArray arrayWithArray:array];
    for (NSDictionary *dictionary in temp) {
        if ([dictionary[@"transcationId"] isEqualToString:transcation.transactionIdentifier]) {
            [arrM removeObject:dictionary];
            break;
        }
    }
    [CommonFileUtils writeObject:arrM toUserDefaultWithKey:@"kIPATranscationIdsKey"];
}
@end
