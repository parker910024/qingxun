//
//  LLRechargeViewController.m
//  XC_TTPersonalMoudle
//
//  Created by lee on 2019/7/27.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "LLRechargeViewController.h"
#import "TTRechargeViewCell.h"
#import "TTCodeBlueViewController.h"
#import "TTBillListViewController.h"
#import "TTWalletEnumConst.h"
#import "TTParentModelViewController.h"

#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"
#import "XCHUDTool.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "XCKeyWordTool.h"
#import "NSString+MessageDigest.h"
#import "HostUrlManager.h"
#import "TTPopup.h"

//model
#import "RechargeInfo.h"
#import "BalanceInfo.h"

//core
#import "AuthCore.h"
#import "UserCore.h"
#import "PurseCore.h"
#import "PurseCoreClient.h"
#import "VersionCore.h"
#import "LookingLoveUtils.h"

@interface LLRechargeViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
PurseCoreClient,
UICollectionViewDelegateFlowLayout
>
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *infoView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *infoNameLabel;
@property (nonatomic, strong) UILabel *balanceNumLabel;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIButton *exchangeBtn; // 兑换
@property (nonatomic, strong) UIButton *rechargeBtn; // 立即充值

@property (nonatomic, strong) BalanceInfo *balanceInfo; // 提现账户信息
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) NSInteger index;  // 被选中的 index
@property (nonatomic, strong) UserInfo *userInfo;

@property (nonatomic, assign) BOOL isRecharging; // 提现过程中

@end

@implementation LLRechargeViewController

- (void)dealloc
{
    RemoveCoreClientAll(self);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // hx
    [LookingLoveUtils lookingLoveWillShowRecharge:53];
    
    NSString * myuid = GetCore(AuthCore).getUid;
    [GetCore(PurseCore) requestBalanceInfo:myuid.userIDValue];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    AddCoreClient(PurseCoreClient, self);
    
    [self requestRechargeIPAList];
    
    [self baseUI];
    [self initViews];
    [self initConstraints];
}

- (void)requestRechargeIPAList {
    #ifdef DEBUG
        EnvironmentType env = [[NSUserDefaults standardUserDefaults]integerForKey:kAppNetWorkEnv];
        if (env==DevType){
            [GetCore(PurseCore) requestRechargeListWithChannelType:IAPChannelType_HHPlay];
        } else if (env==TestType){
            [GetCore(PurseCore) requestRechargeListWithChannelType:IAPChannelType_HHPlay];
        } else if (env==Pre_ReleaseType){
            [GetCore(PurseCore) requestRechargeListWithChannelType:IAPChannelType_LookingLove];
        } else if (env==ReleaseType){
            [GetCore(PurseCore) requestRechargeListWithChannelType:IAPChannelType_LookingLove];
        } else{
            //默认是测试环境
            [GetCore(PurseCore) requestRechargeListWithChannelType:IAPChannelType_HHPlay];
        }
        
    #else
        [GetCore(PurseCore) requestRechargeListWithChannelType:IAPChannelType_LookingLove];
    #endif

        _isRecharging = NO;
        _index = 0;
}

#pragma mark -
#pragma mark lifeCycle
- (void)baseUI {
    self.navigationItem.title = @"金币充值";
    [self addNavigationItemWithTitles:@[@"充值记录"] titleColor:[XCTheme getTTDeepGrayTextColor] isLeft:NO target:self action:@selector(rightItemClickAction:) tags:@[@(1001)]];
    _userInfo = [GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.longLongValue];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:_userInfo.avatar]];
    self.infoNameLabel.text = _userInfo.nick;
}

- (void)initViews {
    [self.view addSubview:self.containerView];
    [self.containerView addSubview:self.infoView];
    [self.containerView addSubview:self.titleLabel];
    [self.containerView addSubview:self.collectionView];
    //    [self.containerView addSubview:self.exchangeBtn];
    [self.containerView addSubview:self.rechargeBtn];
    
    [self.infoView addSubview:self.iconImageView];
    [self.infoView addSubview:self.infoNameLabel];
    [self.infoView addSubview:self.balanceNumLabel];
    [self.infoView addSubview:self.lineView];
}

- (void)initConstraints {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11, *)) {
//            make.edges.equalTo(self.view.mas_safeAreaLayoutGuide);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kSafeTopBarHeight, 0, 0, 0));
        }
    }];
    
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(75);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(45, 45));
    }];
    
    [self.infoNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(15);
        make.top.mas_equalTo(self.iconImageView);
        make.right.mas_lessThanOrEqualTo(0);
    }];
    
    [self.balanceNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.infoNameLabel);
        make.bottom.mas_equalTo(self.iconImageView);
        make.right.mas_lessThanOrEqualTo(0);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.infoView.mas_bottom).offset(15);
    }];
    
    //    [self.exchangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.mas_equalTo(25);
    //        make.bottom.mas_equalTo(0).inset(31);
    //        make.height.mas_equalTo(40);
    //        make.right.equalTo(self.containerView.mas_centerX).inset(25); // 有点意思
    //    }];
    
    [self.rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.right.mas_equalTo(0).inset(25);
        //        make.bottom.mas_equalTo(0).inset(31);
        //        make.height.mas_equalTo(40);
        //        make.left.equalTo(self.containerView.mas_centerX).offset(-10); // 同上
        
        make.left.right.mas_equalTo(0).inset(25);
        make.height.mas_equalTo(46);
        make.bottom.mas_equalTo(-31);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.titleLabel.mas_bottom);
        make.bottom.mas_equalTo(self.rechargeBtn.mas_top);
    }];
}

#pragma mark -
#pragma mark collectionView deleaget & dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TTRechargeViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TTRechargeViewCell class]) forIndexPath:indexPath];
    if (self.dataArray.count > indexPath.item) {
        cell.rechargeInfo = self.dataArray[indexPath.item];
    }
    
    if (indexPath.item == _index) {
        cell.isSelected = YES;
    } else {
        cell.isSelected = NO;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_isRecharging) {
        return;
    }
    
    if (indexPath.item == _index) {
        return;
    }
    //    TTRechargeViewCell *cell = (TTRechargeViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    //    [cell setSelected:YES];
    _index = indexPath.item;
    [collectionView reloadData];
}

#pragma mark -
#pragma mark button click events
- (void)exchangeBtnClickAction:(UIButton *)btn {
    // 去兑换
    //    TTCodeBlueViewController *vc = [[TTCodeBlueViewController alloc] init];
    //    [self.navigationController pushViewController:vc animated:YES];
}

- (void)rechargeBtnClickAction:(UIButton *)btn {
    
    //    NSString *uid = GetCore(AuthCore).getUid;
    //    NSString *ticket = GetCore(AuthCore).getTicket;
    //    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/modules/recharge/index.html?uid=%@&ticket=%@", [HostUrlManager shareInstance].hostUrl, uid, ticket.MD5]]];
    //    return;
    
    // 进行内购充值
    [self isRecharg]; // 正在进行充值
    
    if (self.dataArray.count == 0) {
        return;
    }
    
    if (self.dataArray.count > _index) {
        _isRecharging = YES;
        RechargeInfo *info = self.dataArray[_index];
        
        [XCHUDTool showGIFLoading];
        [GetCore(PurseCore) requestApplyRecharge:info.chargeProdId channel:@"zxc"];
    }
}

- (void)rightItemClickAction:(UIBarButtonItem *)item {
    // 充值历史
    TTBillListViewController *vc = [[TTBillListViewController alloc] init];
    vc.listViewType = TTBillListViewTypeRecharge;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
#pragma mark PurseCoreClient
// info
- (void)onBalanceInfoUpdate:(BalanceInfo *)balanceInfo {
    _balanceInfo = balanceInfo;
    self.balanceNumLabel.text = [NSString stringWithFormat:@"余额：%@金币", balanceInfo.goldNum];
    //    if (balanceInfo.diamondNum.floatValue > 200.00) { // 兑换金币：限制200钻以上才可以显示兑换金币；
    //        self.exchangeBtn.hidden = NO;
    //    } else {
    //        [self.rechargeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
    //            make.left.right.mas_equalTo(0).inset(25);
    //            make.height.mas_equalTo(40);
    //            make.bottom.mas_equalTo(-31);
    //        }];
    //    }
}
// list
- (void)onRequestRechargeListSuccess:(NSArray *)list {
    _dataArray = list;
    [self.collectionView reloadData];
}

- (void)onRequestRechargeListFailth {
}

//MARK:苹果内购流程
- (void)entryRequestProductProgressStatus:(BOOL)Status {
    if (Status == YES) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [XCHUDTool showGIFLoading];
        });
    } else {
        [XCHUDTool showErrorWithMessage:@"网络异常，发起付款失败"];
        [self isRecharg];
    }
}

- (void)entryPurchaseProcessStatus:(XCPaymentStatus)Status {
    [XCHUDTool hideHUD];
    if (Status == XCPaymentStatusPurchased) {
        [XCHUDTool showGIFLoading];
    } else if (Status == XCPaymentStatusPurchasing) {
        [XCHUDTool showGIFLoading];
    } else if (Status == XCPaymentStatusFailed) {
        [XCHUDTool showErrorWithMessage:@"购买失败"];
    } else if (Status == XCPaymentStatusDeferred) {
        [XCHUDTool showErrorWithMessage:@"出现未知错误，请重新尝试"];
    }
    [self isRecharg];
}

/// 内购接口获取不到商品 or 商品数量时调用的回调
/// @param reason 失败的原因
- (void)entryRequestProductFail:(NSString *)reason {
    dispatch_async(dispatch_get_main_queue(), ^{
        [XCHUDTool hideHUD];
        [XCHUDTool showErrorWithMessage:reason];
    });
    [self isRecharg];
}
- (void)entryCheckReceiptSuccess {
    [self isRecharg];
    [XCHUDTool hideHUD];
    [XCHUDTool showSuccessWithMessage:@"购买成功"];
    
    // 如果有首次的一元充值，充值成功后需要刷新列表
    RechargeInfo *info = self.dataArray[0];
    if ([info.money isEqualToNumber:@1]) {
        [self requestRechargeIPAList];
    }
}

- (void)entryCheckReceiptFaildWithMessage:(NSString *)message {
    [self isRecharg];
    [XCHUDTool hideHUD];
    [XCHUDTool showErrorWithMessage:@"验证失败，请稍后再试"];
}

- (void)addRechargeOrderFail:(NSString *)message code:(NSNumber *)code {

    [self isRecharg];
    [XCHUDTool hideHUD];

     if (code.integerValue == 25000) { // code = 25000 时候，在青少年模式下，充值已达上限
        
        TTAlertConfig *config = [[TTAlertConfig alloc] init];
        config.cancelButtonConfig.title = @"去关闭";
        config.confirmButtonConfig.title = @"知道了";
        config.message = message;
        
        @weakify(self);
        [TTPopup alertWithConfig:config confirmHandler:^{ // 知道了
        } cancelHandler:^{ // 去关闭
            @strongify(self);
            TTParentModelViewController *vc = [[TTParentModelViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }];
     } else {
         [XCHUDTool showErrorWithMessage:message];
     }
}

- (void)isRecharg {
    _isRecharging = NO;
    self.collectionView.userInteractionEnabled = YES;
}

#pragma mark -
#pragma mark getter & setter
- (UIView *)infoView
{
    if (!_infoView) {
        _infoView = [[UIView alloc] init];
        _infoView.backgroundColor = [UIColor whiteColor];
        _infoView.userInteractionEnabled = YES;
    }
    return _infoView;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[XCTheme defaultTheme].default_avatar]];
        _iconImageView.layer.cornerRadius = 22.5f;
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.backgroundColor = [UIColor orangeColor];
    }
    return _iconImageView;
}

- (UILabel *)infoNameLabel
{
    if (!_infoNameLabel) {
        _infoNameLabel = [[UILabel alloc] init];
        _infoNameLabel.textColor = [XCTheme getMSMainTextColor];
        _infoNameLabel.font = [UIFont systemFontOfSize:15.f];
        _infoNameLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _infoNameLabel;
}

- (UILabel *)balanceNumLabel
{
    if (!_balanceNumLabel) {
        _balanceNumLabel = [[UILabel alloc] init];
        _balanceNumLabel.textColor = [XCTheme getMSMainTextColor];
        _balanceNumLabel.font = [UIFont systemFontOfSize:15.f];
        _balanceNumLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _balanceNumLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [XCTheme getTTSimpleGrayColor];
    }
    return _lineView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"选择充值金额";
        _titleLabel.textColor = [XCTheme getMSMainTextColor];
        _titleLabel.font = [UIFont systemFontOfSize:15.f];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _titleLabel;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat inset = 15.f;
        CGFloat itemSpace = 10.f;
        CGFloat itemH = 60.f;
        CGFloat itemW = (KScreenWidth - inset * 2 - itemSpace * 2) / 3;
        
        // 如果是轻寻项目
        itemH = 51;
        itemW = KScreenWidth - 30;
        
        flowLayout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
        flowLayout.minimumInteritemSpacing = 10.f;
        flowLayout.itemSize = CGSizeMake(itemW, itemH);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[TTRechargeViewCell class] forCellWithReuseIdentifier:NSStringFromClass([TTRechargeViewCell class])];
    }
    return _collectionView;
}

- (UIView *)containerView
{
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor whiteColor];
    }
    return _containerView;
}

- (UIButton *)exchangeBtn {
    if (!_exchangeBtn) {
        _exchangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_exchangeBtn setTitle:[NSString stringWithFormat:@"%@金币",[XCKeyWordTool sharedInstance].xcExchangeMethod] forState:UIControlStateNormal];
        [_exchangeBtn setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateNormal];
        [_exchangeBtn.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
        [_exchangeBtn setBackgroundColor:[XCTheme getTTSimpleGrayColor]];
        _exchangeBtn.layer.masksToBounds = YES;
        _exchangeBtn.layer.cornerRadius = 20;
        _exchangeBtn.hidden = YES;
        [_exchangeBtn addTarget:self action:@selector(exchangeBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exchangeBtn;
}

- (UIButton *)rechargeBtn {
    if (!_rechargeBtn) {
        _rechargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rechargeBtn setTitle:@"立即充值" forState:UIControlStateNormal];
        [_rechargeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rechargeBtn.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
        [_rechargeBtn setBackgroundColor:[XCTheme getTTMainColor]];
        _rechargeBtn.layer.masksToBounds = YES;
        _rechargeBtn.layer.cornerRadius = 23;
        
        [_rechargeBtn setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateNormal];
        [_rechargeBtn.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
        [_rechargeBtn setBackgroundColor:UIColor.whiteColor];
        _rechargeBtn.layer.borderWidth = 2;
        _rechargeBtn.layer.borderColor = [XCTheme getTTMainTextColor].CGColor;
        
        [_rechargeBtn addTarget:self action:@selector(rechargeBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rechargeBtn;
}


@end
