//
//  TTMessageContainerNavView.m
//  XC_TTMessageMoudle
//
//  Created by lvjunhang on 2020/1/3.
//  Copyright © 2020 WJHD. All rights reserved.
//

#import "TTMessageContainerNavView.h"

#import <Masonry/Masonry.h>
#import <JXCategoryView/JXCategoryTitleVerticalZoomView.h>

#import "XCTheme.h"
#import "XCMacros.h"

@implementation TTMessageContainerNavView
#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initView];
    }
    return self;
}

#pragma mark - private method
- (void)initView {
    [self addSubview:self.categoryView];
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(statusbarHeight);
        make.left.mas_equalTo(12);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-12);
    }];
}

#pragma mark - getters and setters
- (JXCategoryTitleVerticalZoomView *)categoryView {
    if (!_categoryView) {
        JXCategoryTitleVerticalZoomView *view = [[JXCategoryTitleVerticalZoomView alloc] init];
        view.backgroundColor = UIColor.clearColor;
        view.titleLabelAnchorPointStyle = JXCategoryTitleLabelAnchorPointStyleBottom;
        
        view.averageCellSpacingEnabled = NO;
        view.titleColorGradientEnabled = YES;
        view.cellWidthZoomEnabled = YES;
        
        view.titleColor = [XCTheme getTTMainTextColor];
        view.titleSelectedColor = [XCTheme getTTMainTextColor];
        view.titleFont = [UIFont systemFontOfSize:15];
        view.titleSelectedFont = [UIFont systemFontOfSize:15];//见titleLabelSelectedStrokeWidth
        
        view.maxVerticalCellSpacing = 3;
        view.minVerticalCellSpacing = 3;
        view.contentEdgeInsetLeft = 6;
        view.cellSpacing = 20;
        
        CGFloat fontScale = 20/15.f;
        
        //放大倍数：font15->font20，粗细通过titleLabelSelectedStrokeWidth
        view.titleLabelStrokeWidthEnabled = YES;
        view.titleLabelSelectedStrokeWidth = -2;
        view.titleLabelZoomScale = fontScale;
        
        view.maxVerticalFontScale = fontScale;
        view.minVerticalFontScale = 1;
        
        _categoryView = view;
    }
    return _categoryView;
}

@end

