//
//  BaseAttrbutedStringHandler+TTDynamicInfo.h
//  XC_TTGameMoudle
//
//  Created by Lee on 2019/11/23.
//  Copyright © 2019 WUJIE INTERACTIVE. All rights reserved.
//

#import "BaseAttrbutedStringHandler.h"
@class LLDynamicModel;

NS_ASSUME_NONNULL_BEGIN

@interface BaseAttrbutedStringHandler (TTDynamicInfo)
/** 创建 昵称|年龄|官方账号|贵族 */
+ (NSMutableAttributedString *)creatNick_userAge_charmRank_constellationByDynamicModel:(LLDynamicModel *)dynamicModel;
// 创建动态内容 首贴标签-内容
+ (NSMutableAttributedString *)creatFirstDynamicIcon_content:(LLDynamicModel *)dynamicModel;

/// 主播技能标签富文本
/// @param tag 技能标签
/// @param color 显示颜色
+ (NSAttributedString *)anchorSkillTagAttributedStringWithLabel:(NSString *)tag color:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
