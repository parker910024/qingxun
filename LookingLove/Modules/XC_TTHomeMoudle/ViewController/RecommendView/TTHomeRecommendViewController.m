//
//  TTHomeRecommendViewController.m
//  TuTu
//
//  Created by lvjunhang on 2018/12/28.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTHomeRecommendViewController.h"
#import "TTHomeRecommendSectionHeaderView.h"
#import "TTHomeRecommendBannerCell.h"
#import "TTHomeRecommendBigRoomTVCell.h"
#import "TTHomeRecommendRoomTVCell.h"

#import "TTHomeRecommendViewProtocol.h"
#import "TTHomeRecommendViewModel.h"

#import "XCMediator+TTMessageMoudleBridge.h"
#import "XCMediator+TTRoomMoudleBridge.h"
#import "BaseNavigationController.h"

#import "TTWKWebViewViewController.h"

#import <Masonry/Masonry.h>

#import "XCTheme.h"
#import "XCMacros.h"
#import "CoreManager.h"
#import "XCHUDTool.h"
#import "UIViewController+EmptyDataView.h"
#import "XCCurrentVCStackManager.h"
#import "BaseNavigationController.h"

#import "AuthCoreClient.h"
#import "HomeCoreClient.h"
#import "HomeCore.h"
#import "TTHomeV4Data.h"
#import "TTHomeV4DetailData.h"
#import "BannerInfo.h"
#import "AuthCore.h"
#import "UserCore.h"


static NSString *const kBannerCellID = @"kBannerCellID";
static NSString *const kBottomBannerCellID = @"kBottomBannerCellID";
static NSString *const kBigRoomCellID = @"kBigRoomCellID";
static NSString *const kSmallRoomCellID = @"kSmallRoomCellID";

static NSString *const kSectionHeaderViewID = @"kSectionHeaderViewID";

static NSInteger const kHotReqPageSize = 10;//热门推荐请求数据大小

@interface TTHomeRecommendViewController ()
<
HomeCoreClient,
AuthCoreClient,
PDHomeRecommendCellDelegate
>

@property (nonatomic, strong) TTHomeRecommendViewModel *viewModel;

/**
 导航栏下面的图片
 */
@property (nonatomic, strong) UIImageView *navBottomImageView;

/**
 当前热门推荐请求页数
 @discussion 请求成功后，需计数加一
 */
@property (nonatomic, assign) NSUInteger hotReqPageNum;

@end

@implementation TTHomeRecommendViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    AddCoreClient(HomeCoreClient, self);
    AddCoreClient(AuthCoreClient, self);
    
    [self initView];
    [self initConstraints];
    
    [XCHUDTool showGIFLoadingInView:self.view];
    [self pullDownRefresh:0];
}

- (void)dealloc {
    RemoveCoreClientAll(self);
}

#pragma mark - override
- (void)pullDownRefresh:(int)page {
    self.hotReqPageNum = 1;
    [GetCore(HomeCore) requestTTHomeV4Data];
}

- (void)pullUpRefresh:(int)page lastPage:(BOOL)isLastPage {
    
    if (isLastPage) {
        return;
    }
    
    [GetCore(HomeCore) requestTTHomeV4HotRoomWithPageNum:self.hotReqPageNum
                                                pageSize:kHotReqPageSize];
}

/**
 点击失败占位图时的重载方法
 */
- (void)reloadDataWhenLoadFail {
    [XCHUDTool showGIFLoadingInView:self.view];
    [self pullDownRefresh:1];
}

- (BOOL)isHiddenNavBar {
    return YES;
}

#pragma mark - JXCategoryListContentViewDelegate

- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.tableView;
}

#pragma mark - protocol
#pragma mark HomeCoreClient
//首页数据请求返回
- (void)responseTTHomeV4Data:(NSArray *)modelArray errorCode:(NSNumber *)code msg:(NSString *)msg {
    
    [XCHUDTool hideHUDInView:self.view];
    [self.tableView endRefreshStatus:0 hasMoreData:YES];
    
    /// When Network Error
    if (code == nil && msg.length > 0) {
        
        [XCHUDTool showErrorWithMessage:msg];
        if (self.viewModel.dataSourceArray.count > 0) {
            return;
        }
        
        [self showLoadFailViewWithTitle:msg image:[UIImage imageNamed:@"common_no_network"]];
        return;
    }
    
    /// When Servers Send Error
    if (code != nil) {
        
        [XCHUDTool showErrorWithMessage:msg];
        if (self.viewModel.dataSourceArray.count > 0) {
            return;
        }
        
        [self showLoadFailViewWithTitle:msg image:[UIImage imageNamed:@"common_noData_empty"]];
        return;
    }
    
    NSAssert(modelArray != nil, @"Getting Datas Unexpected");
    [self removeEmptyDataView];
    
    self.viewModel.dataSourceArray = modelArray;
    [self.tableView reloadData];
    
    //设置导航底部图片，根据有无 banner，使用不同图片
    TTHomeV4Data *data = [self.viewModel dataAtSection:0];
    if (data.type == TTHomeV4DataTypeBanner) {
        self.navBottomImageView.image = [UIImage imageNamed:@"home_nav_bg_footer"];
        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    } else {
        self.navBottomImageView.image = [UIImage imageNamed:@"home_nav_bg_footer_small"];
        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 30.)];
    }
}

//首页热门推荐请求返回
- (void)responseTTHomeV4HotRoom:(NSArray *)modelArray errorCode:(NSNumber *)code msg:(NSString *)msg {
    
    [XCHUDTool hideHUDInView:self.view];
    [self.tableView endRefreshStatus:1];

    /// When Network Error
    if (code == nil && msg.length > 0) {
        [XCHUDTool showErrorWithMessage:msg];
        return;
    }
    
    /// When Servers Send Error
    if (code != nil) {
        [XCHUDTool showErrorWithMessage:msg];
        return;
    }
    
    if (modelArray.count > 0) {
        self.hotReqPageNum += 1;
        
        [self.viewModel updateHotRecommend:modelArray];
        [self.tableView reloadData];
    }
    
    BOOL hasMoreData = modelArray.count >= kHotReqPageSize;
    [self.tableView endRefreshStatus:1 hasMoreData:hasMoreData];
}

#pragma mark PDHomeRecommendCellDelegate
- (void)didSelectBannerCell:(TTHomeRecommendBannerCell *)cell detailData:(TTHomeV4DetailData *)data {
    
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
        ///虚位以待
        return;
    }
    
    [[XCMediator sharedInstance] ttRoomMoudle_presentRoomViewControllerWithRoomUid:data.uid];
}

- (void)didSelectSmallRoomCell:(TTHomeRecommendRoomTVCell *)cell data:(TTHomeV4DetailData *)data {
    
    if (data == nil) {
        return;
    }
    
    [[XCMediator sharedInstance] ttRoomMoudle_presentRoomViewControllerWithRoomUid:data.uid];
}

#pragma mark UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.dataSourceArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger row = [self.viewModel rowsAtSection:section];
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.viewModel.dataSourceArray.count <= indexPath.section) {
        return [UITableViewCell new];
    }
    
    TTHomeV4Data *data = [self.viewModel dataAtSection:indexPath.section];
    switch (data.type) {
        case TTHomeV4DataTypeBanner:
        {
            TTHomeRecommendBannerCell *cell = [tableView dequeueReusableCellWithIdentifier:kBannerCellID forIndexPath:indexPath];
            cell.delegate = self;
            cell.dataModelArray = data.data;
            return cell;
        }
        case TTHomeV4DataTypeSuper:
        case TTHomeV4DataTypeCustom:
        {
            if (indexPath.row == 0) {
                TTHomeRecommendBigRoomTVCell *cell = [tableView dequeueReusableCellWithIdentifier:kBigRoomCellID forIndexPath:indexPath];
                cell.delegate = self;
                cell.dataModelArray = [TTHomeRecommendViewModel bigRoomsFromDatas:data.data bigRoomCount:data.maxNum];
                
                cell.isSupperDataType = data.type == TTHomeV4DataTypeSuper;
                
                return cell;
            }
        }
        case TTHomeV4DataTypeHot:
        {
            if (indexPath.row == 0) {
                TTHomeRecommendBigRoomTVCell *cell = [tableView dequeueReusableCellWithIdentifier:kBigRoomCellID forIndexPath:indexPath];
                cell.delegate = self;
                cell.dataModelArray = [TTHomeRecommendViewModel bigRoomsFromDatas:data.data bigRoomCount:3];
                cell.isSupperDataType = NO;
                
                return cell;
            }
        }
    }
    
    TTHomeRecommendRoomTVCell *cell = [tableView dequeueReusableCellWithIdentifier:kSmallRoomCellID forIndexPath:indexPath];
    cell.delegate = self;

    NSUInteger bigRoomCount = data.type == TTHomeV4DataTypeHot ? 3 : data.maxNum;
    NSArray *smallRooms = [TTHomeRecommendViewModel smallRoomsFromDatas:data.data bigRoomCount:bigRoomCount];
    
    TTHomeV4DetailData *model = nil;
    if (smallRooms.count > indexPath.row-1) {
        model = smallRooms[indexPath.row-1];
    }
    cell.model = model;
    
    //分隔线
//    cell.separateLine.hidden = smallRooms.count == indexPath.row;
    cell.separateLine.hidden = YES;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (self.viewModel.dataSourceArray.count <= section) {
        NSAssert(NO, @"Unexpected case happened");
        return nil;
    }
    
    TTHomeRecommendSectionHeaderViewConfig *config = [self.viewModel headerConfigAtSection:section];
    
    TTHomeRecommendSectionHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kSectionHeaderViewID];
    view.config = config;
    
    [view setClickHandle:^{
    }];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = UIColor.whiteColor;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [self.viewModel cellHeightAtIndexPath:indexPath];
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = [self.viewModel sectionHeaderHeightAtSection:section];
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    CGFloat height = [self.viewModel sectionFooterHeightAtSection:section];
    return height;
}

#pragma mark - private method
- (void)initView {
    
    [self.view addSubview:self.navBottomImageView];
    [self.view bringSubviewToFront:self.tableView];
    
    self.tableView.tableViewHeightOnScreen = 1;
    [self setupRefreshTarget:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UIColor.clearColor;
    
    [self.tableView registerClass:TTHomeRecommendSectionHeaderView.class forHeaderFooterViewReuseIdentifier:kSectionHeaderViewID];
    [self.tableView registerClass:TTHomeRecommendBannerCell.class forCellReuseIdentifier:kBannerCellID];
    [self.tableView registerClass:TTHomeRecommendBigRoomTVCell.class forCellReuseIdentifier:kBigRoomCellID];
    [self.tableView registerClass:TTHomeRecommendRoomTVCell.class forCellReuseIdentifier:kSmallRoomCellID];
}

- (void)initConstraints {
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
}


#pragma mark - getters and setters
- (TTHomeRecommendViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [[TTHomeRecommendViewModel alloc] init];
    }
    return _viewModel;
}

- (NSUInteger)hotReqPageNum {
    if (_hotReqPageNum <= 0) {
        _hotReqPageNum = 1;
    }
    return _hotReqPageNum;
}

- (UIImageView *)navBottomImageView {
    if (!_navBottomImageView) {
        _navBottomImageView = [[UIImageView alloc] init];
        _navBottomImageView.image = [UIImage imageNamed:@"home_nav_bg_footer"];
    }
    return _navBottomImageView;
}

@end
