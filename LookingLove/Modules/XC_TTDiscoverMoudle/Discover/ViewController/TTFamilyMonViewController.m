//
//  TTFamilyMonViewController.m
//  TuTu
//
//  Created by gzlx on 2018/11/5.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTFamilyMonViewController.h"
//core
#import "FamilyCore.h"
#import "FamilyCoreClient.h"
#import "AuthCore.h"
//view
#import "TTFamilyMonHeaderView.h"
#import "TTFamilyMonSectionView.h"
#import "TTFamilyMonTableViewCell.h"
#import "TTFamilyEmptyTableViewCell.h"
#import "TTDatePickView.h"
//Tool
#import "XCTheme.h"
#import <Masonry/Masonry.h>
#import "XCMacros.h"
#import "NSArray+Safe.h"
#import "TTFamilyBaseAlertController.h"
#import "XCHUDTool.h"
#import "XCAlertControllerCenter.h"
#import "TTPopup.h"
//vc
#import "TTFamilyMemberMonViewController.h"
#import "TTFamilySearchViewController.h"
#import "TTFamilyMemberMonViewController.h"

@interface TTFamilyMonViewController ()<FamilyCoreClient, TTFamilyMonHeadDelegate, UITableViewDelegate, UITableViewDataSource, TTFamilyMonSectionViewDelegate, TTDatePickViewDelegate, TTFamilySearchViewControllerDelegate>
@property (nonatomic, strong) NSMutableArray<XCFamilyMoneyModel *> * dataArray;
@property (nonatomic, strong) TTFamilyMonHeaderView * headerView;
@property (nonatomic, strong) NSMutableArray<XCFamilyModel *> * weekRecordArray;
@property (nonatomic, assign) int cuurentPage;
@property (nonatomic, strong) NSString * selectTime;
@property (nonatomic, strong) NSDate * selectDate;
/** 请求得到的家族*/
@property (nonatomic, strong) XCFamily * familyManager;
/** 贡献家族b*/
@property (nonatomic, strong) NSString * contribuFamilyMon;

@property (nonatomic, strong) TTDatePickView * datePickView;
@end

@implementation TTFamilyMonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addCore];
    [self initView];
    [self initContrations];
 
}
#pragma mark - response
- (void)sarchAction:(UIButton *)sender{
    if (self.ownerType != FamilyMoneyOwnerGroup) {
        TTFamilySearchViewController * searchVC = [[TTFamilySearchViewController alloc] init];
        searchVC.delegate = self;
        searchVC.currentNav = self.navigationController;
        searchVC.searchType = TTFamilySearchType_Family_Member;
        searchVC.listType = FamilyMemberListMoneyTransfer;
        [self.navigationController presentViewController:searchVC animated:YES completion:nil];
    }
}
#pragma makr - private method
- (void)initView{
    self.tableView.tableViewHeightOnScreen = 1;
    if (self.ownerType != FamilyMoneyOwnerMe) {
         [self addNavigationItemWithImageNames:@[@"family_search"] isLeft:NO target:self action:@selector(sarchAction:) tags:nil];
    }

    [self.tableView registerClass:[TTFamilyMonTableViewCell class] forCellReuseIdentifier:@"TTFamilyMonTableViewCell"];
    [self.tableView registerClass:[TTFamilyEmptyTableViewCell class] forCellReuseIdentifier:@"TTFamilyEmptyTableViewCell"];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;  //  *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
    self.selectTime = timeString;
    [self setupRefreshTarget:self.tableView];
    [self pullDownRefresh:1];
    [self configHeaderView];
   
}

- (void)configHeaderView{
    self.headerView.monType = self.ownerType;
    if (self.ownerType == FamilyMoneyOwnerMe) {
        self.title = @"我的家族币";
        self.headerView.frame = CGRectMake(0, 0, KScreenWidth, 223);
    }else{
        if (self.ownerType == FamilyMoneyOwnerGroup) {
            self.title= @"群统计";
            self.headerView.frame = CGRectMake(0, 0, KScreenWidth, 273);
        }else{
            self.title = @"家族币管理";
           self.headerView.frame = CGRectMake(0, 0, KScreenWidth, 223);
        }
    }
    self.tableView.tableHeaderView = self.headerView;
}

- (void)initContrations{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(statusbarHeight + 44);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
}

- (void)addCore{
    AddCoreClient(FamilyCoreClient, self);
}

#pragma mark - UITableViewDelegate and UITabelViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.ownerType == FamilyMoneyOwnerGroup) {
        return self.weekRecordArray.count > 0 ? self.weekRecordArray.count : 1;
    }
    if (self.dataArray.count > 0) {
        XCFamilyMoneyModel * model= [self.dataArray safeObjectAtIndex:section];
        return model.list.count > 0 ? model.list.count : 0;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.ownerType == FamilyMoneyOwnerGroup) {
        if (self.weekRecordArray.count > 0) {
            return 70;
        }
    }
    return self.dataArray.count > 0 ? 70 : 320;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.ownerType == FamilyMoneyOwnerGroup) {
        return 0;
    }
    return 51;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.ownerType == FamilyMoneyOwnerGroup) {
        return [UIView new];
    }
    TTFamilyMonSectionView * headerView = [[TTFamilyMonSectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 51)];
    headerView.delegate = self;
    XCFamilyMoneyModel * model = [self.dataArray safeObjectAtIndex:section];
    [headerView cofigFamilyMonSetionWith:model selectData:self.selectDate];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.ownerType == FamilyMoneyOwnerGroup) {
        if (self.weekRecordArray.count > 0) {
            TTFamilyMonTableViewCell * cell= [tableView dequeueReusableCellWithIdentifier:@"TTFamilyMonTableViewCell"];
            if (cell == nil) {
                cell = [[TTFamilyMonTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TTFamilyMonTableViewCell"];
            }
            cell.currentController = self;
            cell.type = self.ownerType;
            XCFamilyModel * model= [self.weekRecordArray safeObjectAtIndex:indexPath.row];
            [cell configTTMonCellWithMonInfor:model];
            return cell;
        }
    }else{
        if (self.dataArray.count > 0) {
            TTFamilyMonTableViewCell * cell= [tableView dequeueReusableCellWithIdentifier:@"TTFamilyMonTableViewCell"];
            if (cell == nil) {
                cell = [[TTFamilyMonTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TTFamilyMonTableViewCell"];
            }
            cell.currentController = self;
            cell.type = self.ownerType;
            XCFamilyMoneyModel * model = [self.dataArray safeObjectAtIndex:indexPath.section];
            XCFamilyModel * moneyModel = [model.list safeObjectAtIndex:indexPath.row];
            [cell configTTMonCellWithMonInfor:moneyModel];
            return cell;
        }
    }
    TTFamilyEmptyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TTFamilyEmptyTableViewCell"];
    if (cell == nil) {
        cell = [[TTFamilyEmptyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TTFamilyEmptyTableViewCell"];
    }
    cell.iconImageView.image = [UIImage imageNamed:@"common_noData_empty"];
    cell.titleLabel.text = @"暂无记录哦";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - TTFamilySearchViewControllerDelegate
- (void)didSelectFamilyMemberWith:(XCFamilyModel *)familyMember selectDic:(NSMutableDictionary *)selectDic{
    if (familyMember) {
        TTFamilyMemberMonViewController * memberMon = [[TTFamilyMemberMonViewController alloc] init];
        if (self.ownerType == FamilyMoneyOwnerGroup) {
            memberMon.isWeekRecord = YES;
            memberMon.chatId = self.chatId;
        }else{
            memberMon.isWeekRecord = NO;
        }
        memberMon.searchModel = familyMember;
        [self.navigationController pushViewController:memberMon animated:YES];
    }
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
    self.cuurentPage = 1;
    [GetCore(FamilyCore) fetchFamilyMoneyRecordListWith:[[GetCore(AuthCore) getUid] longLongValue] andPage:1 withTime:self.selectTime status:0 isSearch:NO];
}

#pragma mark - TTFamilyMonSectionViewDelegate
- (void)chooseDataWith:(UIButton *)sender{
    TTPopupService *service = [[TTPopupService alloc] init];
    service.contentView = self.datePickView;
    service.style = TTPopupStyleActionSheet;
    
    [TTPopup popupWithConfig:service];
}

#pragma mark - TTFamilyMonHeadDelegate
- (void)contriMonToOwner:(UIButton *)sender{
    if (self.familyManager) {
        NSString * title = [NSString stringWithFormat:@"贡献%@", self.familyManager.moneyName];
        NSString *  message = [NSString stringWithFormat:@"可贡献%@: %.2f%@", self.familyManager.moneyName,self.familyManager.totalAmount, self.familyManager.moneyName];
        XCFamily * family =[GetCore(FamilyCore) getFamilyModel];
        XCFamilyModel  * model = [family.members firstObject];
        NSString * target = [NSString stringWithFormat:@"贡献给：%@", model.name];
        @weakify(self);
        TTFamilyAlertModel * config = [[TTFamilyAlertModel alloc] init];
        config.tipString = title;
        config.content = message;
        config.isShowMon = YES;
        config.placeHolder = @"请输入贡献数量";
        config.keyboardType = UIKeyboardTypeDecimalPad;
        config.changeColorString = [NSString stringWithFormat:@"%.2f%@", self.familyManager.totalAmount, self.familyManager.moneyName];
        [[TTFamilyBaseAlertController defaultCenter] showAlertViewWithTextFiledWith:self alertConfig:config sure:^{
            @strongify(self);
            [self transferFamilyMoneyToMember:family.leader];
        } canle:nil text:^(NSString * _Nonnull text) {
            @strongify(self);
            self.contribuFamilyMon = text;
        }];
    }
}

- (void)transferFamilyMoneyToMember:(XCFamilyModel *)model{
    if ([self.contribuFamilyMon floatValue] > 0) {
        [GetCore(FamilyCore) memberContributeFamilyMoney:self.contribuFamilyMon];
    }else{
        [XCHUDTool showErrorWithMessage:@"请输入正确的金额" inView:self.view];
    }
}

#pragma mark - FamilyCoreClient
- (void)getGroupWeekFamilyMoneyRecordSuccess:(XCFamily *)infor status:(int)status isSearch:(BOOL)isSearch{
    if (isSearch) {
        return;
    }
    self.headerView.monType = self.ownerType;
    [self.headerView configFamilyMoneyHeaderWithFamily:infor];
    if (self.cuurentPage == 1) {
        [self.weekRecordArray removeAllObjects];
        self.weekRecordArray = infor.weekRecords;
    }else{
        [self.weekRecordArray addObjectsFromArray:infor.weekRecords];
    }
    if (infor.weekRecords.count > 0) {
        [self successEndRefreshStatus:status hasMoreData:YES];
    }else{
        [self successEndRefreshStatus:status hasMoreData:NO];
    }
    [self.tableView reloadData];
}

- (void)getGroupWeekFamilyMoneyRecordFail:(NSString *)message status:(int)status isSearch:(BOOL)isSearch{
    [self failEndRefreshStatus:status];
}

//顶部
- (void)fetchFamilyManagerSuccess:(XCFamily *)moneyManaer{
    self.headerView.monType = self.ownerType;
    self.familyManager = moneyManaer;
    [self.headerView configFamilyMoneyHeaderWithFamily:moneyManaer];
    [self successEndRefreshStatus:0 hasMoreData:YES];
}

- (void)fetchFamilyManagerFail:(NSString *)message{
    [self failEndRefreshStatus:0];
}
//家族bi
- (void)fetchFamilyMoneyListSuccess:(NSMutableArray<XCFamilyMoneyModel *> *)recordlist status:(int)status isSearch:(BOOL)isSearch{
    if (isSearch) {
        return;
    }
    if (self.cuurentPage == 1) {
        [self.dataArray removeAllObjects];
        self.dataArray = recordlist;
        [self successEndRefreshStatus:status hasMoreData:YES];
    }else{
        if (recordlist.count > 0) {
            if ([[[recordlist firstObject] month] isEqualToString:[[self.dataArray lastObject] month]]) {
                [[[self.dataArray lastObject] list] addObjectsFromArray:[[recordlist firstObject]list]];
                [recordlist removeObjectAtIndex:0];
                if (recordlist.count > 0) {
                    [self.dataArray addObjectsFromArray:recordlist];
                }
            }else{
                [self.dataArray addObjectsFromArray:recordlist];
            }
            [self successEndRefreshStatus:status hasMoreData:YES];
        }else{
            [self successEndRefreshStatus:status hasMoreData:NO];
        }
    }
    [self.tableView reloadData];
}

- (void)fetchFamilyMoneyListFail:(NSString *)message status:(int)status isSearch:(BOOL)isSearch{
    [self failEndRefreshStatus:status];
}

//收到自定义的消息
- (void)reciveMeesageReloadFamilyMoney:(MessageParams *)message{
    if (message.actionType == FamilyNotificationType_Trade_Money || message.actionType == FamilyNotificationType_Donate_Money) {
        [self pullDownRefresh:1];
    }
    if (message.actionType == FamilyNotificationType_Donate_Money) {
        [XCHUDTool showSuccessWithMessage:@"贡献成功" inView:self.view];
    }
}
#pragma mark - http
- (void)pullDownRefresh:(int)page{
    self.cuurentPage = page;
    if(self.ownerType == FamilyMoneyOwnerGroup){
        [GetCore(FamilyCore) getGroupWeekFamilyMoneyRecord:self.chatId erbanNo:self.tutuId page:page status:0 isSearch:NO];
    }else{
        //查询个人的家族币流水（包含族长）
        [GetCore(FamilyCore) fetchFamilyMoneyManaegerWith:[GetCore(AuthCore) getUid]];
        [GetCore(FamilyCore) fetchFamilyMoneyRecordListWith:[[GetCore(AuthCore) getUid] longLongValue] andPage:page withTime:self.selectTime status:0 isSearch:NO];
    }
}

- (void)pullUpRefresh:(int)page lastPage:(BOOL)isLastPage{
    if (isLastPage) {
        return;
    }
    self.cuurentPage = page;
    if(self.ownerType == FamilyMoneyOwnerGroup){
        [GetCore(FamilyCore) getGroupWeekFamilyMoneyRecord:self.chatId erbanNo:self.tutuId page:page status:1 isSearch:NO];
    }else{
        [GetCore(FamilyCore) fetchFamilyMoneyRecordListWith:[[GetCore(AuthCore) getUid] longLongValue] andPage:page withTime:self.selectTime status:1 isSearch:NO];
    }
}

#pragma mark - setters and getters
- (TTFamilyMonHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[TTFamilyMonHeaderView alloc] init];
        _headerView.delegate = self;
        _headerView.currentController = self;
    }
    return _headerView;
}

- (TTDatePickView *)datePickView{
    if (!_datePickView) {
        _datePickView = [[TTDatePickView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 240)];
        _datePickView.delegate = self;
        _datePickView.maximumDate = [NSDate date];
        _datePickView.time = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
        _datePickView.dateFormat = @"YYYY年MM月dd日";
    }
    return _datePickView;
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
