//
//  TTSettingViewController.m
//  TuTu
//
//  Created by Macx on 2018/11/3.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTSettingViewController.h"

#import "TTSettingCell.h"

#import "TTFeedbackViewController.h"
#import "TTAboutTuTuViewController.h"
#import "TTSetPWViewController.h"
#import "TTChangePWViewController.h"
#import "TTBindingXCZViewController.h"
#import "TTBindingPhoneViewController.h"
#import "TTBindPhoneResultViewController.h"
#import "TTBlackListViewController.h"
#import "TTExperimentViewController.h"
#import "TTWKWebViewViewController.h"
#import "TTPayPwdViewController.h"

#import "LLPrivacySettingController.h"
#import "TTNotificationSettingsViewController.h"

#import "UserInfo.h"
#import "PurseCoreClient.h"
#import "AuthCore.h"
#import "PurseCore.h"
#import "UserCore.h"
#import "UserCoreClient.h"
#import "VersionCore.h"

#import "XCHUDTool.h"
#import "TTPopup.h"
#import "XCTheme.h"
#import "XCHtmlUrl.h"
#import "XCKeyWordTool.h"
#import "TTStatisticsService.h"

#import <CoreLocation/CLLocationManager.h>
#import <SDWebImage/SDWebImageManager.h>
#import <Masonry/Masonry.h>

@interface TTSettingViewController ()

@property (nonatomic, strong) NSMutableArray<NSMutableArray<NSString *> *>  *funTitleArray;
@property (nonatomic, strong) NSMutableArray<NSMutableArray<NSString *> *>  *dataTitleArray;

@property (strong, nonatomic) UIView *footerView;

@property (strong, nonatomic) UIButton *logoutBtn;//退出登录


@end

@implementation TTSettingViewController

- (void)dealloc {
    RemoveCoreClientAll(self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    [self addClient];
    
    [self.tableView registerClass:[TTSettingCell class] forCellReuseIdentifier:NSStringFromClass(TTSettingCell.class)];
    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    self.tableView.tableFooterView = self.footerView;
    [self.footerView addSubview:self.logoutBtn];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.mas_topLayoutGuide);
    }];
    
    [self.logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.footerView).offset(28);
        make.right.mas_equalTo(self.footerView).offset(-28);
        make.top.mas_equalTo(self.footerView).offset(40);
        make.height.mas_equalTo(50);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    NSMutableArray *accuoutTArray =  [self.dataTitleArray objectAtIndex:0];
    NSMutableArray *accuoutDArray = [self.funTitleArray objectAtIndex:0];

    @weakify(self);
    [GetCore(UserCore) getUserInfo:[GetCore(AuthCore).getUid userIDValue] refresh:YES success:^(UserInfo *info) {
        @strongify(self);
        self.userInfo = info;
        
        NSString *thridAccount;
        NSString *titile = @"已绑定";
        switch (info.bindType) {
            case BindType_QQ:
            {
                thridAccount = @"QQ";
                [accuoutTArray replaceObjectAtIndex:0 withObject:thridAccount];
                [accuoutDArray replaceObjectAtIndex:0 withObject:titile];
            }
                break;
            case BindType_WC:
            {
                thridAccount = @"微信";
                [accuoutTArray replaceObjectAtIndex:0 withObject:thridAccount];
                [accuoutDArray replaceObjectAtIndex:0 withObject:titile];
            }
                break;
            case BindType_AppleID:
            {
                thridAccount = @"苹果账号";
                [accuoutTArray replaceObjectAtIndex:0 withObject:thridAccount];
                [accuoutDArray replaceObjectAtIndex:0 withObject:titile];
            }
                break;
                
            default:
                break;
        }
        
        NSString *phone;
        if (self.userInfo.isBindPhone) {
            phone = self.userInfo.phone;
            [accuoutTArray replaceObjectAtIndex:1 withObject:phone];
        }
        
        NSMutableArray *passwArray = [self.dataTitleArray safeObjectAtIndex:1];
        if (self.userInfo.isBindPasswd) {
            [passwArray replaceObjectAtIndex:0 withObject:@"修改"];
        }
        if (self.userInfo.isBindPaymentPwd) {
            [passwArray replaceObjectAtIndex:1 withObject:@"修改"];
        }
        
        //如果拒绝定位权限，将定位展示关闭
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
            if (self.userInfo.userExpand.showLocation) {
                [GetCore(UserCore) updateUserInfoLocationSwitch:NO];
            }
        }
        
        [self.tableView reloadData];
    } failure:nil];
}

- (void)addClient {
    AddCoreClient(PurseCoreClient, self);
    AddCoreClient(UserCoreClient, self);
}

#pragma mark - TableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        if (!self.userInfo.bindType || self.userInfo.bindType == BindType_Phone) {
            return CGFLOAT_MIN;
        }
    }
    
    return 45;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.funTitleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.funTitleArray[section].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 10)];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TTSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(TTSettingCell.class) forIndexPath:indexPath];
    
    // 第一个用来显示绑定的第三方平台信息 不需要箭头
    if (indexPath.section == 0 && indexPath.row == 0) {
        [cell hiddenArrow:YES];
    } else {
        [cell hiddenArrow:NO];
    }

    
    NSString *title = [[self.funTitleArray safeObjectAtIndex:indexPath.section] safeObjectAtIndex:indexPath.row];
    NSString *data = [[self.dataTitleArray safeObjectAtIndex:indexPath.section] safeObjectAtIndex:indexPath.row];
    
    cell.titleLabel.text = title;
    cell.selectSwitch.hidden = YES;
    cell.dataLabel.hidden = NO;
    if (data.length == 3) {
        cell.dataLabel.textColor = [XCTheme getTTMainColor];
    } else {
        cell.dataLabel.textColor = [XCTheme getTTDeepGrayTextColor];
    }
    
    cell.dataLabel.text = data;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            // 绑定手机
            if (self.userInfo.isBindPhone) { // 如果已经绑定
                TTBindPhoneResultViewController *vc = [[TTBindPhoneResultViewController alloc] init];
                vc.userInfo = _userInfo;
                [self.navigationController pushViewController:vc animated:YES];
            }else {
                TTBindingPhoneViewController *vc = [[TTBindingPhoneViewController alloc] init];
                vc.bindingPhoneNumType =  TTBindingPhoneNumTypeNormal;
                vc.userInfo = _userInfo;
                [self.navigationController pushViewController:vc animated:YES];
            }

        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            
            if (!self.userInfo.isBindPhone) {
                [XCHUDTool showErrorWithMessage:@"请先绑定手机号码哦～" inView:self.view];
                return;
            }
            //登录密码
            if(self.userInfo.isBindPasswd){
                TTChangePWViewController *vc = [[TTChangePWViewController alloc] init];
                vc.isPayment = NO;
                [self.navigationController pushViewController:vc animated:YES];
            }else {
                TTSetPWViewController *vc = [[TTSetPWViewController alloc] init];
                vc.isPayment = NO;
                vc.info = self.userInfo;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }else if (indexPath.row == 1) {
            if (!self.userInfo.isBindPhone) {
                [XCHUDTool showErrorWithMessage:@"请先绑定手机号码哦～" inView:self.view];
                return;
            }
            //支付密码
            if (self.userInfo.isBindPaymentPwd) {
                TTChangePWViewController *vc = [[TTChangePWViewController alloc] init];
                vc.isPayment = YES;
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                TTPayPwdViewController *vc = [[TTPayPwdViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        } else if (indexPath.row == 2) {
            // 隐私设置
            LLPrivacySettingController *vc = [[LLPrivacySettingController alloc] init];
            vc.currentUserInfo = self.userInfo;
            [self.navigationController pushViewController:vc animated:YES];
            
            [TTStatisticsService trackEvent:@"setting_secret" eventDescribe:@"隐私设置"];
            
        } else if (indexPath.row == 3) {
           // 消息提醒设置
            TTNotificationSettingsViewController *vc = [[TTNotificationSettingsViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            [TTStatisticsService trackEvent:@"setting_notice" eventDescribe:@"通知提醒设置"];

        } else if (indexPath.row == 4) {
            //黑名单管理
            TTBlackListViewController *blackVC = [[TTBlackListViewController alloc] init];
            [self.navigationController pushViewController:blackVC animated:YES];
        }
    }else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            //帮助
            [self gotoWebViewUrl:HtmlUrlKey(kFAQURL)];
           
        }else  if(indexPath.row == 1){
            //反馈
           TTFeedbackViewController *vc = [[TTFeedbackViewController alloc] init];
            vc.souce = TTFeedbackSouceSetting;
           [self.navigationController pushViewController:vc animated:YES];
        }else  if(indexPath.row == 2){
           //清除缓存
            [self clearCache];
        }else  if(indexPath.row == 3){
              // 关于兔兔
          TTAboutTuTuViewController *vc = [[TTAboutTuTuViewController alloc] init];
          [self.navigationController pushViewController:vc animated:YES];
        } else  if(indexPath.row == 4){
           //注销
            [self gotoWebViewUrl:HtmlUrlKey(kLogOutURL)];
      }
        
    }else if (indexPath.section == 3) {
       //实验室
        TTExperimentViewController *vc = [[TTExperimentViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)gotoWebViewUrl:(NSString *)url {
    TTWKWebViewViewController *webView = [[TTWKWebViewViewController alloc] init];
    webView.uid = GetCore(AuthCore).getUid.longLongValue;
    webView.urlString = url;
    [self.navigationController pushViewController:webView animated:YES];
}

#pragma mark - UserCoreClient
// 更新 位置开关
- (void)updateUserInfoLocationSwitchSuccess:(BOOL)showLocation {
    self.userInfo.userExpand.showLocation = showLocation;
    [self.tableView reloadData];
}

- (void)updateUserInfoLocationSwitchFailth:(BOOL)showLocation errorMessage:(NSString *)message {
    
    self.userInfo.userExpand.showLocation = showLocation;
    [XCHUDTool showErrorWithMessage:message inView:self.view];
    [self.tableView reloadData];
}

/// 更新年龄开关回调
/// @param success 是否更新成功
/// @param code 错误码
/// @param msg 错误信息
- (void)responseUserInfoAgeSwitchSuccess:(BOOL)success code:(NSNumber *)code msg:(NSString *)msg {
    
    if (success) {
        self.userInfo.userExpand.showAge = !self.userInfo.userExpand.showAge;
        
        NSString *status = self.userInfo.userExpand.showAge ? @"开" : @"关";
        NSString *des = [NSString stringWithFormat:@"年龄展示:%@", status];
        [TTStatisticsService trackEvent:@"setting_show_age" eventDescribe:des];
        return;
    }
    
    [XCHUDTool showErrorWithMessage:msg inView:self.view];
    [self.tableView reloadData];
}

/// 更新匹配聊天开关回调
/// @param success 是否更新成功
/// @param code 错误码
/// @param msg 错误信息
- (void)responseUserInfoMatchChatSwitchSuccess:(BOOL)success code:(NSNumber *)code msg:(NSString *)msg {
    
    if (success) {
        self.userInfo.userExpand.matchChat = !self.userInfo.userExpand.matchChat;
        
        NSString *status = self.userInfo.userExpand.showAge ? @"开" : @"关";
        NSString *des = [NSString stringWithFormat:@"匹配聊天:%@", status];
        [TTStatisticsService trackEvent:@"setting_chat_matching" eventDescribe:des];
        return;
    }
    
    [XCHUDTool showErrorWithMessage:msg inView:self.view];
    [self.tableView reloadData];
}

#pragma mark - Event

- (void)onClickLogoutAction {
    [self.navigationController popToRootViewControllerAnimated:YES];
    [GetCore(AuthCore) logout];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"deleteSuperAdmin"];
}


- (void)clearCache {
    TTAlertConfig *config = [[TTAlertConfig alloc] init];
    config.title = @"清除缓存";
    config.message = @"要清除缓存吗？";
    
    [TTPopup alertWithConfig:config confirmHandler:^{
        NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        @weakify(self);
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            @strongify(self);
            [XCHUDTool showSuccessWithMessage:@"清除缓存完成！" inView:self.view];
        }];
        [[SDWebImageManager sharedManager].imageCache clearMemory];
        [[SDWebImageManager sharedManager].imageCache clearDiskOnCompletion:^{
            
        }];
        [[SDWebImageManager sharedManager].imageCache deleteOldFilesWithCompletionBlock:^{
            
        }];
        
        [self cleanSearchRecord];
    } cancelHandler:^{
    }];
}

/// 清空搜索记录
- (void)cleanSearchRecord {
    NSString *key = [NSString stringWithFormat:@"%@_%@", XCConstSearchRecordStoreKey, [GetCore(AuthCore) getUid]];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Getter && Setter

- (NSMutableArray *)funTitleArray {
    if (!_funTitleArray) {
        _funTitleArray = @[
  @[@"QQ", @"手机号码"].mutableCopy,
  @[@"登录密码", [NSString stringWithFormat:@"%@密码", [XCKeyWordTool sharedInstance].xcz], @"隐私设置", @"通知提醒设置", @"黑名单管理",],
  @[@"帮助", @"意见反馈", @"清除缓存", [NSString stringWithFormat:@"关于%@", [XCKeyWordTool sharedInstance].myAppName],@"注销账号"]].mutableCopy;
        
#ifdef DEBUG
        [_funTitleArray addObject:@[@"切换环境"].mutableCopy];
#endif
    }
    return _funTitleArray;
}

- (NSMutableArray *)dataTitleArray {
    if (!_dataTitleArray) {
        _dataTitleArray = @[@[@"未绑定",@"未绑定"].mutableCopy,@[@"设置",@"设置"].mutableCopy].mutableCopy;
    }
    return _dataTitleArray;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 168)];
    }
    return _footerView;
}

- (UIButton *)logoutBtn {
    if (!_logoutBtn) {
        _logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_logoutBtn addTarget:self action:@selector(onClickLogoutAction) forControlEvents:UIControlEventTouchUpInside];
        _logoutBtn.backgroundColor = [UIColor whiteColor];
        _logoutBtn.layer.masksToBounds = YES;
        _logoutBtn.layer.cornerRadius = 50/2;
        _logoutBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_logoutBtn setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateNormal];
        [_logoutBtn setTitle:@"退出当前账号" forState:UIControlStateNormal];
    }
    return _logoutBtn;
}
@end
