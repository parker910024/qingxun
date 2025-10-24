//
//  PrivilegeInfo.h
//  BberryCore
//
//  Created by 卫明何 on 2018/1/8.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PrivilegeInfo : NSObject

/**
 贵族对应id
 */
@property (nonatomic, assign) int id;

/**
 贵族名称
 */
@property (nonatomic, copy)   NSString *name;

/**
 首开金币
 */
@property (nonatomic, assign) NSInteger openGold;


/**
 续费金币
 */
@property (nonatomic, assign) NSInteger renewGold;

/**
 首开返还
 */
@property (nonatomic, assign) NSInteger openReturn;

/**
 续费返还
 */
@property (nonatomic, assign) NSInteger renewReturn;

/**
 公屏勋章
 */
@property (nonatomic, assign) BOOL screenMedal;

/**
 房间小卡片勋章
 */
@property (nonatomic, assign) BOOL roomMedal;

/**
 个人中心勋章
 */
@property (nonatomic, assign) BOOL userMedal;

/**
 贵族个人主页
 */
@property (nonatomic, assign) BOOL userPage;

/**
 开通特效
 */
@property (nonatomic, assign) BOOL openEffect;

/**
 开通/续费通知
 */
@property (nonatomic, assign) BOOL openNotice;

/**
 贵族礼物
 */
@property (nonatomic, assign) BOOL nobleGift;

/**
 专属表情
 */
@property (nonatomic, assign) BOOL specialFace;

/**
 进场欢迎
 */
@property (nonatomic, assign) BOOL enterNotice;

/**
 房间背景
 */
@property (nonatomic, assign) BOOL roomBackground;

/**
 上麦头像饰物
 */
@property (nonatomic, assign) BOOL micDecorate;

/**
 上麦说话光圈
 */
@property (nonatomic, assign) BOOL micHalo;

/**
 聊天气泡
 */
@property (nonatomic, assign) BOOL chatBubble;

/**
 隐身进入房间
 */
@property (nonatomic, assign) BOOL enterHide;

/**
 榜单隐身
 */
@property (nonatomic, assign) BOOL rankHide;

/**
 专属客服
 */
@property (nonatomic, assign) BOOL specialService;

/**
 靓号位数
 */
@property (nonatomic, assign) NSInteger goodNum;

/**
 防禁言，防下麦
 */
@property (nonatomic, assign) BOOL prevent;

/**
 推荐热门房间
 */
@property (nonatomic, assign) BOOL recomRoom;

@end
