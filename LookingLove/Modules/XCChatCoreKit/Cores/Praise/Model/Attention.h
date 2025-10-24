//
//  Attention.h
//  BberryCore
//
//  Created by gzlx on 2017/7/10.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"
#import "UserInfo.h"
#import "RoomInfo.h"
@interface Attention : BaseObject
/**
 *身份 官方 机器人
 */
@property (nonatomic,assign) AccountType defUser;
@property (nonatomic, assign) UserID uid;
@property (nonatomic, assign) BOOL valid;
@property (nonatomic, copy) NSString *avatar;
@property (copy, nonatomic) NSString *nick;
@property (assign, nonatomic) UserGender gender;
@property (copy, nonatomic) NSString *title;
@property (assign, nonatomic) NSInteger operatorStatus;
@property (assign, nonatomic) RoomType type;
@property (assign, nonatomic) NSInteger fansNum;
@property (nonatomic, strong) RoomInfo *userInRoom;
@property (nonatomic, strong) SingleNobleInfo *nobleUsers;
@property(nonatomic, strong)  LevelInfo *userLevelVo;
@property (nonatomic, strong) NSString * userDesc;
@end
