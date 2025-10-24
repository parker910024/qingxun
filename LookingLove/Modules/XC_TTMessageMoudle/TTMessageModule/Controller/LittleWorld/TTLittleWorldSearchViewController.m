//
//  TTLittleWorldSearchViewController.m
//  XC_TTMessageMoudle
//
//  Created by fengshuo on 2019/7/5.
//  Copyright © 2019 WJHD. All rights reserved.
//

#import "TTLittleWorldSearchViewController.h"

//view
#import "TTPublicAtSearchCancelBar.h"
#import "TTLittleWorldMemberTableViewCell.h"
//core
#import "LittleWorldCore.h"
#import "LittleWorldCoreClient.h"
//第三方类
#import <Masonry/Masonry.h>
//XC_类
#import "XCTheme.h"
#import "NSArray+Safe.h"
#import "UIViewController+EmptyDataView.h"
#import "XCHUDTool.h"

@interface TTLittleWorldSearchViewController ()
<
   UITableViewDelegate,
   UITableViewDataSource,
   LittleWorldCoreClient,
   TTPublicAtSearchCancelBarDelegate,
   TTLittleWorldMemberTableViewCellDelegate
>
/**
 搜索框
 */
@property (strong, nonatomic) TTPublicAtSearchCancelBar *searhBar;

@property (strong, nonatomic) NSArray<LittleWolrdMember *> *results;

@property (strong, nonatomic) UITableView *tableView;
@end

@implementation TTLittleWorldSearchViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initConstrations];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.searhBar.searchField becomeFirstResponder];
}

#pragma mark - private method
- (void)initView {
    self.title = @"成员列表";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.searhBar];
    AddCoreClient(LittleWorldCoreClient, self);
    [self.tableView registerClass:[TTLittleWorldMemberTableViewCell class] forCellReuseIdentifier:NSStringFromClass([TTLittleWorldMemberTableViewCell class])];
}

- (void)initConstrations {
    [self.searhBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view.mas_leading);
        make.trailing.mas_equalTo(self.view.mas_trailing);
        make.top.mas_equalTo(self.mas_topLayoutGuideBottom);
        make.height.mas_equalTo(40);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view.mas_leading);
        make.trailing.mas_equalTo(self.view.mas_trailing);
        make.top.mas_equalTo(self.searhBar.mas_bottom);
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuideTop);
    }];
}

- (void)dealloc {
    RemoveCoreClientAll(self);
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LittleWolrdMember *info = [self.results safeObjectAtIndex:indexPath.row];
    if ([self.delegate respondsToSelector:@selector(onsearchVC:littleWorldSerachMember:isDelete:)]) {
        [self.delegate onsearchVC:self littleWorldSerachMember:info isDelete:NO];
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 72;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TTLittleWorldMemberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TTLittleWorldMemberTableViewCell class]) forIndexPath:indexPath];
    cell.type = self.type;
    cell.member = [self.results safeObjectAtIndex:indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - TTLittleWorldMemberTableViewCellDelegate
- (void)ttLittleWorldMemberTableViewCell:(TTLittleWorldMemberTableViewCell *)cell ownerRemoveMember:(LittleWolrdMember *)member {
    if ([self.delegate respondsToSelector:@selector(onsearchVC:littleWorldSerachMember:isDelete:)]) {
        [self.delegate onsearchVC:self littleWorldSerachMember:member isDelete:YES];
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - TTPublicAtSearchCancelBarDelegate

- (void)onSearchCancelBar:(TTPublicAtSearchCancelBar *)searchBar searhWithKey:(NSString *)key {
    if (key.length > 0) {
        [GetCore(LittleWorldCore) requestLittleWorldMemberListWithWorldId:self.worldId searchKey:key isSearch:YES page:1 status:0];
    }
}

- (void)onSearchCancelDidClickBar:(TTPublicAtSearchCancelBar *)searchBar {
    [self.searhBar.searchField resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - LittleWorldCoreClient
- (void)requestLittleWorldMemberListSuccess:(LittleWorldMemberModel *)members isSearch:(BOOL)isSearch status:(int)stauts {
    if (isSearch) {
        self.results = members.records;
        [self.searhBar.searchField resignFirstResponder];
        if (self.results.count == 0) {
            [self showEmptyDataViewWithTitle:@"没有搜到相关信息" image:[UIImage imageNamed:@"common_noData_empty"] needInteractionEnabled:NO];
        }else {
            [self removeEmptyDataView];
        }
        [self.tableView reloadData];
    }
}

- (void)requestLittleWorldMemberListFail:(NSString *)message status:(int)stauts {
    [XCHUDTool showErrorWithMessage:message inView:self.view];
}

#pragma mark - setter & getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorColor = UIColorFromRGB(0xf0f0f0);
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    }
    return _tableView;
}

- (TTPublicAtSearchCancelBar *)searhBar {
    if (!_searhBar) {
        _searhBar = [[TTPublicAtSearchCancelBar alloc]init];
        _searhBar.delegate = self;
    }
    return _searhBar;
}
@end
