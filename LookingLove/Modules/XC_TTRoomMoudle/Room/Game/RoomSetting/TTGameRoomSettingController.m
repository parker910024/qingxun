//
//  TTGameRoomSettingController.m
//  TuTu
//
//  Created by KevinWang on 2018/11/6.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTGameRoomSettingController.h"
#import "TTRoomRoleListController.h"
#import "TTWKWebViewViewController.h"

#import "TTRoomSettingsCell.h"
#import "TTRoomSettingsConfig.h"
#import "TTRoomSettingsInputAlertView.h"
#import "TTRoomSettingsTagPickerView.h"

//core
#import "RoomCoreV2.h"
#import "RoomCoreClient.h"
#import "RoomQueueCoreV2.h"
#import "ImRoomCoreV2.h"
#import "AuthCore.h"
#import "UserCore.h"
#import "HomeCore.h"
#import "HomeCoreClient.h"
#import "ArrangeMicCore.h"
#import "ArrangeMicCoreClient.h"
#import "ImMessageCore.h"
#import "ImMessageCoreClient.h"
#import "RoomGiftValueCore.h"
#import "CPGameCore.h"

#import "HomeTag.h"
#import "XCTheme.h"
#import "XCMacros.h"
#import "XCHtmlUrl.h"
#import "XCHUDTool.h"
#import "NSArray+Safe.h"

#import <Masonry/Masonry.h>
#import <IQKeyboardManager.h>
#import "TTStatisticsService.h"
#import "TTPopup.h"

#import "TTCPGameView.h"
#import "TTRoomModuleCenter.h"
#import "XCRoomSuperAdminAttachment.h"

static NSString *const kCellId = @"kCellId";
static NSString *const kPureModeDetailText = @"开启纯净模式后，砸蛋消息将不在当前房间公屏展示";
static NSString *const kLeaveModelDetailText = @"设置离开模式，房主可离线收益";
@interface TTGameRoomSettingController ()<RoomCoreClient, HomeCoreClient, ArrangeMicCoreClient, ImMessageCoreClient>

@property (nonatomic, strong) NSArray<NSArray<TTRoomSettingsConfig *> *> *dataSourceArray;

@property (nonatomic, strong) RoomInfo *roomInfo;

@property (nonatomic, strong) NSArray *tagList;

@property (nonatomic, strong) UserInfo *myUserInfo;
@end

@implementation TTGameRoomSettingController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    BOOL isSuperAdminAndDelegateSuperAdmin = self.myUserInfo.platformRole == XCUserInfoPlatformRoleSuperAdmin&&[[NSUserDefaults standardUserDefaults] boolForKey:@"deleteSuperAdmin"];
    BOOL isSuperAdminNotDelegateSuperAdmin = self.myUserInfo.platformRole == XCUserInfoPlatformRoleSuperAdmin&&![[NSUserDefaults standardUserDefaults] boolForKey:@"deleteSuperAdmin"];
    BOOL isDelegateSuperAdminNotSuperAdmin = self.myUserInfo.platformRole != XCUserInfoPlatformRoleSuperAdmin&&[[NSUserDefaults standardUserDefaults] boolForKey:@"deleteSuperAdmin"];
    
    if (isSuperAdminNotDelegateSuperAdmin) {

        self.navigationItem.title = @"官方管理";

    } else if (isSuperAdminAndDelegateSuperAdmin ||
               isDelegateSuperAdminNotSuperAdmin) {

        self.navigationItem.title = @"房间设置";

    } else {
        self.navigationItem.title = @"房间设置";
    }
    
    [self initView];
}

- (void)dealloc {
    RemoveCoreClientAll(self);
}

#pragma mark - public method
#pragma mark - system protocols
#pragma mark UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSourceArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TTRoomSettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId forIndexPath:indexPath];
    
    TTRoomSettingsConfig *config = self.dataSourceArray[indexPath.section][indexPath.row];
    cell.config = config;
    
    /// Setting Contents
    if (config.type == TTRoomSettingsSourceName) {
        cell.contentLabel.text = self.roomInfo.title;
        cell.contentLabel.textColor = [XCTheme getMSThirdTextColor];
        
    } else if (config.type == TTRoomSettingsSourceLock) {
        cell.selectSwitch.on = self.roomInfo.roomPwd.length > 0;
        
    } else if (config.type == TTRoomSettingsSourcePwd) {
        cell.nameLabel.text = self.roomInfo.roomPwd;
        
    } else if (config.type == TTRoomSettingsSourceTag) {
        cell.contentLabel.text = self.roomInfo.roomTag;
        cell.contentLabel.textColor = [XCTheme getTTMainColor];
        
    } else if (config.type == TTRoomSettingsSourceGiftEffect) {
        cell.selectSwitch.on = self.roomInfo.hasAnimationEffect;
        
    } else if (config.type == TTRoomSettingsSourceQueueMike) {
        if (self.roomInfo.roomModeType == RoomModeType_Open_Micro_Mode) {
            cell.selectSwitch.on = YES;
        }else{
            cell.selectSwitch.on = NO;
        }
        
    } else if (config.type == TTRoomSettingsSourceMale){
        cell.selectSwitch.on = !self.roomInfo.isCloseScreen;
        
    } else if (config.type == TTRoomSettingsSourcePureModel){
        cell.selectSwitch.on = self.roomInfo.isPureMode;
        if (self.roomInfo.isPureMode) {
            cell.detailLabel.hidden = NO;
            cell.detailLabel.text = kPureModeDetailText;
        } else {
            cell.detailLabel.hidden = YES;
        }
        
    } else if (config.type == TTRoomSettingsSourceRoomLeaveModel) {
        cell.selectSwitch.on = self.roomInfo.leaveMode;
        if (self.roomInfo.leaveMode) {
            cell.detailLabel.hidden = NO;
            cell.detailLabel.text = kLeaveModelDetailText;
        } else {
            cell.detailLabel.hidden = YES;
        }
        
    } else if (config.type == TTRoomSettingsSourceHideRoom) {
        cell.selectSwitch.on = self.roomInfo.hideFlag;
        
    } else if (config.type == TTRoomSettingsSourceUnlockRoomLimit||config.type == TTRoomSettingsSourceUnlockRoom) {
        cell.contentImageView.image = [UIImage imageNamed:@"room_settings_unlock"];
        cell.nameLabel.textColor = UIColorFromRGB(0XFE4C62);
        
    } else if (config.type == TTRoomSettingsSourceCloseRoom) {
        cell.contentImageView.image = [UIImage imageNamed:@"room_settings_close"];
        cell.nameLabel.textColor = UIColorFromRGB(0XFE4C62);
    }
    
    /// Setting Separate Line
    BOOL lastLine = self.dataSourceArray[indexPath.section].count-1 == indexPath.row;
    BOOL hidePwd = (config.type == TTRoomSettingsSourceLock) && (self.roomInfo.roomPwd.length == 0);
    cell.hiddenSeparateLine = lastLine || hidePwd;
    
    /// Setting Switch Block
    [cell setSwitchClickBlock:^(BOOL isOn) {
        
        if (config.type == TTRoomSettingsSourceLock) {
            [self passwordChange:isOn eventType:RoomUpdateEventTypeOther];
            return;
        }
        
        if (config.type == TTRoomSettingsSourceGiftEffect) {
            [self giftEffectChange:isOn];
            return;
        }
        
        if (config.type == TTRoomSettingsSourceQueueMike) {
            // 开启排麦模式
            [self openOrCloseArrangeMic:isOn];
            return;
        }
        
        if (config.type == TTRoomSettingsSourceMale) {
            // 关闭房间公屏
            [self openOrCloseRoomMaleScreen:isOn];
            return;
        }
        
        if (config.type == TTRoomSettingsSourcePureModel) {
            // 关闭纯净模式
            [self pureModeChange:isOn];
            return;
        }
        
        if (config.type == TTRoomSettingsSourceRoomLeaveModel) {
            // 离开模式
            [self leaveModeChange:isOn];
            return;
        }
    
        if (config.type == TTRoomSettingsSourceHideRoom) {
            
            [self hideRoom:isOn];
            return;
        }
        
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TTRoomSettingsConfig *config = self.dataSourceArray[indexPath.section][indexPath.row];
    if (config.type == TTRoomSettingsSourcePwd) {
        if (self.roomInfo.roomPwd == nil || self.roomInfo.roomPwd.length == 0) {
            return CGFLOAT_MIN;
        }
    }
    
    if (config.type == TTRoomSettingsSourcePureModel) {
        if (self.roomInfo.isPureMode) {
            UILabel *label = [[UILabel alloc] init];
            label.text = kPureModeDetailText;
            label.font = [UIFont systemFontOfSize:12];
            label.numberOfLines = 0;
            CGFloat height = [label sizeThatFits:CGSizeMake(KScreenWidth - 20 - 72, MAXFLOAT)].height;
            return 12 + 37 + height;
        }  else {
            return 50;
        }
    } else if (config.type == TTRoomSettingsSourceRoomLeaveModel) {
        if (self.roomInfo.leaveMode) {
            UILabel *label = [[UILabel alloc] init];
            label.text = kLeaveModelDetailText;
            label.font = [UIFont systemFontOfSize:12];
            label.numberOfLines = 0;
            CGFloat height = [label sizeThatFits:CGSizeMake(KScreenWidth - 20 - 72, MAXFLOAT)].height;
            return 12 + 37 + height;
        }
    }
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    TTRoomSettingsConfig *config = self.dataSourceArray[indexPath.section][indexPath.row];
    
    /// 房间名
    if (config.type == TTRoomSettingsSourceName) {
        TTRoomSettingsInputAlertView *alert = [[TTRoomSettingsInputAlertView alloc] init];
        alert.title = @"房间名";
        alert.placeholder = @"请输入房间名";
        alert.content = self.roomInfo.title;
        alert.maxCount = 15;
        
        [alert showAlertWithCompletion:^(NSString * _Nonnull content) {
            [self updateRoomName:content];
        } dismiss:^{
        }];
        
        return;
    }
    
    /// 密码修改
    if (config.type == TTRoomSettingsSourcePwd) {
        [self passwordChange:YES eventType:RoomUpdateEventTypeOther];
        return;
    }
    
    /// 房间标签
    if (config.type == TTRoomSettingsSourceTag) {
        [self roomTagPicker];
        return;
    }
    
    /// 管理员
    if (config.type == TTRoomSettingsSourceAdmin) {
        TTRoomRoleListController *vc = [[TTRoomRoleListController alloc] init];
        vc.role = TTRoomRoleManager;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    /// 黑名单
    if (config.type == TTRoomSettingsSourceBlacklist) {
        TTRoomRoleListController *vc = [[TTRoomRoleListController alloc] init];
        vc.role = TTRoomRoleBlacklist;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    /// 背景设置
    if (config.type == TTRoomSettingsSourceBackground) {
        TTWKWebViewViewController *vc = [[TTWKWebViewViewController alloc] init];
//        NSString *url = [NSString stringWithFormat:@"%@", HtmlUrlKey(kRoomSettingsBackgrondURL)];
        vc.urlString = HtmlUrlKey(kRoomSettingsBackgrondURL);
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if (config.type == TTRoomSettingsSourceUnlockRoomLimit||config.type == TTRoomSettingsSourceUnlockRoom) {
        [self unlockRoom:config.type];
        return;
    }
    
    if (config.type == TTRoomSettingsSourceCloseRoom) {
        [self closeRoom];
        return;
    }
}

#pragma mark - custom protocols
#pragma mark - core protocols
#pragma mark RoomCoreClient
- (void)onGameRoomInfoUpdateSuccess:(RoomInfo *)info eventType:(RoomUpdateEventType)eventType {
    // 此处修改过。修改之前为 tipString = @"修改成功"; 如果不改，会toast show 两次。 测试提出了bug。 (一个版本后删除此注释）
    NSString *tipString;
    switch (eventType) {
            case RoomUpdateEventTypeOpenGiftEffect:
            tipString = @"开启成功";
            break;
            case RoomUpdateEventTypeCloseGiftEffect:
            tipString = @"关闭成功";
            break;
        default:
            break;
    }
    
    self.roomInfo = info;
    [self.tableView reloadData];
    
    [XCHUDTool showErrorWithMessage:tipString];
}

- (void)onGameRoomInfoUpdateFailth:(NSString *)message {
    NSString *tipString = message.length > 0 ? message : @"修改房间信息失败，请重试";
    [XCHUDTool showErrorWithMessage:tipString];
    
    [self.tableView reloadData];
}

#pragma mark 离开模式 CoreClient
// 离开模式
- (void)onChangeRoomLeaveModeSuccess:(BOOL)leaveMode {
    [XCHUDTool hideHUD];
    // 如果是关闭，清空房主临时数据
    if (!leaveMode) {
        [GetCore(RoomGiftValueCore) requestRoomGiftValueStatusDownMicWithRoomUid:self.roomInfo.uid micUid:self.roomInfo.uid position:@"-1"];
        return;
    }
    
    [TTStatisticsService trackEvent:TTStatisticsServiceEventOpenLeaveMode eventDescribe:@"开启离线模式成功"];
    
    [GetCore(RoomGiftValueCore) requestRoomGiftValueStatusUpMicWithRoomUid:self.roomInfo.uid micUid:self.roomInfo.uid position:@"-1"];
    
    // 如果是开启，则把房主信息临时保存
    UserInfo *roomOwnUserInfo = [GetCore(UserCore) getUserInfoInDB:self.roomInfo.uid];
    
    NIMCustomObject *customObject = [[NIMCustomObject alloc]init];
    Attachment *attachment = [[Attachment alloc] init];
    attachment.first = Custom_Noti_Header_Room_LeaveMode;
    attachment.second = Custom_Noti_Sub_Room_LeaveMode_Notice;
    attachment.data = [roomOwnUserInfo model2dictionary];
    customObject.attachment = attachment;
    
    [GetCore(ImMessageCore) sendCustomMessageAttachement:attachment sessionId:[NSString stringWithFormat:@"%ld",(long)self.roomInfo.roomId] type:NIMSessionTypeChatroom];
}

- (void)onChangeRoomLeaveModeFailth:(NSString *)message code:(NSNumber *)code {
    [XCHUDTool hideHUD];
    [self.tableView reloadData];
}
#pragma mark HomeCoreClient
- (void)requestRoomAllTagListSuccess:(NSArray *)list {
    self.tagList = list;
    
    if (list && kHandleRoomTagPicker) {
        kHandleRoomTagPicker = NO;
        [self roomTagPicker];
    }
}

- (void)requestRoomAllTagListFailth:(NSString *)msg {
    [XCHUDTool showErrorWithMessage:msg];
}

#pragma mark - event response
#pragma mark - private method
- (void)initView {
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    AddCoreClient(RoomCoreClient, self);
    AddCoreClient(HomeCoreClient, self);
    AddCoreClient(ArrangeMicCoreClient, self);
    AddCoreClient(ImMessageCoreClient, self);
    
    self.roomInfo = GetCore(ImRoomCoreV2).currentRoomInfo;
    [self fetchRoomTag:NO];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:TTRoomSettingsCell.class forCellReuseIdentifier:kCellId];
    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.edges.mas_equalTo(self.view);
        }
    }];
}

- (void)passwordChange:(BOOL)settingPwd eventType:(RoomUpdateEventType)eventType {
    
    if (!settingPwd) {
        [self updateRoomPwd:@""];
        return;
    }
    
    TTRoomSettingsInputAlertView *alert = [[TTRoomSettingsInputAlertView alloc] init];
    alert.title = @"房间密码";
    alert.placeholder = @"请输入房间密码";
    alert.content = self.roomInfo.roomPwd;
    alert.maxCount = 8;
    alert.keyboardType = UIKeyboardTypeNumberPad;
    
    [alert showAlertWithCompletion:^(NSString * _Nonnull content) {
        [self updateRoomPwd:content];
    } dismiss:^{
        [self reloadRowWithSource:TTRoomSettingsSourceLock];
    }];
}
//是不是开启排麦
- (void)openOrCloseArrangeMic:(BOOL)isOn{
    NSString *msg;
    if (isOn) {
        msg = @"开启排麦模式要排队才能上麦，确定开启吗？";
    } else {
        msg = @"关闭排麦模式后会清空排麦列表哦，确定关闭吗？";
    }
    // 开关都需要弹窗警告
    @weakify(self);
    
    TTAlertConfig *config = [[TTAlertConfig alloc] init];
    config.title = @"提示";
    config.message = msg;
    config.shouldDismissOnBackgroundTouch = NO;
    
    [TTPopup alertWithConfig:config confirmHandler:^{
        
        [GetCore(ArrangeMicCore) managerRoomMiacStatusWith:isOn roomUid:self.roomInfo.uid];
        
    } cancelHandler:^{
        @strongify(self);
        [self.tableView reloadData];
    }];
}

-(void)openOrCloseRoomMaleScreen:(BOOL )closeMale isSuperAdmin:(BOOL)isSuperAdmin {
    if (closeMale) {
        [GetCore(RoomCoreV2) updateRoomMessageViewState:[GetCore(AuthCore)getUid].userIDValue isCloseScreen:!GetCore(ImRoomCoreV2).currentRoomInfo.isCloseScreen isSuperAdmin:isSuperAdmin];
        return;
    }
    
    @weakify(self);
    
    TTAlertConfig *config = [[TTAlertConfig alloc] init];
    config.title = @"温馨提示";
    config.message = @"关闭后将看不到聊天信息，运作更加流畅。是否确认关闭公屏?";
    config.shouldDismissOnBackgroundTouch = NO;
    
    [TTPopup alertWithConfig:config confirmHandler:^{
       
        [GetCore(RoomCoreV2) updateRoomMessageViewState:[GetCore(AuthCore)getUid].userIDValue isCloseScreen:YES isSuperAdmin:isSuperAdmin];
        
    } cancelHandler:^{
        @strongify(self);
        [self.tableView reloadData];
    }];
}

-(void)openOrCloseRoomMaleScreen:(BOOL )closeMale{
    [self openOrCloseRoomMaleScreen:closeMale isSuperAdmin:NO];
}


/// 礼物特效切换
- (void)giftEffectChange:(BOOL)openEffect {
    
    if (openEffect) {
        [self updateGiftEffect:YES];
        return;
    }
    
    @weakify(self);
    
    TTAlertConfig *config = [[TTAlertConfig alloc] init];
    config.title = @"温馨提示";
    config.message = @"关闭后将看不到礼物特效，运作更加流畅。是否确认关闭礼物特效?";
    config.shouldDismissOnBackgroundTouch = NO;

    [TTPopup alertWithConfig:config confirmHandler:^{
        
        @strongify(self);
        [self updateGiftEffect:NO];
        if (GetCore(RoomCoreV2).hasAnimationEffect) {
            GetCore(RoomCoreV2).hasAnimationEffect = NO;
        }
    } cancelHandler:^{
        @strongify(self);
        [self.tableView reloadData];
    }];
}

/// 纯净模式切换
- (void)pureModeChange:(BOOL)pureMode {
    
    NSString *detailText = @"确认关闭纯净模式吗?";
    if (pureMode) { // 开启纯净模式后，砸蛋消息将不在当前房间展示，确认开启吗
        detailText = @"开启纯净模式后，砸蛋消息将不在当前房间公屏展示，确认开启吗?";
        [[BaiduMobStat defaultStat] logEvent:@"open_pure_mode" eventLabel:@"开启纯净模式"];
    }
    
    // 确认关闭纯净模式吗
    
    @weakify(self);
    
    TTAlertConfig *config = [[TTAlertConfig alloc] init];
    config.title = @"温馨提示";
    config.message = detailText;
    config.shouldDismissOnBackgroundTouch = NO;
    
    [TTPopup alertWithConfig:config confirmHandler:^{
        
        @strongify(self);
        [self updatePureModel:pureMode];
        
    } cancelHandler:^{
        @strongify(self);
        [self.tableView reloadData];
    }];
}

- (void)hideRoom:(BOOL)isOn {
    
    @weakify(self);
    if (isOn) {
        
        [TTPopup alertWithMessage:@"隐藏房间，用户只能通过搜索或关注查找到该房间，请谨慎操作" confirmHandler:^{
            @strongify(self);
            [self hideRoomRequest:isOn];
            
        } cancelHandler:^{
            @strongify(self);
            [self reloadList];
        }];
        
    } else {
        @strongify(self);
        [self hideRoomRequest:isOn];
    }
}

- (void)hideRoomRequest:(BOOL)hide {
    
    @weakify(self)
    [GetCore(RoomCoreV2) requestSettingHideRoom:hide success:^(BOOL success) {
        @strongify(self)
        [self updateRoomInfo];
        if (hide) {
            [GetCore(RoomCoreV2) recordSuperAdminOperate:SuperAdminOperateTypeHiddenRoom superAdminUid:GetCore(AuthCore).getUid.userIDValue roomUid:self.roomInfo.uid targetUid:nil];
        }
    }];
}

- (void)reloadList {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.tableView reloadData];
    });
}

- (void)closeRoom {
    
    @weakify(self)
    [TTPopup alertWithMessage:@"关闭房间，并将房间内所有用户踢出，请谨慎操作" confirmHandler:^{
        [GetCore(RoomCoreV2)closeRoomWithBlock:self.roomInfo.uid Success:^(UserID uid) {//close
            
            [GetCore(RoomCoreV2) sendOfficalManagerCustomMessage:Custom_Noti_Sub_Room_SuperAdmin_CloseRoom];
            [GetCore(RoomCoreV2) recordSuperAdminOperate:SuperAdminOperateTypeCloseRoom superAdminUid:[GetCore(AuthCore).getUid userIDValue] roomUid:self.roomInfo.uid targetUid:nil];

        } failure:^(NSNumber *resCode, NSString *message) {
            if ([resCode intValue] == 18004) {
                @strongify(self)
                [self.navigationController popViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NotSuperAdmin" object:nil];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"deleteSuperAdmin"];
            }
        }];
        
    } cancelHandler:^{
        
    }];
}

- (void)unlockRoom:(TTRoomSettingSource)type {
    
    @weakify(self)
    [GetCore(RoomCoreV2) unlockRoomLimitType:@"" roomPwd:@"" success:^{
        
        [XCHUDTool showSuccessWithMessage:@"操作成功"];
        @strongify(self)
        [self.navigationController popViewControllerAnimated:YES];
        if (type == TTRoomSettingsSourceUnlockRoomLimit) {
            [GetCore(RoomCoreV2) sendOfficalManagerCustomMessage:Custom_Noti_Sub_Room_SuperAdmin_unLimmit];
        } else {
            [GetCore(RoomCoreV2) sendOfficalManagerCustomMessage:Custom_Noti_Sub_Room_SuperAdmin_unLock];
            [GetCore(RoomCoreV2) recordSuperAdminOperate:SuperAdminOperateTypeUnlockRoom superAdminUid:[GetCore(AuthCore).getUid userIDValue] roomUid:self.roomInfo.uid targetUid:nil];
        }
        
    } failure:^(NSNumber *resCode, NSString *message) {
        
        if ([resCode intValue] == 18004) {
            @strongify(self)
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NotSuperAdmin" object:nil];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"deleteSuperAdmin"];
        }
    }];
}

/** 离开模式 */
- (void)leaveModeChange:(BOOL)leaveMode {
    
    // 关闭是直接关闭，无须弹窗
    if (!leaveMode) {
        [GetCore(RoomCoreV2) requestChangeRoomLeaveMode:self.roomInfo.uid leaveMode:leaveMode];
        return;
    }
    
    @weakify(self)
    
    TTAlertConfig *config = [[TTAlertConfig alloc] init];
    config.message = @"开启离开模式后，房主会固定显示在房主位，确认开启吗？";
    config.shouldDismissOnBackgroundTouch = NO;
    
    [TTPopup alertWithConfig:config confirmHandler:^{
        @strongify(self)
        [XCHUDTool showGIFLoading];
        [self beforeOpenRoomLeaveMode:leaveMode];
        
    } cancelHandler:^{
        
        @strongify(self);
        [self.tableView reloadData];
    }];
}

// 开启离开模式之前，需要做的事情。
- (void)beforeOpenRoomLeaveMode:(BOOL)leaveMode {
    BOOL isOnMic = [GetCore(RoomQueueCoreV2) isOnMicro:self.roomInfo.uid];
    // 判断是不是房主是不是坑位上
    if (isOnMic) { // 如果是就下麦
        [GetCore(RoomQueueCoreV2) downMic];
    }
    
    NSString *position = @"-1"; // 房主位
    UserInfo *onMicInfo = [GetCore(ImRoomCoreV2).micQueue objectForKey:position].userInfo;
    // 判断房主位是不是已经有人在
    if (onMicInfo) { // 如果是就抱下麦
        [GetCore(RoomQueueCoreV2) kickDownMic:onMicInfo.uid position:position.intValue];
    }

    @weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self);
        [GetCore(RoomCoreV2) requestChangeRoomLeaveMode:self.roomInfo.uid leaveMode:leaveMode];
    });
}



/**
 根据源类型刷新对应行

 @param source 源类型
 */
- (void)reloadRowWithSource:(TTRoomSettingSource)source {
    __block NSIndexPath *indexPath = nil;
    [self.dataSourceArray enumerateObjectsUsingBlock:^(NSArray<TTRoomSettingsConfig *> * _Nonnull obj, NSUInteger section, BOOL * _Nonnull stop) {
        
        static BOOL mapSource = NO;
        [obj enumerateObjectsUsingBlock:^(TTRoomSettingsConfig * _Nonnull config, NSUInteger row, BOOL * _Nonnull stop) {
            if (config.type == source) {
                indexPath = [NSIndexPath indexPathForRow:row inSection:section];
                *stop = YES;
                mapSource = YES;
            }
        }];
        
        if (mapSource) {
            *stop = YES;
        }
    }];
    
    if (indexPath != nil) {
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark Room Tag Handle

/// 是否使用标签选择器标记
static BOOL kHandleRoomTagPicker = NO;

/**
 获取房间标签列表

 @param handlePicker 是否进一步使用标签选择器处理
 */
- (void)fetchRoomTag:(BOOL)handlePicker {
    kHandleRoomTagPicker = handlePicker;
    [GetCore(HomeCore) requestRoomAllTag];
}

/**
 使用标签选择器
 */
- (void)roomTagPicker {
    
    if (self.tagList == nil || self.tagList.count == 0) {
        [self fetchRoomTag:YES];
        return;
    }
    
    HomeTag *tag = [[HomeTag alloc] init];
    tag.id = self.roomInfo.tagId;
    tag.name = self.roomInfo.roomTag;
    
    TTRoomSettingsTagPickerView *picker = [[TTRoomSettingsTagPickerView alloc] init];
    picker.tagList = self.tagList;
    picker.selectedTag = tag;
    
    [picker showAlertWithCompletion:^(HomeTag *tag) {
        [self updateRoomTag:tag];
    } dismiss:^{
    }];
}

#pragma mark Update Room Info Request
- (void)updateRoomTag:(HomeTag *)tag {
    
    if (self.roomInfo == nil) {
        NSAssert(NO, @"Fetch room info ERROR");
        return;
    }
    
    if (tag == nil) {
        NSAssert(NO, @"Invalid tag model");
        return;
    }
    
    [self updateRoomInfoWithName:self.roomInfo.title
                        password:self.roomInfo.roomPwd
                           tagId:tag.id
              hasAnimationEffect:self.roomInfo.hasAnimationEffect
                    audioQuality:self.roomInfo.audioQuality
                       eventType:RoomUpdateEventTypeOther];
}

- (void)updateGiftEffect:(BOOL)openEffect {
    
    RoomUpdateEventType eventType = openEffect ? RoomUpdateEventTypeOpenGiftEffect : RoomUpdateEventTypeCloseGiftEffect;

    if (self.roomInfo == nil) {
        NSAssert(NO, @"Fetch room info ERROR");
        return;
    }
    
    [self updateRoomInfoWithName:self.roomInfo.title
                        password:self.roomInfo.roomPwd
                           tagId:self.roomInfo.tagId
              hasAnimationEffect:openEffect
                    audioQuality:self.roomInfo.audioQuality
                       eventType:eventType];
}

- (void)updatePureModel:(BOOL)pureModel {
    if (self.roomInfo == nil) {
        NSAssert(NO, @"Fetch room info ERROR");
        return;
    }
    
    if (GetCore(ImRoomCoreV2).myMember.type == NIMChatroomMemberTypeCreator) {
        [GetCore(RoomCoreV2) updateGameRoomInfo:@{@"isPureMode" : @(pureModel)} type:UpdateRoomInfoTypeUser];
    } else if (GetCore(ImRoomCoreV2).myMember.type == NIMChatroomMemberTypeManager) {
        [GetCore(RoomCoreV2) updateGameRoomInfo:@{@"isPureMode" : @(pureModel)} type:UpdateRoomInfoTypeManager];
    }
}

- (void)updateRoomPwd:(NSString *)roomPwd {
    
    if (self.roomInfo == nil) {
        NSAssert(NO, @"Fetch room info ERROR");
        return;
    }
    
    [self updateRoomInfoWithName:self.roomInfo.title
                        password:roomPwd
                           tagId:self.roomInfo.tagId
              hasAnimationEffect:self.roomInfo.hasAnimationEffect
                    audioQuality:self.roomInfo.audioQuality
                       eventType:RoomUpdateEventTypeOther];
}

- (void)updateRoomName:(NSString *)roomName {
    
    if (self.roomInfo == nil) {
        NSAssert(NO, @"Fetch room info ERROR");
        return;
    }
    
    [self updateRoomInfoWithName:roomName
                        password:self.roomInfo.roomPwd
                           tagId:self.roomInfo.tagId
              hasAnimationEffect:self.roomInfo.hasAnimationEffect
                    audioQuality:self.roomInfo.audioQuality
                       eventType:RoomUpdateEventTypeOther];
}

- (void)updateRoomInfo {
    
    if (self.roomInfo == nil) {
        NSAssert(NO, @"Fetch room info ERROR");
        return;
    }
    
    [self updateRoomInfoWithName:self.roomInfo.title
                        password:self.roomInfo.roomPwd
                           tagId:self.roomInfo.tagId
              hasAnimationEffect:self.roomInfo.hasAnimationEffect
                    audioQuality:self.roomInfo.audioQuality
                       eventType:RoomUpdateEventTypeOther];
}

/// 更新房间信息
- (void)updateRoomInfoWithName:(NSString *)roomName
                      password:(NSString *)roomPwd
                         tagId:(int)tagId
            hasAnimationEffect:(BOOL)hasAnimationEffect
                  audioQuality:(AudioQualityType)audioQuality
                     eventType:(RoomUpdateEventType)eventType {
    
    if (self.roomInfo == nil) {
        NSAssert(NO, @"Fetch room info ERROR");
        return;
    }
    
    NSDictionary *params = @{@"title": roomName ?: @"",
                             @"roomPwd": roomPwd ?: @"",
                             @"tagId": @(tagId),
                             };
    if (GetCore(ImRoomCoreV2).myMember.type == NIMChatroomMemberTypeCreator) {
        [GetCore(RoomCoreV2) updateGameRoomInfo:params
                                           type:UpdateRoomInfoTypeUser
                             hasAnimationEffect:hasAnimationEffect
                                   audioQuality:audioQuality
                                      eventType:eventType];
        
    } else if (GetCore(ImRoomCoreV2).myMember.type == NIMChatroomMemberTypeManager) {
        [GetCore(RoomCoreV2) updateGameRoomInfo:params
                                           type:UpdateRoomInfoTypeManager
                             hasAnimationEffect:hasAnimationEffect
                                   audioQuality:audioQuality
                                      eventType:eventType];
    }
}

#pragma mark - getters and setters
- (NSArray<NSArray<TTRoomSettingsConfig *> *> *)dataSourceArray {
    if (_dataSourceArray != nil) {
        return _dataSourceArray;
    }
    TTRoomSettingsConfig *hideRoom = [TTRoomSettingsConfig configType:TTRoomSettingsSourceHideRoom
                                                             name:@"隐藏房间"];
    TTRoomSettingsConfig *name = [TTRoomSettingsConfig configType:TTRoomSettingsSourceName
                                                             name:@"房间名"];
    TTRoomSettingsConfig *lock = [TTRoomSettingsConfig configType:TTRoomSettingsSourceLock
                                                             name:@"房间上锁"];
    TTRoomSettingsConfig *pwd = [TTRoomSettingsConfig configType:TTRoomSettingsSourcePwd
                                                            name:@"房间密码"];
    TTRoomSettingsConfig *tag = [TTRoomSettingsConfig configType:TTRoomSettingsSourceTag
                                                            name:@"房间标签"];
    TTRoomSettingsConfig *admin = [TTRoomSettingsConfig configType:TTRoomSettingsSourceAdmin
                                                              name:@"管理员"];
    TTRoomSettingsConfig *black = [TTRoomSettingsConfig configType:TTRoomSettingsSourceBlacklist
                                                              name:@"黑名单"];
    TTRoomSettingsConfig *bg = [TTRoomSettingsConfig configType:TTRoomSettingsSourceBackground
                                                           name:@"房间背景"];
    TTRoomSettingsConfig *gift = [TTRoomSettingsConfig configType:TTRoomSettingsSourceGiftEffect
                                                             name:@"房间礼物特效"];

    TTRoomSettingsConfig *male = [TTRoomSettingsConfig configType:TTRoomSettingsSourceMale
                                                             name:@"房间公屏"];
    TTRoomSettingsConfig *mike = [TTRoomSettingsConfig configType:TTRoomSettingsSourceQueueMike
                                                             name:@"排麦模式"];
    
    TTRoomSettingsConfig *pureModel = [TTRoomSettingsConfig configType:TTRoomSettingsSourcePureModel
                                                                  name:@"纯净模式"];
    TTRoomSettingsConfig *leaveModel = [TTRoomSettingsConfig configType:TTRoomSettingsSourceRoomLeaveModel
                                                                   name:@"离开模式"];
    TTRoomSettingsConfig *unlockRoomLimit = [TTRoomSettingsConfig configType:TTRoomSettingsSourceUnlockRoomLimit
                                                                  name:@"解除进房限制"];
    TTRoomSettingsConfig *unlockRoom = [TTRoomSettingsConfig configType:TTRoomSettingsSourceUnlockRoom
                                                                        name:@"解除进房上锁"];
    TTRoomSettingsConfig *closeRoom = [TTRoomSettingsConfig configType:TTRoomSettingsSourceCloseRoom
                                                                   name:@"关闭房间"];
    
    BOOL isSuperAdminNotDelegateSuperAdmin = self.myUserInfo.platformRole == XCUserInfoPlatformRoleSuperAdmin&&![[NSUserDefaults standardUserDefaults] boolForKey:@"deleteSuperAdmin"];
    
    if (self.roomInfo.type != RoomType_CP) {
        if (GetCore(ImRoomCoreV2).myMember.type == NIMChatroomMemberTypeCreator) {
            if (self.roomInfo.isPermitRoom != PermitRoomType_Personal) {
                if (self.roomInfo.isPermitRoom == PermitRoomType_Licnese) {
                    if (self.roomInfo.type == RoomType_Love) {
                        _dataSourceArray = @[
                            @[name, lock, pwd],
                            @[admin, black, bg, gift, male, mike]
                        ];
                    } else {
                        _dataSourceArray = @[
                            @[name, lock, pwd],
                            @[admin, black, bg, gift, male, mike, leaveModel]
                        ];
                    }
                } else {
                    _dataSourceArray = @[
                        @[name, lock, pwd],
                        @[admin, black, bg, gift, male, mike]
                    ];
                }
            } else {
                _dataSourceArray = @[
                    @[name, lock, pwd],
                    @[tag],
                    @[admin, black, bg, gift, male, mike]
                ];
            }
            
        } else if (isSuperAdminNotDelegateSuperAdmin) {
            if (self.roomInfo.roomPwd.length > 0) {
                _dataSourceArray = @[
                    @[hideRoom],
                    @[black],
                    @[unlockRoom],
                    @[closeRoom]
                ];
            } else {
                _dataSourceArray = @[
                    @[hideRoom],
                    @[black],
                    @[closeRoom]
                ];
            }
        } else {
            if (self.roomInfo.isPermitRoom != PermitRoomType_Personal) {
                _dataSourceArray = @[
                    @[name, lock, pwd],
                    @[black, gift, mike]
                ];
            } else {
                _dataSourceArray = @[
                    @[name, lock, pwd],
                    @[tag],
                    @[black, gift, mike]
                ];
            }
        }
    } else {
        if (GetCore(ImRoomCoreV2).myMember.type == NIMChatroomMemberTypeCreator) {
            if (self.roomInfo.isPermitRoom != PermitRoomType_Personal) {
                _dataSourceArray = @[
                    @[name],
                    @[admin, black, bg, gift, male]
                ];
            } else {
                _dataSourceArray = @[
                    @[name],
                    @[tag],
                    @[admin, black, bg, gift, male]
                ];
            }
        } else if (self.myUserInfo.platformRole == XCUserInfoPlatformRoleSuperAdmin) {
            if (self.roomInfo.limitType.length > 0) {
                _dataSourceArray = @[
                    @[hideRoom],
                    @[black],
                    @[unlockRoomLimit],
                    @[closeRoom]
                ];
            } else {
                _dataSourceArray = @[
                    @[hideRoom],
                    @[black],
                    @[closeRoom]
                ];
            }
            
        } else {
            if (self.roomInfo.isPermitRoom != PermitRoomType_Personal) {
                _dataSourceArray = @[
                    @[name],
                    @[black, gift, male]
                ];
            } else {
                _dataSourceArray = @[
                    @[name],
                    @[tag],
                    @[black, gift, male]
                ];
            }
        }
    }
    
    return _dataSourceArray;
}

- (UserInfo *)myUserInfo {
    
    return [GetCore(UserCore) getUserInfoInDB:GetCore(ImRoomCoreV2).myMember.userId.userIDValue];
}
@end
