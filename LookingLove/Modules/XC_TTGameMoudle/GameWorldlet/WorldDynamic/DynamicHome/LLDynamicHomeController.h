//
//  LLDynamicHomeController.h
//  XC_TTGameMoudle
//
//  Created by Lee on 2019/12/10.
//  Copyright © 2019 WUJIE INTERACTIVE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"

#import <JXPagingView/JXPagerView.h>
#import <JXCategoryView/JXCategoryListContainerView.h>
@class CTDynamicModel, LittleWorldListItem;
typedef NS_ENUM(NSInteger, LLDynamicSquareType) {
    LLDynamicSquareTypeAttention,          // 关注
    LLDynamicSquareTypePlayground          // 广场
};
NS_ASSUME_NONNULL_BEGIN

@interface LLDynamicHomeController : BaseTableViewController<JXCategoryListContentViewDelegate>

@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, assign) LLDynamicSquareType type;
@property (nonatomic, copy) NSString *worldID;
@property (nonatomic, strong) LittleWorldListItem *worldItem;
///发布完成回调
- (void)putCompleteCallBackWithModel:(CTDynamicModel *)model;

///刷新数据并且返回顶部
- (void)refreshDataToTop;
- (void)refreshData;

@end

NS_ASSUME_NONNULL_END
