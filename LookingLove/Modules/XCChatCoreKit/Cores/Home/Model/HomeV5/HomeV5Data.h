//
//  HomeV5Data.h
//  XCChatCoreKit
//
//  Created by lvjunhang on 2019/6/6.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  首页数据

#import "BaseObject.h"
#import "SingleNobleInfo.h"
#import "LevelInfo.h"
#import "UserInfo.h"

NS_ASSUME_NONNULL_BEGIN

@class HomeV5RoomData;
@class UserOfficialAnchorCertification;

@interface HomeV5Data : BaseObject

//是否是推荐房间，（优先判断，如果是true，则房间信息从roomVo对象取值)
@property (nonatomic, assign) BOOL recommendRoom;

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, assign) UserGender gender;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, copy) NSString *nick;
@property (nonatomic, copy) NSString *avatar;

@property (nonatomic, assign) CGFloat distance;//距离
@property (nonatomic, copy) NSString *distanceStr;//距离 带单位

//状态: 1 开启了ktv，2 开启了游戏，3 在房间中，0 无状态，显示标签
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *desc;//状态，标签描述

@property (nonatomic, assign) NSInteger onlineNum;//在线人数

@property (nonatomic, assign) BOOL liveTag;//是否为 101
@property (nonatomic, copy) NSString *skillTag;//101标签图标

//贵族信息
@property(nonatomic, strong) SingleNobleInfo *nobleUsers;

//用户等级
@property(nonatomic, strong) LevelInfo *userLevelVo;

//房间信息
@property (nonatomic, strong) HomeV5RoomData *roomVo;

//官方主播认证
@property (nonatomic, strong) UserOfficialAnchorCertification *nameplate;

@end

/**
 首页里的房间
 */
@interface HomeV5RoomData : BaseObject
@property (nonatomic, copy) NSString *uid;//uid
@property (nonatomic, copy) NSString *avatar;//头像
@property (nonatomic, assign) NSInteger roomId;//房间id
@property (nonatomic, copy) NSString *title;//房间标题
@property (nonatomic, assign) NSInteger tagId;//标签id
@property (nonatomic, strong) NSString *tagPict;//标签图片地址
@property (nonatomic, assign) NSInteger onlineNum;//在线人数
@property (nonatomic, strong) NSString *icon;//live 图标
@property (nonatomic, strong) NSString *badge;//角标
@property (nonatomic, copy) NSString *desc;//描述

//101直播
@property (nonatomic, assign) BOOL liveTag;
@property (nonatomic, copy) NSString *skillTag;//101 技能图片

@end

NS_ASSUME_NONNULL_END
