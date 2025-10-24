//
//  LLPrivacySettingController.m
//  XC_TTPersonalMoudle
//
//  Created by Lee on 2019/12/23.
//  Copyright © 2019 WUJIE INTERACTIVE. All rights reserved.
//

#import "LLPrivacySettingController.h"
#import "TTSettingCell.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"
#import "UIView+XCToast.h"
#import "UserInfo.h"
#import "UserCore.h"
#import "TTPopup.h"
#import "XCHUDTool.h"
#import "TTStatisticsService.h"

static NSString *const kLocationKeyIdentifier = @"地理位置";
static NSString *const kAgeKeyIdentifier = @"年龄展示";
static NSString *const kPairingKeyIdentifier = @"匹配聊天";


@interface LLPrivacySettingController ()
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation LLPrivacySettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initViews];
    [self initConstraints];
}

#pragma mark -
#pragma mark lifeCycle

- (void)initViews {
 
    self.navigationItem.title = @"隐私设置";
    [self.tableView registerClass:TTSettingCell.class forCellReuseIdentifier:@"TTSettingCell"];
    self.tableView.rowHeight = 70;
}

- (void)initConstraints {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(kNavigationHeight, 0, 0, 0));
        }
    }];
}

#pragma mark -
#pragma mark SystemApi Delegate
#pragma mark -
#pragma mark TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TTSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(TTSettingCell.class) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *title = self.dataArray[indexPath.row];
    
    cell.titleLabel.text = title;
    cell.subtitleLabel.text = [self subtitleForTitle:title];
    
    BOOL locationCell = [title isEqualToString:kLocationKeyIdentifier];
    BOOL ageCell = [title isEqualToString:kAgeKeyIdentifier];
    BOOL pairingCell = [title isEqualToString:kPairingKeyIdentifier];
    
    if (locationCell || ageCell || pairingCell) {
        
        BOOL selected = NO;
        if (locationCell) {
            selected = self.currentUserInfo.userExpand.showLocation;
        } else if (ageCell) {
            //无模型时默认YES
            selected = self.currentUserInfo.userExpand==nil || self.currentUserInfo.userExpand.showAge;
        } else if (pairingCell) {
            //无模型时默认YES
            selected = self.currentUserInfo.userExpand==nil || self.currentUserInfo.userExpand.matchChat;
        }
        
        cell.selectSwitch.hidden = NO;
        cell.dataLabel.hidden = YES;
        cell.selectSwitch.on = selected;
        
        cell.switchClickBlock = ^(BOOL isOn) {
            
            if (locationCell) {
                if (isOn) {
                    // 没有位置信息 && 定位被拒绝，授权弹框
                    if (!self.currentUserInfo.userExpand.showLocation && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
                        
                        TTAlertConfig *config = [[TTAlertConfig alloc] init];
                        config.title = @"提示";
                        config.message = @"您未开启定位权限，如需在个人资料页展示位置信息，请前往设置-隐私-开启定位服务";
                        [TTPopup alertWithConfig:config confirmHandler:^{
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                        } cancelHandler:^{
                        }];
                        
                        [self.tableView reloadData];
                        return;
                    }
                }
                
                [GetCore(UserCore) updateUserInfoLocationSwitch:isOn];
                [TTStatisticsService trackEvent:@"setting_location" eventDescribe:!isOn ? @"关闭" : @"开启"];
                
            } else if (ageCell) {
                [GetCore(UserCore) updateUserInfoAgeSwitch:isOn];
            } else if (pairingCell) {
                [GetCore(UserCore) updateUserInfoMatchChatSwitch:isOn];
            }
        };
        
    } else {
        
        cell.selectSwitch.hidden = YES;
        cell.dataLabel.hidden = NO;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UserCoreClient
// 更新 位置开关
- (void)updateUserInfoLocationSwitchSuccess:(BOOL)showLocation {
    self.currentUserInfo.userExpand.showLocation = showLocation;
    [self.tableView reloadData];
}

- (void)updateUserInfoLocationSwitchFailth:(BOOL)showLocation errorMessage:(NSString *)message {
    
    self.currentUserInfo.userExpand.showLocation = showLocation;
    [XCHUDTool showErrorWithMessage:message inView:self.view];
    [self.tableView reloadData];
}

/// 更新年龄开关回调
/// @param success 是否更新成功
/// @param code 错误码
/// @param msg 错误信息
- (void)responseUserInfoAgeSwitchSuccess:(BOOL)success code:(NSNumber *)code msg:(NSString *)msg {
    
    if (success) {
        self.currentUserInfo.userExpand.showAge = !self.currentUserInfo.userExpand.showAge;
        
        NSString *status = self.currentUserInfo.userExpand.showAge ? @"开" : @"关";
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
        self.currentUserInfo.userExpand.matchChat = !self.currentUserInfo.userExpand.matchChat;
        
        NSString *status = self.currentUserInfo.userExpand.showAge ? @"开" : @"关";
        NSString *des = [NSString stringWithFormat:@"匹配聊天:%@", status];
        [TTStatisticsService trackEvent:@"setting_chat_matching" eventDescribe:des];
        return;
    }
    
    [XCHUDTool showErrorWithMessage:msg inView:self.view];
    [self.tableView reloadData];
}

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
/// 根据标题获取子标题
- (NSString *)subtitleForTitle:(NSString *)title {
    NSDictionary *dict = @{kLocationKeyIdentifier : @"展示地理位置信息",
                           kAgeKeyIdentifier : @"展示年龄信息",
                           kPairingKeyIdentifier : @"关闭后将不再推荐至首页合拍"};
    return [dict objectForKey:title];
}
#pragma mark -
#pragma mark Getters and Setters
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithArray:@[kLocationKeyIdentifier, kAgeKeyIdentifier, kPairingKeyIdentifier]];
    }
    return _dataArray;
}



@end
