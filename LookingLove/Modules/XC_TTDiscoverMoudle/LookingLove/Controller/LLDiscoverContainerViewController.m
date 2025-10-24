//
//  TTDiscoverContainViewController.m
//  TuTu
//
//  Created by lee on 2018/12/28.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "LLDiscoverContainerViewController.h"

#import "TTDiscoverContainNavView.h"

#import "LLDiscoverViewController.h"
#import "LLDiscoverFamilyViewController.h"
#import "TTDynamicMessageViewController.h"
#import "LLDynamicSquareController.h"

#import "MessageCore.h"
#import "MessageCoreClient.h"

#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"
#import "TTStatisticsService.h"
#import "LookingLoveManager.h"

#import <Masonry/Masonry.h>
#import <JXCategoryView/JXCategoryView.h>
#import <JXCategoryView/JXCategoryTitleVerticalZoomView.h>
#import <JXPagingView/JXPagerView.h>
#import <JXPagingView/JXPagerListRefreshView.h>
#import "UIButton+EnlargeTouchArea.h"
#import "XCMediator+TTGameModuleBridge.h"

@interface LLDiscoverContainerViewController ()
<
JXCategoryViewDelegate,
JXPagerViewDelegate,
MessageCoreClient
>

/**
 自定义导航栏
 */
@property (nonatomic, strong) TTDiscoverContainNavView *navigationView;

/**
 各个控制器视图容器
 */
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;
@property (nonatomic, strong) JXPagerView *pagerView;

@property (nonatomic, strong) LLDiscoverViewController *discoverVc;
@property (nonatomic, strong) LLDiscoverFamilyViewController *familyVc;
@property (nonatomic, strong) LLDynamicSquareController *dynamicSquareVc;
@property (nonatomic, strong) UIView *coverView; // 遮罩

/// 动态消息
@property (nonatomic, strong) UILabel *msgCountLabel;//数字
@property (nonatomic, strong) UIView *msgCountBgView;//红点
@property (nonatomic, strong) UIButton *alertButton;//铃铛

@property (nonatomic, strong) UIButton *postDynamicBtn;
@end

@implementation LLDiscoverContainerViewController

#pragma mark - life cycle
- (void)dealloc {
    RemoveCoreClientAll(self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AddCoreClient(MessageCoreClient, self);

    self.navigationView.categoryView.titles = [self titleArray];
    self.navigationView.categoryView.contentScrollView = self.pagerView.listContainerView.collectionView;
    
    [self.navigationView.categoryView reloadData];
    
    [self initView];
    [self initConstrations];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [LookingLoveManager lookingLoveDiscoverDidShow:7];

    [self updateMsgCount:GetCore(MessageCore).unread.total];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [LookingLoveManager lookingLoveDiscoverWillShow:9];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    //解决iOS12从推送进入前台跳转消息页导致底部黑屏问题
    self.view.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight-kTabBarHeight);
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.pagerView.frame = self.view.bounds;
}

#pragma mark - Overriden
- (BOOL)isHiddenNavBar {
    return YES;
}

#pragma mark - MessageCoreClient
/// 动态消息个数更新通知
- (void)onUpdateDynamicMessageCount:(DynamicMessageUnread *)count {
    [self updateMsgCount:count.total];
}

#pragma mark - TTDiscoverContainNavViewDelegate
/// 点击消息个数
- (void)navViewDidClickMsgCount:(TTDiscoverContainNavView *)navView {
    TTDynamicMessageViewController *vc = [[TTDynamicMessageViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - JXPagerViewDelegate
- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.navigationView;
}
//
- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    // headView 的高度
    return kNavigationHeight;
}
//
- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return 0;
}
//
- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return nil;
}
//
- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    return [self titleArray].count;
}
//
- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {

    if (index == 0) {
        return self.dynamicSquareVc;
    }
    
    if (index == 1) {
        return self.discoverVc;
    }
    
    return self.familyVc;;
}

- (void)mainTableViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offSetY = scrollView.contentOffset.y;
    CGFloat alpha = offSetY / statusbarHeight;
    
    self.coverView.alpha = alpha;
}

#pragma mark - JXCategoryViewDelegate
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    
    [self updateMsgViewShowStatus:index == 0];
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    
    if (index == 1) { // 家族tab
        [TTStatisticsService trackEvent:@"home_family_click" eventDescribe:@"家族tab"];
    }
}

#pragma mark - Actions
- (void)didClickMsgCountButton:(UIButton *)sender {
    TTDynamicMessageViewController *vc = [[TTDynamicMessageViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - private method
- (void)initView {
    
    [self addChildViewController:self.dynamicSquareVc];
    [self addChildViewController:self.discoverVc];
    [self addChildViewController:self.familyVc];

    [self.view addSubview:self.pagerView];
    [self.view addSubview:self.coverView];
    
    [self setupDynamicMsgCount];
    
    [self.view addSubview:self.postDynamicBtn];
    [self.postDynamicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-25);
        make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-kSafeAreaBottomHeight- 15);
        make.width.height.mas_equalTo(49);
    }];
}

- (void)initConstrations {
    [self.listContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

/// 设置消息数量显示
- (void)setupDynamicMsgCount {
    UIButton *alertButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [alertButton setImage:[UIImage imageNamed:@"message_main_bell"] forState:UIControlStateNormal];
    [alertButton addTarget:self action:@selector(didClickMsgCountButton:) forControlEvents:UIControlEventTouchUpInside];
    [alertButton enlargeTouchArea:UIEdgeInsetsMake(10, 10, 10, 10)];
    self.alertButton = alertButton;
    [self.view addSubview:alertButton];
    
    UIView *countBgView = [[UIView alloc] init];
    countBgView.backgroundColor = UIColorFromRGB(0xFF2D55);
    countBgView.layer.masksToBounds = YES;
    countBgView.layer.cornerRadius = 9;
    countBgView.userInteractionEnabled = NO;
    self.msgCountBgView = countBgView;
    [self.view addSubview:countBgView];
    
    UILabel *countLabel = [[UILabel alloc] init];
    countLabel.font = [UIFont boldSystemFontOfSize:12];
    countLabel.textColor = [UIColor whiteColor];
    countLabel.textAlignment = NSTextAlignmentCenter;
    self.msgCountLabel = countLabel;
    [countBgView addSubview:countLabel];
    
    [alertButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(statusbarHeight+10);
    }];
    
    [countBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(18);
        make.centerY.mas_equalTo(alertButton.mas_top);
        make.centerX.mas_equalTo(alertButton.mas_right);
        make.width.mas_greaterThanOrEqualTo(18);
    }];
    
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.right.mas_equalTo(countBgView).inset(4);
    }];
    
    [self updateMsgCount:0];
}

/// 更新消息个数，小于1时隐藏红点
- (void)updateMsgCount:(NSInteger)count {
    self.msgCountLabel.text = @(count).stringValue;
    self.msgCountBgView.hidden = self.alertButton.hidden || count <= 0;
}

/// 更新动态消息显示状态
/// @param isShow 是否显示
- (void)updateMsgViewShowStatus:(BOOL)isShow {
    
    BOOL zeroCount = self.msgCountLabel.text.intValue == 0;

    self.alertButton.hidden = !isShow;
    self.msgCountBgView.hidden = !isShow || zeroCount;
    self.postDynamicBtn.hidden = !isShow;
}

#pragma mark -
#pragma mark button Event
- (void)onClickPostDynamicButton:(UIButton *)postBtn {
    // 发布动态
    @weakify(self);
    UIViewController *vc = [[XCMediator sharedInstance] ttGameMoudle_LLPostDynamicViewControllerWithRefresh:^{
        @strongify(self);
        // 发布成功后，刷新关注页
        [self.dynamicSquareVc refreshFollowVcData];
    }];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    NSString *des = [NSString stringWithFormat:@"发布动态:%@", @"动态广场"];
    [TTStatisticsService trackEvent:@"world_publish_moments_b" eventDescribe:des];
    [TTStatisticsService trackEvent:@"world_publish_moments" eventDescribe:@"发布动态：无小世界"];
}

/**
 获取分组标题列表
 */
- (NSArray *)titleArray {
    return @[@"广场", @"发现", @"家族"];
}

#pragma mark - setters and getters
- (TTDiscoverContainNavView *)navigationView {
    if (!_navigationView) {
        _navigationView = [[TTDiscoverContainNavView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, kNavigationHeight)];
        _navigationView.backgroundColor = [UIColor whiteColor];
        _navigationView.categoryView.delegate = self;
    }
    return _navigationView;
}

- (JXPagerView *)pagerView {
    if (!_pagerView) {
        _pagerView = [[JXPagerListRefreshView alloc] initWithDelegate:self];
        // 由于这里是隐藏导航栏的做法，所以要减去自定义导航栏的高度。
        _pagerView.pinSectionHeaderVerticalOffset = statusbarHeight;
        _pagerView.defaultSelectedIndex = 0;
    }
    return _pagerView;
}

- (LLDiscoverFamilyViewController *)familyVc {
    if (!_familyVc) {
        _familyVc = [[LLDiscoverFamilyViewController alloc] init];
    }
    return _familyVc;
}

- (LLDiscoverViewController *)discoverVc {
    if (!_discoverVc) {
        _discoverVc = [[LLDiscoverViewController alloc] init];
    }
    return _discoverVc;
}

- (LLDynamicSquareController *)dynamicSquareVc {
    if (!_dynamicSquareVc) {
        _dynamicSquareVc = [[LLDynamicSquareController alloc] init];
    }
    return _dynamicSquareVc;
}

- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, statusbarHeight)];
        _coverView.backgroundColor = [UIColor whiteColor];
        _coverView.alpha = 0;
    }
    return _coverView;
}

- (UIButton *)postDynamicBtn {
    if (!_postDynamicBtn) {
        _postDynamicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_postDynamicBtn setImage:[UIImage imageNamed:@"square_postDynamicBtn_icon"] forState:UIControlStateNormal];
        [_postDynamicBtn addTarget:self action:@selector(onClickPostDynamicButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _postDynamicBtn;
}

@end
