//
//  TTFamilyInforViewController.m
//  TuTu
//
//  Created by gzlx on 2018/11/5.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTFamilyInforViewController.h"
#import "TTFamilyCreateGroupTableViewCell.h"
//tool
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "MMSheetView.h"
#import "XCHtmlUrl.h"
#import "XCHUDTool.h"
#import "UIImage+Utils.h"
#import "NSString+SpecialClean.h"
#import "XCKeyWordTool.h"
//core
#import "XCFamily.h"
#import "FamilyCore.h"
#import "FamilyCoreClient.h"
#import "FileCore.h"
#import "FileCoreClient.h"
//vc
#import "TTFamilyEditViewController.h"
#import "TTFamilyMemberViewController.h"
#import "TTFamilyBaseAlertController.h"
#import "TTPopup.h"

#import "XCMediator+TTMessageMoudleBridge.h"

@interface TTFamilyInforViewController ()<TTFamilyBaseAlertControllerDelegate,FileCoreClient, FamilyCoreClient,UITableViewDelegate, UITableViewDataSource,TTFamilyCreateGroupTableViewCellDelegate, TTFamilyEditViewControllerDelegate>
@property (nonatomic, strong) UIButton * quitButton;
@property (nonatomic, strong) XCFamily * familyInfor;
@end

@implementation TTFamilyInforViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addCore];
    [self initView];
    [self initContrations];
}
#pragma mark - response
- (void)quitButtonAction:(UIButton *)sender{
    NSDictionary * dic = GetCore(FamilyCore).serviceDic;
    XCFamilyModel * model = dic[@"online"];
    if (model== nil) {
        return;
    }
    
    TTAlertConfig *config = [[TTAlertConfig alloc] init];
    config. message = [NSString stringWithFormat:@"需要联系%@客服才能解散家族哦~ \n %@家族客服：ID %@", [XCKeyWordTool sharedInstance].myAppName,[XCKeyWordTool sharedInstance].myAppName,model.content];
    
    config.confirmButtonConfig.title = @"联系客服";
    
    @weakify(self);
    [TTPopup alertWithConfig:config confirmHandler:^{
        @strongify(self);
        [self contactService:model];

    } cancelHandler:^{
    }];
}

- (void)contactService:(XCFamilyModel *)model{
    UIViewController * controller = [[XCMediator sharedInstance] ttMessageMoudle_TTSessionViewController:[model.uid integerValue] sessectionType:NIMSessionTypeP2P];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - life cycle
- (void)initView{
    self.title = @"家族信息";
    self.view.backgroundColor = [XCTheme getTTSimpleGrayColor];
    [self.tableView registerClass:[TTFamilyCreateGroupTableViewCell class] forCellReuseIdentifier:@"TTFamilyCreateGroupTableViewCell"];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
      self.familyInfor = [GetCore(FamilyCore) getFamilyModel];
    [self.view addSubview:self.quitButton];
}

- (void)addCore{
    AddCoreClient(FamilyCoreClient, self);
    AddCoreClient(FileCoreClient, self);
}

- (void)initContrations{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(statusbarHeight + 44);
        make.height.mas_equalTo(160);
    }];
    
    [self.quitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(15);
        make.right.mas_equalTo(self.view).offset(-15);
        make.bottom.mas_equalTo(self.view).offset(-18);
        make.height.mas_equalTo(40);
    }];
}

#pragma mark - UITableViewDelegate and UITbaleViewDaytaSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 70;
    }else if (indexPath.row == 1){
        return 45;
    }else{
        return 45;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TTFamilyCreateGroupTableViewCell * familyCell = [tableView dequeueReusableCellWithIdentifier:@"TTFamilyCreateGroupTableViewCell"];
    if (familyCell == nil) {
        familyCell = [[TTFamilyCreateGroupTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TTFamilyCreateGroupTableViewCell"];
    }
    familyCell.delegate = self;
    if (indexPath.row == 0) {
        familyCell.groupType = FamilyCreateGroupCellType_GroupImage;
        familyCell.titleLabel.text = @"家族主页头像";
        [familyCell configFamilyInforWith:self.familyInfor.familyIcon];
    }else if (indexPath.row == 1){
        familyCell.groupType = FamilyCreateGroupCellType_GroupMem;
        familyCell.titleLabel.text = @"家族名称";
        familyCell.numberPersonLabel.text = self.familyInfor.familyName;
    }else if (indexPath.row == 2){
        familyCell.groupType = FamilyCreateGroupCellType_GroupVer;
        familyCell.titleLabel.text = @"加入家族身份验证";
        familyCell.verSwitch.on = [self.familyInfor.verifyType boolValue];
    }
    return familyCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [self showPhotoView];
    }else if (indexPath.row == 1){
        TTFamilyEditViewController *editVC = [[TTFamilyEditViewController alloc] init];
        editVC.maxLength = 15;
        editVC.defaultText = self.familyInfor.familyName;
        editVC.delegate = self;
        editVC.title= @"编辑家族名称";
        [self.navigationController pushViewController:editVC animated:YES];
    }
}
#pragma mark - TTFamilyEditViewControllerDelegate
- (void)textFiledChangeEngEdit:(NSString *)text{
    BOOL isempty = [self isEmpty:text];
    if (isempty) {
        [XCHUDTool showErrorWithMessage:@"请输入正确的名称" inView:self.view];
        return;
    }
    text = [text cleanSpecialText];
    if (self.familyInfor.familyId.length > 0) {
        NSDictionary * dic = @{@"familyName":text, @"familyId":self.familyInfor.familyId};
        [GetCore(FamilyCore) modifyFamilyInfor:dic];
    }else{
        return;
    }
}

- (BOOL) isEmpty:(NSString *) str {
    if (!str) {
        return YES;
    }else{
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        if (trimedString.length == 0) {
            return YES;
        }else{
            return NO;
        }
    }
}


#pragma mark - TTFamilyCreateGroupTableViewCellDelegate
- (void)switchValueChange:(UISwitch *)verSwitch{
    NSString *verifyType;
    if (verSwitch.on) {
        verifyType = @"1";
    }else{
        verifyType = @"0";
    }
    NSDictionary * dic = @{@"verifyType":verifyType, @"familyId":self.familyInfor.familyId};
    [GetCore(FamilyCore) modifyFamilyInfor:dic];
}

#pragma mark - 选择图片
- (void)showPhotoView {
    [[TTFamilyBaseAlertController defaultCenter] showChoosePhotoWith:self delegate:self];
}
#pragma mark - TTFamilyBaseAlertControllerDelegate
- (void)imagePickerControllerdidFinishPickingMediaWithInfo:(UIImage *)selectImage{
    [GetCore(FileCore) qiNiuUploadImage:selectImage uploadType:UploadImageTypeFamilyIcon];
    [XCHUDTool showSuccessWithMessage:@"正在上传" inView:self.view delay:10 enabled:YES];
}

- (void)didUploadFamilyIconImageSuccessUseQiNiu:(NSString *)key{
    NSString *url = [NSString stringWithFormat:@"%@/%@?imageslim",keyWithType(KeyType_QiNiuBaseURL, NO),key];
    NSDictionary * dic =@{@"inputfile":url, @"familyId":self.familyInfor.familyId};
    [GetCore(FamilyCore) modifyFamilyInfor:dic];
}
- (void)didUploadFamilyIconImageFailUseQiNiu:(NSString *)message{
    [XCHUDTool hideHUDInView:self.view];
}

- (void)modifyFamilyInforMessageSuccess:(NSDictionary *)familyDic{
    [XCHUDTool hideHUDInView:self.view];
    if (familyDic != nil && [familyDic allKeys].count > 0) {
        [GetCore(FamilyCore) checktFamilyInforWith:self.familyInfor.familyId];
    }
}

- (void)getfamilyInforSuccess:(XCFamily *)familyModel{
    self.familyInfor = familyModel;
    [self.tableView reloadData];
}

- (void)modifyFamilyInforMessageFail{
    [XCHUDTool hideHUDInView:self.view];
}


#pragma mark - setters
- (UIButton *)quitButton{
    if (!_quitButton) {
        _quitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_quitButton setTitle:@"解散家族" forState:UIControlStateNormal];
        [_quitButton setTitle:@"解散家族" forState:UIControlStateSelected];
        [_quitButton setTitleColor:UIColorFromRGB(0xFF3852) forState:UIControlStateSelected];
        [_quitButton setTitleColor:UIColorFromRGB(0xFF3852) forState:UIControlStateNormal];
        [_quitButton setBackgroundColor:[UIColor whiteColor]];
        _quitButton.layer.cornerRadius = 20;
        _quitButton.layer.masksToBounds= YES;
        [_quitButton addTarget:self action:@selector(quitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _quitButton;
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
