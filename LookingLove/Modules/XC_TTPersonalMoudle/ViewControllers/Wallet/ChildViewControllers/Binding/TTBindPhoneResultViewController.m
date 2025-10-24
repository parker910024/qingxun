//
//  TTBindPhoneResultViewController.m
//  TuTu
//
//  Created by lee on 2018/11/7.
//  Copyright © 2018 YiZhuan. All rights reserved.
//
// 绑定手机

#import "TTBindPhoneResultViewController.h"

#import "TTBindingPhoneViewController.h"
#import "TTWalletEnumConst.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"

// core
#import "UserInfo.h"

@interface TTBindPhoneResultViewController ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UIButton *changePhoneBtn;

@end

@implementation TTBindPhoneResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"绑定手机";
    [self initViews];
    [self initConstraints];
    _phoneLabel.text = _userInfo.phone;
}

#pragma mark -
#pragma mark lifeCycle
- (void)initViews {
 
    [self.view addSubview:self.containerView];
    [self.containerView addSubview:self.iconImageView];
    [self.containerView addSubview:self.titleLabel];
    [self.containerView addSubview:self.phoneLabel];
    [self.containerView addSubview:self.changePhoneBtn];
}

- (void)initConstraints {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11, *)) {
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kSafeTopBarHeight, 0, 0, 0));
        }
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(50);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(135, 130));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(39);
    }];
    
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(11);
    }];
    
    [self.changePhoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.phoneLabel.mas_bottom).offset(41);
        make.left.right.mas_equalTo(0).inset(32);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(45);
    }];
}

#pragma mark -
#pragma mark clients

#pragma mark -
#pragma mark private methods

#pragma mark -
#pragma mark button click events
- (void)changePhoneBtnClickAction:(UIButton *)btn {
    // 跳转验证手机号
    TTBindingPhoneViewController *vc = [[TTBindingPhoneViewController alloc] init];
    vc.userInfo = _userInfo;
    vc.bindingPhoneNumType = TTBindingPhoneNumTypeConfirm;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
#pragma mark getter & setter

- (UIView *)containerView
{
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor whiteColor];
    }
    return _containerView;
}
- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BindingPhone_BigIcon"]];
    }
    return _iconImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"您当前绑定的手机号为";
        _titleLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        _titleLabel.font = [UIFont systemFontOfSize:14.f];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)phoneLabel
{
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc] init];
        _phoneLabel.textColor = [XCTheme getTTMainColor];
        _phoneLabel.font = [UIFont boldSystemFontOfSize:18.f];
        _phoneLabel.adjustsFontSizeToFitWidth = YES;
        _phoneLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _phoneLabel;
}

- (UIButton *)changePhoneBtn {
    if (!_changePhoneBtn) {
        _changePhoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changePhoneBtn setTitle:@"更改手机号码" forState:UIControlStateNormal];
        [_changePhoneBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_changePhoneBtn.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
        [_changePhoneBtn setBackgroundColor:[XCTheme getTTMainColor]];
        _changePhoneBtn.layer.masksToBounds = YES;
        _changePhoneBtn.layer.cornerRadius = 22.5;
        [_changePhoneBtn addTarget:self action:@selector(changePhoneBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changePhoneBtn;
}

@end
