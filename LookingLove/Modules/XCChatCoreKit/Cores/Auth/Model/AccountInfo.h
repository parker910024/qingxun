//
//  AccountInfo.h
//  CompoundUtil
//
//  Created by chenran on 2017/4/12.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"

typedef NS_ENUM(NSInteger,XCThirdPartLoginType) {
    XCThirdPartLoginWechat = 1, // 微信登录
    XCThirdPartLoginQQ = 2, // QQ登录
    XCThirdPartLoginPhoneNum = 3, // 手机号登录
    XCThirdPartLoginApple = 5, // 苹果id登录
};

typedef NS_ENUM(NSInteger,ALThirdPartLoginType) {
    ALThirdPartLoginWechat = 1,
    ALThirdPartLoginQQ = 2,
    ALThirdPartLoginPhone = 3,
    ALThirdPartLoginFacebook = 4,
    ALThirdPartLoginGoogle = 5,
    ALThirdPartLoginInstagram = 6,
    ALThirdPartLoginTwitter = 7,
};

@interface AccountInfo : BaseObject<NSCopying>
@property(nonatomic, strong)NSString *access_token;
@property(nonatomic, strong)NSString *uid;
@property(nonatomic, strong)NSString *netEaseToken;
@property(nonatomic, strong)NSString *token_type;
@property(nonatomic, strong)NSString *refresh_token;
@property(nonatomic, strong)NSNumber *expires_in;
@property(nonatomic, strong)NSString *scope;
@property(nonatomic, strong)NSString *jti;
@end
