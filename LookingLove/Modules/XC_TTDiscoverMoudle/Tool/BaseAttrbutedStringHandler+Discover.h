//
//  BaseAttrbutedStringHandler+Discover.h
//  TTPlay
//
//  Created by Macx on 2019/1/23.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "BaseAttrbutedStringHandler.h"

NS_ASSUME_NONNULL_BEGIN
@class UserInfo;
@class DiscoveryHeadLineNews;
@interface BaseAttrbutedStringHandler (Discover)
// 创建 性别+用户等级+魅力等级富文本
+ (NSMutableAttributedString *)creatSex_userLevel_charmLevelByUserInfo:(UserInfo *)userInfo;

//头条的富文本
+ (NSMutableAttributedString *)newHeadLineWith:(DiscoveryHeadLineNews *)model withMaxWidht:(CGFloat)maxWidth;
@end

NS_ASSUME_NONNULL_END
