//
//  TTBlackListViewController.m
//  TuTu
//
//  Created by zoey on 2018/11/22.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTBlackListViewController.h"
//View
#import "TTBlackListCell.h"
//t
#import "XCTheme.h"
#import "XCMacros.h"
#import <Masonry/Masonry.h>
//core
#import "ImFriendCore.h"
#import "ImFriendCoreClient.h"
//m
#import "UserInfo.h"
//cate
#import "NSArray+Safe.h"
#import "UIViewController+EmptyDataView.h"

@interface TTBlackListViewController ()<ImFriendCoreClient>
@property (strong , nonatomic) NSArray<UserInfo *> *blackList;
@end

@implementation TTBlackListViewController

- (void)dealloc {
    RemoveCoreClient(ImFriendCoreClient, self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"黑名单管理";
    self.tableView.rowHeight = 65;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:[TTBlackListCell class] forCellReuseIdentifier:@"TTBlackListCell"];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuide);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
    AddCoreClient(ImFriendCoreClient, self);
    [self updateBlackListData];
}


#pragma mark - TableViewDelegate && DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.blackList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TTBlackListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TTBlackListCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[TTBlackListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TTBlackListCell"];
    }
    cell.info = [self.blackList safeObjectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"移除";
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle ==UITableViewCellEditingStyleDelete){
        UserInfo *userInfo = [self.blackList safeObjectAtIndex:indexPath.row];
        [GetCore(ImFriendCore) removeFromBlackList:[NSString stringWithFormat:@"%lld",userInfo.uid]];
    }
}
#pragma mark - ImFriendCoreClient
- (void)onAddToBlackListSuccess{
    [self updateBlackListData];
}
- (void)onAddToBlackListFailth{
    [self updateBlackListData];
}
- (void)onRemoveFromBlackListSuccess{
    [self updateBlackListData];
}
- (void)onRemoveFromBlackListFailth{
    [self updateBlackListData];
}
- (void)onBlackListChanged{
    [self updateBlackListData];
}

#pragma mark - private
- (void)updateBlackListData {
    self.blackList = [GetCore(ImFriendCore) getBlackList];
    if (self.blackList.count == 0) {
        [self showEmptyDataViewWithTitle:@"你的黑名单为空噢" image:[UIImage imageNamed:@"common_noData_empty"]];
    }else{
        [self removeEmptyDataView];
    }
    [self.tableView reloadData];
}


@end
