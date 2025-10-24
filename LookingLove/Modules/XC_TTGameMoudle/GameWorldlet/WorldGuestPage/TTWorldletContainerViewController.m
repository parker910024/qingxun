//
//  TTWorldletContainerViewController.m
//  XC_TTGameMoudle
//
//  Created by apple on 2019/6/27.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTWorldletContainerViewController.h"

/** 类内部 view(cell) */
#import "LittleWorldCoreClient.h"
/** module 内 view(cell)（业务组件自定义view） */
#import "TTWorldletNavView.h"
#import "TTWorldletHeaderView.h"
#import "TTDressUpBuyOrPresentSuccessView.h"
#import "TTWorldletBottomView.h"

#import "TTWorldletJoinSuccessAlertView.h"
#import "TTWorldletNoChatGroupAlertView.h"
#import "TTWorldletGroupFullAlertView.h"
#import "TTWorldletJoinGroupConfirmAlertView.h"

/** module 内 工具类（业务组件的工具类）*/
#import "XCMacros.h" // 约束的宏定义
#import "UIImageView+QiNiu.h"  // 加载图片
#import "XCTheme.h" // 颜色设置的宏定义
#import "XCHUDTool.h"
#import "XCHtmlUrl.h"
#import "TTStatisticsService.h"

/** VC */
#import "TTWorldletMainViewController.h"
#import "TTWorldletEditViewController.h"
/** bridge */
#import "XCMediator+TTMessageMoudleBridge.h"
#import "XCMediator+TTDiscoverModuleBridge.h"
#import "XCMediator+TTRoomMoudleBridge.h"
#import "XCMediator+TTAuthModule.h"

/** xc_tt（兔兔私有组件） */
#import "TTWKWebViewViewController.h"
#import "TTPopup.h"
#import "TTNewbieGuideView.h"

/** xc类 （平台公共组件） */
#import "TTItemMenuView.h"
#import "AuthCore.h"
#import "LittleWorldCore.h"
#import "NSString+Utils.h"
#import "ShareCore.h"
#import "XCHtmlUrl.h"
/** 第三方工具（第三方pod） */
#import <Masonry/Masonry.h> // 约束
#import <JXCategoryView/JXCategoryView.h>
#import <JXPagingView/JXPagerView.h>
#import <JXPagingView/JXPagerListRefreshView.h>
#import "TTPopup.h"
#import "XCShareView.h"
#import "LLPostDynamicViewController.h"
#import "UIView+NTES.h"
#import "AuthCore.h"
#import "UserCore.h"

#import "LLDynamicDetailController.h"
#import "LLDynamicHomeController.h"

static CGFloat const kBottomToolBarViewHeight = 64;

@interface TTWorldletContainerViewController ()<TTWorldletNavViewDelegate,TTItemMenuViewDelegate,
LittleWorldCoreClient,TTWorldletHeaderViewDelegate, JXPagerViewDelegate,
JXCategoryViewDelegate, TTWorldletBottomViewDelegate, XCShareViewDelegate>

@property (nonatomic, strong) TTWorldletNavView *navView;
@property (nonatomic, strong) TTWorldletHeaderView *headerView;
@property (nonatomic, strong) TTWorldletBottomView *bottomView;
@property (nonatomic, assign) SharePlatFormType platform;//选择的分享平台保存

@property (nonatomic, strong) TTWorldletMainViewController *mainVC;
@property (nonatomic, strong) LittleWorldListItem *model;
@property (nonatomic, strong) LLDynamicHomeController *homeVc;

@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXCategoryIndicatorLineView *lineView;
@property (nonatomic, strong) JXPagerView *pagerView;
@property (nonatomic, strong) NSArray<NSString *> *titles;

// 加入小世界
@property (nonatomic, strong) UIButton *joinWorldletBtn;
// 阴影view
@property (nonatomic, strong) UIView *joinBtnShadowView;
@end

@implementation TTWorldletContainerViewController

- (void)dealloc {
    RemoveCoreClientAll(self);
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.hiddenNavBar = YES;
    [self initView];
    [self initContrait];

    AddCoreClient(LittleWorldCoreClient, self);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [GetCore(LittleWorldCore) requestWorldLetDetailDataWithUid:self.worldId uid:GetCore(AuthCore).getUid.userIDValue];
    
    [GetCore(LittleWorldCore) requestWorldPartyRoomListWithWorldId:self.worldId];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)initView {

    [self.view addSubview:self.pagerView];

    [self.view addSubview:self.navView];
    [self.view addSubview:self.bottomView];
    
    [self addChildViewController:self.mainVC];
    [self addChildViewController:self.homeVc];
    
    [self.view addSubview:self.joinBtnShadowView];
    [self.view addSubview:self.joinWorldletBtn];
    
    [TTStatisticsService trackEvent:@"world_view_wolrd_page_b" eventEnd:@"进入小世界"];
    self.navigationController.interactivePopGestureRecognizer.enabled = (self.categoryView.selectedIndex == 0);
}

- (void)initContrait {
    
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(kNavigationHeight);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(kBottomToolBarViewHeight + kSafeAreaBottomHeight);
    }];
    
    [self.joinWorldletBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).inset(kSafeAreaBottomHeight + 20);
        make.width.mas_equalTo(160);
        make.height.mas_equalTo(55);
    }];
    
    [self.joinBtnShadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.joinWorldletBtn);
        make.bottom.right.mas_equalTo(self.joinWorldletBtn).offset(5);
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.pagerView.frame = self.view.bounds;
}

#pragma mark - JXPagerViewDelegate
- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.headerView;
}

- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    CGFloat headerViewHeight = [self.headerView height];
    return headerViewHeight + kNavigationHeight;
}

- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return 46;
}

- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.categoryView;
}

- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    return self.titles.count;
}

- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    UIViewController *viewController;
    switch (index) {
        case 0:
        {
            viewController = self.homeVc;
        }
            break;
        case 1:
        {
            viewController = self.mainVC;
        }
            break;
        default:
            break;
    }
    return (id <JXPagerViewListViewDelegate>) viewController;
}

- (void)mainTableViewDidScroll:(UIScrollView *)scrollView {
    [self.headerView scrollViewDidScroll:scrollView.contentOffset.y];
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    if (index == 0) { // 动态列表
        [TTStatisticsService trackEvent:@"world_page_notice" eventDescribe:@"世界动态"];
    } else if (index == 1) { // 世界通知
        [TTStatisticsService trackEvent:@"world_page_notice" eventDescribe:@"世界通告"];
    }
}

#pragma mark - LittleWorldCoreClient
- (void)responseWorldletGuestPage:(LittleWorldListItem *)model {
    
    _model = model;
    
    _headerView.model = model;
    _bottomView.model = model;
    _homeVc.worldItem = model;
    _mainVC.isFromRoom = self.isFromRoom;
    _mainVC.model = model;
    
    self.joinWorldletBtn.hidden = model.inWorld;
    self.joinBtnShadowView.hidden = model.inWorld;
    self.bottomView.hidden = !model.inWorld;
    
    [self.pagerView resizeTableHeaderViewHeightWithAnimatable:NO duration:0.3 curve:UIViewAnimationCurveEaseIn];
}

- (void)responseWorldletGuestPageFail:(NSString *)message resCode:(NSNumber *)recCode {
    //小世界不存在
    if (recCode.integerValue == 7903) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/// 嗨玩派对房间（语音派对列表）
- (void)responseWorldPartyRoomList:(NSArray<LittleWorldPartyRoom *> *)data code:(NSNumber *)errorCode msg:(NSString *)msg {
    
    if (errorCode || msg) {
        return;
    }
    
    self.headerView.partyRoomList = data;
    
    if (self.headerView.model) {
        [self.pagerView resizeTableHeaderViewHeightWithAnimatable:NO duration:0.3 curve:UIViewAnimationCurveEaseIn];
    }
}

/**
 加入小世界群聊
 @param errorCode 7907:人数达到3人之后才能生成群聊，还差x人，快去邀请好友加入吧,
                  7908:哎呀，群聊人满暂时加不进来啦~
 */
- (void)responseWorldGroupJoinSuccess:(BOOL)success code:(NSNumber *)errorCode msg:(NSString *)msg {
    
    [XCHUDTool hideHUD];
    
    if (success) {
        //设置加入群聊标识
        self.model.inGroupChat = YES;
        
        //跳转群聊
        [self pushGroupChatViewWithSessionId:self.model.tid];
        
        NSString *des = [NSString stringWithFormat:@"加入群聊，小世界：%@", self.model.name];
        [TTStatisticsService trackEvent:@"world_join_group" eventDescribe:des];
        return;
    }
    
    if ([errorCode isEqualToNumber:@(7907)]) {
        //群成员不足
        TTWorldletNoChatGroupAlertView *alert = [[TTWorldletNoChatGroupAlertView alloc] initWithFrame:CGRectMake(0, 0, 280, 285)];
        alert.content = msg;
        alert.enterActionBlock = ^{
            [self inviteFriend];
            [TTPopup dismiss];
        };
        alert.browseActionBlock = ^{
            [TTStatisticsService trackEvent:@"world-page-talk-next time" eventDescribe:@"世界客态页-群成员不足下次再说"];
            [TTPopup dismiss];
        };
        [TTPopup popupView:alert style:TTPopupStyleAlert];
        return;
    }
    
    if ([errorCode isEqualToNumber:@(7908)]) {
        //群满员
        TTWorldletGroupFullAlertView *alert = [[TTWorldletGroupFullAlertView alloc] initWithFrame:CGRectMake(0, 0, 280, 210)];
        alert.name = self.model.groupChatName;
        alert.enterActionBlock = ^{
            [TTPopup dismiss];
        };
        [TTPopup popupView:alert style:TTPopupStyleAlert];
        return;
    }
    
    [XCHUDTool showErrorWithMessage:msg];
}

/**
 获取世界分享图片
 */
- (void)responseWorldSharePic:(NSString *)data code:(NSNumber *)errorCode msg:(NSString *)msg {
        
    [XCHUDTool hideHUD];
    
    if (msg.length > 0) {
        [XCHUDTool showErrorWithMessage:msg];
        return;
    }
    
    if (![data isKindOfClass:[NSString class]]) {
        [XCHUDTool showErrorWithMessage:@"获取分享图片失败"];
        return;
    }
    
    if (data.length == 0) {
        [XCHUDTool showErrorWithMessage:@"获取分享图片失败"];
        return;
    }
    
    [GetCore(ShareCore) shareH5WithTitle:nil url:nil imgUrl:data desc:nil platform: self.platform];
}

#pragma mark - LittleWorldWoreToastClient
- (void)smallSecretaryJoinWorldletSuccessWithWorldId:(long long)worldId isFromRoom:(BOOL)isFromRoom {
    [TTStatisticsService trackEvent:@"world-page-enter-world" eventDescribe:@"世界客态页-加入世界成功"];
    
    if (GetCore(AuthCore).getUid.userIDValue == self.model.ownerUid.userIDValue) {
        return;
    }
    
    if (worldId == self.model.worldId.userIDValue) {
        
        [TTStatisticsService trackEvent:@"world-page-enter-world" eventDescribe:@"世界客态页-加入世界成功"];
        [GetCore(LittleWorldCore) requestWorldLetDetailDataWithUid:self.model.worldId uid:GetCore(AuthCore).getUid.userIDValue];
        
        [GetCore(LittleWorldCore) removeDictWithKey:self.model.worldId];
    }
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
    [self handleShare:sharePlatFormType];
}

- (void)shareViewDidClickCancle:(XCShareView *)shareView {
    [TTPopup dismiss];
}


#pragma mark  --- TTItemMenuViewDelegate 菜单代理 ---
- (void)menuView:(TTItemMenuView *)addMenuView didSelectedItem:(TTItemMenuItem *)item {
    !item.itemClickHandler ? : item.itemClickHandler();
}

#pragma mark - TTWorldletBottomViewDelegate
// 进入群聊
- (void)enterChatBtnClick:(TTWorldletBottomView *_Nonnull)view {
    
    if (!self.model.inGroupChat) {
        //未加入群聊
        @weakify(self)
        TTWorldletJoinGroupConfirmAlertView *alert = [[TTWorldletJoinGroupConfirmAlertView alloc] initWithFrame:CGRectMake(0, 0, 280, 230)];
        alert.name = self.model.groupChatName;
        alert.enterActionBlock = ^{
            @strongify(self)
            //请求加入群聊
            [XCHUDTool showGIFLoading];
            [GetCore(LittleWorldCore) requestWorldGroupJoinWithWorldId:self.model.worldId];
            [TTPopup dismiss];
        };
        [TTPopup popupView:alert style:TTPopupStyleAlert];
        return;
    }
    
    if (self.model.memberNum < 3) {
        //小世界人数不足三人
        TTWorldletNoChatGroupAlertView *alert = [[TTWorldletNoChatGroupAlertView alloc] initWithFrame:CGRectMake(0, 0, 280, 285)];
        alert.content = @"人数达3人才可生成群聊\n快去邀请好友吧";
        alert.enterActionBlock = ^{
            [self inviteFriend];
            [TTPopup dismiss];
        };
        alert.browseActionBlock = ^{
            [TTStatisticsService trackEvent:@"world-page-talk-next time" eventDescribe:@"世界客态页-群成员不足下次再说"];
            [TTPopup dismiss];
        };
        [TTPopup popupView:alert style:TTPopupStyleAlert];
        return;
    }
        
    //跳转群聊
    [self pushGroupChatViewWithSessionId:self.model.tid];
}

// 小世界成员
- (void)worldletMemberBtnClick:(TTWorldletBottomView *_Nonnull)view {
    
    UIViewController *memberVC = [[XCMediator sharedInstance] ttMessageMoudle_TTLittleWorldMemberViewControllerWith:self.model.worldId userType:[self.model.ownerUid userIDValue] == GetCore(AuthCore).getUid.userIDValue ? TTWorldletCreater : TTWorldletNormal];
    
    [self.navigationController pushViewController:memberVC animated:YES];
}

// 加入小世界
- (void)joinWorldletBtnClick:(TTWorldletBottomView *_Nonnull)view {
    
    [TTStatisticsService trackEvent:@"world-page-join-world" eventDescribe:@"世界客态页-加入世界"];
    
    @weakify(self)
    [[GetCore(LittleWorldCore) requestJoinWorldLetWithUid:self.model.worldId uid:GetCore(AuthCore).getUid.userIDValue isFromRoom:self.isFromRoom] subscribeError:^(NSError *error) {
        [XCHUDTool showErrorWithMessage:error.domain];
    } completed:^{
        
        @strongify(self)
        if (self.model.agreeFlag) {
            [XCHUDTool showSuccessWithMessage:@"申请成功，等待审核"];
            
            [GetCore(LittleWorldCore).littleDict setObject:GetCore(AuthCore).getUid forKey:self.model.worldId];
            
            [GetCore(LittleWorldCore) saveLittleDict];
            return;
        }
        
        [GetCore(LittleWorldCore) requestWorldLetDetailDataWithUid:self.worldId uid:GetCore(AuthCore).getUid.userIDValue];

        //加入小世界成功
        TTWorldletJoinSuccessAlertView *alert = [[TTWorldletJoinSuccessAlertView alloc] initWithFrame:CGRectMake(0, 0, 280, 270)];
        alert.name = self.model.name;
        alert.enterActionBlock = ^{
            //请求加入群聊
            [XCHUDTool showGIFLoading];
            [GetCore(LittleWorldCore) requestWorldGroupJoinWithWorldId:self.model.worldId];
            [TTPopup dismiss];
        };
        alert.browseActionBlock = ^{
            [TTPopup dismiss];
        };
        [TTPopup popupView:alert style:TTPopupStyleAlert];
    }];
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

// 发布小世界动态
- (void)postLittleWorldDynamicBtnClick:(TTWorldletBottomView *)view {
    // 跳转发布页
    
    if (![self userPhoneBindStatus]) {
        return; // 如果没有绑定手机。就进行绑定手机跳转
    }
    
    LLPostDynamicViewController *vc = [[LLPostDynamicViewController alloc] initWithWorldId:self.model.worldId worldName:self.model.name];
    @weakify(self);
    vc.refreshDynamicBlock = ^{
        @strongify(self);
        [self.homeVc refreshData];
    };
    
    [self.navigationController pushViewController:vc animated:YES];
    
    NSString *des = [NSString stringWithFormat:@"发布动态:小世界客态页-%@", _model.name];
    [TTStatisticsService trackEvent:@"world_publish_moments" eventDescribe:des];
    [TTStatisticsService trackEvent:@"world_publish_moments_b" eventDescribe:@"发布动态:小世界客态页"];

}

#pragma mark  --- TTWorldletNavViewDelegate 导航条代理 ---
// 返回
- (void)didClickBackBtnAction:(TTWorldletNavView *)view {
    [self.navigationController popViewControllerAnimated:YES];
}

// 更多
- (void)didClickMenuBtnAction:(TTWorldletNavView *)view {
    
    TTItemsMenuConfig * config = [TTItemsMenuConfig creatMenuConfigWithItemHeight:55 menuWidth:150 separatorInset:UIEdgeInsetsMake(0, 0, 0, 0) separatorColor:[XCTheme getTTSimpleGrayColor] backgroudColor:[UIColor whiteColor]];
    
    NSMutableArray * array = [NSMutableArray array];
    // 如果创建的人是自己
    @weakify(self);
    if (GetCore(AuthCore).getUid.userIDValue == [self.model.ownerUid userIDValue]) {
        // 编辑资料
        TTItemMenuItem *editItem = [TTItemMenuItem creatWithTitle:@"编辑资料" iconName:@"gameWorldlet_edit" titleFont:[UIFont systemFontOfSize:15] titleColor:UIColorFromRGB(0x333333) itemClickHandler:^{
            @strongify(self);
            [TTStatisticsService trackEvent:@"world-page-edit-data" eventDescribe:@"世界客态页-编辑资料"];
            // 编辑资料
            TTWorldletEditViewController *editVC = [[TTWorldletEditViewController alloc] init];
            editVC.model = self.model;
            [self.navigationController pushViewController:editVC animated:YES];
        }];
        
        //  解散小世界
        TTItemMenuItem *dissolveItem = [TTItemMenuItem creatWithTitle:@"解散小世界" iconName:@"gameWorldlet_dissolve" titleFont:[UIFont systemFontOfSize:15] titleColor:UIColorFromRGB(0x333333) itemClickHandler:^{
            @strongify(self);
            [TTStatisticsService trackEvent:@"world-page-dissolution-world" eventDescribe:@"世界客态页-解散世界"];
            //  解散小世界
            [TTPopup alertWithMessage:@"解散小世界后所有成员将被移出群聊\n确认解散小世界吗?" confirmHandler:^{
                
                [[GetCore(LittleWorldCore) requestDismissWorldLetWithUid:self.model.worldId uid:GetCore(AuthCore).getUid.userIDValue] subscribeError:^(NSError *error) {
                    [XCHUDTool showErrorWithMessage:error.domain];
                } completed:^{
                    TTDressUpBuyOrPresentSuccessView *buySuccessView = [[TTDressUpBuyOrPresentSuccessView alloc] init];
                    
                    TTPopupService *service = [[TTPopupService alloc] init];
                    
                    service.contentView = buySuccessView;
                    
                    buySuccessView.ensureBlock = ^{
                        [self.navigationController popViewControllerAnimated:YES];
                        [TTPopup dismiss];
                    };
                    
                    buySuccessView.titleString = @"小世界已解散";
                    buySuccessView.imageString = @"common_pop_succeed";
                    buySuccessView.btnSize = CGSizeMake(124, 38);
                    buySuccessView.btnColor = UIColorFromRGB(0xFEF5ED);
                    
                    [TTPopup popupWithConfig:service];
                }];
            } cancelHandler:^{
                
            }];
        }];
        
        [array addObject:editItem];
        [array addObject:dissolveItem];
        
    } else {
        
        TTItemMenuItem *reportitem = [TTItemMenuItem creatWithTitle:@"举报小世界" iconName:@"gameWorldlet_report" titleFont:[UIFont systemFontOfSize:15] titleColor:UIColorFromRGB(0x333333) itemClickHandler:^{
            @strongify(self);
            [TTStatisticsService trackEvent:@"world-page-reporting-world" eventDescribe:@"世界客态页-举报小世界"];
            TTWKWebViewViewController *vc = [[TTWKWebViewViewController alloc]init];
            NSString *urlstr = [NSString stringWithFormat:@"%@?reportUid=%@&source=WORLD",HtmlUrlKey(kReportURL), self.model.ownerUid];
            vc.urlString = urlstr;
            [self.navigationController pushViewController:vc animated:YES];
        }];
        
        TTItemMenuItem *quititem = [TTItemMenuItem creatWithTitle:@"退出小世界" iconName:@"gameWorldlet_exit" titleFont:[UIFont systemFontOfSize:15] titleColor:UIColorFromRGB(0x333333) itemClickHandler:^{
            @strongify(self);
            [TTStatisticsService trackEvent:@"world-page-exit-world" eventDescribe:@"世界客态页-退出小世界"];
            [TTPopup alertWithMessage:@"退出小世界后将被移除群聊\n确认退出吗？" confirmHandler:^{
                
                [[GetCore(LittleWorldCore) requestExitWorldLetWithUid:self.model.worldId uid:GetCore(AuthCore).getUid.userIDValue] subscribeError:^(NSError *error) {
                    
                    [XCHUDTool showErrorWithMessage:error.domain];
                    
                } completed:^{
                    
                    [GetCore(LittleWorldCore) requestWorldLetDetailDataWithUid:self.worldId uid:GetCore(AuthCore).getUid.userIDValue];
                    
                    TTDressUpBuyOrPresentSuccessView *buySuccessView = [[TTDressUpBuyOrPresentSuccessView alloc] init];
                    
                    TTPopupService *service = [[TTPopupService alloc] init];
                    
                    service.contentView = buySuccessView;
                    
                    buySuccessView.ensureBlock = ^{
                        [self.navigationController popViewControllerAnimated:YES];
                        [TTPopup dismiss];
                    };
                    
                    buySuccessView.titleString = @"已退出小世界";
                    buySuccessView.imageString = @"common_pop_succeed";
                    buySuccessView.btnSize = CGSizeMake(124, 38);
                    buySuccessView.btnColor = UIColorFromRGB(0xFEF5ED);
                    
                    [TTPopup popupWithConfig:service];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [TTPopup dismiss];
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                    
                }];
                
            } cancelHandler:^{
                
            }];
        }];
        
        if (self.model.inWorld) {
            [array addObject:reportitem];
            [array addObject:quititem];
        } else {
            [array addObject:reportitem];
        }
    }
    
    TTItemMenuView * meuview = [[TTItemMenuView alloc] initWithFrame:CGRectZero withConfig:config items: [array mutableCopy]];
    meuview.delegate = self;
    [meuview showInView:self.navigationController.view];
}

//  帮助
- (void)didClickHelpBtnAction:(TTWorldletNavView *)view {
    [TTStatisticsService trackEvent:@"world-page-world-notes" eventDescribe:@"世界客态页-世界说明"];
    TTWKWebViewViewController *vc = [[TTWKWebViewViewController alloc]init];
    NSString *urlstr = HtmlUrlKey(kLittleWorldDescriptionURL);
    vc.urlString = urlstr;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - TTWorldletHeaderViewDelegate
// 小世界成员
- (void)numberBtnClickAction:(TTWorldletHeaderView *)view {
    [TTStatisticsService trackEvent:@"world-page-view-members-list" eventDescribe:@" 世界客态页-查看成员列表"];
    if (self.model.inWorld) {
        UIViewController *memberVC = [[XCMediator sharedInstance] ttMessageMoudle_TTLittleWorldMemberViewControllerWith:self.model.worldId userType:[self.model.ownerUid userIDValue] == GetCore(AuthCore).getUid.userIDValue ? TTWorldletCreater : TTWorldletNormal];
        [self.navigationController pushViewController:memberVC animated:YES];
        
    } else {
        [XCHUDTool showErrorWithMessage:@"加入世界才可以查看哦！"];
    }
}

/// 选中语音派对房
- (void)headerView:(TTWorldletHeaderView *)view didSelectedPartyRoom:(LittleWorldPartyRoom *)room {
    if (room == nil || room.roomUid == nil) {
        NSAssert(NO, @"invalid data model");
        return;
    }
    
    [XCMediator.sharedInstance ttRoomMoudle_presentRoomViewControllerWithRoomUid:room.roomUid.longLongValue];
    
    NSString *des = [NSString stringWithFormat:@"加入语音派对-小世界：%@", self.model.name];
    [TTStatisticsService trackEvent:@"world_page_enter_party_b" eventDescribe:des];
    [TTStatisticsService trackEvent:@"world_page_enter_party" eventDescribe:@"加入语音派对:小世界客态页"];
}

#pragma mark - Private
- (void)inviteFriend {
    [TTStatisticsService trackEvent:@"world-page-invite-friends" eventDescribe:@"世界客态页-群成员不足邀请好友"];
    CGSize itemSize = CGSizeMake((KScreenWidth-2*22)/4, 76);

    XCShareView *shareView = [[XCShareView alloc] initWithShareViewStyle:XCShareViewStyleCenterAndBottom items:[self getShareItems] itemSize:itemSize edgeInsets:UIEdgeInsetsMake(12, 22, 12, 22)];
    
    shareView.delegate = self;
    
    [TTPopup popupView:shareView style:TTPopupStyleActionSheet];
}

- (void)handleShare:(SharePlatFormType)platform {
    if (platform == Share_Platfrom_Type_Within_Application) {
        ShareModelInfor *model = [[ShareModelInfor alloc] init];
        model.currentVC = self;
        model.shareType = Custom_Noti_Sub_Share_LittleWorld;
        model.worldletInfor = self.model;
        [GetCore(ShareCore) reloadShareModel:model];
        UIViewController * controller = [[XCMediator sharedInstance] ttDiscoverMoudle_TTFamilyShareContainViewController];
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        
        //保存分享平台
        self.platform = platform;
        
        //获取分享图片
        [XCHUDTool showGIFLoading];
        
        [GetCore(LittleWorldCore) requestWorldSharePicWithWorldId:self.model.worldId];
    }
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

//跳转群聊
- (void)pushGroupChatViewWithSessionId:(NSString *)sessionId {
    UIViewController *vc = [[XCMediator sharedInstance] ttMessageMoudle_TTLittleWorldSessionViewController:sessionId];
    [self.navigationController pushViewController:vc animated:YES];

    NSString *des = [NSString stringWithFormat:@"进入群聊，小世界：%@", self.model.name];
    [TTStatisticsService trackEvent:@"world_page_enter_group_chat_b" eventDescribe:des];
    [TTStatisticsService trackEvent:@"world_page_enter_group_chat" eventDescribe:@"进入群聊-小世界客态页"];
}

- (BOOL)isCurrentViewControllerVisible {
    return (self.isViewLoaded && self.view.window);
}

#pragma mark  --- setter ---

- (TTWorldletNavView *)navView {
    if (!_navView) {
        _navView = [[TTWorldletNavView alloc] init];
        _navView.delegate = self;
    }
    return _navView;
}

- (TTWorldletHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[TTWorldletHeaderView alloc] init];
        _headerView.backgroundColor = UIColorRGBAlpha(0xffffff, 0);
        _headerView.delegate = self;
        _headerView.clipsToBounds = YES;
    }
    return _headerView;
}

- (TTWorldletMainViewController *)mainVC {
    if (!_mainVC) {
        _mainVC = [[TTWorldletMainViewController alloc] init];
    }
    return _mainVC;
}

- (LLDynamicHomeController *)homeVc {
    if (!_homeVc) {
        _homeVc = [[LLDynamicHomeController alloc] init];
        _homeVc.worldID = self.worldId;
    }
    return _homeVc;
}
- (JXCategoryTitleView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 46)];
        _categoryView.titles = self.titles;
        _categoryView.backgroundColor = [UIColor whiteColor];
        _categoryView.delegate = self;
        _categoryView.titleSelectedColor = [XCTheme getTTMainTextColor];
        _categoryView.titleColor = UIColorFromRGB(0xB3B3B3);
        _categoryView.titleSelectedFont = [UIFont boldSystemFontOfSize:16];
        _categoryView.titleFont = [UIFont systemFontOfSize:15];
        _categoryView.titleColorGradientEnabled = YES;
        _categoryView.titleLabelZoomEnabled = NO;
        _categoryView.indicators = @[self.lineView];
        _categoryView.contentScrollView = self.pagerView.listContainerView.collectionView;
        _categoryView.averageCellSpacingEnabled = NO;
        _categoryView.contentEdgeInsetLeft = 20;
        _categoryView.contentEdgeInsetRight = 20;
        _categoryView.cellSpacing = 30;
            //设置圆角
        CGSize radio = CGSizeMake(12, 12);
        UIRectCorner corner = UIRectCornerTopLeft|UIRectCornerTopRight;
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:_categoryView.bounds byRoundingCorners:corner cornerRadii:radio];
        CAShapeLayer *masklayer = [[CAShapeLayer alloc]init];
        masklayer.frame = _categoryView.bounds;
        masklayer.path = path.CGPath;
        _categoryView.layer.mask = masklayer;
    }
    return _categoryView;
}

- (JXCategoryIndicatorLineView *)lineView {
    if (!_lineView) {
        _lineView = [[JXCategoryIndicatorLineView alloc] init];
        _lineView.indicatorColor = [XCTheme getTTMainTextColor];
        _lineView.indicatorWidth = 9;
        _lineView.indicatorHeight = 4;
        _lineView.verticalMargin = 2;
    }
    return _lineView;
}

- (JXPagerView *)pagerView {
    if (!_pagerView) {
        _pagerView = [[JXPagerListRefreshView alloc] initWithDelegate:self];
        _pagerView.listContainerView.collectionView.backgroundColor = UIColor.clearColor;
//        _pagerView.mainTableView.backgroundColor = LLGAMEHOME_BASE_COLOR;
        // 由于这里是隐藏导航栏的做法，所以要减去自定义导航栏的高度。
        _pagerView.pinSectionHeaderVerticalOffset = (NSInteger) kNavigationHeight;
//        _pagerView.frame = self.view.bounds;
    }
    return _pagerView;
}

- (NSArray<NSString *> *)titles {
    if (!_titles) {
        _titles = @[@"世界动态", @"世界公告"];
    }
    return _titles;
}

- (TTWorldletBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[TTWorldletBottomView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.delegate = self;
    }
    return _bottomView;
}


- (UIButton *)joinWorldletBtn {
    if (!_joinWorldletBtn) {
        _joinWorldletBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_joinWorldletBtn setTitle:@"  加入小世界" forState:UIControlStateNormal];
        [_joinWorldletBtn setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateNormal];
        _joinWorldletBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [_joinWorldletBtn setBackgroundColor:[UIColor whiteColor]];
        _joinWorldletBtn.layer.cornerRadius = 55/2;
        _joinWorldletBtn.layer.masksToBounds = YES;
        _joinWorldletBtn.layer.borderColor = [XCTheme getTTMainTextColor].CGColor;
        _joinWorldletBtn.layer.borderWidth = 2.5f;
        [_joinWorldletBtn addTarget:self action:@selector(joinWorldletBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        _joinWorldletBtn.hidden = YES;
    }
    return _joinWorldletBtn;
}

- (UIView *)joinBtnShadowView {
    if (!_joinBtnShadowView) {
        _joinBtnShadowView = [[UIView alloc] init];
        _joinBtnShadowView.backgroundColor = [XCTheme getTTMainColor];
        _joinBtnShadowView.layer.cornerRadius = 55/2;
        _joinBtnShadowView.layer.masksToBounds = YES;
        _joinBtnShadowView.layer.borderColor = [XCTheme getTTMainTextColor].CGColor;
        _joinBtnShadowView.layer.borderWidth = 2.5f;
    }
    return _joinBtnShadowView;
}
@end
