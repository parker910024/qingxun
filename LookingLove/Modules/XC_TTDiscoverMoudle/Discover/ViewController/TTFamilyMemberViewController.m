//
//  TTFamilyMemberViewController.m
//  TuTu
//
//  Created by gzlx on 2018/11/7.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTFamilyMemberViewController.h"
//core
#import "AuthCore.h"
#import "FamilyCoreClient.h"

#import "GroupCore.h"
#import "GroupCoreClient.h"
//tool
#import "XCHUDTool.h"
#import "UIView+XCToast.h"
#import "XCTheme.h"
#import <Masonry/Masonry.h>
//view
#import "TTFamilyMemberTableViewCell.h"
#import "TTFamilyBottomView.h"
#import "TTFamilyMemSectionView.h"
//vc
#import "TTFamilySearchViewController.h"
#import "TTFamilyBaseAlertController.h"
#import "TTPopup.h"
#import "XCMediator+TTPersonalMoudleBridge.h"

@interface TTFamilyMemberViewController ()<
GroupCoreClient,
FamilyCoreClient,
TTFamilyBottomViewDelegate,
TTFamilyMemberTableViewCellDelegate,
TTFamilySearchViewControllerDelegate
>
/** 当前的页数*/
@property (nonatomic, assign) int currntPage;
/** 家族成员的数据源*/
@property (nonatomic, strong) NSMutableArray<XCFamilyModel *> *memberArray;
/** 底部的确认 按钮*/
@property (nonatomic, strong) TTFamilyBottomView *bottomView;
/** 成员的人数*/
@property (nonatomic, strong) NSString * memberNumber;
/** headerView*/
@property (nonatomic, strong) TTFamilyMemSectionView * sectionView;
/** 转让的数量*/
@property (nonatomic, strong) NSString * contributMon;
@end

@implementation TTFamilyMemberViewController
#pragma mark- life cycle
- (void)dealloc{
    RemoveCoreClientAll(self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addCore];
     [self initView];
    [self initContrations];
    [self configNavTitle];
   
}

#pragma mark - response
- (void)searchFamilyMemAction:(UIButton *)sender{
    TTFamilySearchViewController * seachVC = [[TTFamilySearchViewController alloc] init];
    seachVC.searchType = TTFamilySearchType_Family_Member;
    seachVC.listType = self.listType;
    seachVC.currentNav = self.navigationController;
    seachVC.delegate = self;
    seachVC.selectMemDic = self.selectDic;
    [self.navigationController presentViewController:seachVC animated:YES completion:nil];
}

#pragma mark - private method
- (void)initView{
    self.tableView.tableViewHeightOnScreen = 1;
    [self addNavigationItemWithImageNames:@[@"family_search"] isLeft:NO target:self action:@selector(searchFamilyMemAction:) tags:nil];
    self.tableView.tableHeaderView = self.sectionView;
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [XCTheme getTTSimpleGrayColor];
    [self.view addSubview:self.bottomView];
    [self.tableView registerClass:[TTFamilyMemberTableViewCell class] forCellReuseIdentifier:@"TTFamilyMemberTableViewCell"];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setupRefreshTarget:self.tableView];
    [self pullDownRefresh:1];
    
}

- (void)initContrations{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(statusbarHeight + 44);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11, *)) {
           make.left.right.mas_equalTo(self.view.mas_safeAreaLayoutGuide);
        }else{
            make.left.right.mas_equalTo(self.view);
        }
        make.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(55);
    }];
}

- (void)addCore{
    AddCoreClient(FamilyCoreClient , self);
    AddCoreClient(GroupCoreClient, self);
}

#pragma mark - 根据类型判断 需要显示什么
- (void)configNavTitle{
    if (self.listType== FamilyMemberListCreateGroup || self.listType == FamilyMemberAddGroup) {
        self.bottomView.hidden = NO;
        self.title = @"家族成员列表";
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(statusbarHeight + 44);
            make.left.right.mas_equalTo(self.view);
            make.bottom.mas_equalTo(self.view).offset(-55);
        }];
    }else{
        self.bottomView.hidden = YES;
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(statusbarHeight + 44);
            make.left.right.bottom.mas_equalTo(self.view);
        }];
        if (self.listType == FamilyMemberListFamilyRemove || self.listType == FamilyMemberListCheck){
            self.title = @"家族成员列表";
        }else if (self.listType == FamilyMemberListMoneyTransfer){
            self.title = @"选择家族成员";
        }
    }
}


#pragma Mark- UITableViewDelegate and UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.memberArray.count >0 ? 1:0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.memberArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TTFamilyMemberTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TTFamilyMemberTableViewCell"];
    if (cell == nil) {
        cell = [[TTFamilyMemberTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TTFamilyMemberTableViewCell"];
    }
    XCFamilyModel * familyModel = [self.memberArray safeObjectAtIndex:indexPath.row];
    cell.delegate = self;
    if (self.selectDic && self.selectDic.allKeys.count> 0) {
        if ([self.selectDic.allKeys containsObject:[NSString stringWithFormat:@"%@", familyModel.uid]]) {
            XCFamilyModel *selecmodel = [self.selectDic objectForKey:familyModel.uid];
            [cell configFamilyMemberWith:selecmodel];
        }else{
            [cell configFamilyMemberWith:familyModel];
        }
    }else{
        [cell configFamilyMemberWith:familyModel];
    }
    cell.listType = self.listType;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.listType == FamilyMemberListMoneyTransfer) {
        XCFamilyModel * model = [self.memberArray safeObjectAtIndex:indexPath.row];
        [self tranFamilyMonToMember:model];
    }else{
        if (self.memberArray.count > 0) {
            XCFamilyModel * model = [self.memberArray safeObjectAtIndex:indexPath.row];
            NSString *uid = [NSString stringWithFormat:@"%@",model.uid];
            if (uid.length > 0) {
                UIViewController * personVC = [[XCMediator sharedInstance] ttPersonalModule_personalViewController:uid.userIDValue];
                [self.navigationController pushViewController:personVC animated:YES];
            }
        }
        
    }
}

#pragma mark - 转让家族币
- (void)tranFamilyMonToMember:(XCFamilyModel *)familyModel{
    @weakify(self);
    NSString *  title =[NSString stringWithFormat:@"转让%@", self.familyInfor.moneyName];;
    NSString *  message = [NSString stringWithFormat:@"可转让%@: %.2f%@",self.familyInfor.moneyName, self.familyInfor.totalAmount, self.familyInfor.moneyName];
    NSString * target = [NSString stringWithFormat:@"转让给：%@", familyModel.name];
    if (familyModel.uid.userIDValue != [[GetCore(AuthCore) getUid] userIDValue]) {
        TTFamilyAlertModel * config = [[TTFamilyAlertModel alloc] init];
        config.tipString =title;
        config.content = message;
        config.contribuMember = target;
        config.isShowMon = YES;
        config.keyboardType = UIKeyboardTypeDecimalPad;
        config.familyMon = self.familyInfor.moneyName;
        config.placeHolder = @"请输入转让数量";
        config.changeColorString = [NSString stringWithFormat:@"%.2f%@",self.familyInfor.totalAmount, self.familyInfor.moneyName];
        [[TTFamilyBaseAlertController defaultCenter] showAlertViewWithTextFiledWith:self alertConfig:config sure:^{
            @strongify(self);
            [self transFamilyMoToMemberhttp:familyModel];
        } canle:nil text:^(NSString * _Nonnull text) {
            @strongify(self);
            if (text.length > 0) {
              self.contributMon = text;
            }
        }];
    }else{
        [XCHUDTool showErrorWithMessage:@"不能送给自己" inView:self.view];
        return;
    }
}

- (void)transFamilyMoToMemberhttp:(XCFamilyModel *)model{
    if ([self.contributMon floatValue] > 0) {
        if (self.listType == FamilyMemberListMoneyTransfer) {
            [GetCore(FamilyCore) transferFamilyMoenyTo:[model.uid userIDValue] andAmount:self.contributMon];
        }
    }else{
        [XCHUDTool showErrorWithMessage:@"请输入正确的金额" inView:self.view];
    }
}

#pragma mark - TTFamilySearchViewControllerDelegate
- (void)didSelectFamilyMemberWith:(XCFamilyModel *)familyMember selectDic:(NSMutableDictionary *)selectDic{
    if (self.listType == FamilyMemberListMoneyTransfer) {
        [self tranFamilyMonToMember:familyMember];
    }else if (self.listType == FamilyMemberListFamilyRemove){
        //移出家族
        if (familyMember) {
            
            NSString *content = @"移出家族后家族币将无法使用，重新加入即可还原";
            
            [TTPopup alertWithMessage:content confirmHandler:^{
                [[XCAlertControllerCenter defaultCenter] dismissAlertNeedBlock:NO andAnimate:YES];
                [GetCore(FamilyCore) removeFamilyMember:[familyMember.uid integerValue]];
            } cancelHandler:^{
            }];
        }
    }else if (self.listType == FamilyMemberListCheck){
        UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_personalViewController:familyMember.uid.userIDValue];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(self.listType == FamilyMemberAddGroup || self.listType == FamilyMemberListCreateGroup){
        if (self.memberArray <= 0) {
            return;
        }
        if (self.selectDic && [self.selectDic allKeys].count > 0) {
            if ([[self.selectDic allKeys] containsObject:familyMember.uid]) {
                XCFamilyModel * selectModel = [self.selectDic objectForKey:familyMember.uid];
                familyMember.isSelect = NO;
                [self.selectDic removeObjectForKey:familyMember.uid];
            }else{
                familyMember.isSelect = YES;
                [self.selectDic setValue:familyMember forKey:familyMember.uid];
            }
        }else{
            familyMember.isSelect = YES;
            [self.selectDic setValue:familyMember forKey:familyMember.uid];
        }
        [self.tableView reloadData];
    }
}

#pragma mark-  TTFamilyMemberTableViewCellDelegate
- (void)handleFamilyMemberTableViewWith:(XCFamilyModel *)familyModel groupModel:(GroupMemberModel *)groupModel listType:(FamilyMemberListType)listType typeButton:(UIButton *)sender{
    if (listType == FamilyMemberListFamilyRemove){
        //移出家族
        if (familyModel) {
            if ([familyModel.position integerValue] != FamilyMemberPositionOwen) {
                NSString *message = [NSString stringWithFormat:@"移出家族后家族币将不可使用，重新加入即可还原，确定要将%@移出本家族吗？", familyModel.name];
                [TTPopup alertWithMessage:message confirmHandler:^{
                    [GetCore(FamilyCore) removeFamilyMember:[familyModel.uid integerValue]];
                } cancelHandler:^{
                }];
            }
            return;
        }
    }else if(listType == FamilyMemberListCreateGroup || listType == FamilyMemberAddGroup){
        sender.selected = !sender.selected;
        if (familyModel) {
            familyModel.isSelect = sender.selected;
            if (sender.isSelected) {
                [self.selectDic setObject:familyModel forKey:[NSString stringWithFormat:@"%@", familyModel.uid]];
            }else{
                if ([self.selectDic.allKeys containsObject:familyModel.uid]) {
                    [self.selectDic removeObjectForKey:familyModel.uid];
                }
            }
        }
        return;
    }else if (listType== FamilyMemberListCheck){
        NSString *uid = [NSString stringWithFormat:@"%@",familyModel.uid];
        if (uid.length > 0) {
            UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_personalViewController:uid.userIDValue];
            [self.navigationController pushViewController:vc animated:YES];
        }
        return;
    }
}

#pragma mark - TTFamilyBottomViewDelegate
- (void)sureButtonActionWith:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(chooseFamilyMemberWith:)]) {
        [self.delegate chooseFamilyMemberWith:self.selectDic];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - FamilyCoreClinet
//踢出家族成功 刷新数据源
- (void)kickoutFamilySuccess:(NSDictionary *)successDic{
    [self pullDownRefresh:1];
}
//请求家族成员失败
- (void)demandFamilyMemberListFail:(NSString *)message status:(NSInteger)status{
    [self failEndRefreshStatus:status];
    if (self.memberArray.count == 0) {
        [self.tableView showEmptyContentToastWithTitle:@"暂无成员" andImage:[UIImage imageNamed:[[XCTheme defaultTheme] default_empty]]];
    }
    [self.tableView reloadData];
}
//请求家族成员成功
- (void)demandFamilyMemberListSuccess:(XCFamily *)memberList status:(NSInteger)status{
    if (self.currntPage == 1) {
        [self.tableView hideToastView];
        [self.memberArray removeAllObjects];
        self.memberArray = memberList.members;
    }else{
        [self.memberArray addObjectsFromArray:memberList.members];
    }
    if (memberList.members.count > 0) {
        [self.tableView endRefreshStatus:status hasMoreData:YES];
    }else{
        [self.tableView endRefreshStatus:status hasMoreData:NO];
    }
    
    if (self.memberArray.count == 0) {
        [self.tableView showEmptyContentToastWithTitle:@"暂无成员" andImage:[UIImage imageNamed:@"praised_list_empty"]];
    }
    if (self.memberArray.count > 0) {
        self.memberNumber = memberList.count;
    }else{
        self.memberNumber = @"0";
    }
    self.sectionView.titleLabel.text = @"家族成员";
    self.sectionView.subtitleLabel.text =[NSString stringWithFormat:@"%@人", self.memberNumber];
    [self.tableView reloadData];
}
//家族中的人不在群里面成功
- (void)fetchFamilyMemberNotInGroupSuccess:(XCFamily *)familInfor andStatus:(int)status isSearch:(BOOL)isSearch{
    if (!isSearch) {
        if (self.currntPage == 1) {
            [self.memberArray removeAllObjects];
            [self.tableView hideToastView];
            self.memberArray = familInfor.members;
        }else{
            [self.memberArray addObjectsFromArray:familInfor.members];
        }
        if (familInfor.members.count > 0) {
            [self.tableView endRefreshStatus:status hasMoreData:YES];
        }else{
            [self.tableView endRefreshStatus:status hasMoreData:NO];
        }
        if (self.memberArray.count == 0) {
            self.memberNumber = @"0";
            [self.tableView showEmptyContentToastWithTitle:@"家族成员已全部加入群聊" andImage:[UIImage imageNamed:[[XCTheme defaultTheme] default_empty]]];
            self.bottomView.hidden = YES;
            [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(statusbarHeight + 44);
                make.left.right.mas_equalTo(self.view);
                make.bottom.mas_equalTo(self.view);
            }];
        }else{
            self.memberNumber = familInfor.count;
            self.bottomView.hidden = NO;
            [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(statusbarHeight + 44);
                make.left.right.mas_equalTo(self.view);
                make.bottom.mas_equalTo(self.bottomView.mas_top);
            }];
        }
        self.sectionView.titleLabel.text = @"家族成员";
        self.sectionView.subtitleLabel.text =[NSString stringWithFormat:@"%@人", self.memberNumber];
        [self.tableView reloadData];
    }
}

//族长转让成功
- (void)exchangeFamilyMoneySuccess:(NSDictionary *)statusDic{
    self.contributMon = nil;
    [XCHUDTool showSuccessWithMessage:@"转让成功" inView:self.view];
    [GetCore(FamilyCore) fetchFamilyMoneyManaegerWith:[GetCore(AuthCore) getUid]];
}
- (void)exchangeFamilyMoneyFail:(NSString *)message{
    self.contributMon = nil;
}

//顶部
- (void)fetchFamilyManagerSuccess:(XCFamily *)moneyManaer{
    self.familyInfor = moneyManaer;
}

#pragma mark - http


- (void)pullDownRefresh:(int)page{
    self.currntPage = page;
    if (self.listType == FamilyMemberAddGroup) {
        [GetCore(FamilyCore) fetchFamilyMemberNotInGroupWith:self.teamId andPage:page andKey:nil andStatus:0 isSearch:NO];
    }else{
        //获取家族成员
        [GetCore(FamilyCore) fetchFamilyMemberList:[GetCore(AuthCore) getUid] page:page status:0];
    }
}

- (void)pullUpRefresh:(int)page lastPage:(BOOL)isLastPage{
    self.currntPage = page;
    if (isLastPage) {
        return;
    }
    if (self.listType == FamilyMemberAddGroup) {
        [GetCore(FamilyCore) fetchFamilyMemberNotInGroupWith:self.teamId andPage:page andKey:nil andStatus:1 isSearch:NO];
    }else{
        [GetCore(FamilyCore) fetchFamilyMemberList:[GetCore(AuthCore) getUid] page:page status:1];
    }
}

#pragma mark -setters  and getters
- (TTFamilyBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[TTFamilyBottomView alloc] init];
        _bottomView.delegate = self;
    }
    return _bottomView;
}

- (NSMutableDictionary *)selectDic{
    if (!_selectDic) {
        _selectDic = [NSMutableDictionary dictionary];
    }
    return _selectDic;
}

- (TTFamilyMemSectionView *)sectionView{
    if (!_sectionView) {
        _sectionView = [[TTFamilyMemSectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
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
