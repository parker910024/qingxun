//
//  LLVoicePartyViewController.m
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2019/7/25.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "LLVoicePartyViewController.h"

#import "TTVoicePartyBannerCell.h"
#import "LLVoicePartyRoomCell.h"

#import "LLVoicePartyViewModel.h"
#import "LLGameHomeHeader.h"

#import "XCMediator+TTRoomMoudleBridge.h"

#import "HomeCore.h"
#import "HomeCoreClient.h"
#import "BannerInfo.h"
#import "HomeV5Data.h"
#import "AuthCore.h"
#import "HomeV5CategoryRoom.h"

#import "XCMacros.h"
#import "UIView+NTES.h"
#import "XCHUDTool.h"
#import "TTWKWebViewViewController.h"
#import "UIViewController+EmptyDataView.h"
#import "TTStatisticsService.h"


#import <Masonry/Masonry.h>
#import <MJRefresh/MJRefresh.h>

static NSString *const kRoomCellId = @"kRoomCellId";
static NSString *const kBannerCellId = @"kBannerCellId";

static NSInteger const kReqPageSize = 20;//请求数据大小

@interface LLVoicePartyViewController ()
<
UICollectionViewDelegateFlowLayout,
TTVoicePartyBannerCellDelegate,
HomeCoreClient
>

@property (nonatomic, strong) LLVoicePartyViewModel *viewModel;

@property (nonatomic, assign) NSInteger reqPageNum;

@end

@implementation LLVoicePartyViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    AddCoreClient(HomeCoreClient, self);
    
    [self initViews];
    [self initConstraints];
    
    [self.collectionView.mj_header beginRefreshing];
}

- (void)dealloc {
    RemoveCoreClientAll(self);
}

#pragma mark - override
- (void)pullDownRefresh:(int)page {
    
    [TTStatisticsService trackEvent:@"home-drop-refresh" eventDescribe:@"首页-下拉刷新"];
    
    self.reqPageNum = 1;
    [self requestData];
    
    [self requestBanner];
}

- (void)pullUpRefresh:(int)page lastPage:(BOOL)isLastPage {
    
    if (isLastPage) {
        return;
    }
    
    [self requestData];
}

- (BOOL)isHiddenNavBar {
    return YES;
}

/**
 点击失败占位图时的重载方法
 */
- (void)reloadDataWhenLoadFail {
    [self pullDownRefresh:0];
}

#pragma mark - Public Methods
#pragma mark - System Protocols
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.scrollCallback(scrollView);
}

#pragma mark UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.viewModel rowsAtSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.viewModel isBannerIndexPath:indexPath]) {
        
        TTVoicePartyBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBannerCellId forIndexPath:indexPath];
        cell.delegate = self;
        cell.bannerModelArray = self.viewModel.bannerArray;
        return cell;
    }
    
    LLVoicePartyRoomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kRoomCellId forIndexPath:indexPath];
    cell.model = [self.viewModel roomInfoForIndexPath:indexPath];
    return cell;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HomeV5CategoryRoom *roomInfo = [self.viewModel roomInfoForIndexPath:indexPath];
    if ([roomInfo isKindOfClass:HomeV5CategoryRoom.class]) {
        
        [TTStatisticsService trackEvent:@"room_enter_red_paper_room" eventDescribe:@"房间列表"];
        
        [[XCMediator sharedInstance] ttRoomMoudle_presentRoomViewControllerWithRoomUid:roomInfo.uid.longLongValue];
    }
}

#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size = [self.viewModel sizeForItemAtIndexPath:indexPath];
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(10, 20, 30, 20);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 15;
}

#pragma mark - JXPagingViewListViewDelegate
- (UIScrollView *)listScrollView {
    return self.collectionView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (UIView *)listView {
    return self.view;
}

#pragma mark - Custom Protocols
#pragma mark TTVoicePartyBannerCellDelegate
- (void)didSelectBannerCell:(TTVoicePartyBannerCell *)cell bannerData:(BannerInfo *)data {
    
    if (data == nil || data.skipUri.length == 0) {
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
    }
}

#pragma mark - Core Protocols
#pragma mark TTGoddessViewDelegate
- (void)responseHomeV5CategoryRoomData:(NSArray<HomeV5CategoryRoom *> *)modelArray tabId:(NSString *)tabId errorCode:(NSNumber *)code msg:(NSString *)msg {
    
    if (self.tabId != tabId) {
        return;
    }
    
    if (self.reqPageNum == 1) {
        [self.collectionView endRefreshStatus:0 hasMoreData:YES];
        [self.collectionView endRefreshStatus:1 hasMoreData:YES];
        
        [self.viewModel resetRoomList];
        [self.collectionView reloadData];
    }
    
    /// When Network Error
    if (code == nil && msg.length > 0) {
        
        [XCHUDTool showErrorWithMessage:msg];
        if ([self.viewModel rowsAtSection:0] > 0) {
            return;
        }
        
        [self showEmptyDataViewWithTitle:msg image:[UIImage imageNamed:@"common_no_network"] offsetY:-80 view:self.collectionView complete:nil];
        return;
    }
    
    /// When Servers Send Error
    if (code != nil) {
        
        [XCHUDTool showErrorWithMessage:msg];
        if ([self.viewModel rowsAtSection:0] > 0) {
            return;
        }
        
        [self showEmptyDataViewWithTitle:msg image:[UIImage imageNamed:@"common_noData_empty"] offsetY:-80 view:self.collectionView complete:nil];
        
        return;
    }
    
    /// When No Data
    if ([self.viewModel rowsAtSection:0] == 0 &&
        modelArray.count == 0 &&
        self.viewModel.bannerArray.count == 0) {
        
        [self showEmptyDataViewWithTitle:@"暂无数据" image:[UIImage imageNamed:@"common_noData_empty"] offsetY:-80 view:self.collectionView complete:nil];
        return;
    }
    
    NSAssert(modelArray != nil, @"Getting Datas Unexpected");
    [self removeEmptyDataView];
    
    self.reqPageNum += 1;
    
    BOOL hasMoreData = modelArray.count != 0;
    [self.collectionView endRefreshStatus:1 hasMoreData:hasMoreData];
    
    [self.viewModel updateRoomList:modelArray];
    [self.collectionView reloadData];
}

- (void)responseHomeV5CategoryBanner:(NSArray<BannerInfo *> *)data tabId:(NSString *)tabId errorCode:(NSNumber *)code msg:(NSString *)msg {
    
    if (![self.tabId isEqualToString:tabId]) {
        return;
    }
    
    if (data.count > 0) {
        [self removeEmptyDataView];
    }
    
    self.viewModel.bannerArray = data;
    [self.collectionView reloadData];
}

#pragma mark - Event Responses
#pragma mark - Private Methods
#pragma mark layout
- (void)initViews {
    
    self.collectionView.collectionViewHeightOnScreen = 1;
    [self setupRefreshTarget:self.collectionView];
    self.collectionView.backgroundColor = LLGAMEHOME_BASE_COLOR;
    
    [self.collectionView registerClass:TTVoicePartyBannerCell.class forCellWithReuseIdentifier:kBannerCellId];
    [self.collectionView registerClass:LLVoicePartyRoomCell.class forCellWithReuseIdentifier:kRoomCellId];
}

- (void)initConstraints {
    // 减去导航栏，tabbar 和底部安全区域的高度
    self.collectionView.height -= (kNavigationHeight + 49 + kSafeAreaBottomHeight);
}

#pragma mark Request
/**
 请求房间数据
 */
- (void)requestData {
    
    if (self.tabId.length == 0) {
        return;
    }
    
    [GetCore(HomeCore) requestHomeV5CategoryRoomData:self.tabId
                                         currentPage:self.reqPageNum
                                            pageSize:kReqPageSize];
}

- (void)requestBanner {
    [GetCore(HomeCore) requestHomeV5CategoryBanner:self.tabId];
}

#pragma mark - Getters and Setters
- (LLVoicePartyViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [[LLVoicePartyViewModel alloc] init];
    }
    return _viewModel;
}

- (NSInteger)reqPageNum {
    if (_reqPageNum <= 0) {
        _reqPageNum = 1;
    }
    return _reqPageNum;
}

@end

