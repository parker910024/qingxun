//
//  TTGoddessViewProtocol.h
//  AFNetworking
//
//  Created by lvjunhang on 2019/6/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class BannerInfo;
@class HomeV5Data;
@class TTGoddessBannerCell;
@class TTGoddessTableHeaderView;
@class TTGoddessTableFooterView;
@class LLGoddessUserCell;

@protocol TTGoddessViewDelegate<NSObject>

@optional

/**
 选中 Banner
 
 @param data 选中的数据源
 */
- (void)didSelectBannerCell:(TTGoddessBannerCell *)cell bannerData:(BannerInfo *)data;

/**
 选中用户信息、房间信息
 
 @param data 选中的数据源
 */
- (void)didClickActionButtonWithData:(HomeV5Data *)data;

/**
 点击触发头部事件
 */
- (void)didClickTableHeaderView:(TTGoddessTableHeaderView *)headerView;

/**
 点击触发脚部事件
 */
- (void)didClickTableFooterView:(TTGoddessTableFooterView *)footerView;

/**
 选中用户/房间的操作
 
 @param data 选中的数据源，为空表示虚位以待
 */
- (void)didSelectUserCell:(LLGoddessUserCell *)cell data:(HomeV5Data *)data;

/**
 选中用户头像
 
 @param data 选中的数据源
 */
- (void)didClickAvatarWithData:(HomeV5Data *)data;

@end

NS_ASSUME_NONNULL_END
