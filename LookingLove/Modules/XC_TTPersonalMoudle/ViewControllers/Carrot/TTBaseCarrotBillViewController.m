//
//  TTBaseCarrotBillViewController.m
//  TTPlay
//
//  Created by lee on 2019/3/27.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTBaseCarrotBillViewController.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"
#import "UIView+XCToast.h"
#import "PLTimeUtil.h"
#import <MJRefresh/MJRefresh.h>
#import "XCKeyWordTool.h"
// cell
#import "TTCarrotBillCell.h"
#import "TTBillListHeadView.h"
// core
#import "PurseBillCoreClient.h"
#import "PurseBillCore.h"
#import "PurseCore.h"
// model
#import "CarrotGiftInfo.h"

@interface TTBaseCarrotBillViewController ()<PurseBillCoreClient>
@property (nonatomic, strong) NSMutableArray<NSMutableArray *> *disPlayArr;
@property (nonatomic, strong) NSMutableArray *keysArr;
@property (nonatomic, copy) NSString *sortTiemStamp;
@property (nonatomic, assign) NSInteger page;

@end

@implementation TTBaseCarrotBillViewController

- (void)dealloc {
    RemoveCoreClientAll(self);
}

- (BOOL)isHiddenNavBar {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _page = 1;
    AddCoreClient(PurseBillCoreClient, self);
    
    [self baseUI];
    [self initViews];
    [self initConstraints];
    [self initMJRefresh];
    
    [GetCore(PurseBillCore) getCarrotBliiList:self.listType pageNo:self.page date:self.sortTiemStamp pageSize:50];
}

- (void)initMJRefresh {
    @weakify(self);
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.page = 1;
        [self.tableView.mj_footer endRefreshing];
        [GetCore(PurseBillCore) getCarrotBliiList:self.listType pageNo:self.page date:self.sortTiemStamp pageSize:50];
        //类型,1:萝卜币
        [GetCore(PurseCore) requestCarrotWalletWithType:1];
    }];
    
    header.stateLabel.font = [UIFont systemFontOfSize:10];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:10.0];
    header.arrowView.image = [UIImage imageNamed:@"refreshImage"];
    
    self.tableView.mj_header = header;
    
    self.tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        [GetCore(PurseBillCore) getCarrotBliiList:self.listType pageNo:self.page date:self.sortTiemStamp pageSize:50];
    }];
}

#pragma mark -
#pragma mark - lifeCycle
- (void)baseUI {
    
    self.tableView.rowHeight = 80;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[TTBillListHeadView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([TTBillListHeadView class])];
    [self.tableView registerClass:[TTCarrotBillCell class] forCellReuseIdentifier:kTTCarrotBillCellConst];
}

- (void)initViews {
    
}

- (void)initConstraints {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

#pragma mark -
#pragma mark tableView delegate & dataSource
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
    TTCarrotBillCell *cell = [tableView dequeueReusableCellWithIdentifier:kTTCarrotBillCellConst];
    if (self.disPlayArr.count > indexPath.section) { // 安全判断
        cell.carrotInfo = self.disPlayArr[indexPath.section][indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TTBillListHeadView *sectionHeadView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([TTBillListHeadView class])];
    if (self.keysArr.count > section) { // 安全检测
        sectionHeadView.titleLabel.text = self.keysArr[section];
    }
    return sectionHeadView;
}


#pragma mark -
#pragma mark clients
- (void)getCarrotGiftBliiListSuccess:(NSMutableArray *)list keys:(NSMutableArray *)keys pageNo:(NSInteger)pageNo code:(NSNumber *)code message:(NSString *)message  listType:(NSInteger)listType {
    // 结束刷新
    [self endRefresh];
    
    if (listType != self.listType) {
        return;
    }
    [self combineDatelist:list keys:keys pageNo:pageNo];
}

#pragma mark -
#pragma mark 数据统一处理
// 数据处理
- (void)combineDatelist:(NSMutableArray *)list keys:(NSMutableArray *)keys pageNo:(NSInteger)pageNo {
    
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
            //            [self showEmptyByStyle];
            [self.tableView showEmptyContentToastWithTitle:@"没有查找到数据噢" andImage:[UIImage imageNamed:@"common_noData_empty"]];
        }
    } else { // 加载更多
        
        if (list.count) {
            self.page += 1;
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
#pragma mark -
#pragma mark private methods
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

/** 结束刷新 */
- (void)endRefresh {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}
/**
 获取当前时间戳
 
 @return 时间戳
 */
- (NSString *)getNowTimeTimestampMillisecond {
    //获取当前时间戳
    return [PLTimeUtil getNowTimeTimestampMillisecond];
}

- (void)reloadDateByDate:(NSDate *)date {
    NSTimeInterval timeInterval = [date timeIntervalSince1970] * 1000;  //  *1000 是精确到毫秒，不乘就是精确到秒
    self.sortTiemStamp = [NSString stringWithFormat:@"%.f", timeInterval];
    self.page = 1;
    
    [GetCore(PurseBillCore) getCarrotBliiList:self.listType pageNo:self.page date:self.sortTiemStamp pageSize:50];
}

#pragma mark -
#pragma mark button click events

#pragma mark -
#pragma mark getter & setter

- (void)setListType:(CarrotBillListType)listType {
    _listType = listType;
    //    [GetCore(PurseBillCore) getCarrotBliiList:listType pageNo:_page date:self.sortTiemStamp pageSize:50];
}

- (NSString *)sortTiemStamp {
    if (!_sortTiemStamp) {
        _sortTiemStamp = [self getNowTimeTimestampMillisecond];
    }
    return _sortTiemStamp;
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
@end
