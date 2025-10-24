//
//  TTGameAlertViewController.m
//  TTPlay
//
//  Created by new on 2019/3/27.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTGameAlertViewController.h"
#import <Masonry/Masonry.h> // 约束
#import "XCMacros.h" // 约束的宏定义
#import "XCTheme.h" // 颜色设置的宏定义
#import "TTGameStaticTypeCore.h"
#import "NSArray+Safe.h"

@interface TTGameAlertViewController ()

@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIView *selectView;
@property (nonatomic, strong) UIView *btnBackView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *unlimitedBtn;
@property (nonatomic, strong) UIButton *womenButton;
@property (nonatomic, strong) UIButton *menButton;
@property (nonatomic, strong) NSMutableArray *btnArray;
@end

@implementation TTGameAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initView];
    
    [self initConstraint];
    
    self.view.backgroundColor = UIColorRGBAlpha(0xffffff, 0);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenSelfAction)];
    [self.view addGestureRecognizer:tap];
}

- (void)hiddenSelfAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)initView{
    [self.view addSubview:self.cancelButton];
    [self.view addSubview:self.selectView];
    [self.selectView addSubview:self.titleLabel];
    [self.selectView addSubview:self.btnBackView];
    [self.btnBackView addSubview:self.womenButton];
    [self.btnBackView addSubview:self.unlimitedBtn];
    [self.btnBackView addSubview:self.menButton];
    
    [self.btnArray addObject:self.unlimitedBtn];
    [self.btnArray addObject:self.womenButton];
    [self.btnArray addObject:self.menButton];
}

- (void)initConstraint{
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(50);
        make.bottom.mas_equalTo(- (15 + kSafeAreaBottomHeight));
    }];
    
    [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(137);
        make.bottom.mas_equalTo(self.cancelButton.mas_top).offset(-15);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.height.mas_equalTo(16);
        make.centerX.mas_equalTo(self.selectView);
    }];
    
    [self.btnBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(24);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(44);
    }];
    
    [self.womenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.centerX.mas_equalTo(self.btnBackView);
        make.width.mas_equalTo((KScreenWidth - 62) / 3);
    }];
    
    [self.unlimitedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(self.womenButton.mas_width);
    }];
    
    [self.menButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(self.womenButton.mas_width);
    }];
    [self changeSelect];
}

- (void)changeSelect{
    for (int i = 0; i < self.btnArray.count; i++) {
        UIButton *button = [self.btnArray safeObjectAtIndex:i];
        button.selected = NO;
        button.backgroundColor = UIColorFromRGB(0xF5F5F5);
        [button setTitleColor:UIColorRGBAlpha(0x333333, 0.3) forState:UIControlStateNormal];
    }
    switch ([[[NSUserDefaults standardUserDefaults] objectForKey:@"genderIndexSex"] integerValue]) {
        case 1:
            self.menButton.backgroundColor = UIColorFromRGB(0x4FC4FF);
            [self.menButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
            break;
        case 2:
            self.womenButton.backgroundColor = UIColorFromRGB(0x4FC4FF);
            [self.womenButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
            break;
        case 3:
            self.unlimitedBtn.backgroundColor = UIColorFromRGB(0x4FC4FF);
            [self.unlimitedBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

#pragma mark --- button action --
- (void)cancelButtonAction:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)unlimitedBtnAction:(UIButton *)sender{
    [self buttonSelectTypeSwitch:sender];
    [[NSUserDefaults standardUserDefaults] setObject:@"3" forKey:@"genderIndexSex"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)womenButtonAction:(UIButton *)sender{
    [self buttonSelectTypeSwitch:sender];
    [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"genderIndexSex"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)menButtonAction:(UIButton *)sender{
    [self buttonSelectTypeSwitch:sender];
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"genderIndexSex"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)buttonSelectTypeSwitch:(UIButton *)sender{
    for (int i = 0; i < self.btnArray.count; i++) {
        UIButton *button = [self.btnArray safeObjectAtIndex:i];
        button.selected = NO;
        button.backgroundColor = UIColorFromRGB(0xF5F5F5);
        [button setTitleColor:UIColorRGBAlpha(0x333333, 0.3) forState:UIControlStateNormal];
    }
    sender.backgroundColor = UIColorFromRGB(0x4FC4FF);
    [sender setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
}

#pragma mark -- setter --
- (UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:@"确定" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:UIColorFromRGB(0x4D4D4D) forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _cancelButton.layer.cornerRadius = 14;
        _cancelButton.backgroundColor = UIColorFromRGB(0xffffff);
        [_cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIView *)selectView{
    if (!_selectView) {
        _selectView = [[UIView alloc] init];
        _selectView.backgroundColor = [UIColor whiteColor];
        _selectView.layer.cornerRadius = 14;
    }
    return _selectView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"性别筛选";
        _titleLabel.textColor = [XCTheme getTTMainTextColor];
        _titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _titleLabel;
}

- (UIView *)btnBackView{
    if (!_btnBackView) {
        _btnBackView = [[UIView alloc] init];
        _btnBackView.backgroundColor = UIColorRGBAlpha(0xffffff, 0);
        _btnBackView.layer.cornerRadius = 10;
        _btnBackView.clipsToBounds = YES;
    }
    return _btnBackView;
}

- (UIButton *)unlimitedBtn{
    if (!_unlimitedBtn) {
        _unlimitedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_unlimitedBtn setTitle:@"不限" forState:UIControlStateNormal];
        [_unlimitedBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        _unlimitedBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _unlimitedBtn.backgroundColor = UIColorFromRGB(0x4FC4FF);
        [_unlimitedBtn addTarget:self action:@selector(unlimitedBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _unlimitedBtn;
}

- (UIButton *)womenButton{
    if (!_womenButton) {
        _womenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_womenButton setTitle:@"女" forState:UIControlStateNormal];
        [_womenButton setTitleColor:UIColorRGBAlpha(0x333333, 0.3) forState:UIControlStateNormal];
        _womenButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _womenButton.backgroundColor = UIColorFromRGB(0xF5F5F5);
        [_womenButton addTarget:self action:@selector(womenButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _womenButton;
}

- (UIButton *)menButton{
    if (!_menButton) {
        _menButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_menButton setTitle:@"男" forState:UIControlStateNormal];
        [_menButton setTitleColor:UIColorRGBAlpha(0x333333, 0.3) forState:UIControlStateNormal];
        _menButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _menButton.backgroundColor = UIColorFromRGB(0xF5F5F5);
        [_menButton addTarget:self action:@selector(menButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _menButton;
}

- (NSMutableArray *)btnArray{
    if (!_btnArray) {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
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
