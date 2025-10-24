//
//  TTBillListViewController.m
//  TuTu
//
//  Created by lee on 2018/11/9.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTBillListViewController.h"
#import "TTBillListHeadView.h"
#import "TTBillGiftListCell.h"
#import "TTBillListViewCell.h"
#import "TTRechargeViewController.h"
#import "LLRechargeViewController.h"
#import "TTWalletEnumConst.h"
// pods
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "PLTimeUtil.h"
#import <MJRefresh/MJRefresh.h>
#import "UIView+ZJFrame.h"
#import "UIView+XCToast.h"
#import "XCHUDTool.h"
#import "XCKeyWordTool.h"
#import "TTPopup.h"
// core
#import "PurseBillCore.h"
#import "PurseBillCoreClient.h"
// tools
#import "TTDatePickView.h"
// model
#import "RedBillInfo.h"
#import "GiftBillInfo.h"
#import "RechargeBillInfo.h"
#import "WithDrawlBillInfo.h"

@interface TTBillListViewController ()<UITableViewDataSource, UITableViewDelegate, PurseBillCoreClient, TTDatePickViewDelegate>

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *todayLabel;
@property (nonatomic, strong) UIButton *todayBtn;
@property (nonatomic, strong) UIButton *dayChangeBtn;
@property(nonatomic, strong) UILabel *footTipsLabel; // 底部提示文字
/** 返回顶部按钮 */
@property (nonatomic, strong) UIButton *scrollTopBtn;

@property (nonatomic, strong) TTDatePickView *datePickView;

@property (nonatomic, strong) NSMutableArray<NSMutableArray *> *disPlayArr;
@property (nonatomic, strong) NSMutableArray *keysArr;
@property (nonatomic, copy) NSString *sortTiemStamp;

// topBar
@property (nonatomic, strong) UIView *topBarView;
@property (nonatomic, strong) UIView *topBgView;
@property (nonatomic, strong) UIButton *coinGiftBtn;
@property (nonatomic, strong) UIButton *carrotGiftBtn;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *selectedBtn;
@property (nonatomic, assign) NSInteger page;
@end

static CGFloat kTopMargin = 0;

@implementation TTBillListViewController

- (void)dealloc {
    RemoveCoreClientAll(self);
    
    if (self.disPlayArr) {
        self.disPlayArr = nil;
    }
    if (self.keysArr) {
        self.keysArr = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    AddCoreClient(PurseBillCoreClient, self);
    
    _page = 1;
    kTopMargin = 0;
    
    [self initDefaultConfig];
    [self initViews];
    [self initMJRefresh];
    [self initConstraints];
    [self addRechargeBarButtonItem];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self reloadTableViewDataWithPageNo:self.page sortTimeStamp:nil];
}

#pragma mark -
#pragma mark lifeCycle
- (void)initDefaultConfig {
    
    NSString *title;
    switch (_listViewType) {
            case TTBillListViewTypeGiftIn: // 礼物收入
        {
            title = @"礼物记录";
            kTopMargin = 55;
        }
            break;
            case TTBillListViewTypeGiftOut: // 礼物支出
        {
            title = @"赠送记录";
            kTopMargin = 55;
        }
            break;
            case TTBillListViewTypeCodeRed:   // 提现
        {
            title = [NSString stringWithFormat:@"%@记录", [XCKeyWordTool sharedInstance].xcGetCF];
            [self onCoinGiftBtnClickAction:self.coinGiftBtn];
        }
            break;
            case TTBillListViewTypeRecharge: // 充值
        {
            title = @"充值记录";
//            [self reloadTableViewDataWithPageNo:_page sortTimeStamp:nil];
        }
            break;
            case TTBillListViewTypeRedColor: // 红包
        {
            title = [NSString stringWithFormat:@"%@记录", [XCKeyWordTool sharedInstance].xcGetCF];
            [self onCarrotGiftBtnClickAction:self.carrotGiftBtn];
        }
            break;
            case TTBillListViewTypeNoble: // 贵族
        {
            title = @"贵族";
            [self reloadTableViewDataWithPageNo:_page sortTimeStamp:nil];
        }
            break;
            case TTBillListViewTypeRedBalance:
        {
            title = [NSString stringWithFormat:@"%@记录", [XCKeyWordTool sharedInstance].xcRedColor];
        }
            break;
        default:
            break;
    }
    self.navigationItem.title = title;
    self.todayLabel.text = [self getYYMMDDWithDate:[NSDate date]];
}

- (void)initMJRefresh {
    @weakify(self);
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.page = 1;
        [self.tableView.mj_footer endRefreshing];
        [self reloadTableViewDataWithPageNo:self.page sortTimeStamp:nil];
    }];
    
    header.stateLabel.font = [UIFont systemFontOfSize:10];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:10];
    header.arrowView.image = [UIImage imageNamed:@"refreshImage"];
    
    self.tableView.mj_header = header;
    
    self.tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        [self reloadTableViewDataWithPageNo:self.page sortTimeStamp:self.sortTiemStamp];
    }];
}

- (void)initViews {
    [self.view addSubview:self.containerView];
    [self.containerView addSubview:self.tableView];
    [self.containerView addSubview:self.topView];
    [self.containerView addSubview:self.scrollTopBtn];
    
    [self.topView addSubview:self.todayLabel];
    [self.topView addSubview:self.todayBtn];
    [self.topView addSubview:self.dayChangeBtn];
    
    if (self.listViewType == TTBillListViewTypeGiftIn ||
        self.listViewType == TTBillListViewTypeGiftOut) {
        [self.containerView addSubview:self.topBarView];
        [self.topBarView addSubview:self.topBgView];
        [self.topBgView addSubview:self.lineView];
        [self.topBgView addSubview:self.coinGiftBtn];
        [self.topBgView addSubview:self.carrotGiftBtn];
    }
}

- (void)initConstraints {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11, *)) {
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(kSafeTopBarHeight, 0, 0, 0));
        }
    }];
    
    if (self.listViewType == TTBillListViewTypeGiftIn ||
        self.listViewType == TTBillListViewTypeGiftOut) {
        [self.topBarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(55);
            make.left.right.top.mas_equalTo(0);
        }];
        
        [self.topBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.right.mas_equalTo(0).inset(15);
            make.height.mas_equalTo(33);
        }];
        
        [self.coinGiftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(self.topBgView).multipliedBy(0.5);
        }];
        
        [self.carrotGiftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.mas_equalTo(0);
            make.width.mas_equalTo(self.topBgView).multipliedBy(0.5);
        }];
        
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.coinGiftBtn);
            make.width.mas_equalTo(17);
            make.height.mas_equalTo(4);
            make.bottom.mas_equalTo(0);
        }];
    }
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kTopMargin);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(55);
    }];
    
    [self.todayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.dayChangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0).inset(15);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.todayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(self.dayChangeBtn.mas_left).offset(-5);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.topView.mas_bottom);
    }];
    
    [self.scrollTopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0).inset(15);
        make.bottom.mas_equalTo(-55);
    }];
}

#pragma mark -
#pragma mark tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.disPlayArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.disPlayArr[section].count;
    
    if (self.keysArr.count == self.disPlayArr.count) {
        return self.disPlayArr[section].count;
    }
    return  0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 送礼物，收礼物的 cell 样式是一致的
    if ((_listViewType == TTBillListViewTypeGiftIn) ||
        (_listViewType == TTBillListViewTypeGiftOut) ||
        _listViewType == TTBillListViewTypeGiftInCarrot ||
        _listViewType == TTBillListViewTypeGiftOutCarrot) {
        TTBillGiftListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TTBillGiftListCell class])];
        cell.giftType = _listViewType;
        if (self.disPlayArr.count > indexPath.section) { // 安全判断
            [cell configModel:self.disPlayArr[indexPath.section][indexPath.row]];
        }
        return cell;
    }
    
    // 充值，提现，红包 三种类型的 cell 的样式是一致的。
    TTBillListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TTBillListViewCell class])];
    cell.billType = _listViewType;
    if (self.disPlayArr.count > indexPath.section) { // 数据传输
        [cell configModel:self.disPlayArr[indexPath.section][indexPath.row]];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TTBillListHeadView *sectionHeadView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([TTBillListHeadView class])];
    if (self.keysArr.count > section) { // 安全检测
        sectionHeadView.titleLabel.text = self.keysArr[section];
    }
    return sectionHeadView;
}

#pragma mark -
#pragma mark private methods
// 钻石提现 tab
- (void)onCoinGiftBtnClickAction:(UIButton *)coinGiftBtn {
    if (self.listViewType == TTBillListViewTypeGiftOutCarrot) {
        [self topBarBtnClick:coinGiftBtn type:TTBillListViewTypeGiftOut];
    } else if (self.listViewType == TTBillListViewTypeGiftInCarrot) {
        [self topBarBtnClick:coinGiftBtn type:TTBillListViewTypeGiftIn];
    }
}
// 红包提现 tab
- (void)onCarrotGiftBtnClickAction:(UIButton *)carrotGiftBtn {
    if (self.listViewType == TTBillListViewTypeGiftIn) {
        [self topBarBtnClick:carrotGiftBtn type:TTBillListViewTypeGiftInCarrot];
    } else if (self.listViewType == TTBillListViewTypeGiftOut)  {
        [self topBarBtnClick:carrotGiftBtn type:TTBillListViewTypeGiftOutCarrot];
    }
}

- (void)topBarBtnClick:(UIButton *)selectedBtn type:(TTBillListViewType)type {
    if (self.selectedBtn == selectedBtn) {
        return;
    }
    self.selectedBtn = selectedBtn;
    self.listViewType = type;
    [self.tableView.mj_header beginRefreshing];
    [self scrollViewAtIndex:selectedBtn.tag];
    
    // 如果是这样的类型，就不显示充值
    if (self.listViewType == TTBillListViewTypeGiftOutCarrot ||
        self.listViewType == TTBillListViewTypeGiftInCarrot) {
        self.navigationItem.rightBarButtonItem = nil;
        // 不显示底部 tips
        self.footTipsLabel.text = @"";
    } else {
        if (!self.navigationItem.rightBarButtonItem) {
            [self addRechargeBarButtonItem];
        }
    }
    // 切换就刷新数据
    [self todayBtnClickAction:selectedBtn];
}

- (void)scrollViewAtIndex:(NSInteger)index {
    
    [UIView animateWithDuration:0.2 animations:^{
        self.lineView.zj_centerX = self.selectedBtn.zj_centerX;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)addRechargeBarButtonItem {
    [self addNavigationItemWithTitles:@[@"充值"] titleColor:[XCTheme getTTMainTextColor] isLeft:NO target:self action:@selector(jumpToRechargeVC) tags:@[@(1001)]];
}
// 充值
- (void)jumpToRechargeVC {
    UIViewController *vc;
    vc = [[LLRechargeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSString *)getYYMMDDWithDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    formatter.dateFormat = @"yyyy年MM月dd日";
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

// 滑动到顶部
- (void)scrollToTop {
    if (self.keysArr.count != 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

- (void)endRefresh {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (NSString *)getNowTimeTimestampMillisecond {
    //获取当前时间戳
    return [PLTimeUtil getNowTimeTimestampMillisecond];
}

- (void)reloadDateByDate:(NSDate *)date {
    NSTimeInterval timeInterval = [date timeIntervalSince1970] * 1000;  //  *1000 是精确到毫秒，不乘就是精确到秒
    self.sortTiemStamp = [NSString stringWithFormat:@"%.f", timeInterval];
    self.page = 1;
    
    [self reloadTableViewDataWithPageNo:self.page sortTimeStamp:self.sortTiemStamp];
}

#pragma mark -
#pragma mark button click events
- (void)todayBtnClickAction:(UIButton *)btn {
    self.todayLabel.text = [self getYYMMDDWithDate:[NSDate date]];
    [self reloadDateByDate:[NSDate date]];
    [self scrollToTop];
}

- (void)scrollTopBtnClickAction:(UIButton *)scrollTopBtn {
    [self scrollToTop];
}

- (void)dayChangeBtnClickAction:(UIButton *)dayChoseBtn {
    
    TTPopupService *service = [[TTPopupService alloc] init];
    service.contentView = self.datePickView;
    service.style = TTPopupStyleActionSheet;
    [TTPopup popupWithConfig:service];
}

#pragma mark -
#pragma mark datePicker delegate
- (void)ttDatePickCancelAction {
    [TTPopup dismiss];
}

- (void)ttDatePickLimitAction {
    [XCHUDTool showErrorWithMessage:@"出错了" inView:self.view];
}

- (void)ttDatePickEnsureAction:(NSString *)YMd date:(NSDate *)date {
    self.todayLabel.text = YMd;
    [self reloadDateByDate:date];
}

#pragma mark -
#pragma mark request core
- (void)reloadTableViewDataWithPageNo:(NSInteger)pageNo sortTimeStamp:(NSString *)sortTimeStamp {
    if (!sortTimeStamp) {
        sortTimeStamp = [self getNowTimeTimestampMillisecond];
    }
    if (self.listViewType == TTBillListViewTypeGiftOut) { //礼物支出
        [GetCore(PurseBillCore) getOutGiftListPageNo:pageNo time:sortTimeStamp pageSize:50];
    } else if (self.listViewType == TTBillListViewTypeGiftIn) { // 礼物收入
        [GetCore(PurseBillCore) getInGiftListPageNo:pageNo time:sortTimeStamp pageSize:50];
    } else if (self.listViewType == TTBillListViewTypeRecharge) { // 充值
        [GetCore(PurseBillCore) getRechargeListPageNo:pageNo time:sortTimeStamp pageSize:50];
    } else if (self.listViewType == TTBillListViewTypeCodeRed) { // 提现
        [GetCore(PurseBillCore) getWithDrawlListPageNo:pageNo time:sortTimeStamp pageSize:50];
    } else if (self.listViewType == TTBillListViewTypeRedColor) { // 红包
        [GetCore(PurseBillCore) getRedWithDrawlListPageNo:pageNo time:sortTimeStamp pageSize:50];
    } else if (self.listViewType == TTBillListViewTypeNoble) {
        [GetCore(PurseBillCore) getNobleListPageNo:pageNo time:sortTimeStamp pageSize:50];
    } else if (self.listViewType == TTBillListViewTypeRedBalance) {
        [GetCore(PurseBillCore) getRedListPageNo:pageNo date:sortTimeStamp pageSize:50];
    } else if (self.listViewType == TTBillListViewTypeGiftInCarrot) { // 萝卜收入
        [GetCore(PurseBillCore) getCarrotGiftList:2 pageNo:pageNo date:sortTimeStamp pageSize:50];
    } else if (self.listViewType == TTBillListViewTypeGiftOutCarrot) { // 萝卜支出
        [GetCore(PurseBillCore) getCarrotGiftList:1 pageNo:pageNo date:sortTimeStamp pageSize:50];
    }
}

#pragma mark -
#pragma mark clients
// z礼物支出
- (void)getOutGiftListSuccess:(NSMutableArray *)list keys:(NSMutableArray *)keys pageNo:(NSInteger)pageNo {
    [self combineDatelist:list keys:keys pageNo:pageNo];
}

- (void)getOutGiftListFailth:(NSString *)message {
    [self endRefresh];
}
// 礼物收入
- (void)getInGiftListSuccess:(NSMutableArray *)list keys:(NSMutableArray *)keys pageNo:(NSInteger)pageNo {
    [self combineDatelist:list keys:keys pageNo:pageNo];
}

- (void)getInGiftListFailth:(NSString *)message {
    [self endRefresh];
}

// 提现记录
- (void)getWithdrawlListSuccess:(NSMutableArray *)list keys:(NSMutableArray *)keys pageNo:(NSInteger)pageNo {
    [self combineDatelist:list keys:keys pageNo:pageNo];
}

- (void)getWithdrawlListFailth:(NSString *)message {
    [self endRefresh];
}

// 红包提现
- (void)getRedWithdrawlListSuccess:(NSMutableArray *)list keys:(NSMutableArray *)keys pageNo:(NSInteger)pageNo {
    [self combineDatelist:list keys:keys pageNo:pageNo];
}

- (void)getRedWithdrawlListFailth:(NSString *)message {
    [self endRefresh];
}
// 充值记录
- (void)getRechargeListSuccess:(NSMutableArray *)list keys:(NSMutableArray *)keys pageNo:(NSInteger)pageNo {
    [self combineDatelist:list keys:keys pageNo:pageNo];
}
- (void)getRechargeListFailth:(NSString *)message {
    [self endRefresh];
}

// 贵族
- (void)getNobleBillListSuccess:(NSMutableArray *)list keys:(NSMutableArray *)keys pageNo:(NSInteger)pageNo {
    [self combineDatelist:list keys:keys pageNo:pageNo];
}

- (void)getNobleBillListFailth:(NSString *)message {
    [self endRefresh];
}

// redColor list
- (void)getRedGiftListSuccess:(NSMutableArray *)list keys:(NSMutableArray *)keys pageNo:(NSInteger)pageNo {
    [self combineDatelist:list keys:keys pageNo:pageNo];
}

- (void)getRedGiftListFailth:(NSString *)message {
    [self endRefresh];
}

/** 萝卜礼物 */
- (void)getCarrotGiftListSuccess:(NSMutableArray *)list keys:(NSMutableArray *)keys pageNo:(NSInteger)pageNo code:(NSNumber *)code message:(NSString *)message {
    [self combineDatelist:list keys:keys pageNo:pageNo];
}
// 数据处理
- (void)combineDatelist:(NSMutableArray *)list keys:(NSMutableArray *)keys pageNo:(NSInteger)pageNo {
    
    [self endRefresh];
    
    if (pageNo == 1) { // 首次加载 or  下拉刷新
        if (list.count > 0) {
            self.page = 2;
            self.keysArr = keys;
            self.disPlayArr = list;
            [self.tableView hideToastView];
        } else {
            [self.disPlayArr removeAllObjects];
            [self.keysArr removeAllObjects];
            [self.tableView reloadData];
            [self showEmptyByStyle];
            self.footTipsLabel.text = @""; // 置空，不然会出现两个
        }
    } else { // 加载更多
        
        if (list.count) {
            self.page += 1;
            self.footTipsLabel.text = @""; // 置空，不然会出现两个
        } else {
            // 萝卜相关的不显示
            if (self.listViewType != TTBillListViewTypeGiftInCarrot && self.listViewType != TTBillListViewTypeGiftOutCarrot) {
                self.footTipsLabel.text = @"- 仅支持查看近3个月内记录 -";
            }
        }
        
        if ([keys.firstObject isEqualToString:self.keysArr.lastObject]) {
            [keys removeObjectAtIndex:0];
            [self.disPlayArr.lastObject addObjectsFromArray:list.firstObject];
            [list removeObjectAtIndex:0];
            if (list.count > 0) {
                [self.disPlayArr addObjectsFromArray:list];
            }
            if (keys.count > 0) {
                [self.keysArr addObjectsFromArray:keys];
            }
        } else {
            [self.disPlayArr addObjectsFromArray:list];
            [self.keysArr addObjectsFromArray:keys];
        }
    }
    
    [self.tableView reloadData];
}

- (void)showEmptyByStyle {
    switch (_listViewType) {
        case TTBillListViewTypeGiftIn: {
            [self.tableView showEmptyContentToastWithTitle:@"- 仅支持查看近3个月内记录 -" andImage:[UIImage imageNamed:@"common_noData_empty"]];
        }
            break;
        case TTBillListViewTypeGiftOut: {
            [self.tableView showEmptyContentToastWithTitle:@"- 仅支持查看近3个月内记录 -" andImage:[UIImage imageNamed:@"common_noData_empty"]];
        }
            break;
        case TTBillListViewTypeRecharge: {
            [self.tableView showEmptyContentToastWithTitle:@"- 仅支持查看近3个月内记录 -" andImage:[UIImage imageNamed:@"common_noData_empty"]];
        }
            break;
        case TTBillListViewTypeCodeRed: {
            [self.tableView showEmptyContentToastWithTitle:[NSString stringWithFormat:@"- 仅支持查看近3个月内记录 -"] andImage:[UIImage imageNamed:@"common_noData_empty"]];
        }
            break;
            case TTBillListViewTypeRedBalance:
        {
            [self.tableView showEmptyContentToastWithTitle:[NSString stringWithFormat:@"亲爱的宝贝，你还没有%@记录哦!", [XCKeyWordTool sharedInstance].xcRedColor] andImage:[UIImage imageNamed:@"common_noData_empty"]];
        }
            break;
            case TTBillListViewTypeNoble:
        {
            [self.tableView showEmptyContentToastWithTitle:@"亲爱的宝贝，你还没有贵族记录哦!" andImage:[UIImage imageNamed:@"common_noData_empty"]];
        }
            break;
            case TTBillListViewTypeRedColor:
        {
            [self.tableView showEmptyContentToastWithTitle:[NSString stringWithFormat:@"- 仅支持查看近3个月内记录 -"] andImage:[UIImage imageNamed:@"common_noData_empty"]];
        }
            break;
            case TTBillListViewTypeGiftInCarrot:
        {
            [self.tableView showEmptyContentToastWithTitle:@"哼，你们不爱我了，一个礼物都没有" andImage:[UIImage imageNamed:@"common_noData_empty"]];
        }
            break;
            case TTBillListViewTypeGiftOutCarrot:
        {
            [self.tableView showEmptyContentToastWithTitle:@"没有查找到数据噢" andImage:[UIImage imageNamed:@"common_noData_empty"]];
        }
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark getter & setter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 82.f;
        _tableView.tableFooterView = self.footTipsLabel;
        _tableView.backgroundColor = [XCTheme getTTSimpleGrayColor];
        [_tableView registerClass:[TTBillGiftListCell class] forCellReuseIdentifier:NSStringFromClass([TTBillGiftListCell class])];
        [_tableView registerClass:[TTBillListHeadView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([TTBillListHeadView class])];
        [_tableView registerClass:[TTBillListViewCell class] forCellReuseIdentifier:NSStringFromClass([TTBillListViewCell class])];
    }
    return _tableView;
}

- (UIView *)containerView
{
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [XCTheme getTTSimpleGrayColor];
    }
    return _containerView;
}

- (UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [XCTheme getTTSimpleGrayColor];
    }
    return _topView;
}

- (UILabel *)todayLabel
{
    if (!_todayLabel) {
        _todayLabel = [[UILabel alloc] init];
        _todayLabel.text = @"2018年10月29日";
        _todayLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        _todayLabel.font = [UIFont systemFontOfSize:18.f];
        _todayLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _todayLabel;
}

- (UIButton *)todayBtn {
    if (!_todayBtn) {
        _todayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_todayBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_todayBtn.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
        [_todayBtn setImage:[UIImage imageNamed:@"Bill_todayIcon"] forState:UIControlStateNormal];
        [_todayBtn addTarget:self action:@selector(todayBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _todayBtn;
}

- (UIButton *)dayChangeBtn {
    if (!_dayChangeBtn) {
        _dayChangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dayChangeBtn setImage:[UIImage imageNamed:@"BillList_calendarIcon"] forState:UIControlStateNormal];
        [_dayChangeBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_dayChangeBtn.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
        [_dayChangeBtn addTarget:self action:@selector(dayChangeBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dayChangeBtn;
}

- (UIButton *)scrollTopBtn {
    if (!_scrollTopBtn) {
        _scrollTopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_scrollTopBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_scrollTopBtn.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
        [_scrollTopBtn setImage:[UIImage imageNamed:@"Bill_scrollTop"] forState:UIControlStateNormal];
        _scrollTopBtn.layer.masksToBounds = YES;
        _scrollTopBtn.layer.cornerRadius = 25;
        [_scrollTopBtn addTarget:self action:@selector(scrollTopBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _scrollTopBtn;
}

- (TTDatePickView *)datePickView {
    if (!_datePickView) {
        _datePickView = [[TTDatePickView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 240)];
        _datePickView.delegate = self;
        _datePickView.maximumDate = [NSDate date];
        _datePickView.time = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
        _datePickView.dateFormat = @"YYYY年MM月dd日";
    }
    return _datePickView;
}

- (NSMutableArray *)keysArr {
    if (!_keysArr) {
        _keysArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _keysArr;
}

- (NSMutableArray<NSMutableArray *> *)disPlayArr {
    if (!_disPlayArr) {
        _disPlayArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _disPlayArr;
}

- (NSString *)sortTiemStamp {
    if (!_sortTiemStamp) {
        _sortTiemStamp = [self getNowTimeTimestampMillisecond];
    }
    return _sortTiemStamp;
}

- (UIView *)topBarView
{
    if (!_topBarView) {
        _topBarView = [[UIView alloc] init];
        _topBarView.backgroundColor = [UIColor whiteColor];
    }
    return _topBarView;
}

- (UIView *)topBgView
{
    if (!_topBgView) {
        _topBgView = [[UIView alloc] init];
        _topBgView.backgroundColor = [UIColor whiteColor];
    }
    return _topBgView;
}

- (UIButton *)coinGiftBtn {
    if (!_coinGiftBtn) {
        _coinGiftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_coinGiftBtn setTitle:@"金币礼物" forState:UIControlStateNormal];
        [_coinGiftBtn setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateNormal];
        [_coinGiftBtn.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
        _coinGiftBtn.tag = 0;
        [_coinGiftBtn addTarget:self action:@selector(onCoinGiftBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _coinGiftBtn;
}

- (UIButton *)carrotGiftBtn {
    if (!_carrotGiftBtn) {
        _carrotGiftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_carrotGiftBtn setTitle:@"萝卜礼物" forState:UIControlStateNormal];
        _carrotGiftBtn.tag = 1;
        [_carrotGiftBtn setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateNormal];
        [_carrotGiftBtn.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
        [_carrotGiftBtn addTarget:self action:@selector(onCarrotGiftBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _carrotGiftBtn;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [XCTheme getTTMainColor];
        _lineView.layer.cornerRadius = 4/2;
    }
    return _lineView;
}

- (UILabel *)footTipsLabel {
    if (!_footTipsLabel) {
        _footTipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 70)];
        _footTipsLabel.font = [UIFont systemFontOfSize:12];
        _footTipsLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        _footTipsLabel.adjustsFontSizeToFitWidth = YES;
        _footTipsLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _footTipsLabel;
}

@end
