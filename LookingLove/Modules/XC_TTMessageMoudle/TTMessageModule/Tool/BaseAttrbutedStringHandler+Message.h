//
//  BaseAttrbutedStringHandler+Message.h
//  TTPlay
//
//  Created by Macx on 2019/1/24.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "BaseAttrbutedStringHandler.h"
#import "UserInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseAttrbutedStringHandler (Message)
// 创建 昵称 + 性别富文本 (昵称限制4个字, 超过...)
+ (NSMutableAttributedString *)creatNick_SexLimitByUserInfo:(UserInfo *)userInfo textColor:(UIColor *)textColor font:(UIFont *)font;

/** 姓名性别年龄富文本 */
+ (NSMutableAttributedString *)nickGenderAgeAttributedStringWithNick:(NSString *)nick gender:(UserGender)gender age:(NSInteger)age;

@end

NS_ASSUME_NONNULL_END
