//
//  TTCreateGroupViewController.m
//  TuTu
//
//  Created by gzlx on 2018/11/3.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTCreateGroupViewController.h"
//tool
#import <Masonry/Masonry.h>
#import "XCTheme.h"
//view
#import "TTFamilyCreateGroupTableViewCell.h"
#import "TTFamilyBottomView.h"
//core
#import "FamilyCore.h"
#import "GroupCore.h"
#import "GroupCoreClient.h"
#import "FileCore.h"
#import "FileCoreClient.h"
#import "XCHUDTool.h"
#import "XCHtmlUrl.h"
#import "NSString+SpecialClean.h"
#import "MMSheetView.h"
#import "UIImage+Utils.h"
//vc
#import "TTFamilyMemberViewController.h"
#import "TTFamilyBaseAlertController.h"

@interface TTCreateGroupViewController ()<TTFamilyBottomViewDelegate, GroupCoreClient, FileCoreClient, TTFamilyCreateGroupTableViewCellDelegate, TTFamilyBaseAlertControllerDelegate, TTFamilyMemberViewControllerDelegate>
@property (nonatomic, strong) TTFamilyBottomView * bottomView;
/** 群头像*/
@property (nonatomic, strong) NSString * imageKey;
/** 群名称*/
@property (nonatomic, strong) NSString * name;
/** 是不是需要验证*/
@property (nonatomic, assign) BOOL isVerify;
/** 选择的群成员*/
@property (nonatomic, strong) NSMutableDictionary * memberDic;
@end

@implementation TTCreateGroupViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addCore];
    [self initView];
    [self initContrations];
}
#pragma mark - private method
- (void)initView{
    self.title = @"创建群";
    self.isVerify = YES;
    self.imageKey = @"https://img.erbanyy.com/family_group_icon.png";
    [self.tableView registerClass:[TTFamilyCreateGroupTableViewCell class] forCellReuseIdentifier:@"TTFamilyCreateGroupTableViewCell"];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = [XCTheme getTTSimpleGrayColor];
    [self.view addSubview:self.bottomView];
}

- (void)initContrations{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(statusbarHeight + 44);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(265);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(55+ kSafeAreaBottomHeight);
    }];
}

- (void)addCore{
    AddCoreClient(GroupCoreClient, self);
    AddCoreClient(FileCoreClient, self);
}

#pragma mark - UITableViewDelegate and UITabelViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 70;
    }else if (indexPath.row == 3){
        if (self.memberDic &&  self.memberDic.allKeys.count > 0) {
            return 101;
        }
        return 45;
    }
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TTFamilyCreateGroupTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TTFamilyCreateGroupTableViewCell"];
    if (cell == nil) {
        cell = [[TTFamilyCreateGroupTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TTFamilyCreateGroupTableViewCell"];
    }
    FamilyCreateGroupCellType grouptype;
    if (indexPath.row == 0) {
        grouptype = FamilyCreateGroupCellType_GroupImage;
    }else if(indexPath.row ==1){
        grouptype = FamilyCreateGroupCellType_GroupName;
    }else if(indexPath.row ==2){
        grouptype = FamilyCreateGroupCellType_GroupVer;
    }else{
        grouptype = FamilyCreateGroupCellType_GroupMem;
        cell.members = self.memberDic;
    }
    cell.groupType = grouptype;
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [self showPhotoView];
    }
    TTFamilyCreateGroupTableViewCell * cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    if (indexPath.row != 1) {
        [cell.textFiled resignFirstResponder];
    }
    if (indexPath.row == 3) {
        TTFamilyMemberViewController * memberVC = [[TTFamilyMemberViewController alloc] init];
        memberVC.listType = FamilyMemberListCreateGroup;
        memberVC.delegate = self;
        memberVC.selectDic = self.memberDic;
        [self.navigationController pushViewController:memberVC animated:YES];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    TTFamilyCreateGroupTableViewCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    [cell.textFiled resignFirstResponder];
}

#pragma mark - TTFamilyMemberViewControllerDelegate
- (void)chooseFamilyMemberWith:(NSMutableDictionary *)memberDic{
    self.memberDic = memberDic;
    [self.tableView reloadData];
}

#pragma mark -选择相册
- (void)showPhotoView {
    [[TTFamilyBaseAlertController defaultCenter] showChoosePhotoWith:self delegate:self];
}

#pragma mark - TTFamilyBaseAlertControllerDelegate
- (void)imagePickerControllerdidFinishPickingMediaWithInfo:(UIImage *)selectImage{
     TTFamilyCreateGroupTableViewCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.iconImageView.image = selectImage;
    [GetCore(FileCore) qiNiuUploadImage:selectImage uploadType:UploadImageTypeGroupIcon];
    [XCHUDTool showSuccessWithMessage:@"正在上传" inView:self.view delay:10 enabled:YES];
}

#pragma mark - TTFamilyCreateGroupTableViewCellDelegate
- (void)switchValueChange:(UISwitch *)verSwitch{
    self.isVerify = verSwitch.on;
}

- (void)textFiledChangeWithString:(NSString *)text{
    if (text.length > 15) {
        text = [text substringToIndex:15];
    }
    self.name = [[text cleanSpecialText] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (self.name.length > 0) {
        self.bottomView.sureButton.userInteractionEnabled = YES;
    }else{
        self.bottomView.sureButton.userInteractionEnabled = NO;
    }
}

#pragma mark - TTFamilyBottomViewDelegate
- (void)sureButtonActionWith:(UIButton *)sender{
    if (self.name.length > 0) {
        NSString * teamid = GetCore(FamilyCore).teamId;
        [GetCore(GroupCore) creatGroupByFamilyId:[teamid integerValue] icon:self.imageKey name:self.name members:self.memberDic isVerify:self.isVerify];
        self.bottomView.sureButton.userInteractionEnabled = NO;
    }else{
        [XCHUDTool showErrorWithMessage:@"请输入家族名称" inView:self.view];
    }
}

#pragma mark - FileCoreClient 7N
- (void)didUploadGroupIconImageSuccessUseQiNiu:(NSString *)key{
    NSString *url = [NSString stringWithFormat:@"%@/%@?imageslim",keyWithType(KeyType_QiNiuBaseURL, NO),key];
    self.imageKey = url;
    [XCHUDTool hideHUDInView:self.view];
}
-(void)didUploadGroupIconImageFailUseQiNiu:(NSString *)message{
    [XCHUDTool hideHUDInView:self.view];
}

#pragma mark - GroupCoreClient
- (void)creatGroupSuccess:(GroupModel *)group{
    self.bottomView.sureButton.userInteractionEnabled = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(createGroupSuccess)]) {
        [XCHUDTool showSuccessWithMessage:@"创建成功"];
        [self.navigationController popViewControllerAnimated:YES];
        [self.delegate createGroupSuccess];
    }
}
- (void)creatGroupFailth:(NSString *)message{
    self.bottomView.sureButton.userInteractionEnabled = YES;
}

#pragma mark - setters and getters
- (TTFamilyBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[TTFamilyBottomView alloc] init];
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
