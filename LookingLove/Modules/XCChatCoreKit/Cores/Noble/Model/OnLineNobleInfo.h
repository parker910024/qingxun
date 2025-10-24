//
//  OnLineNobleInfo.h
//  BberryCore
//
//  Created by Mac on 2018/1/17.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "BaseObject.h"
#import "SingleNobleInfo.h"
#import "UserInfo.h"
//头像   avatar
//贵族信息  nobleUsers
//昵称   nick
//性别   gender
//Uid     uid

@interface OnLineNobleInfo : BaseObject
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *nick;
@property (nonatomic, assign) UserGender gender;
@property (nonatomic, assign) UserID uid;
@property (nonatomic, strong) SingleNobleInfo *nobleUsers;


@end
