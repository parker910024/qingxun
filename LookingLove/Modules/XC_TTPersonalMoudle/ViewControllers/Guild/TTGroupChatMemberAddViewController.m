//
//  TTGroupChatMemberAddViewController.m
//  TTPlay
//
//  Created by lee on 2019/1/26.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTGroupChatMemberAddViewController.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"
#import "XCHUDTool.h"
#import "UIView+XCToast.h"

//vc
#import "TTKeeperListViewController.h"
#import "TTFamilySearchViewController.h"
#import "TTMineContainViewController.h"
#import "TTGroupChatMemberAddViewController.h"
// view
#import "TTMemberListCell.h"
#import "TTGuildMemberHeaderSectionView.h"

#import "TTItemMenuView.h"
#import "TTItemsMenuConfig.h"
#import "GuildHallGroupInfo.h"

// core
#import "GuildCore.h"
#import "GuildCoreClient.h"
#import "AuthCore.h"
#import "AuthCoreClient.h"
#import "UserCore.h"
#import "UserCoreClient.h"
#import "UserInfo.h"

@interface TTGroupChatMemberAddViewController ()<GuildCoreClient, TTMemberListCellDelegate>

/** 数据展示类型 */
@property (nonatomic, assign) GuildHallListType listType;

/** 是否是群聊添加成员 */
@property (nonatomic, assign) BOOL isGroupAdd;

/** 数据源 */
@property (nonatomic, strong) NSMutableArray *dataArray;
/** 头部view */
@property (nonatomic, strong) TTGuildMemberHeaderSectionView *sectionHeadView;
/** 当前的 index */
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
/** 被选中的用户 */
@property (nonatomic, strong) NSMutableArray<UserInfo *> *selectingUserArray;
/** 当前用户信息 */
@property (nonatomic, strong) UserInfo *currentInfo;
/** 授权数据 */
@property (nonatomic, strong) NSArray<GuildHallManagerInfo *> *authArray;
/** 是否是群聊 */
@property (nonatomic, assign) BOOL isGroupChat;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) GuildChatGroupAllMemberResponse *chatGroupAllMemberResponse;
@end

@implementation TTGroupChatMemberAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self requestAllMemberList];
    AddCoreClient(GuildCoreClient, self);
    [GetCore(GuildCore) requestGuildMemberListWhichNotInGroupWithChatId:self.chatID page:1 pageSize:100];
    
    self.navigationItem.title = @"选择群成员";
    [self addNavigationItemWithTitles:@[@"确定"] titleColor:[XCTheme getTTMainColor] isLeft:NO target:self action:@selector(onRightItemClickHandler:) tags:@[@1003]];
    
    [self initViews];
    [self initConstraints];
}

- (void)onRightItemClickHandler:(UIButton *)btn {
    // 确定
    if (self.selectingUserArray.count <= 0) {
        [XCHUDTool showErrorWithMessage:@"请至少选择一位" inView:self.view];
        return;
    }
    NSMutableArray *mutabArray = [NSMutableArray array];
    [self.selectingUserArray enumerateObjectsUsingBlock:^(UserInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [mutabArray addObject:[NSString stringWithFormat:@"%lld", obj.uid]];
    }];
    NSString *str = [mutabArray componentsJoinedByString:@","];
    [XCHUDTool showGIFLoadingInView:self.view];
    [GetCore(GuildCore) requestGuildGroupAddMembersWithChatId:self.chatID targetUids:str];
}

- (void)dealloc {
    RemoveCoreClientAll(self);
}

- (void)initViews {
    //    [self.view addSubview:self.tableView];
    self.tableView.rowHeight = 66.f;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:[TTMemberListCell class] forCellReuseIdentifier:kMemberListCellConst];
}

- (void)initConstraints {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top).offset(kNavigationHeight);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
}

/** 群聊全部人员 */
- (void)responseGuildGroupAllMembers:(NSArray<UserInfo *> *)list data:(GuildChatGroupAllMemberResponse *)data errorCode:(NSNumber *)code msg:(NSString *)msg {
    [self endTableViewRefresh];
    
    self.chatGroupAllMemberResponse = data;
    if (self.page == 1) {
        self.dataArray = [NSMutableArray arrayWithArray:list];
        if (self.dataArray.count == 0) {
            [self.tableView showEmptyContentToastWithTitle:@"暂时没有数据哦~" andImage:[UIImage imageNamed:@"common_noData_empty"]];
        } else {
            [self.tableView hideToastView];
        }
    } else if (self.page > 1) {
        [self.dataArray addObjectsFromArray:list];
        if (list.count == 0) {
            self.page -= 1;
        }
    }
    [UIView performWithoutAnimation:^{
        [self.tableView reloadData];
    }];
}

/** 获取全部成员 */
- (void)responseGuildHallAllMembersList:(NSArray *)list
                                  count:(NSString *)count
                              errorCode:(NSNumber *)code
                                    msg:(NSString *)msg {
    [self endTableViewRefresh];
    self.sectionHeadView.countLabel.text = [NSString stringWithFormat:@"总人数%@人", count];
    if (self.page == 1) {
        self.dataArray = [NSMutableArray arrayWithArray:list];
        if (self.dataArray.count == 0) {
            [self.tableView showEmptyContentToastWithTitle:@"暂时没有数据哦~" andImage:[UIImage imageNamed:@"common_noData_empty"]];
        } else {
            [self.tableView hideToastView];
        }
    } else if (self.page > 1) {
        [self.dataArray addObjectsFromArray:list];
        if (list.count == 0) {
            self.page -= 1;
        }
    }
    self.sectionHeadView.countLabel.text = [NSString stringWithFormat:@"总人数：%@人", count];
    [UIView performWithoutAnimation:^{
        [self.tableView reloadData];
    }];
}

/** 获取指定不在群里的成员 */
- (void)responseGuildNotInGroupMembers:(NSArray<UserInfo *> *)data errorCode:(NSNumber *)code msg:(NSString *)msg {
    NSArray *array = data;
    [self endTableViewRefresh];
    self.dataArray = [NSMutableArray arrayWithArray:array];
    //    self.sectionHeadView.countLabel.text = [NSString stringWithFormat:@"总人数%ld人", (long)self.dataArray.count];
    [self.tableView reloadData];
}

- (void)responseGuildGroupAddMembers:(BOOL)isSuccess errorCode:(NSNumber *)code msg:(NSString *)msg {
    [XCHUDTool hideHUDInView:self.view];
    if (isSuccess) {
        @weakify(self);
        [UIView animateWithDuration:2.0 animations:^{
            @strongify(self);
            !self.refreshHander ? : self.refreshHander();
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
    }
}


- (void)endTableViewRefresh {
    [self.tableView endRefreshStatus:0];
    [self.tableView endRefreshStatus:1 totalPage:self.page];
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
    cell.currentManagerRoleType = self.hallInfo.roleType;
    cell.isMutable = YES;
    cell.delegate = self;
    cell.tag = indexPath.row;
    if (self.dataArray.count > indexPath.row) {
        cell.userInfo = self.dataArray[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.listType != GuildHallListTypeGroupNormal && self.listType != GuildHallListTypeMember) {
        return;
    }
    TTMineContainViewController *vc = [[TTMineContainViewController alloc] init];
    vc.mineInfoStyle = TTMineInfoViewStyleOhter;
    UserInfo *info = [self.dataArray safeObjectAtIndex:indexPath.row];
    vc.userID = info.uid;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    self.sectionHeadView.countLabel.text = @"";
    return self.sectionHeadView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (TTGuildMemberHeaderSectionView *)sectionHeadView {
    if (!_sectionHeadView) {
        _sectionHeadView = [[TTGuildMemberHeaderSectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
    }
    return _sectionHeadView;
}

- (NSMutableArray<UserInfo *> *)selectingUserArray {
    if (!_selectingUserArray) {
        _selectingUserArray = [NSMutableArray array];
    }
    return _selectingUserArray;
}

- (NSArray<GuildHallManagerInfo *> *)authArray {
    if (!_authArray) {
        _authArray = @[];
    }
    return _authArray;
}
- (void)onCellSelectedClickHandler:(nonnull UIButton *)btn info:(nonnull UserInfo *)info {
    btn.selected = !btn.selected;
        
    if (btn.selected) {
        if (![self.selectingUserArray containsObject:info]) {
            [self.selectingUserArray addObject:info];
        }
    } else {
        if ([self.selectingUserArray containsObject:info]) {
            [self.selectingUserArray removeObject:info];
        }
    }
    self.sectionHeadView.countLabel.text = [NSString stringWithFormat:@"已选择人数:%@人", @(self.selectingUserArray.count).stringValue];
    NSString *uidsStr = [self.selectingUserArray componentsJoinedByString:@","];
    return;

}

@end
