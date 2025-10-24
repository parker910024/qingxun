//
//  TTSettingKeeperViewController.m
//  TuTu
//
//  Created by lee on 2019/1/16.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTSettingKeeperViewController.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"

#import "TTKeeperManagerViewController.h"
// cell
#import "TTMemberListCell.h"
#import "TTGuildMemberHeaderSectionView.h"
// core
#import "GuildCore.h"
#import "GuildCoreClient.h"
// model
#import "GuildHallInfo.h"

//cate
#import "UIButton+EnlargeTouchArea.h"

@interface TTSettingKeeperViewController ()<UITableViewDelegate, UITableViewDataSource, GuildCoreClient, TTMemberListCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) TTGuildMemberHeaderSectionView *sectionHeaderView;

@end

@implementation TTSettingKeeperViewController

- (void)dealloc {
    RemoveCoreClientAll(self);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    AddCoreClient(GuildCoreClient, self);
    
    self.navigationItem.title = @"增减高管";
    
    [self initViews];
    [self initConstraints];
    
    [GetCore(GuildCore) requestGuildHallAllManagersListByHallId:self.hallInfo.hallId page:1 pageSize:50];
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
    //    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (self.dataArray.count > indexPath.row) {
        cell.userInfo = self.dataArray[indexPath.row];
    }
    cell.delegate = self;
    cell.isManagerSelected = YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 权限设置
    TTKeeperManagerViewController *vc = [[TTKeeperManagerViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
#pragma mark clients

#pragma mark -
#pragma mark private methods

#pragma mark -
#pragma mark button click events

#pragma mark -
#pragma mark getter & setter

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
@end
