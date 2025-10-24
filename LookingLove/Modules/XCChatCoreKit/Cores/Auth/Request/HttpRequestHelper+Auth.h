//
//  HttpRequestHelper+Auth.h
//  BberryCore
//
//  Created by chenran on 2017/3/5.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "HttpRequestHelper.h"
#import "AccountInfo.h"
#import "TicketListInfo.h"

@class AccountBindInfo;

@interface HttpRequestHelper (Auth)

/**
 判断手机是否绑定
 
 @param success 成功
 @param failure 失败
 */
+ (void)judgeIsBindingPhoneWithsuccess:(void (^)(BOOL isbinding))success
                               failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/**
 URL渠道统计

 @param url URL
 @param success 成功
 @param failure 失败
 */
+ (void)statisticsWithURL:(NSURL *)url
                  success:(void (^)(BOOL isSuccess))success
                  failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/**
 通过微信openID登录

 @param openID 微信openID
 @param success 成功
 @param failure 失败
 */
+ (void)loginWithWeChatOpenID:(NSString *)openID
                   andUnionID:(NSString *)unionID
                 access_token:(NSString *)access_token
                      andType:(XCThirdPartLoginType)type
                      success:(void (^)(AccountInfo *accountInfo))success
                      failure:(void (^)(NSNumber *resCode, NSString *message))failure;
+ (void)loginWithWeChatOpenID:(NSString *)openID
                   andUnionID:(NSString *)unionID
                 access_token:(NSString *)access_token
                   yiDunToken:(NSString *)yiDunToken
               shuMeiDeviceId:(NSString *)shuMeiDeviceId
                      andType:(XCThirdPartLoginType)type
                      success:(void (^)(AccountInfo *accountInfo))success
                      failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/// 第三方登陆
/// @param openID 第三方 openID
/// @param unionID 第三方 unionID
/// @param access_token 第三方 access_token
/// @param yiDunToken 易盾防护 token
/// @param shuMeiDeviceId 数美deviceID
/// @param type 1：微信登录 2：QQ登录 3：手机号 4：苹果ID   登录类型
/// @param fullName 当类型等于 4：苹果id 登录的时候 必填。
+ (void)loginWithThirdPartOpenID:(NSString *)openID
                   andUnionID:(NSString *)unionID
                 access_token:(NSString *)access_token
                   yiDunToken:(NSString *)yiDunToken
               shuMeiDeviceId:(NSString *)shuMeiDeviceId
                      andType:(XCThirdPartLoginType)type
                appleFullName:(NSString *)fullName
                      success:(void (^)(AccountInfo *accountInfo))success
                      failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/**
 获取游客账号

 @param success 成功
 @param failure 失败
 */
+ (void)getVisitor:(void (^)(AccountInfo *accountInfo))success
           failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 注册

 @param phone 手机
 @param password 密码
 @param smsCode 验证码
 @param success 成功
 @param failure 失败
 */
+ (void)regist:(NSString *)phone
      password:(NSString *)password
       smsCode:(NSString *)smsCode
       success:(void (^)(void))success
       failure:(void (^)(NSNumber *resCode, NSString *message))failure;


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
+ (void)regist:(NSString *)phone
      password:(NSString *)password
       smsCode:(NSString *)smsCode
    verifyCode:(NSString *)verifyCode
         token:(NSString *)token
shuMeiDeviceId:(NSString *)shuMeiDeviceId
       success:(void (^)(void))success
       failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 登录
 
 @param phone 手机
 @param password 密码
 @param success 成功
 @param failure 失败
 */
+ (void)login:(NSString *)phone
     password:(NSString *)password
      success:(void (^)(AccountInfo *accountInfo))success
      failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/**
 登出

 @param accessToken token
 @param success 成功
 @param failure 失败
 */
+ (void)logout:(NSString *)accessToken
       success:(void (^)(void))success
       failure:(void (^)(NSNumber *resCode, NSString *message))failure;



/**
 获取ticket
 
 @param accessToken token
 @param success 成功
 @param failure 失败
 */
+ (void)requestTicket:(NSString *)accessToken
              success:(void (^)(TicketListInfo *ticketInfo))success
              failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/**
 获取验证码

 @param phone 手机
 @param type 类型 1注册 2登录 3修改密码
 @param success 成功
 @param failure 失败
 */
+ (void)requestSmsCode:(NSString *)phone type:(NSNumber *)type
               success:(void (^)(void))success
               failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/**
 设置登录密码

 @param phone 手机
 @param newPwd 密码
 @param smsCode 短信验证码
 @param success 成功
 @param failure 失败
 */
+ (void)requestResetPwd:(NSString *)phone
                 newPwd:(NSString *)newPwd
                smsCode:(NSString *)smsCode
                success:(void (^)(void))success
                failure:(void (^)(NSNumber *resCode, NSString *message))failure;



/**
 修改登录密码

 @param phone 手机
 @param pwd 密码
 @param newPwd 新密码
 @param success 成功
 @param failure 失败
 */
+ (void)requestModifyPwd:(NSString *)phone
                     pwd:(NSString *)pwd
                  newPwd:(NSString *)newPwd
                 success:(void (^)(void))success
                 failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/**
 设置登录密码

 @param phone 手机号码
 @param newPwd 密码
 @param success 成功
 @param failure 失败
 */
+(void)requestSetPwd:(NSString *)phone
              newPwd:(NSString *)newPwd
             success:(void (^)(void))success
             failure:(void (^)(NSNumber *, NSString *))failure;

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
                              failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/**
 重置xcz密码
 
 @param pwd xcz密码
 @param success 成功
 @param failure 失败
 */
+ (void)resetPaymentPwdWith:(NSString *)pwd
                    success:(void (^)(BOOL success))success
                    failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/// 设置支付密码
/// @param pwd 密码
/// @param phone 手机号（某些版本可以不用手机号验证码，这里手机号其实不需要，服务端处理）
/// @param code 验证码
+ (void)requestSetPayPwd:(NSString *)pwd phone:(NSString *)phone verifyCode:(NSString *)code completion:(HttpRequestHelperCompletion)completion;

/**
 兔兔判断qq登录是不是可用

 @param qqOpenid qqOpenid
 @param success 成功
 @param failure 失败
 */
+ (void)qqloginIsNewuserWith:(NSString *)qqOpenid success:(void (^)(BOOL success))success
                     failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/**
 通过erban id登录

 @param erbanId erban id
 @param password 密码
 @param success 成功
 @param failure 失败
 */
+ (void)loginWithbindErBanAccount:(NSString *)erbanId password:(NSString *)password qqOpenid:(NSString *)qqOpenid  success:(void (^)(AccountInfo *))success failure:(void (^)(NSNumber *, NSString *))failure;


/**
 获取用户的邀请码

 @param uid uid
 @param success 成功
 @param failure 失败
 */
+ (void)getShareCodeWithUid:(NSString *)uid success:(void (^)(NSString *))success failure:(void (^)(NSNumber *, NSString *))failure;

/**
 第三方登录_获取access_token
 
 @param uid 第三方返回的uid QQ和微信为openid,海外第三方登录为userID
 @param type 类型 登录账户类型:1.微信;2.qq;3.萌声号或手机号;4.facebook;5.google+;6.instagram;7.twitter;
 @param success 成功
 @param failure 失败
 */
+ (void)thirdLogin:(NSString *)uid type:(ALThirdPartLoginType)type success:(void (^)(AccountInfo *accountInfo))success
           failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 获取第三方绑定信息

 @param success 成功
 @param failure 失败
 */
+ (void)getAccountBindInfo:(void (^)(AccountBindInfo *accountInfo))success
failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 第三方账户信息解绑

 @param type 第三方类型
 @param openId 第三方 uid
 @param success 成功
 @param failure 失败
 */
+ (void)thirdUnbindWithType:(ALThirdPartLoginType)type openid:(NSString *)openId success:(void (^)(AccountInfo *accountInfo))success
                    failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 第三方账户信息绑定
 
 @param type 第三方类型
 @param openId 第三方 uid
 @param success 成功
 @param failure 失败
 */
+ (void)thirdBindWithType:(ALThirdPartLoginType)type openid:(NSString *)openId success:(void (^)(AccountInfo *accountInfo))success
                    failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 请求图片验证码

 @param phone 手机号
 @param success 成功
 @param failure 失败
 */
+ (void)requestCaptchaImageDataWithPhone:(NSString *)phone success:(void (^)(UIImage *))success failure:(void (^)(NSNumber *, NSString *))failure;

#pragma mark - 登录的时候输入验证码错误三次
/**
 发送验证码
 @param phone 兔兔号或者手机号
 */
+ (void)verificationCodeFailSendCodeWith:(NSString *)phone
                                 success:(void (^)(NSString * message))success
                                 failure:(void (^)(NSNumber *resCode, NSString *message))failure;

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
      failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/// 一键登录
/// @param accessToken 营运商授权码
/// @param yiDunToken 易盾token
/// @param shuMeiDeviceId 数美deviceID
/// @param token 易盾token
+ (void)quickLoginAccessToken:(NSString *)accessToken
                   yiDunToken:(NSString *)yiDunToken
               shuMeiDeviceId:(NSString *)shuMeiDeviceId
                        token:(NSString *)token completionHandler:(HttpRequestHelperCompletion)completionHandler;

/// 解除送礼1/2限额的短信验证
/// @param code 验证码
/// @param success 成功
/// @param failure 失败
+ (void)verificationSendGiftWithCode:(NSString *)code
                             success:(void (^)(BOOL success))success
                             failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/// 用户登录删除相亲房数据
+ (void)loveRoomLoginDeleteUserDataSuccess:(void (^)(BOOL success))success
                                   failure:(void (^)(NSNumber *resCode, NSString *message))failure;
@end
