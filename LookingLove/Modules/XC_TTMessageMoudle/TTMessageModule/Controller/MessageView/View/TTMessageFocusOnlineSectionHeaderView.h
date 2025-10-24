//
//  TTMessageFocusOnlineSectionHeaderView.h
//  XC_TTMessageMoudle
//
//  Created by lvjunhang on 2019/11/18.
//  Copyright © 2019 WJHD. All rights reserved.
//  一起玩入口+关注的在线列表

#import <UIKit/UIKit.h>
#import "Attention.h"

NS_ASSUME_NONNULL_BEGIN

@class TTMessageFocusOnlineSectionHeaderView;

@protocol TTMessageFocusOnlineSectionHeaderViewDelegate <NSObject>

/// 选中"一起玩"
- (void)sectionHeaderViewDidClickTogether:(TTMessageFocusOnlineSectionHeaderView *)view;

/// 选中"更多"
- (void)sectionHeaderViewDidClickMore:(TTMessageFocusOnlineSectionHeaderView *)view;

/// 选中关注用户
/// @param attention 用户模型
- (void)sectionHeaderView:(TTMessageFocusOnlineSectionHeaderView *)view didSelectedAttention:(Attention *)attention;
@end

@interface TTMessageFocusOnlineSectionHeaderView : UITableViewHeaderFooterView

/// 关注列表
@property (nonatomic, strong) NSArray<Attention *> *focusArray;

@property (nonatomic, weak) id<TTMessageFocusOnlineSectionHeaderViewDelegate> delegate;

/// 是否隐藏"一起玩"功能入口
@property (nonatomic, assign) BOOL hideTogetherButton;

@end

@interface TTMessageFocusOnlineSectionHeaderCell : UICollectionViewCell

/// 是否为“查看更多”入口（第二十一个cell为“查看更多”入口）
@property (nonatomic, assign) BOOL isMoreItemStyle;

/// 配置cell数据显示
- (void)configData:(Attention *)attention;

@end

NS_ASSUME_NONNULL_END
