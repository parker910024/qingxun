//
//  TTGuildGroupInfoViewController.m
//  TuTu
//
//  Created by lvjunhang on 2019/1/10.
//  Copyright © 2019年 YiZhuan. All rights reserved.
//

#import "TTGuildGroupInfoViewController.h"
#import "TTWKWebViewViewController.h"
#import "TTGuildMemberlistViewController.h"
#import "TTGuildGroupNoticeEditViewController.h"
#import "TTGuildViewController.h"

#import "TTGuildGroupContentCell.h"
#import "TTGuildGroupMultiLineTextCell.h"
#import "TTGuildGroupCollectionCell.h"

#import "TTGuildGroupManageConfig.h"

#import "TTRoomSettingsInputAlertView.h"

#import "XCTheme.h"
#import "UIViewController+EmptyDataView.h"
#import "XCMacros.h"
#import "XCHtmlUrl.h"
#import "TTGuildGroupManageConst.h"

#import "NSArray+Safe.h"
#import "UIImage+Utils.h"
#import "UIImageView+QiNiu.h"

#import "TTPopup.h"
#import "XCHUDTool.h"

#import "FileCore.h"
#import "FileCoreClient.h"
#import "GuildCore.h"
#import "GuildCoreClient.h"

#import <Masonry/Masonry.h>
#import <IQKeyboardManager/IQKeyboardManager.h>

static NSString *const kSeparateLineCellId = @"kSeparateLineCellId";
static NSString *const kContentCellId = @"kContentCellId";
static NSString *const kMultiLineCellId = @"kMultiLineCellId";
static NSString *const kCollectionCellId = @"kCollectionCellId";

@interface TTGuildGroupInfoViewController ()
<FileCoreClient,
GuildCoreClient,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate
>

@property (nonatomic, strong) UIButton *quitButton;

@property (nonatomic, strong) NSArray<TTGuildGroupManageConfig *> *dataSourceArray;

@property (nonatomic, strong) GuildHallGroupInfo *groupInfo;//群信息

@property (nonatomic, strong) GuildHallGroupInfo *tmpUpdateGroupInfo;//更新临时保存群信息

@end

@implementation TTGuildGroupInfoViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"群资料";
    
    AddCoreClient(FileCoreClient, self);
    AddCoreClient(GuildCoreClient, self);
    
    [self initView];
    
    [self pullDownRefresh:1];
}

- (void)dealloc {
    RemoveCoreClientAll(self);
}

#pragma mark - Override
- (void)pullDownRefresh:(int)page {
    [XCHUDTool showGIFLoadingInView:self.view];
    [GetCore(GuildCore) requestGuildGroupInfoFetchWithTid:self.tid];
}

/**
 点击失败占位图时的重载方法
 */
- (void)reloadDataWhenLoadFail {
    [self pullDownRefresh:1];
}

#pragma mark - system protocols
#pragma mark UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TTGuildGroupManageConfig *config = self.dataSourceArray[indexPath.row];
    switch (config.type) {
        case TTGuildGroupManageTypeAvatar:
        case TTGuildGroupManageTypeName:
        case TTGuildGroupManageTypeMemberTitle:
        case TTGuildGroupManageTypeManagerTitle:
        case TTGuildGroupManageTypeNoticeTitle:
        case TTGuildGroupManageTypeMuteSetting:
        case TTGuildGroupManageTypeMsgDoNotDisturb:
        case TTGuildGroupManageTypeClassifyDescribe: {
            TTGuildGroupContentCell *cell = [tableView dequeueReusableCellWithIdentifier:kContentCellId forIndexPath:indexPath];
            cell.config = config;
            
            if (config.type==TTGuildGroupManageTypeAvatar && self.groupInfo.icon.length>0) {
                [cell.avatarImageView qn_setImageImageWithUrl:self.groupInfo.icon placeholderImage:[XCTheme defaultTheme].default_avatar type:ImageTypeHomePageItem];
            }
            
            if (config.type==TTGuildGroupManageTypeName) {
                cell.contentLabel.text = self.groupInfo.name;
            }
            
            if (config.type == TTGuildGroupManageTypeClassifyDescribe) {
                cell.contentLabel.text = GuildHallGroupTypeName(self.groupInfo.type);
            }
            
            if (config.type == TTGuildGroupManageTypeMsgDoNotDisturb) {
                cell.selectSwitch.on = self.groupInfo.promptStatus;
                
                @weakify(self)
                [cell setSwitchClickBlock:^(BOOL isOn) {
                    @strongify(self)
                    self.tmpUpdateGroupInfo = [GuildHallGroupInfo yy_modelWithJSON:[self.groupInfo model2dictionary]];
                    self.tmpUpdateGroupInfo.promptStatus = isOn;
                    
                    [XCHUDTool showGIFLoadingInView:self.view];
                    [GetCore(GuildCore) requestGuildGroupPromptSettingWithChatId:self.groupInfo.chatId promptStatus:isOn];
                }];
            }
            
            if (config.type == TTGuildGroupManageTypeNoticeTitle || config.type == TTGuildGroupManageTypeMuteSetting) {
                cell.contentLabel.text = @"";
            }
            
            return cell;
        }
        case TTGuildGroupManageTypeMemberList:
        case TTGuildGroupManageTypeManagerList: {
            TTGuildGroupCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:kCollectionCellId forIndexPath:indexPath];
            cell.backgroundColor = config.nameColor;
            cell.separateLine.hidden = !config.isShowUnderLine;
            
            if (config.type == TTGuildGroupManageTypeMemberList) {
                cell.dataModelArray = self.groupInfo.memberAvatars;
            } else {
                cell.dataModelArray = self.groupInfo.managerAvatars;
            }
            return cell;
        }
        case TTGuildGroupManageTypeNotice: {
            TTGuildGroupMultiLineTextCell *cell = [tableView dequeueReusableCellWithIdentifier:kMultiLineCellId forIndexPath:indexPath];
            cell.backgroundColor = UIColor.whiteColor;
            cell.separateLine.hidden = !config.isShowUnderLine;
            cell.contentLabel.text = self.groupInfo.notice.length == 0 ? @"未设置" : self.groupInfo.notice;
            return cell;
        }
        default: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSeparateLineCellId forIndexPath:indexPath];
            cell.backgroundColor = config.nameColor;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TTGuildGroupManageConfig *config = self.dataSourceArray[indexPath.row];
    switch (config.type) {
        case TTGuildGroupManageTypeAvatar:
            return 74;
        case TTGuildGroupManageTypeName:
        case TTGuildGroupManageTypeClassifyDescribe:
            return 54;
        case TTGuildGroupManageTypeNoticeTitle:
            return 20;
        case TTGuildGroupManageTypeSeparateLine:
            return 10;
        case TTGuildGroupManageTypeMemberList:
        case TTGuildGroupManageTypeManagerList: {
            if (self.groupInfo.memberAvatars.count == 0) {
                return CGFLOAT_MIN;
            }
            
            NSInteger line = config.type == TTGuildGroupManageTypeManagerList ? 1 : 2;
            CGFloat height = (TTGuildGroupCollectionCellLenth+TTGuildGroupCollectionCellTopMargin+TTGuildGroupCollectionCellBottomMargin)*line;
            return height;
        }
        case TTGuildGroupManageTypeCreateDescribe:
        case TTGuildGroupManageTypeNotice:
            return UITableViewAutomaticDimension;
            
        default:
            return 54;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BOOL isOwner = self.groupInfo.role == GuildHallGroupAuthorityOwner;
    BOOL isManager = self.groupInfo.role == GuildHallGroupAuthorityManager;

    TTGuildGroupManageConfig *config = self.dataSourceArray[indexPath.row];
    switch (config.type) {
        case TTGuildGroupManageTypeAvatar: {
            if (!isOwner) {
                return;
            }
            
            [self photoPicker];
        }
            break;
        case TTGuildGroupManageTypeName: {
            if (!isOwner) {
                return;
            }
            
            TTRoomSettingsInputAlertView *alert = [[TTRoomSettingsInputAlertView alloc] init];
            alert.title = @"群名称";
            alert.placeholder = @"请输入群名称";
            alert.content = self.groupInfo.name;
            alert.maxCount = 15;

            @weakify(self)
            [alert showAlertWithCompletion:^(NSString * _Nonnull content) {
                @strongify(self)
                [self updateName:content];
            } dismiss:^{
            }];
        }
            break;
        case TTGuildGroupManageTypeMemberTitle: {
            
            TTGuildMemberlistViewController *vc = [[TTGuildMemberlistViewController alloc] init];
            vc.hallInfo = GetCore(GuildCore).hallInfo;
            vc.listType = GuildHallListTypeGroupNormal;
            vc.chatID = self.groupInfo.chatId;
            vc.groupChatInfo = self.groupInfo; // 群聊信息
            
            @weakify(self)
            vc.refreshHander = ^{
                @strongify(self)
                [GetCore(GuildCore) requestGuildGroupInfoFetchWithTid:self.tid];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case TTGuildGroupManageTypeManagerTitle: {
            if (!isOwner) {
                return;
            }
            
            TTGuildMemberlistViewController *vc = [[TTGuildMemberlistViewController alloc] init];
            vc.hallInfo = GetCore(GuildCore).hallInfo;
            vc.chatID = self.groupInfo.chatId;
            vc.listType = GuildHallListTypeGroupManager;
            @weakify(self)
            vc.refreshHander = ^{
                @strongify(self)
                [GetCore(GuildCore) requestGuildGroupInfoFetchWithTid:self.tid];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case TTGuildGroupManageTypeMuteSetting: {
            if (!isOwner && !isManager) {
                return;
            }
            
            TTGuildMemberlistViewController *vc = [[TTGuildMemberlistViewController alloc] init];
            vc.hallInfo = GetCore(GuildCore).hallInfo;
            vc.chatID = self.groupInfo.chatId;
            vc.listType = GuildHallListTypeMute;
            vc.groupChatInfo = self.groupInfo;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case TTGuildGroupManageTypeNoticeTitle: {
            if (!isOwner && !isManager) {
                return;
            }
            
            TTGuildGroupNoticeEditViewController *vc = [[TTGuildGroupNoticeEditViewController alloc] init];
            vc.groupInfo = self.groupInfo;
            
            @weakify(self)
            [vc setEditCompletion:^(NSString *notice) {
                @strongify(self)
                self.groupInfo.notice = notice;
                [self reloadRowWithType:TTGuildGroupManageTypeNotice];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
    
}

#pragma mark - core protocols
#pragma mark GuildCoreClient
/**
 获取群聊资料
 
 @param data 群聊资料
 @param code 错误码
 @param msg 错误信息
 */
- (void)responseGuildGroupInfoFetch:(GuildHallGroupInfo *)data errorCode:(NSNumber *)code msg:(NSString *)msg {
    
    [XCHUDTool hideHUDInView:self.view];
    
    if (data) {
        [self removeEmptyDataView];
        
        self.groupInfo = data;
        self.tmpUpdateGroupInfo = data;
        
        [self configDataSource];
        return;
    }

    [XCHUDTool showSuccessWithMessage:msg ?: @"请求出错了"];
    [self showLoadFailViewWithTitle:msg image:[UIImage imageNamed:@"common_noData_empty"]];
}

/**
 更新群聊资料
 
 @param isSuccess 是否成功，出现错误时通过 code 和 msg 返回
 @param code 错误码
 @param msg 错误信息
 */
- (void)responseGuildGroupInfoUpdate:(BOOL)isSuccess errorCode:(NSNumber *)code msg:(NSString *)msg {
    [XCHUDTool hideHUDInView:self.view];
    
    if (isSuccess) {
        [XCHUDTool showSuccessWithMessage:@"设置成功" inView:self.view];
        
        self.groupInfo = [GuildHallGroupInfo yy_modelWithJSON:[self.tmpUpdateGroupInfo model2dictionary]];
        [self.tableView reloadData];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:TTGuildGroupManageDidUpdateGroupNoti object:nil];
        return;
    }
    
    [XCHUDTool showErrorWithMessage:msg ?: @"设置失败" inView:self.view];
}

/**
 解散群聊
 
 @param isSuccess 是否成功，出现错误时通过 code 和 msg 返回
 @param code 错误码
 @param msg 错误信息
 */
- (void)responseGuildGroupRemove:(BOOL)isSuccess errorCode:(NSNumber *)code msg:(NSString *)msg {
    [XCHUDTool hideHUDInView:self.view];

    if (!isSuccess) {
        msg = msg ?: @"操作失败";
        [XCHUDTool showErrorWithMessage:msg inView:self.view];
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TTGuildGroupManageDidRemoveGroupNoti object:nil];
    
    msg = @"已解散群聊";
    [XCHUDTool showSuccessWithMessage:msg inView:self.view];
    
    @weakify(self)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self)
        [self popBlack];
    });
}

/**
 离开群聊
 
 @param isSuccess 是否成功，出现错误时通过 code 和 msg 返回
 @param code 错误码
 @param msg 错误信息
 */
- (void)responseGuildGroupQuit:(BOOL)isSuccess errorCode:(NSNumber *)code msg:(NSString *)msg {
    [XCHUDTool hideHUDInView:self.view];

    if (!isSuccess) {
        msg = msg ?: @"操作失败";
        [XCHUDTool showErrorWithMessage:msg inView:self.view];
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TTGuildGroupManageDidQuitGroupNoti object:nil];
    
    msg = @"已退出群聊";
    [XCHUDTool showSuccessWithMessage:msg inView:self.view];
    @weakify(self)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self)
        [self popBlack];
    });
}

- (void)responseGuildGroupPromptSetting:(BOOL)isSuccess errorCode:(NSNumber *)code msg:(NSString *)msg {
    [XCHUDTool hideHUDInView:self.view];
    
    if (!isSuccess) {
        msg = msg ?: @"操作失败";
        [XCHUDTool showErrorWithMessage:msg inView:self.view];
        [self reloadRowWithType:TTGuildGroupManageTypeMsgDoNotDisturb];
        return;
    }
    
    /// 无需刷新
    self.groupInfo = [GuildHallGroupInfo yy_modelWithJSON:[self.tmpUpdateGroupInfo model2dictionary]];
}

#pragma mark FileCoreClient
- (void)didUploadGroupIconImageSuccessUseQiNiu:(NSString *)key {
    [XCHUDTool hideHUDInView:self.view];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@?imageslim", keyWithType(KeyType_QiNiuBaseURL, NO), key];
    [self updateAvatar:url];
}

- (void)didUploadGroupIconImageFailUseQiNiu:(NSString *)message {
    message = message ?: @"上传图片出错";
    [XCHUDTool showErrorWithMessage:message inView:self.view];
}

#pragma mark - event response
- (void)quitButtonDidTapped:(UIButton *)sender {
    BOOL isOwner = self.groupInfo.role == GuildHallGroupAuthorityOwner;
    BOOL isManager = self.groupInfo.role == GuildHallGroupAuthorityManager;
    NSString *action = isOwner ? @"解散" : @"退出";
    NSString *leaveWarningMsg;
    
    if (isOwner) {
        leaveWarningMsg = @"解散群将会清除所有群聊信息，确认解散吗？";
    } else if (isManager) {
        leaveWarningMsg = @"退出群将会清除管理权限和群聊信息，确认退出吗？";
    } else {
        leaveWarningMsg = @"退出群将会清除群聊信息，确认退出吗？";
    }
    
    @weakify(self)
    [TTPopup alertWithMessage:leaveWarningMsg confirmHandler:^{
        @strongify(self)
        if (isOwner) {
            [self removeGroup];
        } else {
            [self quitGroup];
        }
    } cancelHandler:^{
    }];
}

#pragma mark - private method
- (void)initView {
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.view.backgroundColor = self.tableView.backgroundColor;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 30)];
    self.tableView.estimatedRowHeight = 54;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:kSeparateLineCellId];
    [self.tableView registerClass:TTGuildGroupContentCell.class forCellReuseIdentifier:kContentCellId];
    [self.tableView registerClass:TTGuildGroupMultiLineTextCell.class forCellReuseIdentifier:kMultiLineCellId];
    [self.tableView registerClass:TTGuildGroupCollectionCell.class forCellReuseIdentifier:kCollectionCellId];
    
    [self.view addSubview:self.quitButton];
    
    @weakify(self)
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        if (@available(iOS 11.0, *)) {
            make.top.left.right.mas_equalTo(self.view.mas_safeAreaLayoutGuide);
        } else {
            make.top.left.right.mas_equalTo(self.view);
        }
    }];
    
    [self.quitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.top.mas_equalTo(self.tableView.mas_bottom);
        make.left.right.mas_equalTo(self.view).inset(15);
        make.height.mas_equalTo(40);
        
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuide).offset(-22);
        } else {
            make.bottom.mas_equalTo(self.view).offset(-22);
        }
    }];
}

- (void)reloadRowWithType:(TTGuildGroupManageType)type {
    
    __block NSInteger row = -1;
    [self.dataSourceArray enumerateObjectsUsingBlock:^(TTGuildGroupManageConfig * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj.type == type) {
            row = idx;
            *stop = YES;
        }
    }];
    
    if (row != -1) {
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        [self.tableView reloadData];
    }
}

/**
 返回 TTGuildViewController 页面，没有则返回根页面
 */
- (void)popBlack {
    
    RemoveCoreClientAll(self);
    
    __block UIViewController *findVC = nil;
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:TTGuildViewController.class]) {
            findVC = obj;
            *stop = YES;
        }
    }];
    
    if (findVC) {
        [self.navigationController popToViewController:findVC animated:YES];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)configDataSource {
    if (self.groupInfo == nil) {
        return;
    }
    
    BOOL isOwner = self.groupInfo.role == GuildHallGroupAuthorityOwner;
    BOOL isManager = self.groupInfo.role == GuildHallGroupAuthorityManager;
    NSString *notice = self.groupInfo.notice.length > 0 ? self.groupInfo.notice : @"暂无公告";
    NSString *buttonTitle = isOwner ? @"解散群" : @"退出群";
    
    self.quitButton.hidden = NO;
    [self.quitButton setTitle:buttonTitle forState:UIControlStateNormal];
    
    TTGuildGroupManageConfig *classify =
    [TTGuildGroupManageConfig configType:TTGuildGroupManageTypeClassifyDescribe
                                    name:@"群分类："
                               nameColor:[XCTheme getTTDeepGrayTextColor]
                           showUnderLine:YES
                               showArrow:NO];
    TTGuildGroupManageConfig *avatar =
    [TTGuildGroupManageConfig configType:TTGuildGroupManageTypeAvatar
                                    name:@"群头像："
                               nameColor:[XCTheme getTTDeepGrayTextColor]
                           showUnderLine:YES
                               showArrow:isOwner];
    TTGuildGroupManageConfig *name =
    [TTGuildGroupManageConfig configType:TTGuildGroupManageTypeName
                                    name:@"群名称："
                               nameColor:[XCTheme getTTDeepGrayTextColor]
                           showUnderLine:NO
                               showArrow:isOwner];
    TTGuildGroupManageConfig *separateLine =
    [TTGuildGroupManageConfig configType:TTGuildGroupManageTypeSeparateLine
                                    name:@"分割线"
                               nameColor:UIColorFromRGB(0xf5f5f5)
                           showUnderLine:NO
                               showArrow:NO];
    TTGuildGroupManageConfig *memberTitle =
    [TTGuildGroupManageConfig configType:TTGuildGroupManageTypeMemberTitle
                                    name:@"群成员"
                               nameColor:[XCTheme getTTMainTextColor]
                           showUnderLine:NO
                               showArrow:YES];
    TTGuildGroupManageConfig *memberList =
    [TTGuildGroupManageConfig configType:TTGuildGroupManageTypeMemberList
                                    name:@"群成员列表"
                               nameColor:[XCTheme getTTMainTextColor]
                           showUnderLine:YES
                               showArrow:YES];
    TTGuildGroupManageConfig *manageTitle =
    [TTGuildGroupManageConfig configType:TTGuildGroupManageTypeManagerTitle
                                    name:@"群管理"
                               nameColor:[XCTheme getTTMainTextColor]
                           showUnderLine:NO
                               showArrow:isOwner];
    TTGuildGroupManageConfig *manageList =
    [TTGuildGroupManageConfig configType:TTGuildGroupManageTypeManagerList
                                    name:@"群管理列表"
                               nameColor:[XCTheme getTTMainTextColor]
                           showUnderLine:NO
                               showArrow:NO];
    TTGuildGroupManageConfig *placeholderLine =
    [TTGuildGroupManageConfig configType:TTGuildGroupManageTypeSeparateLine
                                    name:@"群公告上面的补偿"
                               nameColor:UIColor.whiteColor
                           showUnderLine:NO
                               showArrow:NO];
    TTGuildGroupManageConfig *noticeTitle =
    [TTGuildGroupManageConfig configType:TTGuildGroupManageTypeNoticeTitle
                                    name:@"群公告"
                               nameColor:[XCTheme getTTMainTextColor]
                           showUnderLine:NO
                               showArrow:isOwner || isManager];
    TTGuildGroupManageConfig *noticeContent =
    [TTGuildGroupManageConfig configType:TTGuildGroupManageTypeNotice
                                    name:notice
                               nameColor:[XCTheme getTTDeepGrayTextColor]
                           showUnderLine:YES
                               showArrow:NO];
    TTGuildGroupManageConfig *mute =
    [TTGuildGroupManageConfig configType:TTGuildGroupManageTypeMuteSetting
                                    name:@"设置禁言"
                               nameColor:[XCTheme getTTMainTextColor]
                           showUnderLine:YES
                               showArrow:YES];
    TTGuildGroupManageConfig *msgDoNotDisturb =
    [TTGuildGroupManageConfig configType:TTGuildGroupManageTypeMsgDoNotDisturb
                                    name:@"消息免打扰"
                               nameColor:[XCTheme getTTMainTextColor]
                           showUnderLine:NO
                               showArrow:NO];
    
    NSMutableArray *mArray = [NSMutableArray arrayWithArray:@[classify, avatar, name, separateLine, memberTitle, memberList, manageTitle, manageList, separateLine, placeholderLine, noticeTitle, noticeContent]];
    
    if (isOwner || isManager) {
        [mArray addObject:mute];
    }
    
    [mArray addObject:msgDoNotDisturb];
    
    self.dataSourceArray = [mArray copy];
    [self.tableView reloadData];
}

- (void)updateName:(NSString *)name {
    if (name.length <= 0) {
        [XCHUDTool showErrorWithMessage:@"群名称不能为空" inView:self.view];
        return;
    }
    
    self.tmpUpdateGroupInfo = [GuildHallGroupInfo yy_modelWithJSON:[self.groupInfo model2dictionary]];
    self.tmpUpdateGroupInfo.name = name;
    
    [XCHUDTool showGIFLoadingInView:self.view];
    [GetCore(GuildCore) requestGuildGroupInfoUpdateWithChatId:self.groupInfo.chatId
                                                         icon:nil
                                                         name:name
                                                       notice:nil];
}

- (void)updateAvatar:(NSString *)avatar {
    if (avatar.length <= 0) {

        [XCHUDTool showErrorWithMessage:@"头像上传出错" inView:self.view];
        return;
    }
    
    self.tmpUpdateGroupInfo = [GuildHallGroupInfo yy_modelWithJSON:[self.groupInfo model2dictionary]];
    self.tmpUpdateGroupInfo.icon = avatar;
    
    [XCHUDTool showGIFLoadingInView:self.view];
    [GetCore(GuildCore) requestGuildGroupInfoUpdateWithChatId:self.groupInfo.chatId
                                                         icon:avatar
                                                         name:nil
                                                       notice:nil];
}

#pragma mark Group Handle Request
- (void)removeGroup {
    [XCHUDTool showGIFLoadingInView:self.view];
    [GetCore(GuildCore) requestGuildGroupRemoveWithChatId:self.groupInfo.chatId];
}

- (void)quitGroup {
    [XCHUDTool showGIFLoadingInView:self.view];
    [GetCore(GuildCore) requestGuildGroupQuitWithChatId:self.groupInfo.chatId];
}

#pragma mark 选择图片
- (void)photoPicker {
    
    @weakify(self);
    TTActionSheetConfig *cameraConfig = [TTActionSheetConfig normalTitle:@"拍照上传" clickAction:^{
        [YYUtility checkCameraAvailable:^{
            @strongify(self);
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.allowsEditing = YES;
            [self presentViewController:imagePicker animated:YES completion:NULL];
        } denied:^{
            @strongify(self);
            [self showNotPhoto:@"相机不可用" content:@"相机权限受限,点击确定去系统设置"];
        } restriction:^{
            @strongify(self);
            [self showNotPhoto:@"相机不可用" content:@"相册权限受限,点击确定去系统设置"];
        }];
    }];
    
    TTActionSheetConfig *photoLibrayConfig = [TTActionSheetConfig normalTitle:@"本地相册" clickAction:^{
        [YYUtility checkAssetsLibrayAvailable:^{
            @strongify(self);
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.modalPresentationCapturesStatusBarAppearance = YES;
            imagePicker.delegate = self;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.allowsEditing = YES;
            [self presentViewController:imagePicker animated:YES completion:NULL];
        } denied:^{
            @strongify(self);
            [self showNotPhoto:@"相册不可用" content:@"相册权限受限,点击确定去系统设置"];
        } restriction:^{
            @strongify(self);
            [self showNotPhoto:@"相册不可用" content:@"相册权限受限,点击确定去系统设置"];
        }];
    }];
    
    [TTPopup actionSheetWithItems:@[cameraConfig, photoLibrayConfig]];
}

- (void)showNotPhoto:(NSString *)title content:(NSString *)content {
    
    TTAlertConfig *config = [[TTAlertConfig alloc] init];
    config.title = title;
    config.message = content;
    
    [TTPopup alertWithConfig:config confirmHandler:^{
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    } cancelHandler:^{
    }];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    @KWeakify(self);
    [picker dismissViewControllerAnimated:YES completion:^{
        @KStrongify(self);
        UIImage *selectedPhoto = [info objectForKey:UIImagePickerControllerEditedImage];
        if (selectedPhoto) {
            if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
                UIImageWriteToSavedPhotosAlbum(selectedPhoto, nil, nil, nil);
            }
            
            selectedPhoto = [UIImage fixOrientation:selectedPhoto];
            [GetCore(FileCore) qiNiuUploadImage:selectedPhoto uploadType:UploadImageTypeGroupIcon];
            
            [XCHUDTool showGIFLoadingInView:self.view];
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - getters and setters
- (NSArray<TTGuildGroupManageConfig *> *)dataSourceArray {
    if (_dataSourceArray == nil) {
        _dataSourceArray = [NSArray array];
    }
    return _dataSourceArray;
}

- (UIButton *)quitButton {
    if (_quitButton == nil) {
        _quitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_quitButton setTitle:@"解散群" forState:UIControlStateNormal];
        [_quitButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _quitButton.backgroundColor = UIColorFromRGB(0xFF3852);
        _quitButton.layer.cornerRadius = 20;
        _quitButton.layer.masksToBounds = YES;
        [_quitButton addTarget:self action:@selector(quitButtonDidTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        _quitButton.hidden = YES;
    }
    return _quitButton;
}
@end
