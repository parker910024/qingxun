//
//  AuthCoreClient.h
//  CompoundUtil
//
//  Created by chenran on 2017/4/12.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccountInfo.h"
#import "TicketListInfo.h"
#import "AccountBindInfo.h"

@protocol AuthCoreClient <NSObject>
@optional
- (void)onNeedLogin;
- (void)onGetVisitorSuccess;
- (void)onGetVisitorFailth:(NSString *)errorMsg;
- (void)onRegistSuccess;
- (void)onRegistFailth:(NSString *)errorMsg;
- (void)onRegistFailth:(NSString *)errorMsg errorCode:(NSInteger)errorCode;
- (void)onRequestSmsCodeSuccess:(NSNumber *)type;
- (void)onRequestSmsCodeFailth:(NSString *)errorMsg;
- (void)onLoginSuccess;
- (void)thirdPartLoginCancel;//第三方登录取消
- (void)thirdPartLoginFailth; //第三方登录失败
// 第三方登录成功, 但还未开始请求自己的服务器登录 时的回调
- (void)thirdPartLoginSuccess;

- (void)onLoginFailth:(NSString *)errorMsg;
/// 登录失败回调带错误码
- (void)onLoginFailthCode:(NSInteger)code errorMsg:(NSString *)errorMsg;
- (void)onLogout;
- (void)onKicked;
- (void)onRequestTicket:(TicketListInfo *)ticketListInfo;
//重置登录密码成功
- (void)onResetPwdSuccess;
//重置登录密码失败
- (void)onResetPwdFailth:(NSString *)errorMsg;
//重置xcz密码成功
- (void)onResetPaymentPwdSuccess;
//重置xcz密码失败
- (void)onResetPaymentPwdFailth:(NSString *)errorMsg;
//设置支付密码
- (void)onSetPayPwd:(BOOL)success errorCode:(NSNumber *)code msg:(NSString *)msg;

- (void)onCutdownOpen:(NSNumber *)number;
- (void)onCutdownFinish;

//兔兔 判断qq登录是不是已绑定erban的用户
- (void)qqloginNotBindErBanInfor:(NSString *)qqOpenid;

// 获取用用户的邀请码
- (void)getShareCodeSuccess:(NSString *)shareCode;
- (void)getShareCodeFailth:(NSString *)errorMsg;

// 获取注册的图片验证码
- (void)getCaptchaImageDataSuccess:(UIImage *)image;
- (void)getCaptchaImageDataFailth:(NSString *)errorMsg;

#pragma mark - 登录的时候三次密码输错 @fengshuo
//发送验证码 成功|失败
- (void)onLoginImputFailSendCodeSuccess:(NSString *)messsage;
- (void)onLoginImputFailSendCodeFail:(NSString *)message;
//登录的时候输入失败 进行验证的时候 成功|失败
- (void)onloginImputFailVerifySuccess;
- (void)onloginImputFailVerifyFail:(NSString *)message;
//登录输入验证码失败三次的话 需要验证
- (void)onloginImputFailNeedVerifcial;

#pragma mark -
#pragma mark 超管登录 @fulong
/// 当登录用户是超管身份时 需要短信验证
- (void)onloginUserIsSuperAdminNeedVerifcial;

#pragma mark - Allo
/// 第三方获取信息成功
- (void)thirdPartLoginGetInfoSuccess:(AccountInfo *)info type:(ALThirdPartLoginType)type;

/// 获取账户绑定状态
- (void)getAccountBindInfoSuccess:(AccountBindInfo *)info;
- (void)getAccountBindInfoFailth:(NSString *)errorMsg;

// 第三方解绑
- (void)thirdUnbindSuccess:(AccountBindInfo *)info;
- (void)thirdUnbindFailth:(NSString *)errorMsg;

// 第三方绑定
- (void)thirdbindSuccess:(AccountBindInfo *)info;
- (void)thirdbindFailth:(NSString *)errorMsg;

// 完善用户信息后发出通知
- (void)fullinUserInfoSuccess;

// 登陆界面消失后的通知
- (void)loginViewControllerDismiss;

@end
