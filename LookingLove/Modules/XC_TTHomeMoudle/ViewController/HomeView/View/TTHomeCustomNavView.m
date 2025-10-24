//
//  TTHomeCustomNavView.m
//  TuTu
//
//  Created by Macx on 2018/10/29.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTHomeCustomNavView.h"

#import <Masonry/Masonry.h>
#import <JXCategoryView/JXCategoryTitleVerticalZoomView.h>

#import "XCTheme.h"
#import "XCMacros.h"
#import "RoomCategory.h"
#import "UIButton+EnlargeTouchArea.h"

@interface TTHomeCustomNavView()

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) UIImageView *maskImageView;//滚动视图尾部的半透明遮罩
@property (nonatomic, strong) UIButton *searchButton;//搜索
@property (nonatomic, strong) UIButton *myRoomButton;//我的房间

@property (nonatomic, strong) UIButton *lastButton;

@end

@implementation TTHomeCustomNavView

#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initView];
        [self initConstraints];
    }
    return self;
}

#pragma mark - event response
- (void)didClickSearchButton:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(homeCustomNavView:didClickSearchButton:)]) {
        [self.delegate homeCustomNavView:self didClickSearchButton:button];
    }
}

- (void)didClickMyRoomButton:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(homeCustomNavView:didClickMyRoomButton:)]) {
        [self.delegate homeCustomNavView:self didClickMyRoomButton:button];
    }
}

#pragma mark - private method

- (void)initView {
    [self addSubview:self.bgImageView];
    [self addSubview:self.categoryView];
    
    [self addSubview:self.maskImageView];
    [self addSubview:self.searchButton];
    [self addSubview:self.myRoomButton];
}

- (void)initConstraints {
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(statusbarHeight);
        make.right.mas_equalTo(self.maskImageView);
    }];

    [self.maskImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.myRoomButton);
        make.right.mas_equalTo(self.searchButton.mas_left).offset(-6);
        make.width.mas_equalTo(27);
        make.height.mas_equalTo(25);
    }];
    
    [self.searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.myRoomButton);
        make.right.mas_equalTo(self.myRoomButton.mas_left).offset(-11);
        make.width.height.mas_equalTo(22);
    }];
    
    [self.myRoomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-18);
        make.centerY.mas_equalTo(self.categoryView);
        make.width.height.mas_equalTo(22);
    }];
}

#pragma mark - getters and setters
- (void)setRoomCategory:(NSArray<RoomCategory *> *)homeTags {
    _roomCategory = homeTags;
    
    NSMutableArray *titleArray = [NSMutableArray array];
    for (RoomCategory *category in homeTags) {
        [titleArray addObject:category.titleName];
    }
    
    self.categoryView.titles = titleArray.copy;
    [self.categoryView reloadData];
}

- (UIImageView *)bgImageView {
    if (_bgImageView == nil) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = [UIImage imageNamed:iPhoneXSeries ? @"home_nav_bg_iPhoneX" : @"home_nav_bg"];
    }
    return _bgImageView;
}

- (UIImageView *)maskImageView {
    if (_maskImageView == nil) {
        _maskImageView = [[UIImageView alloc] init];
        _maskImageView.image = [UIImage imageNamed:@"home_nav_mask"];
    }
    return _maskImageView;
}

- (UIButton *)searchButton {
    if (!_searchButton) {
        _searchButton = [[UIButton alloc] init];
        [_searchButton setImage:[UIImage imageNamed:@"home_search"] forState:UIControlStateNormal];
        [_searchButton addTarget:self action:@selector(didClickSearchButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [_searchButton setEnlargeEdgeWithTop:8 right:8 bottom:8 left:8];
    }
    return _searchButton;
}

- (UIButton *)myRoomButton {
    if (!_myRoomButton) {
        _myRoomButton = [[UIButton alloc] init];
        [_myRoomButton setImage:[UIImage imageNamed:@"home_room_add"] forState:UIControlStateNormal];
        [_myRoomButton addTarget:self action:@selector(didClickMyRoomButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [_myRoomButton setEnlargeEdgeWithTop:8 right:8 bottom:8 left:8];
    }
    return _myRoomButton;
}

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
