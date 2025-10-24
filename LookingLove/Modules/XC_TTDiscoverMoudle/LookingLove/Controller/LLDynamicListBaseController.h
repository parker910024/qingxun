//
//  LLDynamicListBaseController.h
//  XC_TTDiscoverMoudle
//
//  Created by Lee on 2020/1/6.
//  Copyright © 2020 fengshuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"

#import <JXPagingView/JXPagerView.h>
#import <JXCategoryView/JXCategoryListContainerView.h>
@class CTDynamicModel, LittleWorldListItem;
typedef NS_ENUM(NSInteger, LLDynamicCircleType) {
    LLDynamicCircleTypeAttention,          // 关注
    LLDynamicCircleTypePlayground          // 广场
};
NS_ASSUME_NONNULL_BEGIN

@interface LLDynamicListBaseController : BaseTableViewController<JXCategoryListContentViewDelegate>

@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, assign) LLDynamicCircleType type;
@property (nonatomic, copy) NSString *worldID;
@property (nonatomic, strong) LittleWorldListItem *worldItem;
///发布完成回调
- (void)putCompleteCallBackWithModel:(CTDynamicModel *)model;

///刷新数据并且返回顶部
- (void)refreshDataToTop;
- (void)refreshData;

@end

NS_ASSUME_NONNULL_END
