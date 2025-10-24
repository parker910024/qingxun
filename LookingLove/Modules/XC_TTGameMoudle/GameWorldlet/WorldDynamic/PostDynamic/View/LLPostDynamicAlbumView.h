//
//  LLPostDynamicAlbumView.h
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2020/1/6.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//  发布动态的相册管理

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LLPostDynamicAlbumView;

@protocol LLPostDynamicAlbumViewDelegate <NSObject>
@optional;

/// 将要新增照片
- (void)albumViewWillAppendPhoto:(LLPostDynamicAlbumView *)view;

/// 将要浏览照片
- (void)albumViewWillBrowserPhoto:(LLPostDynamicAlbumView *)view;

/// 已经新增照片
- (void)albumViewHadAppendPhoto:(LLPostDynamicAlbumView *)view;

/// 已经删除照片
- (void)albumViewHadDeletePhoto:(LLPostDynamicAlbumView *)view;

@end

@interface LLPostDynamicAlbumView : UIView
@property (nonatomic, weak) id<LLPostDynamicAlbumViewDelegate> delegate;

@property (nonatomic, strong) NSMutableArray<UIImage *> *dataArray;

#pragma mark - Public
/// 获取高度
- (CGFloat)height;

@end

NS_ASSUME_NONNULL_END
