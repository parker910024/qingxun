//
//  AuthCore.m
//  CompoundUtil
//
//  Created by chenran on 2017/4/12.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "AuthCore.h"
#import "AuthCoreClient.h"
#import "LinkedMeCore.h"
#import "LinkedMeClient.h"

#import "AccountInfoStorage.h"
#import "TicketListInfoStorage.h"
#import "TicketListInfo.h"
#import "TicketInfo.h"

#import "FamilyCore.h"
#import "IReachability.h"

#import "NSObject+YYModel.h"
#import "XCDBManager.h"
#import "AppleAccountInfo.h"

@interface AuthCore()<ReachabilityClient>
@property(nonatomic, strong) AccountInfo *accountInfo;
@property(nonatomic, strong) TicketListInfo *ticketListInfo;

//@property (strong, nonatomic) dispatch_source_t timer;
//@property (strong, nonatomic) NSTimer *requestTimer;
//@property (strong, nonatomic) NSTimer *retryTimer;
@property (nonatomic,assign) NSInteger ticketRetryCount;

@end

@implementation AuthCore

- (instancetype)init
{
    self = [super init];
    if (self) {
        _accountInfo = [AccountInfoStorage getCurrentAccountInfo];
        _ticketListInfo = [TicketListInfoStorage getCurrentTicketListInfo];
        if (_accountInfo == nil) {
            _accountInfo = [[AccountInfo alloc] init];
        }
        if (_ticketListInfo == nil) {
            _ticketListInfo = [[TicketListInfo alloc] init];
        }
    }
    return self;
}

- (NSString *)getTicket
{
    if (self.ticketListInfo.tickets.count > 0) {
        NSString * ticketStr =[self.ticketListInfo.tickets safeObjectAtIndex:0];
        TicketInfo *info = [TicketInfo yy_modelWithJSON:ticketStr];
        if (info.ticket.length > 0) {
            return info.ticket;
        }else {
//            NotifyCoreClient(AuthCoreClient, @selector(onLogout), onLogout);
        }
        
    }
    return @"";
}

- (NSString *)getUid
{
    if (self.accountInfo.uid.length > 0) {
        return self.accountInfo.uid;
    }else {
//        NotifyCoreClient(AuthCoreClient, @selector(onLogout), onLogout);
    }
    return @"";
}

- (NSString *)getNetEaseToken
{
    return self.accountInfo.netEaseToken;
}

-(BOOL)isLogin
{
    return _accountInfo.access_token.length > 0;
}

-(void)regist:(NSString *)phone password:(NSString *)password smsCode:(NSString *)smsCode
{
    [HttpRequestHelper regist:phone password:password smsCode:smsCode success:^{
        [[BaiduMobStat defaultStat]logEvent:@"login_phone_register_click" eventLabel:@"手机立即注册按钮"];
        NotifyCoreClient(AuthCoreClient, @selector(onRegistSuccess), onRegistSuccess);
        [[XCLogger shareXClogger]sendLog:@{EVENT_ID:CRegister,@"mobile":phone} error:nil topic:BussinessLog logLevel:XCLogLevelVerbose];
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(AuthCoreClient, @selector(onRegistFailth:), onRegistFailth:message);
        NSDictionary *userInfo1 = [NSDictionary dictionaryWithObjectsAndKeys:message, NSLocalizedDescriptionKey,nil];
        NSError *error = [[NSError alloc]initWithDomain:NSCocoaErrorDomain code:[resCode integerValue] userInfo:userInfo1];
        [[XCLogger shareXClogger]sendLog:@{EVENT_ID:CRegister,@"mobile":phone} error:error topic:BussinessLog logLevel:XCLogLevelError];
//        [[XCLogger shareXClogger] sendLog:@{EVENT_ID:CRegister,@"mobile":phone} error:nil topic:BussinessLog logLevel:XCLogLevelVerbose];
    }];
}

/**
 TT 新的注册接口
 
 @param phone 手机号
 @param password 密码
 @param smsCode 短信验证码
 @param verifyCode 图片验证码 没有测传@""
 @param token 易盾token
 @param shuMeiDeviceId 数美设备id
 */
- (void)regist:(NSString *)phone password:(NSString *)password smsCode:(NSString *)smsCode verifyCode:(NSString *)verifyCode token:(NSString *)token shuMeiDeviceId:(NSString *)shuMeiDeviceId {
    [HttpRequestHelper regist:phone password:password smsCode:smsCode verifyCode:verifyCode token:token shuMeiDeviceId:shuMeiDeviceId success:^{
        [[BaiduMobStat defaultStat]logEvent:@"login_phone_register_click" eventLabel:@"手机立即注册按钮"];
        NotifyCoreClient(AuthCoreClient, @selector(onRegistSuccess), onRegistSuccess);
        [[XCLogger shareXClogger]sendLog:@{EVENT_ID:CRegister,@"mobile":phone} error:nil topic:BussinessLog logLevel:XCLogLevelVerbose];
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(AuthCoreClient, @selector(onRegistFailth:), onRegistFailth:message);
        NotifyCoreClient(AuthCoreClient, @selector(onRegistFailth:errorCode:), onRegistFailth:message errorCode:[resCode integerValue]);
        NSDictionary *userInfo1 = [NSDictionary dictionaryWithObjectsAndKeys:message, NSLocalizedDescriptionKey,nil];
        NSError *error = [[NSError alloc]initWithDomain:NSCocoaErrorDomain code:[resCode integerValue] userInfo:userInfo1];
        [[XCLogger shareXClogger]sendLog:@{EVENT_ID:CRegister,@"mobile":phone} error:error topic:BussinessLog logLevel:XCLogLevelError];
    }];
}

- (void)login:(NSString *)phone password:(NSString *)password
{
    [HttpRequestHelper login:phone password:password success:^(AccountInfo *accountInfo) {
        if (accountInfo != nil) {
            self.accountInfo = accountInfo;
            [AccountInfoStorage saveAccountInfo:accountInfo];
            [self requestTicket];
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(AuthCoreClient, @selector(onLoginFailth:), onLoginFailth:message);
    }];
}

-(void)logout
{
    [HttpRequestHelper logout:self.accountInfo.access_token success:^{
        
    } failure:^(NSNumber *resCode, NSString *message) {
            
    }];
    [self reset];
    NotifyCoreClient(AuthCoreClient, @selector(onLogout), onLogout);
}

- (void)kicked
{
//    [HttpRequestHelper logout:self.accountInfo.access_token success:^{
//        
//    } failure:^(NSNumber *resCode, NSString *message) {
//        
//    }];
    [self reset];
    NotifyCoreClient(AuthCoreClient, @selector(onKicked), onKicked);
}


- (void) autoLogin
{
    if (![self isLogin]) {
        NotifyCoreClient(AuthCoreClient, @selector(onNeedLogin), onNeedLogin);
        return;
    }

    [self requestTicket];
}


- (void)requestTicket
{
    if (self.retryTimer != nil) {
        [self.retryTimer invalidate];
        self.retryTimer = nil;
    }
    
    @weakify(self);
    [HttpRequestHelper requestTicket:self.accountInfo.access_token success:^(TicketListInfo *ticketListInfo) {
        @strongify(self);
        if (ticketListInfo != nil) {
            self.ticketListInfo = ticketListInfo;
            [TicketListInfoStorage saveTicketListInfo:ticketListInfo];
            [[BaiduMobStat defaultStat]logEvent:@"login_phone_click" eventLabel:@"手机登录"];
            NotifyCoreClient(AuthCoreClient, @selector(onLoginSuccess), onLoginSuccess);
            [[XCLogger shareXClogger]sendLog:@{EVENT_ID:CLogin} error:nil topic:BussinessLog logLevel:(XCLogLevel)XCLogLevelVerbose];
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (resCode != nil) {
            [self reset];
            NotifyCoreClient(AuthCoreClient, @selector(onLogout), onLogout);
        } else {
            if (self.ticketRetryCount < 5) {
                self.ticketRetryCount++;
                self.retryTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(retry) userInfo:nil repeats:NO];
                NSDictionary *userInfo1 = [NSDictionary dictionaryWithObjectsAndKeys:message, NSLocalizedDescriptionKey,nil];
                NSError *error = [[NSError alloc]initWithDomain:NSCocoaErrorDomain code:[resCode integerValue] userInfo:userInfo1];
                [[XCLogger shareXClogger]sendLog:@{EVENT_ID:CLogin} error:error topic:BussinessLog logLevel:(XCLogLevel)XCLogLevelError];
            }else {
                [self reset];
                NotifyCoreClient(AuthCoreClient, @selector(onLogout), onLogout);
            }
            
        }
    }];

}

- (void)reset
{
    if (self.info) {
        self.info = nil;
    }
    if (self.qqInfo) {
        self.qqInfo = nil;
    }
    
    if (self.appleInfo) {
        self.appleInfo = nil;
    }
    [GetCore(FamilyCore) reloadFamilyInfor:nil];
    [AccountInfoStorage saveAccountInfo:nil];
    [TicketListInfoStorage saveTicketListInfo:nil];
    _accountInfo = [[AccountInfo alloc] init];
    _ticketListInfo = [[TicketListInfo alloc] init];
    [[XCDBManager defaultManager] clearManager];
}

- (void) retry
{
    [self requestTicket];
}

- (void)requestResetSmsCode:(NSString *)phone
{
    [self requestSmsCode:phone type:@(3)];
}

- (void)requestLoginSmsCode:(NSString *)phone
{
    [self requestSmsCode:phone type:@(2)];
}

- (void)requestRegistSmsCode:(NSString *)phone
{
    [self requestSmsCode:phone type:@(1)];
}

- (void)requestSmsCode:(NSString *)phone type:(NSNumber *)type
{
    @weakify(self)
    [HttpRequestHelper requestSmsCode:phone type:type success:^{
        NotifyCoreClient(AuthCoreClient, @selector(onRequestSmsCodeSuccess:), onRequestSmsCodeSuccess:type);
        @strongify(self)
        [self openCountdown];
        [[XCLogger shareXClogger]sendLog:@{EVENT_ID:CVerifyCode} error:nil topic:BussinessLog logLevel:XCLogLevelVerbose];
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(AuthCoreClient, @selector(onRequestSmsCodeFailth:), onRequestSmsCodeFailth:message);
        NSDictionary *userInfo1 = [NSDictionary dictionaryWithObjectsAndKeys:message, NSLocalizedDescriptionKey,nil];
        NSError *error = [[NSError alloc]initWithDomain:NSCocoaErrorDomain code:[resCode integerValue] userInfo:userInfo1];
        [[XCLogger shareXClogger]sendLog:@{EVENT_ID:CVerifyCode} error:error topic:BussinessLog logLevel:XCLogLevelError];
    }];
}

/**
 修改  xcz密码
 
 @param oldPasswd 旧密码
 @param newPasswd 新密码
 */
- (void)modifyPaymentPasswordWitholdPassword:(NSString *)oldPasswd
                                 newPassword:(NSString *)newPasswd {
    
    [HttpRequestHelper modifyPaymentPasswordWitholdPassword:oldPasswd newPassword:newPasswd success:^(BOOL success) {
        NotifyCoreClient(AuthCoreClient, @selector(onResetPaymentPwdSuccess), onResetPaymentPwdSuccess);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(AuthCoreClient, @selector(onResetPaymentPwdFailth:), onResetPaymentPwdFailth:message);
    }];
}

/**
 重置xcz密码
 
 */
- (void)resetPaymentPasswordWithPwd:(NSString *)pwd {
    [HttpRequestHelper resetPaymentPwdWith:pwd success:^(BOOL success) {
        NotifyCoreClient(AuthCoreClient, @selector(onResetPaymentPwdSuccess), onResetPaymentPwdSuccess);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(AuthCoreClient, @selector(onResetPaymentPwdFailth:), onResetPaymentPwdFailth:message);
    }];
    
}

/// 设置支付密码
/// @param pwd 密码
/// @param phone 手机号（某些版本可以不用手机号验证码，这里手机号其实不需要，服务端处理）
/// @param code 验证码
- (void)requestSetPayPwd:(NSString *)pwd phone:(NSString *)phone verifyCode:(NSString *)code {
    [HttpRequestHelper requestSetPayPwd:pwd phone:phone verifyCode:code completion:^(id data, NSNumber *resCode, NSString *msg) {
        
        NotifyCoreClient(AuthCoreClient, @selector(onSetPayPwd:errorCode:msg:), onSetPayPwd:[data boolValue] errorCode:resCode msg:msg);
    }];
}

- (void)stopCountDown {
    if (self.timer != nil) {
        dispatch_source_cancel(_timer);
        self.timer = nil;
    }
}

- (void)openCountdown{
    
    __block NSInteger time = 59; //倒计时时间
    
    if (_timer != nil) {
        dispatch_source_cancel(_timer);
    }
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    @weakify(self);
    dispatch_source_set_event_handler(_timer, ^{
        @strongify(self);
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                NotifyCoreClient(AuthCoreClient, @selector(onCutdownFinish), onCutdownFinish);
                
            });
            
        }else{
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮显示读秒效果
                NotifyCoreClient(AuthCoreClient, @selector(onCutdownOpen:), onCutdownOpen:@(seconds));
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}

-(void)requestModifyPwd:(NSString *)phone pwd:(NSString *)pwd newPwd:(NSString *)newPwd
{
    [HttpRequestHelper requestModifyPwd:phone pwd:pwd newPwd:newPwd success:^{
        NotifyCoreClient(AuthCoreClient, @selector(onResetPwdSuccess), onResetPwdSuccess);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(AuthCoreClient, @selector(onResetPwdFailth:), onResetPwdFailth:message);
    }];
}

-(void)requestResetPwd:(NSString *)phone newPwd:(NSString *)newPwd smsCode:(NSString *)smsCode
{
    [HttpRequestHelper requestResetPwd:phone newPwd:newPwd smsCode:smsCode success:^{
        NotifyCoreClient(AuthCoreClient, @selector(onResetPwdSuccess), onResetPwdSuccess);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(AuthCoreClient, @selector(onResetPwdFailth:), onResetPwdFailth:message);
    }];
}

- (void)reachabilityDidChange:(ReachabilityStatus)currentStatus
{
    
}

/**
 设置登录密码
 
 @param phone 手机
 @param newPwd 新密码
 */
- (void)requestSetPwd:(NSString *)phone
               newPwd:(NSString *)newPwd {
    [HttpRequestHelper requestSetPwd:phone newPwd:newPwd success:^{
        NotifyCoreClient(AuthCoreClient, @selector(onResetPwdSuccess), onResetPwdSuccess);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(AuthCoreClient, @selector(onResetPwdFailth:), onResetPwdFailth:message);
        
    }];
}


- (void)loginWithOpenID:(NSString *)openID andUnionID:(NSString *)unionID access_token:(NSString *)access_token andType:(XCThirdPartLoginType)type {
    
    [HttpRequestHelper loginWithWeChatOpenID:openID andUnionID:unionID access_token:access_token andType:type success:^(AccountInfo *accountInfo) {
        if (accountInfo != nil) {
            self.accountInfo = accountInfo;
            [AccountInfoStorage saveAccountInfo:accountInfo];
            [self requestTicket];
        }
    
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(AuthCoreClient, @selector(onLoginFailth:), onLoginFailth:message);
    }];
}

//微信链接
- (void)wechatLoginPlatform:(SSDKPlatformType)platfor {
   
    [self thirdLoginPlatform:SSDKPlatformTypeWechat yiDunToken:nil shuMeiDeviceId:nil];
}

//qq链接
- (void)qqLoginPlatform:(SSDKPlatformType)platfor {
   
    [self thirdLoginPlatform:SSDKPlatformTypeQQ yiDunToken:nil shuMeiDeviceId:nil];
}
- (void)thirdLoginPlatform:(SSDKPlatformType)platfor
                yiDunToken:(NSString *)yiDunToken
            shuMeiDeviceId:(NSString *)shuMeiDeviceId{
    
    [self thirdLoginPlatform:platfor yiDunToken:yiDunToken shuMeiDeviceId:shuMeiDeviceId isNewUser:NO];
}
/// 一键登录
/// @param accessToken 营运商授权码
/// @param yiDunToken 易盾token
/// @param shuMeiDeviceId 数美deviceID
/// @param token 易盾token
- (void)quickLoginAccessToken:(NSString *)accessToken
                   yiDunToken:(NSString *)yiDunToken
               shuMeiDeviceId:(NSString *)shuMeiDeviceId
                        token:(NSString *)token {
    [HttpRequestHelper quickLoginAccessToken:accessToken yiDunToken:yiDunToken shuMeiDeviceId:shuMeiDeviceId token:token completionHandler:^(id data, NSNumber *code, NSString *msg) {
        
        if (data) {
            AccountInfo *info = [AccountInfo modelDictionary:data];
            self.accountInfo = info;
            [AccountInfoStorage saveAccountInfo:info];
            [self requestTicket];
        } else {
            NotifyCoreClient(AuthCoreClient, @selector(onLoginFailth:), onLoginFailth:msg);
        }
    }];
}


- (void)thirdLoginPlatform:(SSDKPlatformType)platfor
                yiDunToken:(NSString *)yiDunToken
            shuMeiDeviceId:(NSString *)shuMeiDeviceId
                 isNewUser:(BOOL)isNewUser {
    [ShareSDK cancelAuthorize:platfor result:nil];
    [ShareSDK getUserInfo:platfor onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        
        if (state == SSDKResponseStateSuccess) {
            
            if (platfor == SSDKPlatformTypeQQ) {
                [[BaiduMobStat defaultStat]logEvent:@"login_qq_click" eventLabel:@"qq登录"];
                self.info = nil;
                QQUserInfo *info = [QQUserInfo yy_modelWithJSON:user.rawData];
                info.openID = user.credential.rawData[@"openid"];
                NSString *unionid = [user.credential rawData][@"unionid"];
                self.qqInfo = info;
                
                if (isNewUser) { // 老用户 需要判断老用户的账号，是否绑定了新app
                    [HttpRequestHelper qqloginIsNewuserWith:info.openID success:^(BOOL success) {
                        if (success) {
                            [self loginWithWeChatOpenID:info.openID
                                             andUnionID:unionid
                                           access_token:user.credential.token
                                             yiDunToken:yiDunToken
                                         shuMeiDeviceId:shuMeiDeviceId
                                                andType:XCThirdPartLoginQQ];
                        }
                    } failure:^(NSNumber *resCode, NSString *message) {
                        if ([resCode intValue] == 6616) {
                            NotifyCoreClient(AuthCoreClient, @selector(qqloginNotBindErBanInfor:), qqloginNotBindErBanInfor:info.openID);
                        }
                    }];
                }else{
                    [self loginWithWeChatOpenID:info.openID
                                     andUnionID:unionid
                                   access_token:user.credential.token
                                     yiDunToken:yiDunToken
                                 shuMeiDeviceId:shuMeiDeviceId
                                        andType:XCThirdPartLoginQQ];
                }
            } else if (platfor == SSDKPlatformTypeWechat) {
                
                [[BaiduMobStat defaultStat]logEvent:@"login_wx_click" eventLabel:@"微信登录"];
                self.qqInfo = nil;
                WeChatUserInfo *info = [WeChatUserInfo yy_modelWithDictionary:user.rawData];
                self.info = info;
                
                [self loginWithWeChatOpenID:info.openid
                                 andUnionID:info.unionid
                               access_token:user.credential.token
                                 yiDunToken:yiDunToken
                             shuMeiDeviceId:shuMeiDeviceId
                                    andType:XCThirdPartLoginWechat];
            } else if (platfor == SSDKPlatformTypeAppleAccount) {
                NSLog(@"rawData---%@",user.rawData);
                NSLog(@"credential--%@",[user.credential rawData]);

//                NSString *unionID = user.credential.rawData[@"user"];
                AppleAccountInfo *appleInfo = [AppleAccountInfo modelDictionary:user.rawData];
                appleInfo.authCode = user.credential.authCode;
                appleInfo.token = user.credential.token;
                self.appleInfo = appleInfo;
                
                [self loginWithThirdPartOpenID:appleInfo.token
                                    andUnionID:appleInfo.user
                                  access_token:appleInfo.authCode
                                    yiDunToken:yiDunToken
                                shuMeiDeviceId:shuMeiDeviceId
                                 appleFullName:appleInfo.appleFullName andType:XCThirdPartLoginApple];
            }
            
        } else if (state == SSDKResponseStateCancel) {
            NotifyCoreClient(AuthCoreClient, @selector(thirdPartLoginCancel), thirdPartLoginCancel);
        } else if (state == SSDKResponseStateFail) {
            NotifyCoreClient(AuthCoreClient, @selector(thirdPartLoginFailth), thirdPartLoginFailth);
        }
        
    }];
}


- (void)loginWithWeChatOpenID:(NSString *)openID
                   andUnionID:(NSString *)unionID
                 access_token:(NSString *)access_token
                   yiDunToken:(NSString *)yiDunToken
               shuMeiDeviceId:(NSString *)shuMeiDeviceId
                      andType:(XCThirdPartLoginType)type {
    
    [self loginWithThirdPartOpenID:openID
                        andUnionID:unionID
                      access_token:access_token
                        yiDunToken:yiDunToken
                    shuMeiDeviceId:shuMeiDeviceId
                     appleFullName:nil andType:type];
}

/// 第三方登陆最新调用 api 加入了苹果id 登陆
- (void)loginWithThirdPartOpenID:(NSString *)openID
                      andUnionID:(NSString *)unionID
                    access_token:(NSString *)access_token
                      yiDunToken:(NSString *)yiDunToken
                  shuMeiDeviceId:(NSString *)shuMeiDeviceId
                   appleFullName:(NSString *)fullName
                         andType:(XCThirdPartLoginType)type {
    
    [HttpRequestHelper loginWithThirdPartOpenID:openID
                                     andUnionID:unionID
                                   access_token:access_token
                                     yiDunToken:yiDunToken
                                 shuMeiDeviceId:shuMeiDeviceId
                                        andType:type
                                  appleFullName:fullName
                                        success:^(AccountInfo *accountInfo) {
        if (accountInfo != nil) {
            self.accountInfo = accountInfo;
            [AccountInfoStorage saveAccountInfo:accountInfo];
            [self requestTicket];
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(AuthCoreClient, @selector(onLoginFailth:), onLoginFailth:message);
    }];
}
#pragma mark - Allo项目

- (void)thirdLoginPlatfor:(SSDKPlatformType)platfor isLogin:(BOOL)isLogin {
    [ShareSDK cancelAuthorize:platfor result:nil];
    
    [ShareSDK getUserInfo:platfor onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        NSLog(@"user:%lu",(unsigned long)state);
        if (state == SSDKResponseStateSuccess) {
            [[BaiduMobStat defaultStat]logEvent:@"login_wx_click" eventLabel:@"微信登录"];
            NSLog(@"%@",user);
            if (isLogin) {
                [self loginWithOpenID:user.uid andType:[self getThirdPartLoginTypeWith:platfor]];
            } else {
                AccountInfo *accouninfo = [AccountInfo yy_modelWithJSON:user.rawData];
                NotifyCoreClient(AuthCoreClient, @selector(thirdPartLoginGetInfoSuccess:type:), thirdPartLoginGetInfoSuccess:accouninfo type:[self getThirdPartLoginTypeWith:platfor]);
            }
            
        }else if (state == SSDKResponseStateCancel) {
            NotifyCoreClient(AuthCoreClient, @selector(thirdPartLoginCancel), thirdPartLoginCancel);
        }else if (state == SSDKResponseStateFail) {
            NotifyCoreClient(AuthCoreClient, @selector(thirdPartLoginFailth), thirdPartLoginFailth);
        }
    }];
}

- (void)loginWithOpenID:(NSString *)openID andType:(ALThirdPartLoginType)type {
    [HttpRequestHelper thirdLogin:openID type:type success:^(AccountInfo *accountInfo) {
        if (accountInfo != nil) {
            self.accountInfo = accountInfo;
            [AccountInfoStorage saveAccountInfo:accountInfo];
            [self requestTicketForThird];
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(AuthCoreClient, @selector(onLoginFailth:), onLoginFailth:message);
    }];
}

- (void)requestTicketForThird {
    if (self.retryTimer != nil) {
        [self.retryTimer invalidate];
        self.retryTimer = nil;
    }
    @weakify(self);
    [HttpRequestHelper requestTicket:self.accountInfo.access_token success:^(TicketListInfo *ticketListInfo) {
        @strongify(self);
        if (ticketListInfo != nil) {
            self.ticketListInfo = ticketListInfo;
            [TicketListInfoStorage saveTicketListInfo:ticketListInfo];
            
            NotifyCoreClient(AuthCoreClient, @selector(onLoginSuccess), onLoginSuccess);
            
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (resCode != nil) {
            [self reset];
            NotifyCoreClient(AuthCoreClient, @selector(onLogout), onLogout);
        } else {
            if (self.ticketRetryCount < 5) {
                self.ticketRetryCount++;
                self.retryTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(retry) userInfo:nil repeats:NO];
            } else {
                [self reset];
                NotifyCoreClient(AuthCoreClient, @selector(onLogout), onLogout);
            }
        }
    }];
}

- (ALThirdPartLoginType)getThirdPartLoginTypeWith:(SSDKPlatformType)type {
    switch (type) {
        case SSDKPlatformTypeQQ:
            return ALThirdPartLoginQQ;
            break;
        case SSDKPlatformTypeWechat:
            return ALThirdPartLoginWechat;
            break;
        case SSDKPlatformTypeFacebook:
            return ALThirdPartLoginFacebook;
            break;
        case SSDKPlatformTypeGooglePlus:
            return ALThirdPartLoginGoogle;
            break;
        case SSDKPlatformTypeInstagram:
            return ALThirdPartLoginInstagram;
            break;
        case SSDKPlatformTypeTwitter:
            return ALThirdPartLoginTwitter;
            break;
        default:
            return ALThirdPartLoginPhone;
            break;
    }
}

- (void)getAccountBindInfo {
    [HttpRequestHelper getAccountBindInfo:^(AccountBindInfo *accountInfo) {
        NotifyCoreClient(AuthCoreClient, @selector(getAccountBindInfoSuccess:), getAccountBindInfoSuccess:accountInfo);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(AuthCoreClient, @selector(getAccountBindInfoFailth:), getAccountBindInfoFailth:message);
    }];
}

- (void)thirdUnBindPlatfor:(SSDKPlatformType)platfor openId:(NSString *)openId {
    [HttpRequestHelper thirdUnbindWithType:[self getThirdPartLoginTypeWith:platfor] openid:openId success:^(AccountInfo *accountInfo) {
        NotifyCoreClient(AuthCoreClient, @selector(thirdUnbindSuccess:), thirdUnbindSuccess:accountInfo);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(AuthCoreClient, @selector(thirdUnbindFailth:), thirdUnbindFailth:message);
    }];
}

- (void)thirdBindPlatfor:(ALThirdPartLoginType)platfor openId:(NSString *)openId {
    [HttpRequestHelper thirdBindWithType:platfor openid:openId success:^(AccountInfo *accountInfo) {
        NotifyCoreClient(AuthCoreClient, @selector(thirdbindSuccess:), thirdbindSuccess:accountInfo);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(AuthCoreClient, @selector(thirdbindFailth:), thirdbindFailth:message);
    }];
}

#pragma mark - tutu引流用的
//qq链接 是不是erban的用户
- (void)qqLoginPlatform:(SSDKPlatformType)platfor isNewUser:(BOOL)isNewUser{
    [ShareSDK cancelAuthorize:platfor result:nil];
    [ShareSDK getUserInfo:platfor onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        
        if (state == SSDKResponseStateSuccess) {
            NotifyCoreClient(AuthCoreClient, @selector(thirdPartLoginSuccess), thirdPartLoginSuccess);
            self.info = nil;
            [[BaiduMobStat defaultStat]logEvent:@"login_qq_click" eventLabel:@"qq登录"];
            QQUserInfo *info = [QQUserInfo yy_modelWithJSON:user.rawData];
            info.openID = user.credential.rawData[@"openid"];
            self.qqInfo = info;
            if (isNewUser) {
                [self isNewUserExistsWith:info.openID credentiaToken:user.credential.token];
            }else{
                [self loginWithOpenID:info.openID andUnionID:nil access_token:user.credential.token andType:XCThirdPartLoginQQ];
            }
            
        }else if (state == SSDKResponseStateCancel) {
            NotifyCoreClient(AuthCoreClient, @selector(thirdPartLoginCancel), thirdPartLoginCancel);
        }else if (state == SSDKResponseStateFail) {
            NotifyCoreClient(AuthCoreClient, @selector(thirdPartLoginFailth), thirdPartLoginFailth);
        }
    }];
}

//老用户的qq是不是可用使用
- (void)isNewUserExistsWith:(NSString *)qqOpenid credentiaToken:(NSString *)token{
    if (qqOpenid) {
        [HttpRequestHelper qqloginIsNewuserWith:qqOpenid success:^(BOOL success) {
            if (success) {
              [self loginWithOpenID:qqOpenid andUnionID:nil access_token:token andType:XCThirdPartLoginQQ];
            }
        } failure:^(NSNumber *resCode, NSString *message) {
            if ([resCode intValue] == 6616) {
                 NotifyCoreClient(AuthCoreClient, @selector(qqloginNotBindErBanInfor:), qqloginNotBindErBanInfor:qqOpenid);
            }
        }];
    }
}

- (void)loginWithErbanAccount:(NSString *)erbanId password:(NSString *)password qqOpenid:(NSString *)qqOpenid{
    [HttpRequestHelper loginWithbindErBanAccount:erbanId password:password qqOpenid:qqOpenid success:^(AccountInfo * accountInfo) {
        if (accountInfo != nil) {
            self.accountInfo = accountInfo;
            [AccountInfoStorage saveAccountInfo:accountInfo];
            [self requestTicket];
        }
    } failure:^(NSNumber * number, NSString *message) {
        NotifyCoreClient(AuthCoreClient, @selector(onLoginFailth:), onLoginFailth:message);
    }];
}


//统计接口
- (void)statisticsWith:(NSURL *)url {
    [HttpRequestHelper statisticsWithURL:url success:^(BOOL isSuccess) {
        
    } failure:^(NSNumber *resCode, NSString *message) {
        
    }];
}

//是否绑定手机do
- (void)isBindingPhoneSuccess:(void (^)(BOOL isbinding))success  {
    [HttpRequestHelper judgeIsBindingPhoneWithsuccess:^(BOOL isbinding) {
        success(isbinding);
    } failure:^(NSNumber *resCode, NSString *message) {
        
    }];
}

/**
 请求用户的邀请码
 
 @param uid uid
 */
- (void)requestShareCodeWithUid:(NSString *)uid {
    [HttpRequestHelper getShareCodeWithUid:uid success:^(NSString *shareCode) {
        NotifyCoreClient(AuthCoreClient, @selector(getShareCodeSuccess:), getShareCodeSuccess:shareCode);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(AuthCoreClient, @selector(getShareCodeFailth:), getShareCodeFailth:message);
    }];
}

/**
 请求图片验证码
 
 @param phone 手机号
 */
- (void)requestCaptchaImageDataWithPhone:(NSString *)phone {
    [HttpRequestHelper requestCaptchaImageDataWithPhone:phone success:^(UIImage *image) {
        NotifyCoreClient(AuthCoreClient, @selector(getCaptchaImageDataSuccess:), getCaptchaImageDataSuccess:image);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(AuthCoreClient, @selector(getCaptchaImageDataFailth:), getCaptchaImageDataFailth:message);
    }];
}

#pragma mark - 登录的时候 输入密码三次以上 @fengshuo
/**
 发送验证码
 */
- (void)verificationSendCodeWithPhone:(NSString *)phone {
    @weakify(self);
    [HttpRequestHelper verificationCodeFailSendCodeWith:phone success:^(NSString *message) {
        @strongify(self);
        NotifyCoreClient(AuthCoreClient, @selector(onLoginImputFailSendCodeSuccess:), onLoginImputFailSendCodeSuccess:message);
        [self openCountdown];
    } failure:^(NSNumber *resCode, NSString *message) {
         NotifyCoreClient(AuthCoreClient, @selector(onLoginImputFailSendCodeFail:), onLoginImputFailSendCodeFail:message);
    }];
   
}

/// 点击登录
/// @param phone 手机号
/// @param password 密码
/// @param code 验证码
/// yiDunToken 云盾token = nil
/// shuMeiDeviceId 数美ID = nil
- (void)login:(NSString *)phone password:(NSString *)password code:(NSString *)code
{
    [self login:phone
       password:password
           code:code
     yiDunToken:nil
 shuMeiDeviceId:nil];
}

/// 点击登录
/// @param phone 手机号
/// @param password 密码
/// @param code 验证码
/// @param yiDunToken 云盾token
/// @param shuMeiDeviceId 数美ID
- (void)login:(NSString *)phone password:(NSString *)password code:(NSString *)code yiDunToken:(NSString *)yiDunToken shuMeiDeviceId:(NSString *)shuMeiDeviceId {
    
    [HttpRequestHelper login:phone password:password code:code yiDunToken:yiDunToken shuMeiDeviceId:shuMeiDeviceId success:^(AccountInfo *accountInfo) {
        if (accountInfo != nil) {
            self.accountInfo = accountInfo;
            [AccountInfoStorage saveAccountInfo:accountInfo];
            [self requestTicket];
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(AuthCoreClient, @selector(onLoginFailth:), onLoginFailth:message);
        // 超管需要处理错误码
        NotifyCoreClient(AuthCoreClient, @selector(onLoginFailthCode:errorMsg:), onLoginFailthCode:resCode.integerValue errorMsg:message);
    }];
}

/// 解除送礼1/2限额的短信验证
/// @param code 验证码
- (RACSignal *)getVerificationSendGiftWithCode:(NSString *)code {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [HttpRequestHelper verificationSendGiftWithCode:code success:^(BOOL success) {
            [subscriber sendNext:@(success)];
            [subscriber sendCompleted];
        } failure:^(NSNumber *resCode, NSString *message) {
            NSError *error = [[NSError alloc] initWithDomain:message code:[resCode integerValue] userInfo:nil];
            [subscriber sendError:error];
        }];
        return nil;
    }];
}

/// 用户登录删除相亲房数据
- (void)loveRoomLoginDeleteUserData {
    [HttpRequestHelper loveRoomLoginDeleteUserDataSuccess:^(BOOL success) {
        
    } failure:^(NSNumber *resCode, NSString *message) {
        
    }];
}
@end
