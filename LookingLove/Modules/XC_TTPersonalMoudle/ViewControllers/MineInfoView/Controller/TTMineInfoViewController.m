//
//  TTMineInfoViewController.m
//  TuTu
//
//  Created by lee on 2018/10/31.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTMineInfoViewController.h"

#import "TTMinePhotoCell.h"
#import "TTMineInfoSignCell.h"
#import "TTMineInfoFamilyCell.h"
#import "TTMineInfoGuildsCell.h"
#import "TTMineGameRecordCell.h"
#import "TTMineGameApproveCell.h"
#import "TTMineInfoVoiceCell.h"
#import "TTMineInfoLittleWorldCell.h"

#import "TTEditMinePhotosViewContorller.h"

#import "ZJScrollPageViewDelegate.h"
#import <Masonry/Masonry.h>
#import "UserInfo.h"
#import "XCMacros.h"
#import "NSString+Utils.h"
#import <SDWebImage/SDWebImageManager.h>
#import "UIView+XCToast.h"
#import "XCMediator+TTDiscoverModuleBridge.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"

// core
#import "UserCore.h"
#import "UserCoreClient.h"
#import "GuildCore.h"
#import "GuildCoreClient.h"
#import "AuthCore.h"
#import "AuthCoreClient.h"
#import "CPGameCore.h"
#import "CPGameCoreClient.h"
#import "VoiceBottleCoreClient.h"

// model
#import "UserInfo.h"
#import "GuildOwnerHallInfo.h"
#import "XCMediator+TTPersonalMoudleBridge.h"
#import "XCMediator+TTGameModuleBridge.h"

#import "TTStatisticsService.h"
#import "TTPopup.h"
#import "XCCurrentVCStackManager.h"
#import "XCPlayerTool.h"
#import "LookingLoveUtils.h"
// 自定义View
#import "TTGameTagSelectView.h"

/**
个人页信息 cell 类型

- TTMineInfoCellTypeAlbum: 相册
- TTMineInfoCellTypeMotto: 签名
- TTMineInfoCellTypeVoice: 声音
- TTMineInfoCellTypeFamily: 家族
- TTMineInfoCellTypeGuild: 公会
- TTMineInfoCellTypeGame: 游戏
- TTMineInfoCellTypeSkillTag: 技能标签
- TTMineInfoCellTypeLittleWorld: 小世界
*/
typedef NS_ENUM(NSUInteger, TTMineInfoCellType) {
    TTMineInfoCellTypeAlbum,
    TTMineInfoCellTypeMotto,
    TTMineInfoCellTypeVoice,
    TTMineInfoCellTypeFamily,
    TTMineInfoCellTypeGuild,
    TTMineInfoCellTypeGame,
    TTMineInfoCellTypeSkillTag,
    TTMineInfoCellTypeLittleWorld,
};

@interface TTMineInfoViewController ()
<
ZJScrollPageViewChildVcDelegate,
TTMinePhotoCellDelegate,
TTMineInfoSignCellDelegate,
TTEditMinePhotosViewContorllerDelegate,
UITableViewDelegate,
UITableViewDataSource,
UserCoreClient,
GuildCoreClient,
VoiceBottleCoreClient,
TTMineInfoGuildsCellDelegate,
TTMineGameApproveCellDelegate,
TTGameTagSelectViewDelegate,
TTMineInfoVoiceCellDelegate
>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UserInfo *userInfo;
//个性签名
@property (nonatomic, assign) BOOL isShowSign;//
@property (nonatomic, strong) GuildOwnerHallInfo *hallInfo;
@property (nonatomic, strong) GuildOwnerHallGroupChat *groupChat;

@property (nonatomic, strong) NSMutableArray *gameRecordArray;
@property (nonatomic, strong) TTGameTagSelectView *gameTagView;
@end

@implementation TTMineInfoViewController

- (void)dealloc {
    RemoveCoreClientAll(self);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    SDImageCacheConfig *config = [SDImageCache sharedImageCache].config;
    config.shouldDecompressImages = YES;
    
    [[SDImageCache sharedImageCache] clearMemory];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // hx
    [LookingLoveUtils lookingLoveWillShowMyInfo:79];
    
    [self updateUserInfo];
    [self requestGameDataForWeek];
    
    NSString *des = self.mineInfoStyle == TTMineInfoViewStyleDefault ? @"个人主页主态页" : @"个人主页客态页";
    [TTStatisticsService trackEvent:@"homepage_data" eventDescribe:des];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[XCPlayerTool sharedPlayerTool] stop];
    [XCPlayerTool sharedPlayerTool].delegate = nil;
    
    if (self.dataArray.count >= TTMineInfoCellTypeVoice) {
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:TTMineInfoCellTypeVoice] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(infoDataReloadNoti:) name:@"kTuTuRefreshUserInfoNoti" object:nil];
    
    AddCoreClient(UserCoreClient, self);
    AddCoreClient(AuthCoreClient, self);
    AddCoreClient(GuildCoreClient, self);
    AddCoreClient(CPGameCoreClient, self);
    AddCoreClient(VoiceBottleCoreClient, self);
    
    [self initViews];
    [self initConstraints];
}

- (BOOL)isHiddenNavBar {
    return YES;
}

#pragma mark -
#pragma mark lifeCycle
- (void)initViews {
    [self.view addSubview:self.tableView];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.gameTagView];
}

- (void)initConstraints {
    
    [self.gameTagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

#pragma mark -
#pragma mark scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.scrollCallback(scrollView);
}

#pragma mark -
#pragma mark tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSArray *)dataArray {
    if (_dataArray && _dataArray.count > 0) {
        return _dataArray;
    }
    
    if (self.userInfo == nil) {
        _dataArray = @[];
        return _dataArray;
    }
    
    NSArray *sec1 = @[@(TTMineInfoCellTypeAlbum)];
    NSArray *sec2 = @[@(TTMineInfoCellTypeMotto)];
    NSArray *sec3 = @[@(TTMineInfoCellTypeVoice)];
    NSArray *sec4 = @[@(TTMineInfoCellTypeFamily)];
    NSArray *sec5 = @[@(TTMineInfoCellTypeGuild)];
    NSArray *sec6 = @[@(TTMineInfoCellTypeGame)];
    NSArray *sec7 = @[@(TTMineInfoCellTypeSkillTag)];
    NSArray *sec8 = @[@(TTMineInfoCellTypeLittleWorld)];
    
    _dataArray = @[sec1, sec2, sec3, sec8, sec4, sec5, sec6, sec7];
    
    return _dataArray;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *sectionData = [self.dataArray safeObjectAtIndex:indexPath.section];
    NSNumber *rowData = [sectionData safeObjectAtIndex:indexPath.row];
    
    if (rowData.integerValue == TTMineInfoCellTypeAlbum) {
        // 头像
        TTMinePhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TTMinePhotoCell class])];
        cell.userID = self.userID;
        cell.privatePhoto = self.userInfo.privatePhoto;
        cell.delegate = self;
        return cell;
    }
    
    if (rowData.integerValue == TTMineInfoCellTypeMotto) {
        // 个性签名
        TTMineInfoSignCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TTMineInfoSignCell class])];
        if (self.userInfo.userDesc.length) {
            cell.signLabel.text = self.userInfo.userDesc;
        }
        cell.delegate = self;
        return cell;
    }
    
    if (rowData.integerValue == TTMineInfoCellTypeVoice) {
        // 声音
        TTMineInfoVoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TTMineInfoVoiceCell class])];
        cell.clipsToBounds = YES;
        cell.delegate = self;
        cell.style = self.mineInfoStyle;
        cell.userInfo = self.userInfo;
        return cell;
    }
    
    if (rowData.integerValue == TTMineInfoCellTypeFamily) {
        //家族
        TTMineInfoFamilyCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TTMineInfoFamilyCell class])];
        cell.clipsToBounds = YES;
        cell.family = self.userInfo.family;
        return cell;
    }
    
    if (rowData.integerValue == TTMineInfoCellTypeGuild) {
        // 公会模厅
        TTMineInfoGuildsCell *cell = [tableView dequeueReusableCellWithIdentifier:kMineInfoGuildsCellConst];
        cell.clipsToBounds = YES;
        cell.infoModel = self.hallInfo;
        cell.delegate = self;
        return cell;
    }
    
    if (rowData.integerValue == TTMineInfoCellTypeGame) {
        // 我的游戏
        TTMineGameRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:kMineGameRecordCellConst];
        cell.clipsToBounds = YES;
        cell.recordArray = self.gameRecordArray;
        [cell.collectionView reloadData];
        
        return cell;
    }
    
    if (rowData.integerValue == TTMineInfoCellTypeSkillTag) {
        TTMineGameApproveCell *cell = [tableView dequeueReusableCellWithIdentifier:kMineGameApproveCellConst];
        cell.clipsToBounds = YES;
        cell.model = self.userInfo.userInfoSkillVo;
        cell.delegate = self;
        cell.userID = self.userID;
        return cell;
    }
    
    if (rowData.integerValue == TTMineInfoCellTypeLittleWorld) {
        TTMineInfoLittleWorldCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TTMineInfoLittleWorldCell class])];
        cell.clipsToBounds = YES;
        [cell setTitle:self.mineInfoStyle == TTMineInfoViewStyleDefault ? @"我的小世界" : @"Ta的小世界"];
        cell.dataArray = self.userInfo.joinWorlds;
        cell.selectedBlock = ^(UserLittleWorld * _Nonnull world) {
            UIViewController *vc = [[XCMediator sharedInstance] ttGameMoudle_TTWorldletContainerViewControllerWithWorldId:world.worldId isFromRoom:NO];
            [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:vc animated:YES];
        };
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",indexPath];
    cell.textLabel.numberOfLines = 0;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
 
 NSArray *sectionData = [self.dataArray safeObjectAtIndex:indexPath.section];
 NSNumber *rowData = [sectionData safeObjectAtIndex:indexPath.row];
    
    switch (rowData.integerValue) {
        case TTMineInfoCellTypeAlbum:
            return 140.f;
        case TTMineInfoCellTypeMotto: {
            if (self.userInfo.userDesc) {
                //  左右间距 60 标签间距高度 20
                CGSize size = [NSString sizeWithText:self.userInfo.userDesc font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(KScreenWidth - 60, CGFLOAT_MAX)];
                CGFloat height = size.height - 17;
                return height ? 100 + height : 100;
            }
            return 100;
        }
        case TTMineInfoCellTypeVoice:
            return (self.userInfo.userVoice.length <= 0 && self.mineInfoStyle == TTMineInfoViewStyleOhter) ? CGFLOAT_MIN : 98.f;
        case TTMineInfoCellTypeFamily:
            return (self.userInfo.family == nil) ? CGFLOAT_MIN : 104.f;
        case TTMineInfoCellTypeGuild:
            return (self.hallInfo == nil) ? CGFLOAT_MIN : 112.f;
        case TTMineInfoCellTypeGame:
            return (self.gameRecordArray.count > 0) ? 175.f : CGFLOAT_MIN;
        case TTMineInfoCellTypeSkillTag:
            ///这里设置为NO，永远隐藏101技能标签功能
            self.userInfo.userInfoSkillVo.liveTag = NO;
            return self.userInfo.userInfoSkillVo.liveTag ? 182.f : CGFLOAT_MIN;
        case TTMineInfoCellTypeLittleWorld:
            return (self.userInfo.joinWorlds.count > 0) ? 190.f : CGFLOAT_MIN;
        default:
            return UITableViewAutomaticDimension;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *sectionData = [self.dataArray safeObjectAtIndex:indexPath.section];
    NSNumber *rowData = [sectionData safeObjectAtIndex:indexPath.row];
    
    if (rowData.integerValue == TTMineInfoCellTypeFamily && self.userInfo.family) { // 家族
        UIViewController *vc = [[XCMediator sharedInstance] ttDiscoverMoudle_TTFamilyPersonViewController:self.userInfo.familyId];
        [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:vc animated:YES];
    }
    
    if (rowData.integerValue == TTMineInfoCellTypeVoice && self.userInfo.userVoice && self.mineInfoStyle == TTMineInfoViewStyleDefault) { // 声音
        [TTStatisticsService trackEvent:@"my_sound" eventDescribe:@"主态页"];
        UIViewController *vc = [[XCMediator sharedInstance] ttGameMoudle_TTVoiceMyViewController];
        [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:vc animated:YES];
    }
    
    if (rowData.integerValue == TTMineInfoCellTypeGuild) {
        TTMineInfoGuildsCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell.joinChatBtn.isHidden && cell.publicChatID.length > 0) {
            [self openGroupSessionViewWithSessionID:cell.publicChatID];
        }
    }
}

- (void)openGroupSessionViewWithSessionID:(NSString *)sessionID {
    UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_TTGuildGroupSessionViewControllerWithSessionId:sessionID];
    [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:vc animated:YES];
}

#pragma mark -
#pragma mark photo cell delegate
- (void)showPhotosEditController
{
    // push next ViewController
    TTEditMinePhotosViewContorller *vc = [[TTEditMinePhotosViewContorller alloc] init];
    vc.uid = _userInfo.uid;
    vc.delegate = self;
    [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:vc animated:YES];
}

- (void)clickShowSignBtn
{
    _isShowSign = !_isShowSign;
    [_tableView reloadData];
}

- (void)photoDataReload:(UserInfo *)userInfo {
    self.userInfo = userInfo;
    [self.tableView reloadData];
}

- (void)infoDataReloadNoti:(NSNotification *)noti {
    [self updateUserInfo];
}

#pragma mark - TTMineInfoVoiceCellDelegate
- (void)personNoVoiceToAddVoice:(TTMineInfoVoiceCell *)cell {
    UIViewController * recordVC = [[XCMediator sharedInstance] ttGameMoudle_TTVoiceRecordViewController];
    [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:recordVC animated:YES];
}

#pragma mark -
#pragma mark Cell delegate
/** cell 上点击按钮的事件 */
- (void)onClickBtnAction:(UIButton *)btn groupChat:(GuildOwnerHallGroupChat *)groupChat {
    switch (btn.tag) {
        case 1001:
        {
            [TTStatisticsService trackEvent:TTStatisticsServiceEventJoinHallClick
                              eventDescribe:@"厅主个人主页 申请入厅"];
            
            TTAlertConfig *config = [[TTAlertConfig alloc] init];
            config.message = [NSString stringWithFormat:@"确定加入%@吗？", self.hallInfo.hallName];
            
            TTAlertMessageAttributedConfig *attConfig = [[TTAlertMessageAttributedConfig alloc] init];
            attConfig.text = self.hallInfo.hallName;
        
            config.messageAttributedConfig = @[attConfig];
            @weakify(self);
            [TTPopup alertWithConfig:config confirmHandler:^{
                @strongify(self);
                // 申请入厅
                NSString *hallId = [NSString stringWithFormat:@"%ld", (long)self.userInfo.hallId];
                [GetCore(GuildCore) requestGuildHallJoinHallWithUid:[GetCore(AuthCore) getUid] hallId:hallId];
            } cancelHandler:^{ 
            }];
        }
            break;
        case 1002:
        {
            [TTStatisticsService trackEvent:TTStatisticsServiceEventJoinOpenGroupClick
                              eventDescribe:@"厅主个人主页 加入公开群"];
            
            self.groupChat = groupChat;
            // 申请加入群聊
            btn.userInteractionEnabled = NO;
            [GetCore(GuildCore) requestGuildGroupJoinWithChatId:[NSString stringWithFormat:@"%ld", (long)groupChat.chatId]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                btn.userInteractionEnabled = YES;
            });
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -
#pragma mark TTMineGameApproveCellDelegate  101认证编辑按钮点击
- (void)editBtnClickAction:(CertificationModel *)model{
    
    self.gameTagView.model = model;
    
    self.gameTagView.hidden = NO;
    
}

#pragma mark -
#pragma mark TTGameTagSelectViewDelegate   删除标签，重新获取userInfo
- (void)deleteGameTagAndUpdateUserInfo{
    [self updateUserInfo];
}

#pragma mark -
#pragma mark GuildCoreClient
// 公会信息
- (void)responseGuildOwnerHallInfo:(GuildOwnerHallInfo *)data errorCode:(NSNumber *)code msg:(NSString *)msg {
    self.hallInfo = data;
    [self.tableView reloadData];
}

// 申请加入模厅
- (void)responseGuildHallJoinHall:(BOOL)success errorCode:(NSNumber *)code msg:(NSString *)msg {
    if (success) {
        [UIView showToastInKeyWindow:@"申请成功，请等待厅主同意" duration:2 position:YYToastPositionCenter];
    }
}

- (void)responseGuildGroupJoin:(BOOL)isSuccess errorCode:(NSNumber *)code msg:(NSString *)msg {
    if (isSuccess) {
        [UIView showToastInKeyWindow:@"加入成功" duration:2 position:YYToastPositionCenter];
        [self openGroupSessionViewWithSessionID:@(self.groupChat.tid).stringValue];
        // 再请求接口
        [GetCore(GuildCore) requestGuildHallInfoWithOwnUid:@(self.userInfo.uid).stringValue];
    }
}

#pragma mark - VoiceBottleCoreClient
//录音发布成功
- (void)recordVoiceCompleteWithVoiceBottleModel:(VoiceBottleModel *)voiceModel {
    if (voiceModel) {
        self.userInfo.voiceDura = voiceModel.voiceLength;
        self.userInfo.userVoice = voiceModel.voiceUrl;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - JXPagingViewListViewDelegate
- (UIScrollView *)listScrollView {
    return self.tableView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (UIView *)listView {
    return self.view;
}

#pragma mark -
#pragma mark CPGameCoreClient
- (void)gameDataWithMinePage:(NSArray *)listArray {
    self.gameRecordArray = [NSMutableArray array];
    [self.gameRecordArray removeAllObjects];
    [self.gameRecordArray addObjectsFromArray:listArray];
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark private methods
// Update Info
- (void)updateUserInfo {
    @weakify(self);
    //需要YES不然修改资料之后无法更新，只能卸载app
    UserExtensionRequest *request = [[UserExtensionRequest alloc] init];
    request.type = QueryUserInfoExtension_Full;
    request.needRefresh = YES;
    [[GetCore(UserCore) queryExtensionUserInfoByWithUserID:self.userID requests:@[request]] subscribeNext:^(id x) {
        @strongify(self);
        if ([x isKindOfClass:[UserInfo class]]) {
            self.userInfo = (UserInfo *)x;
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(refreshTableViewHeaderWithUserInfo:)]) {
                [self.delegate refreshTableViewHeaderWithUserInfo:self.userInfo];
            }
            [self.tableView reloadData];
        }
    }];
}

- (void)requestGameDataForWeek{
    [[GetCore(CPGameCore) requestGameListDataForPersonPage:self.userID] subscribeError:^(NSError *error) {
        [UIView showToastInKeyWindow:[NSString stringWithFormat:@"%@",error.domain] duration:2 position:YYToastPositionCenter];
    }];
}

#pragma mark -
#pragma mark getter & setter
- (void)setUserInfo:(UserInfo *)userInfo {
    _userInfo = userInfo;
    if (userInfo.hallId > 0) {
        [GetCore(GuildCore) requestGuildHallInfoWithOwnUid:@(self.userInfo.uid).stringValue];
    }
    [self.tableView reloadData];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 84 + kSafeAreaBottomHeight)];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
        [_tableView registerClass:[TTMinePhotoCell class] forCellReuseIdentifier:NSStringFromClass([TTMinePhotoCell class])];
        [_tableView registerClass:[TTMineInfoSignCell class] forCellReuseIdentifier:NSStringFromClass([TTMineInfoSignCell class])];
        [_tableView registerClass:[TTMineInfoFamilyCell class] forCellReuseIdentifier:NSStringFromClass([TTMineInfoFamilyCell class])];
        [_tableView registerClass:[TTMineInfoVoiceCell class] forCellReuseIdentifier:NSStringFromClass([TTMineInfoVoiceCell class])];
        [_tableView registerClass:[TTMineInfoLittleWorldCell class] forCellReuseIdentifier:NSStringFromClass([TTMineInfoLittleWorldCell class])];
        [_tableView registerClass:[TTMineInfoGuildsCell class] forCellReuseIdentifier:kMineInfoGuildsCellConst];
        [_tableView registerClass:TTMineGameRecordCell.class forCellReuseIdentifier:kMineGameRecordCellConst];
        [_tableView registerClass:TTMineGameApproveCell.class forCellReuseIdentifier:kMineGameApproveCellConst];
    }
    return _tableView;
}

-(TTGameTagSelectView *)gameTagView{
    if (!_gameTagView) {
        _gameTagView = [[TTGameTagSelectView alloc] init];
        _gameTagView.hidden = YES;
        _gameTagView.delegate = self;
    }
    return _gameTagView;
}


@end
