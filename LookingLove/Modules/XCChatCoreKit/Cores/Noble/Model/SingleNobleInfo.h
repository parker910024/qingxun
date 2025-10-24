//
//  SingleNobleInfo.h
//  BberryCore
//
//  Created by 卫明何 on 2018/1/10.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "BaseObject.h"

@interface SingleNobleInfo : BaseObject

/**
 贵族名称
 */
@property (nonatomic, copy) NSString *nobleName;

/**
 推荐热门剩余次数
 */
@property (nonatomic, assign) NSInteger recomCount;

/**
 排行榜隐身
 */
@property (nonatomic, assign) BOOL rankHide;

/**
 进入房间隐身
 */
@property (nonatomic, assign) BOOL enterHide;

/**
 过期
 */
@property (nonatomic, assign) long expire;

/**
 靓号
 */
@property (nonatomic, copy) NSString *goodNum;
/**
 等级
 */
@property (nonatomic, assign) NSInteger level;

/**
 徽章
 */
@property (nonatomic, strong) id badge;

/**
 头饰
 */
@property (nonatomic, strong) id headwear;


/**
 头饰效果地址
 */

@property (nonatomic, strong) NSString *pic;

/**
 头饰 帧率
 */

@property (nonatomic, assign) int timeInterval;


/**
 卡片背景
 */
@property (nonatomic, strong) id cardbg;

/**
 个人页背景
 */
@property (nonatomic, strong) id zonebg;

/**
 房间背景
 */
@property (nonatomic, strong) id roombg;

/**
 开通特效
 */
@property (nonatomic, strong) id open_effect;

/**
 横幅
 */
@property (nonatomic, strong) id banner;

/**
 聊天气泡
 */
@property (nonatomic, strong) id bubble;

/**
 说话光圈
 */
@property (nonatomic, strong) id halo;

/**
 带翅膀勋章
 */
@property (nonatomic, strong) id wingBadge;


/**
 序列化字典
 */
@property(nonatomic, strong)NSDictionary *encodeAttachemt;

@end
