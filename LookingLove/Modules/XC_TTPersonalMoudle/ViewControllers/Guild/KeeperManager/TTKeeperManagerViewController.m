//
//  TTKeeperManagerViewController.m
//  TuTu
//
//  Created by lee on 2019/1/9.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTKeeperManagerViewController.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"
#import "XCHUDTool.h"
// cell
#import "TTKeeperManagerCell.h"
#import "TTGuildUserInfoView.h"
// core
#import "GuildCore.h"
#import "GuildCoreClient.h"
#import "AuthCore.h"
#import "UserCore.h"
// model
#import "GuildHallInfo.h"
#import "UserInfo.h"
#import "GuildHallManagerInfo.h"
// tool
#import "TTPopup.h"

@interface TTKeeperManagerViewController ()<UITableViewDelegate, UITableViewDataSource, TTKeeperManagerCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) TTGuildUserInfoView *headView;
@property (nonatomic, strong) NSMutableArray<GuildHallManagerInfo *> *dataArray;
/** 权限数组 */
@property (nonatomic, strong) NSMutableArray<NSString *> *authStrArray;
/** 修改的内容 */
@property (nonatomic, strong) NSMutableArray<NSString *> *selectedArray;

/** 模厅厅主信息 */
@property (nonatomic, strong) UserInfo *hallUserInfo;
@end

@implementation TTKeeperManagerViewController

- (void)dealloc {
    RemoveCoreClientAll(self);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"权限设置";
    [self addNavigationItemWithTitles:@[@"确定"] titleColor:[XCTheme getTTMainColor] isLeft:NO target:self action:@selector(onRightEnterItemClickHandler:) tags:@[@1001]];
    [self addNavigationItemWithImageNames:@[@"nav_bar_back"] isLeft:YES target:self action:@selector(onLeftBackItemClickHandler:) tags:@[@(1001)]];
    
    [self initViews];
    [self initConstraints];
    
    self.headView.info = self.info;
//    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    AddCoreClient(GuildCoreClient, self);
    [GetCore(GuildCore) requestGuildhallManagerAuthsListByUid:GetCore(AuthCore).getUid managerUid:[NSString stringWithFormat:@"%lld", self.info.uid]];
    [[GetCore(UserCore) getUserInfoByRac:[GetCore(AuthCore).getUid longLongValue] refresh:YES] subscribeNext:^(id x) {
        self.hallUserInfo = x;
    }];
}

- (void)onLeftBackItemClickHandler:(UIButton *)btn {
    
    if (!self.selectedArray.count) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    @weakify(self);
    [TTPopup alertWithMessage:@"您有设置未保存，确定直接返回吗？" confirmHandler:^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    } cancelHandler:^{
    }];
}

/** 右侧保存按钮 */
- (void)onRightEnterItemClickHandler:(UIButton *)btn {
    
    [XCHUDTool showGIFLoadingInView:self.view];
    // 确定
    NSString *managerUid = [NSString stringWithFormat:@"%lld", self.info.uid];
    NSString *hallId = [NSString stringWithFormat:@"%lld", self.hallUserInfo.hallId];
    NSString *authStr = [self.authStrArray componentsJoinedByString:@","];
    [GetCore(GuildCore) requestGuildsetHallManagerAuthsWithUid:GetCore(AuthCore).getUid managerUid:managerUid hallId:hallId authStr:authStr];
}

#pragma mark -
#pragma mark lifeCycle
- (void)initViews {
    [self.view addSubview:self.tableView];
}

- (void)initConstraints {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(kNavigationHeight);
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
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
    TTKeeperManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:kKeeperManagerConst];
    if (!cell) {
        cell = [[TTKeeperManagerCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kKeeperManagerConst];
    }
    cell.delegate = self;
    if (self.dataArray.count > indexPath.row) {
        cell.managerInfo = self.dataArray[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark Cell Delegate
- (void)onSwClickHandler:(UISwitch *)sw authStr:(NSString *)authStr{
    // 开关权限
    if (sw.on) {
        // 开着
        if (![self.authStrArray containsObject:authStr]) {
            [self.authStrArray addObject:authStr];
        }
    } else {
        if (self.authStrArray.count > 0) {
            if ([self.authStrArray containsObject:authStr]) {
                [self.authStrArray removeObject:authStr];
            }
        }
    }
    //
    self.selectedArray = self.authStrArray;
}

#pragma mark -
#pragma mark clients
// 获取权限列表
- (void)responseGuildHallManagerInfoList:(NSArray *)list errorCode:(NSNumber *)code msg:(NSString *)msg {
    self.dataArray = [NSMutableArray arrayWithArray:list];
    [self.dataArray enumerateObjectsUsingBlock:^(GuildHallManagerInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.status == 1) {
            [self.authStrArray addObject:obj.code];
        }
    }];
    [self.tableView reloadData];
}

// 设置权限列表
- (void)responseGuildHallSetManagerAuthSuccess:(BOOL)isSuccess errorCode:(NSNumber *)code msg:(NSString *)msg {
    [XCHUDTool hideHUDInView:self.view];
    if (isSuccess) {
        [XCHUDTool showSuccessWithMessage:@"操作成功" inView:self.view];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        // 如果失败了。要将已经变更的 Switch 开关刷新回原来的样式
        [self.tableView reloadData];
    }
}

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
        _tableView.tableFooterView = [UIView new];
        _tableView.tableHeaderView = self.headView;
    }
    return _tableView;
}

- (TTGuildUserInfoView *)headView {
    if (!_headView) {
        _headView = [[TTGuildUserInfoView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 70)];
    }
    return _headView;
}

- (NSMutableArray<GuildHallManagerInfo *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray<NSString *> *)authStrArray {
    if (!_authStrArray) {
        _authStrArray = [NSMutableArray array];
    }
    return _authStrArray;
}
- (NSMutableArray<NSString *> *)selectedArray {
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
}
@end
