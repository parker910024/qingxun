//
//  UserHeadWear.h
//  BberryCore
//
//  Created by Macx on 2018/5/11.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "DressUpModel.h"


/*
 {
    "headwearId":1,
    "name":"皇帝头饰",
    "pic":"",
    "effect":"",
    "price":1500,
    "renewPrice":1500,
    "seq":1,
    "enable":true,
    "status":1,
    "days":15,
    "nobleLimit":true,
    "monsterLimit":false,
    "weekStarLimit":false,
    "createTime":1525972020984,
    "updateTime":1525972020984,
    "timeInterval":1
 }
 */


typedef enum {
    Headwear_Status_ok = 1, //有效
    Headwear_Status_expire = 2,//已过期
    Headwear_Status_down = 3//已下架
}Headwear_Status;

typedef enum : NSUInteger {
    UserHeadwearPlaceTypeUserInfo, //个人页
    UserHeadwearPlaceTypeHeadwearPort, //头饰库
} UserHeadwearPlaceType;



@interface UserHeadWear : DressUpModel
/**  头饰 start **/
@property (nonatomic, strong) NSString  *headwearId;// 头饰id
@property (nonatomic, assign) Headwear_Status  status;//
@property (nonatomic, strong) NSString  *name;//头饰名称
@property (nonatomic, strong) NSString  *pic; // 预览图链接
@property (nonatomic, strong) NSString  *effect;//效果

@property (nonatomic, strong) NSString  *seq;//排序
@property (nonatomic, assign) BOOL  enable;//是否启用，
@property (nonatomic, assign) BOOL  isUsed;//
@property (nonatomic, strong) NSString  *comeFrom;//来源，1购买，2用户赠

@property (nonatomic, strong) NSString  *days;//有效天数
@property (nonatomic, strong) NSString  *expireDays;//还有过期

@property (assign , nonatomic) int timeInterval;//帧长 毫秒
@property (assign , nonatomic) CGFloat frameDurations;//帧长 秒
// 2019年03月25日 公会线添加萝卜相关属性
@property (nonatomic, assign) BOOL isSale; // 是否售卖
/**  头饰 end **/

/** 头饰账单 start **/
/*
 {
 "uid":890001,
 "headwearId":1,
 "headwearName":"皇帝头饰",
 "pic":"",
 "effect":"",
 "used":true,
 "status":1,
 "buyTime":1525972020984,
 "expireTime":1525982020984
 }
 */
@property (nonatomic, strong) NSString  *uid;//
@property (nonatomic, strong) NSString  *headwearName;//
@property (nonatomic, strong) NSString  *buyTime;//购买时间
@property (nonatomic, strong) NSString  *expireTime;//过期时间

/** 头饰账单 end **/


//帧长 毫秒
- (CGFloat)frameDurations;

@end
