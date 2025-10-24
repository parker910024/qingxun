//
//  LLDiscoverViewController.h
//  XC_TTDiscoverMoudle
//
//  Created by fengshuo on 2019/7/25.
//  Copyright © 2019 fengshuo. All rights reserved.
//

#import "BaseCollectionViewController.h"
//#import <JXCategoryView/JXCategoryListContainerView.h>
#import <JXPagingView/JXPagerView.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLDiscoverViewController : BaseCollectionViewController<JXPagerViewListViewDelegate>
@property (nonatomic, copy) void(^didScrollCallback)(UIScrollView *scrollView);
@end

NS_ASSUME_NONNULL_END
