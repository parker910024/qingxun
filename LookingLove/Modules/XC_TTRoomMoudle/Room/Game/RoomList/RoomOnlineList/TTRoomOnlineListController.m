//
//  TTRoomOnlineListController.m
//  TuTu
//
//  Created by KevinWang on 2018/11/6.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTRoomOnlineListController.h"
#import "TTWKWebViewViewController.h"

//view
#import "TTRoomOnlineNobleHeaderView.h"
#import "TTRoomOnlineCell.h"
#import "TTRoomOnlineNavBar.h"
#import "TTOpenNobleTipCardView.h"

//helper
#import "BaseAttrbutedStringHandler+TTRoomModule.h"
#import "TTNobleSourceHandler.h"
#import "XCTheme.h"

//core
#import "NobleCore.h"
#import "NobleCoreClient.h"
#import "RoomCoreV2.h"
#import "ImRoomCoreV2.h"
#import "ImRoomCoreClientV2.h"
#import "TTRoomUIClient.h"
#import "UserCore.h"
#import "OnLineNobleInfo.h"

#import "UIImageView+QiNiu.h"
#import "XCHUDTool.h"
#import "UIView+XCToast.h"
#import "XCHtmlUrl.h"
#import "NSString+JsonToDic.h"
#import "TTPopup.h"

#import <Masonry/Masonry.h>

#define kGameRoomMaxNobleListCount 60

static NSString *const kCellId = @"kCellId";

@interface TTRoomOnlineListController ()
<
UITableViewDelegate,
UITableViewDataSource,
TTRoomUIClient,
ImRoomCoreClientV2,
NobleCoreClient,
TTRoomOnlineNavBarDelegate,
XCGameRoomListHeaderViewDelegate,
TTOpenNobleTipCardViewDelegate
>

@property (nonatomic, assign) TTRoomOnlineListType listType;//当前初始化列表类型

@property (nonatomic, strong) UIImageView *bgImageView;//背景视图
@property (nonatomic, strong) UIView *coverBgView;//背景遮罩
@property (nonatomic, strong) TTRoomOnlineNavBar *navBar;//自定义导航栏
@property (nonatomic, strong) TTRoomOnlineNobleHeaderView *nobleHeaderView;

@property (nonatomic, strong) NSMutableArray<NIMChatroomMember *> *onlineMemberArray;

@property (nonatomic, assign) int currentPage;

@end

@implementation TTRoomOnlineListController

#pragma mark - Life Cycle
- (instancetype)initWithOnlineListType:(TTRoomOnlineListType)type {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.listType = type;
        
        if (type == TTRoomOnlineListTypeAll) {
            self.title = @"在线列表";
        } else {
            self.title = @"抱TA上麦";
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    
    [self pullDownRefresh:1];
}

- (void)dealloc {
    RemoveCoreClientAll(self);
}

#pragma mark - Override
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)isHiddenNavBar {
    return YES;
}

- (void)pullDownRefresh:(int)page {
    self.currentPage = 1;
    
    if (self.listType == TTRoomOnlineListTypeAll) {
        [GetCore(ImRoomCoreV2) requestChatRoomOnlineMembersWithRefresh:YES];
        
        if (GetCore(ImRoomCoreV2).currentRoomInfo) {
            NSString *uid = @(GetCore(ImRoomCoreV2).currentRoomInfo.uid).stringValue;
            [GetCore(NobleCore) requestRoomNobleUserList:uid];
        }
    } else {
        [GetCore(ImRoomCoreV2) requestChatRoomNoMicMembersWithRefresh:YES];
    }
}

- (void)pullUpRefresh:(int)page lastPage:(BOOL)isLastPage {
    
    if (self.listType == TTRoomOnlineListTypeAll) {
        [GetCore(ImRoomCoreV2) requestChatRoomOnlineMembersWithRefresh:NO];
    } else {
        [GetCore(ImRoomCoreV2) requestChatRoomNoMicMembersWithRefresh:NO];
    }
}

#pragma mark - Public Methods

#pragma mark - System Protocols
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.onlineMemberArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TTRoomOnlineCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId];
    
    NIMChatroomMember *member = [self.onlineMemberArray safeObjectAtIndex:indexPath.row];
    cell.member = member;
    
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NIMChatroomMember *member = [self.onlineMemberArray safeObjectAtIndex:indexPath.row];
    
    if (self.listType == TTRoomOnlineListTypeWithoutMicro) { //抱TA上麦
        [[GetCore(UserCore) getUserInfoByRac:member.userId.userIDValue refresh:NO] subscribeNext:^(id x) {
            UserInfo * info = x;
            if (info.defUser == AccountType_Robot) {
                [XCHUDTool showErrorWithMessage:@"该用户等级过低无法上麦"];
            } else if (GetCore(RoomCoreV2).getCurrentRoomInfo.leaveMode &&
                       info.uid == GetCore(RoomCoreV2).getCurrentRoomInfo.uid) {
                // 如果是离开模式下，抱房主上麦，不被允许
                [XCHUDTool showErrorWithMessage:@"抱房主上麦请先解除离线模式"];
                
            } else {
                if (self.selectUserBlock) {
                    self.selectUserBlock(member.userId.userIDValue);
                }
            }
             [self.navigationController popToRootViewControllerAnimated:NO];
        }];
       
        return;
    }else{
        NSDictionary *nobleDict = [NSString dictionaryWithJsonString:member.roomExt];
        SingleNobleInfo *nobleInfo = [SingleNobleInfo yy_modelWithJSON:nobleDict[member.userId]];
        if (nobleInfo.enterHide) {
            return;
        }
        if ([self.delegate respondsToSelector:@selector(onOnlineList:didSelectWithUid:)]) {
            [self.delegate onOnlineList:self didSelectWithUid:member.userId.userIDValue];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66;
}

#pragma mark - Custom Protocols
#pragma mark TTRoomOnlineNavBarDelegate
- (void)navBarDidNavBack {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UserInfoCardViewDelegate
//关闭用户信息卡
- (void)closeUserInfoCard {
    [TTPopup dismiss];
}

#pragma mark XCGameRoomListHeaderViewDelegate

- (void)gameRoomListHeaderViewShowNobleUserCard:(UserID)uid {
    
    if ([self.delegate respondsToSelector:@selector(onOnlineList:didSelectWithUid:)]) {
        [self.delegate onOnlineList:self didSelectWithUid:uid];
    }
}

- (void)gameRoomListHeaderViewShowOpenNobleTipCard {
    TTOpenNobleTipCardView *cardView = [[TTOpenNobleTipCardView alloc] initWithCurrentLevel:@"平民" doAction:@"" needLevel:@"贵族"];
    cardView.delegate = self;
    [TTPopup popupView:cardView style:TTPopupStyleAlert];
}

#pragma mark - TTOpenNobleTipCardViewDelegate
- (void)openNobleTipCardViewDidGotoOpenNoble:(TTOpenNobleTipCardView *)cardView {
    [TTPopup dismiss];
    
    TTWKWebViewViewController *vc = [[TTWKWebViewViewController alloc] init];
    vc.urlString = HtmlUrlKey(kNobilityIntroURL);
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)openNobleTipCardViewDidClose:(TTOpenNobleTipCardView *)cardView {
    [TTPopup dismiss];
}

#pragma mark - Core Protocols
#pragma mark RoomUIClient
- (void)roomVCWillDisappear {
    [TTPopup dismiss];
}

#pragma mark ImRoomCoreClientV2
- (void)responseChatroomMembersSuccess {
    if (self.currentPage == 1) {
        [self.onlineMemberArray removeAllObjects];
    }
    
    int state = self.currentPage > 1 ? 1 : 0;
    [self.tableView endRefreshStatus:state];
    
    self.currentPage++;
    
    NSArray *members = nil;
    if (self.listType == TTRoomOnlineListTypeAll) {
        members = [GetCore(ImRoomCoreV2).displayMembers copy];
    } else {
        members = [GetCore(ImRoomCoreV2).noMicMembers copy];
    }
    
    members = [self membersRemoveSuperAdmin:members];
    
    if (members && members.count > 0) {
        [self.onlineMemberArray addObjectsFromArray:members];
    }
    
    if (self.onlineMemberArray.count == 0) {
        [self.tableView showEmptyContentToastWithTitle:@"暂无用户" andImage:[UIImage imageNamed:@"common_noData_empty"]];
    } else {
        [self.tableView hideToastView];
    }
    
    [self.tableView reloadData];
}

- (void)responseChatroomMembersError:(NSError *)error {
    int state = self.currentPage > 1 ? 1 : 0;
    [self.tableView endRefreshStatus:state];
    
    NSString *msg = @"获取在线用户列表失败";
    if (error.userInfo[NSLocalizedDescriptionKey]) {
        msg = error.userInfo[NSLocalizedDescriptionKey];
    }
    [XCHUDTool showErrorWithMessage:msg];
}

#pragma mark NobleCoreClient
/**
 贵族列表
 */
- (void)onRequestRoomNobleUserListSuccess:(NSArray *)nubleList {
    [self.tableView endRefreshStatus:0];
    
    NSMutableArray *uids = [NSMutableArray array];
    for (OnLineNobleInfo *noble in nubleList) {
        [uids addObject:@(noble.uid).stringValue];
    }
    
    @weakify(self)
    [GetCore(UserCore) getUserInfos:uids refresh:YES success:^(NSArray *infoArr) {
        
        @strongify(self)
        NSMutableArray *nobles = [NSMutableArray array];
        
        for (UserInfo *userInfo in infoArr) {
            if (userInfo.platformRole == XCUserInfoPlatformRoleSuperAdmin) {
                continue;
            }
            
            for (OnLineNobleInfo *noble in nubleList) {
                if (noble.uid == userInfo.uid) {
                    [nobles addObject:noble];
                }
            }
        }
        
        [self reloadData:[nobles copy]];
    }];
}

- (void)onRequestRoomNobleUserListFailth:(NSString *)msg {
    [self.tableView endRefreshStatus:0];
    [XCHUDTool showErrorWithMessage:@"获取贵族列表失败"];
    
    self.nobleHeaderView.frame = CGRectMake(0, 0, KScreenWidth, 93);
    [self.nobleHeaderView configGameRoomListHeaderView:@[]];
    [self.tableView reloadData];
}

#pragma mark - Event Responses
#pragma mark - Private Methods
- (void)initViews {
    AddCoreClient(ImRoomCoreClientV2, self);
    AddCoreClient(NobleCoreClient, self);
    
    [self.view addSubview:self.navBar];
    
    RoomInfo *room = [GetCore(ImRoomCoreV2) currentRoomInfo];
    if (room.type == RoomType_CP) {
        if (!room.isOpenGame) {
            [self.bgImageView qn_setImageImageWithUrl:room.backPic placeholderImage:@"Room_GameBg" type:ImageTypeUserLibaryDetail];
        }else{
            [self.bgImageView qn_setImageImageWithUrl:room.backPic placeholderImage:@"room_cp_game_bg" type:ImageTypeUserLibaryDetail];
        }
    }else{
        [self.bgImageView qn_setImageImageWithUrl:room.backPic placeholderImage:@"room_bg" type:ImageTypeUserLibaryDetail];
        
    }
    [self.view addSubview:self.bgImageView];
    [self.view addSubview:self.coverBgView];
    
    [self.view bringSubviewToFront:self.tableView];
    [self.view bringSubviewToFront:self.navBar];
    
    [self setupRefreshTarget:self.tableView];
    
    self.tableView.backgroundColor = UIColor.clearColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerClass:TTRoomOnlineCell.class forCellReuseIdentifier:kCellId];
    
    if (self.listType == TTRoomOnlineListTypeAll) {
        self.tableView.tableHeaderView = self.nobleHeaderView;
    }
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [self.coverBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bgImageView);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.navBar.mas_bottom);
        
        if (@available(iOS 11.0, *)) {
            make.left.right.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuide);
        } else {
            make.left.right.bottom.mas_equalTo(self.view);
        }
    }];
}

//过滤超管
- (NSArray *)membersRemoveSuperAdmin:(NSArray<NIMChatroomMember *> *)array {
    
    NSMutableArray *members = [NSMutableArray arrayWithCapacity:array.count];
    for (NIMChatroomMember *member in array) {
        NSDictionary *ext = [NSString dictionaryWithJsonString:member.roomExt];
        NSDictionary *memberInfo = [ext objectForKey:member.userId];
        NSNumber *platformRole = [memberInfo valueForKey:XCChatroomMemberExtPlatformRole];
        
        if (platformRole && platformRole.intValue == XCUserInfoPlatformRoleSuperAdmin) {
            continue;
        }
        
        [members addObject:member];
    }
    
    return [members copy];
}

- (void)reloadData:(NSArray *)nobles {
    
    int comCount = 4;
    NSUInteger row = 0;
    
    if (nobles == nil || nobles.count == 0) {
        row = 1;
    } else {
        if (nobles.count % comCount == 0) {
            row = nobles.count / comCount;
        } else {
            row = nobles.count / comCount+1;
        }
    }
    
    CGFloat height = row * 93;
    height = nobles.count == kGameRoomMaxNobleListCount ? (height+34) : height+10;
    self.nobleHeaderView.frame = CGRectMake(0, 0, KScreenWidth, height);
    
    [self.nobleHeaderView configGameRoomListHeaderView:[nobles copy]];
    [self.tableView reloadData];
}

#pragma mark - Getters and Setters
- (TTRoomOnlineNobleHeaderView *)nobleHeaderView {
    if (_nobleHeaderView == nil) {
        _nobleHeaderView = [[TTRoomOnlineNobleHeaderView alloc] init];
        _nobleHeaderView.frame = CGRectMake(0, 0, KScreenWidth, 93);
        [_nobleHeaderView configGameRoomListHeaderView:@[]];
        _nobleHeaderView.delegate = self;
    }
    return _nobleHeaderView;
}

- (UIImageView *)bgImageView {
    if (_bgImageView == nil) {
        _bgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"room_bg"]];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImageView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
        _bgImageView.backgroundColor = [UIColor blackColor];
        _bgImageView.clipsToBounds = YES;
    }
    return _bgImageView;
}

- (UIView *)coverBgView{
    if (!_coverBgView) {
        _coverBgView = [[UIView alloc] init];
        _coverBgView.backgroundColor = UIColorRGBAlpha(0x000000, 0.2);
    }
    return _coverBgView;
}

- (TTRoomOnlineNavBar *)navBar {
    if (_navBar == nil) {
        _navBar = [[TTRoomOnlineNavBar alloc] init];
        _navBar.delegate = self;
    }
    return _navBar;
}

- (NSMutableArray<NIMChatroomMember *> *)onlineMemberArray {
    if (_onlineMemberArray == nil) {
        _onlineMemberArray = [NSMutableArray array];
    }
    return _onlineMemberArray;
}
@end
