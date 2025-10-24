//
//  TTCheckinViewController.m
//  TTPlay
//
//  Created by lvjunhang on 2019/3/18.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTCheckinViewController.h"
#import "TTCheckinConst.h"
#import "TTCheckinScrollNotifyView.h"
#import "TTCheckinInfoView.h"
#import "TTCheckinAccumulatePrizeView.h"
#import "TTCheckinPrizePreviewView.h"
#import "TTCheckinRuleAlertView.h"
#import "TTCheckinReceiptAlertView.h"

#import "TTCheckinViewController+Share.h"
#import "TTCheckinViewController+Replenish.h"

#import "TTDiscoverCheckInMissionNotiConst.h"

#import <Masonry/Masonry.h>

#import "CheckinCoreClient.h"
#import "CheckinCore.h"
#import "ShareCoreClient.h"
#import "ClientCore.h"
#import "UserCore.h"
#import "AuthCore.h"
#import "DressUpModel.h"

#import "XCHUDTool.h"
#import "XCCurrentVCStackManager.h"
#import "XCHtmlUrl.h"
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIViewController+EmptyDataView.h"
#import "TTStatisticsService.h"

#import "TTWKWebViewViewController.h"
#import "TTPopup.h"

@interface TTCheckinViewController ()<CheckinCoreClient>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) TTCheckinScrollNotifyView *notifyView;//滚动通知
@property (nonatomic, strong) UILabel *checkinRemindLabel;//签到提醒
@property (nonatomic, strong) UIButton *checkinRemindSwitch;//签到提醒

@property (nonatomic, strong) UIImageView *mainSlogonImageView;//标语，签到瓜分百万
@property (nonatomic, strong) UILabel *subSlogonLabel;//标语，签到时间越长 奖励越丰厚

@property (nonatomic, strong) UIImageView *bgLogoImageView;//顶部背景
@property (nonatomic, strong) TTCheckinInfoView *checkinInfoView;//签到信息

@property (nonatomic, strong) UIButton *ruleButton;//活动规则
@property (nonatomic, strong) UIButton *shareButton;//分享好友

@property (nonatomic, strong) UILabel *accumulatePrizeLabel;//累计签到 领取相应奖励
@property (nonatomic, strong) UIImageView *accumulatePrizeLeftImageView;//累计签到，左图标
@property (nonatomic, strong) UIImageView *accumulatePrizeRightImageView;//累计签到，右图标
@property (nonatomic, strong) TTCheckinAccumulatePrizeView *accumulatePrizeView;//累计签到，领取奖励

@property (nonatomic, strong) TTCheckinPrizePreviewView *prizePreviewView;//奖励预告

@end

@implementation TTCheckinViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"签到";
    
    AddCoreClient(CheckinCoreClient, self);
    AddCoreClient(ShareCoreClient, self);
    
    [self initViews];
    [self initConstraints];
    
    [GetCore(CheckinCore) requestCheckinSignDetail];
    [GetCore(CheckinCore) requestCheckinDrawNotice];
    [GetCore(CheckinCore) requestCheckinRewardTotalNotice];
    [GetCore(CheckinCore) requestCheckinRewardTodayNotice];
}

- (void)dealloc {
    RemoveCoreClientAll(self);
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (self.prizePreviewView.frame.size.height > 0) {
        self.scrollView.contentSize = CGSizeMake(KScreenWidth, CGRectGetMaxY(self.prizePreviewView.frame));
    }
}

/**
 点击失败占位图时的重载方法
 */
- (void)reloadDataWhenLoadFail {
    [GetCore(CheckinCore) requestCheckinSignDetail];
}

#pragma mark - Core Protocols
#pragma mark CheckinCoreClient
///瓜分金币通知栏
- (void)responseCheckinDrawNotice:(NSArray<CheckinDrawNotice *> *)data errorCode:(NSNumber *)code msg:(NSString *)msg {
    
    if (data == nil) {
        return;
    }
    
    self.notifyView.models = data;
    self.notifyView.hidden = data == nil || data.count == 0;
}

///每日签到奖励预告
- (void)responseCheckinRewardTodayNotice:(NSArray<CheckinRewardTodayNotice *> *)data errorCode:(NSNumber *)code msg:(NSString *)msg {
    
    if (data == nil) {
        return;
    }
    
    self.prizePreviewView.dataModelArray = data;
}

///累计奖励预告
- (void)responseCheckinRewardTotalNotice:(NSArray<CheckinRewardTotalNotice *> *)data errorCode:(NSNumber *)code msg:(NSString *)msg {
    
    if (data == nil) {
        return;
    }
    
    self.accumulatePrizeView.modelArray = data;
}

///签到详情
- (void)responseCheckinSignDetail:(CheckinSignDetail *)data errorCode:(NSNumber *)code msg:(NSString *)msg {
    
    self.checkinInfoView.checkinButton.userInteractionEnabled = YES;
    
    /// When Network Error
    if (code == nil && msg.length > 0) {
        [XCHUDTool showErrorWithMessage:@"网络出现问题" inView:self.view];
        return;
    }
    
    /// When Servers Send Error
    if (code != nil) {
        [XCHUDTool showErrorWithMessage:msg ?: @"获取数据出现问题" inView:self.view];
        return;
    }
    
    self.checkinInfoView.signDetail = data;
    self.accumulatePrizeView.signDetail = data;
    
    self.prizePreviewView.canReplenishSign = data.canReplenishSign;
    
    self.checkinRemindSwitch.selected = data.isSignRemind;
}

///签到
- (void)responseCheckinSign:(CheckinSign *)data errorCode:(NSNumber *)code msg:(NSString *)msg {
    
    self.checkinInfoView.checkinButton.userInteractionEnabled = YES;
    
    /// When Network Error
    if (code == nil && msg.length > 0) {
        [XCHUDTool showErrorWithMessage:@"网络出现问题" inView:self.view];
        return;
    }
    
    /// When Servers Send Error
    if (code != nil) {
        [XCHUDTool showErrorWithMessage:msg ?: @"获取数据出现问题" inView:self.view];
        return;
    }
    
    ///刷新获取签到详情
    [GetCore(CheckinCore) requestCheckinSignDetail];
    // 用来通知上一层(任务中心
    !self.signSuccessBlock ?: self.signSuccessBlock();
    // 发现页刷新数据
    [[NSNotificationCenter defaultCenter] postNotificationName:TTDiscoverCheckInMissonRefreshNoti object:nil];
    
    self.checkinInfoView.checkinButton.userInteractionEnabled = NO;
    
    [TTStatisticsService trackEvent:TTStatisticsServiceEventSignSuccess
                      eventDescribe:@"发现-签到页签到成功"];
    
    NSString *toast = [NSString stringWithFormat:@"签到成功，奖金池已增加%ld金币", (long)data.signGoldNum];
    [XCHUDTool showSuccessWithMessage:toast];
    
    ///签到完将金币个数累加上去
    [self.checkinInfoView appendCoin:data.signGoldNum];
    
    ///手动处理当天领取到的礼物
    NSInteger todaySignDay = self.checkinInfoView.signDetail.todaySignDay;
    [self.prizePreviewView refreshViewAfterReceivePrizeForDay:todaySignDay];
}

///瓜分
- (void)responseCheckinDraw:(CheckinDraw *)data errorCode:(NSNumber *)code msg:(NSString *)msg {
    
    self.accumulatePrizeView.userInteractionEnabled = YES;
    
    /// When Network Error
    if (code == nil && msg.length > 0) {
        [XCHUDTool showErrorWithMessage:@"网络出现问题" inView:self.view];
        return;
    }
    
    /// When Servers Send Error
    if (code != nil) {
        [XCHUDTool showErrorWithMessage:msg ?: @"获取数据出现问题" inView:self.view];
        return;
    }
    
    [GetCore(CheckinCore) requestCheckinSignDetail];
    
    TTCheckinReceiptAlertView *alert = [[TTCheckinReceiptAlertView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    alert.shareBlock = ^{
        
        [XCHUDTool showGIFLoading];
        
        NSString *reward = [NSString stringWithFormat:@"金币 x %ld", (long)data.goldNum];
        
        [GetCore(CheckinCore) requestCheckinShareImageWithType:3
                                                           day:@"28天"
                                                        reward:reward];
    };
    
    @KWeakify(self)
    [UIView animateWithDuration:0.5 animations:^{
        @KStrongify(self)
        [self.navigationController.view addSubview:alert];
    } completion:^(BOOL finished) {
        [alert configCoin:data.goldNum];
    }];
}

///开启关闭签到提醒
- (void)responseCheckinSignRemind:(BOOL)isSuccess errorCode:(NSNumber *)code msg:(NSString *)msg {
    
    [XCHUDTool hideHUDInView:self.view];
    
    if (isSuccess) {
        self.checkinRemindSwitch.selected = !self.checkinRemindSwitch.selected;
        return;
    }
    
    [XCHUDTool showErrorWithMessage:msg inView:self.view];
}

///领取累计奖励响应
- (void)responseCheckinReceiveTotalReward:(CheckinReceiveTotalReward *)data errorCode:(NSNumber *)code msg:(NSString *)msg {
    
    self.accumulatePrizeView.userInteractionEnabled = YES;
    
    if (data == nil) {
        [XCHUDTool showErrorWithMessage:msg inView:self.view];
        return;
    }
    
    [GetCore(CheckinCore) requestCheckinRewardTotalNotice];
    
    TTCheckinReceiptAlertView *alert = [[TTCheckinReceiptAlertView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    @KWeakify(self)
    alert.shareBlock = ^{

        [TTStatisticsService trackEvent:TTStatisticsServiceEventSignRewardShare
                          eventDescribe:@"累计奖励-分享"];
        
        [XCHUDTool showGIFLoading];
        
        NSString *day = [NSString stringWithFormat:@"%ld天", (long)data.signDays];
        
        [GetCore(CheckinCore) requestCheckinShareImageWithType:2
                                                           day:day
                                                        reward:data.showText];
    };
    
    [UIView animateWithDuration:0.5 animations:^{
        @KStrongify(self)
        [self.navigationController.view addSubview:alert];
    } completion:^(BOOL finished) {
        [alert configGift:data.showText icon:data.prizePic];
    }];
}

- (void)responseCheckinShare:(BOOL)isSuccess errorCode:(NSNumber *)code msg:(NSString *)msg {
    
}

///获取分享图片
- (void)responseCheckinShareImage:(NSString *)data errorCode:(NSNumber *)code msg:(NSString *)msg {
    if (data == nil || data.length <= 0) {
        [XCHUDTool showErrorWithMessage:msg ?: @"分享图片获取错误" inView:self.view];
        return;
    }
    
    [XCHUDTool hideHUD];
    [XCHUDTool hideHUDInView:self.view];
    
    self.shareImageURL = data;
    [self shareCheckinImage];
}

//获取补签信息
- (void)responseCheckinReplenishInfo:(CheckinReplenishInfo *)data errorCode:(NSNumber *)code msg:(NSString *)msg {
    
    self.prizePreviewView.userInteractionEnabled = YES;
    
    if (data == nil) {
        [XCHUDTool showErrorWithMessage:msg inView:self.view];
        return;
    }
    
    [XCHUDTool hideHUDInView:self.view];
    
    if (data.type == 1) {
        //分享萝卜补签
        [self showShareGetReplenishChanceAlert];
        
    } else if (data.type == 2) {
        //支付萝卜补签
        [self showPayRadishGetReplenishChanceAlertWithRadish:data.price];
    }
}

//补签
- (void)responseCheckinReplenish:(CheckinReplenish *)data errorCode:(NSNumber *)code msg:(NSString *)msg {
    
    if (code.integerValue == kNotCarrotCode) {
        //萝卜不足
        [self showNoEnoughRadishBalanceAlert];
        return;
    }
    
    if (data == nil) {
        [XCHUDTool showErrorWithMessage:msg inView:self.view];
        return;
    }
    
    NSString *evenDes = [NSString stringWithFormat:@"补签成功:第%@次", data.replenishSignNum];
    [TTStatisticsService trackEvent:TTStatisticsServiceEventCheckinResignSuccess eventDescribe:evenDes];
    
    [self showReplenishSuccessAlertWithReward:data.prizeName];

    [GetCore(CheckinCore) requestCheckinSignDetail];
    [GetCore(CheckinCore) requestCheckinRewardTodayNotice];
}

#pragma mark - Event Responses
- (void)ruleButtonTapped {
    TTCheckinRuleAlertView *alertView = [[TTCheckinRuleAlertView alloc] init];
    [alertView showAlert];
}

- (void)shareButtonTapped {
    if (self.checkinInfoView.signDetail == nil) {
        [GetCore(CheckinCore) requestCheckinSignDetail];
        return;
    }
    
    [TTStatisticsService trackEvent:TTStatisticsServiceEventSignShare eventDescribe:@"签到-分享"];
    
    [XCHUDTool showGIFLoadingInView:self.view];
    
    NSString *day = [NSString stringWithFormat:@"%ld天", (long)self.checkinInfoView.signDetail.totalDay];
    NSString *reward = [NSString stringWithFormat:@"%@ x %ld", self.checkinInfoView.signDetail.signPrizeName, (long)self.checkinInfoView.signDetail.signPrizeNum];
    
    [GetCore(CheckinCore) requestCheckinShareImageWithType:1
                                                       day:day
                                                    reward:reward];
}

- (void)checkinRemindSwitchTapped:(UIButton *)sender {
    
    NSString *desc = [NSString stringWithFormat:@"签到提醒开关:%@", !sender.selected ? @"打开" : @"关闭"];
    [TTStatisticsService trackEvent:TTStatisticsServiceEventSignRemindSwitch eventDescribe:desc];
    
    [XCHUDTool showGIFLoadingInView:self.view];
    [GetCore(CheckinCore) requestCheckinSignRemind];
}

#pragma mark - Private Methods
- (void)initViews {
    self.view.backgroundColor = TTCheckinMainColor();
    [self.view addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.bgLogoImageView];
    [self.bgLogoImageView addSubview:self.notifyView];
    [self.bgLogoImageView addSubview:self.checkinRemindLabel];
    [self.bgLogoImageView addSubview:self.checkinRemindSwitch];
    [self.bgLogoImageView addSubview:self.mainSlogonImageView];
    [self.bgLogoImageView addSubview:self.subSlogonLabel];
    [self.bgLogoImageView addSubview:self.ruleButton];
    [self.bgLogoImageView addSubview:self.shareButton];
    
    [self.scrollView addSubview:self.checkinInfoView];
    
    [self.scrollView addSubview:self.accumulatePrizeLabel];
    [self.scrollView addSubview:self.accumulatePrizeLeftImageView];
    [self.scrollView addSubview:self.accumulatePrizeRightImageView];
    [self.scrollView addSubview:self.accumulatePrizeView];
    
    [self.scrollView addSubview:self.prizePreviewView];
    
    if (projectType() == ProjectType_Planet) {
        self.shareButton.hidden = YES;
    }
}

- (void)initConstraints {
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            
            
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            
        } else {
            make.left.right.bottom.mas_equalTo(self.view);
            make.top.mas_equalTo(kNavigationHeight);
        }
    }];
    
    [self.bgLogoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(self.view);
    }];
    
    [self.notifyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(self.checkinRemindLabel.mas_left).offset(-12);
        make.height.mas_equalTo(14);
    }];
    
    [self.checkinRemindSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(self.bgLogoImageView).inset(15);
    }];
    
    [self.checkinRemindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.checkinRemindSwitch.mas_left).offset(-8);
        make.centerY.mas_equalTo(self.checkinRemindSwitch);
    }];
    
    [self.mainSlogonImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(50);
        make.centerX.mas_equalTo(0);
        make.left.mas_greaterThanOrEqualTo(20);
        make.right.mas_lessThanOrEqualTo(-20);
    }];
    
    [self.subSlogonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mainSlogonImageView.mas_bottom).offset(2);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(215);
        make.height.mas_equalTo(28);
    }];
    
    [self.ruleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.subSlogonLabel.mas_bottom).offset(80);
        make.right.mas_equalTo(13);
        make.height.mas_equalTo(26);
        make.width.mas_equalTo(81);
    }];
    
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.ruleButton.mas_bottom).offset(12);
        make.left.width.height.mas_equalTo(self.ruleButton);
    }];
    
    [self.checkinInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view).inset(9);
        make.centerY.mas_equalTo(self.bgLogoImageView.mas_bottom);
        make.height.mas_equalTo(244);
    }];
    
    [self.accumulatePrizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.checkinInfoView.mas_bottom).offset(24);
        make.centerX.mas_equalTo(self.view);
    }];
    [self.accumulatePrizeLeftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.accumulatePrizeLabel.mas_left).offset(-12);
        make.centerY.mas_equalTo(self.accumulatePrizeLabel);
    }];
    [self.accumulatePrizeRightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.accumulatePrizeLabel.mas_right).offset(12);
        make.centerY.mas_equalTo(self.accumulatePrizeLabel);
    }];
    [self.accumulatePrizeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.accumulatePrizeLabel.mas_bottom).offset(20);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(100);
    }];
    
    CGFloat cellWidth = (KScreenWidth - 30*2 - 10*2) / 4;
    CGFloat imageWidth = cellWidth - 20;
    CGFloat cellHeight = imageWidth + 47;
    CGFloat collectionViewHeight = cellHeight * 7;
    CGFloat top = 73;
    CGFloat bottom = 40;
    
    [self.prizePreviewView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.accumulatePrizeView.mas_bottom).offset(40);
        make.left.right.mas_equalTo(self.view).inset(9);
        make.height.mas_equalTo(top+collectionViewHeight+bottom);
    }];
}

//检查是否需实名认证
- (void)checkAuthenticationStatus {
    @KWeakify(self)
    [GetCore(UserCore) getUserInfo:GetCore(AuthCore).getUid.userIDValue refresh:YES success:^(UserInfo *info) {
        @KStrongify(self)
        
        if (info.isCertified) {
            //请求瓜分接口
            [GetCore(CheckinCore) requestCheckinDraw];
        } else {
            [self showAuthenticationAlert];
        }
        
    }failure:^(NSError *error) {
        
    }];
}

//显示实名认证弹窗
- (void)showAuthenticationAlert {
    
    TTAlertConfig *config = [[TTAlertConfig alloc] init];
    config.message = @"为了营造更安全的网络环境\n保护您和他人的财产安全\n请先进行实名认证";
    config.messageLineSpacing = 4;
    config.confirmButtonConfig.title = @"前往认证";
    
    TTAlertMessageAttributedConfig *attConfig = [[TTAlertMessageAttributedConfig alloc] init];
    attConfig.text = @"实名认证";
    
    config.messageAttributedConfig = @[attConfig];
    
    @weakify(self);
    [TTPopup alertWithConfig:config confirmHandler:^{
        @strongify(self);
        TTWKWebViewViewController *web = [[TTWKWebViewViewController alloc] init];
        web.urlString = [NSString stringWithFormat:@"%@?uid=%@", HtmlUrlKey(kIdentityURL), GetCore(AuthCore).getUid];
                         
        [self.navigationController pushViewController:web animated:YES];
    } cancelHandler:^{
    }];
}

#pragma mark - Getters and Setters
- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.backgroundColor = TTCheckinMainColor();
    }
    return _scrollView;
}

- (TTCheckinScrollNotifyView *)notifyView {
    if (_notifyView == nil) {
        _notifyView = [[TTCheckinScrollNotifyView alloc] init];
        _notifyView.hidden = YES;
    }
    return _notifyView;
}

- (UILabel *)checkinRemindLabel {
    if (_checkinRemindLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"签到提醒";
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = UIColor.whiteColor;
        label.textAlignment = NSTextAlignmentRight;
        
        [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        
        _checkinRemindLabel = label;
    }
    return _checkinRemindLabel;
}

- (UIButton *)checkinRemindSwitch {
    if (_checkinRemindSwitch == nil) {
        _checkinRemindSwitch = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkinRemindSwitch setBackgroundImage:[UIImage imageNamed:@"checkin_btn_notify_off"] forState:UIControlStateNormal];
        [_checkinRemindSwitch setBackgroundImage:[UIImage imageNamed:@"checkin_btn_notify_on"] forState:UIControlStateSelected];
        [_checkinRemindSwitch addTarget:self action:@selector(checkinRemindSwitchTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        [_checkinRemindSwitch setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _checkinRemindSwitch;
}

- (UIImageView *)mainSlogonImageView {
    if (_mainSlogonImageView == nil) {
        _mainSlogonImageView = [[UIImageView alloc] init];
        _mainSlogonImageView.image = [UIImage imageNamed:@"checkin_ico_slogon"];
    }
    return _mainSlogonImageView;
}

- (UILabel *)subSlogonLabel {
    if (_subSlogonLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"签到时间越长 奖励越丰厚";
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = UIColorFromRGB(0xfefefe);
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor.whiteColor colorWithAlphaComponent:0.14];
        label.layer.cornerRadius = 14;
        label.layer.masksToBounds = YES;
        
        _subSlogonLabel = label;
    }
    return _subSlogonLabel;
}

- (UIImageView *)bgLogoImageView {
    if (_bgLogoImageView == nil) {
        _bgLogoImageView = [[UIImageView alloc] init];
        _bgLogoImageView.userInteractionEnabled = YES;
        _bgLogoImageView.image = [UIImage imageNamed:@"checkin_bg_logo"];
    }
    return _bgLogoImageView;
}

- (TTCheckinInfoView *)checkinInfoView {
    if (_checkinInfoView == nil) {
        _checkinInfoView = [[TTCheckinInfoView alloc] init];
        
        @KWeakify(self)
        _checkinInfoView.signActionBlock = ^{
            @KStrongify(self)
            self.checkinInfoView.checkinButton.userInteractionEnabled = NO;
            
            [TTStatisticsService trackEvent:TTStatisticsServiceEventSignIn eventDescribe:@"签到按钮-签到页"];
            
            [GetCore(CheckinCore) requestCheckinSign];
        };
        _checkinInfoView.partitionCoinActionBlock = ^{
            @KStrongify(self)
            [self checkAuthenticationStatus];
        };
    }
    return _checkinInfoView;
}

- (UIButton *)ruleButton {
    if (_ruleButton == nil) {
        
        UIColor *color = (projectType()==ProjectType_LookingLove || projectType() == ProjectType_Planet) ? UIColorFromRGB(0x7073FF) : UIColorFromRGB(0x7507EC);
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = color;
        [button setTitle:@"活动规则" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button addTarget:self action:@selector(ruleButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius = 13;
        button.layer.masksToBounds = YES;
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
        
        _ruleButton = button;
    }
    return _ruleButton;
}

- (UIButton *)shareButton {
    if (_shareButton == nil) {
        
        UIColor *color = projectType()==ProjectType_LookingLove ? UIColorFromRGB(0x7073FF) : UIColorFromRGB(0x7507EC);
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = color;
        [button setTitle:@"分享好友" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button addTarget:self action:@selector(shareButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius = 13;
        button.layer.masksToBounds = YES;
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
        
        _shareButton = button;
    }
    return _shareButton;
}

- (UILabel *)accumulatePrizeLabel {
    if (_accumulatePrizeLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont boldSystemFontOfSize:18];
        label.textColor = UIColorFromRGB(0xffffff);
        label.textAlignment = NSTextAlignmentCenter;
        
        NSString *text = @"累计签到 领取相应奖励";
        NSString *prize = @"奖励";
        NSRange prizeRange = [text rangeOfString:prize];
        
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:text];
        [attri addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xFFEA01) range:prizeRange];
        label.attributedText = attri;
        
        _accumulatePrizeLabel = label;
    }
    return _accumulatePrizeLabel;
}

- (UIImageView *)accumulatePrizeLeftImageView {
    if (_accumulatePrizeLeftImageView == nil) {
        _accumulatePrizeLeftImageView = [[UIImageView alloc] init];
        _accumulatePrizeLeftImageView.image = [UIImage imageNamed:@"checkin_ico_accumulate_left"];
    }
    return _accumulatePrizeLeftImageView;
}

- (UIImageView *)accumulatePrizeRightImageView {
    if (_accumulatePrizeRightImageView == nil) {
        _accumulatePrizeRightImageView = [[UIImageView alloc] init];
        _accumulatePrizeRightImageView.image = [UIImage imageNamed:@"checkin_ico_accumulate_right"];
    }
    return _accumulatePrizeRightImageView;
}

- (TTCheckinAccumulatePrizeView *)accumulatePrizeView {
    if (_accumulatePrizeView == nil) {
        _accumulatePrizeView = [[TTCheckinAccumulatePrizeView alloc] init];
        
        @KWeakify(self)
        _accumulatePrizeView.selectPrizeBlock = ^(CheckinRewardTotalNotice * _Nonnull prize) {
            @KStrongify(self)
            self.accumulatePrizeView.userInteractionEnabled = NO;
            
            NSString *configId = @(prize.signRewardConfigId).stringValue;
            [GetCore(CheckinCore) requestCheckinReceiveTotalRewardWithConfigId:configId];
        };
        _accumulatePrizeView.drawCoinBlock = ^{
            @KStrongify(self)
            self.accumulatePrizeView.userInteractionEnabled = NO;
            
            [self checkAuthenticationStatus];
        };
    }
    return _accumulatePrizeView;
}

- (TTCheckinPrizePreviewView *)prizePreviewView {
    if (_prizePreviewView == nil) {
        _prizePreviewView = [[TTCheckinPrizePreviewView alloc] init];
        
        @KWeakify(self)
        _prizePreviewView.selectPreviewPrizeBlock = ^(CheckinRewardTodayNotice * _Nonnull prize) {
            @KStrongify(self)
            self.prizePreviewView.userInteractionEnabled = NO;
            self.replenishSignDay = prize.signDays;
            [self replenishWithSignDay:prize.signDays];
        };
    }
    return _prizePreviewView;
}

@end
