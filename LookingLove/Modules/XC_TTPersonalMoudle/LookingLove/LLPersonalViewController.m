//
//  LLPersonalViewController.m
//  XC_TTPersonalMoudle
//
//  Created by lee on 2019/7/25.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "LLPersonalViewController.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "TTStatisticsService.h"
#import "TTPersonalCellModel.h"
#import "TTPersonalSectionModel.h"
#import "TTPersonalFooterView.h"

#import "TTPersonEditViewController.h"
#import "TTDressUpContainViewController.h"
#import "TTMineContainViewController.h"
#import "TTGoldCoinViewController.h"
#import "TTCodeYellowViewController.h"
#import "TTSettingViewController.h"
#import "TTWKWebViewViewController.h"
#import "TTRecommendContainViewController.h"
#import "TTCarrotViewController.h"
#import "TTParentModelViewController.h"

//view
#import "TTPersonalheadView.h"
#import "TTPersonalMidView.h"
#import "TTPersonalBottomView.h"
//core
#import "UserCore.h"
#import "AuthCore.h"
#import "UserCoreClient.h"
#import "GuildCore.h"
#import "GuildCoreClient.h"
#import "TTServiceCore.h"
#import "AuthCoreClient.h"

//t
#import "XCHtmlUrl.h"
#import "TTGuildGroupManageConst.h"
#import "CoreManager.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "UIImage+Utils.h"
#import "UIView+ZJFrame.h"
#import "TTNewbieGuideView.h"
#import "TTPopup.h"

//bri
#import "XCMediator+TTDiscoverModuleBridge.h"
#import "XCMediator+TTMessageMoudleBridge.h"
#import "XCMediator+TTPersonalMoudleBridge.h"
#import "TTGuildViewController.h"
//
#import "XCHUDTool.h"
#import "TTRecommendContainViewController.h"

#import "TTStatisticsService.h"
#import "TTPersonalCellModel.h"
#import "TTPersonalSectionModel.h"
#import "TTPersonalFooterView.h"
#import "TTPersonalCell.h"
#import "LLPersonalViewCell.h"
#import "TTPersonalCollectionViewFlowLayout.h"
#import "LookingLoveManager.h"
#import "ClientCore.h"

#define kHeadViewHeight 230 + statusbarHeight
#define kMidViewBottomHeight 30
#define kCollectionViewSectionMargin 15
#define kHeadViewSafeTopHeight kHeadViewHeight + kMidViewBottomHeight + kCollectionViewSectionMargin - statusbarHeight

@interface LLPersonalViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, TTPersonalMidViewDelegate, TTPersonalheadViewDelegate, AuthCoreClient>

@property (nonatomic, strong) TTPersonalheadView *headView;
@property (nonatomic, strong) UIImageView *headMaskImageView; //
@property (nonatomic, strong) TTPersonalMidView  *midView;//

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *customNav;
@property (nonatomic, strong) UIButton *serverBtn; // 客服按钮

@property (nonatomic, strong) UICollectionView *collectionView;
// 组数据
@property (nonatomic, strong) NSArray<TTPersonalSectionModel *> *dataArray;
// 第一组
@property (nonatomic, strong) TTPersonalSectionModel *sectionOne;
// 第二组
@property (nonatomic, strong) TTPersonalSectionModel *sectionTwo;
// 第三组
@property (nonatomic, strong) TTPersonalSectionModel *sectionThree;

@property (nonatomic, strong) UserInfo  *useInfo;//
// 是否需要刷新用户信息（进入贵族页后需要刷新）
@property (nonatomic, assign,getter=isNeedRefreshUserInfo) BOOL needRefreshUserInfo;
@end

@implementation LLPersonalViewController

- (void)dealloc {
    RemoveCoreClientAll(self);
}

- (BOOL)isHiddenNavBar {
    return YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // hx
    [LookingLoveManager lookingLovePersonalDidShow:14];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // hx
    [LookingLoveManager lookingLovePersonalWillShow:33];
    
    if (self.isNeedRefreshUserInfo) {
        [self updateUserInfoHandler];
        self.needRefreshUserInfo = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AddCoreClient(GuildCoreClient, self);
    AddCoreClient(UserCoreClient, self);
    AddCoreClient(AuthCoreClient, self);
    
    @weakify(self);
    [[NSNotificationCenter defaultCenter] addObserverForName:TTGuildGroupManageMayUpdateHallJoinStatusNoti object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        @strongify(self);
        [self updateUserInfoHandler];
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:kNeedRefreshUserInfoNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        @strongify(self);
        [self updateUserInfoHandler];
    }];
    
    [self updateUserInfoHandler];
    self.view.backgroundColor = UIColorFromRGB(0xFAFAFA);
    [self initViews];
    [self initConstraints];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    //解决iOS12从推送进入前台跳转消息页导致底部黑屏问题
    self.view.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight-kTabBarHeight);
}

#pragma mark -
#pragma mark lifeCycle
- (void)initViews {
    
    [self.view addSubview:self.collectionView];
    [self.collectionView addSubview:self.headView];
    [self.collectionView addSubview:self.headMaskImageView];
    [self.collectionView addSubview:self.midView];
    
    [self.view addSubview:self.customNav];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.serverBtn];
}

- (void)initConstraints {
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
//
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(statusbarHeight + 13);
        make.centerX.mas_equalTo(self.view);
    }];
    
    [self.serverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(12 + statusbarHeight);
        make.right.mas_equalTo(-18);
    }];
}

#pragma mark -
#pragma mark scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offSetY = scrollView.contentOffset.y;
    CGFloat alpha = offSetY / kNavigationHeight;
    
    self.customNav.backgroundColor = UIColorRGBAlpha(0xFFFFFF, alpha);
    if (alpha >= 0.7) {
        self.titleLabel.text = @"我的";
    } else {
        self.titleLabel.text = @"";
    }
}
#pragma mark -
#pragma mark CollectionView Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    TTPersonalSectionModel *sectionModel = self.dataArray[section];
    return sectionModel.cellModelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LLPersonalViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    TTPersonalSectionModel *sectionModel = self.dataArray[(NSUInteger) indexPath.section];
    TTPersonalCellModel *cellModel = sectionModel.cellModelArray[(NSUInteger) indexPath.row];
    
    if (indexPath.item == 4) {
        if (self.useInfo.nobleUsers.expire) {
            cellModel.detail = [NSString stringWithFormat:@"剩余%ld天到期",[self getNowTimeDaySince: self.useInfo.nobleUsers.expire]];
        } else {
            cellModel.detail = @"";
        }
    } else {
        cellModel.detail = @"";
    }
    
    // 模厅公会
    if (indexPath.section == 1 && indexPath.item == 1) {
        if ([self.useInfo.hallInfo.hallId integerValue] > 0) {
            cellModel.title = self.useInfo.hallInfo.hallName;
        }
    }
    
    cell.model = cellModel;

    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return UIEdgeInsetsMake(kHeadViewSafeTopHeight , 20, 20, 20);
    }
    return UIEdgeInsetsMake(0, 20, 20, 20);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TTPersonalSectionModel *sectionModel = self.dataArray[indexPath.section];
    TTPersonalCellModel *cellModel = sectionModel.cellModelArray[indexPath.row];
    !cellModel.selectBlock ? : cellModel.selectBlock();
}

#pragma mark - delegate
/** 去编辑个人资料 */
- (void)onGotoPersonEditing {
    TTPersonEditViewController *vc = [[TTPersonEditViewController alloc] init];
    @weakify(self);
    vc.infoRefreshHandler = ^(UserInfo *currentUserInfo) {
        @strongify(self);
        self.useInfo = currentUserInfo;
        [self.collectionView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

/** 去个人主页 */
- (void)onGotoPersonView {
    
    TTMineContainViewController *vc = [[TTMineContainViewController alloc] init];
    vc.userID = _useInfo.uid;
    vc.mineInfoStyle = TTMineInfoViewStyleDefault;
    vc.userInfo = _useInfo;
    [self.navigationController pushViewController:vc animated:YES];
}

/** 豆腐块的点击事件 */
- (void)onClickFunctionType:(FunctionType)type {
    switch (type) {
        case FunctionType_Follow:
        {
            UIViewController *vc = [[XCMediator sharedInstance] ttMessageMoudle_TTFocusViewController];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case FunctionType_Fans:
        {
            UIViewController *vc = [[XCMediator sharedInstance] ttMessageMoudle_TTFansViewController];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case FunctionType_Level:
        {
            [self goToWebview:HtmlUrlKey(kLevelURL)];
        }
            break;
        case FunctionType_Charm:
        {
            [self goToWebview:HtmlUrlKey(kCharmURL)];
        }
            break;
        default:
            break;
    }
}

#pragma mark - AuthCoreClient
// 完善用户信息后发出通知
- (void)fullinUserInfoSuccess {
    [self updateUserInfoHandler];
}

// 登录后刷新
- (void)onLoginSuccess {
    [self updateUserInfoHandler];
}

#pragma mark - UserCoreClient

- (void)onCurrentUserInfoUpdate:(UserInfo *)userInfo {
    if (userInfo.uid == [GetCore(AuthCore)getUid].userIDValue) {
        self.useInfo = userInfo;
    }
}

- (void)responseGuildHallInfoFetch:(GuildHallInfo *)data errorCode:(NSNumber *)code msg:(NSString *)msg {
    if ([data isKindOfClass:[GuildHallInfo class]]) {
        self.useInfo.hallInfo = data;
        // 因为网络请求问题，需要判断一下
        if (self.useInfo.hallId > 0) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:1 inSection:1];
            [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
        }
    }
}

#pragma mark -
#pragma mark button Events
- (void)onServerBtnClickAction:(UIButton *)serverBtn {
    // 跳转客服
    @weakify(self);
    [TTPopup alertWithMessage:@"点击确认后将发起客户对话框，确认联系客服吗？" confirmHandler:^{
        @strongify(self);
//        if(GetCore(ClientCore).customerType == 1){
//            [self.navigationController pushViewController:[GetCore(TTServiceCore) getQYSessionViewController] animated:YES];
//        }else{
            TTWKWebViewViewController *webView = [[TTWKWebViewViewController alloc] init];
            webView.urlString = HtmlUrlKey(kLive800);
            [self.navigationController pushViewController:webView animated:YES];
//        }
    } cancelHandler:^{
    }];
}
#pragma mark -
#pragma mark SystemApi Delegate

#pragma mark -
#pragma mark CustomView Delegate

#pragma mark -
#pragma mark CoreClients

#pragma mark -
#pragma mark Event Response

#pragma mark -
#pragma mark Public Methods

#pragma mark -
#pragma mark Private Methods
- (NSUInteger )getNowTimeDaySince:(NSInteger)second {
    NSDate *targetDate = [NSDate dateWithTimeIntervalSince1970:second/ 1000.0];
    NSDate *date = [NSDate new];
    NSTimeInterval time = [targetDate timeIntervalSinceDate:date];
    
    NSUInteger day = time/(3600*24);
    return day;
}

/// 更新用户数据
- (void)updateUserInfoHandler {
    @weakify(self)
    UserExtensionRequest *requese = [[UserExtensionRequest alloc] init];
    requese.type = QueryUserInfoExtension_Full;
    requese.needRefresh = YES;
    [[GetCore(UserCore) queryExtensionUserInfoByWithUserID:GetCore(AuthCore).getUid.longLongValue requests:@[requese]] subscribeNext:^(id x) {
        @strongify(self)
        self.useInfo = x;
        self.headView.info = self.useInfo;
        [self.collectionView reloadData];
    }];
}
- (void)goToWebview:(NSString *)url {
    TTWKWebViewViewController *webView = [[TTWKWebViewViewController alloc] init];
    webView.urlString = url;
    webView.uid = GetCore(AuthCore).getUid.longLongValue;
    [self.navigationController pushViewController:webView animated:YES];
}
#pragma mark -
#pragma mark Getters and Setters

- (void)setUseInfo:(UserInfo *)useInfo {
    _useInfo = useInfo;
    // 赋值
    self.headView.info = _useInfo;
    self.midView.info = _useInfo;
    [self.collectionView reloadData];
    // 如果有模厅
    if (self.useInfo.hallId > 0) {
        [GetCore(GuildCore) requestGuildHallInfoFetchWithHallId:[NSString stringWithFormat:@"%lld",self.useInfo.hallId] uid:@(self.useInfo.uid).stringValue];
    }
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        TTPersonalCollectionViewFlowLayout *flowLayout = [[TTPersonalCollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        CGFloat itemW = (KScreenWidth - 40) / 3;
        flowLayout.itemSize = CGSizeMake(itemW, 100);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView setContentOffset:CGPointMake(0, 0)];
        [_collectionView registerClass:[LLPersonalViewCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}

- (NSArray<TTPersonalSectionModel *> *)dataArray {
    if (!_dataArray) {
        _dataArray = @[self.sectionOne, self.sectionTwo, self.sectionThree];
    }
    return _dataArray;
}

- (TTPersonalSectionModel *)sectionOne {
    if (!_sectionOne) {
        @weakify(self);
        // 我的礼物
        TTPersonalCellModel *giftCell = [TTPersonalCellModel normalModelWtiTitle:@"我的礼物" detail:@"" imageName:@"person_income_puding" selectBlock:^{
            @strongify(self);
            // 我的收入
            UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_diamondViewController];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        // 我的金币
        TTPersonalCellModel *goldCoinCell = [TTPersonalCellModel normalModelWtiTitle:@"金币/充值" detail:@"" imageName:@"person_recharge_puding" selectBlock:^{
            @strongify(self);
            // 我的金币/ 充值
            UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_goldCoinController];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        // 装扮商城
        TTPersonalCellModel *dressCell = [TTPersonalCellModel normalModelWtiTitle:@"装扮商城" detail:@"" imageName:@"person_dressup_puding" selectBlock:^{
            @strongify(self);
            // 装扮商城
            TTDressUpContainViewController *vc = [[TTDressUpContainViewController alloc] init];
            vc.userID = 0;
            [self.navigationController pushViewController:vc animated:YES];
        }];
        // 我的萝卜
        TTPersonalCellModel *carrotCell = [TTPersonalCellModel normalModelWtiTitle:@"我的萝卜" detail:@"" imageName:@"person_carrot_puding" selectBlock:^{
            @strongify(self);
            [TTStatisticsService trackEvent:TTStatisticsServiceEventMyRadish eventDescribe:@"我的萝卜"];
            
            TTCarrotViewController *vc = [[TTCarrotViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        // 贵族特权
        TTPersonalCellModel *nobilityCell = [TTPersonalCellModel normalModelWtiTitle:@"贵族特权" detail:@"" imageName:@"person_nobility_puding" selectBlock:^{
            @strongify(self);
            // 贵族
            self.needRefreshUserInfo = YES;
            if(self.useInfo.nobleUsers.expire){
                [self goToWebview:HtmlUrlKey(lNobilityAuthorityURL)];
            }else {
                [self goToWebview:HtmlUrlKey(kNobilityIntroURL)];
            }
        }];
        
        // 我的家族
        TTPersonalCellModel *familyCell = [TTPersonalCellModel normalModelWtiTitle:@"我的家族" detail:@"" imageName:@"person_famliy_puding" selectBlock:^{
            @strongify(self);
            [TTStatisticsService trackEvent:TTStatisticsServiceEventMyFamilyEntranceClick
                              eventDescribe:@"我的 我的家族入口"];
            
            // 家族
            if (self.useInfo.familyId){
                UIViewController *vc = [[XCMediator sharedInstance] ttDiscoverMoudle_TTFamilyPersonViewController:self.useInfo.familyId];
                [self.navigationController pushViewController:vc animated:YES];
            }else {
                UIViewController *vc = [[XCMediator sharedInstance] ttDiscoverMoudle_TTFamilyEmptyViewController];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }];
        
        giftCell.cornerType = UIRectCornerTopLeft;
        carrotCell.cornerType = UIRectCornerTopRight;
        dressCell.cornerType = UIRectCornerBottomLeft;
        familyCell.cornerType = UIRectCornerBottomRight;
        
        _sectionOne = [TTPersonalSectionModel normalModelWithHeadDesc:@"" footDesc:@"" sectionCellModelArray:@[giftCell, goldCoinCell, carrotCell, dressCell, nobilityCell, familyCell]];
    }
    return _sectionOne;
}

- (TTPersonalSectionModel *)sectionTwo {
    if (!_sectionTwo) {
        @weakify(self);
        // 我的推荐位
        TTPersonalCellModel *recommendCell = [TTPersonalCellModel normalModelWtiTitle:@"我的推荐位" detail:@"" imageName:@"person_recommend_puding" selectBlock:^{
            @strongify(self);
            [TTStatisticsService trackEvent:TTStatisticsServiceMyRecommendClick eventDescribe:@"我的推荐位"];
            // 我的推荐位
            TTRecommendContainViewController *vc = [[TTRecommendContainViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        
        // 我的厅
        TTPersonalCellModel *guildCell = [TTPersonalCellModel normalModelWtiTitle:@"我的厅" detail:@"" imageName:@"person_guild_puding" selectBlock:^{
            @strongify(self);
            [TTStatisticsService trackEvent:TTStatisticsServiceEventHallEntranceClick
                              eventDescribe:@"我的 我的厅入口"];
            
            // 公会/模厅
            if (self.useInfo.hallId) {
                TTGuildViewController *vc = [[TTGuildViewController alloc] init];
                @weakify(self);
                vc.guildNameRefreshHandler = ^(NSString * _Nonnull guildName) {
                    @strongify(self);
                    self.useInfo.hallInfo.hallName = guildName;
//                    [self.tableView reloadData];
                };
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                [XCHUDTool showErrorWithMessage:@"你还没有加入厅哦" inView:self.view];
            }
        }];
        
        // 官方主播
        TTPersonalCellModel *certificationCell = [TTPersonalCellModel normalModelWtiTitle:@"官方主播" detail:@"" imageName:@"person_ico_officitial_certification" selectBlock:^{
            
            @strongify(self);
            [self goToWebview:HtmlUrlKey(kOfficialAnchorCertificationURL)];
            
            [TTStatisticsService trackEvent:@"my_official_anchor" eventDescribe:@"官方主播"];
        }];
        
        recommendCell.cornerType = UIRectCornerTopLeft | UIRectCornerBottomLeft;
        certificationCell.cornerType = UIRectCornerTopRight | UIRectCornerBottomRight;
        
        _sectionTwo = [TTPersonalSectionModel normalModelWithHeadDesc:@"" footDesc:@"" sectionCellModelArray:@[recommendCell, guildCell, certificationCell]];
    }
    return _sectionTwo;
}

- (TTPersonalSectionModel *)sectionThree {
    if (!_sectionThree) {
        @weakify(self);
        
        // 实名认证
        TTPersonalCellModel *authNameCell = [TTPersonalCellModel normalModelWtiTitle:@"实名认证" detail:@"" imageName:@"person_authName_puding" selectBlock:^{
            @strongify(self);
            // 实名认证
            [self goToWebview:[NSString stringWithFormat:@"%@?uid=%@", HtmlUrlKey(kIdentityURL), GetCore(AuthCore).getUid]];
        }];
        
        // 家长模式
        TTPersonalCellModel *personNameCell = [TTPersonalCellModel normalModelWtiTitle:@"青少年模式" detail:@"" imageName:@"person_patriarch_puding" selectBlock:^{
            @strongify(self);
            
            // 家长模式
            TTParentModelViewController *vc = [[TTParentModelViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            
        }];
        
        // 设置
        TTPersonalCellModel *settingCell = [TTPersonalCellModel normalModelWtiTitle:@"设置" detail:@"" imageName:@"person_setting_puding" selectBlock:^{
            @strongify(self);
            // 设置
            TTSettingViewController *vc = [[TTSettingViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            
        }];
        
        authNameCell.cornerType = UIRectCornerTopLeft | UIRectCornerBottomLeft;
        settingCell.cornerType = UIRectCornerTopRight | UIRectCornerBottomRight;
        
        _sectionThree = [TTPersonalSectionModel normalModelWithHeadDesc:@"" footDesc:@"" sectionCellModelArray:@[authNameCell, personNameCell, settingCell]];
    }
    return _sectionThree;
}

- (TTPersonalheadView *)headView {
    if (!_headView) {
        _headView = [[TTPersonalheadView alloc] initWithFrame:CGRectMake(0, -statusbarHeight, KScreenWidth, kHeadViewHeight)];
        _headView.delegate = self;
    }
    return _headView;
}

- (TTPersonalMidView *)midView {
    if (!_midView) {
        _midView = [[TTPersonalMidView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headView.frame) - 60, KScreenWidth, 90)];
        _midView.delegate = self;
    }
    return _midView;
}

- (UIButton *)serverBtn {
    if (!_serverBtn) {
        _serverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_serverBtn setTitle:@"客服" forState:UIControlStateNormal];
        _serverBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_serverBtn setTitleColor:[XCTheme getMSMainTextColor] forState:UIControlStateNormal];
        [_serverBtn setImage:[UIImage imageNamed:@"person_service"] forState:UIControlStateNormal];
        [_serverBtn addTarget:self action:@selector(onServerBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        _serverBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
    }
    return _serverBtn;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColorRGBAlpha(0xE4E4E4, 0.5);
    }
    return _lineView;
}

- (UIView *)customNav {
    if (!_customNav) {
        _customNav = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, kNavigationHeight)];
    }
    return _customNav;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [XCTheme getMSMainTextColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18.f];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _titleLabel;
}

- (UIImageView *)headMaskImageView {
    if (!_headMaskImageView) {
        _headMaskImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headView.frame) - 63, KScreenWidth, 63)];
        _headMaskImageView.image = [UIImage imageNamed:@"personal_head_mask"];
    }
    return _headMaskImageView;
}

@end
