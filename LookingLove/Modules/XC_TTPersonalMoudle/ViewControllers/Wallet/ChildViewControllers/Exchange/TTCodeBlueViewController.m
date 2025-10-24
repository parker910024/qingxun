////
////  TTExchangeViewController.m
////  TuTu
////
////  Created by lee on 2018/11/3.
////  Copyright © 2018 YiZhuan. All rights reserved.
////
//
//#import "TTCodeBlueViewController.h"
//
//#import "TTBindingPhoneViewController.h"
//#import "TTChangePWViewController.h"
//#import "TTSetPWWithPhoneViewController.h"
//#import "TTSetPWViewController.h"
//#import "TTBindingXCZViewController.h"
//#import "TTEnterPayPWViewController.h"
//#import "TTWalletEnumConst.h"
//
//#import <Masonry/Masonry.h>
//#import "XCTheme.h"
//#import "UIView+ZJFrame.h"
//#import "UIView+XCToast.h"
//#import "UIImage+Utils.h"
//
//// core
//#import "PurseCore.h"
//#import "PurseCoreClient.h"
//#import "VersionCore.h"
//#import "UserCore.h"
//#import "AuthCore.h"
//
//#import "UserInfo.h"
//#import <YYText/YYText.h>
//#import "XCKeyWordTool.h"
//
//@interface TTCodeBlueViewController ()<UITextFieldDelegate, TTEnterPayPWViewControllerDelegate>
//
//@property (nonatomic, strong) UIView *containerView;
//
//@property (nonatomic, strong) UIView *diamondView;
//@property (nonatomic, strong) UIButton *diamondBtn;
//@property (nonatomic, strong) UILabel *diamondNumLabel;
//
//@property (nonatomic, strong) UIView *goldCoinView;
//@property (nonatomic, strong) UIButton *goldCoinBtn;
//@property (nonatomic, strong) UILabel *goldNumLabel;
//
//@property (nonatomic, strong) UIView *inputTextView;
//@property (nonatomic, strong) UITextField *inputTextField;
//@property (nonatomic, strong) UILabel *inputExchangeLabel;
//
//@property (nonatomic, strong) UIView *centerView;
//@property (nonatomic, strong) UITextField *goldCoinTextField; // 金币
//@property (nonatomic, strong) UITextField *hammerTextField; // 赠送的锤子
//
//@property (nonatomic, strong) UILabel *descLabel;
//@property (nonatomic, strong) UIButton *confirmBtn;
//
//@property (assign, nonatomic) NSInteger exchangeNumber;
///// 用户信息
//@property (nonatomic, strong) UserInfo *userInfo;
//
//@end
//
//@implementation TTCodeBlueViewController
//
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    _userInfo = [GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.longLongValue];
//}
//
//- (void)dealloc {
//    RemoveCoreClientAll(self);
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    AddCoreClient(PurseCoreClient, self);
//    _balanceInfo = GetCore(PurseCore).balanceInfo;
//    
//    self.navigationItem.title = [NSString stringWithFormat:@"金币%@", [XCKeyWordTool sharedInstance].xcExchangeMethod];
//    [self initViews];
//    [self initConstraints];
//    [self setupData];
//}
//
//- (void)setupData {
//    NSString *exchangeRate = [GetCore(VersionCore) getExchangeRate];
//    if(exchangeRate.integerValue == 0){
//        exchangeRate = @"1";
//    }
//    _descLabel.attributedText = [self tipsLabelAttributedString];
//    _diamondNumLabel.text = _balanceInfo.diamondNum;
//    _goldNumLabel.text = _balanceInfo.goldNum;
//}
//
//#pragma mark -
//#pragma mark lifeCycle
//- (void)initViews {
//    [self.view addSubview:self.containerView];
//    [self.containerView addSubview:self.diamondView];
//    [self.containerView addSubview:self.goldCoinView];
//    [self.containerView addSubview:self.inputTextView];
//    [self.containerView addSubview:self.descLabel];
//    [self.containerView addSubview:self.confirmBtn];
//    [self.containerView addSubview:self.centerView];
//    
//    [self.diamondView addSubview:self.diamondBtn];
//    [self.diamondView addSubview:self.diamondNumLabel];
//    
//    [self.goldCoinView addSubview:self.goldCoinBtn];
//    [self.goldCoinView addSubview:self.goldNumLabel];
//
//    [self.inputTextView addSubview:self.inputTextField];
//    [self.inputTextView addSubview:self.inputExchangeLabel];
//    [self.centerView addSubview:self.goldCoinTextField];
//    [self.centerView addSubview:self.hammerTextField];
//}
//
//- (void)initConstraints {
//    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        if (@available(iOS 11, *)) {
//            make.edges.equalTo(self.view.mas_safeAreaLayoutGuide);
//        } else {
//            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kSafeTopBarHeight, 0, 0, 0));
//        }
//    }];
//    
//    [self.diamondView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.right.mas_equalTo(0);
//        make.height.mas_equalTo(44);
//    }];
//    
//    [self.diamondBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(0);
//        make.left.mas_equalTo(23);
//    }];
//    
//    [self.diamondNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(0).inset(15);
//        make.centerY.mas_equalTo(0);
//    }];
//    
//    [self.goldCoinView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(0);
//        make.top.mas_equalTo(self.diamondView.mas_bottom);
//        make.height.mas_equalTo(44);
//    }];
//    
//    [self.goldCoinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(23);
//        make.centerY.mas_equalTo(0);
//    }];
//    
//    [self.goldNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(-15);
//        make.centerY.mas_equalTo(0);
//    }];
//    
//    [self.inputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(0);
//        make.height.mas_equalTo(44);
//        make.top.mas_equalTo(self.goldCoinView.mas_bottom).offset(10);
//    }];
//    
//    [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(0).inset(15);
//        make.height.mas_equalTo(50);
//        make.centerY.mas_equalTo(0);
//    }];
//    
//    [self.inputExchangeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(-15);
//        make.centerY.mas_equalTo(0);
//    }];
//    
//    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(0);
//        make.top.mas_equalTo(self.inputTextView.mas_bottom);
//        make.height.mas_equalTo(100);
//    }];
//    
//    [self.goldCoinTextField mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(0).inset(15);
//        make.top.mas_equalTo(0);
//        make.height.mas_equalTo(50);
//    }];
//    
//    [self.hammerTextField mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(0).inset(15);
//        make.top.mas_equalTo(self.goldCoinTextField.mas_bottom);
//        make.height.mas_equalTo(50);
//    }];
//    
//    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(0).inset(15);
//        make.top.mas_equalTo(self.centerView.mas_bottom).offset(15);
//    }];
//    
//    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(0).inset(63);
//        make.height.mas_equalTo(40);
//        make.top.mas_equalTo(self.descLabel.mas_bottom).offset(48);
//        
//    }];
//}
//
//#pragma mark -
//#pragma mark UITextFieldDelegate
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
//    if (newString.integerValue > self.balanceInfo.diamondNum.integerValue) {
//        [self.confirmBtn setEnabled:NO];
//        [UIView showToastInKeyWindow:[NSString stringWithFormat:@"%@数量少于%@数量", [XCKeyWordTool sharedInstance].xcCF, [XCKeyWordTool sharedInstance].xcExchangeMethod] duration:2.0 position:YYToastPositionCenter];
//        return YES;
//    }
//    
//    if (newString.length > 2) {
//        if (newString.integerValue == 0) {
//            [self.confirmBtn setEnabled:NO];
//            return NO;
//        }
//    }
//    
//    if (newString.integerValue % 10 > 0) {
//        [self.confirmBtn setEnabled:NO];
//        return YES;
//    }
//    
//    if (newString.length > 1) {
//        if (newString.integerValue == 0) {
//            return NO;
//        }
//    }
//    
//    NSString *exchangeRate = [GetCore(VersionCore) getExchangeRate];
//    if (exchangeRate.integerValue == 0) {
//        exchangeRate = @"1";
//    }
//    NSString *str = [NSString stringWithFormat:@"%.2f",(long)newString.integerValue * exchangeRate.doubleValue];
////    self.bottomBalanceLabel.attributedText = [self configBalanceLabelAttString:str];
//    [self.confirmBtn setEnabled:YES];
////    self.inputExchangeLabel.text = [NSString stringWithFormat:@"%@金币", newString];
//    self.goldCoinTextField.text = [NSString stringWithFormat:@"%@金币", newString];
//    if (newString.integerValue >= 1000) {
//        NSInteger hammarCount = ceil((newString.integerValue / 1000) * 2);
//        self.hammerTextField.text = [NSString stringWithFormat:@"%ld锤子", (long)hammarCount];
//    } else {
//        self.hammerTextField.text = @"";
//    }
//    
//    self.exchangeNumber = newString.integerValue;
//    return YES;
//}
//
//#pragma mark -
//#pragma mark button click events
//- (void)confirmBtnClickAction:(UIButton *)btn {
//    // 确认兑换
//    NSInteger myCornNumber = self.balanceInfo.diamondNum.integerValue;
//    if (self.exchangeNumber <= myCornNumber) {
//        if (self.exchangeNumber == 0) {
//            //            [MBProgressHUD showError:@"请输入大于10的数量"];
//            [UIView showToastInKeyWindow:@"请输入大于10的数量" duration:2.0 position:YYToastPositionCenter];
//            return;
//        }
//        @weakify(self);
//        
//        [GetCore(UserCore) getUserInfo:[GetCore(AuthCore).getUid userIDValue] refresh:YES success:^(UserInfo *info) {
//            @strongify(self);
//            
//            if (!info.isBindPhone) {
//                [UIView showToastInKeyWindow:@"亲, 请先绑定手机号码！" duration:2 position:YYToastPositionCenter];
//                [self gotoBindPhone]; // 绑定手机
//                return;
//            }
//    
//            if (!info.isBindPaymentPwd) {
//                [self gotoSetPayPwd];  // 去设置支付密码
//            } else {
//                [self showPasswordVC]; // 显示输入支付密码
//            }
//            
//        } failure:nil];
//    } else {
//        [UIView showToastInKeyWindow:[NSString stringWithFormat:@"%@数量少于%@数量", [XCKeyWordTool sharedInstance].xcCF, [XCKeyWordTool sharedInstance].xcExchangeMethod] duration:2.0 position:YYToastPositionCenter];
//    }
//}
//
//#pragma mark -
//#pragma mark PurseCoreClient
//- (void)requestExchangeCornSuccess:(BalanceInfo *)balanceInfo {
//    //    [MBProgressHUD hideHUD];
//    [UIView showToastInKeyWindow:@"操作成功" duration:3 position:YYToastPositionCenter];
//    [self.confirmBtn setEnabled:NO];
//    self.exchangeNumber = 0;
//    self.balanceInfo = balanceInfo;
//    self.diamondNumLabel.text = [NSString stringWithFormat:@"%.2f",self.balanceInfo.diamondNum.floatValue];
//    self.goldNumLabel.text = [NSString stringWithFormat:@"%.2f", self.balanceInfo.goldNum.floatValue];
//    self.inputTextField.text = @"";
//    self.goldCoinTextField.text = @"";
//    self.hammerTextField.text = @"";
//}
//
//- (void)requestExchangeCornFail:(NSString *)message {
//    [UIView showToastInKeyWindow:message duration:2.0 position:YYToastPositionCenter];
//}
//
//#pragma mark -
//#pragma mark TTEnterPayPWViewController delegate
//- (void)inputPasswordEnd:(NSString *)password {
//    [UIView showToastInKeyWindow:@"请稍后..." duration:2.0 position:YYToastPositionCenter];
//    [self.inputTextField resignFirstResponder];
//    [GetCore(PurseCore) requestExchangeCorn:self.exchangeNumber paymentPwd:password];
//}
//
//- (void)gotoForgetPasswordVC {
//    // 跳转 忘记密码
////    TTChangePWViewController *vc = [[TTChangePWViewController alloc] init];
////    vc.isPayment = YES;
////    [self.navigationController pushViewController:vc animated:YES];
//    
//    TTSetPWWithPhoneViewController *pw = [[TTSetPWWithPhoneViewController alloc] init];
//    pw.isPayment = YES;
//    pw.isResetPay = YES;
//    [self.navigationController pushViewController:pw animated:YES];
//
//}
//
//#pragma mark -
//#pragma mark private methods
//// 去绑定手机
//- (void)gotoBindPhone {
//    TTBindingPhoneViewController *vc = [[TTBindingPhoneViewController alloc] init];
//    vc.bindingPhoneNumType = TTBindingPhoneNumTypeNormal;
//    [self.navigationController pushViewController:vc animated:YES];
//}
//// 设置密码
//- (void)showPasswordVC {
//    TTEnterPayPWViewController *vc = [[TTEnterPayPWViewController alloc] init];
//    vc.delegate = self;
//    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//    [self presentViewController:vc animated:NO completion:nil];
//}
//
//// 绑定xcz
//- (void)gotoBindXCZAccount {
//    TTBindingXCZViewController *vc = [[TTBindingXCZViewController alloc] init];
//    vc.userInfo = _userInfo;
//    [self.navigationController pushViewController:vc animated:YES];
//}
//
//// 设置支付密码
//- (void)gotoSetPayPwd {
//    TTSetPWViewController *vc = [[TTSetPWViewController alloc] init];
//    vc.isPayment = YES;
//    [self.navigationController pushViewController:vc animated:YES];
//}
//
//// tips attmu
//- (NSMutableAttributedString *)tipsLabelAttributedString
//{
//    NSString *exchangeRate = [GetCore(VersionCore) getExchangeRate];
//    if(exchangeRate.integerValue == 0){
//        exchangeRate = @"1";
//    }
//    NSString *string = [NSString stringWithFormat:@"注: %@可%@金币，%@比率：1%@=%@金币；%@数量必须为10的整数倍。每1000钻可得2把锤子。",
//                        [XCKeyWordTool sharedInstance].xcCF,
//                        [XCKeyWordTool sharedInstance].xcExchangeMethod,
//                        [XCKeyWordTool sharedInstance].xcExchangeMethod,
//                        [XCKeyWordTool sharedInstance].xcCF,
//                        exchangeRate,
//                        [XCKeyWordTool sharedInstance].xcCF];
//    NSRange range = [string rangeOfString:[NSString stringWithFormat:@"每1000钻可得2把锤子"]];
//    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:string];
//    attString.yy_font = [UIFont systemFontOfSize:14];
//    attString.yy_color = [XCTheme getTTDeepGrayTextColor];
//    [attString yy_setColor:UIColorFromRGB(0xFF3852) range:range];
//    return attString;
//}
//
//#pragma mark -
//#pragma mark getter & setter
//- (UIView *)containerView
//{
//    if (!_containerView) {
//        _containerView = [[UIView alloc] init];
//        _containerView.backgroundColor = [XCTheme getTTSimpleGrayColor];
//    }
//    return _containerView;
//}
//
//- (UIView *)diamondView
//{
//    if (!_diamondView) {
//        _diamondView = [[UIView alloc] init];
//        _diamondView.backgroundColor = UIColorFromRGB(0xFFF8F5);
//    }
//    return _diamondView;
//}
//
//- (UIView *)goldCoinView
//{
//    if (!_goldCoinView) {
//        _goldCoinView = [[UIView alloc] init];
//        _goldCoinView.backgroundColor = UIColorFromRGB(0xFFF1F3);
//    }
//    return _goldCoinView;
//}
//
//- (UIView *)inputTextView
//{
//    if (!_inputTextView) {
//        _inputTextView = [[UIView alloc] init];
//        _inputTextView.backgroundColor = [UIColor whiteColor];
//    }
//    return _inputTextView;
//}
//
//- (UILabel *)descLabel
//{
//    if (!_descLabel) {
//        _descLabel = [[UILabel alloc] init];
//        _descLabel.adjustsFontSizeToFitWidth = YES;
//        _descLabel.numberOfLines = 0;
//    }
//    return _descLabel;
//}
//
//- (UIButton *)confirmBtn {
//    if (!_confirmBtn) {
//        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        
//        [_confirmBtn setTitle:[NSString stringWithFormat:@"确认%@", [XCKeyWordTool sharedInstance].xcExchangeMethod] forState:UIControlStateNormal];
//        [_confirmBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
//        [_confirmBtn.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
//        UIImage *normalImg = [UIImage imageWithColor:[XCTheme getTTMainColor]];
//        UIImage *disabledImg = [UIImage imageWithColor:UIColorFromRGB(0xE5E5E5)];
//        [_confirmBtn setBackgroundImage:normalImg forState:UIControlStateNormal];
//        [_confirmBtn setBackgroundImage:disabledImg forState:UIControlStateDisabled];
//        _confirmBtn.layer.masksToBounds = YES;
//        _confirmBtn.layer.cornerRadius = 20;
//        _confirmBtn.enabled = NO;
//        [_confirmBtn addTarget:self action:@selector(confirmBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _confirmBtn;
//}
//
//- (UIButton *)diamondBtn {
//    if (!_diamondBtn) {
//        _diamondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_diamondBtn setTitle:[NSString stringWithFormat:@"%@余额",[XCKeyWordTool sharedInstance].xcCF] forState:UIControlStateNormal];
//        [_diamondBtn setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateNormal];
//        [_diamondBtn.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
//        _diamondBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
//        [_diamondBtn setImage:[UIImage imageNamed:@"diamond_icon"] forState:UIControlStateNormal];
//    }
//    return _diamondBtn;
//}
//
//- (UIButton *)goldCoinBtn {
//    if (!_goldCoinBtn) {
//        _goldCoinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_goldCoinBtn setTitle:@"金币余额" forState:UIControlStateNormal];
//        [_goldCoinBtn setTitleColor:UIColorFromRGB(0xFF3852) forState:UIControlStateNormal];
//        [_goldCoinBtn.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
//        _goldCoinBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
//        [_goldCoinBtn setImage:[UIImage imageNamed:@"goldCoin_icon_orange"] forState:UIControlStateNormal];
//        
//    }
//    return _goldCoinBtn;
//}
//
//- (UILabel *)diamondNumLabel
//{
//    if (!_diamondNumLabel) {
//        _diamondNumLabel = [[UILabel alloc] init];
//        _diamondNumLabel.text = @"0";
//        _diamondNumLabel.textColor = [XCTheme getTTMainColor];
//        _diamondNumLabel.font = [UIFont systemFontOfSize:15.f];
//        _diamondNumLabel.adjustsFontSizeToFitWidth = YES;
//        _diamondNumLabel.textAlignment = NSTextAlignmentRight;
//    }
//    return _diamondNumLabel;
//}
//
//- (UILabel *)goldNumLabel
//{
//    if (!_goldNumLabel) {
//        _goldNumLabel = [[UILabel alloc] init];
//        _goldNumLabel.text = @"0";
//        _goldNumLabel.textColor = UIColorFromRGB(0xFF3852);
//        _goldNumLabel.font = [UIFont systemFontOfSize:15.f];
//        _goldNumLabel.adjustsFontSizeToFitWidth = YES;
//        _goldNumLabel.textAlignment = NSTextAlignmentRight;
//    }
//    return _goldNumLabel;
//}
//
//- (UILabel *)inputExchangeLabel
//{
//    if (!_inputExchangeLabel) {
//        _inputExchangeLabel = [[UILabel alloc] init];
//        _inputExchangeLabel.textColor = [XCTheme getTTDeepGrayTextColor];
//        _inputExchangeLabel.font = [UIFont systemFontOfSize:13.f];
//        _inputExchangeLabel.adjustsFontSizeToFitWidth = YES;
//        _inputExchangeLabel.textAlignment = NSTextAlignmentRight;
//    }
//    return _inputExchangeLabel;
//}
//
//- (UITextField *)inputTextField {
//    if (!_inputTextField) {
//        _inputTextField = [[UITextField alloc] init];
//        _inputTextField.textColor = [XCTheme getTTMainTextColor];
//        _inputTextField.font = [UIFont systemFontOfSize:13.f];
//        _inputTextField.placeholder = [NSString stringWithFormat:@"输入%@的%@数量", [XCKeyWordTool sharedInstance].xcExchangeMethod, [XCKeyWordTool sharedInstance].xcCF];
//        _inputTextField.delegate = self;
//        _inputTextField.tintColor = [XCTheme getTTMainColor];
//        _inputTextField.keyboardType = UIKeyboardTypeNumberPad;
//    }
//    return _inputTextField;
//}
//
//- (UITextField *)goldCoinTextField {
//    if (!_goldCoinTextField) {
//        _goldCoinTextField = [[UITextField alloc] init];
//        _goldCoinTextField.textColor = [XCTheme getTTMainTextColor];
//        _goldCoinTextField.font = [UIFont systemFontOfSize:13.f];
//        _goldCoinTextField.placeholder = @"0金币";
//        _goldCoinTextField.borderStyle = UITextBorderStyleNone;
//        _goldCoinTextField.userInteractionEnabled = NO;
//        _goldCoinTextField.backgroundColor = [UIColor whiteColor];
//    }
//    return _goldCoinTextField;
//}
//
//- (UITextField *)hammerTextField {
//    if (!_hammerTextField) {
//        _hammerTextField = [[UITextField alloc] init];
//        _hammerTextField.textColor = [XCTheme getTTMainTextColor];
//        _hammerTextField.font = [UIFont systemFontOfSize:13.f];
//        _hammerTextField.placeholder = @"0锤子";
//        _hammerTextField.borderStyle = UITextBorderStyleNone;
//        _hammerTextField.backgroundColor = [UIColor whiteColor];
//        _hammerTextField.userInteractionEnabled = NO;
//    }
//    return _hammerTextField;
//}
//
//- (UIView *)centerView
//{
//    if (!_centerView) {
//        _centerView = [[UIView alloc] init];
//        _centerView.backgroundColor = [UIColor whiteColor];
//    }
//    return _centerView;
//}
//@end
