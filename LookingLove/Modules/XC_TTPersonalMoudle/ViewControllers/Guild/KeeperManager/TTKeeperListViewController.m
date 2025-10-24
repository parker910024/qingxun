//
//  TTKeeperListViewController.m
//  TuTu
//
//  Created by lee on 2019/1/9.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTKeeperListViewController.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"
#import "UIView+XCToast.h"
//vc
#import "TTKeeperManagerViewController.h"
#import "TTSettingKeeperViewController.h"
#import "TTGuildMemberlistViewController.h"
// cell
#import "TTMemberListCell.h"
#import "TTGuildMemberHeaderSectionView.h"
// core
#import "GuildCore.h"
#import "GuildCoreClient.h"
// model
#import "GuildHallInfo.h"
#import "UserInfo.h"

//cate
#import "UIButton+EnlargeTouchArea.h"
@interface TTKeeperListViewController ()<UITableViewDelegate, UITableViewDataSource, GuildCoreClient>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<UserInfo *> *dataArray;
@property (nonatomic, strong) TTGuildMemberHeaderSectionView *sectionHeaderView;
@property (nonatomic, strong) UIButton *rightBtnItem;
@property (nonatomic, assign) BOOL needSelected;
@end

@implementation TTKeeperListViewController

- (void)dealloc {
    RemoveCoreClientAll(self);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    AddCoreClient(GuildCoreClient, self);

    self.navigationItem.title = @"高管设置";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtnItem];
    
    [self initViews];
    [self initConstraints];
    [self requestAllKeeperList];
}

- (void)onRightItemClickHandler:(UIButton *)btn {
    // 增减高管
    TTGuildMemberlistViewController *vc = [[TTGuildMemberlistViewController alloc] init];
    vc.hallInfo = self.hallInfo;
    vc.listType = GuildHallListTypeKeeper;
    vc.managerCount = self.dataArray.count;
    vc.refreshHander = ^{
        [self requestAllKeeperList];
    };
    [self.navigationController pushViewController:vc animated:YES];
    return;
    
    btn.selected = !btn.selected;
    self.needSelected = btn.selected;
    [btn setImage:[UIImage imageNamed:@"guild_manager_edit"] forState:UIControlStateNormal];
    if (btn.selected) {
        [btn setImage:nil forState:UIControlStateNormal];
    }
    [btn setTitle:@"确定" forState:UIControlStateSelected];
    [btn setTitle:@"" forState:UIControlStateNormal];
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark lifeCycle
- (void)initViews {
    [self.view addSubview:self.tableView];
}

- (void)initConstraints {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(kNavigationHeight);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];

}

#pragma mark -
#pragma mark coreClients
- (void)responseGuildHallAllManagersList:(NSArray *)list errorCode:(NSNumber *)code msg:(NSString *)msg {
    self.dataArray = [NSMutableArray arrayWithArray:list];
    if (self.dataArray.count == 0) {
        [self.tableView showEmptyContentToastWithTitle:@"暂时没有数据哦~" andImage:[UIImage imageNamed:@"common_noData_empty"]];
    } else {
        [self.tableView hideToastView];
    }
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TTMemberListCell *cell = [tableView dequeueReusableCellWithIdentifier:kMemberListCellConst];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (self.dataArray.count > indexPath.row) {
        cell.userInfo = self.dataArray[indexPath.row];
    }
    cell.isManagerSelected = self.needSelected;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 权限设置
    TTKeeperManagerViewController *vc = [[TTKeeperManagerViewController alloc] init];
    if (self.dataArray.count > indexPath.row) {
        vc.info = self.dataArray[indexPath.row];
    }    
    [self.navigationController pushViewController:vc animated:YES];
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    self.sectionHeaderView.countLabel.text = [NSString stringWithFormat:@"总人数:%lu人", (unsigned long)self.dataArray.count];
//    return self.sectionHeaderView;
//}


#pragma mark -
#pragma mark clients

#pragma mark -
#pragma mark private methods
/** 获取全部管理员列表 */
- (void)requestAllKeeperList {
    [GetCore(GuildCore) requestGuildHallAllManagersListByHallId:self.hallInfo.hallId page:1 pageSize:50];
}
#pragma mark -
#pragma mark button click events

#pragma mark -
#pragma mark getter & setter

- (NSMutableArray<UserInfo *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 66;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[TTMemberListCell class] forCellReuseIdentifier:kMemberListCellConst];
    }
    return _tableView;
}

- (TTGuildMemberHeaderSectionView *)sectionHeaderView {
    if (!_sectionHeaderView) {
        _sectionHeaderView = [[TTGuildMemberHeaderSectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
    }
    return _sectionHeaderView;
}

- (UIButton *)rightBtnItem {
    if (!_rightBtnItem) {
        _rightBtnItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtnItem setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateNormal];
        [_rightBtnItem.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
        _rightBtnItem.frame = CGRectMake(0, 0, 30, 30);
        [_rightBtnItem setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
        [_rightBtnItem setImage:[UIImage imageNamed:@"guild_manager_edit"] forState:UIControlStateNormal];
        [_rightBtnItem addTarget:self action:@selector(onRightItemClickHandler:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtnItem;
}


@end
