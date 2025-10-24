//
//  TTRoomSettingRowConfig.h
//  TuTu
//
//  Created by lvjunhang on 2018/11/6.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTRoomSettingsCell.h"

NS_ASSUME_NONNULL_BEGIN

/**
 房间设置 cell 类型
 
 - TTRoomSettingsCellStyleArrow: 只有箭头
 - TTRoomSettingsCellStyleImage: 只有图片
 - TTRoomSettingsCellStyleContentArrow: 内容+箭头
 - TTRoomSettingsCellStyleSwitch: switch 开关
 - TTRoomSettingsCellStyleSwitchDetail: switch 开关 + 打开的带有描述
 */
typedef NS_ENUM(NSUInteger, TTRoomSettingsCellStyle) {
    TTRoomSettingsCellStyleArrow,
    TTRoomSettingsCellStyleImage,
    TTRoomSettingsCellStyleContentArrow,
    TTRoomSettingsCellStyleSwitch,
    TTRoomSettingsCellStyleSwitchDetail,
};

/**
 房间列表数据源类型
 - TTRoomSettingSourceHideRoom: 隐藏房间
 - TTRoomSettingsSourceLock: 解除房间上锁
 - TTRoomSettingsSourceUnlockRoomLimit: 解除房间限制
 - TTRoomSettingSourceCloseRoom: 关闭房间
 - TTRoomSettingsSourceName: 房间名称
 - TTRoomSettingsSourceLock: 房间上锁
 - TTRoomSettingsSourcePwd: 房间密码
 - TTRoomSettingsSourceTag: 房间标签
 - TTRoomSettingsSourceAdmin: 管理员
 - TTRoomSettingsSourceBlacklist: 黑名单
 - TTRoomSettingsSourceBackground: 房间背景
 - TTRoomSettingsSourceGiftEffect: 房间礼物特效
 - TTRoomSettingsSourceRoomLeaveModel : 离开模式
 */
typedef NS_ENUM(NSUInteger, TTRoomSettingSource) {
    TTRoomSettingsSourceHideRoom,
    TTRoomSettingsSourceUnlockRoom,
    TTRoomSettingsSourceUnlockRoomLimit,
    TTRoomSettingsSourceCloseRoom,
    TTRoomSettingsSourceName,
    TTRoomSettingsSourceLock,
    TTRoomSettingsSourcePwd,
    TTRoomSettingsSourceTag,
    TTRoomSettingsSourceAdmin,
    TTRoomSettingsSourceBlacklist,
    TTRoomSettingsSourceBackground,
    TTRoomSettingsSourceGiftEffect,
    TTRoomSettingsSourceQueueMike,
    TTRoomSettingsSourceMale, // 公屏
    TTRoomSettingsSourcePureModel, // 纯净模式
    TTRoomSettingsSourceRoomLeaveModel, // 离开模式
};

@interface TTRoomSettingsConfig : NSObject

/**
 数据源类型
 */
@property (nonatomic, assign, readonly) TTRoomSettingSource type;

/**
 数据源 Cell 类型
 */
@property (nonatomic, assign, readonly) TTRoomSettingsCellStyle cellStyle;

/**
 数据源名称
 */
@property (nonatomic, copy, readonly) NSString *name;


/**
 生成房间列表数据源配置

 @param type 数据源类型
 @param name 名称
 @return 配置类
 */
+ (instancetype)configType:(TTRoomSettingSource)type name:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
