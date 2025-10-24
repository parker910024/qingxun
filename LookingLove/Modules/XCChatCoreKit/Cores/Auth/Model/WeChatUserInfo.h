//
//  WeChatUserInfo.h
//  BberryCore
//
//  Created by gzlx on 2017/7/18.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"

@interface WeChatUserInfo : BaseObject

//city = Guangzhou;
//country = CN;
//headimgurl = "http://wx.qlogo.cn/mmhead/PiajxSqBRaEIWAbAEuVPe5MIicZcP8dJY7kMgwaMJvnfqYaN5RwYYrqQ/0";
//language = "zh_CN";
//nickname = Simon;
//openid = oIr2PxEpVlJ4drrk3SoZwSysQiAA;
//privilege =     (
//);
//province = Guangdong;
//sex = 1;
//unionid = oNKkdwnLenm6z2iQAxnemrDXS5Fc;

@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *country;
@property (nonatomic, copy) NSString *headimgurl;
@property (nonatomic, copy) NSString *language;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *openid;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *unionid;

@end
