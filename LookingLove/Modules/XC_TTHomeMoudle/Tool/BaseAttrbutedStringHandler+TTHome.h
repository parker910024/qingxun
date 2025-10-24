//
//  BaseAttrbutedStringHandler+TTHome.h
//  TuTu
//
//  Created by lvjunhang on 2018/10/30.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "BaseAttrbutedStringHandler.h"

NS_ASSUME_NONNULL_BEGIN

@class TTHomeRecommendDetailData;
@class UserInfo;

@interface BaseAttrbutedStringHandler (TTHome)
//头条的富文本
+ (NSMutableAttributedString *)newHeadLineWith:(TTHomeRecommendDetailData *)model withMaxWidht:(CGFloat)maxWidth;

//创建 昵称|贵族|性别|等级|魅力等级|星座
+ (NSMutableAttributedString *)creatNick_noble_sex_userLevel_charmLevelByUserInfo:(UserInfo *)userInfo nickType:(BaseAttributedStringNickType)nickType labelAttribute:(NSDictionary *)labelAttribute;

//房间标签富文本
+ (NSMutableAttributedString *)roomTagAttributedStringWithTag:(NSString *)roomTag;

@end

NS_ASSUME_NONNULL_END
