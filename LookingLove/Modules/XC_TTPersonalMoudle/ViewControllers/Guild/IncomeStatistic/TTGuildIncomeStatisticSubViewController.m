//
//  TTGuildIncomeStatisticSubViewController
//  TuTu
//
//  Created by lvjunhang on 2019/1/19.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTGuildIncomeStatisticSubViewController.h"
#import "TTGuildIncomeStatisticTableHeaderView.h"
#import "TTGuildIncomeDetailsViewController.h"
#import "TTGuildIncomeStatisticSectionHeaderView.h"
#import "TTGuildIncomeStatisticCell.h"
#import "XCEmptyDataView.h"

// core
#import "GuildCore.h"
#import "GuildCoreClient.h"

#import <Masonry/Masonry.h>
#import "XCHUDTool.h"
#import "UIView+XCToast.h"
#import "NSArray+Safe.h"
#import "XCMacros.h"
#import "XCTheme.h"

#import "XCMediator+TTRoomMoudleBridge.h"
#import "TTDatePickView.h"
#import "PLTimeUtil.h"
#import "TTPopup.h"

#import "TTStatisticsService.h"

static NSString *const kCellID = @"kCellID";
static NSString *const kSectionHeaderID = @"kSectionHeaderID";

@interface TTGuildIncomeStatisticSubViewController ()<GuildCoreClient, TTDatePickViewDelegate>

@property (nonatomic, strong) GuildIncomeTotal *model;

@property (nonatomic, strong) XCEmptyDataView *emptyDataView;

@property (nonatomic, strong) TTGuildIncomeStatisticTableHeaderView *headerView;
@property (nonatomic, strong) TTDatePickView *datePickView;

@property (nonatomic, strong) NSMutableArray<GuildIncomeTotalVos *> *dataArray;
@property (nonatomic, assign) NSInteger page; // 页数

@property (nonatomic, copy) NSString *startDay;
@property (nonatomic, copy) NSString *endDay;

@property (nonatomic, copy) NSString *selectedDay;

@end

@implementation TTGuildIncomeStatisticSubViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    _page = 1;
    
    AddCoreClient(GuildCoreClient, self);
}

- (void)dealloc {
    RemoveCoreClientAll(self);
}

#pragma mark - Overriden
/**
 下拉刷新的回调 子类需要重写
 @param page 当前请求的页数
 */
- (void)pullDownRefresh:(int)page {
    [self requestIncomDataList];
}

- (void)requestIncomDataList {
    NSString *hallId = GetCore(GuildCore).hallInfo.hallId;
    switch (self.type) {
        case TTGuildIncomeStatisticTypeDay:
        {
            [GetCore(GuildCore) requestGuildIncomeTotalWithHallId:hallId startTimeStr:self.selectedDay endTimeStr:nil];
        }
            break;
        case TTGuildIncomeStatisticTypeWeek:
        {
            [GetCore(GuildCore) requestGuildIncomeTotalWithHallId:hallId startTimeStr:self.startDay endTimeStr:self.endDay];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - UITableViewViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TTGuildIncomeStatisticCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (self.dataArray.count > indexPath.row) {
        cell.model = self.dataArray[indexPath.row];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TTGuildIncomeStatisticSectionHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kSectionHeaderID];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44+26;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 33+13;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [TTStatisticsService trackEvent:TTStatisticsServiceEventIncomeDetailClick
                      eventDescribe:@"查看成员收入详细"];
    
    TTGuildIncomeDetailsViewController *vc = [[TTGuildIncomeDetailsViewController alloc] init];
    if (self.dataArray.count > indexPath.row) {
        vc.totalInfo = self.dataArray[indexPath.row];
    }
    vc.startTime = self.startDay;
    vc.endTime = self.endDay;
    if (self.type == TTGuildIncomeStatisticTypeDay) {
        // 如果是日统计。结束时间传空;
        vc.endTime = @"";
    }
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - private method
- (void)initView {
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.tableViewHeightOnScreen = 1;
    [self setupRefreshTarget:self.tableView];
    
    self.tableView.tableHeaderView = self.headerView;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    __weak typeof(self) weakself = self;
    self.headerView.selectDayActionBlock = ^{
        [weakself datePicker];
    };
    
    [self.tableView registerClass:TTGuildIncomeStatisticCell.class forCellReuseIdentifier:kCellID];
    [self.tableView registerClass:TTGuildIncomeStatisticSectionHeaderView.class forHeaderFooterViewReuseIdentifier:kSectionHeaderID];
}

- (NSString *)getNowTimeTimestampMillisecond {
    //获取当前时间戳
    return [PLTimeUtil getYYMMDDWithDate:[NSDate date]];
}

/**
 调用时间选择器
 */
- (void)datePicker {
    if (self.headerView.selectDate) {
        self.datePickView.atTime = [PLTimeUtil getYYMMDDWithDate:self.headerView.selectDate];
    }
    
    TTPopupService *service = [[TTPopupService alloc] init];
    service.contentView = self.datePickView;
    service.style = TTPopupStyleActionSheet;
    
    [TTPopup popupWithConfig:service];
}

#pragma mark -
#pragma mark datePicker delegate
//取消
- (void)ttDatePickCancelAction {
    [TTPopup dismiss];
}

//不满足  限制
- (void)ttDatePickLimitAction {
    [XCHUDTool showErrorWithMessage:@"出错了" inView:self.view];
}

//确认选择  年月日   时间
- (void)ttDatePickEnsureAction:(NSString *)YMd date:(NSDate *)date {
    
    [self ttDatePickCancelAction];
    
    self.selectedDay = YMd;
    self.startDay = YMd;
    self.headerView.selectDate = date;
    
    // 请求数据
    [self requestIncomDataList];
}

// 确认选择 开始日期， 结束日期 时间
- (void)ttDatePickEnsureActionStartTime:(NSString *)startYMd endTime:(NSString *)endYMD date:(NSDate *)date {
    
    [self ttDatePickCancelAction];
    
    self.startDay = startYMd;
    self.endDay = endYMD;
    
    self.headerView.selectDate = date;
    self.headerView.startDate = [PLTimeUtil getDateWithYearMonthDay:startYMd];
    self.headerView.endDate = [PLTimeUtil getDateWithYearMonthDay:endYMD];
    
    // 请求数据
    [self requestIncomDataList];
}

#pragma mark -
#pragma mark coreClient
- (void)responseGuildIncomeWeeklyTotal:(GuildIncomeTotal *)data errorCode:(NSNumber *)code msg:(NSString *)msg {
    
    [self.tableView endRefreshStatus:0];
    [self.tableView endRefreshStatus:1];
    
    if (self.type == TTGuildIncomeStatisticTypeDay) {
        return;
    }
    
    if (_page == 1) {
        self.dataArray = [NSMutableArray arrayWithArray:data.vos];
        if (self.dataArray.count > 0) {
            [self.tableView hideToastView];
        } else {
            [self.tableView showEmptyContentToastWithTitle:@"暂时没有数据哦~" andImage:[UIImage imageNamed:@"common_noData_empty"]];
        }
        [self.tableView endRefreshStatus:0 totalPage:data.total];
    } else {
        [self.dataArray addObjectsFromArray:data.vos];
        if (data.vos.count == 0) {
            _page -= 1;
        }
        [self.tableView endRefreshStatus:1 totalPage:data.total];
    }
    // 总计
    [self.headerView setupTotalNumber:data.total];
    
    [self.tableView reloadData];
}

- (void)responseGuildIncomeDailyTotal:(GuildIncomeTotal *)data errorCode:(NSNumber *)code msg:(NSString *)msg {
    
    [self.tableView endRefreshStatus:0];
    [self.tableView endRefreshStatus:1];
    
    if (self.type == TTGuildIncomeStatisticTypeWeek) {
        self.tableView.emptyViewInteractionEnabled = YES;
        return;
    }
    
    if (_page == 1) {
        self.dataArray = [NSMutableArray arrayWithArray:data.vos];
        if (self.dataArray.count > 0) {
            [self.tableView hideToastView];
        } else {
            self.tableView.emptyViewInteractionEnabled = YES;
            [self.tableView showEmptyContentToastWithTitle:@"暂时没有数据哦~" andImage:[UIImage imageNamed:@"common_noData_empty"]];
        }
        [self.tableView endRefreshStatus:0 totalPage:data.total];
    } else {
        [self.dataArray addObjectsFromArray:data.vos];
        if (data.vos.count == 0) {
            _page -= 1;
        }
        [self.tableView endRefreshStatus:1 totalPage:data.total];
    }
    // 总计
    [self.headerView setupTotalNumber:data.total];
    
    [self.tableView reloadData];
}

#pragma mark - getters and setters
- (void)setType:(TTGuildIncomeStatisticType)type {
    _type = type;
    
    self.headerView.isWeek = self.type == TTGuildIncomeStatisticTypeWeek;
    self.datePickView.isWeek = self.type == TTGuildIncomeStatisticTypeWeek;

    self.selectedDay = [PLTimeUtil getYYMMDDWithDate:self.headerView.selectDate];
    self.startDay = [PLTimeUtil getYYMMDDWithDate:self.headerView.startDate];
    self.endDay = [PLTimeUtil getYYMMDDWithDate:self.headerView.endDate];
    
    [self requestIncomDataList];
}

- (XCEmptyDataView *)emptyDataView {
    if (!_emptyDataView) {
        _emptyDataView = [[XCEmptyDataView alloc] init];
        _emptyDataView.title = @"暂时没有数据哦~";
        _emptyDataView.messageLabel.textColor = RGBCOLOR(153, 153, 153);
        _emptyDataView.messageLabel.font = [UIFont systemFontOfSize:13];
        _emptyDataView.image = [UIImage imageNamed:@"common_noData_empty"];
        _emptyDataView.imageFrame = CGRectMake(0, 100, KScreenWidth, 320 * KScreenWidth/375);
        _emptyDataView.hidden = YES;
        _emptyDataView.backgroundColor = [UIColor whiteColor];
        _emptyDataView.margin = -90;
        _emptyDataView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
        [self.tableView addSubview:_emptyDataView];
    }
    return _emptyDataView;
}

- (TTGuildIncomeStatisticTableHeaderView *)headerView {
    if (_headerView == nil) {
        _headerView = [[TTGuildIncomeStatisticTableHeaderView alloc] init];
        _headerView.frame = CGRectMake(0, 0, KScreenWidth, 105);
    }
    return _headerView;
}

- (TTDatePickView *)datePickView {
    if (!_datePickView) {
        _datePickView = [[TTDatePickView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 280)];
        _datePickView.delegate = self;
        _datePickView.maximumDate = [NSDate date];
        _datePickView.time = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
    }
    return _datePickView;
}

- (NSMutableArray<GuildIncomeTotalVos *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSString *)selectedDay {
    if (!_selectedDay) {
        _selectedDay = [self getNowTimeTimestampMillisecond];
    }
    return _selectedDay;
}

- (NSString *)startDay {
    if (!_startDay) {
        _startDay = [self getNowTimeTimestampMillisecond];
    }
    return _startDay;
}

- (NSString *)endDay {
    if (!_endDay) {
        _endDay = [self getNowTimeTimestampMillisecond];
        if (self.type == TTGuildIncomeStatisticTypeDay) {
            _endDay = @"";
        }
    }
    return _endDay;
}
@end
