//
//  LLMyGiftViewController.m
//  XC_TTPersonalMoudle
//
//  Created by lee on 2019/7/27.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "LLMyGiftViewController.h"

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

@interface LLMyGiftViewController ()<PurseCoreClient>

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *topBgImageView;
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

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) UIButton *giftButton;
@property (nonatomic, strong) UILabel *diamondNumLabel;
@property (nonatomic, strong) UILabel *diamondTextLabel;

@property (nonatomic, strong) UIButton *giftBillButton;
@property (nonatomic, strong) UIButton *rechargeBillButton;

@property (nonatomic, strong) UIImageView *giftArrorImage;
@property (nonatomic, strong) UIImageView *rechargeArrorImage;

@end

@implementation LLMyGiftViewController


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

#pragma mark -
#pragma mark lifeCycle
- (void)initViews {
    
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationItem.title = @"我的礼物";
    
    [self.view addSubview:self.shadowView];
    [self.shadowView addSubview:self.topView];
    [self.view addSubview:self.giftButton];
    [self.view addSubview:self.diamondNumLabel];
    [self.view addSubview:self.diamondTextLabel];
    
    [self.view addSubview:self.giftBillButton];
    [self.view addSubview:self.rechargeBillButton];
    [self.view addSubview:self.giftArrorImage];
    [self.view addSubview:self.rechargeArrorImage];
    
    [self.view addSubview:self.giftInListBtn];
    [self.view addSubview:self.giftOutListBtn];
}

- (void)initConstraints {
    
    [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.left.mas_equalTo(self.view.mas_safeAreaLayoutGuideLeft).inset(20);
            make.right.mas_equalTo(self.view.mas_safeAreaLayoutGuideRight).inset(20);
            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).inset(20);
        } else {
            make.top.mas_equalTo(kNavigationHeight + 20);
            make.left.right.mas_equalTo(self.view).inset(20);
        }
        make.height.mas_equalTo(78);
    }];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.shadowView);
    }];
    
    [self.giftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.topView).inset(15);
        make.centerY.mas_equalTo(self.topView);
    }];
    
    [self.diamondNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.topView).inset(15);
        make.centerY.mas_equalTo(self.topView);
    }];
    
    [self.diamondTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.topView);
        make.top.mas_equalTo(self.topView.mas_bottom).offset(21);
    }];
    
    [self.giftBillButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.topView);
        make.height.mas_equalTo(45);
        make.top.mas_equalTo(self.diamondTextLabel.mas_bottom).offset(55);
    }];
    
    [self.rechargeBillButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.topView);
        make.top.mas_equalTo(self.giftBillButton.mas_bottom).offset(10);
        make.height.mas_equalTo(self.giftBillButton);
    }];
    
    [self.giftArrorImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(11);
        make.width.mas_equalTo(7);
        make.right.mas_equalTo(self.topView);
        make.centerY.mas_equalTo(self.giftBillButton);
    }];
    
    [self.rechargeArrorImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(11);
        make.width.mas_equalTo(7);
        make.right.mas_equalTo(self.topView);
        make.centerY.mas_equalTo(self.rechargeBillButton);
    }];
    
    [self.giftInListBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.centerY.mas_equalTo(self.giftBillButton);
        make.right.mas_equalTo(self.giftArrorImage);
    }];
    
    [self.giftOutListBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.centerY.mas_equalTo(self.rechargeBillButton);
        make.right.mas_equalTo(self.rechargeArrorImage);
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
- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [UIColor whiteColor];
        _topView.layer.cornerRadius = 8.f;
//        _topView.layer.masksToBounds = YES;
    }
    return _topView;
}

- (UIView *)shadowView {
    if (!_shadowView) {
        _shadowView = [[UIView alloc] init];
        _shadowView.layer.shadowColor = [XCTheme getTTSimpleGrayColor].CGColor;
        _shadowView.layer.shadowOpacity = 1.f;
        _shadowView.layer.shadowOffset = CGSizeZero;
        _shadowView.layer.shadowRadius = 8.0;
        _shadowView.layer.cornerRadius = 8.0;
        _shadowView.clipsToBounds = NO;
    }
    return _shadowView;
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

- (UIButton *)giftInListBtn {
    if (!_giftInListBtn) {
        _giftInListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_giftInListBtn setTitle:@"礼物记录" forState:UIControlStateNormal];
//        [_giftInListBtn setImage:[UIImage imageNamed:@"person_arrow"] forState:UIControlStateNormal];
//        [_giftInListBtn setImage:[UIImage imageNamed:@"person_arrow"] forState:UIControlStateHighlighted];
//        [_giftInListBtn setTitleColor:[XCTheme getTTDeepGrayTextColor] forState:UIControlStateNormal];
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
//        [_giftOutListBtn setTitle:@"赠送记录" forState:UIControlStateNormal];
//        [_giftOutListBtn setImage:[UIImage imageNamed:@"person_arrow"] forState:UIControlStateNormal];
//        [_giftOutListBtn setImage:[UIImage imageNamed:@"person_arrow"] forState:UIControlStateHighlighted];
//        [_giftOutListBtn setTitleColor:[XCTheme getTTDeepGrayTextColor] forState:UIControlStateNormal];
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

- (UIButton *)giftButton {
    if (!_giftButton) {
        _giftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_giftButton setImage:[UIImage imageNamed:@"myGift_giftValue"] forState:UIControlStateNormal];
        [_giftButton setTitle:@"魅力值" forState:UIControlStateNormal];
        [_giftButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
        _giftButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        [_giftButton setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateNormal];
        _giftButton.userInteractionEnabled = NO;
    }
    return _giftButton;
}

- (UIButton *)giftBillButton {
    if (!_giftBillButton) {
        _giftBillButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_giftBillButton setImage:[UIImage imageNamed:@"myGift_giftBill"] forState:UIControlStateNormal];
        [_giftBillButton setTitle:@"礼物收入记录" forState:UIControlStateNormal];
        [_giftBillButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        _giftBillButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        [_giftBillButton setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateNormal];
        _giftBillButton.userInteractionEnabled = NO;
    }
    return _giftBillButton;
}

- (UIButton *)rechargeBillButton {
    if (!_rechargeBillButton) {
        _rechargeBillButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rechargeBillButton setImage:[UIImage imageNamed:@"myGift_rechargeBill"] forState:UIControlStateNormal];
        [_rechargeBillButton setTitle:@"礼物支出记录" forState:UIControlStateNormal];
        [_rechargeBillButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        _rechargeBillButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        [_rechargeBillButton setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateNormal];
        _rechargeBillButton.userInteractionEnabled = NO;
    }
    return _rechargeBillButton;
}

- (UIImageView *)rechargeArrorImage {
    if (!_rechargeArrorImage) {
        _rechargeArrorImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Diamond_arrow"]];
    }
    return _rechargeArrorImage;
}

- (UIImageView *)giftArrorImage {
    if (!_giftArrorImage) {
        _giftArrorImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Diamond_arrow"]];
    }
    return _giftArrorImage;
}
@end
