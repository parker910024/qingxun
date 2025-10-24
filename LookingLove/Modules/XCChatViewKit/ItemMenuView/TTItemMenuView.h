//
//  TTItemMenuView.h
//  TuTu
//
//  Created by 卫明 on 2018/11/6.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

//item
#import "TTItemMenuItem.h"

//config
#import "TTItemsMenuConfig.h"

NS_ASSUME_NONNULL_BEGIN
@class TTItemMenuView;

@protocol TTItemMenuViewDelegate <NSObject>

- (void)menuView:(TTItemMenuView *)addMenuView didSelectedItem:(TTItemMenuItem *)item;

@end

@interface TTItemMenuView : UIView

@property (nonatomic,weak) id<TTItemMenuViewDelegate> delegate;
@property (nonatomic,copy) void (^itemSelectedAction)(TTItemMenuView *menuView, TTItemMenuItem *item);

/**
 设置自定义背景色
 */
@property (nonatomic, strong) UIColor *customBackgroundColor;
/** 是否显示遮罩层 */
@property (nonatomic, assign) BOOL isShowMask;
/**
 *  显示Menu
 *
 *  @param view 父View
 */
- (void)showInView:(UIView *)view;

/**
 *  是否正在显示
 */
- (BOOL)isShow;

/**
 *  隐藏
 */
- (void)dismiss;


/**
 初始化方法

 @param frame 布局
 @param config 配置
 @return TTItemMenuView
 */
- (instancetype)initWithFrame:(CGRect)frame withConfig:(TTItemsMenuConfig *)config items:(NSArray<TTItemMenuItem *>*)items;

- (void)configMenuViewWithItems:(NSArray<TTItemMenuItem *> *)items;
@end

NS_ASSUME_NONNULL_END
