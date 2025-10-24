//
//  TTFamilyMemberMonViewController.m
//  TuTu
//
//  Created by gzlx on 2018/11/21.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTFamilyMemberMonViewController.h"
#import "TTFamilyMonTableViewCell.h"
#import "TTFamilyMonSectionView.h"
#import "TTDatePickView.h"
#import <Masonry/Masonry.h>
#import "UIView+XCToast.h"
#import "NSArray+Safe.h"
#import "XCMacros.h"
#import "XCTheme.h"
#import "TTPopup.h"
//core
#import "XCFamilyMoneyModel.h"
#import "AuthCore.h"
#import "FamilyCore.h"
#import "FamilyCoreClient.h"


@interface TTFamilyMemberMonViewController ()<FamilyCoreClient, TTFamilyMonSectionViewDelegate, TTDatePickViewDelegate>
@property (nonatomic, assign) int currentPage;
/** 家族币*/
@property (nonatomic, strong) NSMutableArray<XCFamilyMoneyModel *> * memberMonArray;
/** 流水*/
@property (nonatomic, strong) NSMutableArray<XCFamilyModel *>* memberWeekArray;
/** 选择日期*/
@property (nonatomic, strong) TTDatePickView * dataPickView;
@property (nonatomic, strong) NSString * selectTime;
@property (nonatomic, copy) NSArray * array;
@property (nonatomic, strong) NSDate * selectDate;

@end

@implementation TTFamilyMemberMonViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addCore];
    [self initView];
    [self initContrations];
}

- (void)addCore{
    AddCoreClient(FamilyCoreClient, self);
}

- (void)initView{
    if (self.isWeekRecord) {
        NSString * name = self.searchModel.nick? self.searchModel.name : @"--";
        self.title = [NSString stringWithFormat:@"%@的群流水记录",name];
    }else{
        NSString * name = self.searchModel.name? self.searchModel.name: @"--";
        self.title = [NSString stringWithFormat:@"%@的家族币记录",name];
    }
    self.tableView.tableViewHeightOnScreen = 1;
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;  //  *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
    self.selectTime = timeString;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[TTFamilyMonTableViewCell class] forCellReuseIdentifier:@"TTFamilyMonTableViewCell"];
    self.tableView.tableFooterView = [UIView new];
    [self setupRefreshTarget:self.tableView];
    [self pullDownRefresh:1];
}

- (void)initContrations{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(statusbarHeight + 44);
    }];
}

#pragma mark - UITableViewDelegate and UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.isWeekRecord) {
        return self.memberWeekArray.count > 0 ? 1 : 0;
    }
    return self.memberMonArray.count > 0 ? self.memberMonArray.count : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isWeekRecord) {
        return self.memberWeekArray.count > 0 ? self.memberWeekArray.count : 0;
    }
    if (self.memberMonArray.count > 0) {
        XCFamilyMoneyModel * model= [self.memberMonArray safeObjectAtIndex:section];
        return model.list.count > 0 ? model.list.count : 0;
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isWeekRecord) {
        if (self.memberWeekArray.count > 0) {
            return 70;
        }
        return 0;
    }else{
        if (self.memberMonArray.count> 0) {
            return 70;
        }
        return 0;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  self.memberMonArray.count > 0 ? 51: 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.isWeekRecord) {
        return [UIView new];
    }
    TTFamilyMonSectionView * headerView = [[TTFamilyMonSectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 51)];
    headerView.delegate = self;
    XCFamilyMoneyModel * model = [self.memberMonArray safeObjectAtIndex:section];
    [headerView cofigFamilyMonSetionWith:model selectData:self.selectDate];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TTFamilyMonTableViewCell * cell= [tableView dequeueReusableCellWithIdentifier:@"TTFamilyMonTableViewCell"];
    if (cell == nil) {
        cell = [[TTFamilyMonTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TTFamilyMonTableViewCell"];
    }
    cell.currentController = self;
    if (self.isWeekRecord) {
            XCFamilyModel * model= [self.memberWeekArray safeObjectAtIndex:indexPath.row];
            [cell configTTMonCellWithMonInfor:model];
            return cell;
    }else{
            XCFamilyMoneyModel * model = [self.memberMonArray safeObjectAtIndex:indexPath.section];
            XCFamilyModel * moneyModel = [model.list safeObjectAtIndex:indexPath.row];
            [cell configTTMonCellWithMonInfor:moneyModel];
            return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - TTDatePickViewDelegate
- (void)ttDatePickCancelAction{
    [TTPopup dismiss];
}
//确认选择  年月日   时间
- (void)ttDatePickEnsureAction:(NSString *)YMd date:(NSDate *)date{
    self.selectDate = date;
    NSInteger timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue] *1000;
    self.selectTime = [NSString stringWithFormat:@"%ld", timeSp];
    self.currentPage = 1;
    [GetCore(FamilyCore) fetchFamilyMoneyRecordListWith:[[GetCore(AuthCore) getUid] longLongValue] andPage:1 withTime:self.selectTime status:0 isSearch:NO];
}

#pragma mark - TTFamilyMonSectionViewDelegate
- (void)chooseDataWith:(UIButton *)sender{
    
    TTPopupService *service = [[TTPopupService alloc] init];
    service.contentView = self.dataPickView;
    service.style = TTPopupStyleActionSheet;
    
    [TTPopup popupWithConfig:service];
}

- (void)pullDownRefresh:(int)page{
    self.currentPage = page;
    if (self.isWeekRecord) {
        [GetCore(FamilyCore) getGroupWeekFamilyMoneyRecord:self.chatId erbanNo:[self.searchModel.erbanNo userIDValue] page:page status:0 isSearch:YES];
    }else{
        [GetCore(FamilyCore) fetchFamilyMoneyRecordListWith:[self.searchModel.uid userIDValue] andPage:page withTime:self.selectTime  status:0 isSearch:YES];
    }
}

- (void)pullUpRefresh:(int)page lastPage:(BOOL)isLastPage{
    if (isLastPage) {
        return;
    }
    self.currentPage = page;
    if (self.isWeekRecord) {
        [GetCore(FamilyCore) getGroupWeekFamilyMoneyRecord:self.chatId erbanNo:[self.searchModel.erbanNo userIDValue] page:page status:0 isSearch:YES];
    }else{
        [GetCore(FamilyCore) fetchFamilyMoneyRecordListWith:[self.searchModel.uid userIDValue] andPage:page withTime:self.selectTime  status:0 isSearch:YES];
    }
}
#pragma mark - FamilyCoreClient
//个人的家族币记录
- (void)fetchFamilyMoneyListSuccess:(NSMutableArray<XCFamilyMoneyModel *> *)recordlist status:(int)status isSearch:(BOOL)isSearch{
    if (isSearch) {
        self.array = [recordlist copy];
        if (self.currentPage == 1) {
            [self.memberMonArray removeAllObjects];
            self.memberMonArray = recordlist;
            [self successEndRefreshStatus:status hasMoreData:YES];
        }else{
            if (recordlist.count > 0) {
                if ([[[recordlist firstObject] month] isEqualToString:[[self.memberMonArray lastObject] month]]) {
                    [[[self.memberMonArray lastObject] list] addObjectsFromArray:[[recordlist firstObject]list]];
                    [recordlist removeObjectAtIndex:0];
                    if (recordlist.count > 0) {
                        [self.memberMonArray addObjectsFromArray:recordlist];
                    }
                }else{
                    [self.memberMonArray addObjectsFromArray:recordlist];
                }
                [self successEndRefreshStatus:status hasMoreData:YES];
            }else{
                [self successEndRefreshStatus:status hasMoreData:NO];
            }
        }
        [self.tableView hideToastView];
        if (self.memberMonArray.count == 0) {
            [self.tableView showEmptyContentToastWithTitle:@"暂无记录" andImage:[UIImage imageNamed:[[XCTheme defaultTheme] default_empty]]];
        }
        [self.tableView reloadData];
    }
}

- (void)fetchFamilyMoneyListFail:(NSString *)message status:(int)status isSearch:(BOOL)isSearch{
    if (isSearch) {
        [self failEndRefreshStatus:status];
    }
}


//群流水的
- (void)getGroupWeekFamilyMoneyRecordSuccess:(XCFamily *)infor status:(int)status isSearch:(BOOL)isSearch{
    if (isSearch) {
        self.array = infor.weekRecords;
        if (self.currentPage == 1) {
            [self.memberWeekArray removeAllObjects];
            self.memberWeekArray = infor.weekRecords;
            [self successEndRefreshStatus:status hasMoreData:YES];
        }else{
            if (infor.weekRecords.count > 0) {
                [self.memberWeekArray addObjectsFromArray:infor.weekRecords];
                [self successEndRefreshStatus:status hasMoreData:YES];
            }else{
                [self successEndRefreshStatus:status hasMoreData:NO];
            }
        }
        [self.tableView hideToastView];
        if (self.memberWeekArray.count == 0) {
            [self.tableView showEmptyContentToastWithTitle:@"暂无记录" andImage:[UIImage imageNamed:[[XCTheme defaultTheme] default_empty]]];
        }
        [self.tableView reloadData];
    }
}
//群流水
- (void)getGroupWeekFamilyMoneyRecordFail:(NSString *)message status:(int)status isSearch:(BOOL)isSearch{
    [self failEndRefreshStatus:status];
}

- (void)dealloc{
    RemoveCoreClientAll(self);
}

- (TTDatePickView *)dataPickView{
    if (!_dataPickView) {
        _dataPickView = [[TTDatePickView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 240)];
        _dataPickView.delegate = self;
        _dataPickView.maximumDate = [NSDate date];
        _dataPickView.time = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
        _dataPickView.dateFormat = @"YYYY年MM月dd日";
    }
    return _dataPickView;
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
