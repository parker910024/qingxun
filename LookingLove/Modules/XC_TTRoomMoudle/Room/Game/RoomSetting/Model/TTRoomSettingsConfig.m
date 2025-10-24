//
//  TTRoomSettingRowConfig.m
//  TuTu
//
//  Created by lvjunhang on 2018/11/6.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTRoomSettingsConfig.h"

@interface TTRoomSettingsConfig ()
/**
 数据源类型
 */
@property (nonatomic, assign, readwrite) TTRoomSettingSource type;

/**
 数据源 Cell 类型
 */
@property (nonatomic, assign, readwrite) TTRoomSettingsCellStyle cellStyle;

/**
 数据源名称
 */
@property (nonatomic, copy, readwrite) NSString *name;

@end

@implementation TTRoomSettingsConfig

+ (instancetype)configType:(TTRoomSettingSource)type name:(NSString *)name {
    
    TTRoomSettingsConfig *config = [[TTRoomSettingsConfig alloc] init];
    
    config.type = type;
    config.name = name;
    config.cellStyle = [self cellStyleForSourceType:type];
    
    return config;
}

+ (TTRoomSettingsCellStyle)cellStyleForSourceType:(TTRoomSettingSource)type {
    switch (type) {
        case TTRoomSettingsSourceName:
        case TTRoomSettingsSourceTag:
            return TTRoomSettingsCellStyleContentArrow;
            
        case TTRoomSettingsSourceHideRoom:
        case TTRoomSettingsSourceLock:
        case TTRoomSettingsSourceGiftEffect:
        case TTRoomSettingsSourceQueueMike:
        case TTRoomSettingsSourceMale:
            return TTRoomSettingsCellStyleSwitch;
            
        case TTRoomSettingsSourcePureModel:
        case TTRoomSettingsSourceRoomLeaveModel:
            return TTRoomSettingsCellStyleSwitchDetail;
            
        case TTRoomSettingsSourceUnlockRoom:
        case TTRoomSettingsSourceUnlockRoomLimit:
        case TTRoomSettingsSourceCloseRoom:
            return TTRoomSettingsCellStyleImage;
            
        default:
            return TTRoomSettingsCellStyleArrow;
    }
}

@end
