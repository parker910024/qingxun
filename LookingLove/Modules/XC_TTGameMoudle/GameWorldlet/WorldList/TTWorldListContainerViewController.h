//
//  TTWorldListContainerViewController.h
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2019/7/1.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  小世界列表 容器

#import "BaseUIViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTWorldListContainerViewController : BaseUIViewController

/**
 跳转小世界分类 Id，-1：我加入的，-2：推荐，其他
 */
@property (nonatomic, copy) NSString *worldTypeId;

@end

NS_ASSUME_NONNULL_END
