//
//  TTWithdrawViewController.m
//  TuTu
//
//  Created by lee on 2018/11/3.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTCodeRedViewController.h"
// view

#import "TTOutputViewCell.h"
#import "TTOutputInfoView.h"
#import "TTWalletEnumConst.h"
// vc
#import "TTBindingXCZViewController.h"
#import "TTBindingPhoneViewController.h"
#import "TTBillListViewController.h"
#import "TTSetPWWithPhoneViewController.h"
#import "TTEnterPayPWViewController.h"
#import "TTPayPwdViewController.h"

// pods
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"
#import "XCHUDTool.h"
#import "UIImage+Utils.h"
#import <ReactiveObjC/ReactiveObjC.h>

// core
#import "PurseCore.h"
#import "PurseCoreClient.h"
#import "PurseBillCore.h"
#import "PurseBillCoreClient.h"
#import "UserCore.h"
#import "UserCoreClient.h"
#import "AuthCore.h"
#import "AuthCoreClient.h"
#import "TTWKWebViewViewController.h"
#import "XCKeyWordTool.h"
#import "XCHtmlUrl.h"

// model
#import "ZXCInfo.h"
#import "WithDrawalInfo.h"
#import "RedWithdrawalsListInfo.h"
#import "RedPageDetailInfo.h"



@interface TTCodeRedViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
TTEnterPayPWViewControllerDelegate,
PurseBillCoreClient,
PurseCoreClient
>

@property (nonatomic, strong) TTOutputInfoView *infoView;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, strong) UIButton *helpBtn;
@property (nonatomic, strong) UIButton *confirmBtn;
/// 可提现list
@property (strong, nonatomic) NSArray<WithDrawalInfo *> *outputList;
//
@property (strong, nonatomic) NSArray<RedWithdrawalsListInfo *> *redList;

/// 提现账户信息
@property (strong, nonatomic) ZXCInfo *zxcInfo;
@property (nonatomic, assign) BOOL isBindingPhoneNum;

@property (nonatomic, assign) NSInteger index;
@end

@implementation TTCodeRedViewController

- (void)dealloc {
    RemoveCoreClientAll(self);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
     AddCoreClient(PurseCoreClient, self);
     AddCoreClient(PurseBillCoreClient, self);
    
    [self baseUI];
    [self initViews];
    [self initConstraints];
    [self infoViewCallBackHandler];
}

#pragma mark -
#pragma mark loadData
- (void)loadData {
    if (self.outputType == TTOutputViewTypexcCF) {
        [GetCore(PurseCore) requestWithdrawalsList];
    } else {
        [GetCore(PurseBillCore) getRedPageInfo];
        [GetCore(PurseCore) requestRedWithdrawalsList];
    }
    [GetCore(PurseCore) requestZXCInfo];
}

#pragma mark -
#pragma mark lifeCycle
- (void)baseUI {
    self.navigationItem.title = [NSString stringWithFormat:@"%@",[XCKeyWordTool sharedInstance].xcGetCF];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"%@记录", [XCKeyWordTool sharedInstance].xcGetCF] style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClickAction:)];
}
- (void)initViews {
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.infoView];
    [self.scrollView addSubview:self.collectionView];
    [self.scrollView addSubview:self.tipsLabel];
    [self.scrollView addSubview:self.helpBtn];
    [self.scrollView addSubview:self.confirmBtn];
}

- (void)initConstraints {
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11, *)) {
            make.edges.centerX.width.mas_equalTo(self.view.mas_safeAreaLayoutGuide);
        } else {
            make.edges.mas_equalTo(0).insets(UIEdgeInsetsMake(kSafeTopBarHeight, 0, 0, 0));
        }
    }];
    
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(260);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.infoView.mas_bottom);
        make.height.mas_equalTo(165);
    }];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0).inset(15);
        make.top.mas_equalTo(self.collectionView.mas_bottom).offset(12);
    }];
    
    [self.helpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.tipsLabel.mas_bottom).offset(40);
        make.height.mas_equalTo(16);
    }];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.left.right.mas_equalTo(0).inset(53);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(self.helpBtn.mas_bottom).offset(18);
        make.bottom.mas_equalTo(-30);
    }];
    
}

#pragma mark -
#pragma mark collectionView delegate & dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.outputType == TTOutputViewTypexcCF) {
        return self.outputList.count;
    }
    return self.redList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TTOutputViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TTOutputViewCell class]) forIndexPath:indexPath];
    if (self.outputType == TTOutputViewTypexcCF) {
        if (self.outputList.count > indexPath.item) {
            cell.codeRedInfo = self.outputList[indexPath.item];
        }
    } else {
        if (self.redList.count > indexPath.item) {
            cell.redDrawInfo = self.redList[indexPath.item];
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TTOutputViewCell *cell = (TTOutputViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell setSelected:YES];
    _index = indexPath.item;
    
    if (self.outputType == TTOutputViewTypexcRedColor) {
        if (self.redList.count > indexPath.item) {
            RedWithdrawalsListInfo *redInfo = self.redList[indexPath.item];
            if (_zxcInfo.diamondNum.integerValue < redInfo.packetNum) {
                [XCHUDTool showErrorWithMessage:@"您的余额不足" inView:self.view];
                if (self.confirmBtn.enabled) { // 提现按钮关闭
                    self.confirmBtn.enabled = NO;
                }
                return;
            }
        }
    } else {
        WithDrawalInfo *info = self.outputList[indexPath.item];
        if (_zxcInfo.diamondNum.integerValue < info.diamondNum.integerValue) {
            [XCHUDTool showErrorWithMessage:@"您的余额不足" inView:self.view];
            if (self.confirmBtn.enabled) { // 提现按钮关闭
                self.confirmBtn.enabled = NO;
            }
            return;
        }
    }
    
    if (_zxcInfo.diamondNum.integerValue != 0) {
        _confirmBtn.enabled = YES;
    }
    
}

#pragma mark -
#pragma mark button click events
- (void)helpBtnClickActon:(UIButton *)btn {
    // 跳去提现规则 html
    TTWKWebViewViewController *web = [[TTWKWebViewViewController alloc] init];
//    web.urlString = HtmlUrlKey(kCodeRedQuestionURL);
    [self.navigationController pushViewController:web animated:YES];
}

- (void)confirmBtnClickAction:(UIButton *)btn {
    // 进行提现操作
    @weakify(self);
    [[GetCore(UserCore) getUserInfoByUid:[GetCore(AuthCore) getUid].longLongValue refresh:YES] subscribeNext:^(id x) {
        @strongify(self);
        if (![x isKindOfClass:[UserInfo class]]) {
            return;
        }
        UserInfo *meInfo = (UserInfo *)x;
        
        if (!meInfo.isBindPhone) {
            [self gotoBinbingPhone:meInfo]; // 绑定手机
            return;
        }
        if (self.zxcInfo.zxcAccount.length <= 0) { // 暂时用这个来判断
            [self gotoBindingXCZAccount:meInfo]; // 绑定支付宝
            return;
        }
        
        if (!meInfo.isBindPaymentPwd) {
            [self gotoSetPayPwd:meInfo]; // 设置支付密码
            return;
        }
        [self showPayPwdVc]; // 输入支付密码
        
    }];
    
}

- (void)rightItemClickAction:(UIBarButtonItem *)item {
    // 跳转提现历史
    TTBillListViewController *vc = [[TTBillListViewController alloc] init];
    
    if (self.outputType == TTOutputViewTypexcRedColor) { // 如果当前是红包提现
        vc.listViewType = TTBillListViewTypeRedColor; // 红包提现
    } else {
        vc.listViewType = TTBillListViewTypeCodeRed; // 钻石提现
    }
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
#pragma mark PurseCoreClient

// 钻石提现
- (void)requestWithdrawalsSuccess:(NSString *)leftDiamond {
    [XCHUDTool hideHUDInView:self.view];
    
    // 因为APP原生移除了提现, 所有先暂时注释
//    @weakify(self);
//    [self.view showLoadingToastDuration:1.6 completion:^{
//        @strongify(self);
//        self.zxcInfo.diamondNum = leftDiamond;
//        self.infoView.zxcInfo = self.zxcInfo;
//
//        [self.collectionView reloadData];
//        self.confirmBtn.enabled = NO; // 关闭较好
//        [UIView showToastInKeyWindow:@"操作申请成功" duration:2.0 position:YYToastPositionCenter];
//    }];
    
}

- (void)requestWithdrawalsFail:(NSString *)message {//xcGetCF申请失败
    [XCHUDTool showErrorWithMessage:message inView:self.view];
}

// 红包提现 ？
- (void)requestRedWithdrawalsSuccess:(NSString *)leftDiamond {
    _zxcInfo.diamondNum = leftDiamond;
    self.infoView.zxcInfo = _zxcInfo;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kTuTuCodeRedRefreshNumNoti" object:nil];
    [self.collectionView reloadData];
    self.confirmBtn.enabled = NO; // 关闭较好
    [XCHUDTool showSuccessWithMessage:@"操作申请成功" inView:self.view];
}

- (void)requestRedWithdrawalsFail:(NSString *)message {
    [XCHUDTool showErrorWithMessage:message inView:self.view];
}

// 钻石可提现list
- (void)requestWithdrawalsList:(NSArray<WithDrawalInfo *> *)drawalsList {
    self.outputList = drawalsList;
    [self.collectionView reloadData];
    self.confirmBtn.enabled = NO;
}

- (void)requestWithdrawalsListFail:(NSString *)message {
    [XCHUDTool showErrorWithMessage:message inView:self.view];
}

// 红包可提现 list
- (void)requestRedWithdrawalsListSuccess:(NSArray *)list {
    self.redList = list;
    [self.collectionView reloadData];
    self.confirmBtn.enabled = NO;
}

- (void)requestRedWithdrawalsListFailth:(NSString *)message {
    [XCHUDTool showErrorWithMessage:message inView:self.view];
}

// 提现账户信息
- (void)requestZXCInfo:(ZXCInfo *)zxcInfo {
   
    if (![zxcInfo isKindOfClass:[ZXCInfo class]]) {
        NSAssert(NO, @"zxcInfo not class");
        return;
    }
    
    if (zxcInfo) {
        if (self.outputType == TTOutputViewTypexcRedColor) {
        zxcInfo.diamondNum = GetCore(PurseBillCore).redPageDetailInfo.packetNum;
        }
        
        _infoView.zxcInfo = zxcInfo;
        _zxcInfo = zxcInfo;
        [self.collectionView reloadData];
    }
    
    if (zxcInfo.zxcAccount.length > 0) {
        
    }
}

- (void)requestZXCInfoFail:(NSString *)message {
    [XCHUDTool showErrorWithMessage:message inView:self.view];
}

- (void)getRedPageInfoSuccess {
    RedPageDetailInfo *redPageInfo = GetCore(PurseBillCore).redPageDetailInfo;
    _zxcInfo.diamondNum = redPageInfo.packetNum;
    _infoView.zxcInfo = _zxcInfo;
}
- (void)RedPageDetailInfoFailth:(NSString *)message {
}

#pragma mark -
#pragma mark passwordVC delegate
- (void)inputPasswordEnd:(NSString *)password {
    
    // 输入后的密码
    if (self.outputType == TTOutputViewTypexcRedColor) {
        RedWithdrawalsListInfo *info = self.redList[_index];
        [GetCore(PurseCore) requestRedWithdrawalsWithID:[NSString stringWithFormat:@"%ld",(long)info.packetId] paymentPwd:password];
    } else {
        WithDrawalInfo *info = self.outputList[_index];
        [GetCore(PurseCore) requestWithdrawalsWithID:info.cashProdId paymentPwd:password];
    }
    [XCHUDTool showGIFLoadingInView:self.view];
}

- (void)gotoForgetPasswordVC {
    // 跳转忘记密码
    TTSetPWWithPhoneViewController *pw = [[TTSetPWWithPhoneViewController alloc] init];
    pw.isPayment = YES;
    pw.isResetPay = YES;
    [self.navigationController pushViewController:pw animated:YES];
}

#pragma mark -
#pragma mark methods
- (void)infoViewCallBackHandler {
    
    @weakify(self);
    _infoView.infoViewClickHandler = ^{
        @strongify(self);
        UserInfo *meInfo = [GetCore(UserCore) getUserInfoInDB:[GetCore(AuthCore) getUid].longLongValue];
        // 如果未绑定手机, 跳转手机绑定
        if (!meInfo.isBindPhone) {
            [self gotoBinbingPhone:meInfo];
            return ;
        }
        [self gotoBindingXCZAccount:meInfo];
    };
}
/** 去绑定手机 */
- (void)gotoBinbingPhone:(UserInfo *)meInfo {
    TTBindingPhoneViewController *vc = [[TTBindingPhoneViewController alloc] init];
    vc.bindingPhoneNumType = TTBindingPhoneNumTypeNormal;
    vc.userInfo = meInfo;
    [self.navigationController pushViewController:vc animated:YES];
}
/** 去设置支付密码 */
- (void)gotoSetPayPwd:(UserInfo *)meInfo {
    TTPayPwdViewController *vc = [[TTPayPwdViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
/** 显示支付密码控制器 */
- (void)showPayPwdVc {
    TTEnterPayPWViewController *vc = [[TTEnterPayPWViewController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.delegate = self;
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}
/** 去绑定提现账号 */
- (void)gotoBindingXCZAccount:(UserInfo *)meInfo {
    // 未填写提现账号资料
    TTBindingXCZViewController *vc = [[TTBindingXCZViewController alloc] init];
    vc.userInfo = meInfo;
//    if (!meInfo.isBindXCZAccount) { // 未绑定  isBindXCZAccount 此字段暂未生效
    if (_zxcInfo.zxcAccount.length == 0) { // 用是否有提现账号来判断
        vc.bindXCZAccountType = TTBindXCZAccountTypeNormal;
    } else {
        vc.bindXCZAccountType = TTBindXCZAccountTypeEdit; // 绑定
        vc.zxcInfo = self.zxcInfo;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
#pragma mark getter & setter

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (TTOutputInfoView *)infoView
{
    if (!_infoView) {
        _infoView = [[TTOutputInfoView alloc] init];
        _infoView.outputType = _outputType;
        _infoView.backgroundColor = [UIColor whiteColor];
    }
    return _infoView;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        
        CGFloat inset = 15.f;
        CGFloat itemSpace = 10.f;
        CGFloat lineSpace = 15.f;
        CGFloat itemH = 60.f;
        CGFloat itemW = (KScreenWidth - inset * 2 - itemSpace * 2) / 3;
        
        flowLayout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
        flowLayout.minimumInteritemSpacing = itemSpace;
        flowLayout.minimumLineSpacing = lineSpace;
        flowLayout.itemSize = CGSizeMake(itemW, itemH);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[TTOutputViewCell class] forCellWithReuseIdentifier:NSStringFromClass([TTOutputViewCell class])];
    }
    return _collectionView;
}

- (UILabel *)tipsLabel
{
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.text = [NSString stringWithFormat:@"注: 大额%@，请关注官方公众号 %@语音联系客服进行提现操作。谢谢！", [XCKeyWordTool sharedInstance].myAppName,[XCKeyWordTool sharedInstance].xcGetCF];
        _tipsLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        _tipsLabel.font = [UIFont systemFontOfSize:12.f];
        _tipsLabel.adjustsFontSizeToFitWidth = YES;
        _tipsLabel.numberOfLines = 0;
        _tipsLabel.hidden = YES;
    }
    return _tipsLabel;
}

- (UIButton *)helpBtn {
    if (!_helpBtn) {
        _helpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_helpBtn setTitle:[NSString stringWithFormat:@"去了解%@规则>>", [XCKeyWordTool sharedInstance].xcGetCF] forState:UIControlStateNormal];
        _helpBtn.hidden = YES;
        [_helpBtn setTitleColor:[XCTheme getTTDeepGrayTextColor] forState:UIControlStateNormal];
        [_helpBtn.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
        [_helpBtn addTarget:self action:@selector(helpBtnClickActon:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _helpBtn;
}

- (UIButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmBtn setTitle:[NSString stringWithFormat:@"确认%@",[XCKeyWordTool sharedInstance].xcGetCF] forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateDisabled];
        [_confirmBtn.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
        [_confirmBtn setBackgroundImage:[UIImage imageWithColor:[XCTheme getTTMainColor]] forState:UIControlStateNormal];
        [_confirmBtn setBackgroundImage:[UIImage imageWithColor:[XCTheme getTTSimpleGrayColor]] forState:UIControlStateDisabled];
        _confirmBtn.enabled = NO;
        _confirmBtn.layer.masksToBounds = YES;
        _confirmBtn.layer.cornerRadius = 20;
        [_confirmBtn addTarget:self action:@selector(confirmBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

@end
