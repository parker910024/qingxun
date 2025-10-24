//
//  TTWorldSearchNavView.h
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2019/7/1.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TTWorldSearchNavView;

@protocol TTWorldSearchNavViewDelegate <NSObject>

/**
 导航栏取消
 */
- (void)didClickCancelActionInNavView:(TTWorldSearchNavView *)navView;

/**
 导航栏搜索
 
 @param searchKey 搜索关键词
 */
- (void)navView:(TTWorldSearchNavView *)navView search:(NSString *)searchKey;

@end

@interface TTWorldSearchNavView : UIView

@property (nonatomic, assign) id<TTWorldSearchNavViewDelegate> delegate;

/**
 当前搜索词
 */
@property (nonatomic, copy, readonly) NSString *currentSearchText;

#pragma mark - Public Method
/**
 初始化设置键盘弹出
 */
- (void)keyboradInitialShow;

@end

NS_ASSUME_NONNULL_END
