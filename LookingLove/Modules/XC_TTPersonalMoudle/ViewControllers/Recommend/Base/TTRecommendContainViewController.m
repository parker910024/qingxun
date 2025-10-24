//
//  TTRecommendContainViewController.m
//  TTPlay
//
//  Created by lee on 2019/2/12.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTRecommendContainViewController.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"
// tool
#import "TTDressUpSelectTabView.h"
#import "ZJScrollPageView.h"
#import "UIButton+EnlargeTouchArea.h"
// const
#import "XCMacros.h"
#import "XCHtmlUrl.h"
#import <ReactiveObjC/ReactiveObjC.h>
// vc
#import "TTMyRecommendBaseController.h"
#import "TTRecommendUnusedViewController.h"
#import "TTRecommendUsingViewController.h"
#import "TTRecommendUsedViewController.h"
#import "TTRecommendInvalidViewController.h"
#import "TTWKWebViewViewController.h"


@interface TTRecommendContainViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) TTDressUpSelectTabView *selectTabView;
@property (nonatomic, strong) ZJScrollPageView *scrollPageView;
@property (nonatomic, strong) NSArray<NSString *> *titles;
@property (nonatomic, strong) ZJSegmentStyle *segmentView;
/// 选中的 button
@property (nonatomic, strong) UIButton *selectedButton;
/// 底部的所有内容
@property (nonatomic, strong) UIScrollView *contentView;
@end

@implementation TTRecommendContainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的推荐位";
    
    [self initViews];
    [self initConstraints];
    [self setupChildViewControllers];
//    [self setupContentView];
    
    [self addNavigationItemWithImageNames:@[@"recommend_help_icon"] isLeft:NO target:self action:@selector(rightItemClickAction:) tags:@[@1001]];
}

- (void)rightItemClickAction:(UIButton *)btn {
    TTWKWebViewViewController *vc = [[TTWKWebViewViewController alloc] init];
    vc.urlString = HtmlUrlKey(kRecommendHelpURL);
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setupChildViewControllers {
    TTRecommendUnusedViewController *vc1 = [[TTRecommendUnusedViewController alloc] init];
    vc1.currentStyle = TTRecommendCellStyleUnUsed;
    
    TTRecommendUsingViewController *vc2 = [[TTRecommendUsingViewController alloc] init];
    vc2.currentStyle = TTRecommendCellStyleUsing;
    
    TTRecommendUsedViewController *vc3 = [[TTRecommendUsedViewController alloc] init];
    vc3.currentStyle = TTRecommendCellStyleUsed;
    
    TTRecommendInvalidViewController *vc4 = [[TTRecommendInvalidViewController alloc] init];
    vc4.currentStyle = TTRecommendCellStyleInvalid;
    
    [self addChildViewController:vc1];
    [self addChildViewController:vc2];
    [self addChildViewController:vc3];
    [self addChildViewController:vc4];
    
    self.contentView.contentSize = CGSizeMake(KScreenWidth * self.childViewControllers.count, 0);
    /// 添加第一个控制器 view
    [self scrollViewDidEndScrollingAnimation:self.contentView];
}

- (void)setupContentView
{
    // 不要自动调整 inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *contentView = [[UIScrollView alloc] init];
    contentView.frame = self.view.bounds;
    contentView.delegate = self;
    contentView.pagingEnabled = YES;
    contentView.showsVerticalScrollIndicator = NO;
    contentView.showsHorizontalScrollIndicator = NO;
    contentView.bounces = NO;
    
    [self.view insertSubview:contentView atIndex:0];

    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.width.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.top.mas_equalTo(self.selectTabView.mas_bottom);
    }];
    contentView.contentSize = CGSizeMake(KScreenWidth * self.childViewControllers.count, 0);
    self.contentView = contentView;
    /// 添加第一个控制器 view
    [self scrollViewDidEndScrollingAnimation:contentView];
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    scrollView.contentSize = CGSizeMake(KScreenWidth * self.childViewControllers.count, 0);
    // 当前索引
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    // 取出子控制器
    UIViewController *vc = self.childViewControllers[index];
    vc.view.zj_x = scrollView.contentOffset.x;
    vc.view.zj_y = 0;
    vc.view.zj_height = scrollView.frame.size.height;
    vc.view.zj_width = KScreenWidth;
    [scrollView addSubview:vc.view];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self scrollViewDidEndScrollingAnimation:scrollView];
    // 点击按钮
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.selectTabView.index = index;
}

#pragma mark -
#pragma mark lifeCycle
- (void)initViews {
    [self.view addSubview:self.selectTabView];
    [self.view insertSubview:self.contentView atIndex:0];
}

- (void)initConstraints {
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.width.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.top.mas_equalTo(self.selectTabView.mas_bottom);
    }];
}

#pragma mark -
#pragma mark clients

#pragma mark -
#pragma mark private methods

#pragma mark -
#pragma mark button click events

#pragma mark -
#pragma mark getter & setter
- (TTDressUpSelectTabView *)selectTabView {
    if (!_selectTabView) {
        
        @weakify(self);
        _selectTabView = [[TTDressUpSelectTabView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, KScreenWidth, 50) titles:self.titles];
        _selectTabView.selectBlock = ^(int selectIndex) {
            @strongify(self);
            // 滚动
            CGPoint offset = self.contentView.contentOffset;
            offset.x = selectIndex * self.contentView.zj_width;
            [self.contentView setContentOffset:offset animated:YES];
        };
        _selectTabView.backgroundColor = [UIColor whiteColor];
    }
    return _selectTabView;
}

- (NSArray<NSString *> *)titles {
    if (!_titles) {
        _titles = @[@"未使用", @"使用中", @"已使用", @"已失效"];
    }
    return _titles;
}

- (UIScrollView *)contentView {
    if (!_contentView) {
        _contentView = [[UIScrollView alloc] init];
        _contentView.frame = self.view.bounds;
        _contentView.delegate = self;
        _contentView.pagingEnabled = YES;
        _contentView.showsVerticalScrollIndicator = NO;
        _contentView.showsHorizontalScrollIndicator = NO;
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.bounces = NO;
    }
    return _contentView;
}
@end
