//
//  TTMineMomentViewController.h
//  XC_TTPersonalMoudle
//
//  Created by lvjunhang on 2019/11/25.
//  Copyright © 2019 WUJIE INTERACTIVE. All rights reserved.
//  我的-动态

#import "BaseTableViewController.h"

#import "TTMineInfoEnumConst.h"

#import <JXPagingView/JXPagerView.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTMineMomentViewController : BaseTableViewController<JXPagerViewListViewDelegate>

@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);

@property (nonatomic, assign) long long userID;
@property (nonatomic, assign) TTMineInfoViewStyle mineInfoStyle;

@end

NS_ASSUME_NONNULL_END
