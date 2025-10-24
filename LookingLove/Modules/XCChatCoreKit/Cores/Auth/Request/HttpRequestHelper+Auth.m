//
//  HttpRequestHelper+Auth.m
//  BberryCore
//
//  Created by chenran on 2017/3/5.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "HttpRequestHelper+Auth.h"
#import "TicketListInfo.h"
#import "AccountBindInfo.h"
#import "DESEncrypt.h"
#import "AuthCore.h"
#import "XCMacros.h"
#import "NSString+NTES.h"
#import "LocalTimeAdjustManager.h"
#import "TTStatisticsService.h"

@implementation HttpRequestHelper (Auth)
+ (void)getVisitor:(void (^)(AccountInfo *))success failure:(void (^)(NSNumber *, NSString *))failure
{
    NSString *method = @"acc/getvisitor";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [HttpRequestHelper GET:method params:params success:^(id data) {
//        AccountInfo *accoutInfo = [AccountInfo yy_modelWithDictionary:data];
        AccountInfo *accoutInfo = [AccountInfo modelDictionary:data];
        if (accoutInfo != nil) {
            success(accoutInfo);
        } else {
            failure(nil, @"用户异常");
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+ (void)regist:(NSString *)phone password:(NSString *)password smsCode:(NSString *)smsCode
       success:(void (^)(void))success
       failure:(void (^)(NSNumber *resCode, NSString *message))failure
{
    
    NSString *method = @"acc/signup";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:phone forKey:@"phone"];
    [params setObject:phone forKey:@"username"];
    [params setObject:smsCode forKey:@"smsCode"];
    [params setObject:[DESEncrypt encryptUseDES:password key:keyWithType(KeyType_PwdEncode, NO)] forKey:@"password"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
            success();
    } failure:^(NSNumber *resCode, NSString *message) {
        [TTStatisticsService trackEvent:@"login_registration_failed" eventDescribe:message];
        if (failure) {
            failure(resCode, message);
        }
    }];
}

/**
 TT 新的注册
 
 @param phone 手机
 @param password 密码
 @param smsCode 验证码
 @param verifyCode 图片验证码
 @param token 易盾token
 @param shuMeiDeviceId 数美设备id
 @param success 成功
 @param failure 失败
 */
+ (void)regist:(NSString *)phone password:(NSString *)password smsCode:(NSString *)smsCode verifyCode:(NSString *)verifyCode token:(NSString *)token shuMeiDeviceId:(NSString *)shuMeiDeviceId success:(void (^)(void))success failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString *method = @"acc/register";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:phone forKey:@"phone"];
    [params setObject:phone forKey:@"username"];
    [params setObject:smsCode forKey:@"smsCode"];
    if (verifyCode.length) {
        [params setObject:verifyCode forKey:@"verifyCode"];
    }
    if (token.length) {
        [params setObject:token forKey:@"token"];
    }
    if (shuMeiDeviceId.length) {
        [params setObject:shuMeiDeviceId forKey:@"shuMeiDeviceId"];
    }
    [params setObject:[DESEncrypt encryptUseDES:password key:keyWithType(KeyType_PwdEncode, NO)] forKey:@"password"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success();
    } failure:^(NSNumber *resCode, NSString *message) {
        [TTStatisticsService trackEvent:@"login_registration_failed" eventDescribe:message];
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+ (void)login:(NSString *)phone password:(NSString *)password success:(void (^)(AccountInfo *))success failure:(void (^)(NSNumber *, NSString *))failure
{
    NSString *method = @"oauth/token";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:phone forKey:@"phone"];
    [params setObject:[DESEncrypt encryptUseDES:password key:keyWithType(KeyType_PwdEncode, NO)] forKey:@"password"];
    [params setObject:@"uyzjdhds" forKey:@"client_secret"];
    [params setObject:@"password" forKey:@"grant_type"];
    [params setObject:@"erban-client" forKey:@"client_id"];
    [params setObject:@"1.0" forKey:@"version"];

    [HttpRequestHelper POST:method params:params success:^(id data) {
//        AccountInfo *accoutInfo = [AccountInfo yy_modelWithDictionary:data];
              AccountInfo *accoutInfo = [AccountInfo modelDictionary:data];
        if (accoutInfo != nil) {
            success(accoutInfo);
        } else {
            failure(nil, @"用户异常");
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        [TTStatisticsService trackEvent:@"login_failed" eventDescribe:message];
        if (failure) {
            failure(resCode, message);
        }
    }];
    
}

+ (void)logout:(NSString *)accessToken success:(void (^)(void))success failure:(void (^)(NSNumber *, NSString *))failure
{
    NSString *method = @"acc/logout";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (accessToken.length == 0 || accessToken == nil) {
        return;
    }
    
    [params setObject:accessToken forKey:@"access_token"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success();
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}
//微信登录
+ (void)loginWithWeChatOpenID:(NSString *)openID
                   andUnionID:(NSString *)unionID
                 access_token:(NSString *)access_token
                      andType:(XCThirdPartLoginType)type
                      success:(void (^)(AccountInfo *))success
                      failure:(void (^)(NSNumber *, NSString *))failure {
    
    [self loginWithWeChatOpenID:openID andUnionID:unionID access_token:access_token yiDunToken:nil shuMeiDeviceId:nil andType:type success:success failure:failure];
   
}
+ (void)loginWithWeChatOpenID:(NSString *)openID
                   andUnionID:(NSString *)unionID
                 access_token:(NSString *)access_token
                   yiDunToken:(NSString *)yiDunToken
               shuMeiDeviceId:(NSString *)shuMeiDeviceId
                      andType:(XCThirdPartLoginType)type
                      success:(void (^)(AccountInfo *accountInfo))success
                      failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    
    [self loginWithThirdPartOpenID:openID
                        andUnionID:unionID
                      access_token:access_token
                        yiDunToken:yiDunToken
                    shuMeiDeviceId:shuMeiDeviceId
                           andType:type
                     appleFullName:nil
                           success:success
                           failure:failure];
}

+ (void)loginWithThirdPartOpenID:(NSString *)openID
                      andUnionID:(NSString *)unionID
                    access_token:(NSString *)access_token
                      yiDunToken:(NSString *)yiDunToken
                  shuMeiDeviceId:(NSString *)shuMeiDeviceId
                         andType:(XCThirdPartLoginType)type
                   appleFullName:(NSString *)fullName
                         success:(void (^)(AccountInfo *))success
                         failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"acc/third/login";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (openID.length > 0) {
        [params setObject:openID forKey:@"openid"];
    }
    if (unionID.length > 0) {
        [params setObject:unionID forKey:@"unionid"];
    }
    if (yiDunToken) {
        [params safeSetObject:yiDunToken forKey:@"yiDunToken"];
    }
    if (shuMeiDeviceId) {
        [params safeSetObject:shuMeiDeviceId forKey:@"shuMeiDeviceId"];
    }
    if (fullName.length > 0) {
//        [params safeSetObject:fullName forKey:@"appleFullName"];
    }

    [params safeSetObject:access_token forKey:@"access_token"];
    [params setObject:@(type) forKey:@"type"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        
        AccountInfo *info = [AccountInfo modelDictionary:data];
        success(info);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}



+ (void)requestTicket:(NSString *)accessToken
              success:(void (^)(TicketListInfo *ticketListInfo))success
              failure:(void (^)(NSNumber *resCode, NSString *message))failure;
{
    NSString *method = @"oauth/ticket";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"multi" forKey:@"issue_type"];
    if (accessToken.length == 0 && accessToken == nil) {
        return;
    }
    [params setObject:accessToken forKey:@"access_token"];

    [HttpRequestHelper POST:method params:params success:^(id data) {
        TicketListInfo *listListInfo = [TicketListInfo modelDictionary:data];
        if (listListInfo != nil && listListInfo.tickets.count > 0) {
            success(listListInfo);
        } else {
            failure(@(10), @"ticket为空");
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+ (void)requestSmsCode:(NSString *)phone type:(NSNumber *)type success:(void (^)(void))success failure:(void (^)(NSNumber *, NSString *))failure
{
    NSString *method = @"sms/code";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:phone forKey:@"phone"];
    [params setObject:[NSString stringWithFormat:@"%@",type] forKey:@"type"];
    NSString *uid = [GetCore(AuthCore) getUid];
    [params safeSetObject:uid forKey:@"uid"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success();
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];

}

+(void)requestResetPwd:(NSString *)phone newPwd:(NSString *)newPwd smsCode:(NSString *)smsCode success:(void (^)(void))success failure:(void (^)(NSNumber *, NSString *))failure
{
    NSString *method = @"acc/pwd/reset";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:phone forKey:@"phone"];
    [params setObject:[DESEncrypt encryptUseDES:newPwd key:keyWithType(KeyType_PwdEncode, NO)] forKey:@"newPwd"];
    [params setObject:smsCode forKey:@"smsCode"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success();
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];

}

+(void)requestModifyPwd:(NSString *)phone pwd:(NSString *)pwd newPwd:(NSString *)newPwd success:(void (^)(void))success failure:(void (^)(NSNumber *, NSString *))failure
{
    NSString *method = @"acc/pwd/modify";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:phone forKey:@"phone"];
    [params setObject:[DESEncrypt encryptUseDES:newPwd key:keyWithType(KeyType_PwdEncode, NO)]  forKey:@"newPwd"];
    if (pwd.length) {
        [params setObject:[DESEncrypt encryptUseDES:pwd key:keyWithType(KeyType_PwdEncode, NO)]  forKey:@"pwd"];
    }
    
    NSString *ticket = [GetCore(AuthCore) getTicket];
    [params setObject:ticket forKey:@"ticket"];


    [HttpRequestHelper POST:method params:params success:^(id data) {
        success();
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}



+(void)requestSetPwd:(NSString *)phone newPwd:(NSString *)newPwd success:(void (^)(void))success failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"acc/pwd/set";
    if (projectType() == ProjectType_VKiss) {
        method = @"user/pwd/set";
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:phone forKey:@"phone"];
    [params setObject:[DESEncrypt encryptUseDES:newPwd key:keyWithType(KeyType_PwdEncode, NO)]  forKey:@"newPwd"];
    NSString *ticket = [GetCore(AuthCore) getTicket];
    [params setObject:ticket forKey:@"ticket"];
    
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success();
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+ (void)statisticsWithURL:(NSURL *)url success:(void (^)(BOOL))success failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"statis/logininfo";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *uid = [GetCore(AuthCore) getUid];
    [params setObject:uid forKey:@"uid"];
    NSString *urlStr = url.absoluteString;
    NSString *ticket = [GetCore(AuthCore) getTicket];
    [params setObject:urlStr forKey:@"url"];
    [params setObject:ticket forKey:@"ticket"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success(YES);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];

}

//判断是否绑定手机
+ (void)judgeIsBindingPhoneWithsuccess:(void (^)(BOOL))success failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"user/isBindPhone";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *uid = [GetCore(AuthCore) getUid];
    NSString *ticket = [GetCore(AuthCore) getTicket];
    [params setObject:ticket forKey:@"ticket"];

    if (uid.length > 0) {
        [params setObject:uid forKey:@"uid"];
    }else {
        success(YES);
    }
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        success(YES);
    } failure:^(NSNumber *resCode, NSString *message) {
        success(NO);
        failure(resCode, message);
    }];
}



/**
 修改 xcz密码
 
 @param oldPasswd 旧密码 设置密码可填空
 @param newPasswd 新密码
 @param success 成功
 @param failure 失败
 */
+ (void)modifyPaymentPasswordWitholdPassword:(NSString *)oldPasswd
                          newPassword:(NSString *)newPasswd
                              success:(void (^)(BOOL success))success
                              failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    
    NSString *method = @"user/paymentPasswd/modify";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *uid = [GetCore(AuthCore) getUid];
    
    [params setObject:[DESEncrypt encryptUseDES:newPasswd key:keyWithType(KeyType_PwdEncode, NO)] forKey:@"newPasswd"];
    [params setObject:[DESEncrypt encryptUseDES:oldPasswd key:keyWithType(KeyType_PwdEncode, NO)] forKey:@"oldPasswd"];
    NSString *ticket = [GetCore(AuthCore) getTicket];
    [params setObject:ticket forKey:@"ticket"];

    if (uid.length > 0) {
        [params setObject:uid forKey:@"uid"];
    }else {
        failure(@404,@"用户账号异常获取不到uid");
        return;
    }
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success(YES);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}



/**
 重置xcz密码

 @param pwd xcz密码
 @param success 成功
 @param failure 失败
 */
+ (void)resetPaymentPwdWith:(NSString *)pwd success:(void (^)(BOOL success))success
                    failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    
    [self requestSetPayPwd:pwd phone:nil verifyCode:nil completion:^(id data, NSNumber *code, NSString *msg) {
        
        BOOL result = [data boolValue];
        if (result) {
            !success ?: success(YES);
        } else {
            !failure ?: failure(code, msg);
        }
    }];
}

/// 设置支付密码
/// @param pwd 密码
/// @param phone 手机号（某些版本可以不用手机号验证码，这里手机号其实不需要，服务端处理）
/// @param code 验证码
+ (void)requestSetPayPwd:(NSString *)pwd phone:(NSString *)phone verifyCode:(NSString *)code completion:(HttpRequestHelperCompletion)completion {
    
    NSString *method = @"/user/paymentPasswd/reset";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params setValue:[DESEncrypt encryptUseDES:pwd key:keyWithType(KeyType_PwdEncode, NO)] forKey:@"newPasswd"];
    [params setValue:[GetCore(AuthCore) getTicket] forKey:@"ticket"];
    [params setValue:phone forKey:@"phone"];
    [params setValue:code forKey:@"code"];

    [HttpRequestHelper POST:method params:params success:^(id data) {
        !completion ?: completion(@(YES), nil, nil);
    } failure:^(NSNumber *resCode, NSString *message) {
        !completion ?: completion(@(NO), resCode, message);
    }];
}

/**
 兔兔判断qq登录是不是可用
 
 @param qqOpenid qqOpenid
 @param success 成功
 @param failure 失败
 */
+ (void)qqloginIsNewuserWith:(NSString *)qqOpenid success:(void (^)(BOOL success))success
                     failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    NSString * method = @"acc/third/isExistsQqAccount";
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setValue:qqOpenid forKey:@"qqOpenid"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success(YES);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

+ (void)loginWithbindErBanAccount:(NSString *)erbanId password:(NSString *)password qqOpenid:(NSString *)qqOpenid  success:(void (^)(AccountInfo *))success failure:(void (^)(NSNumber *, NSString *))failure{
    NSString *method = @"oauth/token";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:erbanId forKey:@"phone"];
    [params setObject:[DESEncrypt encryptUseDES:password key:keyWithType(KeyType_PwdEncode, NO)] forKey:@"password"];
    [params setObject:@"uyzjdhds" forKey:@"client_secret"];
    [params setObject:@"password" forKey:@"grant_type"];
    [params setObject:@"erban-client" forKey:@"client_id"];
    [params setObject:qqOpenid forKey:@"qqOpenid"];
    [params setObject:@"2" forKey:@"operateType"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        //        AccountInfo *accoutInfo = [AccountInfo yy_modelWithDictionary:data];
        AccountInfo *accoutInfo = [AccountInfo modelDictionary:data];
        if (accoutInfo != nil) {
            success(accoutInfo);
        } else {
            failure(nil, @"用户异常");
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

// 获取用户的邀请码
+ (void)getShareCodeWithUid:(NSString *)uid success:(void (^)(NSString *))success failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"user/shareCode";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (uid.length > 0) {
        [params setObject:uid forKey:@"uid"];
    } else {
        success(@"");
    }
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success(data);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

// 第三方登录
+ (void)thirdLogin:(NSString *)uid type:(ALThirdPartLoginType)type success:(void (^)(AccountInfo *))success failure:(void (^)(NSNumber *, NSString *))failure {
    
    NSString *method = @"acc/third/login";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:uid forKey:@"openid"];
    [params setObject:@(type) forKey:@"type"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        AccountInfo *accoutInfo = [AccountInfo modelDictionary:data];
        if (accoutInfo != nil) {
            success(accoutInfo);
        } else {
            failure(nil, @"用户异常");
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+ (void)getAccountBindInfo:(void (^)(AccountBindInfo *))success failure:(void (^)(NSNumber *, NSString *))failure {
    
    NSString *method = @"account/bindinfo/get";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *uid = [GetCore(AuthCore) getUid];
    [params setObject:uid forKey:@"uid"];
    NSString *ticket = [GetCore(AuthCore) getTicket];
    [params setObject:ticket forKey:@"ticket"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        AccountBindInfo *accoutInfo = [AccountBindInfo modelDictionary:data];
        if (accoutInfo != nil) {
            success(accoutInfo);
        } else {
            failure(nil, @"绑定异常");
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+ (void)thirdUnbindWithType:(ALThirdPartLoginType)type openid:(NSString *)openId success:(void (^)(AccountInfo *))success failure:(void (^)(NSNumber *, NSString *))failure {
    
    NSString *method = @"account/unbind";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *uid = [GetCore(AuthCore) getUid];
    NSString *ticket = [GetCore(AuthCore) getTicket];
    [params setObject:uid forKey:@"uid"];
    [params setObject:ticket forKey:@"ticket"];
    [params setObject:openId forKey:@"bindAccountOpenid"];
    [params setObject:@(type) forKey:@"unbindAccountType"];

    [HttpRequestHelper POST:method params:params success:^(id data) {
        AccountBindInfo *accoutInfo = [AccountBindInfo modelDictionary:data];
        if (accoutInfo != nil) {
            success(accoutInfo);
        } else {
            failure(nil, @"绑定异常");
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
    
}

+ (void)thirdBindWithType:(ALThirdPartLoginType)type openid:(NSString *)openId success:(void (^)(AccountInfo *))success failure:(void (^)(NSNumber *, NSString *))failure {
    
    NSString *method = @"account/bind";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *uid = [GetCore(AuthCore) getUid];
    NSString *ticket = [GetCore(AuthCore) getTicket];
    [params setObject:uid forKey:@"uid"];
    [params setObject:ticket forKey:@"ticket"];
    [params setObject:openId forKey:@"bindAccountOpenid"];
    [params setObject:@(type) forKey:@"unbindAccountType"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        AccountBindInfo *accoutInfo = [AccountBindInfo modelDictionary:data];
        if (accoutInfo != nil) {
            success(accoutInfo);
        } else {
            failure(nil, @"绑定异常");
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

/**
 请求图片验证码
 
 @param phone 手机号
 @param success 成功
 @param failure 失败
 */
+ (void)requestCaptchaImageDataWithPhone:(NSString *)phone success:(void (^)(UIImage *))success failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"acc/captcha/image";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    // 时间戳
    NSString *timestamp = [NSString stringWithFormat:@"%ld", [LocalTimeAdjustManager shareManager].adjustedLocalTimestamp];
    
    // 随机串，6位
    int nonceNum = arc4random() % 100000;
    NSString *nonce = [NSString stringWithFormat:@"%06d", nonceNum];
    
    // sign=md5(phone+nonce+timestamp)
    NSString *sign = [[NSString stringWithFormat:@"%@%@%@", phone, nonce, timestamp] MD5String];
    
    [params setObject:phone forKey:@"phone"];
    [params setObject:timestamp forKey:@"timestamp"];
    [params setObject:nonce forKey:@"nonce"];
    [params setObject:sign forKey:@"sign"];
    
    [HttpRequestHelper POSTImage:method params:params success:^(id data) {
        if (success) {
            UIImage *imageData = (UIImage *)data;
            success(imageData);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
    
}

#pragma mark - 登录的时候输入验证码错误三次  @fengshuo
/**
 发送验证码
 @param phone 兔兔号或者手机号
 */
+ (void)verificationCodeFailSendCodeWith:(NSString *)phone
                                 success:(void (^)(NSString * message))success
                                 failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    NSString * method = @"sms/login/code";
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:phone forKey:@"phone"];
    [HttpRequestHelper POST:method params:dic success:^(id data) {
        NSString * message = data;
        success(message);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
    
}

/**
  登录
  兔兔玩友专用
  @param phone 手机
  @param password 密码
  @param code 验证码
  @param yiDunToken 云盾token
  @param shuMeiDeviceId 数美ID
  @param success 成功
  @param failure 失败
  */
 + (void)login:(NSString *)phone
      password:(NSString *)password
          code:(NSString *)code
    yiDunToken:(NSString *)yiDunToken
 shuMeiDeviceId:(NSString *)shuMeiDeviceId
       success:(void (^)(AccountInfo *accountInfo))success
       failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    
    NSString *method = @"oauth/token";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:phone forKey:@"phone"];
    if (code && code.length > 0) {
     [params setObject:code forKey:@"code"];
    }
    
    [params setObject:[DESEncrypt encryptUseDES:password key:keyWithType(KeyType_PwdEncode, NO)] forKey:@"password"];
    [params setObject:@"uyzjdhds" forKey:@"client_secret"];
    [params setObject:@"password" forKey:@"grant_type"];
    [params setObject:@"erban-client" forKey:@"client_id"];
    [params setObject:@"1.0" forKey:@"version"];
    
    [params setValue:yiDunToken forKey:@"yiDunToken"];
    [params setValue:shuMeiDeviceId forKey:@"shuMeiDeviceId"];

    [HttpRequestHelper POST:method params:params success:^(id data) {
        
        AccountInfo *accoutInfo = [AccountInfo modelDictionary:data];
        if (accoutInfo != nil) {
            success(accoutInfo);
        } else {
            failure(nil, @"用户异常");
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        [TTStatisticsService trackEvent:@"login_failed" eventDescribe:message];
        if (failure) {
            failure(resCode, message);
        }
    }];
}

/// 一键登录
/// @param accessToken 营运商授权码
/// @param yiDunToken 易盾token
/// @param shuMeiDeviceId 数美deviceID
/// @param token 易盾token
+ (void)quickLoginAccessToken:(NSString *)accessToken
                   yiDunToken:(NSString *)yiDunToken
               shuMeiDeviceId:(NSString *)shuMeiDeviceId
                        token:(NSString *)token completionHandler:(HttpRequestHelperCompletion)completionHandler {
    NSString *method = @"acc/oneclick/login";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:token forKey:@"token"];
    [params setValue:accessToken forKey:@"accessToken"];
    [params setValue:shuMeiDeviceId forKey:@"shuMeiDeviceId"];
    [params setValue:yiDunToken forKey:@"yiDunToken"];
//    [params setValue:@"qingxun" forKey:@"app"];

    [self request:method
           method:HttpRequestHelperMethodPOST
           params:params
       completion:completionHandler];
}

/// 解除送礼1/2限额的短信验证
/// @param code 验证码
/// @param success 成功
/// @param failure 失败
+ (void)verificationSendGiftWithCode:(NSString *)code
                             success:(void (^)(BOOL success))success
                             failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    
    NSString *method = @"gift/send/sms/verify";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:code forKey:@"code"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        if (success) {
            success(YES);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

/// 用户登录删除相亲房数据
+ (void)loveRoomLoginDeleteUserDataSuccess:(void (^)(BOOL success))success
                                   failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    
    NSString *method = @"room/blindDate/delData";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:GetCore(AuthCore).getUid forKey:@"uid"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        if (success) {
            success(YES);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}
@end
