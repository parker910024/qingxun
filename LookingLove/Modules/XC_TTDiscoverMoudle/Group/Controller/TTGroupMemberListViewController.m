//
//  TTGroupMemberListViewController.m
//  TuTu
//
//  Created by gzlx on 2018/11/16.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTGroupMemberListViewController.h"
//tool
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "NSArray+Safe.h"
#import "XCHUDTool.h"
#import "UIView+XCToast.h"
#import "TTPopup.h"
//core
#import "GroupCore.h"
#import "GroupCoreClient.h"
//view
#import "TTFamilyMemberTableViewCell.h"
#import "TTFamilyMemSectionView.h"
//vc
#import "TTFamilySearchViewController.h"
#import "TTFamilyMemberViewController.h"
#import "XCMediator+TTPersonalMoudleBridge.h"


@interface TTGroupMemberListViewController ()<GroupCoreClient, TTFamilyMemberTableViewCellDelegate, TTFamilyMemberViewControllerDelegate, TTFamilySearchViewControllerDelegate>
/** 家族成员*/
@property (nonatomic, strong) NSMutableArray<GroupMemberModel *> * groupArray;
/** 一个群的人数*/
@property (nonatomic, copy) NSString * numberMember;
/** 当前的页数*/
@property (nonatomic, assign) int currentPage;
/** 是不是搜索得到的结果*/
@property (nonatomic, assign) BOOL isSearch;
/** 已经选择的*/
@property (nonatomic, strong) NSMutableDictionary * selectDic;
/** 显示成员的个数*/
@property (nonatomic, strong) TTFamilyMemSectionView * sectionView;

@end

@implementation TTGroupMemberListViewController

- (void)dealloc{
    RemoveCoreClientAll(self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addCore];
    [self initView];
    [self configNav];
    [self initContrations];
}

#pragma mark - response
- (void)ttaddMemberAction:(UIButton *)sender{
    if (sender.tag == 1000) {
        TTFamilyMemberViewController * familyMemberVC = [[TTFamilyMemberViewController alloc] init];
        familyMemberVC.delegate = self;
        familyMemberVC.teamId = self.chatId;
        familyMemberVC.listType = FamilyMemberAddGroup;
        [self.navigationController pushViewController:familyMemberVC animated:YES];
    }else if (sender.tag == 1001){
        TTFamilySearchViewController *vc = [[TTFamilySearchViewController alloc]init];
        vc.currentNav = self.navigationController;
        vc.delegate = self;
        vc.listType = self.listType;
        vc.searchType = TTFamilySearchType_Group;
        vc.teamId = self.teamId;
        [self.navigationController presentViewController:vc animated:YES completion:nil];
    }
}

#pragma mark - private method
- (void)initView{
    self.tableView.tableViewHeightOnScreen = 1;
    self.selectDic = [NSMutableDictionary dictionary];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[TTFamilyMemberTableViewCell class] forCellReuseIdentifier:@"TTFamilyMemberTableViewCell"];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.tableHeaderView = self.sectionView;
    [self setupRefreshTarget:self.tableView];
    [self pullDownRefresh:1];
}

- (void)initContrations{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(statusbarHeight + 44);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
}

- (void)addCore{
    AddCoreClient(GroupCoreClient , self);
}

- (void)configNav{
    if ((self.listType== FamilyGroupMemberListCheck|| self.listType == FamilyMemberListGroupRemove) && (self.role == GroupMemberRole_Owner || self.role == GroupMemberRole_Manager)) {
        [self addNavigationItemWithImageNames:@[@"family_group_add", @"family_search"] isLeft:NO target:self action:@selector(ttaddMemberAction:) tags:@[@1000, @1001]];
    }else{
        [self addNavigationItemWithImageNames:@[@"family_search"] isLeft:NO target:self action:@selector(ttaddMemberAction:) tags:@[@1001]];
    }
    
    if (self.listType == FamilyGroupMemberListCheck) {
        self.title = @"家族群成员列表";
    }else if (self.listType == FamilyMemberListGroupManager){
        self.title = @"设置管理员";
    }else{
        self.title = @"群成员列表";
    }
}


#pragma mark - UITableViewDelegate and UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.groupArray.count > 0 ? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.groupArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TTFamilyMemberTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TTFamilyMemberTableViewCell"];
    if (cell== nil) {
        cell = [[TTFamilyMemberTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TTFamilyMemberTableViewCell"];
    }
    cell.delegate = self;
    GroupMemberModel * groupMember = [self.groupArray safeObjectAtIndex:indexPath.row];
    if (self.selectDic && self.selectDic.allKeys.count > 0) {
        if ([self.selectDic.allKeys containsObject:[NSString stringWithFormat:@"%lld", groupMember.uid]]) {
         GroupMemberModel * selectmodel = [self.selectDic objectForKey:[NSString stringWithFormat:@"%lld", groupMember.uid]];
            [cell configGroupMemberWith:selectmodel];
        }else{
            [cell configGroupMemberWith:groupMember];
        }
    }else{
        [cell configGroupMemberWith:groupMember];
    }
    cell.listType = self.listType;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.groupArray.count > 0) {
        GroupMemberModel * model = [self.groupArray safeObjectAtIndex:indexPath.row];
        UIViewController * controller = [[XCMediator sharedInstance] ttPersonalModule_personalViewController:model.uid];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark - TTFamilyMemberTableViewCellDelegate
- (void)handleFamilyMemberTableViewWith:(XCFamilyModel *)familyModel groupModel:(GroupMemberModel *)groupModel listType:(FamilyMemberListType)listType typeButton:(UIButton *)sender{
    if (listType == FamilyMemberListGroupManager) {
        //设置管理员
        if (!sender.selected) {
            if (groupModel.role == GroupMemberRole_Normal) {
                NSString * message = [NSString stringWithFormat:@"成为管理员后将拥有修改群名称的权限，确定设置%@为群管理吗？", groupModel.nick];
                TTAlertConfig * config = [[TTAlertConfig alloc] init];
                config.message = message;
                
                TTAlertMessageAttributedConfig *attConfig = [[TTAlertMessageAttributedConfig alloc] init];
                attConfig.text = groupModel.nick;
                
                config.messageAttributedConfig = @[attConfig];
                
                @weakify(self);
                [TTPopup alertWithConfig:config confirmHandler:^{
                    @strongify(self);
                    [GetCore(GroupCore) setManagerByTeamId:self.teamId targetUid:groupModel.uid groupModel:groupModel];
                } cancelHandler:^{
                }];

            }
        }else{
            if (groupModel.role == GroupMemberRole_Manager) {
                NSString * message = [NSString stringWithFormat:@"取消管理员后将不在拥有修改群名称的权限，确定取消%@为群管理吗？", groupModel.nick];
                TTAlertConfig * config = [[TTAlertConfig alloc] init];
                config.message = message;
                
                TTAlertMessageAttributedConfig *attConfig = [[TTAlertMessageAttributedConfig alloc] init];
                attConfig.text = groupModel.nick;
                
                config.messageAttributedConfig = @[attConfig];
                
                @weakify(self);
                [TTPopup alertWithConfig:config confirmHandler:^{
                    @strongify(self);
                    [GetCore(GroupCore) removeManagerByTeamId:self.teamId targetUid:groupModel.uid groupModel:groupModel];
                } cancelHandler:^{
                }];
            }
        }
        return;
    }else if (listType == FamilyMemberListGroupBanned){
        //禁言
        if (groupModel) {
            if (groupModel.role != GroupMemberRole_Owner) {
                NSString * message;
                if (sender.selected) {
                    message = [NSString stringWithFormat:@"禁言后将不能再群里发言，确定禁言%@吗？", groupModel.nick];
                }else{
                    message = [NSString stringWithFormat:@"解除禁言后将能在群里发言，确定解除禁言%@吗？", groupModel.nick];
                }
                TTAlertConfig * config = [[TTAlertConfig alloc] init];
                config.message = message;
                
                TTAlertMessageAttributedConfig *attConfig = [[TTAlertMessageAttributedConfig alloc] init];
                attConfig.text = groupModel.nick;
                
                config.messageAttributedConfig = @[attConfig];
                
                @weakify(self);
                [TTPopup alertWithConfig:config confirmHandler:^{
                    @strongify(self);
                    [GetCore(GroupCore) updateGroupMemberDisable:self.teamId andTargetId:groupModel.uid muteStatus:sender.selected groupModel:groupModel];
                } cancelHandler:^{
                }];
            }
        }
        return;
    }else if (listType == FamilyMemberListGroupRemove){
        if (groupModel.role != GroupMemberRole_Owner) {
            NSString * message = [NSString stringWithFormat:@"移出群后收不到群消息，确定移出%@？", groupModel.nick];
            TTAlertConfig * config = [[TTAlertConfig alloc] init];
            config.message = message;
            
            TTAlertMessageAttributedConfig *attConfig = [[TTAlertMessageAttributedConfig alloc] init];
            attConfig.text = groupModel.nick;
            
            config.messageAttributedConfig = @[attConfig];
            
            @weakify(self);
            [TTPopup alertWithConfig:config confirmHandler:^{
                @strongify(self);
                [GetCore(GroupCore) kickMemberByTeamId:self.teamId targetUid:groupModel.uid groupModel:groupModel];
            } cancelHandler:^{
            }];
        }
    }else if (listType == FamilyGroupMemberListCheck){
        UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_personalViewController:groupModel.uid];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - TTFamilyMemberViewControllerDelegate
/** 选择完成之后*/
- (void)chooseFamilyMemberWith:(NSMutableDictionary *)memberDic{
    if (memberDic.allKeys.count > 0) {
        [GetCore(GroupCore) addFamilyMemberToGroup:self.teamId andMembers:memberDic];
    }
}
#pragma mark - TTFamilySearchViewControllerDelegate
- (void)didSelectGroupMemberWith:(GroupMemberModel *)groupMember selectDic:(NSMutableDictionary *)selectDic{
    if (self.listType == FamilyMemberListGroupManager) {
        if (groupMember.role == GroupMemberRole_Manager) {
                NSString * message = [NSString stringWithFormat:@"取消管理员后将不在拥有修改群名称的权限，确定取消%@为群管理吗？", groupMember.nick];
            TTAlertConfig * config = [[TTAlertConfig alloc] init];
            config.message = message;
            
            TTAlertMessageAttributedConfig *attConfig = [[TTAlertMessageAttributedConfig alloc] init];
            attConfig.text = groupMember.nick;
            
            config.messageAttributedConfig = @[attConfig];
            
            @weakify(self);
            [TTPopup alertWithConfig:config confirmHandler:^{
                @strongify(self);
                [GetCore(GroupCore) removeManagerByTeamId:self.teamId targetUid:groupMember.uid groupModel:groupMember];
            } cancelHandler:^{
            }];
    
        }else if (groupMember.role == GroupMemberRole_Normal){
            NSString * message = [NSString stringWithFormat:@"成为管理员后将拥有修改群名称的权限，确定设置%@为群管理吗？", groupMember.nick];
            TTAlertConfig * config = [[TTAlertConfig alloc] init];
            config.message = message;
            
            TTAlertMessageAttributedConfig *attConfig = [[TTAlertMessageAttributedConfig alloc] init];
            attConfig.text = groupMember.nick;
            
            config.messageAttributedConfig = @[attConfig];
            
            @weakify(self);
            [TTPopup alertWithConfig:config confirmHandler:^{
                @strongify(self);
                [GetCore(GroupCore) setManagerByTeamId:self.teamId targetUid:groupMember.uid groupModel:groupMember];
            } cancelHandler:^{
            }];
        }
    }else if (self.listType == FamilyMemberListGroupBanned){
        NSString * message;
        if (!groupMember.isDisable) {
            message = [NSString stringWithFormat:@"禁言后将不能再群里发言，确定禁言%@吗？", groupMember.nick];
        }else{
            message = [NSString stringWithFormat:@"解除禁言后将能在群里发言，确定解除禁言%@吗？", groupMember.nick];
        }
        TTAlertConfig * config = [[TTAlertConfig alloc] init];
        config.message = message;
        
        TTAlertMessageAttributedConfig *attConfig = [[TTAlertMessageAttributedConfig alloc] init];
        attConfig.text = groupMember.nick;
        
        config.messageAttributedConfig = @[attConfig];
        
        @weakify(self);
        [TTPopup alertWithConfig:config confirmHandler:^{
            @strongify(self);
            [GetCore(GroupCore) updateGroupMemberDisable:self.teamId andTargetId:groupMember.uid muteStatus:!groupMember.isDisable groupModel:groupMember];
        } cancelHandler:^{
        }];
        
    }else if(self.listType == FamilyMemberListGroupRemove){
        if (groupMember.role != GroupMemberRole_Owner) {
            NSString * message = [NSString stringWithFormat:@"移出群后收不到群消息，确定移出%@？", groupMember.nick];
            TTAlertConfig * config = [[TTAlertConfig alloc] init];
            config.message = message;
            
            TTAlertMessageAttributedConfig *attConfig = [[TTAlertMessageAttributedConfig alloc] init];
            attConfig.text = groupMember.nick;
            
            config.messageAttributedConfig = @[attConfig];
            
            @weakify(self);
            [TTPopup alertWithConfig:config confirmHandler:^{
                @strongify(self);
                [GetCore(GroupCore) kickMemberByTeamId:self.teamId targetUid:groupMember.uid groupModel:groupMember];
            } cancelHandler:^{
            }];
        }
    }
}
    
#pragma mark - http
- (void)pullDownRefresh:(int)page{
    [self.selectDic removeAllObjects];
    self.currentPage = page;
    [GetCore(GroupCore) fetchGroupMemberByTeamId:self.teamId page:page pageSize:10 andStatus:0];
}

- (void)pullUpRefresh:(int)page lastPage:(BOOL)isLastPage{
    self.currentPage = page;
    if (isLastPage) {
        return;
    }
 [GetCore(GroupCore) fetchGroupMemberByTeamId:self.teamId page:page pageSize:10 andStatus:1];
}

#pragma mark - GroupCoreClientpo
//禁言
- (void)setupGroupMemberDisableSuccess:(NSDictionary *)dic andTeamId:(NSInteger)temaId andStatus:(BOOL)status groupModel:(GroupMemberModel *)groupInfor{
    [XCHUDTool showSuccessWithMessage:@"设置成功" inView:self.view];
    groupInfor.isDisable = status;
    if (self.selectDic) {
        [self.selectDic setValue:groupInfor forKey:[NSString stringWithFormat:@"%lld", groupInfor.uid]];
    }
    GetCore(GroupCore).isReloadGroupInfor = YES;
    [self.tableView reloadData];
}

- (void)setupGroupMemberDisableFail:(NSString *)message andStatus:(BOOL)status{
    GetCore(GroupCore).isReloadGroupInfor = NO;
    [XCHUDTool showErrorWithMessage:@"设置失败" inView:self.view];
}

//设置管理员
- (void)setManagerSuccess:(UserID)targetUid teamId:(NSInteger)teamId groupModel:(GroupMemberModel *)groupInfor{
    groupInfor.role = GroupMemberRole_Manager;
    GetCore(GroupCore).isReloadGroupInfor = YES;
    if (self.selectDic) {
        [self.selectDic setValue:groupInfor forKey:[NSString stringWithFormat:@"%lld", groupInfor.uid]];
    }
    [self.tableView reloadData];
    [XCHUDTool showSuccessWithMessage:@"设置管理员成功" inView:self.view];
    [self.tableView reloadData];
}
- (void)setManagerFailthMessage:(NSString *)message targetUid:(UserID)targetUid teamId:(NSInteger)teamId{
    GetCore(GroupCore).isReloadGroupInfor = NO;
}

//移出管理员
- (void)removeManagerSuccess:(UserID)targetUid teamId:(NSInteger)teamId groupModel:(GroupMemberModel *)groupInfor{
    groupInfor.role = GroupMemberRole_Normal;
    GetCore(GroupCore).isReloadGroupInfor = YES;
    if (self.selectDic) {
        [self.selectDic setValue:groupInfor forKey:[NSString stringWithFormat:@"%lld", groupInfor.uid]];
    }
    [self.tableView reloadData];
}
- (void)removeManagerFailthMessage:(NSString *)message targetUid:(UserID)targetUid teamId:(NSInteger)teamId{
    GetCore(GroupCore).isReloadGroupInfor = NO;
}


//获取群聊所有的人 成功
- (void)fetchGroupMemberSuccess:(GroupMember *)groupMember page:(NSInteger)page pageSize:(NSInteger)pageSize status:(NSInteger)status{
    if (page == 1) {
        [self.groupArray removeAllObjects];
        [self.tableView hideToastView];
        self.groupArray = groupMember.memberList;
    }else{
        [self.groupArray addObjectsFromArray: groupMember.memberList];
    }
    if (groupMember.memberList.count > 0) {
        [self.tableView endRefreshStatus:status hasMoreData:YES];
    }else{
        [self.tableView endRefreshStatus:status hasMoreData:NO];
    }
    
    if (self.groupArray.count == 0) {
        [self.tableView showEmptyContentToastWithTitle:@"暂无成员" andImage:[UIImage imageNamed:@"praised_list_empty"]];
    }
    
    self.numberMember = groupMember.count;
    self.sectionView.titleLabel.text = @"群成员";
    self.sectionView.subtitleLabel.text = [NSString stringWithFormat:@"%@人", self.numberMember];
    [self.tableView reloadData];
}

- (void)fetchGroupMemberFailth:(NSString *)message status:(NSInteger)status{
    [self failEndRefreshStatus:status];
    if (self.groupArray.count == 0) {
        [self.tableView showEmptyContentToastWithTitle:@"暂无成员" andImage:[UIImage imageNamed:[[XCTheme defaultTheme] default_empty]]];
    }
    [self.tableView reloadData];
}

//移出群
- (void)kickMemberOutOfGroupSuccess:(UserID)targetUid teamId:(NSInteger)teamId groupModel:(GroupMemberModel *)groupInfor{
    if (teamId == self.teamId) {
        //获取群成员
        [XCHUDTool showSuccessWithMessage:@"移出成功" inView:self.view];
        GetCore(GroupCore).isReloadGroupInfor = YES;
        [[NIMSDK sharedSDK].teamManager fetchTeamInfo:[NSString stringWithFormat:@"%ld", self.chatId] completion:^(NSError * _Nullable error, NIMTeam * _Nullable team) {
            if (error== nil) {
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    for (GroupMemberModel * model in self.groupArray) {
                        if (model.uid == groupInfor.uid) {
                            [self.groupArray removeObject:model];
                            break;
                        }
                    }
                });
                NIMTeam * team = [[NIMSDK sharedSDK].teamManager teamById:[NSString stringWithFormat:@"%ld", self.chatId]];
                self.numberMember = [NSString stringWithFormat:@"%ld", team.memberNumber];
                self.sectionView.subtitleLabel.text = [NSString stringWithFormat:@"%@人", self.numberMember];
            }
            dispatch_main_sync_safe(^{
                [self.tableView reloadData];
            });
        }];
    }
}

- (void)kickMemberFailthWithMessage:(NSString *)message targetUid:(UserID)targetUid teamId:(NSInteger)teamId{
    [XCHUDTool showErrorWithMessage:@"移出失败" inView:self.view];
}

//添加成员到群聊的时候
- (void)addFamilyMemberToGroupSuccess:(NSDictionary *)dic chatId:(NSInteger)chatId{
    //获取群成员
    if (self.teamId == chatId) {
        //成功之后刷新一下 群人数
        GetCore(GroupCore).isReloadGroupInfor = YES;
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO]; 
        [GetCore(GroupCore) fetchGroupMemberByTeamId:chatId page:1 pageSize:10 andStatus:0];
    }
}

- (void)addFamilyMemberToGroupFail:(NSString *)message{
    
}

#pragma mark - setters and getters
- (TTFamilyMemSectionView *)sectionView{
    if (!_sectionView) {
        _sectionView = [[TTFamilyMemSectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 27)];
    }
    return _sectionView;
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
