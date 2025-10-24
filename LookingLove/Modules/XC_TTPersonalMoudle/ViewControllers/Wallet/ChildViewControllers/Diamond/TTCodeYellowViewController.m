//
//  TTDiamondViewController.m
//  TuTu
//
//  Created by lee on 2018/11/3.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTCodeYellowViewController.h"

#import "TTCodeRedViewController.h"
#import "TTCodeBlueViewController.h"
#import "TTBillListViewController.h"
#import "TTWKWebViewViewController.h"

#import "XCTheme.h"
#import <Masonry/Masonry.h>
#import "XCConst.h"
#import "XCHtmlUrl.h"
#import "XCMacros.h"
#import "XCKeyWordTool.h"
#import "UIButton+EnlargeTouchArea.h"

#import "PurseCore.h"
#import "PurseCoreClient.h"
#import "BalanceInfo.h"
#import "AuthCore.h"


@interface TTCodeYellowViewController ()<PurseCoreClient>

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *topBgImageView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *diamondNumLabel;
@property (nonatomic, strong) UILabel *diamondTextLabel;
@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) UIView *marginLineView;
@property (nonatomic, strong) UIButton *giftInListBtn;
@property (nonatomic, strong) UIButton *giftOutListBtn;

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIButton *exchangBtn;
@property (nonatomic, strong) UIButton *codeRedBtn;
@property (nonatomic, strong) UIButton *tipsHammerBtn;

// custom navBar
@property (nonatomic, strong) UIView *narBarView;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) BalanceInfo *balanceInfo;
@end

@implementation TTCodeYellowViewController

- (void)dealloc
{
    RemoveCoreClient(PurseCoreClient, self);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    NSString *uid = GetCore(AuthCore).getUid;
    [GetCore(PurseCore) requestBalanceInfo:uid.userIDValue];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AddCoreClient(PurseCoreClient, self);
    
    [self initViews];
    [self initConstraints];
}

- (BOOL)isHiddenNavBar {
    return YES;
}

#pragma mark -
#pragma mark lifeCycle
- (void)initViews {
 
    self.view.backgroundColor = [XCTheme getTTSimpleGrayColor];
    [self.view addSubview:self.containerView];
    [self.containerView addSubview:self.topBgImageView];
    [self.containerView addSubview:self.exchangBtn];
    [self.containerView addSubview:self.codeRedBtn];
    [self.containerView addSubview:self.textLabel];
    [self.containerView addSubview:self.tipsHammerBtn];
    
    [self.containerView addSubview:self.topView];
    
    [self.topView addSubview:self.diamondNumLabel];
    [self.topView addSubview:self.diamondTextLabel];
    [self.topView addSubview:self.topLineView];
    [self.topView addSubview:self.giftInListBtn];
    [self.topView addSubview:self.marginLineView];
    [self.topView addSubview:self.giftOutListBtn];
    
    [self.view addSubview:self.narBarView];
    [self.narBarView addSubview:self.backBtn];
    [self.narBarView addSubview:self.titleLabel];
}

- (void)initConstraints {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11, *)) {
            make.edges.mas_equalTo(self.view.mas_safeAreaLayoutGuide).insets(UIEdgeInsetsMake(-statusbarHeight, 0, 0, 0));
        } else {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(64, 0, 0, 0));
        }
        make.width.mas_equalTo(KScreenWidth);
    }];
    
    [self.narBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11, *)) {
            make.left.right.top.mas_equalTo(self.view.mas_safeAreaLayoutGuide);
        } else {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(statusbarHeight);
        }
        make.height.mas_equalTo(44);
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
    }];
    
    [self.topBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.view).offset(-2);
        make.height.mas_equalTo(200);
    }];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(90);
        make.left.right.mas_equalTo(0).inset(15);
        make.height.mas_equalTo(211);
    }];
    
    [self.diamondNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(56);
        make.centerX.mas_equalTo(0);
    }];
    
    [self.diamondTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.diamondNumLabel.mas_bottom).offset(26);
        make.centerX.mas_equalTo(0);
    }];
    
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(-50);
    }];
    
    [self.giftInListBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0);
        make.width.mas_equalTo(self.topView).multipliedBy(0.5);
        make.height.mas_equalTo(50);
    }];
    
    [self.giftOutListBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(0);
        make.height.width.mas_equalTo(self.giftInListBtn);
    }];
    
    [self.marginLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(-17);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(1);
    }];
    
    [self.tipsHammerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topView.mas_bottom).offset(48);
        make.left.right.mas_equalTo(0).inset(74);
        make.height.mas_equalTo(43);
    }];
    
    [self.exchangBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tipsHammerBtn.mas_bottom).offset(11);
        make.left.right.mas_equalTo(0).inset(63);
        make.height.mas_equalTo(40);
    }];
    
    [self.codeRedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.exchangBtn.mas_bottom).offset(28);
        make.width.height.centerX.mas_equalTo(self.exchangBtn);
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.codeRedBtn.mas_bottom).offset(32);
        make.centerX.mas_equalTo(0);
    }];
}

#pragma mark -
#pragma mark button custom events
// 兑换
- (void)exchangBtnClickAction:(UIButton *)btn {
//    TTCodeBlueViewController *vc = [[TTCodeBlueViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
}

// 提现
- (void)codeRedBtnClickAction:(UIButton *)btn {
//    TTCodeRedViewController *vc = [[TTCodeRedViewController alloc] init];
//    TTWKWebViewViewController *web = [[TTWKWebViewViewController alloc] init];
//    web.urlString = HtmlUrlKey(kTuTuCodeRedURL);
//    [self.navigationController pushViewController:web animated:YES];
}
// 礼物收入
- (void)giftInListBtnClickAction:(UIButton *)btn {
    TTBillListViewController *vc = [[TTBillListViewController alloc] init];
    vc.listViewType = TTBillListViewTypeGiftIn;
    [self.navigationController pushViewController:vc animated:YES];
}

// 礼物支出
- (void)giftOutListBtnClickAction:(UIButton *)btn {
    TTBillListViewController *vc = [[TTBillListViewController alloc] init];
    vc.listViewType = TTBillListViewTypeGiftOut;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)backBtnClickPopAction:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark PurseCoreClient
- (void)onBalanceInfoUpdate:(BalanceInfo *)balanceInfo {
    _balanceInfo = balanceInfo;
    self.balanceInfo = GetCore(PurseCore).balanceInfo;
    self.diamondNumLabel.text= [NSString stringWithFormat:@"%.2f", self.balanceInfo.diamondNum];
    
//    if (balanceInfo.diamondNum.floatValue > 500.00) { // 兑换金币：限制500钻以上才可以显示兑换金币；
//        self.exchangBtn.hidden = NO;
//        self.tipsHammerBtn.hidden = NO;
//    }
    
//    if (GetCore(PurseCore).minDisplayCount > 0) {
//        if (balanceInfo.diamondNum.floatValue > GetCore(PurseCore).minDisplayCount) { // 钻石提现：限制1000钻以上才可以显示提;
//            self.codeRedBtn.hidden = NO;
//            self.textLabel.hidden = NO;
//            self.tipsHammerBtn.hidden = NO;
//        }
//    }
}

#pragma mark -
#pragma mark getter & setter
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [XCTheme getTTSimpleGrayColor];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIImageView *)topBgImageView {
    if (!_topBgImageView) {
        _topBgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Diamond_bgView"]];
    }
    return _topBgImageView;
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [UIColor whiteColor];
        _topView.layer.cornerRadius = 8.f;
        _topView.layer.masksToBounds = YES;
    }
    return _topView;
}

- (UILabel *)diamondNumLabel
{
    if (!_diamondNumLabel) {
        _diamondNumLabel = [[UILabel alloc] init];
        _diamondNumLabel.text = @"0.00";
        _diamondNumLabel.textColor = [XCTheme getMSMainTextColor];
        _diamondNumLabel.font = [UIFont boldSystemFontOfSize:32.f];
        _diamondNumLabel.adjustsFontSizeToFitWidth = YES;
        _diamondNumLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _diamondNumLabel;
}

- (UILabel *)diamondTextLabel
{
    if (!_diamondTextLabel) {
        _diamondTextLabel = [[UILabel alloc] init];
        _diamondTextLabel.text = @"·收到礼物会增加相应的魅力值哦·";
        _diamondTextLabel.textColor = [XCTheme getMSSecondTextColor];
        _diamondTextLabel.font = [UIFont systemFontOfSize:11.f];
        _diamondTextLabel.adjustsFontSizeToFitWidth = YES;
        _diamondTextLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _diamondTextLabel;
}

- (UIView *)topLineView {
    if (!_topLineView) {
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = [XCTheme getMSSimpleGrayColor];
    }
    return _topLineView;
}

- (UIButton *)giftInListBtn {
    if (!_giftInListBtn) {
        _giftInListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_giftInListBtn setTitle:@"礼物记录" forState:UIControlStateNormal];
        [_giftInListBtn setImage:[UIImage imageNamed:@"person_arrow"] forState:UIControlStateNormal];
        [_giftInListBtn setImage:[UIImage imageNamed:@"person_arrow"] forState:UIControlStateHighlighted];
        [_giftInListBtn setTitleColor:[XCTheme getTTDeepGrayTextColor] forState:UIControlStateNormal];
        [_giftInListBtn.titleLabel setFont:[UIFont systemFontOfSize:13.f]];
        _giftInListBtn.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        _giftInListBtn.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        _giftInListBtn.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        _giftInListBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        [_giftInListBtn addTarget:self action:@selector(giftInListBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _giftInListBtn;
}

- (UIButton *)giftOutListBtn {
    if (!_giftOutListBtn) {
        _giftOutListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_giftOutListBtn setTitle:@"赠送记录" forState:UIControlStateNormal];
        [_giftOutListBtn setImage:[UIImage imageNamed:@"person_arrow"] forState:UIControlStateNormal];
        [_giftOutListBtn setImage:[UIImage imageNamed:@"person_arrow"] forState:UIControlStateHighlighted];
        [_giftOutListBtn setTitleColor:[XCTheme getTTDeepGrayTextColor] forState:UIControlStateNormal];
        // 翻转图片 和 文本
        _giftOutListBtn.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        _giftOutListBtn.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        _giftOutListBtn.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        [_giftOutListBtn.titleLabel setFont:[UIFont systemFontOfSize:13.f]];
        _giftOutListBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        [_giftOutListBtn addTarget:self action:@selector(giftOutListBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _giftOutListBtn;
}

- (UIView *)marginLineView {
    if (!_marginLineView) {
        _marginLineView = [[UIView alloc] init];
        _marginLineView.backgroundColor = [XCTheme getTTSimpleGrayColor];
    }
    return _marginLineView;
}

- (UIButton *)exchangBtn {
    if (!_exchangBtn) {
        _exchangBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_exchangBtn setTitle:[NSString stringWithFormat:@"%@金币", [XCKeyWordTool sharedInstance].xcExchangeMethod] forState:UIControlStateNormal];
        [_exchangBtn setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateNormal];
        [_exchangBtn.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
        [_exchangBtn setBackgroundColor:[UIColor whiteColor]];
        _exchangBtn.layer.masksToBounds = YES;
        _exchangBtn.layer.cornerRadius = 20;
        _exchangBtn.hidden = YES;
        [_exchangBtn addTarget:self action:@selector(exchangBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exchangBtn;
}

- (UIButton *)codeRedBtn {
    if (!_codeRedBtn) {
        _codeRedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_codeRedBtn setTitle:[NSString stringWithFormat:@"立即%@", [XCKeyWordTool sharedInstance].xcGetCF] forState:UIControlStateNormal];
        [_codeRedBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_codeRedBtn.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
        [_codeRedBtn setBackgroundColor:[XCTheme getTTMainColor]];
        _codeRedBtn.layer.masksToBounds = YES;
        _codeRedBtn.layer.cornerRadius = 20;
        _codeRedBtn.hidden = YES;
        [_codeRedBtn addTarget:self action:@selector(codeRedBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _codeRedBtn;
}

- (UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        NSString *str = [NSString stringWithFormat:@"%@", [XCKeyWordTool sharedInstance].xcGetCF];
        NSString *cf = [NSString stringWithFormat:@"%@", [XCKeyWordTool sharedInstance].xcCF];
        _textLabel.text = [NSString stringWithFormat:@"注: %@可用于%@，%@比例1元=10%@", cf,str, str, cf];
        _textLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        _textLabel.font = [UIFont systemFontOfSize:11.f];
        _textLabel.adjustsFontSizeToFitWidth = YES;
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.hidden = YES;
    }
    return _textLabel;
}

// custom navBar
- (UIView *)narBarView
{
    if (!_narBarView) {
        _narBarView = [[UIView alloc] init];
        _narBarView.backgroundColor = [UIColor clearColor];
    }
    return _narBarView;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
        [_backBtn setImage:[UIImage imageNamed:@"nav_bar_back_white"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnClickPopAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"我的礼物";
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18.f];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIView *)containerView
{
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [XCTheme getTTSimpleGrayColor];
    }
    return _containerView;
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
@end
