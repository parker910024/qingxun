//
//  TTWorldSquareNavView.h
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2019/6/28.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  世界广场自定义导航栏

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TTWorldSquareNavView;

@protocol TTWorldSquareNavViewDelegate <NSObject>

/**
 导航栏返回
 */
- (void)didClickBackActionInNavView:(TTWorldSquareNavView *)navView;

/**
 导航栏搜索
 */
- (void)didClickSearchActionInNavView:(TTWorldSquareNavView *)navView;

@end

@interface TTWorldSquareNavView : UIView

@property (nonatomic, assign) id<TTWorldSquareNavViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
