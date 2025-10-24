//
//  MTErrorCodeMessage.m
//  Bberry
//
//  Created by KevinWang on 2018/6/2.
//  Copyright © 2018年 XC. All rights reserved.
//

#import "XCHTTPErrorCodeMessage.h"

@implementation XCHTTPErrorCodeMessage

+ (NSString *)errorMessage:(int)resCode{
    NSString *message = nil;
    switch (resCode) {
        case 107:
            message =  @"密码错误";
            break;
        case 109:
            message = @"用户不存在";
            break;
        case 110:
            message = @"用户已被冻结";
            break;
        case 111:
            message = @"用户不存在或密码错误";
            break;
        case 150:
            message = @"验证码错误";
            break;
        case 151:
            message = @"手机号不可用";
            break;
        case 153:
            message = @"重置密码无效";
            break;
        case 161:
            message = @"昵称不合法";
            break;
        case 401:
            message = @"ticket失效";
            break;
        case 10108:
            message = @"需要先实名认证";
            break;
        default:
            message = @"服务器正在维护";
            break;
    }
    return message;
}


@end
