//
//  QQUserInfo.h
//  BberryCore
//
//  Created by gzlx on 2017/8/18.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"

@interface QQUserInfo : BaseObject

//user:{
//    city = "北海道";
//    figureurl = "http://qzapp.qlogo.cn/qzapp/1106219931/C5A6D73685A853BFAB619B4068AAA3C0/30";
//    "figureurl_1" = "http://qzapp.qlogo.cn/qzapp/1106219931/C5A6D73685A853BFAB619B4068AAA3C0/50";
//    "figureurl_2" = "http://qzapp.qlogo.cn/qzapp/1106219931/C5A6D73685A853BFAB619B4068AAA3C0/100";
//    "figureurl_qq_1" = "http://q.qlogo.cn/qqapp/1106219931/C5A6D73685A853BFAB619B4068AAA3C0/40";
//    "figureurl_qq_2" = "http://q.qlogo.cn/qqapp/1106219931/C5A6D73685A853BFAB619B4068AAA3C0/100";
//    gender = "女";
//    "is_lost" = 0;
//    "is_yellow_vip" = 0;
//    "is_yellow_year_vip" = 0;
//    level = 0;
//    msg = "";
//    nickname = "百变小音后";
//    province = "";
//    ret = 0;
//    vip = 0;
//    "yellow_vip_level" = 0;
//}

@property (copy, nonatomic) NSString *gender;
@property (copy, nonatomic) NSString *figureurl_qq_2;
@property (copy, nonatomic) NSString *nickname;
@property (copy, nonatomic) NSString *openID;

@end
