//
//  TTGuildViewController.m
//  TuTu
//
//  Created by lee on 2018/12/29.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTGuildViewController.h"
#import "TTGuildNameSettingsViewController.h"
#import "TTGuildMemberlistViewController.h"
#import "TTGuildGroupCreateViewController.h"
#import "TTGuildGroupInfoViewController.h"
#import "TTGuildIncomeStatisticViewController.h"

#import "XCMediator+TTPersonalMoudleBridge.h"
#import "XCMediator+TTHomeMoudle.h"

#import <Masonry/Masonry.h>
#import <YYCache/YYCache.h>

#import "XCTheme.h"
#import "XCMacros.h"
#import "TTGuildGroupManageConst.h"
#import "UIView+ZJFrame.h"
#import "UIView+XCToast.h"
#import "XCHUDTool.h"
#import "GuildCore.h"
#import "GuildCoreClient.h"
#import "UserCore.h"
#import "AuthCore.h"
// model
#import "GuildHallMenu.h"
// tools
#import "TTPopup.h"
#import "NSDate+Util.h"
#import "NSDate+TimeCategory.h"

// views
#import "TTGuildTofuCell.h"
#import "TTGuildGroupChatCell.h"
#import "TTGuildGroupHeadReusableView.h"
#import "TTGuildAddMemberSheetView.h"
#import "TTGuildAddMemberSecretCodeView.h"
//core
#import "GuildCore.h"
#import "GuildCoreClient.h"
#import "ShareCore.h"
#import "ShareCoreClient.h"
#import "GuildEmojiCode.h"
#import "TTStatisticsService.h"

#import "TTItemMenuView.h"
#import "TTItemsMenuConfig.h"

#import "TTWKWebViewViewController.h"

static CGFloat const kSheetViewHeight = 243;
static CGFloat const kSecretCodeViewHeight = 380;
static CGFloat const kItemMenuHeight = 130;
static NSString *const kCacheEmojiCodeName = @"kCacheEmojiCodeName";
static NSString *const kEmojiCodeCacheKey = @"kEmojiCodeCacheKey";
static NSString *const kEmojiCodeUserIDKey = @"kEmojiCodeUserIDKey";

@interface TTGuildViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, TTGuildGroupHeadReusableViewDelegate, GuildCoreClient, ShareCoreClient, TTItemMenuViewDelegate, TTGuildGroupChatCellDelegate, TTGuildAddMemberSheetViewDelegate, TTGuildAddMemberSecretCodeViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<GuildHallGroupListItem *> *dataArray;
@property (nonatomic, strong) NSMutableArray<GuildHallMenu *> *headArray;

@property (nonatomic, strong) GuildHallInfo *hallInfo;//模厅信息
/** 更多菜单 */
@property (nonatomic, strong) TTItemMenuView *menuView;
// 群聊
@property (nonatomic, strong) GuildHallGroupListItem *groupChatItem;
/** 平台按钮view */
@property (nonatomic, strong) TTGuildAddMemberSheetView *guildAddSheetView;
/** 暗号显示view */
@property (nonatomic, strong) TTGuildAddMemberSecretCodeView *guildSecretCodeView;
@property (nonatomic, strong) GuildEmojiCode *shareEmojiCode;
@property (nonatomic, assign) BOOL isGuildView;
@end

@implementation TTGuildViewController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    _isGuildView = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _isGuildView = YES;
}

- (void)dealloc {
    RemoveCoreClientAll(self);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initCores];
    [self initViews];
    [self initConstraints];
    [self setupNotification];
    [self setupItemDropMenu];

    [self requestHallInfo];
    [self requestHallGroupList];
    [self requestHallMenus];
}

- (void)setupItemDropMenu {
    TTItemMenuItem *settingName = [TTItemMenuItem creatWithTitle:@"设置厅名" iconName:@"guild_moreItems_nameEdit" titleFont:[UIFont systemFontOfSize:15] titleColor:[UIColor whiteColor]];
    
    TTItemsMenuConfig *config = [TTItemsMenuConfig creatMenuConfigWithItemHeight:44 menuWidth:kItemMenuHeight separatorInset:UIEdgeInsetsMake(0, 0, 0, 0) separatorColor:[UIColor colorWithWhite:1 alpha:0] backgroudColor:UIColorFromRGB(0x4C4C4C)];
    TTItemMenuView *menuView = [[TTItemMenuView alloc] initWithFrame:CGRectZero withConfig:config items:@[settingName]];
    menuView.delegate = self;
    menuView.isShowMask = NO;
    self.menuView = menuView;
}

- (void)rightItemsClickHandler:(UIButton *)btn {
    switch (btn.tag) {
        case 1001:
        {
            // 成员管理
            TTGuildMemberlistViewController *vc = [[TTGuildMemberlistViewController alloc] init];
            vc.hallInfo = self.hallInfo;
            vc.listType = GuildHallListTypeMember;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1002:
        {
            // 下拉弹窗
            [self.menuView showInView:self.navigationController.view];
        }
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark TTItemMenuViewDelegate
- (void)menuView:(TTItemMenuView *)addMenuView didSelectedItem:(TTItemMenuItem *)item {
    if ([item.title isEqualToString:@"设置厅名"]) {
        // 设置
        TTGuildNameSettingsViewController *vc = [[TTGuildNameSettingsViewController alloc] init];
        vc.hallName = self.hallInfo.hallName;
        @weakify(self);
        [vc setEditCompletion:^(NSString * _Nonnull hallName) {
            @strongify(self);
            self.hallInfo.hallName = hallName;
            self.title = hallName;
            !self.guildNameRefreshHandler ? : self.guildNameRefreshHandler(hallName);
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark -
#pragma mark cell Delegate
- (void)onJoinGroupChatClickHandler:(UIButton *)btn groupChatItem:(GuildHallGroupListItem *)item{
    // 加入群
    self.groupChatItem = item;
    [XCHUDTool showGIFLoadingInView:self.view];
    [GetCore(GuildCore) requestGuildGroupJoinWithChatId:item.chatId];
}

#pragma mark -
#pragma mark Private Methods
- (void)initViews {
    [self.view addSubview:self.collectionView];
}

- (void)initConstraints {
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(kNavigationHeight);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

/**
 请求模厅信息
 */
- (void)requestHallInfo {
    UserInfo *info = [GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.longLongValue];
    [GetCore(GuildCore) requestGuildHallInfoFetchWithHallId:@(info.hallId).stringValue uid:@(info.uid).stringValue];
}

/**
 请求模厅群聊列表
 */
- (void)requestHallGroupList {
    UserInfo *info = [GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.longLongValue];
    [GetCore(GuildCore) requestGuildGroupListWithHallId:@(info.hallId).stringValue groupType:nil];
}

/**
 请求模厅信息
 */
- (void)requestHallMenus {
    [GetCore(GuildCore) requestGuildHallMenusWithUid:@""];
}

- (void)setupNotification {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];

    __weak typeof(self) weakself = self;
    [defaultCenter addObserverForName:TTGuildGroupManageDidUpdateHallNoti object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [weakself requestHallInfo];
    }];
    [defaultCenter addObserverForName:TTGuildGroupManageDidUpdateGroupNoti object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [weakself requestHallGroupList];
    }];
    [defaultCenter addObserverForName:TTGuildGroupManageDidCreateGroupNoti object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [weakself requestHallGroupList];
    }];
    [defaultCenter addObserverForName:TTGuildGroupManageDidQuitGroupNoti object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [weakself requestHallGroupList];
    }];
    [defaultCenter addObserverForName:TTGuildGroupManageDidRemoveGroupNoti object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [weakself requestHallGroupList];
    }];
}

#pragma mark -
#pragma mark addCore
- (void)initCores {
    AddCoreClient(GuildCoreClient, self);
    AddCoreClient(ShareCoreClient, self);
}

#pragma mark -
#pragma mark TTGuildGroupHeadReusableViewDelegate
- (void)onClickCreatGroupChatBtnHandler:(UIButton *)btn {
    TTGuildGroupCreateViewController *vc = [[TTGuildGroupCreateViewController alloc] init];
    vc.hallInfo = self.hallInfo;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark collectionView delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (self.headArray.count > indexPath.item) {
            GuildHallMenu *menuInfo = self.headArray[indexPath.item];
            if ([menuInfo.code isEqualToString:@"look_hall_income"]) {
                
                // 收益详情
                TTGuildIncomeStatisticViewController *vc = [[TTGuildIncomeStatisticViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                
            } else if ([menuInfo.code isEqualToString:@"member_join_manager"]) {
                
                // 统计添加成员
                [TTStatisticsService trackEvent:TTStatisticsServiceEventHallAddMembers eventDescribe:@"添加成员-面板"];
                // 显示暗号分享view
                [self showGuildSheetView];
                
            } else if ([menuInfo.code isEqualToString:@"hall_owner_room_serial"]) {
                // 厅收入统计
                [TTStatisticsService trackEvent:TTStatisticsServiceEventHallIncome eventDescribe:@"厅收入统计"];
                // 厅收入
                TTWKWebViewViewController *webVC = [[TTWKWebViewViewController alloc] init];
                webVC.url = [NSURL URLWithString:menuInfo.url];
                [self.navigationController pushViewController:webVC animated:YES];
                
            } else {
                [XCHUDTool showErrorWithMessage:@"请更新最新版本" inView:self.view];
            }
        }
        return;
    }
    
    if (self.dataArray.count <= indexPath.row) {
        return;
    }
    
    GuildHallGroupListItem *item = self.dataArray[indexPath.row];
    if (!item.inChat) {
        return; // 不在群中
    }
    UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_TTGuildGroupSessionViewControllerWithSessionId:item.tid];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.headArray.count;
    }
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 功能列表
    if (indexPath.section == 0) {
        TTGuildTofuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGuildTofuConst forIndexPath:indexPath];
        cell.isShowThirdPic = self.headArray.count >= 3;
        
        if (self.headArray.count > indexPath.item) {
            cell.hallMenu = self.headArray[indexPath.item];
        }
        return cell;
    }
    // 群聊列表
    TTGuildGroupChatCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGuildGroupChatConst forIndexPath:indexPath];
    cell.delegate = self;
    if (self.dataArray.count > indexPath.item) {
        cell.listItem = self.dataArray[indexPath.item];
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        TTGuildGroupHeadReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kGuildGroupChatHeadConst forIndexPath:indexPath];
        headView.delegate = self;
        reusableView = headView;
        if ([self.hallInfo.roleType isEqualToString:@"1"]) {
            headView.creatGroupChatBtn.hidden = NO;
        }
    }
    return reusableView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.headArray.count >= 3) {
            return CGSizeMake((KScreenWidth - 60) / 3, 57);
        }
        return CGSizeMake((KScreenWidth - 45) / 2, 85);
    }
    return CGSizeMake(KScreenWidth, 70);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return CGSizeMake(KScreenWidth, 60);
    }
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return UIEdgeInsetsMake(15, 15, 15, 15);
    }
    return UIEdgeInsetsMake(0, 15, 5, 15);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 15;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 1) {
        return 1;
    }
    return 15;
}


#pragma mark -
#pragma mark clients
#pragma mark GuildCoreClient

/**
 获取模厅信息
 
 @param data 模厅信息
 @param code 错误码
 @param msg 错误信息
 */
- (void)responseGuildHallInfoFetch:(GuildHallInfo *)data errorCode:(NSNumber *)code msg:(NSString *)msg {
    if (data) {
        
        NSArray *item = @[@"guild_manager_item"];
        if ([data.roleType isEqualToString:@"1"]) {
            item = @[@"guild_manager_item", @"guild_setting_item"];
        }
         [self addNavigationItemWithImageNames:item isLeft:NO target:self action:@selector(rightItemsClickHandler:) tags:@[@1001,@1002]];
        
        self.hallInfo = data;
        self.title = data.hallName;
        [self.collectionView reloadData];
        return;
    }
}

/**
 获取模厅群聊列表
 
 @param data 群聊列表
 @param code 错误码
 @param msg 错误信息
 */
- (void)responseGuildGroupList:(NSArray<GuildHallGroupListItem *> *)data errorCode:(NSNumber *)code msg:(NSString *)msg
{
    self.dataArray = [NSMutableArray arrayWithArray:data];
    if (self.dataArray.count == 0) {
        self.collectionView.emptyViewInteractionEnabled = YES;
        [self.collectionView showEmptyContentToastWithTitle:@"暂时没有数据哦~" andImage:[UIImage imageNamed:@"common_noData_empty"]];
    } else {
        [self.collectionView hideToastView];
    }
    [self.collectionView reloadData];
}

/**
 获取模厅首页顶部功能列表(如收入统计)

 @param list 功能列表
 @param code 错误码
 @param msg 错误信息
 */
- (void)responseGuildHallMenusList:(NSArray<GuildHallMenu *> *)list errorCode:(NSNumber *)code msg:(NSString *)msg {
    self.headArray = [NSMutableArray arrayWithArray:list];
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
    [self.collectionView performBatchUpdates:^{
        [self.collectionView reloadSections:indexSet];
    } completion:nil];
}

/** 加入群聊成功 */
- (void)responseGuildGroupJoin:(BOOL)isSuccess errorCode:(NSNumber *)code msg:(NSString *)msg {
    [XCHUDTool hideHUDInView:self.view];
    if (isSuccess) {
        if (self.groupChatItem) {
            UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_TTGuildGroupSessionViewControllerWithSessionId:self.groupChatItem.tid];
            [self.navigationController pushViewController:vc animated:YES];
            // 刷新
            [self requestHallGroupList];
        }
    }
}

/** 请求暗号 */
- (void)responseGuildEmojiCode:(GuildEmojiCode *)emojiCode errorCode:(NSNumber *)code msg:(NSString *)msg {
    if (!emojiCode) {
        // 如果需要显示的话就解开注释
        //        [UIView showToastInKeyWindow:msg duration:2.0 position:YYToastPositionCenter];
        return;
    }
    
    if (!_isGuildView) {
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
#pragma mark showSheetView
- (void)showGuildSheetView {
    [TTPopup popupView:self.guildAddSheetView style:TTPopupStyleActionSheet];
}

- (void)showGuildSecretCodeViewWithEmojiCode:(GuildEmojiCode *)emojiCode {
    
    self.guildSecretCodeView.emojiCode = emojiCode;
    
    [TTPopup popupView:self.guildSecretCodeView style:TTPopupStyleActionSheet];
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
#pragma mark -
#pragma mark button click events

#pragma mark -
#pragma mark getter & setter
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
//        flowLayout.itemSize = CGSizeMake(100, 100);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[TTGuildGroupChatCell class] forCellWithReuseIdentifier:kGuildGroupChatConst];
        [_collectionView registerClass:[TTGuildTofuCell class] forCellWithReuseIdentifier:kGuildTofuConst];
        [_collectionView registerClass:[TTGuildGroupHeadReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kGuildGroupChatHeadConst];
    }
    return _collectionView;
}

- (NSMutableArray<GuildHallGroupListItem *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray<GuildHallMenu *> *)headArray {
    if (!_headArray) {
        _headArray = [NSMutableArray array];
    }
    return _headArray;
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
