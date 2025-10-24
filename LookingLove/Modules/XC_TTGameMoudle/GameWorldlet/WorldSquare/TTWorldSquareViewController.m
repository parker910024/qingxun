//
//  TTWorldSquareViewController.m
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2019/6/28.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTWorldSquareViewController.h"

#import "TTWorldSquareBannerCell.h"
#import "TTWorldSquareWorldCell.h"
#import "TTWorldSquareNavView.h"
#import "TTWorldSquareSectionFooterView.h"
#import "TTWorldSquareSectionHeaderView.h"

#import "TTWorldSquareViewModel.h"
#import "TTWorldletConst.h"

#import "TTWorldSearchViewController.h"
#import "TTWorldListContainerViewController.h"
#import "TTWorldletContainerViewController.h"

#import "XCMediator+TTRoomMoudleBridge.h"

#import "AuthCore.h"
#import "BannerInfo.h"
#import "LittleWorldCoreClient.h"
#import "LittleWorldCore.h"
#import "P2PInteractiveAttachment.h"

#import "XCMacros.h"
#import "UIView+NTES.h"
#import "XCHUDTool.h"
#import "TTWKWebViewViewController.h"
#import "UIViewController+EmptyDataView.h"
#import "TTStatisticsService.h"
#import "BaseNavigationController.h"
#import "TTNewbieGuideView.h"
#import "TTStatisticsService.h"

#import <Masonry/Masonry.h>

static NSString *const kWorldCellId = @"kWorldCellId";
static NSString *const kBannerCellId = @"kBannerCellId";
static NSString *const kSectionHeaderId = @"kSectionHeaderId";
static NSString *const kSectionFooterId = @"kSectionFooterId";

@interface TTWorldSquareViewController ()
<
UICollectionViewDelegateFlowLayout,
TTWorldSquareNavViewDelegate,
TTWorldSquareBannerCellDelegate,
LittleWorldCoreClient
>

@property (nonatomic, strong) TTWorldSquareNavView *navView;

@property (nonatomic, strong) TTWorldSquareViewModel *viewModel;

@end

@implementation TTWorldSquareViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    AddCoreClient(LittleWorldCoreClient, self);
    
    [self initViews];
    [self initConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //初次加载页面显示 loading
    if (!self.viewModel.isDataModelInitailize) {
        [XCHUDTool showGIFLoadingInView:self.collectionView];
    }
    
    [self requestData];
}

- (void)dealloc {
    RemoveCoreClientAll(self);
}

- (BOOL)isHiddenNavBar {
    return YES;
}

/**
 点击失败占位图时的重载方法
 */
- (void)reloadDataWhenLoadFail {
    [self removeEmptyDataView];
    
    [XCHUDTool showGIFLoadingInView:self.collectionView];
    [self pullDownRefresh:0];
}

- (void)pullDownRefresh:(int)page {
    [self requestData];
}

#pragma mark - Public Methods
#pragma mark - System Protocols
#pragma mark UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.viewModel numberOfSections];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.viewModel numberOfItemsInSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.viewModel isBannerIndexPath:indexPath]) {
        
        TTWorldSquareBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBannerCellId forIndexPath:indexPath];
        cell.delegate = self;
        cell.bannerModelArray = self.viewModel.bannerArray;
        return cell;
    }
    
    TTWorldSquareWorldCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kWorldCellId forIndexPath:indexPath];
    
    if ([self.viewModel isFindNewWorldEntrance:indexPath]) {
        cell.findWorldEntrance = YES;
    } else {
        cell.findWorldEntrance = NO;
        cell.model = [self.viewModel dataForIndexPath:indexPath];
    }
    
    return cell;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.viewModel isBannerIndexPath:indexPath]) {
        return;
    }
    
    if ([self.viewModel isFindNewWorldEntrance:indexPath]) {
        //发现新世界，跳转到推荐
        
        [TTStatisticsService trackEvent:@"world-plaza-joined-find-world"
                          eventDescribe:@"世界广场-我加入的-发现新世界"];
        
        TTWorldListContainerViewController *vc = [[TTWorldListContainerViewController alloc] init];
        vc.worldTypeId = TTWorldletRecommendWorldTypeId;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    LittleWorldListItem *data = [self.viewModel dataForIndexPath:indexPath];
    if (data == nil) {
        return;
    }
    
    TTWorldletContainerViewController *vc = [[TTWorldletContainerViewController alloc] init];
    vc.worldId = data.worldId;
    [self.navigationController pushViewController:vc animated:YES];
    
    LittleWorldSquareClassify *classify = [self.viewModel classifyInfoForIndexPath:indexPath];
    NSString *event = [NSString stringWithFormat:@"世界广场-进入世界，分类：%@", classify.typeName];
    
    [TTStatisticsService trackEvent:@"world-square-into-world"
                      eventDescribe:event];
}

#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size = [self.viewModel sizeForItemAtIndexPath:indexPath];
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 8;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        TTWorldSquareSectionFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kSectionFooterId forIndexPath:indexPath];
        return footerView;
    }
    
    TTWorldSquareSectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kSectionHeaderId forIndexPath:indexPath];
    
    LittleWorldSquareClassify *classify = [self.viewModel classifyInfoForIndexPath:indexPath];
    if (classify) {
        headerView.nameLabel.text = classify.typeName;
    }
    
    @weakify(self)
    headerView.moreActionBlock = ^{
        @strongify(self)
        
        TTWorldListContainerViewController *vc = [[TTWorldListContainerViewController alloc] init];
        vc.worldTypeId = classify.typeId;
        [self.navigationController pushViewController:vc animated:YES];
        
        if ([classify.typeId isEqualToString:TTWorldletMyJoinedWorldTypeId]) {
            [TTStatisticsService trackEvent:@"world-plaza-joined-more"
                              eventDescribe:@"世界广场-我加入的-更多"];
        } else {
            [TTStatisticsService trackEvent:@"world-square-find-world-more"
                              eventDescribe:@"世界广场-发现世界-更多"];
        }
    };
    return headerView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    if ([self.viewModel isBannerIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]]) {
        return CGSizeZero;
    }
    
    return CGSizeMake(KScreenWidth, 70);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    
    if ([self.viewModel isBannerIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]]) {
        return CGSizeZero;
    }
    
    return CGSizeMake(KScreenWidth, 10);
}

#pragma mark - Custom Protocols
#pragma mark TTWorldSquareNavViewDelegate
/**
 导航栏返回
 */
- (void)didClickBackActionInNavView:(TTWorldSquareNavView *)navView {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 导航栏搜索
 */
- (void)didClickSearchActionInNavView:(TTWorldSquareNavView *)navView {
    
    [TTStatisticsService trackEvent:@"world-square-search-world"
                      eventDescribe:@"世界广场-搜索世界"];
    
    TTWorldSearchViewController *vc = [[TTWorldSearchViewController alloc] init];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark TTWorldSquareBannerCellDelegate
- (void)didSelectBannerCell:(TTWorldSquareBannerCell *)cell bannerData:(BannerInfo *)data {
    
    if (data == nil) {
        return;
    }
    
    if (data.skipType == BannerInfoSkipTypeWeb) {
        
        TTWKWebViewViewController *vc = [[TTWKWebViewViewController alloc]init];
        NSString *url = data.skipUri;
        if ([data.skipUri containsString:@"?"]) {
            url = [NSString stringWithFormat:@"%@&uid=%@", data.skipUri, [GetCore(AuthCore) getUid]];
        } else {
            url = [NSString stringWithFormat:@"%@?uid=%@", data.skipUri, [GetCore(AuthCore) getUid]];
        }
        vc.url = [NSURL URLWithString:url];
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (data.skipType == BannerInfoSkipTypeRoom) {
        
        [[XCMediator sharedInstance] ttRoomMoudle_presentRoomViewControllerWithRoomUid:data.skipUri.userIDValue];
        
    } else if (data.skipType == BannerInfoSkipTypeInApp) {
        
        if (data.routerType == P2PInteractive_SkipType_LittleWorldGuestPage) {
            
            TTWorldletContainerViewController *vc = [[TTWorldletContainerViewController alloc] init];
            vc.worldId = data.routerValue;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - Core Protocols
#pragma mark LittleWorldCoreClient
- (void)responseWorldSquare:(LittleWorldSquare *)data code:(NSNumber *)errorCode msg:(NSString *)msg {
    
    [XCHUDTool hideHUDInView:self.collectionView];
    [self successEndRefreshStatus:0 hasMoreData:NO];
    
    /// When Network Error
    if (errorCode == nil && msg.length > 0) {
        
        [self.viewModel updateDataModel:nil];
        [self.collectionView reloadData];
        
        [XCHUDTool showErrorWithMessage:msg];
        
        [self showLoadFailViewWithTitle:msg image:[UIImage imageNamed:@"common_no_network"] view:self.collectionView complete:nil];
        return;
    }
    
    /// When Servers Send Error
    if (errorCode != nil) {
        
        [self.viewModel updateDataModel:nil];
        [self.collectionView reloadData];
        
        [XCHUDTool showErrorWithMessage:msg];
        
        [self showLoadFailViewWithTitle:msg image:[UIImage imageNamed:@"common_noData_empty"] view:self.collectionView complete:nil];
        return;
    }
    
    /// When No Data
    if (data == nil) {
        
        [self.viewModel updateDataModel:nil];
        [self.collectionView reloadData];
        
        [self showEmptyDataViewWithTitle:@"暂无数据" image:[UIImage imageNamed:@"common_noData_empty"]];
        return;
    }
    
    [self removeEmptyDataView];
    
    [self.viewModel updateDataModel:data];
    [self.collectionView reloadData];
    
}

#pragma mark - Event Responses
#pragma mark - Private Methods
#pragma mark layout
- (void)initViews {
    
    [self setupRefreshTarget:self.collectionView with:RefreshTypeHeader];
    
    [self.collectionView registerClass:TTWorldSquareBannerCell.class forCellWithReuseIdentifier:kBannerCellId];
    [self.collectionView registerClass:TTWorldSquareWorldCell.class forCellWithReuseIdentifier:kWorldCellId];
    [self.collectionView registerClass:TTWorldSquareSectionHeaderView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kSectionHeaderId];
    [self.collectionView registerClass:TTWorldSquareSectionFooterView.class forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kSectionFooterId];

    [self.view addSubview:self.navView];
}

- (void)initConstraints {
    self.collectionView.top = kNavigationHeight;
    self.collectionView.height -= (kNavigationHeight + kSafeAreaBottomHeight);
    
    self.navView.top = 0;
    self.navView.left = 0;
    self.navView.width = KScreenWidth;
    self.navView.height = kNavigationHeight;
}

#pragma mark Request
- (void)requestData {
    [GetCore(LittleWorldCore) requestWorldSquare];
}

#pragma mark - Getters and Setters
- (TTWorldSquareNavView *)navView {
    if (_navView == nil) {
        _navView = [[TTWorldSquareNavView alloc] init];
        _navView.delegate = self;
    }
    return _navView;
}

- (TTWorldSquareViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [[TTWorldSquareViewModel alloc] init];
    }
    return _viewModel;
}

@end
