//
//  TTFeedbackAlbumView.h
//  XC_TTPersonalMoudle
//
//  Created by lvjunhang on 2020/5/8.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TTFeedbackAlbumView;

@protocol TTFeedbackAlbumViewDelegate <NSObject>
@optional;

/// 将要新增照片
- (void)albumViewWillAppendPhoto:(TTFeedbackAlbumView *)view;

/// 将要浏览照片
- (void)albumViewWillBrowserPhoto:(TTFeedbackAlbumView *)view;

/// 已经新增照片
- (void)albumViewHadAppendPhoto:(TTFeedbackAlbumView *)view;

/// 已经删除照片
- (void)albumViewHadDeletePhoto:(TTFeedbackAlbumView *)view;

@end

@interface TTFeedbackAlbumView : UIView
@property (nonatomic, weak) id<TTFeedbackAlbumViewDelegate> delegate;

@property (nonatomic, strong) NSMutableArray<UIImage *> *dataArray;

#pragma mark - Public
/// 获取高度
- (CGFloat)height;

@end

NS_ASSUME_NONNULL_END
