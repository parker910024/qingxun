//
//  LLDynamicSquareController.h
//  XC_TTDiscoverMoudle
//
//  Created by Lee on 2020/1/6.
//  Copyright © 2020 fengshuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseUIViewController.h"
#import <JXCategoryView/JXCategoryListContainerView.h>
#import <JXPagingView/JXPagerView.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLDynamicSquareController : BaseUIViewController<JXPagerViewListViewDelegate>
@property (nonatomic, copy) void(^didScrollCallback)(UIScrollView *scrollView);

- (void)refreshFollowVcData;

@end

NS_ASSUME_NONNULL_END
