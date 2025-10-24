//
//  LLGoddessViewController.h
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2019/7/25.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "BaseTableViewController.h"

#import <JXPagingView/JXPagerView.h>

NS_ASSUME_NONNULL_BEGIN

@class BannerInfo;

@interface LLGoddessViewController : BaseTableViewController<JXPagerViewListViewDelegate>
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);

@property (nonatomic, copy) void(^didSelectBanner)(BannerInfo *info);

//标签类型，1男神，2女神，3男神女神
@property (nonatomic, assign) NSInteger labelType;

@end

NS_ASSUME_NONNULL_END
