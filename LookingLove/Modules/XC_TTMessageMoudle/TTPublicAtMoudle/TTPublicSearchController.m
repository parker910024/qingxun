//
//  TTPublicSearchController.m
//  TuTu
//
//  Created by 卫明 on 2018/11/7.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTPublicSearchController.h"

//view
#import "TTPublicAtSearchCancelBar.h"

//core
#import "PublicChatroomCore.h"
//client
#import "PublicChatroomCoreClient.h"

//model
#import "SearchResultInfo.h"

//cell
#import "TTFriendTableViewCell.h"

//tool
#import "XCTheme.h"
#import <Masonry/Masonry.h>
#import "NSArray+Safe.h"
#import "UIViewController+EmptyDataView.h"

@interface TTPublicSearchController ()
<
    TTPublicAtSearchCancelBarDelegate,
    PublicChatroomCoreClient,
    UITableViewDelegate,
    UITableViewDataSource
>
/**
 搜索框
 */
@property (strong, nonatomic) TTPublicAtSearchCancelBar *searhBar;

@property (strong, nonatomic) NSArray *results;

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation TTPublicSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initConstrations];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.searhBar.searchField becomeFirstResponder];
}

#pragma mark - PublicChatroomCoreClient

- (void)searchAtFriendNoticeFansSuccess:(NSArray *)searchInfo {
    self.results = [NSArray arrayWithArray:searchInfo];
    [self.searhBar.searchField resignFirstResponder];
    if (self.results.count == 0) {
        [self showEmptyDataViewWithTitle:@"没有搜到相关信息" image:[UIImage imageNamed:@"common_noData_empty"] needInteractionEnabled:NO];
    }else {
        [self removeEmptyDataView];
    }
    [self.tableView reloadData];
}

#pragma mark - TTPublicAtSearchCancelBarDelegate

- (void)onSearchCancelBar:(TTPublicAtSearchCancelBar *)searchBar searhWithKey:(NSString *)key {
    if (key.length > 0) {
        [GetCore(PublicChatroomCore)searchAtFriendNoticeFans:key];
    }
}

- (void)onSearchCancelDidClickBar:(TTPublicAtSearchCancelBar *)searchBar {
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchResultInfo *info = [self.results safeObjectAtIndex:indexPath.row];
    UserInfo *userInfo = [UserInfo modelDictionary:[info model2dictionary]];
    if ([self.delegate respondsToSelector:@selector(onSearchVC:didSelectedUserInfo:)]) {
        [self.delegate onSearchVC:self didSelectedUserInfo:userInfo];
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TTFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TTFriendTableViewCell" forIndexPath:indexPath];
    [cell setCellType:TTFriendTableViewCell_Hidden];
    SearchResultInfo *info = (SearchResultInfo *)[self.results safeObjectAtIndex:indexPath.row];
    UserInfo *userInfo = [UserInfo modelDictionary:[info model2dictionary]];
    [cell configTTFriendTableViewCell:userInfo];
    return cell;
}

#pragma mark - TTFriendTableViewCellDelegate

#pragma mark - private

- (void)initView {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.searhBar];
    AddCoreClient(PublicChatroomCoreClient, self);
    [self.tableView registerClass:[TTFriendTableViewCell class] forCellReuseIdentifier:@"TTFriendTableViewCell"];
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
