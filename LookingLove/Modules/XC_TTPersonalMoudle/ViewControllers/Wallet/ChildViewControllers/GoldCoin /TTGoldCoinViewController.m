//
//  TTGoldCoinViewController.m
//  TuTu
//
//  Created by lee on 2018/11/2.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTGoldCoinViewController.h"

#import "TTCodeBlueViewController.h"
#import "TTRechargeViewController.h"
#import "TTWKWebViewViewController.h"

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

@interface TTGoldCoinViewController ()<PurseCoreClient, UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *topImageView;

@property (nonatomic, strong) UIButton *titleBtn;
/// 金币总额
@property (nonatomic, strong) UILabel *coinNumLabel; //
@property (nonatomic, strong) UILabel *tipsLabel; // 贵族金币 tips
// buttons
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIButton *exchangBtn;
@property (nonatomic, strong) UIButton *rechargeBtn;
@property (nonatomic, strong) UIButton *tipsHammerBtn;

// center View
@property (nonatomic, strong) UIImageView *centerImageView;
@property (nonatomic, strong) UIButton *goldCoinBtn;
@property (nonatomic, strong) UIButton *nobleCoinBtn;
/// 金币
@property (nonatomic, strong) UILabel *goldCoinNumLabel;
/// 贵族金币
@property (nonatomic, strong) UILabel *nobleCoinNumLabel;
@property (nonatomic, strong) UIButton *helpBtn;
@property (nonatomic, strong) UIView *lineView;

// custom navBar
@property (nonatomic, strong) UIView *navBarView;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) BalanceInfo *balanceInfo;
@end

@implementation TTGoldCoinViewController

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
    return UIStatusBarStyleLightContent;
}

- (BOOL)isHiddenNavBar {
    return YES;
}

#pragma mark -
#pragma mark lifeCycle
- (void)baseUI {
    self.view.backgroundColor = [XCTheme getTTSimpleGrayColor];
}

- (void)customNavBar {
    
}

- (void)initViews {
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.topImageView];
    [self.scrollView addSubview:self.titleBtn];
    [self.scrollView addSubview:self.coinNumLabel];
//    [self.scrollView addSubview:self.exchangBtn];
    [self.scrollView addSubview:self.rechargeBtn];
    [self.scrollView addSubview:self.textLabel];
    [self.scrollView addSubview:self.tipsLabel];
    [self.scrollView addSubview:self.centerImageView];
    [self.scrollView addSubview:self.tipsHammerBtn];
    
    [self.scrollView addSubview:self.lineView];
    [self.scrollView addSubview:self.goldCoinBtn];
    [self.scrollView addSubview:self.goldCoinNumLabel];
    [self.scrollView addSubview:self.nobleCoinBtn];
    [self.scrollView addSubview:self.nobleCoinNumLabel];
    [self.scrollView addSubview:self.helpBtn];
    
    [self.view addSubview:self.navBarView];
    [self.navBarView addSubview:self.leftBtn];
    [self.navBarView addSubview:self.titleLabel];
}

- (void)initConstraints {
 
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11, *)) {
            make.edges.mas_equalTo(self.view.mas_safeAreaLayoutGuide).insets(UIEdgeInsetsMake(-statusbarHeight, 0, 0, 0));
        } else {
            make.edges.width.mas_equalTo(self.view);
        }
    }];
    
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(-5);
        make.height.mas_equalTo(305);
    }];
    
    [self.titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(100);
        make.centerX.mas_equalTo(0);
    }];
    
    [self.coinNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.titleBtn.mas_bottom).offset(20);
    }];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.coinNumLabel.mas_bottom).offset(12);
        make.width.mas_equalTo(73);
        make.height.mas_equalTo(21);
    }];
    
    [self.centerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.tipsLabel.mas_bottom).offset(25);
        make.height.mas_equalTo(146);
    }];
    
    [self.tipsHammerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (KScreenHeight < 1136) {
            make.top.mas_equalTo(self.centerImageView.mas_bottom).offset(18);
        } else {
            make.top.mas_equalTo(self.centerImageView.mas_bottom).offset(68);
        }
        make.left.right.mas_equalTo(0).inset(74);
        make.height.mas_equalTo(43);
    }];
    
//    [self.exchangBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(0);
//        make.left.right.mas_equalTo(0).inset(63);
//        make.height.mas_equalTo(40);
//        make.top.mas_equalTo(self.tipsHammerBtn.mas_bottom).offset(10);
//    }];

    [self.rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.centerImageView.mas_bottom).offset(68);
        make.height.mas_equalTo(40);
        make.left.right.mas_equalTo(0).inset(63);
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.rechargeBtn.mas_bottom).offset(32);
    }];
    
    // custom navBar
    [self.navBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11, *)) {
            make.left.right.top.equalTo(self.view.mas_safeAreaLayoutGuide);
        } else {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.view.mas_top).offset(statusbarHeight);
        }
        make.height.mas_equalTo(44);
    }];
    
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(16);
    }];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
    }];
    
    // centerView
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.centerImageView);
        make.height.mas_equalTo(1);
        make.left.right.mas_equalTo(0).inset(35);
    }];
    
    [self.goldCoinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.lineView);
        make.bottom.mas_equalTo(self.lineView.mas_top).offset(-17);
    }];
    
    [self.goldCoinNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.lineView);
        make.centerY.mas_equalTo(self.goldCoinBtn);
    }];

    [self.nobleCoinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.lineView);
        make.top.mas_equalTo(self.lineView.mas_bottom).offset(17);
    }];
    
    [self.nobleCoinNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.lineView);
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
    TTRechargeViewController *vc = [[TTRechargeViewController alloc] init];
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
- (UIImageView *)topImageView {
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"goldCoin_bg"]];
    }
    return _topImageView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [XCTheme getTTSimpleGrayColor];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIButton *)titleBtn {
    if (!_titleBtn) {
        _titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_titleBtn setTitle:@"金币总额" forState:UIControlStateNormal];
        [_titleBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_titleBtn.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
        _titleBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
        [_titleBtn setImage:[UIImage imageNamed:@"goldCoin_icon_white"] forState:UIControlStateNormal];
        _titleBtn.userInteractionEnabled = NO;
    }
    return _titleBtn;
}

- (UILabel *)coinNumLabel
{
    if (!_coinNumLabel) {
        _coinNumLabel = [[UILabel alloc] init];
        _coinNumLabel.text = @"0";
        _coinNumLabel.textColor = UIColor.whiteColor;
        _coinNumLabel.font = [UIFont boldSystemFontOfSize:36.f];
        _coinNumLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _coinNumLabel;
}

- (UIButton *)exchangBtn {
    if (!_exchangBtn) {
        _exchangBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_exchangBtn setTitle:[NSString stringWithFormat:@"%@金币", [XCKeyWordTool sharedInstance].xcExchangeMethod] forState:UIControlStateNormal];
        [_exchangBtn setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateNormal];
        [_exchangBtn.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
        [_exchangBtn setBackgroundColor:UIColor.whiteColor];
        _exchangBtn.layer.masksToBounds = YES;
        _exchangBtn.layer.cornerRadius = 20;
        _exchangBtn.hidden = YES;
//        [_exchangBtn setBackgroundImage:[UIImage imageNamed:@"goldCoin_hintBubble_icon"] forState:UIControlStateNormal];
        [_exchangBtn addTarget:self action:@selector(exchangBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exchangBtn;
}


- (UIButton *)rechargeBtn {
    if (!_rechargeBtn) {
        _rechargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rechargeBtn setTitle:@"金币充值" forState:UIControlStateNormal];
        [_rechargeBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_rechargeBtn setBackgroundColor:[XCTheme getTTMainColor]];
        [_rechargeBtn.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
        _rechargeBtn.layer.masksToBounds = YES;
        _rechargeBtn.layer.cornerRadius = 20;
        [_rechargeBtn addTarget:self action:@selector(rechargeBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rechargeBtn;
}

- (UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        NSString *str = [NSString stringWithFormat:@"注: %@可用于%@，%@比例1元=10%@",[XCKeyWordTool sharedInstance].xcCF, [XCKeyWordTool sharedInstance].xcGetCF,[XCKeyWordTool sharedInstance].xcGetCF,[XCKeyWordTool sharedInstance].xcCF ];
        _textLabel.text = str;
        _textLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        _textLabel.font = [UIFont systemFontOfSize:11.f];
        _textLabel.adjustsFontSizeToFitWidth = YES;
        _textLabel.hidden = YES;
    }
    return _textLabel;
}

// custom navBar
- (UIView *)navBarView
{
    if (!_navBarView) {
        _navBarView = [[UIView alloc] init];
        _navBarView.backgroundColor = [UIColor clearColor];
    }
    return _navBarView;
}

- (UIButton *)leftBtn {
    if (!_leftBtn) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftBtn setImage:[UIImage imageNamed:@"nav_bar_back_white"] forState:UIControlStateNormal];
        [_leftBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_leftBtn.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
        [_leftBtn setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
        [_leftBtn addTarget:self action:@selector(leftBtnClickPopAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"我的金币";
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18.f];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _titleLabel;
}

- (UILabel *)tipsLabel
{
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.text = @"含贵族金币";
        _tipsLabel.textColor = [UIColor whiteColor];
        _tipsLabel.font = [UIFont systemFontOfSize:11.f];
        _tipsLabel.adjustsFontSizeToFitWidth = YES;
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.backgroundColor = UIColorRGBAlpha(0x000000, 0.1);
        _tipsLabel.layer.cornerRadius = 21 * 0.5;
        _tipsLabel.layer.masksToBounds = YES;
    }
    return _tipsLabel;
}

- (UIImageView *)centerImageView {
    if (!_centerImageView) {
        _centerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"goldCoin_centerBg_icon"]];
    }
    return _centerImageView;
}

- (UIButton *)tipsHammerBtn {
    if (!_tipsHammerBtn) {
        _tipsHammerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_tipsHammerBtn setTitle:@"免费获得金蛋锤子！100%中奖哦！" forState:UIControlStateNormal];
        [_tipsHammerBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_tipsHammerBtn.titleLabel setFont:[UIFont systemFontOfSize:13.f]];
        [_tipsHammerBtn setBackgroundImage:[UIImage imageNamed:@"goldCoin_hintBubble_icon"] forState:UIControlStateNormal];
        _tipsHammerBtn.titleEdgeInsets = UIEdgeInsetsMake(-10, 0, 0, 0);
        _tipsHammerBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        _tipsHammerBtn.userInteractionEnabled = NO;
        _tipsHammerBtn.hidden = YES;
    }
    return _tipsHammerBtn;
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

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    }
    return _lineView;
}
@end
