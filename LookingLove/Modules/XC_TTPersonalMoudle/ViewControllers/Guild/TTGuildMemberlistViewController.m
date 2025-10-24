//
//  TTGuildMemberlistViewController.m
//  TuTu
//
//  Created by lee on 2019/1/8.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTGuildMemberlistViewController.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"
#import "XCHUDTool.h"
#import "UIView+XCToast.h"

//vc
#import "TTKeeperListViewController.h"
#import "TTFamilySearchViewController.h"
#import "XCMediator+TTHomeMoudle.h"
#import "TTMineContainViewController.h"
#import "TTGroupChatMemberAddViewController.h"
// view
#import "TTMemberListCell.h"
#import "TTGuildMemberHeaderSectionView.h"
#import "TTGuildAddMemberSheetView.h"
#import "TTGuildAddMemberSecretCodeView.h"

// tools
#import "TTItemMenuView.h"
#import "TTItemsMenuConfig.h"
#import "GuildHallGroupInfo.h"
#import "NSDate+Util.h"
#import "NSDate+TimeCategory.h"
#import <YYCache/YYCache.h>
#import "TTPopup.h"

// core
#import "GuildCore.h"
#import "GuildCoreClient.h"
#import "AuthCore.h"
#import "AuthCoreClient.h"
#import "UserCore.h"
#import "UserCoreClient.h"
#import "ShareCore.h"
#import "ShareCoreClient.h"
// model
#import "GuildEmojiCode.h"
// 统计工具
#import "TTStatisticsService.h"

static CGFloat const kSheetViewHeight = 243;
static CGFloat const kSecretCodeViewHeight = 380;
static NSString *const kCacheEmojiCodeName = @"kCacheEmojiCodeName";
static NSString *const kEmojiCodeCacheKey = @"kEmojiCodeCacheKey";
static NSString *const kEmojiCodeUserIDKey = @"kEmojiCodeUserIDKey";

@interface TTGuildMemberlistViewController ()<UITableViewDelegate, UITableViewDataSource, TTItemMenuViewDelegate, GuildCoreClient, ShareCoreClient, TTMemberListCellDelegate, TTGuildAddMemberSheetViewDelegate, TTGuildAddMemberSecretCodeViewDelegate>

//@property (nonatomic, strong) UITableView *tableView;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray *dataArray;
/** 更多菜单 */
@property (nonatomic, strong) TTItemMenuView *menuView;
/** 头部view */
@property (nonatomic, strong) TTGuildMemberHeaderSectionView *sectionHeadView;
/** 当前的 index */
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
/** 被选中的用户 */
@property (nonatomic, strong) NSMutableArray<UserInfo *> *selectingUserArray;
/** 当前用户信息 */
@property (nonatomic, strong) UserInfo *currentInfo;
/** 授权数据 */
@property (nonatomic, strong) NSArray<GuildHallManagerInfo *> *authArray;
/** 是否是群聊 */
@property (nonatomic, assign) BOOL isGroupChat;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) GuildChatGroupAllMemberResponse *chatGroupAllMemberResponse;
@property (nonatomic, strong) NSMutableArray *managerArray;//管理员数组

/** 平台按钮view */
@property (nonatomic, strong) TTGuildAddMemberSheetView *guildAddSheetView;
/** 暗号显示view */
@property (nonatomic, strong) TTGuildAddMemberSecretCodeView *guildSecretCodeView;
@property (nonatomic, strong) GuildEmojiCode *shareEmojiCode;
@end

@implementation TTGuildMemberlistViewController

- (void)dealloc {
    RemoveCoreClientAll(self);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.listType == GuildHallListTypeGroupNormal) {
        self.page = 1;
        [self requestAllMemberList];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // addCore
    AddCoreClient(GuildCoreClient, self);
    AddCoreClient(ShareCoreClient, self);
    
    // method
    [self initViews];
    [self initConstraints];
//    [self requestAllMemberList];
    [self setupNavigationTitle];
    
    // request
    @weakify(self);
    [GetCore(UserCore) getUserInfo:[[GetCore(AuthCore) getUid] longLongValue] refresh:YES success:^(UserInfo *info) {
        @strongify(self);
        self.currentInfo = info;
        if (info.hallId > 0) {
            [self requestKeeperManagerAuthList];
        }
    } failure:nil];
    
    self.page = 1;
    self.tableView.tableViewHeightOnScreen = 1;
    [self setupRefreshTarget:self.tableView With:RefreshTypeHeaderAndFooter];
    [self pullDownRefresh:self.page];
}

- (void)pullDownRefresh:(int)page {
    self.page = 1;
    [self requestAllMemberList];
}

- (void)pullUpRefresh:(int)page lastPage:(BOOL)isLastPage {
    self.page += 1;
    [self requestAllMemberList];
}
#pragma mark -
#pragma mark lifeCycle
/** 设置导航栏 */
- (void)setupNavigationTitle {
    switch (self.listType) {
        case GuildHallListTypeGroupNormal:
        {
            self.navigationItem.title = @"查看群成员";
            if (self.groupChatInfo.role != GuildHallGroupAuthorityMember) {
                [self addNavigationItemWithImageNames:@[@"guild_group_item_remove", @"guild_group_item_add"] isLeft:NO target:self action:@selector(onRightItemClickHandler:) tags:@[@1005, @1006]];
            }
        }
            break;
        case GuildHallListTypeGroupMember:
        {
            self.navigationItem.title = @"选择群成员";
            [self addNavigationItemWithTitles:@[@"确定"] titleColor:[XCTheme getTTMainColor] isLeft:NO target:self action:@selector(onRightItemClickHandler:) tags:@[@1003]];
        }
            break;
        case GuildHallListTypeGroupManager:
        {
            self.navigationItem.title = @"选择群管理";
        }
            break;
        case GuildHallListTypeMute:
        {
            self.navigationItem.title = @"设置禁言";
        }
            break;
        case GuildHallListTypeKeeper:
        {
            self.navigationItem.title = @"增减高管";
        }
            break;
        case GuildHallListTypeRemoveMember:
            break;
        case GuildHallListTypeMember:
        {
            self.navigationItem.title = @"成员列表";
            [self addNavigationItemWithImageNames:@[@"guild_memberList_rightItem_more", @"guild_memberList_rightItem_search"] isLeft:NO target:self action:@selector(onRightItemClickHandler:) tags:@[@1001, @1002]];
        }
            break;
        case GuildHallListTypeMutableMember:
        {
            self.navigationItem.title = @"选择群成员";
            [self addNavigationItemWithTitles:@[@"确定"] titleColor:[XCTheme getTTMainColor] isLeft:NO target:self action:@selector(onRightItemClickHandler:) tags:@[@1003]];
        }
            break;
            
        default:
            break;
    }
}
/** 设置多个items */
- (void)setupNavigationItems {
    
    TTItemMenuItem *addMemberItem = [TTItemMenuItem creatWithTitle:@"添加成员" iconName:@"guild_moreItems_add" titleFont:[UIFont systemFontOfSize:15] titleColor:[UIColor whiteColor]];
    TTItemMenuItem *removeMemberItem = [TTItemMenuItem creatWithTitle:@"移除成员" iconName:@"guild_moreItems_remove" titleFont:[UIFont systemFontOfSize:15] titleColor:[UIColor whiteColor]];
    TTItemMenuItem *managerMemberItem = [TTItemMenuItem creatWithTitle:@"高管设置" iconName:@"guild_moreItems_master" titleFont:[UIFont systemFontOfSize:15] titleColor:[UIColor whiteColor]];
    TTItemMenuItem *exitItem = [TTItemMenuItem creatWithTitle:@"退出" iconName:@"guild_moreItems_quit" titleFont:[UIFont systemFontOfSize:15] titleColor:[UIColor whiteColor]];
    
    TTItemsMenuConfig *config = [TTItemsMenuConfig creatMenuConfigWithItemHeight:44 menuWidth:130 separatorInset:UIEdgeInsetsMake(0, 0, 0, 0) separatorColor:[UIColor colorWithWhite:1 alpha:0] backgroudColor:UIColorFromRGB(0x4C4C4C)];

    NSMutableArray<TTItemMenuItem *> *items = [NSMutableArray array];
    [self.authArray enumerateObjectsUsingBlock:^(GuildHallManagerInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.status == 1) {
            if ([obj.code isEqualToString:@"member_join_manager"]) {
                [items addObject:addMemberItem];
            }
            if ([obj.code isEqualToString:@"member_exit_manager"]) {
                [items addObject:removeMemberItem];
            }
            if ([obj.code isEqualToString:@"hall_manager_set"]) {
                [items addObject:managerMemberItem];
            }
            if ([obj.name isEqualToString:@"退出"]) {
                [items addObject:exitItem];
            }
        }
    }];
    
    TTItemMenuView *menuView = [[TTItemMenuView alloc] initWithFrame:CGRectZero withConfig:config items:items.copy];
    menuView.delegate = self;
    menuView.isShowMask = NO;
    self.menuView = menuView;
    
}
- (void)initViews {
//    [self.view addSubview:self.tableView];
    self.tableView.rowHeight = 66.f;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:[TTMemberListCell class] forCellReuseIdentifier:kMemberListCellConst];
}

- (void)initConstraints {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(kNavigationHeight);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
}

#pragma mark -
#pragma mark TTItemMenuViewDelegate
- (void)menuView:(TTItemMenuView *)addMenuView didSelectedItem:(TTItemMenuItem *)item {
    if ([item.title isEqualToString:@"添加成员"]) {
        // 添加成员
        [self addMemberToHall];
    } else if ([item.title isEqualToString:@"移除成员"]) {
        // 移除成员
        [self removeMemberInHall];
    } else if ([item.title isEqualToString:@"高管设置"]) {
        // 高管设置
        [self setupKeeperManagerToHall];
    } else if ([item.title isEqualToString:@"退出"]) {
        // 退出
        [self quitHall];
    }
}


#pragma mark -
#pragma mark - sheetViewDelegate
- (void)didClickCancelAction {
    [TTPopup dismiss];
}

- (void)didClickSheetViewItemAction:(TTSheetViewClickType)indexType {
    
    if (indexType != TTSheetViewClickTypeTuTu) {
        // 如果是兔兔ID 添加，就和往常一样，直接搜索ID 添加。
        // 否则就是发起请求，请求模厅按钮，然后分享出去
        self.guildSecretCodeView.shareType = (TTGuildMemberCodeShareType)indexType;
        if ([self isNeedRequestNewEmojiCode]) {
            // 如果缓存中的已经过期，就请求新的
            [GetCore(GuildCore) requestGuildEmojiCode];
        } else {
            // 从缓存中获取
            [self showGuildSecretCodeViewWithEmojiCode:self.shareEmojiCode];
        }
        
        // 统计添加成员点击
        if (indexType == TTSheetViewClickTypeWX) {
            [TTStatisticsService trackEvent:TTStatisticsServiceHallAddMemberWXClick eventDescribe:@"添加成员-微信导入"];
        } else {
            [TTStatisticsService trackEvent:TTStatisticsServiceHallAddMemberQQClick eventDescribe:@"添加成员-QQ导入"];
        }
        return;
    }
    
    // 兔兔id 添加
    UIViewController *vc = [[XCMediator sharedInstance] ttHomeMoudleBridge_inviteSearchRoomController];
    [self.navigationController pushViewController:vc animated:YES];
    
    // 统计
    [TTStatisticsService trackEvent:TTStatisticsServiceHallAddMemberIDClick eventDescribe:@"添加成员-兔兔ID"];
   
}

- (void)onClickCancelBtnAction {
    [TTPopup dismiss];
}

- (void)onClickShareBtnWithType:(TTGuildMemberCodeShareType)shareType {
    switch (shareType) {
        case TTGuildMemberCodeShareTypeWX:
        {
            // 跳转WX
            NSURL *url = [NSURL URLWithString:@"weixin://"];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
            [TTStatisticsService trackEvent:TTStatisticsServiceHallShareMemberWXClick eventDescribe:@"分享暗号到微信"];
        }
            break;
        case TTGuildMemberCodeShareTypeQQ:
        {
            // 跳转QQ
            NSURL *url = [NSURL URLWithString:@"mqq://"];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
            [TTStatisticsService trackEvent:TTStatisticsServiceHallShareMemberQQClick eventDescribe:@"分享暗号到QQ"];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -
#pragma mark showSheetView
- (void)showGuildSheetView {
    [TTPopup popupView:self.guildAddSheetView style:TTPopupStyleActionSheet];
}

- (void)showGuildSecretCodeViewWithEmojiCode:(GuildEmojiCode *)emojiCode {
    self.guildSecretCodeView.emojiCode = emojiCode;
    
    [TTPopup popupView:self.guildSecretCodeView style:TTPopupStyleActionSheet];
}


#pragma mark -
#pragma mark clients
#pragma mark GuildCoreClient
/** 获取全部成员 */
- (void)responseGuildHallAllMembersList:(NSArray *)list
                                  count:(NSString *)count
                              errorCode:(NSNumber *)code
                                    msg:(NSString *)msg {
    [self endTableViewRefresh];
    self.sectionHeadView.countLabel.text = [NSString stringWithFormat:@"总人数%@人", count];
    if (self.page == 1) {
        self.dataArray = [NSMutableArray arrayWithArray:list];
        if (self.dataArray.count == 0) {
            [self.tableView showEmptyContentToastWithTitle:@"暂时没有数据哦~" andImage:[UIImage imageNamed:@"common_noData_empty"]];
        } else {
            [self.tableView hideToastView];
        }
    } else if (self.page > 1) {
        [self.dataArray addObjectsFromArray:list];
        if (list.count == 0) {
            self.page -= 1;
        }
    }
    self.sectionHeadView.countLabel.text = [NSString stringWithFormat:@"总人数：%@人", count];
    [UIView performWithoutAnimation:^{
        [self.tableView reloadData];
    }];
}

/** 群聊全部人员 */
- (void)responseGuildGroupAllMembers:(NSArray<UserInfo *> *)list data:(GuildChatGroupAllMemberResponse *)data errorCode:(NSNumber *)code msg:(NSString *)msg {
    [self endTableViewRefresh];
    
    self.chatGroupAllMemberResponse = data;
    if (self.page == 1) {
        self.dataArray = [NSMutableArray arrayWithArray:list];
        if (self.dataArray.count == 0) {
            [self.tableView showEmptyContentToastWithTitle:@"暂时没有数据哦~" andImage:[UIImage imageNamed:@"common_noData_empty"]];
        } else {
            [self.tableView hideToastView];
        }
    } else if (self.page > 1) {
        [self.dataArray addObjectsFromArray:list];
        if (list.count == 0) {
            self.page -= 1;
        }
    }
    [UIView performWithoutAnimation:^{
        [self.tableView reloadData];
    }];
}

/** 设置管理员 */
- (void)responseGuildHallSetManagerSuccess:(BOOL)isSuccess errorCode:(NSNumber *)code msg:(NSString *)msg {
    self.managerCount += 1;
    [self refreshDataBySuccessAction:isSuccess msg:msg];
}

/** 取消管理员 */
- (void)responseGuildHallRemoveManagerSuccess:(BOOL)isSuccess errorCode:(NSNumber *)code msg:(NSString *)msg {
    self.managerCount -= 1;
    [self refreshDataBySuccessAction:isSuccess msg:msg];
}

/** 将用户移除模厅 */
- (void)responseGuildHallKick:(BOOL)isSuccess errorCode:(NSNumber *)code msg:(NSString *)msg {
    [XCHUDTool hideHUDInView:self.view];
    if (isSuccess) {
        self.listType = GuildHallListTypeMember;
        [self.dataArray removeObjectAtIndex:self.currentIndexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[self.currentIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        [self requestAllMemberList];
    }
}

/** 退出模厅成功 */
- (void)responseGuildHallQuit:(BOOL)isSuccess errorCode:(NSNumber *)code msg:(NSString *)msg {
    if (isSuccess) {
        [XCHUDTool showSuccessWithMessage:@"你的申请已提交" inView:self.view];
    }
}

/** 更多菜单权限 */
- (void)responseGuildHallGetManagerAuthList:(NSArray<GuildHallManagerInfo *> *)list errorCode:(NSNumber *)code msg:(NSString *)msg {
    self.authArray = list;
    [self setupNavigationItems];
}

/** 移出群聊成功 */
- (void)responseGuildGroupKick:(BOOL)isSuccess errorCode:(NSNumber *)code msg:(NSString *)msg {
    [XCHUDTool hideHUDInView:self.view];
    if (isSuccess) {
        self.listType = GuildHallListTypeGroupNormal;
        [self.dataArray removeObjectAtIndex:self.currentIndexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[self.currentIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        !_refreshHander ? : _refreshHander();
    }
}

/** 设置高管成功 */
- (void)responseGuildGroupSetManager:(BOOL)isSuccess errorCode:(NSNumber *)code msg:(NSString *)msg {
    [XCHUDTool hideHUDInView:self.view];
    if (isSuccess) {
        [XCHUDTool showSuccessWithMessage:@"操作成功" inView:self.view];
        [self requestAllMemberList];
        !_refreshHander ? : _refreshHander();
    }
}

/** 取消管理成功 */
- (void)responseGuildGroupCancelManager:(BOOL)isSuccess errorCode:(NSNumber *)code msg:(NSString *)msg {
    [XCHUDTool hideHUDInView:self.view];
    if (isSuccess) {
        [XCHUDTool showSuccessWithMessage:@"操作成功" inView:self.view];
        [self requestAllMemberList];
        !_refreshHander ? : _refreshHander();
    }
}

/** 禁言成功 or 取消禁言成功 */
- (void)responseGuildGroupBan:(BOOL)isSuccess errorCode:(NSNumber *)code msg:(NSString *)msg {
    [XCHUDTool hideHUDInView:self.view];
    if (isSuccess) {
        [XCHUDTool showSuccessWithMessage:@"操作成功" inView:self.view];
        [self requestAllMemberList];
    }
}

/** 群组添加成员成功 */
- (void)responseGuildGroupAddMembers:(BOOL)isSuccess errorCode:(NSNumber *)code msg:(NSString *)msg {
    [XCHUDTool hideHUDInView:self.view];
    if (isSuccess) {
        [XCHUDTool showSuccessWithMessage:@"添加成员成功" inView:self.view];
        self.isGroupChat = NO;
        !_refreshHander ? : _refreshHander();
    }
}
/** 获取指定不在群里的成员 */
- (void)responseGuildNotInGroupMembers:(NSArray<UserInfo *> *)data errorCode:(NSNumber *)code msg:(NSString *)msg {
    NSArray *array = data;
    [self endTableViewRefresh];
//    if (array.count <= 0) {
//        self.sectionHeadView.countLabel.text = [NSString stringWithFormat:@"总人数%ld人", (long)array.count];
//        return;
//    }
    self.dataArray = [NSMutableArray arrayWithArray:array];
//    self.sectionHeadView.countLabel.text = [NSString stringWithFormat:@"总人数%ld人", (long)self.dataArray.count];
    [self.tableView reloadData];
}

- (void)responseGuildEmojiCode:(GuildEmojiCode *)emojiCode errorCode:(NSNumber *)code msg:(NSString *)msg {
    if (!emojiCode) {
        // 如果需要显示的话就解开注释
//        [UIView showToastInKeyWindow:msg duration:2.0 position:YYToastPositionCenter];
        return;
    }
    
    // 保存一份到本地
    YYCache *emojiCodeCache = [[YYCache alloc] initWithName:kCacheEmojiCodeName];
    [emojiCodeCache setObject:emojiCode forKey:kEmojiCodeCacheKey];
    [emojiCodeCache setObject:GetCore(AuthCore).getUid forKey:kEmojiCodeUserIDKey];
    
    self.shareEmojiCode = emojiCode;
    [self showGuildSecretCodeViewWithEmojiCode:emojiCode];
}

#pragma mark -
#pragma mark private methods

/**
 判断是否需要请求暗号分享口令，如果口令还在生效期，就直接加载缓存中的数据

 @return 是否需要请求资源
 */
- (BOOL)isNeedRequestNewEmojiCode {
    // 默认为请求
    BOOL isNeed = YES;
    // 如果口令的失效时间大于当前时间，就不需要再重新请求，直接使用缓存
    if (self.shareEmojiCode.expireDate.integerValue > [NSDate cTimestampFromDate:[NSDate date]]) {
        isNeed = NO;
    }

    return isNeed;
}

/**
 头部显示的w标题文字

 @return 显示内容
 */
- (NSString *)headerViewText {
    NSString *text = @"0";
    switch (self.listType) {
        case GuildHallListTypeMute:
        {
            text = [NSString stringWithFormat:@"已禁言人数:%@人", self.chatGroupAllMemberResponse.muteCount];
        }
            break;
        case GuildHallListTypeGroupManager:
        {
            text = [NSString stringWithFormat:@"管理员人数:%@人", self.chatGroupAllMemberResponse.managerCount];
        }
            break;
        case GuildHallListTypeMutableMember:
        {
            text = [NSString stringWithFormat:@"已选择人数:%@人", @(self.selectingUserArray.count).stringValue];
        }
            break;
        case GuildHallListTypeKeeper:
        {
            text = [NSString stringWithFormat:@"管理员人数:%ld人", (long)self.managerCount];
        }
            break;
        default:
            text = [NSString stringWithFormat:@"总人数:%@人", @(self.dataArray.count).stringValue];
            break;
    }
    return text;
}

#pragma mark -
#pragma mark GetCore
/** 获取公会全部成员 */
- (void)requestAllMemberList {
    NSInteger pageSize = 100;
    if (self.listType == GuildHallListTypeMutableMember && self.isGroupAdd) {
        [GetCore(GuildCore) requestGuildMemberListWhichNotInGroupWithChatId:self.chatID page:self.page pageSize:pageSize];
        return;
    }
    
    if (self.listType != GuildHallListTypeMute &&
        self.listType != GuildHallListTypeGroupMember &&
        self.listType != GuildHallListTypeGroupManager &&
        self.listType != GuildHallListTypeGroupNormal) {
        // 模厅全员
        [GetCore(GuildCore) requestGuildHallAllMembersListByHallId:self.hallInfo.hallId page:self.page pageSize:pageSize];
        return;
    }
    // 群聊全员
    [GetCore(GuildCore) requestGuildGroupAllMembersWithChatId:self.chatID page:self.page pageSize:pageSize];
}

/** 刷新数据 */
- (void)refreshDataBySuccessAction:(BOOL)isSuccess msg:(NSString *)msg {
    if (isSuccess) {
        [XCHUDTool showSuccessWithMessage:@"操作成功" inView:self.view];
        !_refreshHander ? : _refreshHander();
        [self requestAllMemberList];
    }
}

/** 添加成员 */
- (void)addMemberToHall {
    // 统计添加成员
    [TTStatisticsService trackEvent:TTStatisticsServiceEventHallAddMembers eventDescribe:@"添加成员-成员列表"];
    [self showGuildSheetView];
}
/** 移除成员 */
- (void)removeMemberInHall {
    self.listType = GuildHallListTypeRemoveMember;
    [self.tableView reloadData];
}
/** 高管设置 */
- (void)setupKeeperManagerToHall {
    TTKeeperListViewController *vc = [[TTKeeperListViewController alloc] init];
    vc.hallInfo = self.hallInfo;
    [self.navigationController pushViewController:vc animated:YES];
}
/** 退出模厅 */
- (void)quitHall {
    // 退出
    TTAlertConfig *config = [[TTAlertConfig alloc] init];
    config.message = @"退出将解除关系并退出群聊，此操作需要厅主审核，你真的要退出吗？";
    
    // 第一段需要富文本显示的文本
    TTAlertMessageAttributedConfig *exitAttConfig = [[TTAlertMessageAttributedConfig alloc] init];
    exitAttConfig.text = @"退出群聊";
    
    // 第二段需要富文本显示的文本
    TTAlertMessageAttributedConfig *needComfirmConfig = [[TTAlertMessageAttributedConfig alloc] init];
    needComfirmConfig.text = @"需要厅主审核";
    
    config.messageAttributedConfig = @[exitAttConfig, needComfirmConfig];
    
    [TTPopup alertWithConfig:config confirmHandler:^{
        [GetCore(GuildCore) requestGuildHallQuit];
    } cancelHandler:^{
    }];
}

/** 获取管理员权限 */
- (void)requestKeeperManagerAuthList {
    [GetCore(GuildCore) requestGuildHallGetHallAuthsWithUid:[GetCore(AuthCore) getUid] roleType:self.hallInfo.roleType];
}

- (void)endTableViewRefresh {
    [self.tableView endRefreshStatus:0];
    [self.tableView endRefreshStatus:1 totalPage:self.page];
}
#pragma mark -
#pragma mark button click events
- (void)onRightItemClickHandler:(UIButton *)btn {
    switch (btn.tag) {
        case 1001:
        {
            // 更多
            [self.menuView showInView:self.navigationController.view];
        }
            break;
        case 1002:
        {
            // 搜索
            UIViewController *vc = [[XCMediator sharedInstance] ttHomeMoudleBridge_hallSearchSearchRoomController];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1003:
        {
            // 确定
            if (self.selectingUserArray.count <= 0) {
                [XCHUDTool showErrorWithMessage:@"请至少选择一位" inView:self.view];
                return;
            }
            !_tranfromHandler ? : _tranfromHandler(self.selectingUserArray);
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case 1005:
        {
            // remove
            NSLog(@"点击删除");
            self.listType = GuildHallListTypeRemoveMember;
            self.isGroupChat = YES;
            [self.tableView reloadData];
        }
            break;
        case 1006:
        {
            // add
            TTGroupChatMemberAddViewController *vc = [[TTGroupChatMemberAddViewController alloc] init];
            vc.hallInfo = GetCore(GuildCore).hallInfo;
//            vc.listType = GuildHallListTypeMutableMember;
            vc.chatID = self.chatID;
//            vc.isGroupAdd = YES;
            @weakify(self);
            vc.tranfromHandler = ^(NSMutableArray<UserInfo *> * _Nonnull array) {
                @strongify(self);
                NSMutableArray *mutabArray = [NSMutableArray array];
                [array enumerateObjectsUsingBlock:^(UserInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [mutabArray addObject:[NSString stringWithFormat:@"%lld", obj.uid]];
                }];
                NSString *str = [mutabArray componentsJoinedByString:@","];
                [GetCore(GuildCore) requestGuildGroupAddMembersWithChatId:self.chatID targetUids:str];
                [XCHUDTool showGIFLoadingInView:self.view];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TTMemberListCell *cell = [tableView dequeueReusableCellWithIdentifier:kMemberListCellConst];
    cell.currentManagerRoleType = self.hallInfo.roleType;
    switch (self.listType) {
        case GuildHallListTypeRemoveMember:
        {
            cell.isRemove = YES;
        }
            break;
        case GuildHallListTypeMember:
        {
            cell.isNormal = YES;
        }
            break;
        case GuildHallListTypeKeeper:
        {
            cell.isManagerSelected = YES;
        }
            break;
        case GuildHallListTypeMutableMember:
        {
            cell.isMutable = YES;
        }
            break;
        case GuildHallListTypeMute:
        {
            cell.isMute = YES;
            cell.isGroup = YES;
            cell.currentManagerRoleType = @(self.groupChatInfo.role).stringValue;
        }
            break;
        case GuildHallListTypeGroupMember:
        {
            cell.isMutable = YES;
            cell.isGroup = YES;
        }
            break;
        case GuildHallListTypeGroupManager:
        {
            cell.isManagerSelected = YES;
            cell.isGroup = YES;
        }
            break;
        case GuildHallListTypeGroupNormal:
        {
            cell.isGroup = YES;
            cell.isRemove = NO;
        }
            break;
        default:
            break;
    }
    cell.delegate = self;
    cell.tag = indexPath.row;
    if (self.dataArray.count > indexPath.row) {
        cell.userInfo = self.dataArray[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.listType != GuildHallListTypeGroupNormal && self.listType != GuildHallListTypeMember) {
        return;
    }
    TTMineContainViewController *vc = [[TTMineContainViewController alloc] init];
    vc.mineInfoStyle = TTMineInfoViewStyleOhter;
    UserInfo *info = [self.dataArray safeObjectAtIndex:indexPath.row];
    vc.userID = info.uid;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    self.sectionHeadView.countLabel.text = [self headerViewText];
    return self.sectionHeadView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

#pragma mark -
#pragma mark CellBtn selected delegate
- (void)onCellSelectedClickHandler:(UIButton *)btn info:(UserInfo *)info {
    // 设置群管理
    if (self.listType == GuildHallListTypeGroupManager) {
        
        TTAlertConfig *config = [[TTAlertConfig alloc] init];
        if (btn.selected) {
            config.message = [NSString stringWithFormat:@"确认取消%@的管理员身份吗？", info.nick];
        } else {
            config.message = [NSString stringWithFormat:@"确定设置%@为管理员吗？", info.nick];
        }
        
        TTAlertMessageAttributedConfig *attConfig = [[TTAlertMessageAttributedConfig alloc] init];
        attConfig.text = info.nick;
   
        config.messageAttributedConfig = @[attConfig];
        
        @weakify(self);
        [TTPopup alertWithConfig:config confirmHandler:^{
            @strongify(self);
            // 请求接口
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:btn.tag inSection:0];
            self.currentIndexPath = indexPath;
            if (btn.selected) {
                [GetCore(GuildCore) requestGuildGroupCancelManagerWithChatId:self.chatID targetUid:[NSString stringWithFormat:@"%lld", info.uid]];
            } else {
                [GetCore(GuildCore) requestGuildGroupSetManagerWithChatId:self.chatID targetUid:[NSString stringWithFormat:@"%lld", info.uid]];
            }
            [XCHUDTool showGIFLoadingInView:self.view];
        } cancelHandler:^{
        }];
        return;
    }
    // 禁言
    if (self.listType == GuildHallListTypeMute) {
        
        TTAlertConfig *config = [[TTAlertConfig alloc] init];
        if (btn.selected) {
            config.message = [NSString stringWithFormat:@"确认取消%@的禁言吗", info.nick];
        } else {
            config.message = [NSString stringWithFormat:@"确认禁言%@吗？", info.nick];
        }
        
        TTAlertMessageAttributedConfig *attConfig = [[TTAlertMessageAttributedConfig alloc] init];
        attConfig.text = info.nick;
        
        config.messageAttributedConfig = @[attConfig];
        
        @weakify(self);
        [TTPopup alertWithConfig:config confirmHandler:^{
            @strongify(self);
            // 请求接口
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:btn.tag inSection:0];
            self.currentIndexPath = indexPath;
            [GetCore(GuildCore) requestGuildGroupBanWithChatId:self.chatID targetUid:[NSString stringWithFormat:@"%lld", info.uid] isMute:!btn.selected];
            [XCHUDTool showGIFLoadingInView:self.view];
        } cancelHandler:^{
            
        }];
        return;
    }
    // 多选成员
    if (self.listType == GuildHallListTypeMutableMember || self.listType == GuildHallListTypeGroupMember) {
        btn.selected = !btn.selected;
        
        if (btn.selected) {
            if (![self.selectingUserArray containsObject:info]) {
                [self.selectingUserArray addObject:info];
            }
        } else {
            if ([self.selectingUserArray containsObject:info]) {
                [self.selectingUserArray removeObject:info];
            }
        }
        
        self.sectionHeadView.countLabel.text = [NSString stringWithFormat:@"已选择人数:%@人", @(self.selectingUserArray.count).stringValue];
        NSString *uidsStr = [self.selectingUserArray componentsJoinedByString:@","];
        return;
    }
    // 移除成员
    if (self.listType == GuildHallListTypeRemoveMember) {
        
        TTAlertConfig *config = [[TTAlertConfig alloc] init];
        config.message = [NSString stringWithFormat:@"确认把%@移出群吗?", info.nick];
        
        if (!self.isGroupChat) {
            config.message = [NSString stringWithFormat:@"移除%@将清除数据并退出群聊，确认移除吗？", info.nick];
            if ([info.roleType isEqualToString:@"2"]) {
                config.message = [NSString stringWithFormat:@"%@为高管，移除将清除数据并退出群聊，确认移除吗？", info.nick];
            }
        }
        
        TTAlertMessageAttributedConfig *attConfig = [[TTAlertMessageAttributedConfig alloc] init];
        attConfig.text = info.nick;
      
        config.messageAttributedConfig = @[attConfig];
        
        @weakify(self);
        [TTPopup alertWithConfig:config confirmHandler:^{
            @strongify(self);
            // 请求接口
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:btn.tag inSection:0];
            self.currentIndexPath = indexPath;
            if (self.isGroupChat) {
                // 踢出群聊
                [GetCore(GuildCore) requestGuildGroupKickWithChatId:self.chatID targetUids:[NSString stringWithFormat:@"%lld", info.uid]];
            } else {
                // 踢出公会
                [GetCore(GuildCore) requestGuildHallKickWithTargetUid:[NSString stringWithFormat:@"%lld", info.uid]];
            }
            [XCHUDTool showGIFLoadingInView:self.view];
        } cancelHandler:^{
        }];
        return;
    }
    
    if (self.listType == GuildHallListTypeKeeper) {
        // 高管设置
        TTAlertConfig *config = [[TTAlertConfig alloc] init];
        if (btn.selected) {
            config.message = [NSString stringWithFormat:@"确认删除%@的高管身份吗？", info.nick];
        } else {
            config.message = [NSString stringWithFormat:@"确认设%@为高管吗", info.nick];
        }
        
        TTAlertMessageAttributedConfig *attConfig = [[TTAlertMessageAttributedConfig alloc] init];
        attConfig.text = info.nick;
        
        config.messageAttributedConfig = @[attConfig];
        
        @weakify(self);
        [TTPopup alertWithConfig:config confirmHandler:^{
            @strongify(self);
            // 请求接口
            NSString *currentUid = [NSString stringWithFormat:@"%lld", info.uid];
            if (btn.selected) {
                [GetCore(GuildCore) requestGuildHallRemoveManagerByHallId:self.hallInfo.hallId targetUid:currentUid];
            } else {
                [GetCore(GuildCore) requestGuildHallSetManagerByHallId:self.hallInfo.hallId targetUid:currentUid];
            }
        } cancelHandler:^{
        }];
    }
}


#pragma mark -
#pragma mark getter & setter

- (TTGuildMemberHeaderSectionView *)sectionHeadView {
    if (!_sectionHeadView) {
        _sectionHeadView = [[TTGuildMemberHeaderSectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
    }
    return _sectionHeadView;
}

- (NSMutableArray<UserInfo *> *)selectingUserArray {
    if (!_selectingUserArray) {
        _selectingUserArray = [NSMutableArray array];
    }
    return _selectingUserArray;
}

- (NSArray<GuildHallManagerInfo *> *)authArray {
    if (!_authArray) {
        _authArray = @[];
    }
    return _authArray;
}

- (NSMutableArray *)managerArray {
    if (!_managerArray) {
        _managerArray = [NSMutableArray array];
    }
    return _managerArray;
}

- (TTGuildAddMemberSheetView *)guildAddSheetView {
    if (!_guildAddSheetView) {
        _guildAddSheetView = [[TTGuildAddMemberSheetView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, kSheetViewHeight + kSafeAreaBottomHeight)];
        _guildAddSheetView.delegate = self;
    }
    return _guildAddSheetView;
}

- (TTGuildAddMemberSecretCodeView *)guildSecretCodeView {
    if (!_guildSecretCodeView) {
        _guildSecretCodeView = [[TTGuildAddMemberSecretCodeView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, kSecretCodeViewHeight + kSafeAreaBottomHeight)];
        _guildSecretCodeView.delegate = self;
    }
    return _guildSecretCodeView;
}

- (GuildEmojiCode *)shareEmojiCode {
    if (!_shareEmojiCode) {
        _shareEmojiCode = [[GuildEmojiCode alloc] init];
        // 本地数据
        YYCache *emojiCodeCache = [YYCache cacheWithName:kCacheEmojiCodeName];
        
        // 判断是否可以是自己发出去的
        NSString *currentUserID = [GetCore(AuthCore) getUid];
        NSString *cacheUserID = (NSString *)[emojiCodeCache objectForKey:kEmojiCodeUserIDKey];
        if (![currentUserID isEqualToString:cacheUserID]) {
            // 如果缓存中的 UserID 和当前用户不是同一个，就清空缓存数据
            [emojiCodeCache removeAllObjects];
        }
        
        if ([emojiCodeCache containsObjectForKey:kEmojiCodeCacheKey]) {
            _shareEmojiCode = (GuildEmojiCode *)[emojiCodeCache objectForKey:kEmojiCodeCacheKey];
        }
    }
    return _shareEmojiCode;
}
@end

