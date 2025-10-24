//
//  TTHomeRecommendViewController.h
//  TuTu
//
//  Created by lvjunhang on 2018/12/28.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//  首页的推荐页，即首页的第一个 tab 页面

#import "BaseTableViewController.h"
#import <JXCategoryView/JXCategoryListContainerView.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ShowAllKTVListBlock)(void);

@interface TTHomeRecommendViewController : BaseTableViewController<JXCategoryListContentViewDelegate>

@property (nonatomic, copy) void(^didScrollCallback)(UIScrollView *scrollView);

@end

NS_ASSUME_NONNULL_END
