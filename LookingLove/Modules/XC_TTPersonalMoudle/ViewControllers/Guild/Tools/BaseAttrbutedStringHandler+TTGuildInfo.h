//
//  BaseAttrbutedStringHandler+TTGuildInfo.h
//  TuTu
//
//  Created by lee on 2019/1/9.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "BaseAttrbutedStringHandler.h"
@class UserInfo;
NS_ASSUME_NONNULL_BEGIN

@interface BaseAttrbutedStringHandler (TTGuildInfo)

/** 创建 性别|等级|魅力等级 */
+ (NSMutableAttributedString *)creatName_Sex_userRank_charmRankByUserInfo:(UserInfo *)userInfo;

@end

NS_ASSUME_NONNULL_END
