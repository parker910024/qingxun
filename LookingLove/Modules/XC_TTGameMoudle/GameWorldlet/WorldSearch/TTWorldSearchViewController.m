//
//  TTWorldSearchViewController.m
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2019/7/1.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTWorldSearchViewController.h"

#import "TTWorldListCell.h"
#import "TTWorldSearchNavView.h"

#import "TTWorldletContainerViewController.h"

#import "XCMediator+TTPersonalMoudleBridge.h"

#import "LittleWorldCore.h"
#import "LittleWorldCoreClient.h"
#import "AuthCore.h"
#import "UserCore.h"

#import "XCMacros.h"
#import "XCHUDTool.h"
#import "XCTheme.h"
#import "TTPopup.h"
#import "XCEmptyDataView.h"

#import <Masonry/Masonry.h>

static NSInteger const kReqPageSize = 20;//请求数据大小

@interface TTWorldSearchViewController ()
<
UITextFieldDelegate,
TTWorldSearchNavViewDelegate,
LittleWorldCoreClient
>

@property (nonatomic, assign) NSInteger reqPageNum;

@property (nonatomic, strong) XCEmptyDataView *emptyDataView;

@property (nonatomic, strong) TTWorldSearchNavView *customNavView;

@property (nonatomic, strong) NSMutableArray<LittleWorldListItem *> *dataArray;

@end

@implementation TTWorldSearchViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    AddCoreClient(LittleWorldCoreClient, self);
    
    [self initView];
    [self initConstrations];
    
    self.dataArray = [NSMutableArray array];
    
    [self.customNavView keyboradInitialShow];
}

- (void)dealloc {
    self.dataArray = nil;
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
    return YES;
}

/**
 点击失败占位图时的重载方法
 */
- (void)reloadDataWhenLoadFail {
    [self pullDownRefresh:0];
}

#pragma mark - public methods

#pragma mark - UITableViewViewDataSource && UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TTWorldListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TTWorldListCell class]) forIndexPath:indexPath];
    
    LittleWorldListItem *data = [self.dataArray safeObjectAtIndex:indexPath.row];
    cell.model = data;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LittleWorldListItem *data = [self.dataArray safeObjectAtIndex:indexPath.row];
    if (data == nil) {
        return;
    }
    
    TTWorldletContainerViewController *vc = [[TTWorldletContainerViewController alloc] init];
    vc.worldId = data.worldId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - TTWorldSearchNavViewDelegate
/**
 导航栏取消
 */
- (void)didClickCancelActionInNavView:(TTWorldSearchNavView *)navView {
    
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 导航栏搜索

 @param searchKey 搜索关键词
 */
- (void)navView:(TTWorldSearchNavView *)navView search:(NSString *)searchKey {
    
    [XCHUDTool showGIFLoadingInView:self.view];
    
    self.reqPageNum = 1;
    [self requestData];
}

#pragma mark - LittleWorldCoreClient
- (void)responseWorldList:(LittleWorldListModel *)data typeId:(NSString *)typeId code:(NSNumber *)errorCode msg:(NSString *)msg {
    
    if (msg) {
        [XCHUDTool showErrorWithMessage:msg inView:self.view];
        return;
    }

    [XCHUDTool hideHUDInView:self.view];
    
    if (self.reqPageNum == 1) {
        [self.dataArray removeAllObjects];
        
        [self.tableView endRefreshStatus:0 hasMoreData:YES];
        [self.tableView endRefreshStatus:1 hasMoreData:YES];
    }
    
    self.reqPageNum += 1;
    
    BOOL hasMoreData = data.records.count >= kReqPageSize;
    [self.tableView endRefreshStatus:1 hasMoreData:hasMoreData];
    
    [self.dataArray addObjectsFromArray:data.records];
    [self.tableView reloadData];
    
    self.emptyDataView.hidden = self.dataArray.count > 0;
}

#pragma mark - private method
#pragma mark Layout
- (void)initView {
    [self.view addSubview:self.customNavView];
    [self.view addSubview:self.tableView];
    
    self.tableView.tableViewHeightOnScreen = 1;
    [self setupRefreshTarget:self.tableView With:RefreshTypeFooter];
    
    [self.tableView registerClass:[TTWorldListCell class] forCellReuseIdentifier:NSStringFromClass([TTWorldListCell class])];
    self.tableView.rowHeight = 128.f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
}

- (void)initConstrations {
    [self.customNavView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(kNavigationHeight);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.customNavView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-kSafeAreaBottomHeight);
    }];
}

#pragma mark Request
- (void)requestData {
    
    NSString *searchKey = self.customNavView.currentSearchText;
    
    [GetCore(LittleWorldCore) requestWorldListWithPage:self.reqPageNum
                                              pageSize:20
                                             searchKey:searchKey
                                           worldTypeId:nil];
}

#pragma mark - getters and setters
- (TTWorldSearchNavView *)customNavView {
    if (!_customNavView) {
        _customNavView = [[TTWorldSearchNavView alloc] init];
        _customNavView.delegate = self;
    }
    return _customNavView;
}

- (XCEmptyDataView *)emptyDataView {
    if (!_emptyDataView) {
        _emptyDataView = [[XCEmptyDataView alloc] init];
        _emptyDataView.frame = CGRectMake(0, statusbarHeight + 64, KScreenWidth, KScreenHeight);
        _emptyDataView.title = @"暂无搜索记录";
        _emptyDataView.messageLabel.textColor = RGBCOLOR(153, 153, 153);
        _emptyDataView.messageLabel.font = [UIFont systemFontOfSize:13];
        _emptyDataView.image = [UIImage imageNamed:@"common_noData_empty"];
        _emptyDataView.imageFrame = CGRectMake((KScreenWidth - 185) / 2, (KScreenHeight - 145) / 2 - 60, 185, 145);
        _emptyDataView.hidden = YES;
        _emptyDataView.backgroundColor = [UIColor whiteColor];
        _emptyDataView.margin = -45;
        [self.view addSubview:_emptyDataView];
    }
    return _emptyDataView;
}

@end
