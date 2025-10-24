//
//  HL_SegmentView.h
//  pageDemo
//
//  Created by 黄清华 on 2018/3/2.
//  Copyright © 2018年 zjht_macos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HL_SegmentViewDelegate.h"
#import "HL_PageViewDelegate.h"


@interface HL_SegmentView : UIView<HL_PageViewDelegate>

///pageViewController中的scrollView
@property (nonatomic, weak) UIScrollView *pageVcScrollView;
///titles数据
@property (nonatomic, strong) NSArray *titles;
///是否是平分宽度
@property (nonatomic, assign) BOOL isAvgWith;
///标签未选中的颜色  默认gray
@property (nonatomic, strong) UIColor *titleNorColor;
///标签选中的颜色 默认black
@property (nonatomic, strong) UIColor *titleSelColor;
///标签字体
@property (nonatomic, strong) UIFont *titleNorFont;
///标签选中字体
@property (nonatomic, strong) UIFont *titleSelFont;
///item直接的间距  默认15
@property (nonatomic, assign) CGFloat itemMarge;
///左右吧间距
@property (nonatomic, assign) CGFloat leftRightMarge;
@property (nonatomic, weak) id<HL_SegmentViewDelegate> delegate;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) NSInteger willSelctedIndex;//拖拽时的下一个index


- (instancetype)initWithFrame:(CGRect)frame;

/**
 配置数据完成布局UI
 */
- (void)setUpComplete;


/**
 设置默认选中
 */
- (void)setDefaultSelectedWithIndex:(NSInteger)index;


@end

