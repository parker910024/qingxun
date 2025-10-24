//
//  AuthCore.h
//  CompoundUtil
//
//  Created by chenran on 2017/4/12.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "BaseCore.h"
#import "TicketListInfo.h"
#import "AccountInfo.h"
#import "AccountBindInfo.h"
#import "HttpRequestHelper+Auth.h"
#import <ShareSDK/ShareSDK.h>
#import "WeChatUserInfo.h"
#import "QQUserInfo.h"
#import "AppleAccountInfo.h"

@interface AuthCore : BaseCore

@property (nonatomic, strong) WeChatUserInfo *info;
@property (nonatomic, strong) QQUserInfo *qqInfo;
@property (nonatomic, strong) AppleAccountInfo *appleInfo;
@property (nonatomic, assign) BOOL isNewRegister;

@property (strong, nonatomic) dispatch_source_t timer;
@property (strong, nonatomic) NSTimer *requestTimer;
@property (strong, nonatomic) NSTimer *retryTimer;

- (BOOL)isLogin;
-(NSString *)getTicket;
-(NSString *)getUid;
-(NSString *)getNetEaseToken;

- (void)regist:(NSString *)phone password:(NSString *)password smsCode:(NSString *)smsCode;
/**
 TT 新的注册接口

 @param phone 手机号
 @param password 密码
 @param smsCode 短信验证码
 @param verifyCode 图片验证码 没有测传@""
 @param token 易盾token
 @param shuMeiDeviceId 数美设备id
 */
- (void)regist:(NSString *)phone password:(NSString *)password smsCode:(NSString *)smsCode verifyCode:(NSString *)verifyCode token:(NSString *)token shuMeiDeviceId:(NSString *)shuMeiDeviceId;
- (void)login:(NSString *)phone password:(NSString *)password;
- (void)autoLogin;
- (void)logout;
- (void)kicked;
- (void)requestTicket;
- (void)openCountdown;
- (void)requestRegistSmsCode:(NSString *)phone;
- (void)requestLoginSmsCode:(NSString *)phone;
- (void)requestResetSmsCode:(NSString *)phone;
// 业务类型，必填，1注册，2登录，3重设密码，4绑定手机，5绑定xczAccount，6重设xcz密码，7解绑手机
- (void)requestSmsCode:(NSString *)phone type:(NSNumber *)type;
- (void)requestResetPwd:(NSString *)phone newPwd:(NSString *)newPwd smsCode:(NSString *)smsCode;
- (void)stopCountDown; //关闭定时器

- (void)wechatLoginPlatform:(SSDKPlatformType)platfor;//微信获取用户信息
- (void)qqLoginPlatform:(SSDKPlatformType)platfor;//QQ获取用户信息

/**
 第三方登录

 @param platfor 平台
 @param yiDunToken 易盾token
 @param shuMeiDeviceId 数美deviceID
 */
- (void)thirdLoginPlatform:(SSDKPlatformType)platfor
                yiDunToken:(NSString *)yiDunToken
            shuMeiDeviceId:(NSString *)shuMeiDeviceId;
/**
第三方登录

@param platfor 平台
@param yiDunToken 易盾token
@param shuMeiDeviceId 数美deviceID
@param isNewUser YES是老用户  NO是新用户
*/
- (void)thirdLoginPlatform:(SSDKPlatformType)platfor
                yiDunToken:(NSString *)yiDunToken
            shuMeiDeviceId:(NSString *)shuMeiDeviceId
                 isNewUser:(BOOL)isNewUser;

/// 一键登录
/// @param accessToken 营运商授权 token
/// @param yiDunToken 易盾token
/// @param shuMeiDeviceId 数美deviceID
/// @param token 易盾token
- (void)quickLoginAccessToken:(NSString *)accessToken
                   yiDunToken:(NSString *)yiDunToken
               shuMeiDeviceId:(NSString *)shuMeiDeviceId
                        token:(NSString *)token;
/**
 修改  xcz密码

 @param oldPasswd 旧密码
 @param newPasswd 新密码
 */
- (void)modifyPaymentPasswordWitholdPassword:(NSString *)oldPasswd
                                      newPassword:(NSString *)newPasswd;


/**
 重置 xcz密码

 @param pwd xcz密码
 */
- (void)resetPaymentPasswordWithPwd:(NSString *)pwd;

/// 设置支付密码
/// @param pwd 密码
/// @param phone 手机号（某些版本可以不用手机号验证码，这里手机号其实不需要，服务端处理）
/// @param code 验证码
- (void)requestSetPayPwd:(NSString *)pwd phone:(NSString *)phone verifyCode:(NSString *)code;

/**
 修改登录密码

 @param phone 手机
 @param pwd 旧密码
 @param newPwd 新密码
 */
- (void)requestModifyPwd:(NSString *)phone
                     pwd:(NSString *)pwd
                  newPwd:(NSString *)newPwd;

/**
 设置登录密码

 @param phone 手机
 @param newPwd 新密码
*/
- (void)requestSetPwd:(NSString *)phone
                  newPwd:(NSString *)newPwd;


/**
 第三方登录

 @param openID 第三方openID
 @param unionID 第三方unionID
 */
- (void)loginWithOpenID:(NSString *)openID
             andUnionID:(NSString *)unionID
           access_token:(NSString *)access_token
                andType:(XCThirdPartLoginType)type;



/**
 统计接口

 @param url 渠道URL
 */
- (void)statisticsWith:(NSURL *)url;

//是否绑定手机do
- (void)isBindingPhoneSuccess:(void (^)(BOOL isbinding))success;

//qq链接 是不是erban的用户
- (void)qqLoginPlatform:(SSDKPlatformType)platfor isNewUser:(BOOL)isNewUser;
/** erban登录兔兔*/
- (void)loginWithErbanAccount:(NSString *)erbanId password:(NSString *)password qqOpenid:(NSString *)qqOpenid;


/**
 请求用户的邀请码

 @param uid uid
 */
- (void)requestShareCodeWithUid:(NSString *)uid;

/**
 请求图片验证码

 @param phone 手机号
 */
- (void)requestCaptchaImageDataWithPhone:(NSString *)phone;

#pragma mark - Allo项目
/// 第三方登录获取用户信息 isLogin YES 登录 NO 绑定/解绑
- (void)thirdLoginPlatfor:(SSDKPlatformType)platfor isLogin:(BOOL)isLogin;

/// 获取用户绑定状态
- (void)getAccountBindInfo;

/// 账号解绑第三方
- (void)thirdUnBindPlatfor:(SSDKPlatformType)platfor openId:(NSString *)openId;

/// 账号绑定第三方
- (void)thirdBindPlatfor:(ALThirdPartLoginType)platfor openId:(NSString *)openId;

#pragma mark - 登录的时候 输入密码三次以上 @fengshuo
/**
 发送验证码
 */
- (void)verificationSendCodeWithPhone:(NSString *)phone;

/// 点击登录
/// @param phone 手机号
/// @param password 密码
/// @param code 验证码
/// yiDunToken 云盾token = nil
/// shuMeiDeviceId 数美ID = nil
- (void)login:(NSString *)phone password:(NSString *)password code:(NSString *)code;

/// 点击登录
/// @param phone 手机号
/// @param password 密码
/// @param code 验证码
/// @param yiDunToken 云盾token
/// @param shuMeiDeviceId 数美ID
- (void)login:(NSString *)phone password:(NSString *)password code:(NSString *)code yiDunToken:(NSString *)yiDunToken shuMeiDeviceId:(NSString *)shuMeiDeviceId;

/// 解除送礼1/2限额的短信验证
/// @param code 验证码
- (RACSignal *)getVerificationSendGiftWithCode:(NSString *)code;

/// 用户登录删除相亲房数据
- (void)loveRoomLoginDeleteUserData;
@end
