//
//  TTSearchRoomViewController.h
//  TuTu
//
//  Created by Macx on 2018/11/5.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "BaseTableViewController.h"
#import "Target_TTHomeMoudle.h"

typedef void(^DismissAndDidClickPersonBlcok)(long long uid);

@interface TTSearchRoomViewController : BaseTableViewController
/** 是否是搜索zen送, 默认为NO */
@property (nonatomic, assign) BOOL isPresent;
/** 是否是邀请用户 */
@property (nonatomic, assign) BOOL isInvite;
/** 是否是模厅内部搜索 */
@property (nonatomic, assign) BOOL isHallSearch;

/// 允许显示历史记录（搜索记录和进房记录）
@property (nonatomic, assign) BOOL showHistoryRecord;

/** zen 送按钮点击的回调 */
@property (nonatomic, copy) TTSearchPresentDidClickBlock searchPresentDidClickBlock;

/** dimiss 并点击了 个人资料的 回调 */
@property (nonatomic, copy) DismissAndDidClickPersonBlcok dismissAndDidClickPersonBlcok;

/// 进入房间操作处理
@property (nonatomic, copy) void (^enterRoomHandler)(long long roomUid);

@end
