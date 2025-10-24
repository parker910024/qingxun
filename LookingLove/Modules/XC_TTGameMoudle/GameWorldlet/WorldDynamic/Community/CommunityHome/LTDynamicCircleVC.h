//
//  LTDynamicCircleVC.h
//  LTChat
//
//  Created by apple on 2019/7/25.
//  Copyright © 2019 wujie. All rights reserved.
// 动态圈

#import "BaseUIViewController.h"
#import "BaseTableViewController.h"
#import <JXPagingView/JXPagerView.h>
@class CTDynamicModel, LittleWorldListItem;
typedef NS_ENUM(NSInteger, LTDynamicCircleType) {
    LTDynamicCircleTypeAttention,          // 关注
    LTDynamicCircleTypePlayground          // 广场
};

NS_ASSUME_NONNULL_BEGIN

@interface LTDynamicCircleVC : BaseTableViewController<JXPagerViewListViewDelegate>
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, assign) LTDynamicCircleType type;
@property (nonatomic, copy) NSString *worldID;
@property (nonatomic, strong) LittleWorldListItem *worldItem;
///发布完成回调
- (void)putCompleteCallBackWithModel:(CTDynamicModel *)model;

///刷新数据并且返回顶部
- (void)refreshDataToTop;
- (void)refreshData;
@end

NS_ASSUME_NONNULL_END
