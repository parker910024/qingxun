//
//  HomeV5CategoryRoom.h
//  XCChatCoreKit
//
//  Created by lvjunhang on 2019/6/12.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  分类下的房间模型

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeV5CategoryRoom : BaseObject

@property (nonatomic, copy) NSString *uid;//uid
@property (nonatomic, copy) NSString *avatar;//头像
@property (nonatomic, assign) NSInteger roomId;//房间id
@property (nonatomic, copy) NSString *title;//房间标题
@property (nonatomic, assign) NSInteger tagId;//标签id
@property (nonatomic, copy) NSString *roomTag;//房间标签
@property (nonatomic, strong) NSString *tagPict;//标签图片地址
@property (nonatomic, assign) NSInteger type;//房间类型
@property (nonatomic, assign) NSInteger onlineNum;//在线人数
@property (nonatomic, strong) NSString *badge;//角标
//@property (nonatomic, copy) NSString *roomDesc;//房间描述
@property (nonatomic, assign) BOOL valid;//房间状态- 开启或者关闭
@property (nonatomic, assign) NSInteger tabId;//tab主键
@property (nonatomic, copy) NSString *tabName;//tab名称
@property (nonatomic, copy) NSString *roomPwd;//房间密码

//101直播
@property (nonatomic, assign) BOOL liveTag;
//@property (nonatomic, copy) NSString *skillTag;//101 技能标签图片
@property (nonatomic, assign) BOOL isRedPack; // 是否用红包标识

@end

NS_ASSUME_NONNULL_END
