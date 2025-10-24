//
//  TTDiscoverContainViewController.m
//  TuTu
//
//  Created by lee on 2018/12/28.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTDiscoverContainViewController.h"

#import "TTDiscoverContainNavView.h"

#import <Masonry/Masonry.h>
#import <JXCategoryView/JXCategoryView.h>
#import <JXCategoryView/JXCategoryTitleVerticalZoomView.h>

#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"

// vc
#import "TTDiscoverViewController.h"
#import "XCMediator+TTHomeMoudle.h"

@interface TTDiscoverContainViewController ()
<
JXCategoryViewDelegate,
JXCategoryListContainerViewDelegate
>

/**
 自定义导航栏
 */
@property (nonatomic, strong) TTDiscoverContainNavView *navigationView;

/**
 各个控制器视图容器
 */
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;

@property(nonatomic, strong) TTDiscoverViewController *discoverVc;
@property(nonatomic, strong) UIViewController *familyVc;

@end

@implementation TTDiscoverContainViewController

#pragma mark - life cycle
- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationView.categoryView.titles = [self titleArray];
    self.navigationView.categoryView.contentScrollView = self.listContainerView.scrollView;
    [self.navigationView.categoryView reloadData];
    
    [self initView];
    [self initConstrations];
}

#pragma mark - Overriden
- (BOOL)isHiddenNavBar {
    return YES;
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
        return self.discoverVc;
    }
    
    id<JXCategoryListContentViewDelegate> vc;
    if ([self.familyVc conformsToProtocol:@protocol(JXCategoryListContentViewDelegate)]) {
        vc = (id)self.familyVc;
    }
    return vc;
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.navigationView.categoryView.titles.count;
}

#pragma mark - private method
- (void)initView {
    
    [self addChildViewController:self.discoverVc];
    [self addChildViewController:self.familyVc];
    
    [self.view addSubview:self.navigationView];
    [self.view addSubview:self.listContainerView];
}

- (void)initConstrations {
    [self.navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(kNavigationHeight);
    }];
    
    [self.listContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.navigationView.mas_bottom);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
}

/**
 获取分组标题列表
 */
- (NSArray *)titleArray {
    return @[@"发现", @"家族"];
}

#pragma mark - setters and getters
- (TTDiscoverContainNavView *)navigationView {
    if (!_navigationView) {
        _navigationView = [[TTDiscoverContainNavView alloc] init];
        _navigationView.categoryView.delegate = self;
    }
    return _navigationView;
}

- (JXCategoryListContainerView *)listContainerView {
    if (!_listContainerView) {
        _listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
        _listContainerView.defaultSelectedIndex = 0;
    }
    return _listContainerView;
}


- (UIViewController *)familyVc {
    if (!_familyVc) {
        _familyVc = [[XCMediator sharedInstance] ttHomeMoudle_familyViewController];
    }
    return _familyVc;
}

- (TTDiscoverViewController *)discoverVc {
    if (!_discoverVc) {
        _discoverVc = [[TTDiscoverViewController alloc] init];
    }
    return _discoverVc;
}

@end
