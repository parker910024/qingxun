//
//  UserOfficialAnchorCertification.h
//  XCChatCoreKit
//
//  Created by lvjunhang on 2020/3/25.
//  Copyright © 2020 YiZhuan. All rights reserved.
//  官方主播认证模型

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserOfficialAnchorCertification : BaseObject
@property (nonatomic, copy) NSString *fixedWord;//认证名称
@property (nonatomic, copy) NSString *iconPic;//背景图片
@property (nonatomic, copy) NSString *ID;//convert from id
@end

NS_ASSUME_NONNULL_END
