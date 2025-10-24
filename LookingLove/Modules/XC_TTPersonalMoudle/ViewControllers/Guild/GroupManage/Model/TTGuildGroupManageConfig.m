//
//  TTGuildGroupManageConfig.m
//  TuTu
//
//  Created by lvjunhang on 2019/1/9.
//  Copyright © 2019年 YiZhuan. All rights reserved.
//

#import "TTGuildGroupManageConfig.h"

@interface TTGuildGroupManageConfig ()
/**
 数据源类型
 */
@property (nonatomic, assign, readwrite) TTGuildGroupManageType type;

/**
 数据源 Cell 类型
 */
@property (nonatomic, assign, readwrite) TTGuildGroupManageCellStyle cellStyle;

/**
 数据源名称
 */
@property (nonatomic, copy, readwrite) NSString *name;

/**
 数据源名称(标题）颜色
 */
@property (nonatomic, strong, readwrite) UIColor *nameColor;

/**
 是否显示箭头，仅 TTGuildGroupManageCellStyleTitleContentArrow 类型有效
 */
@property (nonatomic, assign, readwrite, getter=isShowArrow) BOOL showArrow;

/**
 是否显示 cell 底部下划线
 */
@property (nonatomic, assign, readwrite, getter=isShowUnderLine) BOOL showUnderLine;

@end

@implementation TTGuildGroupManageConfig

/**
 生成群组管理数据源配置
 
 @param type 数据源类型
 @param name 名称
 @param nameColor 标题颜色
 @param isShowUnderLine 是否显示分割线
 @param isShowArrow 是否显示箭头
 @return 配置类
 */

+ (instancetype)configType:(TTGuildGroupManageType)type
                      name:(NSString *)name
                 nameColor:(UIColor *)nameColor
             showUnderLine:(BOOL)isShowUnderLine
                 showArrow:(BOOL)isShowArrow {
    
    TTGuildGroupManageConfig *config = [[TTGuildGroupManageConfig alloc] init];
    
    config.type = type;
    config.name = name;
    config.nameColor = nameColor;
    config.showArrow = isShowArrow;
    config.showUnderLine = isShowUnderLine;
    config.cellStyle = [self cellStyleForSourceType:type];
    
    return config;
}

+ (TTGuildGroupManageCellStyle)cellStyleForSourceType:(TTGuildGroupManageType)type {
    
    switch (type) {
        case TTGuildGroupManageTypeAvatar:
        case TTGuildGroupManageTypeName:
        case TTGuildGroupManageTypeMemberTitle:
        case TTGuildGroupManageTypeManagerTitle:
        case TTGuildGroupManageTypeNoticeTitle:
        case TTGuildGroupManageTypeMuteSetting:
        case TTGuildGroupManageTypeClassifyDescribe:
            return TTGuildGroupManageCellStyleTitleContentArrow;
        case TTGuildGroupManageTypeMemberList:
        case TTGuildGroupManageTypeManagerList:
            return TTGuildGroupManageCellStyleCollection;
        case TTGuildGroupManageTypeClassify:
            return TTGuildGroupManageCellStyleChoose;
        case TTGuildGroupManageTypeCreateDescribe:
        case TTGuildGroupManageTypeNotice:
            return TTGuildGroupManageCellStyleMutiLineText;
        case TTGuildGroupManageTypeMsgDoNotDisturb:
            return TTGuildGroupManageCellStyleSwitch;
        case TTGuildGroupManageTypeSeparateLine:
            return TTGuildGroupManageCellStyleSeparateLine;
    }
}

@end

