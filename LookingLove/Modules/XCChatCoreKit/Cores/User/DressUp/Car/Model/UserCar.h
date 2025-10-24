//
//  UserCar.h
//  BberryCore
//
//  Created by 卫明何 on 2018/2/27.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "DressUpModel.h"

typedef enum {
    Car_Status_down = 1, //已下架
    Car_Status_expire = 2, //已过期
    Car_Status_ok = 3 //正常
}Car_Status;

typedef enum : NSUInteger {
    UserCarPlaceTypeUserInfo, //个人页
    UserCarPlaceTypeCarPort, //车库
} UserCarPlaceType;

@interface UserCar : DressUpModel

@property (nonatomic, strong) NSString *carID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *pic;
@property (nonatomic, strong) NSString *effect; //svga
@property (nonatomic, assign) BOOL isUsed;
@property (nonatomic, assign) BOOL isGive;
@property (nonatomic, strong) NSString *days; //使用时间
@property (nonatomic, strong) NSString *nobleId;
@property (nonatomic, assign) NSInteger expireDate; //失效时间
@property (nonatomic, assign) Car_Status status; //状态

@property (nonatomic, strong) NSString  *mp4Url;
@property (nonatomic, strong) NSString  *mp4Key;
@property (nonatomic, strong) NSString  *nick;  //用户昵称
@property (nonatomic, strong) NSString  *avatar;    //用户头像
@end

@interface UserCarKey : BaseObject
@property (nonatomic, strong) NSString  *avatar;
@property (nonatomic, strong) NSString  *nick;
@end
