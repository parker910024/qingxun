//
//  TTGuildGroupManageConfig.h
//  TuTu
//
//  Created by lvjunhang on 2019/1/9.
//  Copyright © 2019年 YiZhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 群组管理 cell 类型

 - TTGuildGroupManageCellStyleTitleContentArrow: 标题内容箭头
 - TTGuildGroupManageCellStyleSwitch: switch 开关
 - TTGuildGroupManageCellStyleCollection: 集合（群成员、群管理）
 - TTGuildGroupManageCellStyleMutiLineText: 多行文本（群公告、群数据说明）
 - TTGuildGroupManageCellStyleChoose: 选择器（选择群分类）
 - TTGuildGroupManageCellStyleSeparateLine: 分割线
 */
typedef NS_ENUM(NSUInteger, TTGuildGroupManageCellStyle) {
    TTGuildGroupManageCellStyleTitleContentArrow,
    TTGuildGroupManageCellStyleSwitch,
    TTGuildGroupManageCellStyleCollection,
    TTGuildGroupManageCellStyleMutiLineText,
    TTGuildGroupManageCellStyleChoose,
    TTGuildGroupManageCellStyleSeparateLine
};

/**
 群组管理数据源类型

 - TTGuildGroupManageTypeAvatar: 头像
 - TTGuildGroupManageTypeName: 名称
 -  TTGuildGroupManageTypeMemberTitle: 选择群成员
 - TTGuildGroupManageTypeMemberList: 成员列表
 - TTGuildGroupManageTypeManagerTitle: 选择管理员
 - TTGuildGroupManageTypeManagerList: 管理员列表
 - TTGuildGroupManageTypeClassify: 群分类
 - TTGuildGroupManageTypeClassifyDescribe: 群分类描述（不可更改）
 - TTGuildGroupManageTypeCreateDescribe: 创建描述
 - TTGuildGroupManageTypeNotice: 群公告
 - TTGuildGroupManageTypeMuteSetting: 设置禁言
 - TTGuildGroupManageTypeMsgDoNotDisturb: 消息免打扰
 - TTGuildGroupManageTypeSeparateLine: 分割线
 */
typedef NS_ENUM(NSUInteger, TTGuildGroupManageType) {
    TTGuildGroupManageTypeAvatar,
    TTGuildGroupManageTypeName,
    TTGuildGroupManageTypeMemberTitle,
    TTGuildGroupManageTypeMemberList,
    TTGuildGroupManageTypeManagerTitle,
    TTGuildGroupManageTypeManagerList,
    TTGuildGroupManageTypeClassify,
    TTGuildGroupManageTypeClassifyDescribe,
    TTGuildGroupManageTypeCreateDescribe,
    TTGuildGroupManageTypeNoticeTitle,
    TTGuildGroupManageTypeNotice,
    TTGuildGroupManageTypeMuteSetting,
    TTGuildGroupManageTypeMsgDoNotDisturb,
    TTGuildGroupManageTypeSeparateLine
};

@interface TTGuildGroupManageConfig : NSObject

/**
 数据源类型
 */
@property (nonatomic, assign, readonly) TTGuildGroupManageType type;

/**
 数据源 Cell 类型
 */
@property (nonatomic, assign, readonly) TTGuildGroupManageCellStyle cellStyle;

/**
 数据源名称
 */
@property (nonatomic, copy, readonly) NSString *name;

/**
 数据源名称(标题）颜色
 */
@property (nonatomic, strong, readonly) UIColor *nameColor;

/**
 是否显示箭头，仅 TTGuildGroupManageCellStyleTitleContentArrow 类型有效
 */
@property (nonatomic, assign, readonly, getter=isShowArrow) BOOL showArrow;

/**
 是否显示 cell 底部下划线
 */
@property (nonatomic, assign, readonly, getter=isShowUnderLine) BOOL showUnderLine;

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
                 showArrow:(BOOL)isShowArrow;
@end

NS_ASSUME_NONNULL_END
