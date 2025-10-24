//
//  TTPerfectUserViewController.m
//  TuTu
//
//  Created by Macx on 2018/10/29.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTPerfectUserViewController.h"
#import "TTFullinUserViewController.h"

// core
#import "AuthCore.h"
#import "AuthCoreClient.h"

#import "XCTheme.h"
#import <Masonry/Masonry.h>
#import "XCMacros.h"

#import "UIImage+_1x1Color.h"

@interface TTPerfectUserViewController ()
/** backButton */
@property (nonatomic, strong) UIButton *backButton;
/** title */
@property (nonatomic, strong) UILabel *titleLabel;
/** man */
@property (nonatomic, strong) UIButton *manButton;
/** woman */
@property (nonatomic, strong) UIButton *womanButton;
/** tipLabel */
@property (nonatomic, strong) UILabel *tipLabel;
/** tip */
@property (nonatomic, strong) UIImageView *tipImageView;

/** 是否选择是男性 */
@property (nonatomic, assign) BOOL isMan;
@property (strong, nonatomic) WeChatUserInfo *weChatInfo;
@property (strong, nonatomic) QQUserInfo *qqInfo;

/** next */
@property (nonatomic, strong) UIButton *nextButton;

@end

@implementation TTPerfectUserViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    [self initConstrations];
    
    [self judgeIsThridPartLogin];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    //Remove Client Here
}

#pragma mark - public methods

#pragma mark - [系统控件的Protocol]   //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - [自定义控件的Protocol] //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - [core相关的Protocol]  //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - event response
- (void)didClickNextButton:(UIButton *) button {
    TTFullinUserViewController * vc = [[TTFullinUserViewController alloc] init];
    vc.isMan = self.isMan;
    vc.weChatInfo = self.weChatInfo;
    vc.qqInfo = self.qqInfo;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didClickManSelectButton:(UIButton *)btn {
    self.isMan = YES;
}

- (void)didClickWomanSelectButton:(UIButton *)btn {
    self.isMan = NO;
}

- (void)didClickBackButton:(UIButton *)btn {
    [self dismissViewControllerAnimated:YES completion:^{
        [GetCore(AuthCore) logout];
    }];
}

#pragma mark - private method

- (void)initView {
    [self.view addSubview:self.backButton];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.manButton];
    [self.view addSubview:self.womanButton];
    [self.view addSubview:self.nextButton];
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.tipImageView];
    
    [self.nextButton addTarget:self action:@selector(didClickNextButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.manButton addTarget:self action:@selector(didClickManSelectButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.womanButton addTarget:self action:@selector(didClickWomanSelectButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.backButton addTarget:self action:@selector(didClickBackButton:) forControlEvents:UIControlEventTouchUpInside];
    
    self.nextButton.enabled = NO;
}

- (void)initConstrations {
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(5);
        make.top.mas_equalTo(self.view).offset(8 + statusbarHeight);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(28);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (KScreenWidth <= 320) {
            make.top.mas_equalTo(self.view).offset(75);
        }else{
            make.top.mas_equalTo(self.view).offset(75 + statusbarHeight);
        }
        make.left.mas_equalTo(self.view).offset(35);
    }];
    
    CGFloat margin = (KScreenWidth - 87 * 2) / 3;
    [self.manButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(75);
        make.left.mas_equalTo(self.view).offset(margin);
        make.width.height.mas_equalTo(87);
    }];
    
    [self.womanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(75);
        make.right.mas_equalTo(self.view).offset(-margin);
        make.width.height.mas_equalTo(87);
    }];

    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.manButton.mas_bottom).offset(79);
        make.left.mas_equalTo(self.view).offset(58);
        make.right.mas_equalTo(self.view).offset(-58);
        make.width.height.mas_equalTo(44);
    }];
    
    [self.tipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nextButton.mas_bottom).offset(16);
        make.left.mas_equalTo(self.view.mas_centerX).offset(-63);
        make.width.height.mas_equalTo(14);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.tipImageView);
        make.left.mas_equalTo(self.tipImageView.mas_right).offset(5);
    }];
}

//判断是否第三方登录
- (void)judgeIsThridPartLogin {
    if (GetCore(AuthCore).info.openid) {
        self.qqInfo = nil;
        self.weChatInfo = GetCore(AuthCore).info;
        GetCore(AuthCore).isNewRegister = YES;
        self.isMan = [self.weChatInfo.sex isEqualToString:@"1"];
        
    } else if (GetCore(AuthCore).qqInfo.openID) {
        self.weChatInfo = nil;
        self.qqInfo = GetCore(AuthCore).qqInfo;
        GetCore(AuthCore).isNewRegister = YES;
        self.isMan = [self.qqInfo.gender isEqualToString:@"男"];
    }
}

#pragma mark - getters and setters
- (void)setIsMan:(BOOL)isMan{
    _isMan = isMan;
    self.nextButton.enabled = YES;
    if (isMan == NO) {
        self.manButton.selected = NO;
        self.womanButton.selected = YES;
    } else {
        self.manButton.selected = YES;
        self.womanButton.selected = NO;
    }
}

- (BOOL)isHiddenNavBar {
    return YES;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [[UIButton alloc] init];
        [_backButton setImage:[UIImage imageNamed:@"nav_bar_back"] forState:UIControlStateNormal];
    }
    return _backButton;
}

- (UILabel *)titleLabel {
    if (!_tipLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [XCTheme getTTMainTextColor];
        _titleLabel.text = @"请选择性别";
        _titleLabel.font = [UIFont systemFontOfSize:22];
    }
    return _titleLabel;
}

- (UIButton *)manButton {
    if (!_manButton) {
        _manButton = [[UIButton alloc] init];
        [_manButton setImage:[UIImage imageNamed:@"auth_man_unselect"] forState:UIControlStateNormal];
        [_manButton setImage:[UIImage imageNamed:@"auth_man_select"] forState:UIControlStateSelected];
    }
    return _manButton;
}

- (UIButton *)womanButton {
    if (!_womanButton) {
        _womanButton = [[UIButton alloc] init];
        [_womanButton setImage:[UIImage imageNamed:@"auth_woman_unselect"] forState:UIControlStateNormal];
        [_womanButton setImage:[UIImage imageNamed:@"auth_woman_select"] forState:UIControlStateSelected];
    }
    return _womanButton;
}

- (UIButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextButton.layer.masksToBounds = YES;
        _nextButton.layer.cornerRadius = 22;
        [_nextButton setBackgroundImage:[UIImage instantiate1x1ImageWithColor:UIColorFromRGB(0xdbdbdb)] forState:UIControlStateDisabled];
        [_nextButton setBackgroundImage:[UIImage instantiate1x1ImageWithColor:[XCTheme getTTMainColor]] forState:UIControlStateNormal];
        [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextButton setTitle:@"下一步" forState:UIControlStateSelected];
        _nextButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    }
    return _nextButton;
}

- (UIImageView *)tipImageView {
    if (!_tipImageView) {
        _tipImageView = [[UIImageView alloc] init];
        _tipImageView.image = [UIImage imageNamed:@"auth_tip_icon"];
    }
    return _tipImageView;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.textColor = [XCTheme getTTMainTextColor];
        _tipLabel.text = @"性别选择后不可更改";
        _tipLabel.font = [UIFont systemFontOfSize:13];
    }
    return _tipLabel;
}

@end
