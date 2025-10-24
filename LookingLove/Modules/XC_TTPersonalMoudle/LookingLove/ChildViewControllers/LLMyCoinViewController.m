//
//  LLMyCoinViewController.m
//  XC_TTPersonalMoudle
//
//  Created by lee on 2019/7/27.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "LLMyCoinViewController.h"
#import "TTCodeBlueViewController.h"
#import "TTRechargeViewController.h"
#import "TTWKWebViewViewController.h"
#import "LLRechargeViewController.h"

// pods
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "XCHtmlUrl.h"

// core
#import "PurseCore.h"
#import "VersionCore.h"
#import "AuthCore.h"
#import "PurseCoreClient.h"
#import "UIButton+EnlargeTouchArea.h"
#import "XCKeyWordTool.h"

@interface LLMyCoinViewController ()<PurseCoreClient, UIScrollViewDelegate>

@property (nonatomic, strong) UIView *topView; //
@property (nonatomic, strong) UIView *shadowView; //
@property (nonatomic, strong) UIButton *titleBtn;
/// 金币总额
@property (nonatomic, strong) UILabel *coinNumLabel; //
@property (nonatomic, strong) UILabel *tipsLabel; // 贵族金币 tips
// buttons
@property (nonatomic, strong) UIButton *rechargeBtn;

// center View
@property (nonatomic, strong) UIButton *goldCoinBtn;
@property (nonatomic, strong) UIButton *nobleCoinBtn;
/// 金币
@property (nonatomic, strong) UILabel *goldCoinNumLabel;
/// 贵族金币
@property (nonatomic, strong) UILabel *nobleCoinNumLabel;
@property (nonatomic, strong) UIButton *helpBtn;

@property (nonatomic, strong) BalanceInfo *balanceInfo;

@end

@implementation LLMyCoinViewController

- (void)dealloc
{
    RemoveCoreClient(PurseCoreClient, self);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    NSString *uid = GetCore(AuthCore).getUid;
    [GetCore(PurseCore)requestBalanceInfo:uid.userIDValue];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AddCoreClient(PurseCoreClient, self);
    
    [self baseUI];
    [self initViews];
    [self initConstraints];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

#pragma mark -
#pragma mark lifeCycle
- (void)baseUI {
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationItem.title = @"我的金币";
}

- (void)customNavBar {
    
}

- (void)initViews {
    
    [self.view addSubview:self.shadowView];
    [self.shadowView addSubview:self.topView];
    [self.view addSubview:self.coinNumLabel];
    [self.view addSubview:self.titleBtn];
    [self.view addSubview:self.tipsLabel];
    
    [self.view addSubview:self.goldCoinBtn];
    [self.view addSubview:self.goldCoinNumLabel];
    [self.view addSubview:self.nobleCoinBtn];
    [self.view addSubview:self.nobleCoinNumLabel];
    [self.view addSubview:self.helpBtn];
    
    [self.view addSubview:self.rechargeBtn];
}

- (void)initConstraints {

    [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view).inset(20);
        make.top.mas_equalTo(self.view.mas_top).offset(kNavigationHeight + 20);
        make.height.mas_equalTo(78);
    }];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.shadowView);
    }];
    
    [self.titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.topView);
        make.left.mas_equalTo(self.topView).offset(15);
    }];
    
    [self.coinNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleBtn);
        make.right.mas_equalTo(self.topView).inset(15);
    }];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.topView);
        make.top.mas_equalTo(self.topView.mas_bottom).offset(21);
    }];
    
    [self.rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-35 - kSafeAreaBottomHeight);
        make.height.mas_equalTo(46);
        make.left.right.mas_equalTo(0).inset(38);
    }];
    
    [self.goldCoinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.topView);
        make.top.mas_equalTo(self.tipsLabel.mas_bottom).offset(55);
    }];
    
    [self.goldCoinNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.topView);
        make.centerY.mas_equalTo(self.goldCoinBtn);
    }];
    
    [self.nobleCoinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.goldCoinBtn);
        make.top.mas_equalTo(self.goldCoinBtn.mas_bottom).offset(25);
    }];
    
    [self.nobleCoinNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.topView);
        make.centerY.mas_equalTo(self.nobleCoinBtn);
    }];
    
    [self.helpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nobleCoinBtn.mas_right).offset(7);
        make.height.width.mas_equalTo(15);
        make.centerY.mas_equalTo(self.nobleCoinBtn);
    }];
}

#pragma mark -
#pragma mark PurseCoreClient
- (void)onBalanceInfoUpdate:(BalanceInfo *)balanceInfo
{
    self.balanceInfo = GetCore(PurseCore).balanceInfo;
    self.coinNumLabel.text= [NSString stringWithFormat:@"%.2f", [self.balanceInfo.goldNum integerValue] * 1.0];
    self.goldCoinNumLabel.text = [NSString stringWithFormat:@"%.2f", [self.balanceInfo.chargeGoldNum integerValue] * 1.0];
    self.nobleCoinNumLabel.text = [NSString stringWithFormat:@"%.2f", [self.balanceInfo.nobleGoldNum integerValue] * 1.0];
    
}

#pragma mark -
#pragma mark button custom events

// item
- (void)helpBtnClickAction:(UIButton *)btn {
    // 点击帮助按钮
    TTWKWebViewViewController *web = [[TTWKWebViewViewController alloc] init];
    web.urlString = HtmlUrlKey(kNobilityQuestionURL);
    [self.navigationController pushViewController:web animated:YES];
}

- (void)leftBtnClickPopAction:(UIButton *)btn {
    // 返回
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)exchangBtnClickAction:(UIButton *)btn {
    // 兑换
    //    TTCodeBlueViewController *vc = [[TTCodeBlueViewController alloc] init];
    //    vc.balanceInfo = _balanceInfo;
    //    [self.navigationController pushViewController:vc animated:YES];
}

- (void)rechargeBtnClickAction:(UIButton *)btn {
    // 充值
    LLRechargeViewController *vc = [[LLRechargeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y <= 0) {
        scrollView.bounces = NO;
    } else {
        scrollView.bounces = YES;
    }
}

#pragma mark -
#pragma mark getter & setter
- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = UIColor.whiteColor;
        _topView.layer.cornerRadius = 8.0f;
//        _topView.layer.masksToBounds = YES;
    }
    return _topView;
}

- (UIView *)shadowView {
    if (!_shadowView) {
        _shadowView = [[UIView alloc] init];
        _shadowView.layer.shadowColor = [XCTheme getTTSimpleGrayColor].CGColor;
        _shadowView.layer.shadowOffset = CGSizeZero;
        _shadowView.layer.shadowRadius = 8.f;
        _shadowView.layer.shadowOpacity = 1;
    }
    return _shadowView;
}

- (UIButton *)titleBtn {
    if (!_titleBtn) {
        _titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_titleBtn setTitle:@"金币总额" forState:UIControlStateNormal];
        [_titleBtn setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateNormal];
        [_titleBtn.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
        _titleBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
        [_titleBtn setImage:[UIImage imageNamed:@"rechargeCoin_selected"] forState:UIControlStateNormal];
        _titleBtn.userInteractionEnabled = NO;
    }
    return _titleBtn;
}

- (UILabel *)coinNumLabel
{
    if (!_coinNumLabel) {
        _coinNumLabel = [[UILabel alloc] init];
        _coinNumLabel.text = @"0";
        _coinNumLabel.textColor = [XCTheme getTTMainTextColor];
        _coinNumLabel.font = [UIFont boldSystemFontOfSize:25.f];
        _coinNumLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _coinNumLabel;
}

- (UIButton *)rechargeBtn {
    if (!_rechargeBtn) {
        _rechargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rechargeBtn setTitle:@"金币充值" forState:UIControlStateNormal];
        [_rechargeBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_rechargeBtn setBackgroundColor:[XCTheme getTTMainColor]];
        [_rechargeBtn.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
        _rechargeBtn.layer.masksToBounds = YES;
        _rechargeBtn.layer.cornerRadius = 23;
        
        [_rechargeBtn setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateNormal];
        [_rechargeBtn setBackgroundColor:UIColor.whiteColor];
        _rechargeBtn.layer.borderWidth = 2;
        _rechargeBtn.layer.borderColor = [XCTheme getTTMainTextColor].CGColor;
        
        [_rechargeBtn addTarget:self action:@selector(rechargeBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rechargeBtn;
}

- (UILabel *)tipsLabel
{
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.text = @"含贵族金币";
        _tipsLabel.textColor = [XCTheme getTTMainTextColor];
        _tipsLabel.font = [UIFont systemFontOfSize:12.f];
    }
    return _tipsLabel;
}

- (UIButton *)goldCoinBtn {
    if (!_goldCoinBtn) {
        _goldCoinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_goldCoinBtn setTitle:@"金币余额" forState:UIControlStateNormal];
        [_goldCoinBtn setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateNormal];
        [_goldCoinBtn.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
        [_goldCoinBtn setImage:[UIImage imageNamed:@"goldCoin_coinColor_icon"] forState:UIControlStateNormal];
        _goldCoinBtn.userInteractionEnabled = NO;
        _goldCoinBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 7, 0, -7);
        _goldCoinBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 7);
        
    }
    return _goldCoinBtn;
}

- (UIButton *)nobleCoinBtn {
    if (!_nobleCoinBtn) {
        _nobleCoinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nobleCoinBtn setTitle:@"贵族金币" forState:UIControlStateNormal];
        [_nobleCoinBtn setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateNormal];
        [_nobleCoinBtn.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
        [_nobleCoinBtn setImage:[UIImage imageNamed:@"goldCoin_noble_icon"] forState:UIControlStateNormal];
        _nobleCoinBtn.userInteractionEnabled = NO;
        _nobleCoinBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 7, 0, -7);
        _nobleCoinBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 7);
    }
    return _nobleCoinBtn;
}

- (UIButton *)helpBtn {
    if (!_helpBtn) {
        _helpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_helpBtn setImage:[UIImage imageNamed:@"goldCoin_help_icon"] forState:UIControlStateNormal];
        [_helpBtn setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
        [_helpBtn addTarget:self action:@selector(helpBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _helpBtn;
}


- (UILabel *)goldCoinNumLabel
{
    if (!_goldCoinNumLabel) {
        _goldCoinNumLabel = [[UILabel alloc] init];
        _goldCoinNumLabel.text = @"0";
        _goldCoinNumLabel.textColor = [XCTheme getMSMainTextColor];
        _goldCoinNumLabel.font = [UIFont boldSystemFontOfSize:16.f];
        _goldCoinNumLabel.adjustsFontSizeToFitWidth = YES;
        _goldCoinNumLabel.textAlignment = NSTextAlignmentRight;
    }
    return _goldCoinNumLabel;
}

- (UILabel *)nobleCoinNumLabel
{
    if (!_nobleCoinNumLabel) {
        _nobleCoinNumLabel = [[UILabel alloc] init];
        _nobleCoinNumLabel.text = @"0";
        _nobleCoinNumLabel.textColor = [XCTheme getMSMainTextColor];
        _nobleCoinNumLabel.font = [UIFont boldSystemFontOfSize:16.f];
        _nobleCoinNumLabel.adjustsFontSizeToFitWidth = YES;
        _nobleCoinNumLabel.textAlignment = NSTextAlignmentRight;
    }
    return _nobleCoinNumLabel;
}

@end
