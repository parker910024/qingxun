//
//  TTGameRoomViewController+Red.h
//  XC_TTRoomMoudle
//
//  Created by lvjunhang on 2020/5/12.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//  红包相关

#import "TTGameRoomViewController.h"

#import "RoomRedClient.h"

#import "TTRedListView.h"
#import "TTRedListItemView.h"
#import "TTRedDrawView.h"
#import "TTRedEntranceView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTGameRoomViewController (Red)
<
RoomRedClient,
TTRedListViewDelegate,
TTRedListItemViewDelegate,
TTRedDrawViewDelegate,
TTRedEntranceViewDelegate
>

/// 请求红包列表
/// @param completion 完成回调
- (void)requestRedListWithCompletion:(void(^_Nullable)(void))completion;

/// 初始化配置红包入口，是否显示及显示动画
- (void)initialRedEntranceView;

/// 更新红包入口显示状态
- (void)updateRedEntranceViewShowStatus;

@end

NS_ASSUME_NONNULL_END
