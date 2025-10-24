//
//  UserBackground.h
//  BberryCore
//
//  Created by Macx on 2018/6/20.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "DressUpModel.h"

typedef enum {
    //状态(1、正常 2、过期)
    BackgroundStatus_ok = 1, //有效
    BackgroundStatus_expire = 2//已过期
}BackgroundStatus;


typedef enum {
    BackgroundEable_enable = 1,//上架
    BackgroundEable_disable = 2,//下架
}BackgroundEnableStatus;



@interface UserBackground : DressUpModel

@property (nonatomic, strong) NSString  *backgroundId;//
@property (nonatomic, assign) BackgroundStatus  status;//背景状态 状态(1、正常 2、过期)
@property (nonatomic, assign) BOOL  isLimit;//限定类型

@property (nonatomic, strong) NSString  *name;//背景名称
@property (nonatomic, strong) NSString  *pic;//背景图片
@property (nonatomic, strong) NSString  *icon;//背景图标
@property (nonatomic, strong) NSString  *effect;//效果

@property (nonatomic, assign) BackgroundEnableStatus  enable;//是否下架
@property (nonatomic, assign) BOOL  used;//是否正在使用
@property (nonatomic, assign) BOOL  isFree;//是否免费商品


@property (nonatomic, strong) NSString  *comeFrom;//来源，1购买，2用户赠

@property (nonatomic, strong) NSString  *days;//时限
@property (nonatomic, strong) NSString  *expireDays;//剩余天数

//本地更多icon使用
@property (nonatomic, strong) NSString *localMoreIconImageName;

@end
