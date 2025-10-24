//
//  TTRoomListViewController.m
//  TTPlay
//
//  Created by lvjunhang on 2019/2/20.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTRoomListViewController.h"
#import "TTHomeRecommendBannerCell.h"
#import "TTHomeRecommendRoomTVCell.h"
#import "TTHomeRecommendBigRoomTVCell.h"

#import "XCMediator+TTRoomMoudleBridge.h"
#import "TTWKWebViewViewController.h"
#import "TTHomeRecommendViewModel.h"
#import "TTHomeRecommendViewProtocol.h"

#import "TTHomeV4DetailData.h"
#import "RoomCategory.h"
#import "RoomCategoryData.h"
#import "UserInfo.h"
#import "HomeCore.h"
#import "HomeCoreClient.h"
#import "AuthCore.h"

#import "XCMacros.h"
#import "XCHUDTool.h"
#import "UIViewController+EmptyDataView.h"

#import <Masonry/Masonry.h>
#import <MJRefresh/MJRefresh.h>

static NSString *const kRoomCellID = @"kRoomCellID";
static NSString *const kBigRoomCellID = @"kBigRoomCellID";
static NSString *const kBannerCellID = @"kBannerCellID";

static NSUInteger const kPageSize = 10;//分页个数
static NSUInteger const kBigRoomNum = 3;//大房间个数
static NSUInteger const kDefaultBannerRowIndex = 4;//默认baner所在行的索引位置

@interface TTRoomListViewController ()
<UITableViewDelegate,
UITableViewDataSource,
PDHomeRecommendCellDelegate
>

/**
 导航栏下面的图片
 */
@property (nonatomic, strong) UIImageView *navBottomImageView;

@property (nonatomic, assign) int currentPage;
@property (nonatomic, strong) NSMutableArray<TTHomeV4DetailData *> *dataModelArray;
@property (nonatomic, strong) NSArray<BannerInfo *> *bannerModelArray;
@end

@implementation TTRoomListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AddCoreClient(HomeCoreClient, self);
    
    [self.view addSubview:self.navBottomImageView];
    [self.view bringSubviewToFront:self.tableView];
    
    self.tableView.tableViewHeightOnScreen = 1;
    [self setupRefreshTarget:self.tableView];
    
    self.tableView.backgroundColor = UIColor.clearColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:TTHomeRecommendBannerCell.class forCellReuseIdentifier:kBannerCellID];
    [self.tableView registerClass:TTHomeRecommendRoomTVCell.class forCellReuseIdentifier:kRoomCellID];
    [self.tableView registerClass:TTHomeRecommendBigRoomTVCell.class forCellReuseIdentifier:kBigRoomCellID];
    
    [self.navBottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.left.right.mas_equalTo(self.view.mas_safeAreaLayoutGuide);
        } else {
            make.top.left.right.mas_equalTo(self.view);
        }
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self pullDownRefresh:1];
}

- (void)dealloc {
    RemoveCoreClientAll(self);
}

#pragma mark - Override
- (void)pullDownRefresh:(int)page {
    self.currentPage = 1;
    [self requestRoomData];
}

- (void)pullUpRefresh:(int)page lastPage:(BOOL)isLastPage {
    
    if (isLastPage) {
        return;
    }
    
    self.currentPage += 1;
    [self requestRoomData];
}

- (BOOL)isHiddenNavBar {
    return YES;
}

/**
 点击失败占位图时的重载方法
 */
- (void)reloadDataWhenLoadFail {
    [self pullDownRefresh:1];
}

#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.tableView;
}

#pragma mark - HomeCoreClient
//兔兔分页获取标题对应列表数据(某分类下房间列表)v4 Modify at:@2019-02-15
- (void)responseTTHomeV4RoomCategoryRoomData:(RoomCategoryData *)data errorCode:(NSNumber *)code msg:(NSString *)msg {
    
    //过滤非同一个房间 ID
    if (![data.titleId isEqualToString:self.roomTag.titleId]) {
        return;
    }
    
    [self successEndRefreshStatus:0 hasMoreData:YES];
    [self successEndRefreshStatus:1 hasMoreData:YES];
    
    /// When Network Error
    if (code == nil && msg.length > 0) {
        
        [XCHUDTool showErrorWithMessage:msg inView:self.view];
        if (self.dataModelArray.count > 0) {
            return;
        }
        
        [self showLoadFailViewWithTitle:msg image:[UIImage imageNamed:@"common_no_network"]];
        return;
    }
    
    /// When Servers Send Error
    if (code != nil) {
        
        [XCHUDTool showErrorWithMessage:msg inView:self.view];
        if (self.dataModelArray.count > 0) {
            return;
        }
        
        [self showLoadFailViewWithTitle:@"没有房间数据" image:[UIImage imageNamed:@"common_noData_empty"]];
        return;
    }
    
    /// banner & room no data
    if (data.banner.count==0 && data.rooms.count==0) {
        
        [XCHUDTool showErrorWithMessage:msg inView:self.view];
        
        if (self.currentPage == 1) {
            [self.dataModelArray removeAllObjects];
            [self.tableView reloadData];
        }
        
        if (self.dataModelArray.count > 0) {
            [self successEndRefreshStatus:1 hasMoreData:NO];
            return;
        }
        
        [self showLoadFailViewWithTitle:@"没有房间数据" image:[UIImage imageNamed:@"common_noData_empty"]];
        return;
    }
    
    [self removeEmptyDataView];
    
    if (self.currentPage == 1) {
        self.bannerModelArray = data.banner;
        self.dataModelArray = data.rooms.mutableCopy;
    } else {
        [self.dataModelArray addObjectsFromArray:data.rooms];
        
        BOOL hasMore = data.rooms.count >= kPageSize;
        [self successEndRefreshStatus:1 hasMoreData:hasMore];
    }
    
    [self.tableView reloadData];
}

#pragma mark PDHomeRecommendCellDelegate
- (void)didSelectBannerCell:(TTHomeRecommendBannerCell *)cell bannerData:(BannerInfo *)data {
    
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

- (void)didSelectBigRoomCell:(TTHomeRecommendBigRoomTVCell *)cell data:(TTHomeV4DetailData *)data {
    if (data == nil) {
//        assert(0);
        return;
    }
    
    [[XCMediator sharedInstance] ttRoomMoudle_presentRoomViewControllerWithRoomUid:data.uid];
}

- (void)didSelectSmallRoomCell:(TTHomeRecommendRoomTVCell *)cell data:(TTHomeV4DetailData *)data {
    if (data == nil) {
//        assert(0);
        return;
    }
    
    [[XCMediator sharedInstance] ttRoomMoudle_presentRoomViewControllerWithRoomUid:data.uid];
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.didScrollCallback ?: self.didScrollCallback(scrollView);
}

#pragma mark UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self numberOfRows];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self bannerIndexPath] == indexPath) {
        TTHomeRecommendBannerCell *cell = [tableView dequeueReusableCellWithIdentifier:kBannerCellID forIndexPath:indexPath];
        cell.delegate = self;
        cell.bannerModelArray = self.bannerModelArray;
        return cell;
    }
    
    if ([self bigRoomIndexPath] == indexPath) {
        TTHomeRecommendBigRoomTVCell *cell = [tableView dequeueReusableCellWithIdentifier:kBigRoomCellID forIndexPath:indexPath];
        cell.delegate = self;
        cell.dataModelArray = [TTHomeRecommendViewModel bigRoomsFromDatas:self.dataModelArray bigRoomCount:kBigRoomNum];
        
        cell.isSupperDataType = NO;
        
        return cell;
    }
    
    TTHomeRecommendRoomTVCell *cell = [tableView dequeueReusableCellWithIdentifier:kRoomCellID forIndexPath:indexPath];
    cell.delegate = self;
    
    //分隔线
    //    cell.separateLine.hidden = [self hideSmallRoomSeparateLineForIndexPath:indexPath];
    cell.separateLine.hidden = YES;
    
    //数据源
    TTHomeV4DetailData *model = [self smallRoomDataForIndexPath:indexPath];
    cell.model = model;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIImageView *headerView = [[UIImageView alloc] init];
    headerView.backgroundColor = UIColor.clearColor;
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = UIColor.whiteColor;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self bannerIndexPath] == indexPath) {
        return [self bannerCellHeight];
    }
    
    if ([self bigRoomIndexPath] == indexPath) {
        CGFloat margin = TTHomeRecommendBigRoomTVCellTopMargin + TTHomeRecommendBigRoomTVCellBottomMargin;
        return [self singleLineBigRoomHeight] + margin;
    }
    
    return [self smallRoomHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - Private Methods
///请求房间列表数据
- (void)requestRoomData {
    [GetCore(HomeCore) requestTTHomeV4RoomCategoryRoomDataWithTitleId:self.roomTag.titleId
                                                              pageNum:self.currentPage
                                                             pageSize:kPageSize];
}

/**
 大房所在索引位置
 @discussion 只有两种情况，在第0行，或不存在（即房间数为0）
 
 @return 索引，为nil时表示不存在
 */
- (nullable NSIndexPath *)bigRoomIndexPath {
    return self.dataModelArray.count>0 ? [NSIndexPath indexPathForRow:0 inSection:0] : nil;
}

/**
 banner所在索引位置
 @discussion 默认在表格kDefaultBannerRowIndex位置，如果房间数不够则一直往前顶，特别地，当没有房间时显示在第0行
 
 @return 索引，为nil时表示不存在
 */
- (nullable NSIndexPath *)bannerIndexPath {
    if (![self hasBanner]) {
        return nil;
    }
    
    //如果没有大房间，直接显示在第一行
    if ([self bigRoomIndexPath] == nil) {
        return [NSIndexPath indexPathForRow:0 inSection:0];
    }
    
    NSArray *smallRooms = [TTHomeRecommendViewModel smallRoomsFromDatas:self.dataModelArray bigRoomCount:kBigRoomNum];
    NSInteger bannerRowIndex = 1;//小房间个数=0时显示在第二行
    if (smallRooms.count+1 >= kDefaultBannerRowIndex) {
        bannerRowIndex = kDefaultBannerRowIndex;
    } else {
        bannerRowIndex = smallRooms.count+1;
    }
    
    return [NSIndexPath indexPathForRow:bannerRowIndex inSection:0];
}

/**
 是否隐藏小房间分割线
 
 @param indexPath 当前索引
 @return 是否隐藏
 */
- (BOOL)hideSmallRoomSeparateLineForIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *smallRooms = [TTHomeRecommendViewModel smallRoomsFromDatas:self.dataModelArray bigRoomCount:kBigRoomNum];
    
    // 当没有 banner，最后一个隐藏
    if (![self hasBanner]) {
        return smallRooms.count == indexPath.row;
    }
    
    // 当有 banner，banner 前一个，banner 后的最后一个隐藏
    if (indexPath.row == [self bannerIndexPath].row - 1) {
        return YES;
    }
    
    if (indexPath.row > kDefaultBannerRowIndex) {
        return indexPath.row == smallRooms.count + 1;
    }
    
    return NO;
}

- (TTHomeV4DetailData *)smallRoomDataForIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *smallRooms = [TTHomeRecommendViewModel smallRoomsFromDatas:self.dataModelArray bigRoomCount:kBigRoomNum];
    
    /// 当没有 banner
    if (![self hasBanner]) {
        if (smallRooms.count > indexPath.row-1) {
            return smallRooms[indexPath.row-1];
        } else {
            return nil;
        }
    }
    
    /// 当有 banner
    
    // banner 前
    if (indexPath.row <= [self bannerIndexPath].row - 1) {
        if (smallRooms.count > indexPath.row-1) {
            return smallRooms[indexPath.row-1];
        } else {
            return nil;
        }
    }
    
    // banner 之后
    if (smallRooms.count > indexPath.row - 2) {
        return smallRooms[indexPath.row-2];
    } else {
        return nil;
    }
}

/**
 行数计算
 */
- (NSInteger)numberOfRows {
    NSInteger bannerFlag = [self hasBanner] ? 1 : 0;
    NSInteger bigRoomFlag = self.dataModelArray.count > 0;
    NSInteger smallRooms = self.dataModelArray.count<=3 ? 0 : self.dataModelArray.count-3;
    
    return bannerFlag + bigRoomFlag + smallRooms;
}

/**
 是否有 banner
 */
- (BOOL)hasBanner {
    return self.bannerModelArray.count > 0;
}

#pragma mark Cell Height Calculate
- (CGFloat)bannerCellHeight {
    if (![self hasBanner]) {
        return CGFLOAT_MIN;
    }
    
    CGFloat vertMargin = 8*2;//上下间距
    return vertMargin + (KScreenWidth - 15*2) * TTHomeRecommendBannerCellBannerAspectRatio;
}

/// 一排的大房间高度，n排即 *n
- (CGFloat)singleLineBigRoomHeight {
    CGFloat width = (KScreenWidth - 15*2 - TTHomeRecommendBigRoomCVCellHoriInterval) / 3;
    CGFloat height = width + TTHomeRecommendBigRoomCVCellLabelHeight;
    return height;
}

/// 小房间高度
- (CGFloat)smallRoomHeight {
    return 76.0;
}

#pragma mark - Setter Getter
- (NSMutableArray<TTHomeV4DetailData *> *)dataModelArray {
    if (_dataModelArray == nil) {
        _dataModelArray = [NSMutableArray array];
    }
    return _dataModelArray;
}

- (UIImageView *)navBottomImageView {
    if (!_navBottomImageView) {
        _navBottomImageView = [[UIImageView alloc] init];
        _navBottomImageView.image = [UIImage imageNamed:@"home_nav_bg_footer_small"];
    }
    return _navBottomImageView;
}

@end
