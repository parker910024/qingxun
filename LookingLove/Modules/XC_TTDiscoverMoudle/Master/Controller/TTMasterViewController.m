//
//  TTMasterViewController.m
//  TTPlay
//
//  Created by Macx on 2019/1/16.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTMasterViewController.h"

#import "TTMasterHeaderView.h"
#import "TTMyMasterTableViewCell.h"
#import "XCEmptyDataView.h"
#import "TTPopup.h"
#import "TTMasterRelieveView.h"
#import "TTWKWebViewViewController.h"

#import "TTMasterHeaderModel.h"

#import "MentoringShipCore.h"
#import "MentoringShipCoreClient.h"
#import "UserCore.h"
#import "UserInfo.h"
#import "AuthCore.h"

#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "XCHUDTool.h"
#import "XCHtmlUrl.h"
//vc
#import "XCMediator+TTMessageMoudleBridge.h"
#import "XCMediator+TTPersonalMoudleBridge.h"

// 最近 徒弟的key
static NSString *kRecentlyApprenticeUidKey = @"kRecentlyApprenticeUidKey";

@interface TTMasterViewController ()<TTMasterHeaderViewDelegate, MentoringShipCoreClient, TTMasterRelieveViewDelegate>
/** header */
@property (nonatomic, strong) TTMasterHeaderView *headerView;

/** 我的师徒列表 */
@property (nonatomic, strong) NSMutableArray<UserInfo *> *lists;
/** XCEmptyDataView */
@property (nonatomic, strong) XCEmptyDataView *emptyDataView;

/** 正在解除师徒关系的模型 */
@property (nonatomic, strong) UserInfo *relievingInfo;
@end

@implementation TTMasterViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    [self initConstrations];
    [self initCore];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 请求是否能够收徒
    [GetCore(MentoringShipCore) canHarvestApprenticeWithUid:[GetCore(AuthCore) getUid].userIDValue];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    //Remove Client Here
    RemoveCoreClientAll(self);
    [self.headerView.advView stopCountDown];
}

#pragma mark - public methods

#pragma mark - TableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TTMyMasterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TTMyMasterTableViewCell class])];
    UserInfo *info = [self.lists safeObjectAtIndex:indexPath.row];
    cell.userInfo = info;
    
    @KWeakify(self);
    cell.deleteButtonDidClickBlcok = ^(long long uid) {
        @KStrongify(self);
        
        NSString *content = @"";
        if (info.type == 1) { // 徒弟 点击 解除师傅
            content = @"解除关系后，将无法再拜师\n是否确认解除师徒关系?";
        } else { // 解除徒弟
            content = @"解除关系后，将不可还原\n是否确认解除师徒关系?";
        }
        TTAlertConfig * config = [[TTAlertConfig alloc] init];
        config.title = @"提示";
        config.message = content;
        self.relievingInfo = info;
        
        [TTPopup alertWithConfig:config confirmHandler:^{
            UserID masterUid = 0;
            UserID apprenticeUid = 0;
            UserID operUid = [GetCore(AuthCore) getUid].userIDValue;
            if (info.type == 1) {
                masterUid = info.uid;
                apprenticeUid = [GetCore(AuthCore) getUid].userIDValue;
            } else {
                masterUid = [GetCore(AuthCore) getUid].userIDValue;
                apprenticeUid = info.uid;
            }
            
            [GetCore(MentoringShipCore) masterSendDeleteRequestWithMasterUid:masterUid apprenticeUid:apprenticeUid operUid:operUid];
        } cancelHandler:^{
        }];

    };
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    // 高 38
    UILabel *label = [[UILabel alloc] init];
    label.text = @"我的师徒";
    label.textColor = [XCTheme getTTMainTextColor];
    label.font = [UIFont systemFontOfSize:16];
    UIView *contentView = [UIView new];
    contentView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:label];
    label.frame = CGRectMake(15, 14, 100, 18);
    return contentView;
}

#pragma mark - TableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 38;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UserInfo *info = [self.lists safeObjectAtIndex:indexPath.row];
    UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_personalViewController:info.uid];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - TTMasterHeaderViewDelegate
/** 点击了去收徒 */
- (void)masterHeaderView:(TTMasterHeaderView *)view didClickAcceptpPrenticeView:(UIView *)acceptpPrenticeView {
    [[BaiduMobStat defaultStat] logEvent:@"mentor_go_to_the_apprentice" eventLabel:@"去收徒"];
    
    if (self.headerView.headerModel.can) {
        [GetCore(MentoringShipCore) applyToHarvestApprcnticeWithUid:GetCore(AuthCore).getUid.userIDValue];
    } else {
        NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:kRecentlyApprenticeUidKey];
        if ([uid integerValue] > 0) {
            UIViewController * controller = [[XCMediator sharedInstance] ttMessageMoudle_TTSessionViewController:[uid userIDValue] sessectionType:NIMSessionTypeP2P];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}

/** 点击了名师排行榜 */
- (void)masterHeaderView:(TTMasterHeaderView *)view didClickRankingView:(UIView *)rankingView {
     [[BaiduMobStat defaultStat] logEvent:@"mentor_ranking_list" eventLabel:@"名师排行榜"];
    TTWKWebViewViewController *vc = [[TTWKWebViewViewController alloc]init];
    vc.urlString = [NSString stringWithFormat:@"%@?uid=%@", HtmlUrlKey(kMasterRankingURL),[GetCore(AuthCore) getUid]];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - TTMasterRelieveViewDelegate
/** 点击了关闭按钮 */
- (void)masterRelieveView:(TTMasterRelieveView *)view didClickCloseButton:(UIButton *)closeButton {
    [TTPopup dismiss];
}

#pragma mark - MentoringShipCoreClient
/** 查询是不是能请求收徒*/
- (void)checkUserCanHarvestApprenticeingSuceess:(NSDictionary *)dic {
    self.headerView.headerModel = [TTMasterHeaderModel yy_modelWithJSON:dic];
}

- (void)checkUserCanHarvestApprenticeingFail:(NSString *)message {
    
}

/** 请求收徒*/
- (void)requestHarvestApprenticeingSuccess:(NSDictionary *)dic {
    UIViewController * controller = [[XCMediator sharedInstance] ttMessageMoudle_TTSessionViewController:[dic[@"uid"] userIDValue] sessectionType:NIMSessionTypeP2P];
    [self.navigationController pushViewController:controller animated:YES];
    
    // 存储最近的收徒uid
    [[NSUserDefaults standardUserDefaults] setObject:dic[@"uid"] forKey:kRecentlyApprenticeUidKey];
}

- (void)requestHarvestApprenticeingFail:(NSString *)message {
    
}

/**师徒建立成功 跑马灯*/
- (void)getMasterAndApprenticeRelationShipListSuccess:(NSArray *)relationShips {
    
    if (relationShips.count > 0) {
        // 增加头部高度
        self.headerView.frame = CGRectMake(0, 0, KScreenWidth, 230);
    } else {
        // 减少头部高度
        self.headerView.frame = CGRectMake(0, 0, KScreenWidth, 208); // 230
    }
    self.tableView.tableHeaderView = self.headerView;
    self.headerView.advModels = relationShips;
    [self.tableView reloadData];
}

- (void)getMasterAndApprenticeRelationShipListFail:(NSString *)message {
    self.headerView.frame = CGRectMake(0, 0, KScreenWidth, 208);
    self.tableView.tableHeaderView = self.headerView;
    self.headerView.advModels = [NSArray array];
    [self.tableView reloadData];
}

/** 我的师徒list接口 */
- (void)getMyMasterAndApprenticeListSuccess:(NSArray *)list page:(int)page state:(int)state {
    if (page == 1) {
        [self.lists removeAllObjects];
    }
    
    [self.lists addObjectsFromArray:list];
    [self.tableView reloadData];
    
    if (list.count > 0) {
        [self successEndRefreshStatus:state hasMoreData:YES];
    } else {
        [self successEndRefreshStatus:state hasMoreData:NO];
    }
    
    if (self.lists.count > 0) {
        self.emptyDataView.hidden = YES;
    } else {
        self.emptyDataView.hidden = NO;
    }
}

- (void)getMyMasterAndApprenticeListFail:(NSString *)message page:(int)page state:(int)state {
    [XCHUDTool showSuccessWithMessage:message inView:self.view];
    
    [self failEndRefreshStatus:state];
}

/** 请求师徒关系的 获取名师榜数据 */
- (void)getMasterAndApprenticeRankingListSuccess:(NSArray *)list page:(int)page state:(int)state type:(int)type {
    if (type == 1) {
        self.headerView.rankingList = list;
    }
}

- (void)getMasterAndApprenticeRankingListFail:(NSString *)message page:(int)page state:(int)state type:(int)type {
    
}

/** 解除师徒关系 */
- (void)masterSendDeleteRequestSuccess {
    [[BaiduMobStat defaultStat] logEvent:@"mentor_disengagement" eventLabel:@"解除关系成功"];
    
    TTMasterRelieveView *relieveView = [[TTMasterRelieveView alloc] init];
    relieveView.delegate = self;
    
    TTPopupService *service = [[TTPopupService alloc] init];
    service.contentView = relieveView;
    
    [TTPopup popupWithConfig:service];
        
    self.relievingInfo.type = 0;
    self.relievingInfo = nil;
    [self.tableView reloadData];
}

- (void)masterSendDeleteRequestFail:(NSString *)message {
    [XCHUDTool showErrorWithMessage:message inView:self.view];
}

#pragma mark - event response
- (void)rightBarButtonItemDidClick:(UIButton *)btn {
    TTWKWebViewViewController *vc = [[TTWKWebViewViewController alloc]init];
    vc.urlString = [NSString stringWithFormat:@"%@?uid=%@", HtmlUrlKey(kMasterStrategyURL),[GetCore(AuthCore) getUid]];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - private method

- (void)initNav {
    self.title = @"师徒";
    UIButton *rightItem = [[UIButton alloc] init];
    [rightItem setTitle:@"攻略" forState:UIControlStateNormal];
    [rightItem setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateNormal];
    rightItem.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightItem addTarget:self action:@selector(rightBarButtonItemDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightItem sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItem];
}

- (void)initView {
    [self initNav];
    
    [self.view addSubview:self.tableView];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:[TTMyMasterTableViewCell class] forCellReuseIdentifier:NSStringFromClass([TTMyMasterTableViewCell class])];
    self.tableView.tableViewHeightOnScreen = 1;
    
    self.headerView.frame = CGRectMake(0, 0, KScreenWidth, 208); // 230
    self.tableView.tableHeaderView = self.headerView;
    
    [self setupRefreshTarget:self.tableView];
    [self pullDownRefresh:1];
}

- (void)initCore {
    AddCoreClient(MentoringShipCoreClient, self);
    
    [GetCore(MentoringShipCore) getMasterAndApprenticeRelationShipListWithPage:1 pageSize:10];
    [GetCore(MentoringShipCore) getMasterAndApprenticeRankingList:1 pageSize:3 state:0 type:1];
}

- (void)initConstrations {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(44 + statusbarHeight);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
}

/**
 下拉刷新的回调 子类需要重写
 @param page 当前请求的页数
 */
- (void)pullDownRefresh:(int)page {
    [GetCore(MentoringShipCore) getMyMasterAndApprenticeList:1 pageSize:20 state:0];
}

/**
 上拉刷新的回掉  子类需要重写
 @param page   当前请求的页数
 @param isLastPage yes:已经到了最后一页 NO：还没到
 */
- (void)pullUpRefresh:(int)page lastPage:(BOOL)isLastPage {
    if (isLastPage) {
        return;
    }
    [GetCore(MentoringShipCore) getMyMasterAndApprenticeList:page pageSize:20 state:1];
}

#pragma mark - getters and setters
- (TTMasterHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[TTMasterHeaderView alloc] init];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (NSMutableArray<UserInfo *> *)lists {
    if (!_lists) {
        _lists = [NSMutableArray array];
    }
    return _lists;
}

- (XCEmptyDataView *)emptyDataView {
    if (!_emptyDataView) {
        _emptyDataView = [[XCEmptyDataView alloc] init];
        _emptyDataView.frame = CGRectMake(0, 262, KScreenWidth, KScreenHeight - 262);
        _emptyDataView.title = @"再不去收徒弟，我长大了就自己收了啊~";
        _emptyDataView.messageLabel.textColor = RGBCOLOR(153, 153, 153);
        _emptyDataView.messageLabel.font = [UIFont systemFontOfSize:13];
        _emptyDataView.image = [UIImage imageNamed:@"common_noData_empty"];
        _emptyDataView.imageFrame = CGRectMake((KScreenWidth - 185) / 2, (KScreenHeight - 262 - 145) / 2 - 30, 185, 145);
        _emptyDataView.margin = -45;
        [self.tableView addSubview:_emptyDataView];
        _emptyDataView.hidden = YES;
        _emptyDataView.backgroundColor = [UIColor clearColor];
    }
    return _emptyDataView;
}
@end
