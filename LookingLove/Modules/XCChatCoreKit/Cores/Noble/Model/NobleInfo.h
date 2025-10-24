//
//  PeeragesInfo.h
//  BberryCore
//
//  Created by 卫明何 on 2018/1/8.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PrivilegeInfo.h"
#import "NobleSourceInfo.h"
#import "NSObject+YYModel.h"

@interface NobleInfo : NSObject

typedef enum {
    NobleSource_badge = 1, //勋章
    NobleSource_headerwear = 2, //头饰
    NobleSource_cardbg = 3, //小卡片背景
    NobleSource_zonebg = 4, //个人页背景
    NobleSource_open_effect = 5, //开通特效
    NobleSource_banner = 6, // 横幅
    NobleSource_bubble = 7, //聊天气泡
    NobleSource_halo = 8, //光晕
    NobleSource_wingBadge = 9, //翅膀勋章
}NobleSource;



/**
 //贵族等级对应枚举 //可配置，所以不能写死枚举
 */
@property (nonatomic, assign) NSInteger level;

/**
 //特权信息
 */
@property (nonatomic, strong) PrivilegeInfo *privilegeInfo;

/**
 //勋章
 */
@property (nonatomic, strong) NobleSourceInfo *badge;

/**
 //头饰
 */
@property (nonatomic, strong) NobleSourceInfo *headerwear;

/**
 //小卡片背景
 */
@property (nonatomic, strong) NobleSourceInfo *cardbg;

/**
 //个人页背景
 */
@property (nonatomic, strong) NobleSourceInfo *zonebg;

/**
 //开通特效
 */
@property (nonatomic, strong) NobleSourceInfo *open_effect;

/**
 //横幅
 */
@property (nonatomic, strong) NobleSourceInfo *banner;

/**
 //聊天气泡
 */
@property (nonatomic, strong) NobleSourceInfo *bubble;

/**
 //光晕
 */
@property (nonatomic, strong) NobleSourceInfo *halo;

/**
 //皇帝推荐
 */
@property (nonatomic, strong) NobleSourceInfo *recommend;
@end
