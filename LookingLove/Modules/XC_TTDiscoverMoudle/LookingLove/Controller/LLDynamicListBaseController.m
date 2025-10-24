//
//  LLDynamicListBaseController.m
//  XC_TTDiscoverMoudle
//
//  Created by Lee on 2020/1/6.
//  Copyright © 2020 fengshuo. All rights reserved.
//

#import "LLDynamicListBaseController.h"
#import "BaseNavigationController.h"
#import "TTWKWebViewViewController.h"
#import "TTStatisticsService.h"
//core
#import "CTTabTopicModel.h"
#import "CTDynamicModel.h"
#import "VKCommunityCore.h"
#import "VKCommunityCoreClient.h"
#import "AuthCore.h"
#import "AuthCoreClient.h"
#import "APNSCoreClient.h"
#import "DynamicCommentCore.h"
#import "DynamicCommentCoreClient.h"

//tool
#import "VKPlayerManager.h"
#import "UIView+XCToast.h"

#import "MMSheetView.h"
#import "KEMenuItemTool.h"
#import "KEReportController.h"
//view
#import "LTDynamicCell.h"
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
#import "LLDynamicSquareCell.h"
#import "LLDynamicLayoutModel.h"
#import "LLStatusToolView.h"
#import "LLDynamicAnchorOrderAlertView.h"

@interface LLDynamicListBaseController ()
<
UITableViewDelegate,
UITableViewDataSource,
LittleWorldCoreClient,
XCShareViewDelegate,
LLDynamicSquareCellDelegate,
LLStatusToolViewDelegate
>
@property (nonatomic, assign) UserID uid;

@property (nonatomic, strong) UserInfo *userInfo;

///我的动态  列表
@property (nonatomic, strong) NSMutableArray *dataArray;
///当前分页
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, assign) SharePlatFormType platform;//选择的分享平台保存
@property (nonatomic, copy) NSString *nextDynamicID; //

@property (nonatomic, strong) LLDynamicLayoutModel *currentCellLayout;// 当前选中cell的 layout
@property (nonatomic, strong) UILabel *tipsLabel; // 提示view

@end

@implementation LLDynamicListBaseController

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

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    self.scrollCallback(scrollView);
//}

#pragma mark - LifeCycle

- (void)initView {
    self.currentPage = 1;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView.backgroundColor = UIColorFromRGB(0xFAFAFA);
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;

    [self.tableView registerClass:LLDynamicSquareCell.class forCellReuseIdentifier:@"LLDynamicSquareCell"];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    self.tableView.tableViewHeightOnScreen = 1;
    [self setupRefreshTarget:self.tableView];
    [self pullDownRefresh:1];
}

- (void)addCore {
    AddCoreClient(LittleWorldCoreClient, self);
}

- (void)loadData {
    if (self.type == LLDynamicCircleTypePlayground) {
        [GetCore(LittleWorldCore) requestDynamicSquareRecommendDynamicsWithPage:self.currentPage];
    } else {
        [GetCore(LittleWorldCore) requestDynamicSquareFollowerDynamicsWithDynamicId:@""];
    }
}

- (void)refreshData {
    self.currentPage = 1;
    if (self.type == LLDynamicCircleTypePlayground) {
        [GetCore(LittleWorldCore) requestDynamicSquareRecommendDynamicsWithPage:self.currentPage];
    } else {
        [GetCore(LittleWorldCore) requestDynamicSquareFollowerDynamicsWithDynamicId:@""];
    }
}

- (void)pullDownRefresh:(int)page {
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.currentPage = page;
    
    [self refreshData];
}

- (void)pullUpRefresh:(int)page lastPage:(BOOL)isLastPage{
    if (self.type == LLDynamicCircleTypePlayground) {
        [GetCore(LittleWorldCore) requestDynamicSquareRecommendDynamicsWithPage:self.currentPage];
    } else {
        [GetCore(LittleWorldCore) requestDynamicSquareFollowerDynamicsWithDynamicId:self.nextDynamicID];
    }
}

#pragma mark - UITableViewDataSource/UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LLDynamicModel *model = self.dataArray[indexPath.row];
    model.isRecommendDynamic = self.type == LLDynamicCircleTypePlayground ? YES : NO;
    
    LLDynamicLayoutModel *layout = [LLDynamicLayoutModel layoutWithStatusModel:model];
    layout.isRecommendDynamic = self.type == LLDynamicCircleTypePlayground ? YES : NO;

    LLDynamicSquareCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LLDynamicSquareCell"];
    cell.layout = layout;
    cell.delegate = self;
    cell.worldView.delegate = self;
    
    @weakify(self);
    @weakify(cell);
    cell.openUpBlock = ^{
        @strongify(self);
        
        layout.dynamicModel.isOpenUp = !layout.dynamicModel.isOpenUp;
        [self.dataArray replaceObjectAtIndex:indexPath.row withObject:layout.dynamicModel];
        
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [TTStatisticsService trackEvent:@"world_moments_more" eventDescribe:@"动态-展开内容:动态广场"];
    };
    
    cell.albumEmptyAreaHandler = ^{
        @strongify(self)
        @strongify(cell)
        [TTStatisticsService trackEvent:@"world_moments_details" eventDescribe:@"动态详情-点击动态：动态广场"];
        
        self.currentCellLayout = cell.layout;
        
        [self jumpToDynamicDeatailVcWithDynamicModel:cell.layout.dynamicModel isShowKeyboard:NO indexPath:indexPath];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LLDynamicModel *model = self.dataArray[indexPath.row];
    model.isRecommendDynamic = self.type == LLDynamicCircleTypePlayground ? YES : NO;
    LLDynamicLayoutModel *layout = [LLDynamicLayoutModel layoutWithStatusModel:model];
    return layout.squareRowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataArray.count<=indexPath.row) {
        return;
    }
    
    [TTStatisticsService trackEvent:@"world_moments_details" eventDescribe:@"动态详情-点击动态：动态广场"];
    
    LLDynamicSquareCell *cell = (LLDynamicSquareCell *)[tableView cellForRowAtIndexPath:indexPath];
    self.currentCellLayout = cell.layout;
    
    [self jumpToDynamicDeatailVcWithDynamicModel:cell.layout.dynamicModel isShowKeyboard:NO indexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.dataArray.count - 3) {
        
        if (self.nextDynamicID) {
            [self pullUpRefresh:0 lastPage:NO];
            self.nextDynamicID = nil;
        }
    }
}

#pragma mark - LLDynamicCellDelegate
// cell 上的用户信息view上的事件回调
- (void)didSelectProfileAtCellLayoutModel:(LLDynamicLayoutModel *)layout actionType:(ProfileViewActionType)actionType {
    
    if (actionType == ProfileViewActionTypeProfile) {
        // 跳转个人页
        self.currentCellLayout = layout; // 如果跳转过去后删除了动态，在回调中使用
        UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_personalViewController:[layout.dynamicModel.uid userIDValue]];
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (actionType == ProfileViewActionTypeAnchorChat) {
        
        [TTStatisticsService trackEvent:@"world_moment_chat_b" eventDescribe:@"动态广场"];

        if ([GetCore(AuthCore).getUid isEqualToString:layout.dynamicModel.uid]) {
            return;
        }
        
        UIViewController *vc = [[XCMediator sharedInstance] ttMessageMoudle_TTSessionViewController:[layout.dynamicModel.uid userIDValue] sessectionType:NIMSessionTypeP2P];
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (actionType == ProfileViewActionTypeAnchorMark) {
        //订单问号
        LLDynamicAnchorOrderAlertView *alert = [[LLDynamicAnchorOrderAlertView alloc] init];
        [alert showAlert];
    }
}

// cell 上toolBar 事件点击回调
- (void)didSelectToolBarViewAtCellLayoutModel:(LLDynamicLayoutModel *)layout actionType:(ToolViewActionType)actionType toolView:(LTDynamicToolView *)toolView{
    switch (actionType) {
        case ToolViewActionTypeShare:
            // 分享
            [self didSelectToolBarViewShareBtnAtLayout:layout];
            break;
        case ToolViewActionTypeLike:
            // 点赞
            [self didSelectToolBarViewLikeBtnAtLayout:layout toolView:toolView];
            break;
        case ToolViewActionTypeComment:
            // 评论
            [self didSelectToolBarViewCommentBtnAtLayout:layout];
            break;
        case ToolViewActionTypeMenu:
            // 点击更多 显示举报-删除
            [self didSelectProfileMoreBtnDynamicCellLayout:layout];
            break;
        default:
            break;
    }
}

// 点击更多 显示举报-删除
- (void)didSelectProfileMoreBtnDynamicCellLayout:(LLDynamicLayoutModel *)layout {

    NSMutableArray *items = [NSMutableArray array];

    @weakify(self);
    TTActionSheetConfig *report = [TTActionSheetConfig actionWithTitle:@"举报" color:UIColorFromRGB(0xFF3B30) handler:^{
        @strongify(self);
        // 举报
        [TTStatisticsService trackEvent:@"world_report_moments" eventDescribe:@"动态广场：点击举报"];
        TTWKWebViewViewController *vc = [[TTWKWebViewViewController alloc]init];
        NSString *urlstr = [NSString stringWithFormat:@"%@?reportUid=%@&source=DYNAMIC_SQUARE",HtmlUrlKey(kReportURL), layout.dynamicModel.uid];
        vc.urlString = urlstr;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    TTActionSheetConfig *delete = [TTActionSheetConfig actionWithTitle:@"删除" color:UIColorFromRGB(0xFF3B30) handler:^{
        @strongify(self);
        
        self.currentCellLayout = layout;
        // 删除
        [TTStatisticsService trackEvent:@"world_delete_moments" eventDescribe:@"动态广场：点击删除"];
        
        [TTPopup alertWithMessage:@"删除后不可恢复\n确定删除该动态吗？" confirmHandler:^{
            NSString *worldID = [NSString stringWithFormat:@"%ld", (long)layout.dynamicModel.dynamicId];
            [GetCore(LittleWorldCore) requestDynamicDeleteWitDynamicId:layout.dynamicModel.dynamicId worldId:worldID];
        } cancelHandler:^{
            
        }];
        
    }];
    
    NSString *currentUid = GetCore(AuthCore).getUid;
    // 举报
    if (![layout.dynamicModel.uid isEqualToString:currentUid]) {
        [items addObject:report];
    }
    
    if ([layout.dynamicModel.uid isEqualToString:currentUid] ||
        [self.worldItem.ownerUid isEqualToString:currentUid]) {
        [items addObject:delete];
    }
    
    [TTPopup actionSheetWithItems:items.copy showCancelItem:YES];
}

// 点赞
- (void)didSelectToolBarViewLikeBtnAtLayout:(LLDynamicLayoutModel *)layout toolView:(LTDynamicToolView *)toolView {
    
    NSString *worldID = [NSString stringWithFormat:@"%ld", (long)layout.dynamicModel.dynamicId];
    [GetCore(LittleWorldCore) requestDynamicLikeWitDynamicId:layout.dynamicModel.dynamicId worldId:worldID isLike:!layout.dynamicModel.isLike dynamicUid:layout.dynamicModel.uid completion:^(BOOL success, NSString * _Nonnull errorMsg) {
        
        if (success) {
            layout.dynamicModel.isLike = !layout.dynamicModel.isLike;
            
            NSInteger likeCount = [layout.dynamicModel.likeCount integerValue];
            likeCount += (layout.dynamicModel.isLike ? 1 : -1);
            likeCount = MAX(likeCount, 0);
            layout.dynamicModel.likeCount = [NSString stringWithFormat:@"  %ld", (long)likeCount];
            
            [toolView likeButtonAnimation];
            
            if (layout.dynamicModel.isLike) {
                [TTStatisticsService trackEvent:@"world_like_moments" eventDescribe:@"点赞动态:动态广场"];
                [TTStatisticsService trackEvent:@"world_like_moments_b" eventDescribe:layout.dynamicModel.worldName];
                [TTStatisticsService trackEvent:@"world_like_moments_c" eventDescribe:@"点赞动态:点赞"];
           } else {
               [TTStatisticsService trackEvent:@"点赞动态" eventDescribe:@"点赞动态:取消赞"];
           }
        }
    }];
}

// 评论
- (void)didSelectToolBarViewCommentBtnAtLayout:(LLDynamicLayoutModel *)layout {
    [TTStatisticsService trackEvent:@"world_comment_moments" eventDescribe:@"动态广场：点击评论"];
    [TTStatisticsService trackEvent:@"world_comment_moments_b" eventDescribe:self.worldItem.name];
    [TTStatisticsService trackEvent:@"world_moments_details" eventDescribe:@"动态详情-点击评论：动态广场"];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.dataArray indexOfObject:layout.dynamicModel] inSection:0];
    self.currentCellLayout = layout;
    [self jumpToDynamicDeatailVcWithDynamicModel:layout.dynamicModel isShowKeyboard:YES indexPath:indexPath];
}

//  分享
- (void)didSelectToolBarViewShareBtnAtLayout:(LLDynamicLayoutModel *)layout {
    [TTStatisticsService trackEvent:@"world_share_moments" eventDescribe:@"动态广场：点击分享"];
    
    if (layout.dynamicModel.status == 0) {
        return; // 未通过的动态，不给分享
    }
    
    CGSize itemSize = CGSizeMake((KScreenWidth-2*22)/4, 76);
    
    self.currentCellLayout = layout;
    
    XCShareView *shareView = [[XCShareView alloc] initWithShareViewStyle:XCShareViewStyleCenterAndBottom items:[self getShareItems] itemSize:itemSize edgeInsets:UIEdgeInsetsMake(12, 22, 12, 22)];
    
    shareView.delegate = self;
    
    [TTPopup popupView:shareView style:TTPopupStyleActionSheet];
}

#pragma mark - LLStatusToolViewDelegate
- (void)didSelectActionAtToolView:(LLStatusToolView *)toolView {
    
    UIViewController *vc = [[XCMediator sharedInstance] ttGameMoudle_TTWorldletContainerViewControllerWithWorldId:toolView.layout.dynamicModel.worldId isFromRoom:NO];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - LTDynamicCellDelegate
// 点赞
- (void)myVestDynamicCell:(LTDynamicCell *)cell clickLaudButtonCallBackWith:(BOOL)isLaud {
    
    [GetCore(LittleWorldCore) requestDynamicLikeWitDynamicId:cell.dynamicModel.dynamicId worldId:self.worldID isLike:isLaud dynamicUid:cell.dynamicModel.uid completion:^(BOOL success, NSString * _Nonnull errorMsg) {
        
        if (success) {
            cell.dynamicModel.isLike = !cell.dynamicModel.isLike;
            
            NSInteger likeCount = [cell.dynamicModel.likeCount integerValue];
            likeCount += (cell.dynamicModel.isLike ? 1 : -1);
            likeCount = MAX(likeCount, 0);
            cell.dynamicModel.likeCount = [NSString stringWithFormat:@"  %ld", (long)likeCount];
            
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
    
    LLDynamicModel *dynamicModel = self.currentCellLayout.dynamicModel;
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
- (void)requestDynamicSquareRecommendListSuccess:(NSArray<LLDynamicModel *> *)modelList {
    if (self.type == LLDynamicCircleTypeAttention) {
        return;
    }
    [self dynamicListSuccess:modelList nextDynamicId:@""];
}

- (void)requestDynamicSquareFollowListSuccess:(NSArray<LLDynamicModel *> *)modelList nextDynamicId:(NSString *)nextDynamicId {
    if (self.type == LLDynamicCircleTypePlayground) {
        return;
    }
    
    [self dynamicListSuccess:modelList nextDynamicId:nextDynamicId];
}
/// 获取动态详情列表成功
/// @param modelList 动态详情
/// @param nextDynamicId 下个动态id
- (void)dynamicListSuccess:(NSArray<LLDynamicModel *> *)modelList nextDynamicId:(NSString *)nextDynamicId {
    
    [TTStatisticsService trackEvent:@"world_reading_volume" eventDescribe:@"动态阅读量"];
    
    [self.tableView.mj_header endRefreshing];
    
    if (self.currentPage == 1) {
        self.dataArray = [NSMutableArray arrayWithArray:modelList];
        self.currentPage += 1;
    } else {
        [self.dataArray addObjectsFromArray:modelList];
        self.currentPage += 1;
        
        modelList.count == 0 ? [self.tableView.mj_footer endRefreshingWithNoMoreData] : [self.tableView.mj_footer endRefreshing];
    }
    
    if (self.dataArray.count == 0) {
        [self.tableView showEmptyContentToastWithTitle:@"暂无动态，去推荐看看吧" andImage:[UIImage imageNamed:@"common_noData_empty"]];
    } else {
        [self.tableView hideToastView];
    }

    self.nextDynamicID = modelList.count == 0 ? nil : nextDynamicId;
    self.tableView.tableFooterView = modelList.count == 0 ?  self.tipsLabel : [[UIView alloc] init];
    if (!self.dataArray.count) {
        self.tableView.tableFooterView = [UIView new];
    }
    
    if (!self.dataArray.count) {
        self.tableView.tableFooterView = nil;
    }
    
    [self.tableView reloadData];
}

- (void)requestDynamicListFailth:(NSString *)message {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    if (self.dataArray.count == 0) {
        [self.tableView showEmptyContentToastWithTitle:@"暂无动态，去推荐看看吧" andImage:[UIImage imageNamed:@"common_noData_empty"]];
    }
    [UIView hideToastView];
}

- (void)requestDynamicDeleteSuccess {
    
    [UIView hideHUD];
    
    // 防止多次响应 拦截为空时不进行处理
    if (!self.currentCellLayout) {
        return;
    }
    
    [self.dataArray removeObject:self.currentCellLayout.dynamicModel];
    [self.tableView reloadData];
    self.currentCellLayout = nil;
    
    if (self.dataArray.count == 0) {
        [self.tableView showEmptyContentToastWithTitle:@"暂无动态，去推荐看看吧" andImage:[UIImage imageNamed:@"common_noData_empty"]];
    }
}

- (void)requestDynamicDeleteFailth:(NSString *)message {
}

#pragma mark - 私有方法

///跳转到详情
- (void)jumpToDynamicDeatailVcWithDynamicModel:(LLDynamicModel *)dynamicModel isShowKeyboard:(BOOL)isShowKeyboard indexPath:(NSIndexPath *)indexPath {
    
    if (isShowKeyboard) { // 如果是评论跳转
        if (![self userPhoneBindStatus]) {
            return; // 未绑定手机
        }
    }
    
    if (!dynamicModel) {
        return; // 没有数据就不显示
    }
    
    [TTStatisticsService trackEvent:@"world_view_wolrd_page" eventDescribe:@"动态广场"];
    
    NSString *dynamicID = [NSString stringWithFormat:@"%ld", (long)dynamicModel.dynamicId];
    UIViewController *vc = [[XCMediator sharedInstance] ttGameMoudle_TTDynamicDetailViewControllerWithWorldID:dynamicModel.worldId dynamicID:dynamicID comment:isShowKeyboard block:^(id  _Nonnull data, NSInteger type) {
        
        if ([data isKindOfClass:[LLDynamicModel class]]) {
            
            LLDynamicModel *model = (LLDynamicModel *)data;
            
            if (type == 0) { // 删除
                [self.dataArray removeObject:model];
            } else if (type == 1) { // 刷新
                [self.dataArray replaceObjectAtIndex:indexPath.row withObject:model];
            }
            
            [self.tableView reloadData];
        }
    }];
    
    [self.navigationController pushViewController:vc animated:YES];
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

- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
        _tipsLabel.text = @"————  不要扒拉我，我是底线 ————";
        _tipsLabel.textColor = UIColorFromRGB(0xABAAB3);
        _tipsLabel.font = [UIFont systemFontOfSize:12];
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipsLabel;
}
@end
