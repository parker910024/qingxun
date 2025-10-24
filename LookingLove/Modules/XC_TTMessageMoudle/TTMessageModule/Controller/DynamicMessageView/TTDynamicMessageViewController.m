//
//  TTDynamicMessageViewController.m
//  XC_TTMessageMoudle
//
//  Created by lvjunhang on 2019/11/28.
//  Copyright © 2019 WJHD. All rights reserved.
//

#import "TTDynamicMessageViewController.h"

#import "TTDynamicMessageCell.h"

#import "XCMediator+TTGameModuleBridge.h"
#import "XCMediator+TTPersonalMoudleBridge.h"

#import "MessageCore.h"
#import "MessageCoreClient.h"

#import "XCHUDTool.h"
#import "TTPopup.h"
#import "UIViewController+EmptyDataView.h"
#import "XCCurrentVCStackManager.h"
#import "NSArray+Safe.h"

#import <Masonry/Masonry.h>

static NSString *const kCellID = @"kCellID";

static NSInteger const kReqPageSize = 20;//请求数据大小

@interface TTDynamicMessageViewController ()<MessageCoreClient>

@property (nonatomic, strong) NSMutableArray<DynamicMessage *> *dataArray;

@property (nonatomic, strong) NSString *lastRequestId;//最后一次请求的ID

@end

@implementation TTDynamicMessageViewController

#pragma mark - Life Cycle
- (void)dealloc {
    RemoveCoreClientAll(self);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.title = @"全部消息";
    
    AddCoreClient(MessageCoreClient, self);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [self addNavigationItemWithTitles:@[@"清空"] titleColor:UIColor.blackColor isLeft:NO target:self action:@selector(didClickRightBarButton) tags:nil];

    [self initViews];
    [self initConstraints];

    self.dataArray = [NSMutableArray array];

    [self requestDataWithRefresh:YES];
}

#pragma mark - Overridden
- (void)pullDownRefresh:(int)page {
    
    [self requestDataWithRefresh:YES];
}

- (void)pullUpRefresh:(int)page lastPage:(BOOL)isLastPage {
    
    if (isLastPage) {
        return;
    }
    
    [self requestDataWithRefresh:NO];
}

/**
 点击失败占位图时的重载方法
 */
- (void)reloadDataWhenLoadFail {
    [self removeEmptyDataView];
    [self pullDownRefresh:0];
}

#pragma mark - Notifitcation
/// APP进入前台通知
- (void)applicationDidBecomeActive:(NSNotification *)notification {
    [self requestDataWithRefresh:YES];
}

#pragma mark - System Protocols
#pragma mark UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TTDynamicMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID forIndexPath:indexPath];
    
    DynamicMessage *model = [self.dataArray safeObjectAtIndex:indexPath.row];
    cell.model = model;
    
    @weakify(self)
    cell.avatarActionHandler = ^{
        @strongify(self)
        UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_personalViewController:model.uid];
        [self.navigationController pushViewController:vc animated:YES];
    };
    cell.nameActionHandler = ^{
        @strongify(self)
        UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_personalViewController:model.uid];
        [self.navigationController pushViewController:vc animated:YES];
    };
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DynamicMessage *data = [self.dataArray safeObjectAtIndex:indexPath.row];
    if (data == nil) {
        return;
    }

    UIViewController *vc = [[XCMediator sharedInstance] ttGameMoudle_TTDynamicDetailViewControllerWithWorldID:data.worldId dynamicID:data.dynamicId comment:NO];
    [[[XCCurrentVCStackManager shareManager]currentNavigationController] pushViewController:vc animated:YES];
}

#pragma mark - Core Protocols
#pragma mark MessageCoreClient
- (void)responseMessageDynamicList:(NSArray<DynamicMessage *> *)data code:(NSNumber *)errorCode msg:(NSString *)msg {

    if (self.lastRequestId == nil) {
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
    if (data.count == 0 && self.dataArray.count == 0) {

        [self showLoadFailViewWithTitle:@"暂无数据" image:[UIImage imageNamed:@"common_noData_empty"]];
        [self.tableView reloadData];
        return;
    }

    [self removeEmptyDataView];

    BOOL hasMoreData = data.count >= kReqPageSize;
    [self.tableView endRefreshStatus:1 hasMoreData:hasMoreData];

    [self.dataArray addObjectsFromArray:data];
    [self.tableView reloadData];
}

#pragma mark - Event Responses
- (void)didClickRightBarButton {
    
    [TTPopup alertWithMessage:@"清空后所有互动通知将被删除，确定清空吗？" confirmHandler:^{
        
        [GetCore(MessageCore) requestMessageDynamicClearCompletion:^(BOOL success, NSNumber * _Nullable code, NSString * _Nullable msg) {
            
            if (msg) {
                [XCHUDTool showErrorWithMessage:msg];
                return;
            }
            
            [self requestDataWithRefresh:YES];
        }];
        
    } cancelHandler:^{
        
    }];
}

#pragma mark - Private Methods
#pragma mark layout
- (void)initViews {
    self.tableView.tableViewHeightOnScreen = 1;
    [self setupRefreshTarget:self.tableView With:RefreshTypeHeaderAndFooter];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UIColor.clearColor;
    
    //iOS10需要预估行高，否则自动计算行高无效
    self.tableView.estimatedRowHeight = 125;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableView registerClass:TTDynamicMessageCell.class forCellReuseIdentifier:kCellID];
}

- (void)initConstraints {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuide);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
}

#pragma mark Request
/**
 请求列表数据
 */
- (void)requestDataWithRefresh:(BOOL)refresh {
    
    self.lastRequestId = refresh ? nil : self.dataArray.lastObject.msgId;
    [GetCore(MessageCore) requestMessageDynamicListWithId:self.lastRequestId pageSize:kReqPageSize];
}

@end

