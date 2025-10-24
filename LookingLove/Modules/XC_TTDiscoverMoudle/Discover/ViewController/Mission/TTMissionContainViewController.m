//
//  TTMissionContainViewController.m
//  XC_TTDiscoverMoudle
//
//  Created by lee on 2019/4/17.
//  Copyright © 2019 fengshuo. All rights reserved.
//

#import "TTMissionContainViewController.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"
#import "TTMissionNavView.h"
#import "TTMissionGuildView.h"
// tool
#import <JXCategoryView/JXCategoryView.h>
#import <JXCategoryView/JXCategoryListContainerView.h>
// vc
#import "TTMissionViewController.h"
#import "TTMineInfoViewController.h"

static NSString *const kGuideStatusStoreKey = @"TTMissionViewControllerGuideStatus";

@interface TTMissionContainViewController ()<JXCategoryViewDelegate, JXCategoryListContainerViewDelegate, TTMissionNavViewDelegate>
/** 分页标题 */
@property (nonatomic, strong) NSArray<NSString *> *titles;
/** 分页控件 */
@property (nonatomic, strong) JXCategoryTitleView *titleView;
/** 分页lineView */

@property (nonatomic, strong) JXCategoryListContainerView *contentView;
@property (nonatomic, strong) TTMissionNavView *navView;//自定义导航栏
@property (nonatomic, strong) UIImageView *headBgView;  // 头部背景view

@property (nonatomic, strong) TTMissionViewController *routineMissionVC;//每日任务控制器
@property (nonatomic, strong) TTMissionViewController *achieveMissionVC;//成就任务控制器

@property (nonatomic, strong) TTMissionGuildView *guildView;//新手引导
@end

@implementation TTMissionContainViewController

#pragma mark - lifeCycle
- (void)dealloc {
    
}

- (BOOL)isHiddenNavBar {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [XCTheme getTTSimpleGrayColor];
    
    [self initViews];
    [self initConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.routineMissionVC updateData];
    [self.achieveMissionVC updateData];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)initViews {
    [self.view addSubview:self.headBgView];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.titleView];
    [self.view addSubview:self.contentView];
    
    //  轻寻不展示新手引导
    if (projectType() == ProjectType_LookingLove || projectType() == ProjectType_Planet) {
        return;
    }
    // 首次显示引导
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    BOOL hadGuide = [ud boolForKey:kGuideStatusStoreKey];
    if (!hadGuide) {
        [ud setBool:YES forKey:kGuideStatusStoreKey];
        [ud synchronize];

        [[UIApplication sharedApplication].keyWindow addSubview:self.guildView];
    }
}

- (void)initConstraints {
    [self.headBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.view);
        make.height.mas_equalTo(184 + statusbarHeight);
    }];
    
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(kNavigationHeight);
    }];
    
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.navView.mas_bottom);
        make.height.mas_equalTo(56);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleView.mas_bottom).offset(15);
        make.left.right.bottom.mas_equalTo(self.view);
//        make.height.mas_equalTo(KScreenHeight);
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    // Demo 默认是写 frame 的
//    self.titleView.frame = CGRectMake(0, kNavigationHeight, KScreenWidth, kTitleViewHeight);
//    CGFloat contentY = kTitleViewHeight + kNavigationHeight + 15;
//    self.contentView.frame = CGRectMake(0, contentY, KScreenWidth, KScreenHeight - kTitleViewHeight - kSafeAreaBottomHeight);
}

#pragma mark - JXCategoryListContainerViewDelegate
- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.titles.count;
}

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    
    TTMissionViewController *vc = index == 1 ? self.achieveMissionVC : self.routineMissionVC;
    return vc;
}

#pragma mark - JXCategoryViewDelegate
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    
    [self.contentView didClickSelectedItemAtIndex:index];
}

- (void)categoryView:(JXCategoryBaseView *)categoryView scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio {
    
//    [self.contentView scrollingFromLeftIndex:leftIndex toRightIndex:rightIndex ratio:ratio selectedIndex:categoryView.selectedIndex];
}

#pragma mark -
#pragma mark TTMissionNavViewDelegate
- (void)didClickBackButtonInMissionNavView:(TTMissionNavView *)navView {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - getter & setter
- (JXCategoryTitleView *)titleView {
    if (!_titleView) {
        _titleView = [[JXCategoryTitleView alloc] init];
        _titleView.delegate = self;
        _titleView.titles = self.titles;
        _titleView.titleColor = UIColor.whiteColor;
        _titleView.titleSelectedColor = UIColor.whiteColor;
        _titleView.titleFont = [UIFont systemFontOfSize:15];
        _titleView.titleLabelAnchorPointStyle = JXCategoryTitleLabelAnchorPointStyleCenter;
        _titleView.contentScrollViewClickTransitionAnimationEnabled = NO;
        _titleView.defaultSelectedIndex = 0;
        _titleView.contentScrollView = self.contentView.scrollView;
        
        JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
        lineView.indicatorColor = UIColor.whiteColor;
        lineView.indicatorWidth = 17.f;
        lineView.indicatorHeight = 4.f;
        lineView.indicatorCornerRadius = 2.f;
        _titleView.indicators = @[lineView];
    }
    return _titleView;
}

- (JXCategoryListContainerView *)contentView {
    if (!_contentView) {
        _contentView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
        _contentView.defaultSelectedIndex = 0;
    }
    return _contentView;
}

- (TTMissionNavView *)navView {
    if (_navView == nil) {
        _navView = [[TTMissionNavView alloc] init];
        _navView.delegate = self;
    }
    return _navView;
}

- (UIImageView *)headBgView {
    if (!_headBgView) {
        _headBgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"discover_mession_bg"]];
    }
    return _headBgView;
}

- (NSArray<NSString *> *)titles {
    if (!_titles) {
        _titles = @[@"每日任务", @"成就任务"];
    }
    return _titles;
}

- (TTMissionViewController *)routineMissionVC {
    if (!_routineMissionVC) {
        _routineMissionVC = [[TTMissionViewController alloc] init];
        _routineMissionVC.type = 1;
    }
    return _routineMissionVC;
}

- (TTMissionViewController *)achieveMissionVC {
    if (!_achieveMissionVC) {
        _achieveMissionVC = [[TTMissionViewController alloc] init];
        _achieveMissionVC.isAchievement = YES;
        _achieveMissionVC.type = 2;
    }
    return _achieveMissionVC;
}

- (TTMissionGuildView *)guildView {
    if (!_guildView) {
        _guildView = [[TTMissionGuildView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _guildView;
}

@end
