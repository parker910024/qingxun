//
//  TTRedListView.h
//  XC_TTRoomMoudle
//
//  Created by lvjunhang on 2020/5/12.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//  红包列表

#import <UIKit/UIKit.h>
#import "TTRedListItemView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TTRedListViewAction) {//红包列表操作类型
    TTRedListViewActionClose,//关闭
    TTRedListViewActionMark,//问号
    TTRedListViewActionSend,//发红包
    TTRedListViewActionRecord,//红包记录
};

@class RoomRedListItem, TTRedListView, RoomRedDetail;

@protocol TTRedListViewDelegate <NSObject>
/// 红包列表的操作
- (void)redListView:(TTRedListView *)view didAction:(TTRedListViewAction)action;

/// 红包关注操作
- (void)redListView:(TTRedListView *)view focus:(RoomRedDetail *)redDetail;

@end

@interface TTRedListView : UIView
@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, weak) id<TTRedListViewDelegate, TTRedListItemViewDelegate> delegate;
@property (nonatomic, strong) NSArray<RoomRedListItem *> *dataArray;

/// 显示一个红包详情
- (void)showRed:(RoomRedDetail *_Nullable)red;

/// 显示动画
- (void)showAnimation;

@end

NS_ASSUME_NONNULL_END
