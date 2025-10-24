//
//  TTNotificationSettingsViewController.m
//  XC_TTPersonalMoudle
//
//  Created by lvjunhang on 2019/12/20.
//  Copyright © 2019 WUJIE INTERACTIVE. All rights reserved.
//

#import "TTNotificationSettingsViewController.h"

#import "TTNotificationSettingsCell.h"
#import "TTNotificationSettingsItem.h"

#import <UserNotifications/UserNotifications.h>

#import "ImFriendCore.h"
#import "UserCore.h"
#import "UserCoreClient.h"

#import "NSArray+Safe.h"
#import "XCHUDTool.h"
#import "TTPopup.h"
#import "TTStatisticsService.h"

#import <Masonry/Masonry.h>

static NSString *const kCellId = @"kCellId";

@interface TTNotificationSettingsViewController ()
<
UserCoreClient
>

@property (nonatomic, strong) NSArray<NSArray<TTNotificationSettingsItem *> *> *dataModelArray;
@end

@implementation TTNotificationSettingsViewController

#pragma mark - Life Cycle
- (void)dealloc {
    RemoveCoreClientAll(self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通知提醒设置";
    
    AddCoreClient(UserCoreClient, self);
    
    [self.tableView registerClass:[TTNotificationSettingsCell class] forCellReuseIdentifier:kCellId];
    self.tableView.contentInset = UIEdgeInsetsMake(1, 0, 0, 0);

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.mas_topLayoutGuide);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [GetCore(UserCore) requestUserInfoNotifyStatus];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataModelArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataModelArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *sectionArray = [self.dataModelArray safeObjectAtIndex:indexPath.section];
    TTNotificationSettingsItem *item = [sectionArray safeObjectAtIndex:indexPath.row];
    
    TTNotificationSettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId forIndexPath:indexPath];
    
    cell.titleLabel.text = item.title;
    cell.subtitleLabel.text = item.desc;
    cell.selectSwitch.on = item.notification;
    
    @weakify(self)
    cell.switchClickBlock = ^(BOOL isOn) {
        
        @strongify(self)
        [TTNotificationSettingsViewController mobilePushAuthority:^(BOOL isAuthority) {
            
            if (!isAuthority) {
                [TTPopup alertWithMessage:@"您未开启推送通知权限，请前往设置" confirmHandler:^{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                } cancelHandler:^{
                    
                }];
                item.notification = NO;
                [tableView reloadData];
                return;
            }
            
            if (item.type == TTNotificationSettingsItemTypeSystem) {
                [self setSystemNotify:isOn item:item];
                
                NSString *des = [NSString stringWithFormat:@"系统通知提醒:%@", isOn ? @"开" : @"关"];
                [TTStatisticsService trackEvent:@"setting_system_notice" eventDescribe:des];
            }
            
            switch (item.type) {
                case TTNotificationSettingsItemTypeSystem:
                {
                    [self setSystemNotify:isOn item:item];
                    
                    NSString *des = [NSString stringWithFormat:@"系统通知提醒:%@", isOn ? @"开" : @"关"];
                    [TTStatisticsService trackEvent:@"setting_system_notice" eventDescribe:des];
                }
                    break;
                case TTNotificationSettingsItemTypeInteraction:
                {
                    [self setInteractionNotify:isOn item:item];
                }
                    break;
                default:
                    break;
            }
        }];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

#pragma mark - Private
/// 获取手机推送权限
+ (void)mobilePushAuthority:(void(^)(BOOL isAuthority))authority {
    
    if (@available(iOS 10.0, *)) {
        [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            
            BOOL permission = settings.authorizationStatus == UNAuthorizationStatusAuthorized;
            dispatch_async(dispatch_get_main_queue(), ^{
                !authority ?: authority(permission);
            });
        }];
    } else {
        BOOL permission = [[UIApplication sharedApplication] currentUserNotificationSettings].types != UIUserNotificationTypeNone;
        !authority ?: authority(permission);
    }
}

/// 获取系统通知权限
- (BOOL)systemNotify {
    
    SecretarySystemUIDs *uids = GetCore(ImFriendCore).secretarySystemUIDs;
    if (uids == nil) {
        //uid为空时，获取、缓存
        [GetCore(ImFriendCore) requestSecretarySystemUIDsWithCompletion:nil];
        return NO;
    }
    
    BOOL secretaryNotify = [GetCore(ImFriendCore) notifyForNewMsg:uids.secretaryUid];
    BOOL systemNotify = [GetCore(ImFriendCore) notifyForNewMsg:uids.systemMessageUid];

    return secretaryNotify && systemNotify;
}

/// 设置系统通知权限
- (void)setSystemNotify:(BOOL)isOn item:(TTNotificationSettingsItem *)item {
    
    if ([self systemNotify] == isOn) {
        item.notification = isOn;
        return;
    }
    
    SecretarySystemUIDs *uids = GetCore(ImFriendCore).secretarySystemUIDs;
    if (uids == nil) {
        //uid为空时，获取、缓存
        [GetCore(ImFriendCore) requestSecretarySystemUIDsWithCompletion:nil];
        
        [XCHUDTool showErrorWithMessage:@"请求未成功"];
        [self.tableView reloadData];
        return;
    }
    
    [GetCore(ImFriendCore) updateNotifyState:isOn forUser:uids.secretaryUid completion:^(NSError * _Nullable error) {
        
        if (error == nil) {
            item.notification = isOn;
            return;
        }
        
        [XCHUDTool showErrorWithMessage:error.localizedDescription];
        [self.tableView reloadData];
    }];
    
    [GetCore(ImFriendCore) updateNotifyState:isOn forUser:uids.systemMessageUid completion:^(NSError * _Nullable error) {
        
        if (error == nil) {
            item.notification = isOn;
            return;
        }
        
        [XCHUDTool showErrorWithMessage:error.localizedDescription];
        [self.tableView reloadData];
    }];
    
    //iOS端只上传给服务器统计，暂无业务操作关系
    [GetCore(UserCore) updateUserInfoSystemNotify:isOn completion:nil];
}

/// 设置互动通知权限
- (void)setInteractionNotify:(BOOL)isOn item:(TTNotificationSettingsItem *)item {
    
    [GetCore(UserCore) updateUserInfoInteractionNotify:isOn completion:^(BOOL result, NSNumber *errCode, NSString *msg) {
        
        if (result) {
            item.notification = isOn;
            return;
        }
        
        [XCHUDTool showErrorWithMessage:msg ?: @"请求未完成"];
    }];
}

#pragma mark - Core
#pragma mark UserCoreClient
/// 获取用户消息设置状态
- (void)responseUserInfoNotifyStatus:(UserNotifyStatus *)data code:(NSNumber *)code msg:(NSString *)msg {
    
    if (code) {
        [XCHUDTool showErrorWithMessage:msg ?: @"请求数据错误"];
        return;
    }
    
    @weakify(self)
    [TTNotificationSettingsViewController mobilePushAuthority:^(BOOL isAuthority) {
        @strongify(self)
        TTNotificationSettingsItem *systemItem = [[TTNotificationSettingsItem alloc] init];
        systemItem.type = TTNotificationSettingsItemTypeSystem;
        systemItem.title = @"系统通知";
        systemItem.desc = @"关闭后，系统消息和官方小秘书不再提示";
        systemItem.notification = isAuthority ? [self systemNotify] : NO;//注意，系统消息状态通过云信判断，而非服务器
        
        TTNotificationSettingsItem *interactionItem = [[TTNotificationSettingsItem alloc] init];
        interactionItem.type = TTNotificationSettingsItemTypeInteraction;
        interactionItem.title = @"互动通知";
        interactionItem.desc = @"关闭后，收到动态互动通知不再提示";
        interactionItem.notification = isAuthority ? data.interactiveMsgNotify : NO;
        
        self.dataModelArray = [NSMutableArray arrayWithArray:@[@[systemItem, interactionItem]]];
        [self.tableView reloadData];
    }];
}
@end
