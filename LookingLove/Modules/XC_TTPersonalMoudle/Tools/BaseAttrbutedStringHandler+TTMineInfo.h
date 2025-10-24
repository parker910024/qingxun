//
//  BaseAttrbutedStringHandler+TTMineInfo.h
//  TuTu
//
//  Created by lee on 2018/11/17.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "BaseAttrbutedStringHandler.h"

NS_ASSUME_NONNULL_BEGIN

@class UserInfo;
@interface BaseAttrbutedStringHandler (TTMineInfo)

/** 创建 爵位|等级|魅力等级|星座 */
+ (NSMutableAttributedString *)creatTitle_userRank_charmRank_constellationByUserInfo:(UserInfo *)userInfo;


/** 创建 爵位 | 靓 | 星座 |ID*/
+ (NSMutableAttributedString *)creatTitle_Beauty_Constellation_IDByUserInfo:(UserInfo *)userInfo;

/**
 官|良|ID
 */
+ (NSMutableAttributedString *)createTitle_Offical_Beauty_IDWith:(UserInfo *)info;

/**
 官 | 靓 | ID | 地理信息
 
 @param info 用户信息
 */
+ (NSMutableAttributedString *)createTitle_Offical_Beauty_ID_LoactionWith:(UserInfo *)info;

//靓
+ (NSAttributedString *)makeBeautyImage;
//IDlabel
+ (NSMutableAttributedString *)makeIDLabel;
//铭牌时间
+ (NSMutableAttributedString *)creatNameplateTitle:(NSInteger)time;
@end

NS_ASSUME_NONNULL_END
