//
//  LLPostDynamicLittleWorldAlertView.m
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2020/1/9.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import "LLPostDynamicLittleWorldAlertView.h"

#import "LLPostDynamicLittleWorldAlertTableView.h"

#import "LittleWorldCore.h"
#import "LittleWorldCoreClient.h"

#import "XCTheme.h"
#import "TTPopup.h"
#import "UIView+NTES.h"
#import "UIButton+EnlargeTouchArea.h"

#import <Masonry/Masonry.h>
#import <JXCategoryView/JXCategoryView.h>
#import <JXCategoryView/JXCategoryTitleView.h>

@interface LLPostDynamicLittleWorldAlertView ()
<
JXCategoryViewDelegate,
JXCategoryListContainerViewDelegate
>

@property (nonatomic, strong) UIView *containerView;//全部内容容器（不包含蒙层）
@property (nonatomic, strong) UIButton *closeButton;//关闭按钮（顶部小横条）
@property (nonatomic, strong) JXCategoryTitleView *categoryView;//segmented分段视图

@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;//table容器
@property (nonatomic, strong) LLPostDynamicLittleWorldAlertTableView *allTableView;//全部
@property (nonatomic, strong) LLPostDynamicLittleWorldAlertTableView *hotTableView;//大家都在聊
@property (nonatomic, strong) LLPostDynamicLittleWorldAlertTableView *mineTableView;//我加入的

@end

@implementation LLPostDynamicLittleWorldAlertView
- (void)dealloc {
}

- (instancetype)initWithFrame:(CGRect)frame {
    frame = UIScreen.mainScreen.bounds;
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initViewAndLayout];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    if (touch.view == self) {
        [TTPopup dismiss];
    }
}

#pragma mark - Private
- (void)initViewAndLayout {
    
    [self addSubview:self.containerView];
    [self.containerView addSubview:self.closeButton];
    [self.containerView addSubview:self.categoryView];
    [self.containerView addSubview:self.listContainerView];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(480);
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(6);
    }];
    
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.closeButton.mas_bottom).offset(6);
        make.left.right.mas_equalTo(self.containerView).inset(20);
        make.height.mas_equalTo(44);
    }];
    
    [self.listContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.categoryView.mas_bottom);
        make.left.bottom.right.mas_equalTo(0);
    }];
    
    [self layoutIfNeeded];
    [self.containerView addRoundedCorners:UIRectCornerTopLeft|UIRectCornerTopRight withRadii:CGSizeMake(8, 8) viewRect:self.containerView.bounds];
}

#pragma mark - Public
- (void)show {
    [TTPopup popupView:self style:TTPopupStyleActionSheet];
}

#pragma mark - Actions
- (void)didClickCloseButton:(UIButton *)sender {
    [TTPopup dismiss];
}

#pragma mark - JXCategoryViewDelegate
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    
    [self.listContainerView didClickSelectedItemAtIndex:index];
}

- (void)categoryView:(JXCategoryBaseView *)categoryView scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio {
    
//    [self.listContainerView scrollingFromLeftIndex:leftIndex toRightIndex:rightIndex ratio:ratio selectedIndex:categoryView.selectedIndex];
}

#pragma mark - JXCategoryListContainerViewDelegate
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {

    if (index == 0) {
        return self.mineTableView;
    } else if (index == 1) {
        return self.hotTableView;
    } else {
        return self.allTableView;
    }
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.categoryView.titles.count;
}

#pragma mark - Setter Getter
- (void)setCurrentSelectType:(DynamicPostWorldRequestType)currentSelectType {
    _currentSelectType = currentSelectType;
    
    NSInteger index = 0;
    switch (currentSelectType) {
        case DynamicPostWorldRequestTypeMine:
            index = 0;
            break;
        case DynamicPostWorldRequestTypeRecommend:
            index = 1;
            break;
        case DynamicPostWorldRequestTypeAll:
            index = 2;
            break;
    }
    
    self.listContainerView.defaultSelectedIndex = index;
    self.categoryView.defaultSelectedIndex = index;
    [self.categoryView reloadData];
}

- (NSArray *)titles {
    return @[@"我加入的", @"大家都在聊", @"全部"];
}

- (UIView *)containerView {
    if (_containerView == nil) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = UIColor.whiteColor;
    }
    return _containerView;
}

- (JXCategoryListContainerView *)listContainerView {
    if (_listContainerView == nil) {
        _listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
        _listContainerView.defaultSelectedIndex = 0;
        _listContainerView.scrollView.scrollEnabled = YES;
    }
    return _listContainerView;
}

- (JXCategoryTitleView *)categoryView {
    if (_categoryView == nil) {
        JXCategoryTitleView *view = [[JXCategoryTitleView alloc] init];
        view.delegate = self;
        view.contentScrollView = self.listContainerView.scrollView;

        view.titleLabelAnchorPointStyle = JXCategoryTitleLabelAnchorPointStyleBottom;
        view.titleColor = UIColorFromRGB(0xb3b3b3);
        view.titleSelectedColor = [XCTheme getTTMainTextColor];
        view.titleFont = [UIFont systemFontOfSize:16];
        view.titleSelectedFont = [UIFont systemFontOfSize:16];
                
        JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
        lineView.indicatorColor = [XCTheme getTTMainColor];
        lineView.indicatorWidth = 12;
        lineView.verticalMargin = 4;
        lineView.indicatorCornerRadius = 2;
        view.indicators = @[lineView];
        
        view.titles = [self titles];
        
        _categoryView = view;
    }
    return _categoryView;
}

- (UIButton *)closeButton {
    if (_closeButton == nil) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.backgroundColor = UIColorFromRGB(0xe6e6e6);
        _closeButton.layer.cornerRadius = 3;
        _closeButton.layer.masksToBounds = YES;
        
        [_closeButton addTarget:self action:@selector(didClickCloseButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [_closeButton enlargeTouchArea:UIEdgeInsetsMake(10, 5, 5, 5)];
    }
    return _closeButton;
}

- (LLPostDynamicLittleWorldAlertTableView *)allTableView {
    if (_allTableView == nil) {
        _allTableView = [[LLPostDynamicLittleWorldAlertTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _allTableView.requestType = DynamicPostWorldRequestTypeAll;
        
        @weakify(self)
        _allTableView.selectWorldHandler = ^(LittleWorldDynamicPostWorld * _Nonnull model) {
            @strongify(self)
            !self.selectWorldHandler ?: self.selectWorldHandler(model);
            [TTPopup dismiss];
        };
    }
    return _allTableView;
}

- (LLPostDynamicLittleWorldAlertTableView *)mineTableView {
    if (_mineTableView == nil) {
        _mineTableView = [[LLPostDynamicLittleWorldAlertTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mineTableView.requestType = DynamicPostWorldRequestTypeMine;
        
        @weakify(self)
        _mineTableView.selectWorldHandler = ^(LittleWorldDynamicPostWorld * _Nonnull model) {
            @strongify(self)
            !self.selectWorldHandler ?: self.selectWorldHandler(model);
            [TTPopup dismiss];
        };
    }
    return _mineTableView;
}

- (LLPostDynamicLittleWorldAlertTableView *)hotTableView {
    if (_hotTableView == nil) {
        _hotTableView = [[LLPostDynamicLittleWorldAlertTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _hotTableView.requestType = DynamicPostWorldRequestTypeRecommend;
        
        @weakify(self)
        _hotTableView.selectWorldHandler = ^(LittleWorldDynamicPostWorld * _Nonnull model) {
            @strongify(self)
            !self.selectWorldHandler ?: self.selectWorldHandler(model);
            [TTPopup dismiss];
        };
    }
    return _hotTableView;
}

@end
