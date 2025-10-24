//
//  LLDynamicHomeController.m
//  XC_TTGameMoudle
//
//  Created by Lee on 2019/12/10.
//  Copyright © 2019 WUJIE INTERACTIVE. All rights reserved.
//

#import "LLDynamicHomeController.h"

#import "BaseNavigationController.h"

#import "TTWKWebViewViewController.h"
#import "TTStatisticsService.h"
//core
#import "AuthCore.h"
#import "AuthCoreClient.h"

//tool
#import "UIView+XCToast.h"
#import "MMSheetView.h"
#import "KEMenuItemTool.h"
#import "KEReportController.h"

//view
#import "LTDynamicCell.h"
//#import "AppDelegate.h"
#import <MJRefresh/MJRefresh.h>
#import "UserCore.h"
#import "AuthCore.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+NTES.h"
#import "UIView+XCToast.h"
#import "TTPopup.h"
#import "LittleWorldCore.h"
#import "LittleWorldCoreClient.h"
#import "XCHUDTool.h"
#import "HostUrlManager.h"
#import "XCHtmlUrl.h"
#import "XCShareView.h"
#import "ShareCore.h"
#import "LittleWorldListModel.h"
#import "XCMediator+TTGameModuleBridge.h"
#import "XCMediator+TTPersonalMoudleBridge.h"
#import "XCMediator+TTAuthModule.h"
#import "XCMediator+TTDiscoverModuleBridge.h"
#import "XCMediator+TTMessageMoudleBridge.h"
#import "LLDynamicDetailController.h"
#import "LLDynamicAnchorOrderAlertView.h"

@interface LLDynamicHomeController ()
<
UITableViewDelegate,
UITableViewDataSource,
LTDynamicCellDelegate,
LittleWorldCoreClient,
XCShareViewDelegate
>
@property (nonatomic, assign) UserID uid;

@property (nonatomic, strong) UserInfo *userInfo;

///我的动态  列表
@property (nonatomic, strong) NSMutableArray *dataArray;
///需要删除的动态
@property (nonatomic, weak) LTDynamicCell *deleteCell;
///当前分页
@property (nonatomic, assign) NSInteger currentPage;
///正在播放音频的模型
@property (nonatomic, weak) CTDynamicModel *playingModel;
///正在播放的cell
@property (nonatomic, weak) LTDynamicCell *playingCell;
///当前正在播放的index
@property (nonatomic, weak) NSIndexPath *playingIndexPath;
///时间过滤条件（列表最小时间），毫秒时间戳
@property (nonatomic, copy) NSString *start;
///需要被刷新的cell
@property (nonatomic, strong) NSMutableArray *reloadCellArr;
///删除评论的IndexPath
@property (nonatomic, strong) NSIndexPath *deleteCommentIndex;
@property (nonatomic, assign) SharePlatFormType platform;//选择的分享平台保存
@property (nonatomic, copy) NSString *nextDynamicID; //
@property (nonatomic, weak) LTDynamicCell *shareCell;
@end

@implementation LLDynamicHomeController

- (BOOL)isHiddenNavBar{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    [self addCore];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.scrollCallback(scrollView);
}

#pragma mark - LifeCycle

- (void)initView {
    self.currentPage = 1;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView.backgroundColor = UIColorFromRGB(0xffffff);
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 200;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 64 + kSafeAreaBottomHeight, 0);
    
    [self.tableView registerClass:[LTDynamicCell class] forCellReuseIdentifier:LTDynamicCellIdentifier];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    self.tableView.tableViewHeightOnScreen = 1;
    [self setupRefreshTarget:self.tableView With:RefreshTypeHeader];
    [self pullDownRefresh:1];
}

- (void)addCore {
    AddCoreClient(LittleWorldCoreClient, self);
}

- (void)loadData {
    [GetCore(LittleWorldCore) requestDynamicListWithWorldID:self.worldID pageNum:self.currentPage dynamicId:0];
}

- (void)refreshData {
    self.currentPage = 1;
    [GetCore(LittleWorldCore) requestDynamicListWithWorldID:self.worldID pageNum:self.currentPage dynamicId:0];
}

- (void)pullDownRefresh:(int)page{
    self.currentPage = page;
    [self refreshData];
}

- (void)pullUpRefresh:(int)page lastPage:(BOOL)isLastPage {
//    [GetCore(LittleWorldCore) requestDynamicListWithWorldID:self.worldID pageNum:self.currentPage dynamicId:[self.nextDynamicID integerValue]];
}

#pragma mark - UITableViewDataSource/UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LTDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:LTDynamicCellIdentifier forIndexPath:indexPath];
    cell.delegate = self;

    CTDynamicModel *model = self.dataArray[indexPath.row];
    cell.dynamicModel = model;
    
    @weakify(self);
    cell.refreshOpenUpHandler = ^(CTDynamicModel *dynamicModel) {
        // 动态刷新展开更多 or 取消展示更多
        @strongify(self);
        [TTStatisticsService trackEvent:@"world_moments_more" eventDescribe:@"动态列表：展开更多"];
        [self.dataArray replaceObjectAtIndex:indexPath.row withObject:dynamicModel];
        
        [UIView performWithoutAnimation:^{
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
    };
    
    cell.albumEmptyAreaHandler = ^{
        @strongify(self)
        [self jumpToDynamicDeatailVcWithDynamicModel:model isShowKeyboard:NO];
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataArray.count<=indexPath.row) {
        return;
    }
    
    self.deleteCell = [tableView cellForRowAtIndexPath:indexPath];
    CTDynamicModel *dynamicModel = self.dataArray[indexPath.row];
    
    [self jumpToDynamicDeatailVcWithDynamicModel:dynamicModel isShowKeyboard:NO];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.dataArray.count - 3) {
        if (self.nextDynamicID) {
            [GetCore(LittleWorldCore) requestDynamicListWithWorldID:self.worldID pageNum:self.currentPage dynamicId:[self.nextDynamicID integerValue]];
        }
    }
}

#pragma mark - LTDynamicCellDelegate
// 点击更多 显示举报-删除
- (void)didClickMoreButtonDynamicCell:(LTDynamicCell *)cell {
    @weakify(self);
    
    NSMutableArray *items = [NSMutableArray array];
    TTActionSheetConfig *report = [TTActionSheetConfig actionWithTitle:@"举报" color:UIColorFromRGB(0xFF3B30) handler:^{
        @strongify(self);
        // 举报
        [TTStatisticsService trackEvent:@"world_report_moments" eventDescribe:@"动态列表：点击举报"];
        TTWKWebViewViewController *vc = [[TTWKWebViewViewController alloc]init];
        NSString *urlstr = [NSString stringWithFormat:@"%@?reportUid=%@&source=WORLDDYNAMIC",HtmlUrlKey(kReportURL), cell.dynamicModel.uid];
        vc.urlString = urlstr;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    TTActionSheetConfig *delete = [TTActionSheetConfig actionWithTitle:@"删除" color:UIColorFromRGB(0xFF3B30) handler:^{
        @strongify(self);
        self.deleteCell = cell;
        // 删除
        [TTStatisticsService trackEvent:@"world_delete_moments" eventDescribe:@"动态列表：点击删除"];
        
        [TTPopup alertWithMessage:@"删除后不可恢复\n确定删除该动态吗？" confirmHandler:^{
            [GetCore(LittleWorldCore) requestDynamicDeleteWitDynamicId:cell.dynamicModel.dynamicId worldId:self.worldID];
        } cancelHandler:^{
            
        }];
        
    }];
    
    NSString *currentUid = GetCore(AuthCore).getUid;
    // 举报
    if (![cell.dynamicModel.uid isEqualToString:currentUid]) {
        [items addObject:report];
    }
    
    if ([cell.dynamicModel.uid isEqualToString:currentUid] ||
        [self.worldItem.ownerUid isEqualToString:currentUid]) {
        [items addObject:delete];
    }
    
    [TTPopup actionSheetWithItems:items.copy showCancelItem:YES];
}

// 跳转个人页
- (void)didClickUserActionWithUserUid:(NSString *)uid communityCell:(LTDynamicCell *)cell{
    UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_personalViewController:[uid userIDValue]];
    [self.navigationController pushViewController:vc animated:YES];
}
// 点赞
- (void)myVestDynamicCell:(LTDynamicCell *)cell clickLaudButtonCallBackWith:(BOOL)isLaud {

    [GetCore(LittleWorldCore) requestDynamicLikeWitDynamicId:cell.dynamicModel.dynamicId worldId:self.worldID isLike:isLaud dynamicUid:cell.dynamicModel.uid completion:^(BOOL success, NSString * _Nonnull errorMsg) {
        
        if (success) {
            cell.dynamicModel.isLike = !cell.dynamicModel.isLike;
            
            NSInteger likeCount = [cell.dynamicModel.likeCount integerValue];
            likeCount += (cell.dynamicModel.isLike ? 1 : -1);
            likeCount = MAX(likeCount, 0);
            cell.dynamicModel.likeCount = [NSString stringWithFormat:@"%ld", (long)likeCount];
            
            [cell updateLikeButtonStatus];
            
            if (cell.dynamicModel.isLike) {
                [TTStatisticsService trackEvent:@"world_like_moments" eventDescribe:@"点赞动态:动态列表"];
                [TTStatisticsService trackEvent:@"world_like_moments_b" eventDescribe:self.worldItem.name];
                [TTStatisticsService trackEvent:@"world_like_moments_c" eventDescribe:@"点赞动态:点赞"];
           } else {
               [TTStatisticsService trackEvent:@"点赞动态" eventDescribe:@"点赞动态:取消赞"];
           }
        }
    }];
}

// 点击评论
- (void)didClickCommentButtonWithMyVestDynamicCell:(LTDynamicCell *)cell {
    CTDynamicModel *dynamicModel = cell.dynamicModel;
    [TTStatisticsService trackEvent:@"world_comment_moments" eventDescribe:@"动态列表：点击评论"];
    [TTStatisticsService trackEvent:@"world_comment_moments_b" eventDescribe:self.worldItem.name];
    [self jumpToDynamicDeatailVcWithDynamicModel:dynamicModel isShowKeyboard:YES];
    self.deleteCell = cell;
}

// 点击分享
- (void)didClickShareButtonWithMyVestDynamicCell:(LTDynamicCell *)cell {
    [TTStatisticsService trackEvent:@"world_share_moments" eventDescribe:@"动态列表：点击分享"];
    
    if (cell.dynamicModel.status == 0) {
        return; // 未通过的动态，不给分享
    }
    
    CGSize itemSize = CGSizeMake((KScreenWidth-2*22)/4, 76);
    
    self.shareCell = cell;
    
    XCShareView *shareView = [[XCShareView alloc] initWithShareViewStyle:XCShareViewStyleCenterAndBottom items:[self getShareItems] itemSize:itemSize edgeInsets:UIEdgeInsetsMake(12, 22, 12, 22)];
    
    shareView.delegate = self;
    
    [TTPopup popupView:shareView style:TTPopupStyleActionSheet];
}

// 点击评论
- (void)jumpDynamicDetailsWithReplyComment:(CTCommentReplyModel*)comment communityCell:(LTDynamicCell *)cell {
    
    [self jumpToDynamicDeatailVcWithDynamicModel:cell.dynamicModel
                                  isShowKeyboard:comment!=nil];
}

///点击主播订单
- (void)didClickAnchorOrderDynamicCell:(LTDynamicCell *)cell {
    
    [TTStatisticsService trackEvent:@"world_moment_chat_b" eventDescribe:@"小世界"];

    if ([GetCore(AuthCore).getUid isEqualToString:cell.dynamicModel.uid]) {
        return;
    }
    
    UIViewController *vc = [[XCMediator sharedInstance] ttMessageMoudle_TTSessionViewController:[cell.dynamicModel.uid userIDValue] sessectionType:NIMSessionTypeP2P];
    [self.navigationController pushViewController:vc animated:YES];
}

///点击主播订单问号
- (void)didClickAnchorOrderMarkDynamicCell:(LTDynamicCell *)cell {
    
    [TTStatisticsService trackEvent:@"world_order_explain" eventDescribe:@"小世界动态列表"];
    
    //订单问号
    LLDynamicAnchorOrderAlertView *alert = [[LLDynamicAnchorOrderAlertView alloc] init];
    [alert showAlert];
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

- (void)handShare:(SharePlatFormType)shareType {
    
    CTDynamicModel *dynamicModel = self.shareCell.dynamicModel;
    // 构建分享数据
    
    ShareDynamicInfo *dynamicInfo = [[ShareDynamicInfo alloc] init];
    
    dynamicInfo.nick = dynamicModel.nick;
    dynamicInfo.dynamicID = [NSString stringWithFormat:@"%ld", (long)dynamicModel.dynamicId];
    dynamicInfo.worldID = dynamicModel.worldId;
    dynamicInfo.content = dynamicModel.content;
    dynamicInfo.shareUid = dynamicModel.uid;
    
    if (dynamicInfo.content.length == 0) {
        dynamicInfo.content = @"点击查看动态详情";
    }
    dynamicInfo.iconUrl = dynamicModel.avatar;
    
    if (dynamicModel.dynamicResList.count > 0) {
        // 如果动态中有发布图片，就改为动态中的第一张图
        LLDynamicImageModel *imageModel = [dynamicModel.dynamicResList firstObject];
        dynamicInfo.iconUrl = imageModel.resUrl;
    }
    
    ShareModelInfor *model = [[ShareModelInfor alloc] init];
    model.currentVC = self;
    model.shareType = Custom_Noti_Sub_Dynamic_ShareDynamic;
    model.dynamicInfo = dynamicInfo;
    [GetCore(ShareCore) reloadShareModel:model];

    if (shareType == Share_Platfrom_Type_Within_Application) {
        // 分享到好友
        UIViewController * controller = [[XCMediator sharedInstance] ttDiscoverMoudle_TTFamilyShareContainViewController];
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        // 分享到第三方平台
        
        NSString *iconUrl = dynamicModel.avatar; // 默认图片是用户的头像
        if (dynamicModel.dynamicResList.count > 0) {
            // 如果动态中有发布图片，就改为动态中的第一张图
            LLDynamicImageModel *imageModel = [dynamicModel.dynamicResList firstObject];
            iconUrl = imageModel.resUrl;
        }
        NSString *urlStr = [NSString stringWithFormat:@"%@%@?uid=%@&dynamicId=%ld&worldId=%@",[HostUrlManager shareInstance].hostUrl,
                            HtmlUrlKey(kLittleWorldDynamicShareURL),
                            GetCore(AuthCore).getUid,
                            (long)dynamicModel.dynamicId,
                            dynamicModel.worldId];
        
        [GetCore(ShareCore) shareDynamicH5WithNick:dynamicModel.nick
                                       dynamicText:dynamicModel.content
                                       dynamicIcon:iconUrl
                                          shareUrl:urlStr
                                          platform:shareType];
    }
}

- (void)shareViewDidClickCancle:(XCShareView *)shareView {
    [TTPopup dismiss];
}

#pragma mark - LittleWorldCoreClient

/// 获取动态详情列表成功
/// @param modelList 动态详情
/// @param nextDynamicId 下个动态id
- (void)requestDynamicListSuccess:(NSArray<CTDynamicModel *> *)modelList nextDynamicId:(nonnull NSString *)nextDynamicId{

    [TTStatisticsService trackEvent:@"world_reading_volume" eventDescribe:@"动态阅读量"];
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
    if (self.currentPage == 1) {
        self.dataArray = [NSMutableArray arrayWithArray:modelList];
        self.currentPage += 1;
    } else {
        [self.dataArray addObjectsFromArray:modelList];
        self.currentPage += 1;
        
//        if (modelList.count == 0) {
//            [self.tableView.mj_footer endRefreshingWithNoMoreData];
//        }
    }
    
    if (self.dataArray.count == 0) {
        [self.tableView showEmptyContentToastWithTitle:@"这个小世界的历史由你撰写~" andImage:[UIImage imageNamed:@"common_noData_empty"]];
    } else {
        [self.tableView hideToastView];
    }

    self.nextDynamicID = modelList.count == 0 ? nil : nextDynamicId;
    
    [self.tableView reloadData];
}

- (void)requestDynamicListFailth:(NSString *)message {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    if (self.dataArray.count == 0) {
        [self.tableView showEmptyContentToastWithTitle:@"这个小世界的历史由你撰写~" andImage:[UIImage imageNamed:@"common_noData_empty"]];
    }
    [UIView hideToastView];
}

- (void)requestDynamicGetSquareSuccess:(NSArray<CTDynamicModel *> *)modelList {
    if (self.type != LLDynamicSquareTypePlayground) return;
//    [self.view hiddenLoading];
    [self.tableView.mj_header endRefreshing];
    modelList.count == 0 ? [self.tableView.mj_footer endRefreshingWithNoMoreData] : [self.tableView.mj_footer endRefreshing];
    [self.dataArray addObjectsFromArray:modelList];
    [UIView performWithoutAnimation:^{
        [self.tableView reloadData];
    }];
}

- (void)requestDynamicGetSquareFailth:(NSString *)msg {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [UIView hideToastView];
}

- (void)requestDynamicDeleteSuccess{
    
    [UIView hideHUD];
    
    // 防止多次响应 拦截为空时不进行处理
    if (!self.deleteCell) {
        return;
    }
    
    [self.dataArray removeObject:self.deleteCell.dynamicModel];
    [self.tableView reloadData];
    self.deleteCell = nil;

//    NSIndexPath *indexPath = [self.tableView indexPathForCell:self.deleteCell];
//    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    if (self.dataArray.count == 0) {
        [self.tableView showEmptyContentToastWithTitle:@"这个小世界的历史由你撰写~" andImage:[UIImage imageNamed:@"common_noData_empty"]];
    }
}

- (void)requestDynamicDeleteFailth:(NSString *)message {
}

#pragma mark - 私有方法

///跳转到详情
- (void)jumpToDynamicDeatailVcWithDynamicModel:(CTDynamicModel *)dynamicModel isShowKeyboard:(BOOL)isShowKeyboard {
    
    if (isShowKeyboard) { // 如果是评论跳转
        if (![self userPhoneBindStatus]) {
            return; // 未绑定手机
        }
    }
    
    LLDynamicDetailController *detailsVc = [[LLDynamicDetailController alloc]init];
    detailsVc.dynamicId = dynamicModel.dynamicId;
    detailsVc.worldId = dynamicModel.worldId;
    detailsVc.worldUid = dynamicModel.worldUid;
    detailsVc.isShowKeyboard = isShowKeyboard;
    detailsVc.isWorldDynamic = YES;

    [self.navigationController pushViewController:detailsVc animated:YES];
}

/// 用户资料的手机绑定状态
- (BOOL)userPhoneBindStatus {
    UserInfo *userInfo = [GetCore(UserCore) getUserInfoInDB:[GetCore(AuthCore).getUid longLongValue]];
    if (!userInfo.isBindPhone) {
        
        TTAlertMessageAttributedConfig *msgConfig = [[TTAlertMessageAttributedConfig alloc] init];
        msgConfig.text = @"绑定手机号";
        msgConfig.font = [UIFont boldSystemFontOfSize:15];
        
        TTAlertConfig *config = [[TTAlertConfig alloc] init];
        config.message = @"为了营造更安全的网络环境发布评论需先 绑定手机号";
        config.messageAttributedConfig = @[msgConfig];
        config.confirmButtonConfig.title = @"前往";
        
        @weakify(self);
        [TTPopup alertWithConfig:config confirmHandler:^{
            @strongify(self);
            UIViewController *vc = [[XCMediator sharedInstance] ttAuthMoudle_bindPhoneAlertViewController:^{
                [GetCore(AuthCore) logout];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        } cancelHandler:^{
        }];
    }
    
    return userInfo.isBindPhone;
}

#pragma mark - get/set

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)reloadCellArr {
    if (!_reloadCellArr) {
        _reloadCellArr = [NSMutableArray array];
    }
    return _reloadCellArr;
}
@end
