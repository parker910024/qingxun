//
//  TTWorldListContainerViewController.m
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2019/7/1.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTWorldListContainerViewController.h"

#import "TTWorldListViewController.h"

#import "LittleWorldCoreClient.h"
#import "LittleWorldCore.h"

#import "XCMacros.h"
#import "NSArray+Safe.h"
#import "XCTheme.h"
#import "XCHUDTool.h"
#import "UIViewController+EmptyDataView.h"

#import <JXCategoryView/JXCategoryView.h>
#import <JXCategoryView/JXCategoryListContainerView.h>
#import <Masonry/Masonry.h>

@interface TTWorldListContainerViewController ()
<
JXCategoryViewDelegate,
JXCategoryListContainerViewDelegate,
LittleWorldCoreClient
>

@property (nonatomic, strong) NSArray<LittleWorldCategory *> *categoryArray;//分类列表
@property (nonatomic, strong) NSMutableArray <TTWorldListViewController *> *vcArray;//控制器

@property (nonatomic, strong) JXCategoryTitleView *categoryView;

/**
 各个控制器视图容器
 */
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;

@end

@implementation TTWorldListContainerViewController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"全部小世界";
    
    [self initViews];
    [self initConstraints];
    
    AddCoreClient(LittleWorldCoreClient, self);
    
    self.vcArray = [NSMutableArray array];
    
    [self requestData];
}

- (void)dealloc {
    RemoveCoreClientAll(self);
}

- (void)reloadDataWhenLoadFail {
    [self requestData];
}

#pragma mark - Public Methods
#pragma mark - System Protocols
#pragma mark - Custom Protocols
#pragma mark JXCategoryViewDelegate
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    
    [self.listContainerView didClickSelectedItemAtIndex:index];
}

- (void)categoryView:(JXCategoryBaseView *)categoryView scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio {
    
//    [self.listContainerView scrollingFromLeftIndex:leftIndex toRightIndex:rightIndex ratio:ratio selectedIndex:categoryView.selectedIndex];
}

#pragma mark JXCategoryListContainerViewDelegate
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    
    TTWorldListViewController *vc = [self.vcArray safeObjectAtIndex:index];
    return vc;
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.categoryArray.count;
}

#pragma mark - Core Protocols
#pragma mark LittleWorldCoreClient
- (void)responseWorldFullCategoryList:(NSArray<LittleWorldCategory *> *)data code:(NSNumber *)errorCode msg:(NSString *)msg {
    
    if (data == nil) {
        
        [XCHUDTool showErrorWithMessage:msg];
        [self showLoadFailViewWithTitle:msg image:[UIImage imageNamed:@"common_noData_empty"]];
        return;
    }
    
    [XCHUDTool hideHUDInView:self.listContainerView];

    @weakify(self)

    for (LittleWorldCategory *cat in data) {
        
        TTWorldListViewController *vc = [[TTWorldListViewController alloc] init];
        vc.worldTypeId = cat.typeId;
        [self.vcArray addObject:vc];
        
        vc.jumpTabBlock = ^(NSString * _Nonnull worldTypeId) {
            @strongify(self)
            [self jumpTabWithTypeId:worldTypeId];
        };
    }
    
    self.categoryArray = data;
    
    __block NSUInteger jumpIndex = 0;
    [self.categoryArray enumerateObjectsUsingBlock:^(LittleWorldCategory * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj.typeId isEqualToString:self.worldTypeId]) {
            jumpIndex = idx;
            *stop = YES;
        }
    }];
    
    NSArray *titles = [data valueForKeyPath:@"typeName"];
    self.categoryView.titles = titles;
    
    self.categoryView.defaultSelectedIndex = jumpIndex;
    [self.listContainerView didClickSelectedItemAtIndex:jumpIndex];
    
    [self.listContainerView reloadData];
    [self.categoryView reloadData];
}

#pragma mark - Event Responses
#pragma mark - Private Methods
#pragma mark layout
- (void)initViews {
    [self.view addSubview:self.categoryView];
    [self.view addSubview:self.listContainerView];
    
    self.categoryView.contentScrollView = self.listContainerView.scrollView;
}

- (void)initConstraints {
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavigationHeight);
        make.left.right.mas_equalTo(self.view).inset(8);
        make.height.mas_equalTo(46);
    }];
    
    [self.listContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.categoryView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-kSafeAreaBottomHeight);
    }];
}

- (void)jumpTabWithTypeId:(NSString *)typeId {
    
    __block NSUInteger jumpIndex = 0;
    
    [self.categoryArray enumerateObjectsUsingBlock:^(LittleWorldCategory * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj.typeId isEqualToString:typeId]) {
            jumpIndex = idx;
            *stop = YES;
        }
    }];
    
    [self.categoryView selectItemAtIndex:jumpIndex];
    [self.listContainerView didClickSelectedItemAtIndex:jumpIndex];
}

- (void)requestData {
    [GetCore(LittleWorldCore) requestWorldFullCategoryList];
}

#pragma mark - Getters and Setters
- (JXCategoryListContainerView *)listContainerView {
    if (!_listContainerView) {
        _listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
        _listContainerView.defaultSelectedIndex = 0;
    }
    return _listContainerView;
}

- (JXCategoryTitleView *)categoryView {
    if (!_categoryView) {
        JXCategoryTitleView *view = [[JXCategoryTitleView alloc] init];
        view.delegate = self;
        view.backgroundColor = UIColor.clearColor;
        view.titleLabelAnchorPointStyle = JXCategoryTitleLabelAnchorPointStyleBottom;
        
        view.averageCellSpacingEnabled = NO;
        view.titleColorGradientEnabled = YES;
        view.cellWidthZoomEnabled = YES;
        
        view.titleColor = [XCTheme getTTDeepGrayTextColor];
        view.titleSelectedColor = [XCTheme getTTMainTextColor];
        view.titleFont = [UIFont systemFontOfSize:15];
        view.titleSelectedFont = [UIFont boldSystemFontOfSize:16];
        
        view.contentEdgeInsetLeft = 6;
        view.cellSpacing = 20;
        
        JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
        lineView.indicatorColor = UIColorFromRGB(0xFBB606);
        lineView.indicatorWidth = 17;
        lineView.indicatorHeight = 4;
        lineView.indicatorCornerRadius = 2;
        view.indicators = @[lineView];
        
        _categoryView = view;
    }
    return _categoryView;
}

@end
