//
//  TTPublicChatAttrbutedStringHandler.h
//  TuTu
//
//  Created by 卫明 on 2018/10/30.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "BaseAttrbutedStringHandler.h"

//model
#import "UserInfo.h"
//core

NS_ASSUME_NONNULL_BEGIN

@interface TTPublicChatAttrbutedStringHandler : BaseAttrbutedStringHandler

//|官方-如果有|贵族勋章|经验等级|魅力等级|用户昵称
+ (NSMutableAttributedString *)makePublicChatUserNameWithUserInfo:(UserInfo *)userInfo;
//emoji图片
+ (NSMutableAttributedString *)makeEmojiAttributedString:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
