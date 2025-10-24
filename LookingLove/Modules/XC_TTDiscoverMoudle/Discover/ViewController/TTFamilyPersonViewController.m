//
//  TTFamilyPersonViewController.m
//  TuTu
//
//  Created by gzlx on 2018/11/2.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTFamilyPersonViewController.h"
//View
#import "TTFamilyEmptyTableViewCell.h"
#import "TTFamilyPatriaTableViewCell.h"
#import "TTFamilyPersonGameTableViewCell.h"
#import "TTFamilyPersonMemTableViewCell.h"
#import "TTPersonGroupTableViewCell.h"
#import "TTMyFamilyMoneyTableViewCell.h"
#import "TTFamilyPersionHeaderView.h"
#import "TTFamilyPersonSctionView.h"
#import "TTEnterFamilyView.h"
#import "TTFamilyGuideView.h"
#import "TTItemMenuView.h"
//Core
#import "FamilyCore.h"
#import "FamilyCoreClient.h"
#import "XCFamily.h"
#import "ShareModelInfor.h"
#import "ShareCore.h"
#import "GroupCore.h"
#import "GroupCoreClient.h"
#import "AuthCoreClient.h"
//Tool
#import "XCTheme.h"
#import <Masonry/Masonry.h>
#import "XCMacros.h"
#import "NSArray+Safe.h"
#import "XCHUDTool.h"
#import "TTFamilyBaseAlertController.h"
#import "TTPopup.h"
#import "XCKeyWordTool.h"
//vc
#import "TTCreateGroupViewController.h"
#import "TTFamilyMonViewController.h"
#import "TTFamilyMemberViewController.h"
#import "XCMediator+TTMessageMoudleBridge.h"
#import "XCMediator+TTPersonalMoudleBridge.h"
#import "TTFamilyShareContainViewController.h"

#import "TTStatisticsService.h"

#define TTFamilyManagerNewGuide @"TTFamilyManagerNewGuide"

@interface TTFamilyPersonViewController ()<
UITableViewDelegate,
UITableViewDataSource,
TTPersonGroupTableViewCellDelegate,
TTFamilyPersonSctionViewDelegate,
GroupCoreClient,
FamilyCoreClient,
AuthCoreClient,
TTItemMenuViewDelegate,
TTFamilyPersonMemTableViewCellDelegate,
TTCreateGroupViewControllerDelegate
>
/** 头部*/
@property (nonatomic, strong) TTFamilyPersionHeaderView * headerView;
/** 保存请求到的家族信息*/
@property (nonatomic, strong) XCFamily * familyInfor;
/** 加入家族*/
@property (nonatomic, strong) TTEnterFamilyView * enterFamilyView;
/** 区头*/
@property (nonatomic, strong) TTFamilyPersonSctionView * sectionView;
/** 加入家族或者加入群 输入的消息*/
@property (nonatomic, strong) NSString * placeHolder;
/** 退出*/
@property (nonatomic, strong) TTItemMenuView *  menuView;
@end

@implementation TTFamilyPersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addCore];
    [self initView];
    [self initContrations];
}

#pragma mark - response
- (void)rightNavButtonAction:(UIButton *)sender{
    if (sender.tag == 1001) {
        [TTFamilyBaseAlertController defaultCenter].family = self.familyInfor;
        [[TTFamilyBaseAlertController defaultCenter] shareAppcationActionSheetWith:self];
    }else{
       [self configQuitFamilyOrInviteFriend];
    }
}
/** 加入家族*/
- (void)enterFamilyViewRecognizer:(UITapGestureRecognizer *)tap{
    
    [TTStatisticsService trackEvent:TTStatisticsServiceEventFamilyJoinClick
                      eventDescribe:@"家族主页 加入家族按钮"];
    
    if (self.familyInfor.enterStatus == UserInFamilyYES) {
        return;
    }
   self.placeHolder = @"我希望加入贵家族";
    if ([self.familyInfor.verifyType integerValue] == 1) {
        NSString * message = [NSString stringWithFormat:@"确认要加入%@家族吗？", self.familyInfor.familyName];
        @weakify(self);
        TTFamilyAlertModel * config = [[TTFamilyAlertModel alloc] init];
        config.content = message;
        config.placeHolder = self.placeHolder;
        config.changeColorString = self.familyInfor.familyName;
        [[TTFamilyBaseAlertController defaultCenter] showAlertViewWithTextFiledWith:self alertConfig:config sure:^{
            @strongify(self);
            [self configEnterFamilyHttp:self.familyInfor];
        } canle:nil text:^(NSString * _Nonnull text) {
            @strongify(self);
            if (text.length > 0) {
                  self.placeHolder = text;
            }
        }];
    }else{
        [self configEnterFamilyHttp:self.familyInfor];
    }
}

#pragma mark - private method
- (void)addCore{
    AddCoreClient(FamilyCoreClient, self);
    AddCoreClient(GroupCoreClient, self);
    AddCoreClient(AuthCoreClient, self);
}

- (void)initView{
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[TTFamilyEmptyTableViewCell class] forCellReuseIdentifier:@"TTFamilyEmptyTableViewCell"];
    [self.tableView registerClass:[TTMyFamilyMoneyTableViewCell class] forCellReuseIdentifier:@"TTMyFamilyMoneyTableViewCell"];
    [self.tableView registerClass:[TTFamilyPatriaTableViewCell class] forCellReuseIdentifier:@"TTFamilyPatriaTableViewCell"];
    [self.tableView registerClass:[TTFamilyPersonMemTableViewCell class] forCellReuseIdentifier:@"TTFamilyPersonMemTableViewCell"];
    [self.tableView registerClass:[TTFamilyPersonGameTableViewCell class] forCellReuseIdentifier:@"TTFamilyPersonGameTableViewCell"];
    [self.tableView registerClass:[TTPersonGroupTableViewCell class] forCellReuseIdentifier:@"TTPersonGroupTableViewCell"];
    [self requsetFamilyInfor];

}

- (void)initContrations{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(statusbarHeight + 44);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
}

- (void)uploadNav{
    if (self.familyInfor.enterStatus == UserInFamilyYES) {
        [self addNavigationItemWithImageNames:@[@"family_person_quit",@"family_person_share"] isLeft:NO target:self action:@selector(rightNavButtonAction:) tags:@[@1000, @1001]];
        self.title = @"我的家族";
        NSArray * array = self.navigationItem.rightBarButtonItems;
    }else{
        [self addNavigationItemWithImageNames:@[@"family_person_share"] isLeft:NO target:self action:@selector(rightNavButtonAction:) tags:@[@1001]];
        self.title = self.familyInfor.familyName;
    }
}

- (void)configEnterFamilyView{
    //在家族中的话
    if (self.familyInfor.enterStatus == UserInFamilyYES) {
        [self.enterFamilyView removeFromSuperview];
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.mas_equalTo(self.view);
             make.top.mas_equalTo(statusbarHeight + 44);
        }];
    }else{
        [self.view addSubview:self.enterFamilyView];
        [self.enterFamilyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(self.view);
            make.height.mas_equalTo(73);
        }];
        
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.view).offset(-73);
            make.left.right.mas_equalTo(self.view);
            make.top.mas_equalTo(statusbarHeight + 44);
        }];
    }
}

- (void)configQuitFamilyOrInviteFriend{
    if (!self.familyInfor || self.familyInfor.enterStatus == UserInFamilyNO) {
        return;
    }
    TTItemsMenuConfig * config = [TTItemsMenuConfig creatMenuConfigWithItemHeight:35 menuWidth:130 separatorInset:UIEdgeInsetsMake(0, 0, 0, 0) separatorColor:[XCTheme getTTSimpleGrayColor] backgroudColor:[UIColor whiteColor]];
    NSArray * array;
    if (self.familyInfor.enterStatus == UserInFamilyYES && self.familyInfor.position == FamilyMemberPositionOwen) {
        
        TTItemMenuItem *quititem = [TTItemMenuItem creatWithTitle:@"解散家族" iconName:@"family_nav_dissolve" titleFont:[UIFont systemFontOfSize:14] titleColor:UIColorFromRGB(0xFF3852)];
        
        TTItemMenuItem *inviteitem = [TTItemMenuItem creatWithTitle:@"邀请好友" iconName:@"family_nav_invite" titleFont:[UIFont systemFontOfSize:14] titleColor:UIColorFromRGB(0x000000)];

        array = @[quititem, inviteitem];
    }else{
        
        TTItemMenuItem *quititem = [TTItemMenuItem creatWithTitle:@"退出家族" iconName:@"family_nav_quit" titleFont:[UIFont systemFontOfSize:14] titleColor:UIColorFromRGB(0xFF3852)];
        array = @[quititem];
    }
    TTItemMenuView * meuview = [[TTItemMenuView alloc] initWithFrame:CGRectZero withConfig:config items: [array mutableCopy]];
    meuview.delegate = self;
    self.menuView = meuview;
    [meuview showInView:self.navigationController.view];
    
}

#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //0 家族bi 1 家族game  2 家族成员  3 家族群组
    return self.familyInfor ? 4 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.familyInfor) {
        if (section == 0) {
            if (self.familyInfor.enterStatus == UserInFamilyNO) {
                return 1;
            }
            return self.familyInfor.openMoney ? 1: 0;
        }else if (section ==1){
            return self.familyInfor.openGame && self.familyInfor.games ? 1: 0;
        }else if (section == 2){
            if (self.familyInfor.enterStatus == UserInFamilyNO) {
                return 0;
            }else{
                return self.familyInfor.members.count > 0 ? 1 :0;
            }
        }else if (section == 3){
            return self.familyInfor.groups.count > 0 ? self.familyInfor.groups.count : 1;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.familyInfor) {
        if (indexPath.section == 0) {
            if (self.familyInfor.enterStatus == UserInFamilyNO) {
                return 80;
            }
            return self.familyInfor.openMoney ? 50: 0;
        }else if (indexPath.section == 1){
            return self.familyInfor.openGame && self.familyInfor.games.count > 0 ? 118: 0;
        }else if (indexPath.section == 2){
            if (self.familyInfor.enterStatus == NO) {
                return 0;
            }else{
                return self.familyInfor.members.count > 0 ? 106: 0;
            }
        }else if (indexPath.section == 3){
            return self.familyInfor.groups.count > 0 ? 75: 320;
        }
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [UIView new];
    TTFamilyPersonSctionView * sectionView = [[TTFamilyPersonSctionView alloc] initWithFrame:CGRectMake(0, 0,KScreenWidth , 54)];
    sectionView.delegate = self;
    if (self.familyInfor) {
        if (section == 0) {
            return view;
        }else if (section == 1){
            if (self.familyInfor.games.count >0) {
                sectionView.type =  TTFamilyPersonSctionView_hidden;
                sectionView.titleLabel.text = @"家族游戏";
                return sectionView;
            }
        }else if (section ==2){
            if (self.familyInfor.enterStatus == UserInFamilyYES && self.familyInfor.members.count > 0) {
                sectionView.type =  TTFamilyPersonSctionView_more;
                sectionView.titleLabel.text = [NSString stringWithFormat:@"家族成员(%@)", self.familyInfor.memberCount];;
                return sectionView;
            }
        }else if (section == 3){
            NSString * groupTitle;
            if (self.familyInfor.groups.count > 0) {
                groupTitle = [NSString stringWithFormat:@"家族群组(%ld)", self.familyInfor.groups.count];
            }else{
                groupTitle = [NSString stringWithFormat:@"家族群组(0)"];
            }
            if (self.familyInfor.enterStatus == UserInFamilyNO) {
                sectionView.type =  TTFamilyPersonSctionView_hidden;
            }else{
                if (self.familyInfor.position == FamilyMemberPositionOwen) {
                    sectionView.type =  TTFamilyPersonSctionView_create;
                }else{
                    sectionView.type =  TTFamilyPersonSctionView_hidden;
                }
            }
            sectionView.titleLabel.text = groupTitle;
            self.sectionView = sectionView;
            return sectionView;
        }
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.familyInfor) {
        if (section == 0) {
            return 0;
        }else if (section == 1){
            return self.familyInfor.games.count > 0 ? 54: 0;
        }else if(section ==2){
            if (self.familyInfor.enterStatus == UserInFamilyNO) {
                return 0;
            }
            return self.familyInfor.members.count > 0 ? 54 : 0;
        }else if (section == 3){
            return 54;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (self.familyInfor.enterStatus == UserInFamilyNO) {
            return [self configFamilyPatriaCellWith:tableView indexPath:indexPath];
        }else{
            return [self configMyFamilyMoenyCellWith:tableView indexPath:indexPath];
        }
    }else if (indexPath.section == 1){
        return [self configFamilyPersonGameCellWith:tableView indexPath:indexPath];
    }else if (indexPath.section ==2){
          return [self configFamilyPersonMemberCellWith:tableView indexPath:indexPath];
    }else{
        if (self.familyInfor.groups.count > 0) {
            return [self configFamilyGroupCellWith:tableView indexPath:indexPath];
        }else{
            return [self configFamilyEmptyCellWith:tableView indexPath:indexPath];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (self.familyInfor.enterStatus == UserInFamilyYES && self.familyInfor.openMoney) {
            TTFamilyMonViewController * monVC =[[TTFamilyMonViewController alloc] init];
            if (self.familyInfor.position == FamilyMemberPositionOwen) {
                monVC.ownerType = FamilyMoneyOwnerManager;
            }else{
                monVC.ownerType = FamilyMoneyOwnerMe;
            }
            [self.navigationController pushViewController:monVC animated:YES];
        }else{
            UIViewController * controller = [[XCMediator sharedInstance] ttPersonalModule_personalViewController:[self.familyInfor.leader.uid integerValue]];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }else if(indexPath.section ==3){
        if (self.familyInfor.groups.count > 0) {
            XCFamilyModel * familyModel = [self.familyInfor.groups safeObjectAtIndex:indexPath.row];
            if (familyModel.isExists) {
                UIViewController * controller = [[XCMediator sharedInstance] ttMessageMoudle_TTSessionViewController:[familyModel.tid integerValue] sessectionType:NIMSessionTypeTeam];
                [self.navigationController pushViewController:controller animated:YES];
            }
        }
    }
}

#pragma mark - TTItemMenuViewDelegate
- (void)menuView:(TTItemMenuView *)addMenuView didSelectedItem:(TTItemMenuItem *)item{
    if ([item.title isEqualToString:@"邀请好友"]) {
        ShareModelInfor * model = [[ShareModelInfor alloc] init];
        model.currentVC = self;
        model.familyInfor = self.familyInfor;
        model.shareType = Custom_Noti_Sub_Share_Family;
        model.Type = XCShare_Type_Invite;
        model.memberType = FamilyMemberPositionOwen;
        [GetCore(ShareCore) reloadShareModel:model];
        TTFamilyShareContainViewController * shareVC = [[TTFamilyShareContainViewController alloc] init];
        shareVC.shareType = XCShare_Type_Invite;
        [self.navigationController pushViewController:shareVC animated:YES];
    }else{
        if ([item.title isEqualToString:@"解散家族"]) {
            NSDictionary * dic = GetCore(FamilyCore).serviceDic;
            XCFamilyModel * model = dic[@"online"];
            if (model == nil) {
                return;
            }
            
            TTAlertConfig *config = [[TTAlertConfig alloc] init];
            config.message = [NSString stringWithFormat:@"需要联系%@客服才能解散家族哦~ \n %@家族客服：ID %@", [XCKeyWordTool sharedInstance].myAppName,[XCKeyWordTool sharedInstance].myAppName,model.content];
            config.confirmButtonConfig.title = @"联系客服";
            
            @weakify(self);
            [TTPopup alertWithConfig:config confirmHandler:^{
                @strongify(self);
                UIViewController *vc = [[XCMediator sharedInstance] ttMessageMoudle_TTSessionViewController:model.uid.userIDValue sessectionType:NIMSessionTypeP2P];
                [self.navigationController pushViewController:vc animated:YES];
            } cancelHandler:^{
            }];
            
        }else if ([item.title isEqualToString:@"退出家族"]){
            TTAlertConfig *config = [[TTAlertConfig alloc] init];
            config.message = @"退出家族后您的家族币将无法使用重新加入即可还原，你真的要退出吗？";
            
            TTAlertMessageAttributedConfig *attConfig = [[TTAlertMessageAttributedConfig alloc] init];
            attConfig.text = @"家族币将无法使用";
            attConfig.font = [UIFont boldSystemFontOfSize:14];
            
            [TTPopup alertWithConfig:config confirmHandler:^{
                [GetCore(FamilyCore) quitFamily];
            } cancelHandler:^{
            }];
        }
    }
}

#pragma mark - TTFamilyPersonSctionViewDelegate
- (void)touchViewPushMoreOrCreateGroupAction:(TTFamilyPersonSctionViewType)type{
    if (type == TTFamilyPersonSctionView_create) {
        TTCreateGroupViewController * createGroupVC = [[TTCreateGroupViewController alloc] init];
        createGroupVC.delegate = self;
        [self.navigationController pushViewController:createGroupVC animated:YES];
    }else if (type == TTFamilyPersonSctionView_more){
        TTFamilyMemberViewController * memberVC = [[TTFamilyMemberViewController alloc] init];
        if (self.familyInfor.position == FamilyMemberPositionOwen) {
            memberVC.listType = FamilyMemberListFamilyRemove;
        }else{
            memberVC.listType = FamilyMemberListCheck;
        }
        [self.navigationController pushViewController:memberVC animated:YES];
    }
}

#pragma mark - TTCreateGroupViewControllerDelegate
- (void)createGroupSuccess{
      [GetCore(FamilyCore) checktFamilyInforWith:self.familyId];
}

#pragma mark - TTFamilyPersonMemTableViewCellDelegate
- (void)didSelectFamilyMemberWith:(XCFamilyModel *)familyMolde{
    if (familyMolde) {
        UIViewController * controller = [[XCMediator sharedInstance] ttPersonalModule_personalViewController:[familyMolde.uid userIDValue]];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark - AuthCoreClient
- (void)onLogout{
    if (self.menuView.isShow) {
        [self.menuView dismiss];
    }
}

- (void)onKicked{
    if (self.menuView.isShow) {
        [self.menuView dismiss];
    }
}

#pragma mark - GroupCoreClient
- (void)updateGroupDataSuccess:(GroupModel *)group{
     [GetCore(FamilyCore) checktFamilyInforWith:self.familyId];
}
//删除成功
- (void)deleteGroupSuccessWithTeamId:(NSInteger)teamId sessionId:(NSInteger)sessionId{
    if (self.familyInfor.position == FamilyMemberPositionOwen) {
        [GetCore(FamilyCore) checktFamilyInforWith:self.familyId];
    }
}
//加入成功
- (void)enterFamilyGroupSuccess:(NSDictionary *)dic andGroupInfor:(XCFamilyModel *)model{
    if (model.isVerify) {
        [XCHUDTool showSuccessWithMessage:@"群申请成功，待族长审核" inView:self.view];
    }
}

#pragma mark - FamilyCoreClient
//加入家族的申请 接口请求成功
- (void)enterFamilySuccess:(NSDictionary *)successDic{
    if ([self.familyInfor.verifyType integerValue] == 1) {
        [XCHUDTool showSuccessWithMessage:@"申请提交成功， 待族长审核" inView:self.view];
    }
}
//接口请求成功之后 如果不需要验证话 直接会发个自定义消息 如果需要验证的话 族长同意之后 所发的自定义的消息
- (void)reciveFamilyCustomMessageWith:(MessageParams *)messageDic{
    if ([self isCurrentViewControllerVisible]) {
        [self.menuView removeFromSuperview];
        if (self.familyInfor.position == FamilyMemberPositionMember) {
            if (messageDic.actionType == FamilyNotificationType_BeKicked || messageDic.actionType == FamilyNotificationType_Outer) {
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
        }else{
            if (messageDic.actionType == FamilyNotificationType_Dismiss) {
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
        }
    }
    [GetCore(FamilyCore) checktFamilyInforWith:messageDic.familyId];
}

-(BOOL)isCurrentViewControllerVisible{
    return (self.isViewLoaded && self.view.window);
}

- (void)reciveMeesageReloadFamilyMoney:(MessageParams *)message{
    if (self.familyInfor.enterStatus == UserInFamilyYES) {
        if (self.familyInfor.position == FamilyMemberPositionOwen) {
            [GetCore(FamilyCore) checktFamilyInforWith:message.familyId];
        }else{
            if (message.actionType == FamilyNotificationType_Trade_Money || message.actionType == FamilyNotificationType_Donate_Money) {
                [GetCore(FamilyCore) checktFamilyInforWith:message.familyId];
            }
        }
    }
}
//族长分配
- (void)exchangeFamilyMoneySuccess:(NSDictionary *)statusDic{
    if (self.familyInfor.enterStatus == UserInFamilyYES &&self.familyId) {
        [self requsetFamilyInfor];
    }
}

//成员贡献
- (void)memberContributeFamilyMoneySuccess:(NSDictionary *)dic{
    if (self.familyInfor.enterStatus == UserInFamilyYES &&self.familyId) {
        [self requsetFamilyInfor];
    }
}

- (void)getfamilyInforSuccess:(XCFamily *)familyModel{
    if (familyModel) {
        [self.headerView configTTFamilypersonHeaderViewWithFamily:familyModel];
    }
    self.familyInfor = familyModel;
    //重新配置下nav
    [self uploadNav];
    [self configEnterFamilyView];
    [self.tableView reloadData];
    if (projectType() != ProjectType_LookingLove || projectType() != ProjectType_Planet) {
        [self showFamilyGuideView];
    }
}

#pragma mark -家族族张引导
- (void)showFamilyGuideView{
    NSString * key = [NSString stringWithFormat:@"%@", TTFamilyManagerNewGuide];
    if (!(self.isViewLoaded && self.view.window)) {
        return;
    }
    if (self.familyInfor) {
        if (self.familyInfor.enterStatus == UserInFamilyYES && self.familyInfor.position == FamilyMemberPositionOwen) {
            BOOL isPlay = [[NSUserDefaults standardUserDefaults] boolForKey:key];
            if (!isPlay) {
                TTFamilyGuideView * guide = [[TTFamilyGuideView alloc] init];
                UIView * view = [UIApplication sharedApplication].delegate.window;
                @weakify(self);
                [guide showInView:view maskBtn:nil guideType:FamilyGuideType_Share dismiss:^(BOOL isShow) {
                    if (isShow) {
                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:key];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        @strongify(self);
                        TTFamilyGuideView * managerView = [[TTFamilyGuideView alloc] init];
                        [managerView showInView:view maskView:self.headerView.managerView guideType:FamilyGuideType_Manager dismiss:^(BOOL isShow) {
                            @strongify(self);
                            if (isShow) {
                                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:key];
                                [[NSUserDefaults standardUserDefaults] synchronize];
                                NSIndexPath * dayOne = [NSIndexPath indexPathForRow:0 inSection:3];
                                [self.tableView scrollToRowAtIndexPath:dayOne atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                                [self performSelector:@selector(showCreate) withObject:self afterDelay:0.2];
                              
                            }
                        }];
                    }
                }];
            }
        }
    }
    return;
}

- (void)showCreate{
    NSString * key = [NSString stringWithFormat:@"%@", TTFamilyManagerNewGuide];
     UIView * view = [UIApplication sharedApplication].delegate.window;
    TTFamilyGuideView  * managerView = [[TTFamilyGuideView alloc] init];
    [managerView showInView:view maskView:self.sectionView.subTitleLabel guideType:FamilyGuideType_Group dismiss:^(BOOL isShow) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
}

#pragma mark - TTPersonGroupTableViewCellDelegate
//加入群
- (void)enterFamilyGroupWithFamilyModel:(XCFamilyModel *)group{
    if (self.familyInfor.enterStatus == UserInFamilyYES) {
        if (group.isVerify) {
            NSString * message = [NSString stringWithFormat:@"确定要加入%@群吗？", group.name];
            self.placeHolder = @"我希望加入群聊";
            @weakify(self);
            TTFamilyAlertModel * config = [[TTFamilyAlertModel alloc] init];
            config.content = message;
            config.rightConfigDic = @{@"text":@"确定加入"};
            config.placeHolder = self.placeHolder;
             config.changeColorString = [NSString stringWithFormat:@"%@", group.name];
            [[TTFamilyBaseAlertController defaultCenter] showAlertViewWithTextFiledWith:self alertConfig:config sure:^{
                @strongify(self);
                 [GetCore(GroupCore) enterFamilyGroupWith:[group.id integerValue] message:self.placeHolder group:group];
            } canle:nil text:^(NSString * _Nonnull text) {
                if (text.length > 0) {
                    self.placeHolder = text;
                }
            }];
           
            
        }else{
            [GetCore(GroupCore) enterFamilyGroupWith:[group.id integerValue] message:@"" group:group];
        }
    }else{
        //如果没在家族中的话 并且加入家族中不需要验证 并且加入群的也不需要验证
        if ([self.familyInfor.verifyType integerValue] == 0) {
            if (group.isVerify) {
                NSString * message = [NSString stringWithFormat:@"你还没加入“%@”？\n 申请入群需要族长同意加入家族后才可以入群，确认申请加入吗？", group.name];
               self.placeHolder = @"我希望加入群聊";
                TTFamilyAlertModel * config = [[TTFamilyAlertModel alloc] init];
                config.content = message;
                config.rightConfigDic = @{@"title":@"确定加入"};
                 config.changeColorString = [NSString stringWithFormat:@"“%@”", group.name];
                @weakify(self);
                [[TTFamilyBaseAlertController defaultCenter] showAlertViewWithTextFiledWith:self alertConfig:config sure:^{
                    @strongify(self);
                    [GetCore(GroupCore) enterFamilyGroupWith:[group.id integerValue] message:self.placeHolder group:group];
                } canle:nil text:^(NSString * _Nonnull text) {
                    if (text.length > 0) {
                        self.placeHolder = text;
                    }
                }];
            }else{
                [GetCore(GroupCore) enterFamilyGroupWith:[group.id integerValue] message:@"" group:group];
            }
        }else{
            NSString * message = [NSString stringWithFormat:@"您还未加入“%@”？\n 申请入群需要族长同意加入家族后才可以入群，确认申请加入吗？", group.name];
            self.placeHolder = @"我希望加入贵家族";
            @weakify(self);
            TTFamilyAlertModel * config = [[TTFamilyAlertModel alloc] init];
            config.content = message;
            config.rightConfigDic = @{@"title":@"确定加入"};
            config.changeColorString = [NSString stringWithFormat:@"“%@”", group.name];
            [[TTFamilyBaseAlertController defaultCenter] showAlertViewWithTextFiledWith:self alertConfig:config sure:^{
                @strongify(self);
                [GetCore(GroupCore) enterFamilyGroupWith:[group.id integerValue] message:self.placeHolder group:group];
            } canle:nil text:^(NSString * _Nonnull text) {
                if (text.length > 0) {
                    self.placeHolder = text;
                }
            }];
        }
    }
}

//家族群组为空
- (TTFamilyEmptyTableViewCell *)configFamilyEmptyCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    TTFamilyEmptyTableViewCell * cell = [tableView  dequeueReusableCellWithIdentifier:@"TTFamilyEmptyTableViewCell"];
    if (cell == nil) {
        cell = [[TTFamilyEmptyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TTFamilyEmptyTableViewCell"];
    }
    cell.iconImageView.image = [UIImage imageNamed:@"family_person_emptygroup"];
    cell.titleLabel.text = @"暂无家族群哦~";
    return cell;
}

- (TTFamilyPatriaTableViewCell *)configFamilyPatriaCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    TTFamilyPatriaTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TTFamilyPatriaTableViewCell"];
    if (cell == nil) {
        cell = [[TTFamilyPatriaTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TTFamilyPatriaTableViewCell"];
    }
    [cell configTTFamilyPatriaTableViewCellWithFamily:self.familyInfor];
    return cell;
}

- (TTFamilyPersonGameTableViewCell *)configFamilyPersonGameCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    TTFamilyPersonGameTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TTFamilyPersonGameTableViewCell"];
    if (cell == nil) {
        cell = [[TTFamilyPersonGameTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TTFamilyPersonGameTableViewCell"];
    }
    cell.currentVC = self;
    [cell configTTFamilyPersonGameTableViewCellGameArray:self.familyInfor.games];
    return cell;
}

- (TTFamilyPersonMemTableViewCell *)configFamilyPersonMemberCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    TTFamilyPersonMemTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TTFamilyPersonMemTableViewCell"];
    if (cell == nil) {
        cell = [[TTFamilyPersonMemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TTFamilyPersonMemTableViewCell"];
    }
    cell.delegate = self;
    [cell configTTFamilyPersonMemTableViewCellWith:self.familyInfor.members];
    return cell;
}

- (TTPersonGroupTableViewCell *)configFamilyGroupCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    TTPersonGroupTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TTPersonGroupTableViewCell"];
    if (cell == nil) {
        cell = [[TTPersonGroupTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TTPersonGroupTableViewCell"];
    }
    [cell configTTPersonGroupTableViewCellWithfamilyModel:[self.familyInfor.groups safeObjectAtIndex:indexPath.row]];
    cell.delegate = self;
    return cell;
}

- (TTMyFamilyMoneyTableViewCell *)configMyFamilyMoenyCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    TTMyFamilyMoneyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TTMyFamilyMoneyTableViewCell"];
    if (cell == nil) {
        cell = [[TTMyFamilyMoneyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TTMyFamilyMoneyTableViewCell"];
    }
    [cell configTTMyFamilyMoneyTableViewCellWithFamilyModel:self.familyInfor];
    return cell;
}

#pragma mar - http
- (void)requsetFamilyInfor{
     [GetCore(FamilyCore) checktFamilyInforWith:self.familyId];
}

- (void)configEnterFamilyHttp:(XCFamily *)family{
    if (family) {
        [GetCore(FamilyCore) enterFamilyWith:self.placeHolder teamId:family.familyId];
    }
}

#pragma mark - setters and getters
- (TTFamilyPersionHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[TTFamilyPersionHeaderView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 176)];
        _headerView.controtroller = self;
    }
    return _headerView;
}

- (TTEnterFamilyView *)enterFamilyView{
    if (!_enterFamilyView) {
        _enterFamilyView = [[TTEnterFamilyView alloc] init];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterFamilyViewRecognizer:)];
        [_enterFamilyView addGestureRecognizer:tap];
    }
    return _enterFamilyView;
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
