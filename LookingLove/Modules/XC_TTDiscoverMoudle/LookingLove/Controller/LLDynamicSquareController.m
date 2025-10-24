//
//  LLDynamicSquareController.m
//  XC_TTDiscoverMoudle
//
//  Created by Lee on 2020/1/6.
//  Copyright © 2020 fengshuo. All rights reserved.
//

#import "LLDynamicSquareController.h"
#import "LLDynamicListBaseController.h"

#import "XCMediator+TTGameModuleBridge.h"

#import "LLDynamicHomeController.h"
#import <JXCategoryView/JXCategoryView.h>

#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"
#import "UIView+XCToast.h"
#import "TTStatisticsService.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"
#import "UIView+XCToast.h"
#import "AuthCoreClient.h"
#import "AuthCore.h"
#import "UserInfo.h"
#import "UserCore.h"
#import "UIView+NTES.h"

static CGFloat const kCategoryViewH = 49;
@interface LLDynamicSquareController ()<JXCategoryViewDelegate, JXCategoryListContainerViewDelegate, AuthCoreClient>

@property (nonatomic, strong) LLDynamicListBaseController *recommendVc;
@property (nonatomic, strong) LLDynamicListBaseController *followVc;
@property (nonatomic, strong) LLDynamicHomeController *homeVc;

@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) NSArray<NSString *> *titles;
@property (nonatomic, strong) JXCategoryIndicatorLineView *lineView;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;

@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation LLDynamicSquareController

- (void)dealloc {
    RemoveCoreClientAll(self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AddCoreClient(AuthCoreClient, self);
    
    
    [self addChildViewController:self.recommendVc];
    [self addChildViewController:self.followVc];
 
    [self.view addSubview:self.categoryView];
    [self.view addSubview:self.listContainerView];
    
    
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(kCategoryViewH);
    }];
    
    [self.listContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.categoryView.mas_bottom);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
}

- (BOOL)isHiddenNavBar {
    return YES;
}

- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.listContainerView.scrollView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.didScrollCallback = callback;
}

- (void)refreshFollowVcData {
    [self.followVc refreshData];
}

#pragma mark - JXCategoryViewDelegate
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    
    NSString *event = index == 1 ? @"关注" : @"推荐";
    [TTStatisticsService trackEvent:@"square_recommend_follow" eventDescribe:event];
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    
    [self.listContainerView didClickSelectedItemAtIndex:index];
}

- (void)categoryView:(JXCategoryBaseView *)categoryView scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio {
    

//    [self.listContainerView scrollingFromLeftIndex:leftIndex toRightIndex:rightIndex ratio:ratio selectedIndex:categoryView.selectedIndex];
}

#pragma mark - JXCategoryListContainerViewDelegate
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    
    if (index == 0) {
        return self.recommendVc;
    }

    return self.followVc;
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.categoryView.titles.count;
}

#pragma mark -
#pragma mark authCoreClient
- (void)onLoginSuccess {
    
    [self.followVc refreshData];
}

#pragma mark -
#pragma mark Getter && Setter
- (JXCategoryTitleView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[JXCategoryTitleView alloc] init];
        _categoryView.titles = self.titles;
        _categoryView.backgroundColor = [UIColor whiteColor];
        _categoryView.delegate = self;
        _categoryView.titleSelectedColor = [XCTheme getTTMainTextColor];
        _categoryView.titleColor = [XCTheme getTTDeepGrayTextColor];
        _categoryView.titleFont = [UIFont systemFontOfSize:16];
        _categoryView.titleSelectedFont = [UIFont boldSystemFontOfSize:16];
        _categoryView.titleColorGradientEnabled = YES;
        _categoryView.titleLabelZoomEnabled = NO;
        _categoryView.indicators = @[self.lineView];
        _categoryView.contentScrollView = self.listContainerView.scrollView;
        _categoryView.averageCellSpacingEnabled = NO;
    }
    return _categoryView;
}


- (JXCategoryIndicatorLineView *)lineView {
    if (!_lineView) {
        _lineView = [[JXCategoryIndicatorLineView alloc] init];
        _lineView.indicatorColor = [XCTheme getTTMainColor];
        _lineView.indicatorWidth = 12;
        _lineView.verticalMargin = 3;
    }
    return _lineView;
}


- (NSArray<NSString *> *)titles {
    if (!_titles) {
        _titles = @[@"推荐", @"关注"];
    }
    return _titles;
}

- (LLDynamicListBaseController *)recommendVc {
    if (!_recommendVc) {
        _recommendVc = [[LLDynamicListBaseController alloc] init];
        _recommendVc.type = LLDynamicCircleTypePlayground;
    }
    return _recommendVc;
}

- (LLDynamicListBaseController *)followVc {
    if (!_followVc) {
        _followVc = [[LLDynamicListBaseController alloc] init];
        _followVc.type = LLDynamicCircleTypeAttention;
    }
    return _followVc;
}

- (LLDynamicHomeController *)homeVc {
    if (!_homeVc) {
        _homeVc = [[LLDynamicHomeController alloc] init];
    }
    return _homeVc;
}

- (JXCategoryListContainerView *)listContainerView {
    if (!_listContainerView) {
        _listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_CollectionView delegate:self];
        _listContainerView.defaultSelectedIndex = 0;
    }
    return _listContainerView;
}

@end
