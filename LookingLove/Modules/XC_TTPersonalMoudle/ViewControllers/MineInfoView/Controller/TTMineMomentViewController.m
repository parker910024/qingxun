//
//  TTMineMomentViewController.m
//  XC_TTPersonalMoudle
//
//  Created by lvjunhang on 2019/11/25.
//  Copyright © 2019 WUJIE INTERACTIVE. All rights reserved.
//

#import "TTMineMomentViewController.h"

#import "TTMineMomentCell.h"

#import "XCMediator+TTGameModuleBridge.h"
#import "XCMediator+TTDiscoverModuleBridge.h"
#import "XCMediator+TTMessageMoudleBridge.h"

#import "LittleWorldCore.h"
#import "LittleWorldCoreClient.h"
#import "ShareCore.h"
#import "ShareCoreClient.h"
#import "AuthCore.h"
#import "UserCore.h"

#import "XCHUDTool.h"
#import "TTPopup.h"
#import "XCShareView.h"
#import "UIViewController+EmptyDataView.h"
#import "XCCurrentVCStackManager.h"
#import "NSArray+Safe.h"
#import "XCTheme.h"
#import "XCHtmlUrl.h"
#import "TTStatisticsService.h"
#import "TTWKWebViewViewController.h"
#import "HostUrlManager.h"

#import <Masonry/Masonry.h>

static NSString *const kCellID = @"kCellID";

static NSInteger const kRequestSize = 20;

@interface TTMineMomentViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
LittleWorldCoreClient,
XCShareViewDelegate
>

@property (nonatomic, strong) NSMutableArray<UserMoment *> *dataArray;

@property (nonatomic, assign) NSInteger requestPage;

/// 正在操作对象的索引（删除、举报等）
@property (nonatomic, strong) NSIndexPath *handleIndexPath;

/// 选择的分享平台保存
@property (nonatomic, assign) SharePlatFormType platform;
@property (nonatomic, strong) UserMoment *shareMoment; // 分享专用
@end

@implementation TTMineMomentViewController

- (void)dealloc {
    RemoveCoreClientAll(self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AddCoreClient(LittleWorldCoreClient, self);
    
    [self initViews];
    [self initConstraints];
    
    [self pullDownRefresh:0];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSString *des = self.mineInfoStyle == TTMineInfoViewStyleDefault ? @"个人主页主态页" : @"个人主页客态页";
    [TTStatisticsService trackEvent:@"homepage_moment" eventDescribe:des];
}

#pragma mark - override
- (void)pullDownRefresh:(int)page {
    self.requestPage = 1;
    [self requestData];
}

- (void)pullUpRefresh:(int)page lastPage:(BOOL)isLastPage {
    
    if (isLastPage) {
        return;
    }
    
    [self requestData];
}

- (BOOL)isHiddenNavBar {
    return YES;
}

/**
 点击失败占位图时的重载方法
 */
- (void)reloadDataWhenLoadFail {
    [self pullDownRefresh:0];
}

#pragma mark - Layout
- (void)initViews {
    self.tableView.backgroundColor = UIColor.clearColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableView.tableViewHeightOnScreen = 1;
    [self setupRefreshTarget:self.tableView With:RefreshTypeHeaderAndFooter];
    
    [self.tableView registerClass:[TTMineMomentCell class] forCellReuseIdentifier:kCellID];
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 20)];
}

- (void)initConstraints {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11, *)) {
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.edges.mas_equalTo(0);
        }
    }];
}

#pragma mark - Request
- (void)requestData {
    NSString *types = @"0,2";
    [GetCore(LittleWorldCore) requestUserMomentListForUid:@(self.userID).stringValue
                                                    types:types
                                                     page:self.requestPage
                                                 pageSize:kRequestSize];
}

#pragma mark - Private
/// 更多操作
- (void)moreActionHandleWithModel:(UserMoment *)model indexPath:(NSIndexPath *)indexPath {

    BOOL forMe = self.mineInfoStyle == TTMineInfoViewStyleDefault;
    self.handleIndexPath = forMe ? indexPath : nil;
    
    NSString *title = forMe ? @"删除" : @"举报";
    TTActionSheetConfig *config = [TTActionSheetConfig actionWithTitle:title color:UIColorFromRGB(0xFF3B30) handler:^{
        
        if (forMe) {
            [self deleteDynamicWithModel:model];
        } else {
            [self reportDynamicWithModel:model];
        }
    }];
    [TTPopup actionSheetWithItems:@[config]];
}

/// 删除动态
- (void)deleteDynamicWithModel:(UserMoment *)model {
    [TTPopup alertWithMessage:@"小世界动态也会同步删除哦\n确定删除该动态吗?" confirmHandler:^{
        [GetCore(LittleWorldCore) requestDynamicDeleteWitDynamicId:(long)model.dynamicId.longLongValue worldId:model.worldId];
    } cancelHandler:^{
        
    }];
    
    [TTStatisticsService trackEvent:@"world_delete_moments" eventDescribe:@"删除动态:个人主页"];
}

/// 举报
- (void)reportDynamicWithModel:(UserMoment *)model {
    TTWKWebViewViewController *vc = [[TTWKWebViewViewController alloc]init];
    NSString *urlstr = [NSString stringWithFormat:@"%@?reportUid=%@&source=PERSONAL_DYNAMIC",HtmlUrlKey(kReportURL), @(self.userID).stringValue];
    vc.urlString = urlstr;
    [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:vc animated:YES];

    [TTStatisticsService trackEvent:@"world_report_moments" eventDescribe:@"举报动态:个人主页"];
}

/// 分享
- (void)shareDynamicWithModel:(UserMoment *)model {
    
    self.shareMoment = model;
    CGSize itemSize = CGSizeMake((KScreenWidth-2*22)/4, 76);

    XCShareView *shareView = [[XCShareView alloc] initWithShareViewStyle:XCShareViewStyleCenterAndBottom items:[self getShareItems] itemSize:itemSize edgeInsets:UIEdgeInsetsMake(12, 22, 12, 22)];
    
    shareView.delegate = self;
    
    [TTPopup popupView:shareView style:TTPopupStyleActionSheet];
}

- (NSArray<XCShareItem *>*)getShareItems {

    BOOL installWeChat = [GetCore(ShareCore) isInstallWechat];
    BOOL installQQ = [GetCore(ShareCore) isInstallQQ];

    XCShareItem *tutuItem = [XCShareItem itemWitTag:XCShareItemTagAppFriends title:@"好友" imageName:@"share_friend" disableImageName:@"share_friend" disable:NO];

    XCShareItem *momentItem = [XCShareItem itemWitTag:XCShareItemTagMoments title:@"朋友圈" imageName:@"share_wxcircle" disableImageName:@"share_wxcircle_disable" disable:!installWeChat];
    XCShareItem *weChatItem = [XCShareItem itemWitTag:XCShareItemTagWeChat title:@"微信好友" imageName:@"share_wx" disableImageName:@"share_wx_disable" disable:!installWeChat];
    XCShareItem *qqZoneItem = [XCShareItem itemWitTag:XCShareItemTagQQZone title:@"QQ空间" imageName:@"share_qqzone" disableImageName:@"share_qqzone_disable" disable:!installQQ];
    XCShareItem *qqItem = [XCShareItem itemWitTag:XCShareItemTagQQ title:@"QQ好友" imageName:@"share_qq" disableImageName:@"share_qq_disable" disable:!installQQ];

    return @[tutuItem,momentItem,weChatItem,qqZoneItem,qqItem];
}

#pragma mark - XCShareViewDelegate
- (void)shareView:(XCShareView *)shareView didSelected:(XCShareItemTag)itemTag {
    SharePlatFormType sharePlatFormType;
    
    [TTPopup dismiss];
    
    switch (itemTag) {
        case XCShareItemTagAppFriends:
            sharePlatFormType = Share_Platfrom_Type_Within_Application;
            break;
        case XCShareItemTagMoments:
            sharePlatFormType = Share_Platform_Type_Wechat_Circle;
            break;
        case XCShareItemTagWeChat:
            sharePlatFormType = Share_Platform_Type_Wechat;
            break;
        case XCShareItemTagQQZone:
            sharePlatFormType = Share_Platform_Type_QQ_Zone;
            break;
        case XCShareItemTagQQ:
            sharePlatFormType = Share_Platform_Type_QQ;
            break;
        default:
            sharePlatFormType = Share_Platform_Type_Wechat_Circle;
            break;
    }
    [self handShare:sharePlatFormType];
}

- (void)shareViewDidClickCancle:(XCShareView *)shareView {
    [TTPopup dismiss];
}

- (void)handShare:(SharePlatFormType)shareType {

    UserInfo *info = [GetCore(UserCore) getUserInfoInDB:[GetCore(AuthCore).getUid userIDValue]];

    ShareDynamicInfo *dynamicInfo = [[ShareDynamicInfo alloc] init];
    dynamicInfo.nick = info.nick;
    dynamicInfo.dynamicID = self.shareMoment.dynamicId;
    dynamicInfo.worldID = self.shareMoment.worldId;
    dynamicInfo.content = self.shareMoment.content;
    dynamicInfo.shareUid = [NSString stringWithFormat:@"%lld", self.userID];
    if (dynamicInfo.content.length == 0) {
        dynamicInfo.content = @"点击查看动态详情";
    }
    dynamicInfo.iconUrl = info.avatar;
    
    if (self.shareMoment.type == UserMomentTypePic) {
        UserMomentRes *res = [self.shareMoment.dynamicResList firstObject];
        dynamicInfo.iconUrl = res.resUrl;
    }
    
    ShareModelInfor *model = [[ShareModelInfor alloc] init];
    model.currentVC = self;
    model.shareType = Custom_Noti_Sub_Dynamic_ShareDynamic;
    model.dynamicInfo = dynamicInfo;
    
    [GetCore(ShareCore) reloadShareModel:model];
    
    if (shareType == Share_Platfrom_Type_Within_Application) {
        
        UIViewController * controller = [[XCMediator sharedInstance] ttDiscoverMoudle_TTFamilyShareContainViewController];
        [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:controller animated:YES];

        
    } else {
    
        NSString *iconUrl = info.avatar; // 默认图片是用户的头像
        if (self.shareMoment.type == UserMomentTypePic) {
            UserMomentRes *res = [self.shareMoment.dynamicResList firstObject];
            iconUrl = res.resUrl;
        }
        
        NSString *urlStr = [NSString stringWithFormat:@"%@%@?uid=%@&dynamicId=%@&worldId=%@",[HostUrlManager shareInstance].hostUrl, HtmlUrlKey(kLittleWorldDynamicShareURL), GetCore(AuthCore).getUid, self.shareMoment.dynamicId, self.shareMoment.worldId];
        
        [GetCore(ShareCore) shareDynamicH5WithNick:info.nick
                                       dynamicText:self.shareMoment.content
                                       dynamicIcon:iconUrl
                                          shareUrl:urlStr
                                          platform:shareType];
    }
}

#pragma mark - LittleWorldCoreClient
- (void)responseUserMomentList:(NSArray<UserMoment *> *)data uid:(NSString *)uid code:(NSNumber *)code msg:(NSString *)msg {

    [XCHUDTool hideHUD];

    if (self.userID != uid.longLongValue) {
        return;
    }
    
    if (self.requestPage == 1) {
        [self.tableView endRefreshStatus:0 hasMoreData:YES];
        [self.tableView endRefreshStatus:1 hasMoreData:YES];

        [self.dataArray removeAllObjects];
    }
    
    /// When Network Error
    if (code == nil && msg.length > 0) {
        
        [XCHUDTool showErrorWithMessage:msg];
        if (self.dataArray.count > 0) {
            return;
        }
        
        [self showEmptyDataViewWithTitle:msg image:[UIImage imageNamed:@"common_no_network"] offsetY:-80 view:self.tableView complete:nil];
        return;
    }
    
    /// When Servers Send Error
    if (code != nil) {
        
        [XCHUDTool showErrorWithMessage:msg];
        if (self.dataArray.count > 0) {
            return;
        }
        
        [self showEmptyDataViewWithTitle:msg image:[UIImage imageNamed:@"common_noData_empty"] offsetY:-80 view:self.tableView complete:nil];

        return;
    }
    
    /// When No Data
    if (self.dataArray.count == 0 && data.count == 0) {
        
        [self showEmptyDataViewWithTitle:@"暂无数据" image:[UIImage imageNamed:@"common_noData_empty"] offsetY:-80 view:self.tableView complete:nil];
        return;
    }
    
    NSAssert(data != nil, @"Getting Datas Unexpected");
    [self removeEmptyDataView];
    
    self.requestPage += 1;
    
    BOOL hasMoreData = data.count >= kRequestSize;
    [self.tableView endRefreshStatus:1 hasMoreData:hasMoreData];
    
    [self.dataArray addObjectsFromArray:data];
    [self.tableView reloadData];
}

- (void)requestDynamicDeleteSuccess {
    
    [XCHUDTool showSuccessWithMessage:@"已删除"];
    
    if (self.handleIndexPath) {
        [self.dataArray removeObjectAtIndex:self.handleIndexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[self.handleIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        if (self.dataArray.count == 0) {
            [self pullDownRefresh:0];
        }
    }
            
    self.handleIndexPath = nil;
}

- (void)requestDynamicListFailth:(NSString *)message {
    self.handleIndexPath = nil;
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

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.scrollCallback(scrollView);
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UserMoment *model = [self.dataArray safeObjectAtIndex:indexPath.row];

    TTMineMomentCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID forIndexPath:indexPath];
    cell.hidenTimelineView = self.dataArray.count - 1 == indexPath.row;
    cell.model = model;
    
    @weakify(self)
    @weakify(cell)
    cell.worldBlock = ^{
        UIViewController *vc = [[XCMediator sharedInstance] ttGameMoudle_TTWorldletContainerViewControllerWithWorldId:model.worldId isFromRoom:NO];
        [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:vc animated:YES];
        
        NSString *des = [NSString stringWithFormat:@"进入小世界客态页-小世界：%@", model.tag];
        [TTStatisticsService trackEvent:@"world_view_wolrd_page_b" eventDescribe:des];
        [TTStatisticsService trackEvent:@"world_view_wolrd_page" eventDescribe:@"进入小世界客态页-个人主页"];
    };
    cell.likeBlock = ^{
        @strongify(cell)
        @strongify(self)
        //dynamicUid被赞用户uid，这里传当前信息页的主人uid
        [GetCore(LittleWorldCore) requestDynamicLikeWitDynamicId:model.dynamicId.integerValue worldId:model.worldId isLike:!model.isLike dynamicUid:@(self.userID).stringValue completion:^(BOOL success, NSString * _Nonnull errorMsg) {
            
            if (success) {
                model.isLike = !model.isLike;
                
                NSInteger likeCount = model.likeCount;
                likeCount += (model.isLike ? 1 : -1);
                likeCount = MAX(likeCount, 0);
                model.likeCount = likeCount;
                
                [cell updateLikeButtonStatus];
                
                if (model.isLike) {
                    [TTStatisticsService trackEvent:@"world_like_moments" eventDescribe:@"点赞动态:个人主页"];
                }
            }
        }];
    };
    cell.commentBlock = ^{
        UIViewController *vc = [[XCMediator sharedInstance] ttGameMoudle_TTDynamicDetailViewControllerWithWorldID:model.worldId?:@"" dynamicID:model.dynamicId?:@"" comment:YES];
        [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:vc animated:YES];
        
        [TTStatisticsService trackEvent:@"world_comment_moments" eventDescribe:@"评论按钮:个人主页"];
        [TTStatisticsService trackEvent:@"world_moments_details" eventDescribe:@"动态详情:个人主页"];
    };
    cell.shareBlock = ^{
        @strongify(self)
        [self shareDynamicWithModel:model];
        
        [TTStatisticsService trackEvent:@"world_share_moments" eventDescribe:@"分享动态:个人主页"];
    };
    cell.moreBlock = ^{
        @strongify(self)
        @strongify(cell)
        //注意：使用实时获取realtimeIndexPath
        //由于indexPath被block捕获，当多次删除后，捕获的indexPath不会改变
        //导致删错cell，甚至crash
        NSIndexPath *realtimeIndexPath = [tableView indexPathForCell:cell];
        [self moreActionHandleWithModel:model indexPath:realtimeIndexPath];
    };
    cell.foldBlock = ^{
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    };
    cell.tapAnchorOrderHandler = ^{
        @strongify(self)
        if (GetCore(AuthCore).getUid.userIDValue == self.userID) {
            return;
        }
        
        UIViewController *vc = [[XCMediator sharedInstance] ttMessageMoudle_TTSessionViewController:self.userID sessectionType:NIMSessionTypeP2P];
        [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:vc animated:YES];
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UserMoment *model = [self.dataArray safeObjectAtIndex:indexPath.row];
    if (model.type == UserMomentTypeGreeting) {
        //打招呼的不跳转
        return;
    }
    
    UIViewController *vc = [[XCMediator sharedInstance] ttGameMoudle_TTDynamicDetailViewControllerWithWorldID:model.worldId?:@"" dynamicID:model.dynamicId?:@"" comment:NO];
    [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:vc animated:YES];
    
    [TTStatisticsService trackEvent:@"world_moments_details" eventDescribe:@"动态详情:个人主页"];
}

#pragma mark - Lazy Load
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
