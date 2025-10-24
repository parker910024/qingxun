//
//  TTInviteRewardsViewController.m
//  TuTu
//
//  Created by lvjunhang on 2018/11/20.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTInviteRewardsViewController.h"
#import "TTInviteRewardsNavigationView.h"
#import "TTInviteRewardsMsgCycleCell.h"
#import "XCMediator+TTPersonalMoudleBridge.h"
#import "TTWKWebViewViewController.h"

#import <Masonry/Masonry.h>
#import "SDCycleScrollView.h"

#import "XCTheme.h"
#import "XCMacros.h"
#import "XCKeyWordTool.h"
#import "XCHtmlUrl.h"

#import "AuthCore.h"
#import "PurseBillCoreClient.h"
#import "PurseBillCore.h"
#import "RedPageDetailInfo.h"
#import "WithdrawalShowInfo.h"

@interface TTInviteRewardsViewController ()<TTInviteRewardsNavigationViewDelegate, SDCycleScrollViewDelegate>
@property (nonatomic, strong) TTInviteRewardsNavigationView *navigationView;
@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) UIButton *ruleButton;//活动规则
@property (nonatomic, strong) UIButton *skillButton;//奖励秘籍

@property (nonatomic, strong) UIImageView *redColorBgView;//Hong-Bao背景
@property (nonatomic, strong) UILabel *rewardsMoneyLabel;//奖励金额
@property (nonatomic, strong) SDCycleScrollView *rewardsMsgCycleScrollView;//喇叭：实时奖励榜单

@property (nonatomic, strong) UIImageView *infoBoardBgView;//信息面板：已成功邀请、我的fc奖励
@property (nonatomic, strong) UILabel *successInviteLabel;//已成功邀请
@property (nonatomic, strong) UILabel *successInviteCountLabel;//已成功邀请
@property (nonatomic, strong) UIButton *successInviteButton;//已成功邀请

@property (nonatomic, strong) UILabel *bonusRewardsLabel;//我的fc奖励
@property (nonatomic, strong) UILabel *bonusRewardsCountLabel;//我的fc奖励
@property (nonatomic, strong) UIButton *bonusRewardsButton;//我的fc奖励

@property (nonatomic, strong) UIButton *checkRankButton;//查看排名

@property (nonatomic, strong) UIButton *outputButton;//立即提现

@property (nonatomic, strong) NSArray *rewardsMsgContentArray;
@end

@implementation TTInviteRewardsViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"我的%@奖励", [XCKeyWordTool sharedInstance].xcRedColor];
    
    [self initViews];
    [self initConstraints];
    
    AddCoreClient(PurseBillCoreClient, self);
    
    [GetCore(PurseBillCore) getRedPageInfo];
    [GetCore(PurseBillCore) getWithdrawalShowInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadNumData:) name:@"kTuTuCodeRedRefreshNumNoti" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)dealloc {
    RemoveCoreClientAll(self);
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

#pragma mark - Override
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)isHiddenNavBar {
    return YES;
}

- (void)reloadNumData:(NSNotification *)noti {
    [GetCore(PurseBillCore) getRedPageInfo];
}

#pragma mark - Public Methods
#pragma mark - System Protocols
#pragma mark - Custom Protocols
#pragma mark TTInviteRewardsNavigationViewDelegate
- (void)navigationViewClickLeftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navigationViewClickRightAction {
    UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_billListViewController:4];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark SDCycleScrollViewDelegate
- (Class)customCollectionViewCellClassForCycleScrollView:(SDCycleScrollView *)view {
    return TTInviteRewardsMsgCycleCell.class;
}

- (void)setupCustomCell:(UICollectionViewCell *)cell forIndex:(NSInteger)index cycleScrollView:(SDCycleScrollView *)view {
    TTInviteRewardsMsgCycleCell *cycleCell = (TTInviteRewardsMsgCycleCell *)cell;
//    cycleCell.content = [self.rewardsMsgContentArray safeObjectAtIndex:index];
    cycleCell.content = @"满70米可联系客服领取贵族体验券哦！";
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
}

#pragma mark - Core Protocols
#pragma mark PurseBillCoreClient
- (void)getRedPageInfoSuccess {
    RedPageDetailInfo *redPageInfo = GetCore(PurseBillCore).redPageDetailInfo;
    // 如果不到 100R 就隐藏提现按钮
    if (redPageInfo.packetNum.floatValue >= 100.00) {
        self.outputButton.hidden = NO;
    }
    NSString *money = [NSString stringWithFormat:@"%.2f米", redPageInfo.packetNum.floatValue];
    NSString *reg = [NSString stringWithFormat:@"%@人", redPageInfo.registerCout];
    NSString *bonus = [NSString stringWithFormat:@"%@米", redPageInfo.chargeBonus];
    
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:money];
    [attriString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:24] range:NSMakeRange(0, money.length-1)];
    [attriString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(money.length-1, 1)];
    
    self.rewardsMoneyLabel.attributedText = attriString;
    if (redPageInfo.registerCout) {
        self.successInviteCountLabel.text = reg;
    }
    if (redPageInfo.chargeBonus) {
        self.bonusRewardsCountLabel.text = bonus;
    }
}

- (void)RedPageDetailInfoFailth:(NSString *)message {
}

- (void)requestWithdrawalShowInfoSuccess:(NSMutableArray *)showInfoList {
    if (showInfoList.count == 0) {
        return;
    }
    
    NSMutableArray *mArray = [NSMutableArray array];
    
    for (WithdrawalShowInfo *item in showInfoList) {
        NSString *string = item.nick;
        string = [string stringByAppendingString:[NSString stringWithFormat:@"刚刚%@了%@米",[[XCKeyWordTool sharedInstance] xcGetCF], item.packetNum]];
        [mArray addObject:string];
    }
    
    self.rewardsMsgContentArray = [mArray copy];
//    self.rewardsMsgCycleScrollView.imageURLStringsGroup = [mArray copy];
}

- (void)requestWithdrawalShowInfoFailth:(NSString *)message {
}

#pragma mark - Event Responses
- (void)checkRankButtonTapped:(UIButton *)sender {
    TTWKWebViewViewController *vc = [[TTWKWebViewViewController alloc]init];
    vc.urlString = [NSString stringWithFormat:@"%@?uid=%@",HtmlUrlKey(kInvitationRankURL),[GetCore(AuthCore) getUid]];;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)outputButtonTapped:(UIButton *)sender {
    
    UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_redDrawalsViewController];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)ruleButtonTapped:(UIButton *)sender {
    TTWKWebViewViewController *vc = [[TTWKWebViewViewController alloc]init];
    vc.urlString = HtmlUrlKey(kInviteFightRuleURL);
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)skillButtonTapped:(UIButton *)sender {
    TTWKWebViewViewController *vc = [[TTWKWebViewViewController alloc]init];
    vc.urlString = HtmlUrlKey(kInvitationCheatsURL);
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)successInviteButtonTapped:(UIButton *)sender {
    TTWKWebViewViewController *vc = [[TTWKWebViewViewController alloc]init];
    vc.urlString = [NSString stringWithFormat:@"%@?uid=%@", HtmlUrlKey(kInvitationDetailURL),[GetCore(AuthCore) getUid]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)bonusRewardsButtonTapped:(UIButton *)sender {
    TTWKWebViewViewController *vc = [[TTWKWebViewViewController alloc]init];
    vc.urlString = [NSString stringWithFormat:@"%@?uid=%@", HtmlUrlKey(kRevenueDetailURL),[GetCore(AuthCore) getUid]];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Private Methods
- (void)initViews {
    [self.view addSubview:self.bgImageView];
    [self.view addSubview:self.navigationView];
    
    [self.view addSubview:self.ruleButton];
    [self.view addSubview:self.skillButton];
    
    [self.view addSubview:self.redColorBgView];
    [self.view addSubview:self.rewardsMoneyLabel];
    [self.view addSubview:self.rewardsMsgCycleScrollView];
    
    [self.view addSubview:self.infoBoardBgView];
    [self.view addSubview:self.successInviteLabel];
    [self.view addSubview:self.successInviteCountLabel];
    [self.view addSubview:self.successInviteButton];
    [self.view addSubview:self.bonusRewardsLabel];
    [self.view addSubview:self.bonusRewardsCountLabel];
    [self.view addSubview:self.bonusRewardsButton];
    
    [self.view addSubview:self.checkRankButton];
    [self.view addSubview:self.outputButton];
}

- (void)initConstraints {
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(statusbarHeight+44);
    }];
    
    [self.ruleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(statusbarHeight+90);
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(46);
        make.height.mas_equalTo(40);
    }];
    [self.skillButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.ruleButton.mas_bottom).offset(15);
        make.right.width.height.mas_equalTo(self.ruleButton);
    }];
    
    [self.redColorBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (KScreenWidth > 320  && statusbarHeight > 20) {
            make.top.mas_equalTo(300);
        } else if (KScreenWidth < 321) {
            make.top.mas_equalTo(160);
        } else {
            make.top.mas_equalTo(230);
        }
        make.left.right.mas_equalTo(self.view).inset(40);
    }];
    [self.rewardsMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.redColorBgView.mas_top).offset(123);
        make.centerX.mas_equalTo(0);
    }];
    [self.rewardsMsgCycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.infoBoardBgView.mas_top).offset(-4);
        make.left.right.mas_equalTo(self.redColorBgView).inset(12);
        make.height.mas_equalTo(35);
    }];
    
    [self.infoBoardBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view).inset(20);
        make.bottom.mas_equalTo(self.redColorBgView.mas_bottom).offset(15);
    }];
    [self.successInviteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.infoBoardBgView).offset(26);
        make.left.mas_equalTo(self.redColorBgView).offset(18);
    }];
    [self.successInviteCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.successInviteLabel.mas_bottom).offset(12);
        make.centerX.mas_equalTo(self.successInviteLabel);
    }];
    [self.successInviteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.successInviteLabel);
        make.bottom.mas_equalTo(self.successInviteCountLabel);
    }];
    [self.bonusRewardsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.successInviteLabel);
        make.right.mas_equalTo(self.redColorBgView).offset(-18);
    }];
    [self.bonusRewardsCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.successInviteCountLabel);
        make.centerX.mas_equalTo(self.bonusRewardsLabel);
    }];
    [self.bonusRewardsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.bonusRewardsLabel);
        make.bottom.mas_equalTo(self.bonusRewardsCountLabel);
    }];

    [self.checkRankButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.infoBoardBgView.mas_bottom).offset(13-5);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(88);
        make.height.mas_equalTo(26);
    }];
    
    [self.outputButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view).inset(53);
        make.bottom.mas_equalTo(-27-kSafeAreaBottomHeight);
        make.height.mas_equalTo(40);
    }];
}

- (UIButton *)leftCornerButtonWithTitle:(NSString *)title selector:(SEL)selector {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    button.titleLabel.numberOfLines = 2;
    button.backgroundColor = [XCTheme getTTMainColor];
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    
    [self addRoundedButton:button corners:UIRectCornerTopLeft|UIRectCornerBottomLeft withRadii:CGSizeMake(20, 20) viewRect:CGRectMake(0, 0, 46, 40)];
    
    return button;
}

/**
 *  设置部分圆角(相对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 *  @param rect    需要设置的圆角view的rect
 */
- (void)addRoundedButton:(UIButton *)button
                 corners:(UIRectCorner)corners
                withRadii:(CGSize)radii
                 viewRect:(CGRect)rect {
    
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:radii];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    
    button.layer.mask = shape;
}

#pragma mark - Getters and Setters
- (TTInviteRewardsNavigationView *)navigationView {
    if (_navigationView == nil) {
        _navigationView = [[TTInviteRewardsNavigationView alloc] init];
        _navigationView.delegate = self;
    }
    return _navigationView;
}

- (UIImageView *)bgImageView {
    if (_bgImageView == nil) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = [UIImage imageNamed:@"invite_rewards_bg"];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImageView.clipsToBounds = YES;
    }
    return _bgImageView;
}

- (UIButton *)ruleButton {
    if (_ruleButton == nil) {
        _ruleButton = [self leftCornerButtonWithTitle:@"活动\n规则" selector:@selector(ruleButtonTapped:)];
    }
    return _ruleButton;
}

- (UIButton *)skillButton {
    if (_skillButton == nil) {
        _skillButton = [self leftCornerButtonWithTitle:@"奖励\n秘籍" selector:@selector(skillButtonTapped:)];
    }
    return _skillButton;
}

- (UIImageView *)redColorBgView {
    if (_redColorBgView == nil) {
        _redColorBgView = [[UIImageView alloc] init];
        _redColorBgView.image = [UIImage imageNamed:@"invite_rewards_red_color"];
        _redColorBgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _redColorBgView;
}

- (UILabel *)rewardsMoneyLabel {
    if (_rewardsMoneyLabel == nil) {
        _rewardsMoneyLabel = [[UILabel alloc] init];
        _rewardsMoneyLabel.text = @"0米";
        _rewardsMoneyLabel.font = [UIFont systemFontOfSize:24];
        _rewardsMoneyLabel.textColor = UIColorFromRGB(0xFB6654);
    }
    return _rewardsMoneyLabel;
}

- (SDCycleScrollView *)rewardsMsgCycleScrollView {
    if (_rewardsMsgCycleScrollView == nil) {
        _rewardsMsgCycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, KScreenWidth, 35) delegate:self placeholderImage:nil];
        _rewardsMsgCycleScrollView.showPageControl = NO;
        _rewardsMsgCycleScrollView.backgroundColor = [UIColor clearColor];
        [_rewardsMsgCycleScrollView disableScrollGesture];
        _rewardsMsgCycleScrollView.autoScroll = NO;
        _rewardsMsgCycleScrollView.imageURLStringsGroup = @[@"满70米可联系客服领取贵族体验券哦！"];
        _rewardsMsgCycleScrollView.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _rewardsMsgCycleScrollView;
}

- (UIImageView *)infoBoardBgView {
    if (_infoBoardBgView == nil) {
        _infoBoardBgView = [[UIImageView alloc] init];
        _infoBoardBgView.image = [[UIImage imageNamed:@"invite_rewards_rect"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    }
    return _infoBoardBgView;
}

- (UILabel *)successInviteLabel {
    if (_successInviteLabel == nil) {
        _successInviteLabel = [[UILabel alloc] init];
        _successInviteLabel.text = @"已成功邀请";
        _successInviteLabel.font = [UIFont systemFontOfSize:15];
        _successInviteLabel.textColor = UIColorFromRGB(0x085370);
    }
    return _successInviteLabel;
}

- (UILabel *)successInviteCountLabel {
    if (_successInviteCountLabel == nil) {
        _successInviteCountLabel = [[UILabel alloc] init];
        _successInviteCountLabel.text = @"0人";
        _successInviteCountLabel.font = [UIFont systemFontOfSize:15];
        _successInviteCountLabel.textColor = UIColorFromRGB(0x085370);
    }
    return _successInviteCountLabel;
}

- (UIButton *)successInviteButton {
    if (_successInviteButton == nil) {
        _successInviteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_successInviteButton addTarget:self action:@selector(successInviteButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _successInviteButton;
}

- (UILabel *)bonusRewardsLabel {
    if (_bonusRewardsLabel == nil) {
        _bonusRewardsLabel = [[UILabel alloc] init];
        _bonusRewardsLabel.text = [NSString stringWithFormat:@"我的%@奖励", [XCKeyWordTool sharedInstance].xcShare];
        _bonusRewardsLabel.font = [UIFont systemFontOfSize:15];
        _bonusRewardsLabel.textColor = UIColorFromRGB(0x085370);
    }
    return _bonusRewardsLabel;
}

- (UILabel *)bonusRewardsCountLabel {
    if (_bonusRewardsCountLabel == nil) {
        _bonusRewardsCountLabel = [[UILabel alloc] init];
        _bonusRewardsCountLabel.text = @"0米";
        _bonusRewardsCountLabel.font = [UIFont systemFontOfSize:15];
        _bonusRewardsCountLabel.textColor = UIColorFromRGB(0x085370);
    }
    return _bonusRewardsCountLabel;
}

- (UIButton *)bonusRewardsButton {
    if (_bonusRewardsButton == nil) {
        _bonusRewardsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bonusRewardsButton addTarget:self action:@selector(bonusRewardsButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bonusRewardsButton;
}

- (UIButton *)checkRankButton {
    if (_checkRankButton == nil) {
        _checkRankButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkRankButton setTitle:@"查看排行" forState:UIControlStateNormal];
        [_checkRankButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _checkRankButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _checkRankButton.layer.cornerRadius = 13;
        _checkRankButton.backgroundColor = [XCTheme getTTMainColor];
        [_checkRankButton addTarget:self action:@selector(checkRankButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _checkRankButton;
}

- (UIButton *)outputButton {
    if (_outputButton == nil) {
        _outputButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_outputButton setTitle:[NSString stringWithFormat:@"立即%@",[XCKeyWordTool sharedInstance].xcGetCF] forState:UIControlStateNormal];
        [_outputButton setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateNormal];
        _outputButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _outputButton.layer.cornerRadius = 20;
        _outputButton.hidden = YES;
        _outputButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6];
        [_outputButton addTarget:self action:@selector(outputButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _outputButton;
}
@end
