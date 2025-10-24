//
//  BaseAttrbutedStringHandler+Voice.h
//  XC_TTGameMoudle
//
//  Created by Macx on 2019/6/6.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "BaseAttrbutedStringHandler.h"

NS_ASSUME_NONNULL_BEGIN
@class UserInfo;

@interface BaseAttrbutedStringHandler (Voice)
// 创建 昵称 + 性别富文本 + 星座 + 地区 (昵称限制5个字, 超过.. 地区限制四个字超过..)
+ (NSMutableAttributedString *)creatNick_Sex_Constellation_CityLimitByUserInfo:(UserInfo *)userInfo location:(NSString *)location textColor:(UIColor *)textColor font:(UIFont *)font;
@end

NS_ASSUME_NONNULL_END
