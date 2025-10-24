//
//  LLDiscoverFamilyViewController.h
//  XC_TTDiscoverMoudle
//
//  Created by fengshuo on 2019/7/26.
//  Copyright © 2019 fengshuo. All rights reserved.
//

#import "BaseTableViewController.h"
#import <JXCategoryView/JXCategoryListContainerView.h>
#import <JXPagingView/JXPagerView.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger) {
    LLDiscoverFamilyCellType_Banners = 0,//轮播图
    LLDiscoverFamilyCellType_Square = 1,//家族广场
    LLDiscoverFamilyCellType_MyFamily = 2,//我的家族
    LLDiscoverFamilyCellType_Charm = 3,//星推荐
    LLDiscoverFamilyCellType_Service = 4//客服
}LLDiscoverFamilyCellType;


@interface LLDiscoverFamilyViewController : BaseTableViewController<JXPagerViewListViewDelegate>
@property (nonatomic, copy) void(^didScrollCallback)(UIScrollView *scrollView);

@end

NS_ASSUME_NONNULL_END
