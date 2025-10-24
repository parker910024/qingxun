//
//  TTFamilySearchViewController.m
//  TuTu
//
//  Created by gzlx on 2018/11/7.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTFamilySearchViewController.h"
//view
#import "TTFamilySearchView.h"
#import "TTFamilyMemberTableViewCell.h"
// core
#import "SearchCore.h"
#import "SearchCoreClient.h"
#import "AuthCore.h"
#import "GroupCore.h"
#import "GroupCoreClient.h"
#import "FamilyCoreClient.h"
// m
#import <Masonry/Masonry.h>
#import "XCMacros.h"
#import "XCHUDTool.h"
#import "UIView+XCToast.h"
#import "NSArray+Safe.h"
#import "NSBundle+Source.h"
#import "XCTheme.h"
//vc
#import "TTFamilyPersonViewController.h"
#import "XCMediator+TTPersonalMoudleBridge.h"

@interface TTFamilySearchViewController ()<TTFamilySearchViewDelegate, TTFamilyMemberTableViewCellDelegate,FamilyCoreClient, GroupCoreClient, SearchCoreClient>
@property (copy, nonatomic) NSArray<SearchResultInfo *> *resultList;
@property (nonatomic, strong) NSMutableArray<XCFamily *> * datasource;//家族
@property (nonatomic, strong) NSMutableArray<GroupMemberModel *>* groupMembers;//群成员列表
@property (nonatomic, strong) NSMutableArray<XCFamilyModel *> * familyMembers;//家族成员
/** 搜索*/
@property (nonatomic, strong) TTFamilySearchView * searchView;
@end

@implementation TTFamilySearchViewController
- (BOOL)isHiddenNavBar{
    return YES;
}

- (void)dealloc{
    RemoveCoreClientAll(self);
}
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addCore];
    [self initView];
    [self initContrations];
}
#pragma mark - private method
- (void)initView{
    [self.view addSubview:self.searchView];
     self.tableView.rowHeight = 75;
    [self.tableView registerClass:[TTFamilyMemberTableViewCell class] forCellReuseIdentifier:@"TTFamilyMemberTableViewCell"];
    self.tableView.tableFooterView = [UIView new];
    if (self.searchType == TTFamilySearchType_Family) {
        self.searchView.textFiled.placeholder = @"搜索家族ID/名称";
    }
}

- (void)addCore{
    AddCoreClient(FamilyCoreClient, self);
    AddCoreClient(GroupCoreClient, self);
    AddCoreClient(SearchCoreClient, self);
}

- (void)initContrations{
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view);
        make.height.mas_equalTo(44 + statusbarHeight);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(44+ statusbarHeight);
    }];
}

#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchType == TTFamilySearchType_Family ) {
        return self.datasource.count;
    }else if (self.searchType == TTFamilySearchType_Family_Member){
        return self.familyMembers.count;
    }else if (self.searchType == TTFamilySearchType_Group){
        return self.groupMembers.count;
    }
    return self.resultList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TTFamilyMemberTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TTFamilyMemberTableViewCell"];
    if (cell == nil) {
        cell = [[TTFamilyMemberTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TTFamilyMemberTableViewCell"];
    }
    if (self.searchType == TTFamilySearchType_Family) {
        [cell configSearchFamilyWith:[self.datasource safeObjectAtIndex:indexPath.row]];
    }else if (self.searchType == TTFamilySearchType_Family_Member){
        [cell configFamilyMemberWith:[self.familyMembers safeObjectAtIndex:indexPath.row]];
        cell.listType = self.listType;
        cell.delegate = self;
        cell.selectMemberDic = self.selectMemDic;
    }else if (self.searchType == TTFamilySearchType_Group){
        [cell configGroupMemberWith:[self.groupMembers safeObjectAtIndex:indexPath.row]];
        cell.listType = self.listType;
        cell.delegate = self;
    }else{
        [cell configSearchShareCellWith:[self.resultList safeObjectAtIndex:indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.searchType == TTFamilySearchType_Family) {
        if (self.datasource.count >0) {
             XCFamily * family = [self.datasource safeObjectAtIndex:indexPath.row];
            TTFamilyPersonViewController * personVc = [[TTFamilyPersonViewController alloc] init];
            personVc.familyId = family.familyId;
            @weakify(self);
            [self dismissViewControllerAnimated:YES completion:^{
                @strongify(self);
                [self.currentNav pushViewController:personVc animated:YES];
            }];
        }
    }else if (self.searchType == TTFamilySearchType_Share) {
        if (self.resultList.count > 0) {
            @weakify(self);
            [self dismissViewControllerAnimated:YES completion:^{
                @strongify(self);
                SearchResultInfo *info = [self.resultList safeObjectAtIndex:indexPath.row];
                if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectCellWith:)]) {
                    [self.delegate didSelectCellWith:info];
                }
            }];
        }
        return ;
    }else if (self.searchType == TTFamilySearchType_Family_Member) {
        if (self.listType == FamilyMemberListMoneyTransfer) {
            @weakify(self);
            [self dismissViewControllerAnimated:YES completion:^{
                @strongify(self);
                if (self.familyMembers.count >0) {
                    XCFamilyModel * model = [self.familyMembers safeObjectAtIndex:indexPath.row];
                    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectFamilyMemberWith:selectDic:)]) {
                        [self.delegate didSelectFamilyMemberWith:model selectDic:self.selectMemDic];
                    }
                }
            }];
            return;
        }else if (self.listType == FamilyMemberListCheck){
            if (self.familyMembers.count > 0) {
                XCFamilyModel * infor = [self.familyMembers safeObjectAtIndex:indexPath.row];
                UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_personalViewController:infor.uid.userIDValue];
                @weakify(self);
                [self dismissViewControllerAnimated:YES completion:^{
                    @strongify(self);
                    [self.currentNav pushViewController:vc animated:YES];
                }];
            }
            return;
        }else if (self.listType == FamilyMemberListFamilyRemove || self.listType == FamilyMemberAddGroup || self.listType == FamilyMemberListCreateGroup){
            return;
        }
        
    }else if (self.searchType == TTFamilySearchType_Group){
        if (self.listType == FamilyMemberListGroupBanned || self.listType ==FamilyMemberListGroupManager) {
            return;
        }
        if (self.groupMembers.count > 0) {
            @weakify(self);
            [self dismissViewControllerAnimated:YES completion:^{
                @strongify(self);
                GroupMemberModel * infor = [self.groupMembers safeObjectAtIndex:indexPath.row];
                if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectGroupMemberWith:selectDic:)]) {
                    [self.delegate didSelectGroupMemberWith:infor selectDic:self.selectMemDic];
                }
            }];
        }
        return;
    }
    
    SearchResultInfo *info = [self.resultList safeObjectAtIndex:indexPath.row];
    UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_personalViewController:info.uid];
    @weakify(self);
    [self dismissViewControllerAnimated:YES completion:^{
        @strongify(self);
        [self.currentNav pushViewController:vc animated:YES];
    }];
}

#pragma mark- TTFamilyMemberTableViewCellDelegate
- (void)handleFamilyMemberTableViewWith:(XCFamilyModel *)familyModel groupModel:(GroupMemberModel *)groupModel listType:(FamilyMemberListType)listType typeButton:(UIButton *)sender{
    if (self.searchType == TTFamilySearchType_Family_Member) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectFamilyMemberWith:selectDic:)]) {
            @weakify(self);
            [self dismissViewControllerAnimated:YES completion:^{
                @strongify(self);
                [self.delegate didSelectFamilyMemberWith:familyModel selectDic:self.selectMemDic];
            }];
        }
    }else if (self.searchType == TTFamilySearchType_Group){
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectGroupMemberWith:selectDic:)]) {
            @weakify(self);
            [self dismissViewControllerAnimated:YES completion:^{
                @strongify(self);
                [self.delegate didSelectGroupMemberWith:groupModel selectDic:self.selectMemDic];
            }];
        }
    }

}

#pragma mark - GroupCoreClient
- (void)searchMembersInGroupSuccess:(NSArray<GroupMemberModel *> *)groupMembers page:(NSInteger)page pageSize:(NSInteger)pageSize{
    [XCHUDTool hideHUDInView:self.view];
    if (groupMembers.count == 0) {
        [self.groupMembers removeAllObjects];
        [self.tableView showEmptyContentToastWithTitle:@"暂无数据" andImage:[UIImage imageNamed:[[XCTheme defaultTheme] default_empty]]];
        [self.tableView reloadData];
    }else {
        self.groupMembers = [groupMembers mutableCopy];
        [self.tableView hideToastView];
        [self.tableView reloadData];
    }
    
}

- (void)searchMembersInGroupFailth:(NSString *)message page:(NSInteger)page pageSize:(NSInteger)pageSize{
    [XCHUDTool hideHUDInView:self.view];
}
#pragma mark - FamilyCoreClient
//家族列表
- (void)searchFamilyListSuccess:(NSArray<XCFamily *> *)familyList{
    [XCHUDTool hideHUDInView:self.view];
    [self.tableView hideToastView];
    if (familyList.count == 0) {
        [self.datasource removeAllObjects];
        [self.tableView showEmptyContentToastWithTitle:@"暂无数据" andImage:[UIImage imageNamed:[[XCTheme defaultTheme] default_empty]]];
        [self.tableView reloadData];
    }else {
        self.datasource = [familyList mutableCopy];
        [self.tableView hideToastView];
        [self.tableView reloadData];
    }
}


- (void)searchFamilyListFail:(NSString *)message{
    [XCHUDTool hideHUDInView:self.view];
}

//家族成员
- (void)searchFamilyMemberListSuccess:(NSArray *)memberList{
    [XCHUDTool hideHUDInView:self.view];
    [self.tableView hideToastView];
    if (memberList.count == 0) {
        [self.familyMembers removeAllObjects];
        [self.tableView showEmptyContentToastWithTitle:@"暂无数据" andImage:[UIImage imageNamed:[[XCTheme defaultTheme] default_empty]]];
        [self.tableView reloadData];
    }else {
        self.familyMembers = [memberList mutableCopy];
        [self.tableView hideToastView];
        [self.tableView reloadData];
    }
}

- (void)searchFamilyMemberListFail:(NSString *)message{
    [XCHUDTool hideHUDInView:self.view];
}


- (void)onSearchSuccess:(NSArray *)arr {
    [XCHUDTool hideHUDInView:self.view];
    [self.tableView hideToastView];
    if (arr.count == 0) {
        [self.tableView showEmptyContentToastWithTitle:@"暂无搜索结果" andImage:[UIImage imageNamed:[XCTheme defaultTheme].default_empty]];
    }
    self.resultList = arr;
    [self.tableView reloadData];
}

- (void)onSearchFailth:(NSString *)message {
    [XCHUDTool showSuccessWithMessage:message inView:self.view];
}
//在家族中 但是不在群里面
- (void)fetchFamilyMemberNotInGroupSuccess:(XCFamily *)familyInfor andStatus:(int)status isSearch:(BOOL)isSearch{
    [XCHUDTool hideHUDInView:self.view];
    if (isSearch) {
        [XCHUDTool hideHUDInView:self.view];
        [self.tableView hideToastView];
        if (familyInfor.members.count == 0) {
            [self.familyMembers removeAllObjects];
        }
        self.familyMembers = familyInfor.members;
        if (self.familyMembers.count <= 0) {
            [self.tableView showEmptyContentToastWithTitle:@"暂无数据" andImage:[UIImage imageNamed:[[XCTheme defaultTheme] default_empty]]];
        }
        [self.tableView reloadData];
    }
}

- (void)fetchFamilyMemberNotInGroupFail:(NSString *)members andStatus:(int)status isSearch:(BOOL)isSearch{
    [XCHUDTool hideHUDInView:self.view];
}
#pragma mark - TTFamilySearchViewDelegate
- (void)touchCancleDismissSearch{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)searchViewTextFileTextChange:(UITextField *)textfiled{
    if (textfiled.text.length == 0) {
        return;
    }
    [self.view endEditing:YES];
    [XCHUDTool showGIFLoadingInView:self.view];
    if (self.searchType == TTFamilySearchType_Family) {
        [GetCore(FamilyCore) searchFamilyListWithKey:textfiled.text];
    }else if (self.searchType == TTFamilySearchType_Family_Member){
        [GetCore(FamilyCore) searchFamilyMemberListWithKey:textfiled.text];
    }else if (self.searchType == TTFamilySearchType_Group){
        [GetCore(GroupCore) serachMemberGroupByErbanNo:textfiled.text teamId:self.teamId page:1 pageSize:20];
    }else if (self.searchType == TTFamilySearchType_Family_NotInGroup){
         [GetCore(FamilyCore) fetchFamilyMemberNotInGroupWith:self.teamId andPage:1 andKey:textfiled.text andStatus:0 isSearch:YES];
    }else{
        [GetCore(SearchCore) searchWithKey:textfiled.text];
    }
}

#pragma mark - setters and getters
- (TTFamilySearchView *)searchView{
    if (!_searchView) {
        _searchView = [[TTFamilySearchView alloc] init];
        _searchView.delegate = self;
    }
    return _searchView;
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
