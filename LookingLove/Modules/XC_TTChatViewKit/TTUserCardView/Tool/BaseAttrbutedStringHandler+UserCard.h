//
//  BaseAttrbutedStringHandler+UserCard.h
//  TuTu
//
//  Created by 卫明 on 2018/11/15.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "BaseAttrbutedStringHandler.h"
#import "TTUserCardContainerView.h"

#import "UserInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseAttrbutedStringHandler (UserCard)

+ (NSMutableAttributedString *)makeUserCardInfoByUserInfo:(UserInfo *)userInfo type:(ShowUserCardType)type;

@end

NS_ASSUME_NONNULL_END
