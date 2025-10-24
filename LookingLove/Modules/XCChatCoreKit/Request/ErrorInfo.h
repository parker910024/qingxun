//
//  ErrorInfo.h
//  Bberry
//
//  Created by KevinWang on 2018/6/2.
//  Copyright © 2018年 XC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"

@interface ErrorInfo : BaseObject
/**
 * 登录的接口 里面如果输入输入三次的话 就会用着判断 如果是1就需要谈输入验证码的view
 */
@property (nonatomic,assign) NSInteger codeVerify;
@property(nonatomic, strong) NSNumber *code;
@property(nonatomic, strong) NSString *message;

/**
 超管登录，服务器判断如果是超管登录，就需要是获取验证码之后才可以登录
 */
@property (nonatomic, assign) NSInteger superCodeVerify;

@end
