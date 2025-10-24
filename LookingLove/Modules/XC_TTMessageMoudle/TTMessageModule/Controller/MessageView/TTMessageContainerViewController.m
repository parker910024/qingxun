//
//  TTDiscoverContainViewController.m
//  TuTu
//
//  Created by lee on 2018/12/28.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTMessageContainerViewController.h"

#import "TTMessageContainerNavView.h"

#import "TTMessageViewController.h"
#import "TTContactViewController.h"

#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"

#import <Masonry/Masonry.h>
#import <JXCategoryView/JXCategoryView.h>
#import <JXCategoryView/JXCategoryTitleVerticalZoomView.h>

@interface TTMessageContainerViewController ()
<
JXCategoryViewDelegate,
JXCategoryListContainerViewDelegate
>

/// 自定义导航栏
@property (nonatomic, strong) TTMessageContainerNavView *navigationView;

/// 控制器视图容器
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;

/// 消息控制器
@property (nonatomic, strong) TTMessageViewController *messageVC;
/// 联系人控制器
@property (nonatomic, strong) TTContactViewController *contactVC;

@end

@implementation TTMessageContainerViewController

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

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    //解决iOS12从推送进入前台跳转消息页导致底部黑屏问题
    self.view.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight-kTabBarHeight);
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
        return self.messageVC;
    }
    
    return self.contactVC;
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.navigationView.categoryView.titles.count;
}

#pragma mark - private method
- (void)initView {
    
    [self addChildViewController:self.messageVC];
    [self addChildViewController:self.contactVC];
    
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
    return @[@"消息", @"联系人"];
}

#pragma mark - setters and getters
- (TTMessageContainerNavView *)navigationView {
    if (!_navigationView) {
        _navigationView = [[TTMessageContainerNavView alloc] init];
        _navigationView.categoryView.delegate = self;
    }
    return _navigationView;
}

- (JXCategoryListContainerView *)listContainerView {
    if (!_listContainerView) {
        _listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
        _listContainerView.defaultSelectedIndex = 0;
        _listContainerView.scrollView.scrollEnabled = NO;
    }
    return _listContainerView;
}

- (TTMessageViewController *)messageVC {
    if (!_messageVC) {
        _messageVC = [[TTMessageViewController alloc] init];
    }
    return _messageVC;
}

- (TTContactViewController *)contactVC {
    if (!_contactVC) {
        _contactVC = [[TTContactViewController alloc] init];
    }
    return _contactVC;
}

@end
