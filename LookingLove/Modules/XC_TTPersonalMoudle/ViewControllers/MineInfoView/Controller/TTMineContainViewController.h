//
//  TTMineContainViewController.h
//  TuTu
//
//  Created by lee on 2018/10/29.
//  Copyright © 2018 YiZhuan. All rights reserved.
//  主态页、客态页容器

#import "BaseUIViewController.h"
#import "TTMineInfoEnumConst.h"

NS_ASSUME_NONNULL_BEGIN

@class UserInfo;
@interface TTMineContainViewController : BaseUIViewController
// 布局风格
@property (nonatomic, assign) TTMineInfoViewStyle mineInfoStyle;

@property (nonatomic, strong) UserInfo *userInfo;

@property (nonatomic, assign) long long userID;

@end

NS_ASSUME_NONNULL_END
