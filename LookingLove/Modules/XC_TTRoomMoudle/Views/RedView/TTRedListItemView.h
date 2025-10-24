//
//  TTRedListItemView.h
//  XC_TTRoomMoudle
//
//  Created by lvjunhang on 2020/5/13.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//  红包列表里面的红包

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RoomRedListItem;
@class TTRedListItemView;

@protocol TTRedListItemViewDelegate <NSObject>
/// 选中红包
- (void)didSelectedItemView:(TTRedListItemView *)view;
/// 分享红包
- (void)shareItemView:(TTRedListItemView *)view;
@end

@interface TTRedListItemView : UIView
@property (nonatomic, strong) RoomRedListItem *model;
@property (nonatomic, weak) id<TTRedListItemViewDelegate> delegate;

/// 已分享成功
- (void)hadShareSuccess;

@end

NS_ASSUME_NONNULL_END
