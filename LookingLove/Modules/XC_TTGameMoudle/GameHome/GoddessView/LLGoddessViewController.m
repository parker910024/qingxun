//
//  LLGoddessViewController.m
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2019/7/25.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "LLGoddessViewController.h"

#import "TTGoddessTableHeaderView.h"
#import "TTGoddessTableFooterView.h"
#import "TTGoddessBannerCell.h"
#import "LLGoddessUserCell.h"

#import "TTGoddessViewProtocol.h"
#import "TTGoddessViewModel.h"
#import "TTPublicChatroomMessageProtocol.h"
#import "LLGameHomeHeader.h"

#import "XCMediator+TTMessageMoudleBridge.h"
#import "XCMediator+TTRoomMoudleBridge.h"
#import "XCMediator+TTPersonalMoudleBridge.h"

#import "HomeCore.h"
#import "HomeCoreClient.h"
#import "BannerInfo.h"
#import "HomeV5Data.h"
#import "AuthCore.h"
#import "RoomCoreV2.h"
#import "RoomInfo.h"
#import "UserCore.h"
#import "AuthCoreClient.h"

#import "TTWKWebViewViewController.h"
#import "UIView+NTES.h"
#import "XCMacros.h"
#import "UIView+XCToast.h"
#import "XCHUDTool.h"
#import "TTStatisticsService.h"
#import "XCEmptyDataView.h"
#import "XCTheme.h"

static NSString *const kBannerCellID = @"kBannerCellID";
static NSString *const kUserCellID = @"kUserCellID";

static NSInteger const kReqPageSize = 20;//请求数据大小

@interface LLGoddessViewController ()
<
TTGoddessViewDelegate,
HomeCoreClient,
AuthCoreClient,
TTPublicChatroomMessageProtocol
>

@property (nonatomic, strong) TTGoddessViewModel *viewModel;

@property (nonatomic, assign) NSInteger reqPageNum;

@property (nonatomic, strong) TTGoddessTableHeaderView *tableHeaderView;
@property (nonatomic, strong) TTGoddessTableFooterView *tableFooterView;

@property (nonatomic, strong) XCEmptyDataView *emptyDataView;

@end

@implementation LLGoddessViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = LLGAMEHOME_BASE_COLOR;

    AddCoreClient(HomeCoreClient, self);
    AddCoreClient(TTPublicChatroomMessageProtocol, self);
    AddCoreClient(AuthCoreClient, self);
    
    // 选择菜单后刷新数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDataByNoti:) name:@"kCategoryItemMenuSelectIndexRefreshDataNoti" object:nil];
    
    [self initViews];
    [self initConstraints];
    
    self.reqPageNum = 1;
    [self requestData];
}

- (void)dealloc {
    RemoveCoreClientAll(self);
}

#pragma mark - Overridden
- (void)pullDownRefresh:(int)page {
    
    [TTStatisticsService trackEvent:@"home-drop-refresh" eventDescribe:@"首页-下拉刷新"];
    
    self.reqPageNum = 1;
    [self requestData];
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

#pragma mark UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger row = [self.viewModel rowsAtSection:section];
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.viewModel isBannerIndexPath:indexPath]) {
        TTGoddessBannerCell *cell = [tableView dequeueReusableCellWithIdentifier:kBannerCellID forIndexPath:indexPath];
        cell.backgroundColor = LLGAMEHOME_BASE_COLOR;
        cell.delegate = self;
        cell.bannerModelArray = self.viewModel.bannerArray;
        return cell;
    }
    
    LLGoddessUserCell *cell = [tableView dequeueReusableCellWithIdentifier:kUserCellID forIndexPath:indexPath];
    cell.backgroundColor = LLGAMEHOME_BASE_COLOR;
    cell.delegate = self;
    cell.model = [self.viewModel userDataForIndexPath:indexPath];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self delayTableViewUserInteraction];
    
    if ([self.viewModel isBannerIndexPath:indexPath]) {
        return;
    }
    
    HomeV5Data *data = [self.viewModel userDataForIndexPath:indexPath];
    
    if (data == nil) {
        return;
    }
    
    //房间推荐
    if (data.recommendRoom) {
        
        NSString *roomType = data.roomVo.liveTag ? @"101直播间" : @"模厅";
        NSString *labelName;
        if (self.labelType == 1) {
            labelName = @"男神";
        } else if (self.labelType == 2) {
            labelName = @"女神";
        } else {
            labelName = @"男神女神";
        }
        
        NSString *des = [NSString stringWithFormat:@"合拍男/女神-进入房间:%@ %@", labelName, roomType];
        [TTStatisticsService trackEvent:@"match-male-enter-room" eventDescribe:des];
        
        [TTStatisticsService trackEvent:@"home-user-list-step-into-room" eventDescribe:@"首页-用户列表-踩进房间"];
        
        [[XCMediator sharedInstance] ttRoomMoudle_presentRoomViewControllerWithRoomUid:data.roomVo.uid.longLongValue];
        return;
    }
    
    [TTStatisticsService trackEvent:@"home-page-private" eventDescribe:@"首页-私聊"];
    
    //私聊
    UIViewController *vc = [[XCMediator sharedInstance] ttMessageMoudle_TTSessionViewControllerChatterboxGame:data.uid.longLongValue sessectionType:NIMSessionTypeP2P withReturnStatistics:^{
        
        //触发了抛点数
        [TTStatisticsService trackEvent:@"home-chat-number-of-points" eventDescribe:@"首页-私聊-话匣子游戏-抛点数"];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Custom Protocols
#pragma mark TTGoddessViewDelegate
/**
 选中滚动 Banner
 
 @param data 选中的数据源
 */
- (void)didSelectBannerCell:(TTGoddessBannerCell *)cell bannerData:(BannerInfo *)data {
    
    if (data == nil || data.skipUri.length == 0) {
        return;
    }
    
    [self delayTableViewUserInteraction];
    
    !self.didSelectBanner ?: self.didSelectBanner(data);
}

/**
 选中用户信息、房间信息
 
 @param data 选中的数据源，为空表示虚位以待
 */
- (void)didSelectUserCell:(LLGoddessUserCell *)cell data:(HomeV5Data *)data {
    
    if (data == nil) {
        return;
    }
    
    [self delayTableViewUserInteraction];
    
    //房间推荐
    if (data.recommendRoom) {
        
        NSString *roomType = data.roomVo.liveTag ? @"101直播间" : @"模厅";
        NSString *labelName;
        if (self.labelType == 1) {
            labelName = @"男神";
        } else if (self.labelType == 2) {
            labelName = @"女神";
        } else {
            labelName = @"男神女神";
        }
        
        NSString *des = [NSString stringWithFormat:@"合拍男/女神-进入房间:%@ %@", labelName, roomType];
        [TTStatisticsService trackEvent:@"match-male-enter-room" eventDescribe:des];
        
        [TTStatisticsService trackEvent:@"home-user-list-step-into-room" eventDescribe:@"首页-用户列表-踩进房间"];
        
        [[XCMediator sharedInstance] ttRoomMoudle_presentRoomViewControllerWithRoomUid:data.roomVo.uid.longLongValue];
        return;
    }
    
    [TTStatisticsService trackEvent:@"home-page-private" eventDescribe:@"首页-私聊"];
    
    //私聊
    UIViewController *vc = [[XCMediator sharedInstance] ttMessageMoudle_TTSessionViewControllerChatterboxGame:data.uid.longLongValue sessectionType:NIMSessionTypeP2P withReturnStatistics:^{
        
        //触发了抛点数
        [TTStatisticsService trackEvent:@"home-chat-number-of-points" eventDescribe:@"首页-私聊-话匣子游戏-抛点数"];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 用户操作按钮
 */
- (void)didClickActionButtonWithData:(HomeV5Data *)data {
    
    if (data == nil) {
        return;
    }
    
    //推荐房间操作不走这里
    if (data.recommendRoom) {
        return;
    }
    
    [self delayTableViewUserInteraction];
    
    if (data.status.integerValue == 0) {
        //进入私聊，撩一下
        UIViewController *vc = [[XCMediator sharedInstance] ttMessageMoudle_TTSessionViewControllerFlirtToUid:data.uid.longLongValue chatterboxStartBlock:^{

            [TTStatisticsService trackEvent:@"home-chat-number-of-points" eventDescribe:@"首页-私聊-话匣子游戏-抛点数"];
        }];
        [self.navigationController pushViewController:vc animated:YES];
        
        [TTStatisticsService trackEvent:@"homepage_hook_up" eventDescribe:@"撩一下"];
        return;
    }
    
    if (data.status.integerValue == 2) {
        //游戏中
        [TTStatisticsService trackEvent:@"home-user-list-watch-games" eventDescribe:@"首页-围观游戏"];
    }
    
    [TTStatisticsService trackEvent:@"home-user-list-step-into-room" eventDescribe:@"首页-用户列表-踩进房间"];
    
    // 房间中/KTV中：点击跳转该用户所在房间
    //游戏中：点击前往围观--->围观也是在该用户所在房间内
    [GetCore(RoomCoreV2) getUserInterRoomInfo:data.uid.longLongValue Success:^(RoomInfo *roomInfo) {
        
        if (roomInfo && roomInfo.uid > 0 && roomInfo.title.length > 0) {
            [[XCMediator sharedInstance] ttRoomMoudle_presentRoomViewControllerWithRoomUid:roomInfo.uid];
        } else {
            [XCHUDTool showErrorWithMessage:@"TA现在没有在房间内哦" inView:self.view];
        }
        
    } failure:^(NSNumber *resCode, NSString *message) {
        [XCHUDTool showErrorWithMessage:message inView:self.view];
    }];
}

/**
 选中用户头像

 @param data 选中的数据源
 */
- (void)didClickAvatarWithData:(HomeV5Data *)data {
    
    if (data == nil) {
        return;
    }
    
    //推荐房间操作不走这里
    if (data.recommendRoom) {
        return;
    }
    
    [self delayTableViewUserInteraction];
    
    //客态页
    UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_personalViewController:data.uid.longLongValue];
    [self.navigationController pushViewController:vc animated:YES];
    
    [TTStatisticsService trackEvent:@"homepage_personal_page" eventDescribe:@"进入个人客态页"];
}

/**
 点击触发头部事件
 */
- (void)didClickTableHeaderView:(TTGoddessTableHeaderView *)headerView {
    
    [TTStatisticsService trackEvent:@"home-lobby-chat" eventDescribe:@"首页-大厅热聊"];
    
    [self delayTableViewUserInteraction];
    
    UIViewController *vc = [[XCMediator sharedInstance] TTMessageMoudle_HeadLineViewContoller:1];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 点击触发脚部事件
 */
- (void)didClickTableFooterView:(TTGoddessTableFooterView *)footerView {
    
    [TTStatisticsService trackEvent:@"home-page-click-to-view-more" eventDescribe:@"首页-点击查看更多"];
    
    [self delayTableViewUserInteraction];
    
    [XCHUDTool showLoadingInView:self.view];
    [self requestData];
}

#pragma mark JXPagingViewListViewDelegate
- (UIScrollView *)listScrollView {
    return self.tableView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (UIView *)listView {
    return self.view;
}

#pragma mark - Core Protocols
- (void)onLoginSuccess {
    self.reqPageNum = 1;
    [self requestData];
}
#pragma mark HomeCoreClient
- (void)responseHomeV5Data:(NSArray<HomeV5Data *> *)data errorCode:(NSNumber *)code msg:(NSString *)msg {
    
    [XCHUDTool hideHUD];
    
    [self successEndRefreshStatus:0 hasMoreData:YES];
    [self successEndRefreshStatus:1 hasMoreData:YES];
    
    /// When Network Error
    if (code == nil && msg.length > 0) {
        
        [XCHUDTool showErrorWithMessage:msg];
        if ([self.viewModel rowsAtSection:0] > 0) {
            return;
        }
        
        self.emptyDataView.image = [UIImage imageNamed:@"common_no_network"];
        self.emptyDataView.title = msg;
        self.emptyDataView.hidden = NO;
        return;
    }
    
    /// When Servers Send Error
    if (code != nil) {
        
        [XCHUDTool showErrorWithMessage:msg];
        if ([self.viewModel rowsAtSection:0] > 0) {
            return;
        }
        
        self.emptyDataView.image = [UIImage imageNamed:@"common_noData_empty"];
        self.emptyDataView.title = msg;
        self.emptyDataView.hidden = NO;
        return;
    }
    
    /// When No Data
    if ([self.viewModel rowsAtSection:0] == 0 &&
        data.count == 0 &&
        self.viewModel.bannerArray.count == 0) {
        
        self.emptyDataView.image = [UIImage imageNamed:@"common_noData_empty"];
        self.emptyDataView.title = @"暂无数据";
        self.emptyDataView.hidden = NO;
        return;
    }
    
    NSAssert(data != nil, @"Getting Datas Unexpected");
    self.emptyDataView.hidden = YES;
    
    if (self.reqPageNum == 1) {
        [self.viewModel resetDataList];
        [self.tableView reloadData];
    }
    
    if (data.count == 0) {
        [XCHUDTool showErrorWithMessage:@"没有更多数据了"];
    } else {
        self.reqPageNum += 1;
    }
    
    //只要有数据就一直可以加载更多，因为服务器可能在当前页没返回足够请求个数，而下一页依然有数据的情况
    [self successEndRefreshStatus:1 hasMoreData:data.count > 0];
    
    [self.viewModel updateDataList:data];
    [self.tableView reloadData];
}

- (void)responseHomeV5Banner:(NSArray<BannerInfo *> *)data errorCode:(NSNumber *)code msg:(NSString *)msg {
    
    if (data == nil || [data count] == 0) {
        return;
    }
    
    if (data.count > 0) {
        self.emptyDataView.hidden = YES;
    }
    
    self.viewModel.bannerArray = data;
    [self.tableView reloadData];
}

#pragma mark TTPublicChatroomMessageProtocol
- (void)onCurrentPublicChatroomMessageUpdate:(NSMutableArray *)messages {
    self.tableHeaderView.dataModelArray = [messages mutableCopy];
    [self.tableView reloadData];
}

#pragma mark - Event Responses
// 通知过来刷新数据
- (void)refreshDataByNoti:(NSNotification *)noti {
    if (noti.object && [noti.object isKindOfClass:[NSString class]]) {
        self.labelType = [noti.object integerValue];
        [self pullDownRefresh:0];
    }
}

/**
 点击没有数据占位图
 */
- (void)didTapEmptyView {
    self.reqPageNum = 1;
    [self requestData];
}

#pragma mark - Private Methods
#pragma mark layout
- (void)initViews {
    
    self.tableView.tableViewHeightOnScreen = 1;
    [self setupRefreshTarget:self.tableView With:RefreshTypeHeaderAndFooter];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UIColor.clearColor;
    
    //业务关系，这里隐藏头部脚部
//    self.tableView.tableHeaderView = self.tableHeaderView;
//    self.tableView.tableFooterView = self.tableFooterView;
    
    [self.tableView registerClass:TTGoddessBannerCell.class forCellReuseIdentifier:kBannerCellID];
    [self.tableView registerClass:LLGoddessUserCell.class forCellReuseIdentifier:kUserCellID];
}

- (void)initConstraints {
    // 减去导航栏，tabbar 和底部安全区域的高度
    self.tableView.height -= (kNavigationHeight + 49 + kSafeAreaBottomHeight);
}

#pragma mark Request
/**
 请求 banner
 */
- (void)requestBanner {
    [GetCore(HomeCore) requestHomeV5Banner];
}

/**
 请求首页数据
 */
- (void)requestData {
    [GetCore(HomeCore) requestHomeV5DataWithLabelType:self.labelType
                                          currentPage:self.reqPageNum
                                             pageSize:kReqPageSize];
}

/**
 延迟交互 table view
 @discussion 解决多次快速连点导致卡死问题
 */
- (void)delayTableViewUserInteraction {
    
    self.tableView.userInteractionEnabled = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.tableView.userInteractionEnabled = YES;
    });
}

#pragma mark - Getters and Setters
- (TTGoddessViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [[TTGoddessViewModel alloc] init];
    }
    return _viewModel;
}

- (NSInteger)reqPageNum {
    if (_reqPageNum <= 0) {
        _reqPageNum = 1;
    }
    return _reqPageNum;
}

- (TTGoddessTableHeaderView *)tableHeaderView {
    if (_tableHeaderView == nil) {
        _tableHeaderView = [[TTGoddessTableHeaderView alloc] init];
        _tableHeaderView.delegate = self;
    }
    return _tableHeaderView;
}

- (TTGoddessTableFooterView *)tableFooterView {
    if (_tableFooterView == nil) {
        _tableFooterView = [[TTGoddessTableFooterView alloc] init];
        _tableFooterView.delegate = self;
    }
    return _tableFooterView;
}

- (XCEmptyDataView *)emptyDataView {
    if (!_emptyDataView) {
        UIImage *image = [UIImage imageNamed:@"common_noData_empty"];
        CGFloat height = 488;
        _emptyDataView = [[XCEmptyDataView alloc] initWithFrame:CGRectMake(0, 65, KScreenWidth, height)];
        _emptyDataView.title = @"暂无数据";
        _emptyDataView.messageLabel.textColor = RGBCOLOR(153, 153, 153);
        _emptyDataView.messageLabel.font = [UIFont systemFontOfSize:13];
        _emptyDataView.image = image;
        _emptyDataView.imageFrame = CGRectMake((KScreenWidth - 185)/2, (height - 145) / 2 - 80, 185, 145);
        _emptyDataView.margin = -45;
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapEmptyView)];
        [_emptyDataView addGestureRecognizer:tapGR];
        
        _emptyDataView.hidden = YES;
        [self.tableView addSubview:_emptyDataView];
    }
    return _emptyDataView;
}

@end

