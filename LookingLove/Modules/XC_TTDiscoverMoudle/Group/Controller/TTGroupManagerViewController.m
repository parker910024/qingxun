//
//  TTGroupManagerViewController.m
//  TuTu
//
//  Created by gzlx on 2018/11/16.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTGroupManagerViewController.h"
//view
#import "TTGroupManagerTableViewCell.h"
#import "TTFamilyBottomView.h"
//core
#import "FileCore.h"
#import "FileCoreClient.h"
#import "GroupModel.h"
#import "FamilyCore.h"
#import "GroupCore.h"
#import "GroupCoreClient.h"
#import "UserCore.h"
#import "AuthCore.h"
#import "ShareModelInfor.h"
#import "ShareCore.h"
//tool
#import "XCTheme.h"
#import <Masonry/Masonry.h>
#import "XCMacros.h"
#import "NSArray+Safe.h"
#import "NSString+Utils.h"
#import "TTFamilyBaseAlertController.h"
#import "TTPopup.h"
#import "XCHUDTool.h"
//vc
#import "TTFamilyEditViewController.h"
#import "TTFamilyMonViewController.h"
#import "TTGroupMemberListViewController.h"

@interface TTGroupManagerViewController ()<GroupCoreClient, TTFamilyEditViewControllerDelegate, TTFamilyBaseAlertControllerDelegate, FileCoreClient, TTGroupManagerTableViewCellDelegate, TTFamilyBottomViewDelegate>
@property (nonatomic, strong) TTFamilyBottomView *bottomView;
@property (nonatomic, strong) NSMutableArray<NSArray *> * datasourceArray;
@property (nonatomic, strong) GroupModel * groupModel;
@property (nonatomic, assign) TTGroupManagerModelType modifyType;
@end

@implementation TTGroupManagerViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 有些时候需要刷新数据 
    if (GetCore(GroupCore).isReloadGroupInfor) {
       [GetCore(GroupCore)fetchGroupDetailByTeamId:_teamId];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self intiContrations];
    [self addCore];
}

#pragma mark- response
- (void)showShareView:(UIButton *)sender{
    [TTFamilyBaseAlertController defaultCenter].group = self.groupModel;
    [[TTFamilyBaseAlertController defaultCenter] shareAppcationActionSheetWith:self];
}
#pragma mark - private method
- (void)initView{
    self.title = @"家族群资料";
    [self.tableView registerClass:[TTGroupManagerTableViewCell class] forCellReuseIdentifier:@"TTGroupManagerTableViewCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = self.bottomView;
    
    GroupModel * model = GetCore(GroupCore).groupInfor;
    if (model) {
        self.groupModel = model;
        [self creatGroupManagerModelWith:model];
        [self.tableView reloadData];
    }else{
        [GetCore(GroupCore)fetchGroupDetailByTeamId:_teamId];
    }
    [self addNavigationItemWithImageNames:@[@"family_person_share"] isLeft:NO target:self action:@selector(showShareView:) tags:nil];
}

- (void)intiContrations{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(statusbarHeight + 44);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
    
    [self.bottomView.sureButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bottomView).offset(15);
        make.right.mas_equalTo(self.bottomView).offset(-15);
        make.top.mas_equalTo(self.bottomView).offset(20);
        make.height.mas_equalTo(44);
    }];
}

- (void)addCore{
    AddCoreClient(GroupCoreClient, self);
    AddCoreClient(FileCoreClient, self);
}

#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.datasourceArray.count > 0 ? self.datasourceArray.count : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray * array = [self.datasourceArray safeObjectAtIndex:section];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    TTGroupManagerModel * model = [[self.datasourceArray safeObjectAtIndex:indexPath.section] safeObjectAtIndex:indexPath.row];
    return model.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        if (self.groupModel.role == GroupMemberRole_Normal) {
            return 0;
        }
        return 44;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel * titlelabel = [[UILabel alloc] init];
    if (section == 2) {
        if (self.groupModel.role == GroupMemberRole_Normal) {
            titlelabel.frame = CGRectMake(0, 0, KScreenWidth, 0);
            titlelabel.text = @"";
            return titlelabel;
        }
        titlelabel.frame = CGRectMake(0, 0, KScreenWidth, 44);
        titlelabel.text = @"   群管理";
    }else{
        titlelabel.frame = CGRectMake(0, 0, KScreenWidth, 10);
        titlelabel.text = @"";
    }
    return titlelabel;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TTGroupManagerTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TTGroupManagerTableViewCell"];
    if (cell == nil) {
        cell = [[TTGroupManagerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TTGroupManagerTableViewCell"];
    }
     TTGroupManagerModel * model = [[self.datasourceArray safeObjectAtIndex:indexPath.section] safeObjectAtIndex:indexPath.row];
    cell.delegate = self;
    if (model.disPlayType == TTGroupCellSwitch_Type_Verifica) {
        if (indexPath.section == 1 && indexPath.row == 1) {
            cell.switchType = TTGroupCellSwitch_Type_NoDistur;
        }else if (indexPath.section==2 && indexPath.row == 4){
            cell.switchType = TTGroupCellSwitch_Type_Verifica;
        }
    }
    [cell configTTGroupManagerTableViewCellWith:model];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self didClickTableViewCellWith:indexPath];
}

- (void)didClickTableViewCellWith:(NSIndexPath *)indexPath{
    TTGroupManagerModel *display = self.datasourceArray[indexPath.section][indexPath.row];
    if (indexPath.section == 0) {
        TTGroupMemberListViewController *vc =  [[TTGroupMemberListViewController alloc]init];
        if (self.groupModel.role ==GroupMemberRole_Owner) {
            vc.listType = FamilyMemberListGroupRemove;
        }else{
            vc.listType = FamilyGroupMemberListCheck;
        }
        vc.teamId = self.groupModel.id;
        vc.role = self.groupModel.role;
        vc.chatId = self.groupModel.tid;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 1) {
        if (indexPath.row == 3) {
            TTAlertConfig *config = [[TTAlertConfig alloc] init];
            config.title = @"清空聊天记录";
            config.message = @"确认清空聊天记录？";
            
            @weakify(self);
            [TTPopup alertWithConfig:config confirmHandler:^{
                @strongify(self);
                [self removeAllRecord];
            } cancelHandler:^{
            }];
        }
    }else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            [self showChoosePhotoView];
        }else if (indexPath.row == 1) {
            TTFamilyEditViewController * editVC = [[TTFamilyEditViewController alloc] init];
            editVC.defaultText = display.subTitle;
            editVC.maxLength = 15;
            editVC.title = @"编辑群名称";
            editVC.delegate = self;
            [self.navigationController pushViewController:editVC animated:YES];
        }else if (indexPath.row == 2) {
            if (_groupModel.role == GroupMemberRole_Owner) {//管理员
                TTGroupMemberListViewController *vc =  [[TTGroupMemberListViewController alloc]init];
                vc.listType = FamilyMemberListGroupManager;
                vc.teamId = self.groupModel.id;
                [self.navigationController pushViewController:vc animated:YES];
            }else if (_groupModel.role == GroupMemberRole_Manager) { //禁言
                TTGroupMemberListViewController *vc =  [[TTGroupMemberListViewController alloc]init];
                vc.listType = FamilyMemberListGroupBanned;
                vc.teamId = self.groupModel.id;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else if (indexPath.row == 3) {
            if (_groupModel.role == GroupMemberRole_Owner) {
                TTGroupMemberListViewController *vc =  [[TTGroupMemberListViewController alloc]init];
                vc.listType = FamilyMemberListGroupBanned;
                vc.teamId = self.groupModel.id;
                [self.navigationController  pushViewController:vc animated:YES];
            }
        }else if (indexPath.row == 5){
            if (_groupModel.role == GroupMemberRole_Owner) {
                @weakify(self);
                [[GetCore(UserCore) getUserInfoByUid:[GetCore(AuthCore).getUid userIDValue] refresh:NO]subscribeNext:^(id x) {
                    @strongify(self)
                    TTFamilyMonViewController *vc = [[TTFamilyMonViewController alloc]init];
                    vc.ownerType = FamilyMoneyOwnerGroup;
                    vc.chatId = self.groupModel.id;
                    [self.navigationController pushViewController:vc animated:YES];
                }];
            }
        }
        
    }
}

- (void)removeAllRecord{
    NIMDeleteMessagesOption *option = [[NIMDeleteMessagesOption alloc] init];
    option.removeSession = NO;
    option.removeTable = YES;
    NIMSession * section = [NIMSession session:[NSString stringWithFormat:@"%ld", self.groupModel.tid] type:NIMSessionTypeTeam];
    [[NIMSDK sharedSDK].conversationManager deleteAllmessagesInSession:section
                                                                option:option];
    [XCHUDTool showErrorWithMessage:@"清空完成" inView:self.view];
}

#pragma mark  - TTGroupManagerTableViewCellDelegate
- (void)ttGroupManagerCellSwtich:(BOOL)status switchType:(TTGroupCellSwitch_Type)type{
    if (type == TTGroupCellSwitch_Type_Verifica) {
        if (self.groupModel.role == GroupMemberRole_Owner) {
            self.modifyType = GroupManagerModifyType_Verify;
            [GetCore(GroupCore)updateGroupDataByTeamId:self.groupModel.id icon:nil name:nil isVerify:
             status];
        }
    }else if (type == TTGroupCellSwitch_Type_NoDistur){
         [GetCore(GroupCore)operationMessageNotificationSwitch:status teamId:self.groupModel.id];
    }
}

#pragma mark - TTFamilyEditViewControllerDelegate
- (void)textFiledChangeEngEdit:(NSString *)text{
    [self modifyGroupNameWith:text];
}

- (void)modifyGroupNameWith:(NSString *)text{
    if (self.groupModel) {
        [XCHUDTool showGIFLoadingInView:self.view];
        self.modifyType = GroupManagerModifyType_Name;
        [GetCore(GroupCore)updateGroupDataByTeamId:self.groupModel.id icon:nil name:text isVerify:nil];
    }
}

#pragma mark - TTFamilyBaseAlertControllerDelegate
- (void)showChoosePhotoView{
    [[TTFamilyBaseAlertController defaultCenter] showChoosePhotoWith:self delegate:self];
}

- (void)imagePickerControllerdidFinishPickingMediaWithInfo:(UIImage *)selectImage{
    [XCHUDTool showGIFLoadingInView:self.view];
    [GetCore(FileCore) qiNiuUploadImage:selectImage uploadType:UploadImageTypeGroupIcon];
}

#pragma mark - FileCoreClient
- (void)didUploadGroupIconImageSuccessUseQiNiu:(NSString *)key {
    [XCHUDTool hideHUDInView:self.view];
    NSString *url = [NSString stringWithFormat:@"%@/%@?imageslim",keyWithType(KeyType_QiNiuBaseURL, NO),key];
    self.modifyType = GroupManagerModifyType_Avatar;
    [GetCore(GroupCore)updateGroupDataByTeamId:self.groupModel.id icon:url name:self.groupModel.name isVerify:self.groupModel.isVerify];
}

- (void)didUploadGroupIconImageFailUseQiNiu:(NSString *)message {
    [XCHUDTool hideHUDInView:self.view];
}

#pragma mark - GroupCoreClient
- (void)deleteGroupSuccessWithTeamId:(NSInteger)teamId sessionId:(NSInteger)sessionId{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)outGroupSuccessTeamId:(NSInteger)teamId sessionId:(NSInteger)sessionId{
    if (self.navigationController.viewControllers.count > 0) {
        @weakify(self);
        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @strongify(self);
            if ([obj  isKindOfClass:[TTGroupManagerViewController class]]) {
                UIViewController * controller = [self.navigationController.viewControllers objectAtIndex:idx -2];
                if (controller) {
                    [self.navigationController popToViewController:controller animated:YES];
                }else{
                    [self.navigationController popViewControllerAnimated:YES];
                }
                *stop = YES;
            }
            
        }];
    }
}
//更新群信息
- (void)updateGroupDataSuccess:(GroupModel *)group {
    [XCHUDTool hideHUDInView:self.view];
    if (group) {
        [XCHUDTool showSuccessWithMessage:@"修改成功" inView:self.view];
      GroupModel * infor =  GetCore(GroupCore).groupInfor;
        if (self.modifyType == GroupManagerModifyType_Avatar) {
            TTGroupManagerModel * model = [[self.datasourceArray safeObjectAtIndex:2] safeObjectAtIndex:0];
             model.avatar = group.icon;
            infor.icon = group.icon;
        }else if (self.modifyType == GroupManagerModifyType_Name){
            TTGroupManagerModel * model = [[self.datasourceArray safeObjectAtIndex:2] safeObjectAtIndex:1];
             model.subTitle = group.name;
            infor.name = group.name;
        }else if (self.modifyType == GroupManagerModifyType_Verify){
            TTGroupManagerModel * model = [[self.datasourceArray safeObjectAtIndex:2] safeObjectAtIndex:4];
            model.switchStatus = group.isVerify;
            infor.isVerify = group.isVerify;
            TTGroupManagerModel * verModel = [[self.datasourceArray safeObjectAtIndex:1] safeObjectAtIndex:2];
            if (group.isVerify) {
                verModel.subTitle = @"开启身份验证";
            }else {
                verModel.subTitle = @"关闭身份验证";
            }
        }
        [self.tableView reloadData];
    }
    return;
}

- (void)updateGroupDataFailth:(NSString *)message {
    [XCHUDTool showErrorWithMessage:message inView:self.view];
}

- (void)fetchGroupDetailSuccess:(GroupModel *)group teamId:(NSInteger)teamId {
    [XCHUDTool hideHUDInView:self.view];
    self.groupModel = group;
    [self creatGroupManagerModelWith:group];
    [self.tableView reloadData];
}

//消息免打扰
- (void)muteGroupSuccessTeamId:(NSInteger)teamId isMute:(BOOL)isMute{
    self.groupModel = self.groupModel;
    TTGroupManagerModel * model = [[self.datasourceArray safeObjectAtIndex:1] safeObjectAtIndex:1];
    model.switchStatus = isMute;
    [self.tableView reloadData];
    [XCHUDTool showSuccessWithMessage:@"修改成功" inView:self.view];
}
- (void)muteGroupFailth:(NSString *)message teamId:(NSInteger)teamId {
}

#pragma mark -TTFamilyBottomViewDelegate
- (void)sureButtonActionWith:(UIButton *)sender{
    if (self.groupModel.role == GroupMemberRole_Owner) {
        [TTPopup alertWithMessage:@"删除后，该群组所有成员将退出群组，确定删除？" confirmHandler:^{
            [[XCAlertControllerCenter defaultCenter] dismissAlertNeedBlock:NO andAnimate:YES];
            [GetCore(GroupCore)deleteGroupByTeamId:self.groupModel.id sessionId:self.teamId];
        } cancelHandler:^{
        }];
    }else{
        NSString *title = [NSString stringWithFormat:@"退出后将收不到群消息，确认退出%@群聊吗？",self.groupModel.name];

        TTAlertConfig *config = [[TTAlertConfig alloc] init];
        config.message = title;
        
        TTAlertMessageAttributedConfig *attConfig = [[TTAlertMessageAttributedConfig alloc] init];
        attConfig.text = self.groupModel.name;
        
        config.messageAttributedConfig = @[attConfig];
        
        [TTPopup alertWithConfig:config confirmHandler:^{
            [[XCAlertControllerCenter defaultCenter] dismissAlertNeedBlock:NO andAnimate:YES];
            [GetCore(GroupCore)outterGroupByTeamId:self.groupModel.id sessionId:self.teamId];
        } cancelHandler:^{
        }];
    }
}

#pragma mark - setters and getters
- (void)creatGroupManagerModelWith:(GroupModel *)group{
    XCFamily * family  = [GetCore(FamilyCore) getFamilyModel];
    NSMutableArray * groupArray = [NSMutableArray array];
    //群成员
    TTGroupManagerModel * memModel = [[TTGroupManagerModel alloc] init];
    memModel.cellHeight = 50;
    memModel.disPlayType = TTGroupManagerModelType_SubtitleArrow;
    memModel.title = @"全部群成员";
    memModel.subTitle = [NSString stringWithFormat:@"群成员(%ld)", group.memberCount];
    memModel.titleFont = [UIFont boldSystemFontOfSize:15];
   //本群职务
    TTGroupManagerModel * dutyModel = [[TTGroupManagerModel alloc] init];
    dutyModel.cellHeight = 50;
    dutyModel.disPlayType = TTGroupManagerModelType_Subtitle;
    dutyModel.title = @"本群职务";
    NSString * duty;
    if (group.role == GroupMemberRole_Owner) {
        duty = @"群主";
    }else if (group.role == GroupMemberRole_Manager){
        duty = @"管理员";
    }else if (group.role == GroupMemberRole_Normal){
        duty = @"群成员";
    }
    dutyModel.subTitle = duty;
    dutyModel.titleFont = [UIFont boldSystemFontOfSize:15];
//  消息免打扰
    TTGroupManagerModel * messageModel = [[TTGroupManagerModel alloc] init];
    messageModel.cellHeight = 50;
    messageModel.disPlayType = TTGroupManagerModelType_Verifica;
    messageModel.title = @"消息免打扰";
    messageModel.switchStatus = group.isPromt;
    messageModel.titleFont = [UIFont systemFontOfSize:15.f];
//   身份认证
    TTGroupManagerModel * verModel = [[TTGroupManagerModel alloc] init];
    verModel.cellHeight = 50;
    verModel.disPlayType = TTGroupManagerModelType_Subtitle;
    verModel.title = @"身份认证";
    if (group.isVerify) {
        verModel.subTitle = @"开启身份验证";
    }else {
        verModel.subTitle = @"关闭身份验证";
    }
    messageModel.switchStatus = group.isPromt;
     messageModel.titleFont = [UIFont systemFontOfSize:15.f];
//   清空聊天记录
    TTGroupManagerModel * messRecordModel = [[TTGroupManagerModel alloc] init];
    messRecordModel.cellHeight = 50;
    messRecordModel.disPlayType = TTGroupManagerModelType_SubtitlHidden;
    messRecordModel.title = @"清空聊天记录";
     messRecordModel.titleFont = [UIFont systemFontOfSize:15.f];
//    群头像
    TTGroupManagerModel * avatarModel = [[TTGroupManagerModel alloc] init];
    avatarModel.avatar = group.icon;
    avatarModel.title = @"群头像";
    avatarModel.titleFont = [UIFont systemFontOfSize:15.f];
    avatarModel.disPlayType = TTGroupManagerModelType_Avatar;
    avatarModel.cellHeight = 70;
//    群名称
    TTGroupManagerModel * groupNameModel = [[TTGroupManagerModel alloc] init];
    groupNameModel.title = @"群名称";
    groupNameModel.titleFont = [UIFont systemFontOfSize:15.f];
    groupNameModel.disPlayType = TTGroupManagerModelType_SubtitleArrow;
    groupNameModel.subTitle = group.name;
    groupNameModel.cellHeight = 50;
//   设置本群管理员
    TTGroupManagerModel * managerModel = [[TTGroupManagerModel alloc] init];
    managerModel.title = @"设置本群管理员";
    managerModel.titleFont = [UIFont systemFontOfSize:15.f];
    managerModel.disPlayType = TTGroupManagerModelType_SubtitleArrow;
    managerModel.subTitle = [NSString stringWithFormat:@"%ld个管理员",(long)group.managerCount];
    managerModel.cellHeight = 50;
//   设置群内禁言
    TTGroupManagerModel * bannedModel = [[TTGroupManagerModel alloc] init];
    bannedModel.title = @"设置群内禁言";
    bannedModel.disPlayType = TTGroupManagerModelType_SubtitleArrow;
    bannedModel.subTitle = group.name;
    bannedModel.subTitle = [NSString stringWithFormat:@"%ld人禁言",(long)group.disabledCount];
    bannedModel.cellHeight = 50;
//    加入群身份验证
    TTGroupManagerModel * enterModel = [[TTGroupManagerModel alloc] init];
    enterModel.title = @"加入群身份验证";
    enterModel.switchStatus = group.isVerify;
    enterModel.disPlayType = TTGroupManagerModelType_Verifica;
    enterModel.cellHeight = 50;
    enterModel.subTitle = group.name;
//    群统计
    TTGroupManagerModel * statisModel = [[TTGroupManagerModel alloc] init];
    statisModel.title = @"群统计";
    statisModel.cellHeight = 50;
    statisModel.titleFont = [UIFont systemFontOfSize:15.f];
    statisModel.disPlayType = TTGroupManagerModelType_SubtitleArrow;
    NSString * money = [NSString changeAsset: [NSString stringWithFormat:@"%.2f", group.totalAmount]];
    statisModel.subTitle =[NSString stringWithFormat:@"%@%@",money, [GetCore(FamilyCore) getFamilyModel].moneyName];
    NSArray * memberArray = @[memModel];
    NSArray * setterArray = @[dutyModel, messageModel, verModel,messRecordModel];
    NSArray * managerArray;
    if (group.role == GroupMemberRole_Owner) {
        if (family && family.openMoney) {
          managerArray = @[avatarModel, groupNameModel,managerModel, bannedModel,enterModel, statisModel];
        }else{
            managerArray = @[avatarModel, groupNameModel,managerModel, bannedModel,enterModel];
        }
    }else if (group.role == GroupMemberRole_Manager){
        managerArray = @[avatarModel, groupNameModel];
    }else{
        managerArray =@[];
    }
    self.datasourceArray = [@[memberArray, setterArray, managerArray] mutableCopy];
    if (group.role == GroupMemberRole_Owner) {
        [self.bottomView.sureButton setTitle:@"解散群组" forState:UIControlStateNormal];
    }else{
        [self.bottomView.sureButton setTitle:@"退出群组" forState:UIControlStateNormal];
    }
}

- (TTFamilyBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[TTFamilyBottomView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 84)];
        _bottomView.backgroundColor = [XCTheme getTTSimpleGrayColor];
        [_bottomView.sureButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [_bottomView.sureButton setBackgroundColor:UIColorFromRGB(0xFF4362)];
        _bottomView.delegate = self;
    }
    return _bottomView;
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
