//
//  TTWorldListViewController.m
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2019/7/1.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTWorldListViewController.h"

#import "TTWorldletConst.h"

#import "TTWorldListCell.h"
#import "TTWorldListEmptyDataView.h"

#import "TTWorldletContainerViewController.h"

#import "LittleWorldCoreClient.h"
#import "LittleWorldCore.h"

#import "XCHUDTool.h"
#import "UIViewController+EmptyDataView.h"
#import "XCCurrentVCStackManager.h"
#import "NSArray+Safe.h"

#import <Masonry/Masonry.h>

static NSString *const kCellID = @"kCellID";

static NSInteger const kReqPageSize = 20;//请求数据大小

@interface TTWorldListViewController ()<LittleWorldCoreClient>

@property (nonatomic, assign) NSInteger reqPageNum;

@property (nonatomic, strong) NSMutableArray<LittleWorldListItem *> *dataArray;

@property (nonatomic, strong) TTWorldListEmptyDataView *myWorldEmptyView;
@end

@implementation TTWorldListViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    AddCoreClient(LittleWorldCoreClient, self);
    
    [self initViews];
    [self initConstraints];
    
    self.dataArray = [NSMutableArray array];
    
    //’我加入的‘世界，请求在 listDidAppear 触发
    if (![self.worldTypeId isEqualToString:TTWorldletMyJoinedWorldTypeId]) {
        [self pullDownRefresh:0];
    }
}

- (void)dealloc {
    RemoveCoreClientAll(self);
}

#pragma mark - Overridden
- (void)pullDownRefresh:(int)page {
    
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
    return NO;
}

/**
 点击失败占位图时的重载方法
 */
- (void)reloadDataWhenLoadFail {
    [self removeEmptyDataView];
    [self pullDownRefresh:0];
}

#pragma mark - Public Methods
#pragma mark - System Protocols
#pragma mark UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TTWorldListCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID forIndexPath:indexPath];
    cell.model = [self.dataArray safeObjectAtIndex:indexPath.row];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = UIColor.whiteColor;
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = UIColor.whiteColor;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 128.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LittleWorldListItem *data = [self.dataArray safeObjectAtIndex:indexPath.row];
    if (data == nil) {
        return;
    }
    
    TTWorldletContainerViewController *vc = [[TTWorldletContainerViewController alloc] init];
    vc.worldId = data.worldId;
    [[[XCCurrentVCStackManager shareManager]currentNavigationController] pushViewController:vc animated:YES];
}

#pragma mark - Custom Protocols
#pragma mark JXPagingViewListViewDelegate
- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.tableView;
}

- (void)listDidAppear {
    
    //每次来到’我加入的‘世界，刷新
    if ([self.worldTypeId isEqualToString:TTWorldletMyJoinedWorldTypeId]) {
        self.reqPageNum = 1;
        [self requestData];
    }
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

#pragma mark - Core Protocols
#pragma mark LittleWorldCoreClient
- (void)responseWorldList:(LittleWorldListModel *)data typeId:(NSString *)typeId code:(NSNumber *)errorCode msg:(NSString *)msg {
    
    if (![self.worldTypeId isEqualToString:typeId]) {
        return;
    }
    
    [XCHUDTool hideHUDInView:self.tableView];
    
    if (self.reqPageNum == 1) {
        [self.dataArray removeAllObjects];
        
        [self.tableView endRefreshStatus:0 hasMoreData:YES];
        [self.tableView endRefreshStatus:1 hasMoreData:YES];
    }
    
    /// When Network Error
    if (errorCode == nil && msg.length > 0) {
        
        [self.dataArray removeAllObjects];
        [self.tableView reloadData];
        
        [XCHUDTool showErrorWithMessage:msg];
        
        [self showLoadFailViewWithTitle:msg image:[UIImage imageNamed:@"common_no_network"]];
        return;
    }
    
    /// When Servers Send Error
    if (errorCode != nil) {
        
        [self.dataArray removeAllObjects];
        [self.tableView reloadData];
        
        [XCHUDTool showErrorWithMessage:msg];
        
        [self showLoadFailViewWithTitle:msg image:[UIImage imageNamed:@"common_noData_empty"]];
        return;
    }
    
    /// When No Data
    if (data.records.count == 0 && self.dataArray.count == 0) {
        
        if ([self.worldTypeId isEqualToString:TTWorldletMyJoinedWorldTypeId]) {
            self.myWorldEmptyView.hidden = NO;
        } else {
            [self showLoadFailViewWithTitle:@"暂无数据" image:[UIImage imageNamed:@"common_noData_empty"]];
        }
        
        [self.tableView reloadData];
        return;
    }
    
    self.myWorldEmptyView.hidden = YES;
    [self removeEmptyDataView];
    
    self.reqPageNum += 1;
    
    BOOL hasMoreData = data.records.count >= kReqPageSize;
    [self.tableView endRefreshStatus:1 hasMoreData:hasMoreData];
    
    [self.dataArray addObjectsFromArray:data.records];
    [self.tableView reloadData];
}

#pragma mark - Event Responses


#pragma mark - Private Methods
#pragma mark layout
- (void)initViews {
    
    self.tableView.tableViewHeightOnScreen = 1;
    [self setupRefreshTarget:self.tableView With:RefreshTypeHeaderAndFooter];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UIColor.clearColor;
    
    [self.tableView registerClass:TTWorldListCell.class forCellReuseIdentifier:kCellID];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 20)];
    headerView.backgroundColor = UIColor.whiteColor;
    self.tableView.tableHeaderView = headerView;
}

- (void)initConstraints {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

#pragma mark Request
/**
 请求列表数据
 */
- (void)requestData {
    
    NSAssert(self.worldTypeId != nil, @"type id can't not be nil");
    
    [GetCore(LittleWorldCore) requestWorldListWithPage:self.reqPageNum
                                              pageSize:kReqPageSize
                                             searchKey:nil
                                           worldTypeId:self.worldTypeId];
}

- (NSInteger)reqPageNum {
    if (_reqPageNum <= 0) {
        _reqPageNum = 1;
    }
    return _reqPageNum;
}

- (TTWorldListEmptyDataView *)myWorldEmptyView {
    if (_myWorldEmptyView == nil) {
        _myWorldEmptyView = [[TTWorldListEmptyDataView alloc] init];
        _myWorldEmptyView.frame = self.tableView.bounds;
        _myWorldEmptyView.hidden = YES;
        [self.tableView addSubview:_myWorldEmptyView];

        @weakify(self)
        _myWorldEmptyView.actionBlock = ^{
            @strongify(self)
            [self requestData];
            
            !self.jumpTabBlock ?: self.jumpTabBlock(TTWorldletRecommendWorldTypeId);
        };
    }
    return _myWorldEmptyView;
}

@end

