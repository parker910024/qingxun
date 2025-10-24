//
//  TTSendPresentUserInfo.h
//  TuTu
//
//  Created by lvjunhang on 2018/11/23.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//  选择赠送礼物的h用户模型

#import "BaseObject.h"
#import "UserID.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTSendPresentUserInfo : BaseObject
@property (nonatomic, copy, readonly) NSString *nickname;
@property (nonatomic, assign, readonly) UserID uid;

+ (instancetype)initWithNickname:(NSString *)nickname userID:(UserID)uid;

@end

NS_ASSUME_NONNULL_END
