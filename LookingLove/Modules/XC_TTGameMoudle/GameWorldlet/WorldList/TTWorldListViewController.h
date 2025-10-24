//
//  TTWorldListViewController.h
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2019/7/1.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  小世界列表 子控制器

#import "BaseTableViewController.h"

#import <JXCategoryView/JXCategoryListContainerView.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTWorldListViewController : BaseTableViewController<JXCategoryListContentViewDelegate>

/**
 小世界分类 Id
 */
@property (nonatomic, copy) NSString *worldTypeId;

@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);

/**
 根据分类 ID 跳转对应 tab
 */
@property (nonatomic, copy) void(^jumpTabBlock)(NSString *worldTypeId);

@end

NS_ASSUME_NONNULL_END
