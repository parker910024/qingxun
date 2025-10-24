//
//  TTLittleWorldMemberViewController.m
//  XC_TTMessageMoudle
//
//  Created by fengshuo on 2019/6/28.
//  Copyright © 2019 WJHD. All rights reserved.
//

#import "TTLittleWorldMemberViewController.h"
//vc
#import "TTLittleWorldSearchViewController.h"
//view
#import "TTLittleWorldMemberTableViewCell.h"
#import "TTLittleWorldSearchView.h"
#import "TTMessageEmptyDataView.h"
#import "UIViewController+EmptyDataView.h"
//XC_tt类
#import "XCMediator+TTRoomMoudleBridge.h"
#import "XCMediator+TTPersonalMoudleBridge.h"

//XC_类
#import "XCMacros.h"
#import "XCHUDTool.h"
#import "NSArray+Safe.h"
#import "TTPopup.h"
#import "TTStatisticsService.h"

//core
#import "LittleWorldCore.h"
#import "LittleWorldCoreClient.h"
//第三方类
#import <Masonry/Masonry.h>


@interface TTLittleWorldMemberViewController ()
<
    UITableViewDelegate,
    UITableViewDataSource,
    LittleWorldCoreClient,
    TTLittleWorldSearchViewDelegate,
    TTLittleWorldSearchViewControllerDelegate,
    TTLittleWorldMemberTableViewCellDelegate
>
/** 数据源*/
@property (nonatomic,strong) NSMutableArray<LittleWolrdMember *> *datasource;
/** 包含成员以及总人数*/
@property (nonatomic,strong) LittleWorldMemberModel *memberModel;
/** 头部的视图*/
@property (nonatomic,strong) TTLittleWorldSearchView *headView;
/** 空视图*/
@property (nonatomic,strong) TTMessageEmptyDataView *emptyDataView;
/** 当前的页数*/
@property (nonatomic,assign) int page;
@end

@implementation TTLittleWorldMemberViewController
- (void)dealloc {
    RemoveCoreClientAll(self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addCore];
    [self initView];
    [self initConstrations];
}


#pragma mark - public methods
#pragma mark - delegate

#pragma mark - UITableViewDelegate and UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    tableView.backgroundView = self.datasource.count ? nil : self.emptyDataView;
    return self.datasource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 72;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TTLittleWorldMemberTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TTLittleWorldMemberTableViewCell class])];
    if (cell == nil) {
        cell = [[TTLittleWorldMemberTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([TTLittleWorldMemberTableViewCell class])];
    }
    cell.delegate = self;
     cell.type = self.type;
    cell.member = [self.datasource safeObjectAtIndex:indexPath.row];
   
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LittleWolrdMember * member = [self.datasource safeObjectAtIndex:indexPath.row];
    if (member.currentRoomUid > 0) {
        [[XCMediator sharedInstance] ttRoomMoudle_presentRoomViewControllerWithRoomUid:member.currentRoomUid];
    }else {
        UIViewController * vc =  [[XCMediator sharedInstance] ttPersonalModule_personalViewController:member.uid];
        [self.navigationController pushViewController:vc animated:YES];
    }
   
}

#pragma mark - TTLittleWorldSearchViewDelegate
- (void)tapTTLittleWorldSearchView:(TTLittleWorldSearchView *)searchView {
    TTLittleWorldSearchViewController * vc =  [[TTLittleWorldSearchViewController alloc] init];
    vc.worldId = self.worldId;
    vc.delegate = self;
    vc.type = self.type;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - TTLittleWorldSearchViewControllerDelegate
- (void)onsearchVC:(TTLittleWorldSearchViewController *)vc littleWorldSerachMember:(LittleWolrdMember *)meber isDelete:(BOOL)isDelete {
    if (isDelete) {
        [self handleLittleWorldCreateDeleteMember:meber];
    }else {
        [self handleLittleWorldMemberClickWith:meber];
    }
}

#pragma mark - TTLittleWorldMemberTableViewCellDelegate
- (void)ttLittleWorldMemberTableViewCell:(TTLittleWorldMemberTableViewCell *)cell ownerRemoveMember:(LittleWolrdMember *)member {
    [TTStatisticsService trackEvent:@"world-page-remove-members" eventDescribe:@"世界客态页-查看成员列表--移除"];
    [self handleLittleWorldCreateDeleteMember:member];
}

#pragma mark - LittleWorldCoreClient
- (void)requestLittleWorldMemberListFail:(NSString *)message status:(int)stauts {
    [self failEndRefreshStatus:stauts];
    [XCHUDTool showErrorWithMessage:message inView:self.view];

}

- (void)requestLittleWorldMemberListSuccess:(LittleWorldMemberModel *)members isSearch:(BOOL)isSearch status:(int)stauts {
    if (isSearch) {
        return;
    }
    if (self.page== 1) {
        self.datasource = [members.records mutableCopy];
    }else {
       [self.datasource addObjectsFromArray:members.records];
    }
    if (members.records.count > 0) {
        [self successEndRefreshStatus:stauts hasMoreData:YES];
        self.title = [NSString stringWithFormat:@"成员列表(%@)", members.total];
    }else {
        [self successEndRefreshStatus:stauts hasMoreData:NO];
    }
    self.memberModel = members;
    [self.tableView reloadData];
}

//移除
- (void)removeLittleWorldMemberSuccess:(UserID)removerId {
    @KWeakify(self);
    [self.datasource enumerateObjectsUsingBlock:^(LittleWolrdMember * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @KStrongify(self);
        if (obj.uid == removerId) {
            [self.datasource removeObject:obj];
            *stop = YES;
            [self.tableView reloadData];
            self.title = [NSString stringWithFormat:@"成员列表(%ld)", (self.memberModel.total.integerValue - 1)];
        }
    }];
}

- (void)removeLittleWorldMemberFail:(NSString *)message {
    [XCHUDTool showErrorWithMessage:message inView:self.view];
}

#pragma mark - event response

#pragma mark - http
- (void)pullDownRefresh:(int)page {
    self.page = page;
    [GetCore(LittleWorldCore) requestLittleWorldMemberListWithWorldId:self.worldId searchKey:nil isSearch:NO page:self.page status:0];
}

- (void)pullUpRefresh:(int)page lastPage:(BOOL)isLastPage {
    if (isLastPage) {
        return;
    }
    self.page = page;
    [GetCore(LittleWorldCore) requestLittleWorldMemberListWithWorldId:self.worldId searchKey:nil isSearch:NO page:self.page status:1];
}

#pragma mark - private method
- (void)addCore {
    AddCoreClient(LittleWorldCoreClient, self);
}

- (void)initView {
    self.title = @"成员列表";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[TTLittleWorldMemberTableViewCell class] forCellReuseIdentifier:NSStringFromClass([TTLittleWorldMemberTableViewCell class])];
    self.tableView.tableHeaderView = self.headView;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableViewHeightOnScreen = 1;
    [self setupRefreshTarget:self.tableView];
    [self pullDownRefresh:1];
}
- (void)initConstrations {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(statusbarHeight + 44);
    }];
}

- (void)handleLittleWorldCreateDeleteMember:(LittleWolrdMember *)member {
    [TTPopup alertWithMessage:@"移除后该成员将退出小世界 \n 确认移除吗?" confirmHandler:^{
        [GetCore(LittleWorldCore) removeLittleWorldMemberWithWorldId:self.worldId removerUid:member.uid];
    } cancelHandler:^{
        
    }];
    

}

//处理点击成员个人的
- (void)handleLittleWorldMemberClickWith:(LittleWolrdMember *)member {
    if (member.currentRoomUid > 0) {
        [[XCMediator sharedInstance] ttRoomMoudle_presentRoomViewControllerWithRoomUid:member.currentRoomUid];
    }else {
        UIViewController * controller = [[XCMediator sharedInstance] ttPersonalModule_personalViewController:member.uid];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark - getters and setters
- (NSMutableArray<LittleWolrdMember *> *)datasource {
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}

- (TTLittleWorldSearchView *)headView {
    if (!_headView) {
        _headView = [[TTLittleWorldSearchView alloc] init];
        _headView.frame = CGRectMake(0, 0, KScreenWidth, 36);
        _headView.delegate = self;
    }
    return _headView;
}


@end
