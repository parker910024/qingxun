//
//  TTRoomListViewController.h
//  TTPlay
//
//  Created by lvjunhang on 2019/2/20.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  各个分类下的房间列表

#import "BaseTableViewController.h"
#import <JXCategoryView/JXCategoryListContainerView.h>

NS_ASSUME_NONNULL_BEGIN

@class RoomCategory;

@interface TTRoomListViewController : BaseTableViewController<JXCategoryListContentViewDelegate>
@property (nonatomic, strong) RoomCategory *roomTag;

@property (nonatomic, copy) void(^didScrollCallback)(UIScrollView *scrollView);

@end

NS_ASSUME_NONNULL_END
