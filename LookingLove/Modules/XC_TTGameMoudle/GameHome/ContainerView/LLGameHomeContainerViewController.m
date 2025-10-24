//
//  LLGameHomeContainerViewController.m
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2019/7/25.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "LLGameHomeContainerViewController.h"

#import "LLGameHomeHeader.h"

#import "LLGameHomeHeaderContainerView.h"
#import "TTGameMenuView.h"

#import "LLGameHomeContainerViewController+Checkin.h"
#import "LLGameHomeContainerViewController+LoginHandle.h"
#import "LLGameHomeContainerViewController+TeenagerModel.h"
#import "LLGoddessViewController.h"
#import "LLVoicePartyViewController.h"
#import "TTVoiceMatchingViewController.h"
#import "TTWorldSquareViewController.h"
#import "TTOppositeSexMatchViewController.h"

#import "XCMediator+TTHomeMoudle.h"
#import "XCMediator+TTPersonalMoudleBridge.h"
#import "XCMediator+TTDiscoverModuleBridge.h"
#import "XCMediator+TTRoomMoudleBridge.h"
#import "XCMediator+TTGameModuleBridge.h"

#import "HomeCore.h"
#import "HomeCoreClient.h"
#import "HomeV5Category.h"
#import "UserCore.h"
#import "UserCoreClient.h"
#import "AuthCore.h"
#import "AuthCoreClient.h"
#import "P2PInteractiveAttachment.h"
#import "LinkedMeClient.h"
#import "CheckinCore.h"
#import "CheckinCoreClient.h"
#import "RoomCoreClient.h"
#import "RoomCoreV2.h"
#import "TTGameStaticTypeCore.h"
#import "ClientCore.h"
#import "CPGameCore.h"
#import "CPGameCoreClient.h"

#import "TTStatisticsService.h"
#import "XCHUDTool.h"
#import "UIView+ZJFrame.h"
#import "TTPopup.h"
#import "UIViewController+EmptyDataView.h"
#import "BaseNavigationController.h"
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+NTES.h"
#import "LookingLoveManager.h"
#import "TTHomeRoomSelectView.h"
#import "TTWKWebViewViewController.h"
#import "TTNewbieGuideView.h"

#import <YYCache/YYCache.h>
#import <Masonry/Masonry.h>
#import <JXPagingView/JXPagerView.h>
#import <JXPagingView/JXPagerListRefreshView.h>
#import <JXCategoryView/JXCategoryView.h>

static CGFloat kCategoryViewHeight = 60.f;
static NSInteger const kHiddenMenuValue = -1;

static NSString *const kOptCategoryCacheName = @"kOptCategoryCacheName";
static NSString *const kOptCategoryStoreKey = @"kOptCategoryStoreKey";

@interface LLGameHomeContainerViewController ()
<
JXPagerViewDelegate,
JXCategoryViewDelegate,
LLGameHomeNavViewDelegate,
LLGameHomeBannerViewDelegate,
LLGameHomeEntranceViewDelegate,
TTOppositeSexMatchViewControllerDelegate,
TTHomeRoomSelectViewDelegate,
LLTeenagerModelAlertViewDelegate,
HomeCoreClient,
CheckinCoreClient,
AuthCoreClient,
UserCoreClient,
LinkedMeClient
>

@property (nonatomic, strong) JXCategoryTitleImageView *categoryView;
@property (nonatomic, strong) JXPagerView *pagingView;
@property (nonatomic, strong) NSArray<NSString *> *titles;

// 头部容器
@property (nonatomic, strong) LLGameHomeHeaderContainerView *headerContainerView;

// 下拉菜单按钮
@property (nonatomic, assign) NSInteger goddessIndex; // 女神男神标签 index
@property (nonatomic, assign) NSInteger lastIndex; // 上次选中的标签

// vc
@property (nonatomic, strong) LLGoddessViewController *goddessViewController;

@property (nonatomic, strong) HomeV5Category *homeV5Category;

@property (nonatomic, strong) TTHomeRoomSelectView *roomSelectView;
@property (nonatomic, strong) TTOppositeSexMatchViewController *matchVC; // 异性匹配弹窗

@property (nonatomic, strong) NSMutableArray<NSString *> *imageNames;

@end

@implementation LLGameHomeContainerViewController

- (void)dealloc {
    RemoveCoreClientAll(self);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [LookingLoveManager lookingLoveHomeWillShow:10];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [LookingLoveManager lookingLoveHomeDidShow:8];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = LLGAMEHOME_BASE_COLOR;
    
    _goddessIndex = kHiddenMenuValue;
    
    [self addCore];
    [self initViews];
    
//    if ([GetCore(AuthCore) isLogin]) {
//        [self requestData];
//        [self needOrNotShowTeenagerView];
//    }
}

- (BOOL)isHiddenNavBar {
    return YES;
}

- (BOOL)isNavRootViewController {
    return YES;
}

/**
 点击失败占位图时的重载方法
 */
- (void)reloadDataWhenLoadFail {
    
    [self removeEmptyDataView];
    [self requestData];
}

#pragma mark - JXPagingViewDelegate
- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.headerContainerView;
}

- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    return (NSUInteger)[self.headerContainerView height];
}

- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return (NSUInteger)kCategoryViewHeight;
}

- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.categoryView;
}

- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    return self.titles.count;
}

- (id <JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    
    id<JXPagerViewListViewDelegate> vc = [self.childViewControllers safeObjectAtIndex:index];
    if ([vc conformsToProtocol:@protocol(JXPagerViewListViewDelegate)]) {
        return vc;
    }
    return nil;
}

- (void)mainTableViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offSetY = scrollView.contentOffset.y;
    CGFloat headerHeight = [self.headerContainerView height];
    CGFloat alpha = (headerHeight - offSetY) / headerHeight;
    
    //当头部向上移动，全部在导航栏以上时，隐藏头部
    //和‘1’比较是因为存在小数点偏差
    if (headerHeight - offSetY - statusbarHeight < 1) {
        alpha = 0;
    }
    
    self.headerContainerView.alpha = alpha;
}

#pragma mark - JXCategoryViewDelegate
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    if (_lastIndex == index &&
        _goddessIndex == index) {
        
        [self showMenuArrowUp];
        [self showDropDownMenu];
    }
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
    
    HomeV5CategoryDetail *cat = [self.homeV5Category.allVo safeObjectAtIndex:index];
    if (cat && cat.name.length > 0) {
        NSString *catName = [NSString stringWithFormat:@"首页-语音派对:%@", cat.name];
        [TTStatisticsService trackEvent:@"home-voice-party" eventDescribe:catName];
    }
    
    //    self.dropDownMenuButton.hidden = !(self.goddessIndex == index);
    // 记录上次的下标
    self.lastIndex = index;
    
    [self resetMenuArrowNormalImage];
}

#pragma mark -
#pragma mark JXCategoryViewDataSource
- (void)showDropDownMenu {
    if(self.goddessIndex < 0){
        return;
    }
    // 构建数据源
    NSArray<TTGameMenuModel *> *items = [self loadItemsData:self.categoryView.titles[self.goddessIndex]];
    
    // 计算frame
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.goddessIndex inSection:0];
    CGRect rect = [[self.categoryView.collectionView cellForItemAtIndexPath:indexPath] convertRect:[self.categoryView.collectionView cellForItemAtIndexPath:indexPath].bounds toView:keyWindow];
    
    // 初始化
    TTGameMenuView *menuView = [[TTGameMenuView alloc] initMenuViewWithItems:items menuRect:CGRectMake(rect.origin.x, rect.origin.y + rect.size.height, 120, 155)];
    // dismiss block
    @weakify(self);
    menuView.dismissBlock = ^{
        @strongify(self);
        [self showMenuArrowDown];
    };
    
    // select block
    menuView.selectBlock = ^(NSInteger index) {
        // 请求刷新数据
        @strongify(self);
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.categoryView.titles];
        
        // 取出有下拉菜单的标签数据
        HomeV5CategoryDetail *categoryDetail = self.homeV5Category.allVo[self.goddessIndex];
        // 下拉菜单中标签数据
        HomeV5CategoryDetailListItem *listItem = categoryDetail.opts[index];
        
        //缓存选择
        YYCache *cache = [YYCache cacheWithName:kOptCategoryCacheName];
        [cache setObject:listItem forKey:kOptCategoryStoreKey];
        
        if (array.count > self.goddessIndex) {
            array[self.goddessIndex] = listItem.name;
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kCategoryItemMenuSelectIndexRefreshDataNoti" object:listItem.type];
        // 埋点
        [TTStatisticsService trackEvent:@"home-goddess-of-harmony" eventDescribe:listItem.name];
        
        self.categoryView.titles = array.copy;
        [self.categoryView reloadData];
    };
    
    // addSubView
    [UIView animateWithDuration:0.2 animations:^{
        [keyWindow addSubview:menuView];
    }];
}

/**
 读取并组成下拉菜单中的数据
 
 @param currentTitle 当前已在显示的标题
 @return 下拉菜单数据
 */

- (NSArray<TTGameMenuModel *> *)loadItemsData:(NSString *)currentTitle {
    HomeV5CategoryDetail *categoryDetail = self.homeV5Category.allVo[self.goddessIndex];
    NSMutableArray<TTGameMenuModel *> *items = [NSMutableArray array];
    
    [categoryDetail.opts enumerateObjectsUsingBlock:^(HomeV5CategoryDetailListItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIColor *color = [XCTheme getTTMainTextColor];
        if ([obj.name isEqualToString:currentTitle]) {
            color = [XCTheme getTTMainColor];
        }
        
        TTGameMenuModel *model = [TTGameMenuModel normalModelWtiTitle:obj.name titleColor:color];
        [items addObject:model];
    }];
    
    return items.copy;
}

#pragma mark - LLGameHomeNavViewDelegate
/** 点击创建我的房间 */
- (void)navViewDidClickCreateRoom:(LLGameHomeNavView *)view {
    
    [self showCreateRoom];
    
    [TTStatisticsService trackEvent:@"openRoom" eventDescribe:@"创建房间按钮"];
}

/** 点击搜索 */
- (void)navViewDidClickSearch:(LLGameHomeNavView *)view {
    @KWeakify(self);
    UIViewController *searchVC = [[XCMediator sharedInstance] ttHomeMoudleBridge_modalRecordSearchRoomControllerWithDismissHandler:^(long long uid) {
        
        @KStrongify(self);
        UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_personalViewController:uid];
        [self.navigationController pushViewController:vc animated:YES];
        
    } enterRoomHandler:^(long long roomUid) {
        [[XCMediator sharedInstance] ttRoomMoudle_presentRoomViewControllerWithRoomUid:roomUid];
    }];
    
    BaseNavigationController *navVC = [[BaseNavigationController alloc] initWithRootViewController:searchVC];
    // iOS 13 也需要全屏展示
    navVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:navVC animated:YES completion:nil];
    
    [TTStatisticsService trackEvent:@"home_search" eventDescribe:@"搜索"];
}

/** 点击签到 */
- (void)navViewDidClickCheckin:(LLGameHomeNavView *)view {
    
    [TTStatisticsService trackEvent:TTStatisticsServiceEventHomeSign eventDescribe:@"签到-首页"];
    
    UIViewController *vc = [[XCMediator sharedInstance] ttDiscoverMoudle_TTCheckinViewController];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - LLGameHomeEntranceViewDelegate
- (void)entranceView:(LLGameHomeEntranceView *)entranceView didSelectItemWithInfo:(BannerInfo *)bannerInfo {
    
    [self routerHandleWithBannerInfo:bannerInfo];
}

- (void)didClickSelectViewItemAtIndex:(NSInteger)index {
    if (index >= self.titles.count) {
        return;
    }
    [self.categoryView selectItemAtIndex:index];
}

#pragma mark - LLGameHomeBannerViewDelegate
- (void)didSelectBannerView:(LLGameHomeBannerView *)view bannerData:(BannerInfo *)data {
    
    [self routerHandleWithBannerInfo:data];
}

#pragma mark -
#pragma mark LLTeenagerModelAlertViewDelegagte
- (void)hiddeView:(LLTeenagerModelAlertView *)view {
    [TTPopup dismiss];
}

- (void)didClickTeenagerButtonAction:(UIButton *)button {
    [TTPopup dismiss];
    // 跳转青少年模式
    UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_TTParentModelViewController];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - layout
- (void)initViews {
    [self.view addSubview:self.pagingView];
}

- (void)initConstraints {
}

- (void)addCore {
    AddCoreClient(AuthCoreClient, self);
    AddCoreClient(UserCoreClient, self);
    AddCoreClient(HomeCoreClient, self);
    AddCoreClient(CheckinCoreClient, self);
    AddCoreClient(LinkedMeClient, self);
    AddCoreClient(CPGameCoreClient, self);
    
    // 用户登录后刷新数据(请求地址信息)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataWhenLoadFail) name:@"kUserLoginSuccessRefreshUserInfoNoti" object:nil];
}

#pragma mark - CoreClients
// 轻寻的首页导航(卡片)和 banner
- (void)responseLLHomeV5CategoryBanner:(HomeV5Category *)data errorCode:(NSNumber *)code msg:(NSString *)msg {
    
    [XCHUDTool hideHUDInView:self.view];
    
    /// When Network Error
    if (code == nil && msg.length > 0) {
        
        [XCHUDTool showErrorWithMessage:msg];
        
        [self showLoadFailViewWithTitle:msg image:[UIImage imageNamed:@"common_no_network"]];
        return;
    }
    
    /// When Servers Send Error
    if (code != nil) {
        
        [XCHUDTool showErrorWithMessage:msg];
        
        [self showLoadFailViewWithTitle:msg image:[UIImage imageNamed:@"common_noData_empty"]];
        return;
    }
    
    // 移除空白占位
    [self removeEmptyDataView];
    
    // 数据处理
    self.homeV5Category = data;
    
    [self.headerContainerView configData:data];
    self.categoryView.titles = [self configFullTagCategoryTitles:data];
    
    [self.categoryView reloadData];
    [self.pagingView reloadData];
    
    [self showMenuArrowDown];
}


#pragma mark -
#pragma mark Event Response
- (void)onClickDropDownMenuButtonAction:(UIButton *)dropDownMenuButton {
    
    // 如果上次的 index 和当前的 index 以及需要展示菜单的 index 一致的话，就显示菜单数据
    
    if (self.lastIndex == self.categoryView.selectedIndex &&
        self.goddessIndex == self.categoryView.selectedIndex) {
        // 显示菜单
        [self showMenuArrowUp];
        [self showDropDownMenu];
    } else {
        [self.categoryView selectItemAtIndex:self.goddessIndex];
    }
}

#pragma mark -
#pragma mark Private Methods
/**
 显示创建房间
 */
- (void)showCreateRoom {
    
    if (!self.roomSelectView.roomShowsView.isHidden) {
        self.roomSelectView.roomShowsView.hidden = YES;
    }
    
    [TTPopup popupView:self.roomSelectView
                 style:TTPopupStyleAlert];
}

/**
 配置标题栏和对应的控制器
 
 @param data 服务器返回的数据
 @return 标题数组
 */
- (NSArray *)configFullTagCategoryTitles:(HomeV5Category *)data {
    
    [self.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromParentViewController];
    }];
    
    __block NSMutableArray<NSString *> *names = [NSMutableArray array];
    __block NSMutableArray<NSNumber *> *imageTypes = [NSMutableArray array];
    __block NSMutableArray<NSString *> *normalImages = [NSMutableArray array];
    __block NSMutableArray<NSString *> *selectImages = [NSMutableArray array];
    
    [data.allVo enumerateObjectsUsingBlock:^(HomeV5CategoryDetail * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        // 男神女神使用一个控制器，另外的声音派对使用的全是相同的控制器，根据类型来处理数据
        if ([obj.name isKindOfClass:[NSString class]] && obj.name.length > 0) {
            
            [names addObject:obj.name]; // 标题
            [imageTypes addObject:@(JXCategoryTitleImageType_OnlyTitle)]; // 标题显示样式
            [normalImages addObject:@""]; // 图片
            [selectImages addObject:@""]; // 选中图片
            
            LLVoicePartyViewController *vc = [[LLVoicePartyViewController alloc] init];
            vc.tabId = obj.tabId;
            vc.view.tag = idx+100;
            [self addChildViewController:vc];
            
        } else if (!obj.name && obj.opts.count > 0) {
            // 和服务的协议好判断没有name且二级菜单有数据的本地处理
                        
            YYCache *cache = [YYCache cacheWithName:kOptCategoryCacheName];
            __block HomeV5CategoryDetailListItem *cacheCategory = (HomeV5CategoryDetailListItem *)[cache objectForKey:kOptCategoryStoreKey];
            
            //匹配存储标签和接口标签type，不能匹配则丢弃cache(防止type值得变化）
            __block BOOL mapCacheCategory = NO;
            
            if ([cacheCategory isKindOfClass:HomeV5CategoryDetailListItem.class]) {
                [obj.opts enumerateObjectsUsingBlock:^(HomeV5CategoryDetailListItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    if ([obj.type isEqualToString:cacheCategory.type]) {
                        mapCacheCategory = YES;
                        cacheCategory = obj;
                        *stop = YES;
                    }
                }];
            }
            
            if (!mapCacheCategory) {
                
                //不能匹配则丢弃cache，赋值默认标签
                cacheCategory = obj.opts.firstObject;
                
                UserInfo *userInfo = [GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue];

                //寻找匹配默认标签
                [obj.opts enumerateObjectsUsingBlock:^(HomeV5CategoryDetailListItem *obj, NSUInteger idx, BOOL *stop) {
                    
                    // 当前用户是男性，且标签类型是女神
                    if (userInfo.gender == UserInfo_Male && obj.type.intValue == 2) {
                        cacheCategory = obj;
                        *stop = YES;
                    }
                    
                    // 当前用户是女性，且标签类型是男神
                    if (userInfo.gender == UserInfo_Female && obj.type.intValue == 1) {
                        cacheCategory = obj;
                        *stop = YES;
                    }
                }];
            }
            
            if (cacheCategory) {
                [cache setObject:cacheCategory forKey:kOptCategoryStoreKey];
                [names addObject:cacheCategory.name];
                self.goddessViewController.labelType = cacheCategory.type.integerValue;
            }
            
            [normalImages addObject:@"home_list_icon_down"]; // 图片
            [selectImages addObject:@"home_list_icon_up"]; // 选中图片
            [imageTypes addObject:@(JXCategoryTitleImageType_RightImage)]; // 标题显示样式
            self.goddessIndex = self.lastIndex = idx;
            // 添加女神男神控制器
            [self addChildViewController:self.goddessViewController];
        }
    }];
    
    self.titles = names.copy;
    
    self.imageNames = selectImages;
    
    self.categoryView.imageTypes = imageTypes;
    self.categoryView.selectedImageNames = normalImages;
    self.categoryView.imageNames = normalImages;
    
    return names.copy;
}

- (void)showMenuArrowDown {
    // 如果是隐藏下拉菜单栏样式，则直接返回
    if ([self isHiddenDorpDownMenu] || self.goddessIndex < 0) {
        return;
    }
    
    self.imageNames[self.goddessIndex] = @"home_list_icon_down";
    self.categoryView.selectedImageNames = self.imageNames;
    [self.categoryView reloadCellAtIndex:self.goddessIndex];
}

- (void)showMenuArrowUp {
    // 如果是隐藏下拉菜单栏样式，则直接返回
    if ([self isHiddenDorpDownMenu] || self.goddessIndex < 0) {
        return;
    }
    
    self.imageNames[self.goddessIndex] = @"home_list_icon_up";
    self.categoryView.selectedImageNames = self.imageNames;
    [self.categoryView reloadCellAtIndex:self.goddessIndex];
}

/**
 重新设置正常状态的箭头图片
 
 菜单处于选中/非选中状态
 */
- (void)resetMenuArrowNormalImage {
    if(self.goddessIndex < 0){
        return;
    }
    
    BOOL isMenu = self.lastIndex == self.goddessIndex;
    NSString *currentImage = self.categoryView.imageNames[self.goddessIndex];
    NSString *newerImage = isMenu ? @"home_list_icon_down" : @"home_list_icon_down_noselect";
    NSMutableArray *normalImages = [self.categoryView.imageNames mutableCopy];
    
    if (![currentImage isEqualToString:newerImage]) {
        normalImages[self.goddessIndex] = newerImage;
        self.categoryView.imageNames = [normalImages copy];
        [self.categoryView reloadCellAtIndex:self.goddessIndex];
    }
}

/**
 是否隐藏下拉菜单
 */
- (BOOL)isHiddenDorpDownMenu {
    return self.goddessIndex == kHiddenMenuValue;
}

- (void)requestData {
    [XCHUDTool showGIFLoadingInView:self.view];
    [GetCore(HomeCore) requestLLHomeV5CategoryBanner];
}

#pragma mark Router Handle
/**
 路由跳转处理
 */
- (void)routerHandleWithBannerInfo:(BannerInfo *)bannerInfo {
    
    if ([bannerInfo.bannerName isEqualToString:@"声音匹配"]) {
        [TTStatisticsService trackEvent:@"home-sound-matching" eventDescribe:@"首页-声音匹配"];
    } else if ([bannerInfo.bannerName isEqualToString:@"游戏匹配"]) {
        [TTStatisticsService trackEvent:@"home-small-game" eventDescribe:@"首页-小游戏"];
    } else if ([bannerInfo.bannerName isEqualToString:@"测一测"] || bannerInfo.skipUri.integerValue == P2PInteractive_SkipType_Test) {
        [TTStatisticsService trackEvent:@"home-test" eventDescribe:@"首页-测一测"];
    }
    
    switch (bannerInfo.skipType) {
            case BannerInfoSkipTypePage: {
                [self inAppJumpHandleWithSkipType:bannerInfo.skipUri.integerValue];
            }
            break;
            case BannerInfoSkipTypeRoom: {
                
                [[XCMediator sharedInstance] ttRoomMoudle_presentRoomViewControllerWithRoomUid:bannerInfo.skipUri.userIDValue];
            }
            break;
            case BannerInfoSkipTypeWeb: {
                
                TTWKWebViewViewController *vc = [[TTWKWebViewViewController alloc]init];
                vc.url = [NSURL URLWithString:bannerInfo.skipUri];
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
        default:
            break;
    }
}

/**
 应用内跳转处理
 */
- (void)inAppJumpHandleWithSkipType:(P2PInteractive_SkipType)skipType {
    switch (skipType) {
            case P2PInteractive_SkipType_UpLoad_VoiceMatching: {
                // 声音匹配
                TTVoiceMatchingViewController *vc = [[TTVoiceMatchingViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
            case P2PInteractive_SkipType_ChatParty: {
                // 嗨聊派对
                [self hiChatBtnMatchClick];
            }
            break;
            case P2PInteractive_SkipType_HeartbeatMatch: {
                // 心跳匹配
                [self oppositeSexBtnMatchClick];
            }
            break;
            case P2PInteractive_SkipType_CityMatch: {
                // 城市匹配
                //TODO 需求未定
            }
            break;
            case P2PInteractive_SkipType_GameMatch: {
                // 游戏匹配 ,跳转全部游戏列表
                [self moreGameBtnClickActionBackMainPageDeal];
            }
            break;
            case P2PInteractive_SkipType_LittleWorld: {
                
                [TTStatisticsService trackEvent:@"home-little-world" eventDescribe:@"首页-小世界"];
                
                // 小世界
                TTWorldSquareViewController *vc = [[TTWorldSquareViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
        default:
            break;
    }
}

#pragma mark - LinkedMeClient
//跳转H5
- (void)jumpInWebViewWithh5Url:(NSString *)h5Url {
    
    TTWKWebViewViewController *webView = [[TTWKWebViewViewController alloc] init];
    webView.urlString = h5Url;
    [self.navigationController pushViewController:webView animated:YES];
}

//跳转到小世界客态页
- (void)jumpInLittleWorldHomePageWithWorldId:(NSString *)worldId {
    
    UIViewController *littleWorldVc = [[XCMediator sharedInstance] ttGameMoudle_TTWorldletContainerViewControllerWithWorldId:worldId isFromRoom:NO];
    
    if ([@"1.4.1" compare:[YYUtility appVersion] options:NSNumericSearch] == NSOrderedDescending){
        //>1.4.1
        [self.navigationController pushViewController:littleWorldVc animated:YES];
    } else {
        //等于1.4.1
        if ([@"1.4.1" isEqualToString:[YYUtility appVersion]]) {
            
            [self.navigationController pushViewController:littleWorldVc animated:YES];
        } else {
            // <1.4.1
            [XCHUDTool showErrorWithMessage:@"请下载最新版本"];
        }
    }
}

- (void)jumpInLittleWorldDynamicDetailPageWithWorldId:(NSString *)worldID dynamicID:(NSString *)dynamicID {
    
    UIViewController *vc = [[XCMediator sharedInstance] ttGameMoudle_TTDynamicDetailViewControllerWithWorldID:worldID
                                                                                                    dynamicID:dynamicID
                                                                                                      comment:NO];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark --- 嗨聊派对 ---
- (void)hiChatBtnMatchClick {
    [TTStatisticsService trackEvent:@"game_homepage_hiparty" eventDescribe:@"游戏首页-嗨聊派对"];
    
    [XCHUDTool showGIFLoadingInView:self.view];
    @weakify(self);
    [[GetCore(CPGameCore) userMatchGuildRoomListWithUid:GetCore(AuthCore).getUid.userIDValue] subscribeNext:^(id x) {
        @strongify(self);
        [XCHUDTool hideHUDInView:self.view];
        if ([x isKindOfClass:[NSArray class]]) {
                NSArray *uids = (NSArray *)x;
                if (uids.count == 0) {
                    [XCHUDTool showErrorWithMessage:@"当前没有嗨聊房"];
                    return;
                }
                
                NSDictionary *dict = [uids firstObject];
                if (dict[@"uid"]) {
                    [[XCMediator sharedInstance] ttRoomMoudle_presentRoomViewControllerWithRoomUid:[dict[@"uid"] userIDValue] andNeedEdgeGesture:YES];
                }
            }
    } error:^(NSError *error) {
        @strongify(self);
        // 青少年模式下进房失败弹窗
        [self showTeenagerAlertView:error];
    }];
}

/**
 * 青少年模式下，显示无法进入房间警告 ⚠️
 * @param error 错误信息
 */
- (void)showTeenagerAlertView:(NSError *)error {
    [XCHUDTool hideHUDInView:self.view];
    if ([error isKindOfClass:[CoreError class]]) {
        CoreError *coreError = (CoreError *) error;
        if (coreError.resCode == 30000) {
            NotifyCoreClient(RoomCoreClient, @selector(roomOnLineTimsMaxWithMessage:), roomOnLineTimsMaxWithMessage:
                coreError.message);
        } else {
            [XCHUDTool showErrorWithMessage:coreError.message];
        }
    }
}

#pragma mark --- 异性匹配 ---
- (void)oppositeSexBtnMatchClick {
    [TTStatisticsService trackEvent:@"game_homepage_matchsex" eventDescribe:@"游戏首页-异性匹配"];
    
    if (GetCore(RoomCoreV2).isInRoom) {
        if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"firstOppositeSex"] isEqualToString:@"FirstOppositeSex"]) {
            [[NSUserDefaults standardUserDefaults] setObject:@"FirstOppositeSex" forKey:@"firstOppositeSex"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            @weakify(self)
            [TTPopup alertWithMessage:@"匹配会退出当前房间并解散用户" confirmHandler:^{
                
                @strongify(self)
                [GetCore(RoomCoreV2) closeRoomWithBlock:GetCore(AuthCore).getUid.userIDValue Success:^(UserID uid) {
                    
                    [[XCMediator sharedInstance] ttRoomMoudle_closeRoomViewController];
                    
                    [GetCore(CPGameCore) userAddOppositeSexMatchPoolWithUid:GetCore(AuthCore).getUid.userIDValue];
                    
                    self.matchVC = [[TTOppositeSexMatchViewController alloc] init];
                    self.matchVC.delegate = self;
                    self.matchVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                    [self.tabBarController presentViewController:self.matchVC animated:NO completion:nil];
                    
                } failure:^(NSNumber *resCode, NSString *message) {
                    
                }];
                
            } cancelHandler:^{
                
            }];
            
            return;
        }else{
            [[XCMediator sharedInstance] ttRoomMoudle_closeRoomViewController];
            [GetCore(CPGameCore) userAddOppositeSexMatchPoolWithUid:GetCore(AuthCore).getUid.userIDValue];
            [self showHeartBeatAnmationViewController]; // 心动匹配
        }
    }else{

        @weakify(self);
        [[GetCore(CPGameCore) RAC_roomOwnerAddOppositeSexMatchPoolWithUid:GetCore(AuthCore).getUid.userIDValue] subscribeNext:^(id x) {
            @strongify(self);
            // 加入队列成功就进行匹配
            if ([x boolValue]) {
                [self showHeartBeatAnmationViewController];
            }
        } error:^(NSError *error) {
            // 青少年模式下弹窗失败，弹窗警告 ⚠️
            [self showTeenagerAlertView:error];
        }];
    }
}

/**
 * 显示心动匹配
 */
- (void)showHeartBeatAnmationViewController {
    self.matchVC = [[TTOppositeSexMatchViewController alloc] init];
    self.matchVC.delegate = self;
    self.matchVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self.tabBarController presentViewController:self.matchVC animated:NO completion:nil];
}

#pragma mark --- TTOppositeSexMatchViewControllerDelegate 异性匹配超时 ---
- (void)oppositeSexMatchTimeoutWith:(TTOppositeSexMatchViewController *)object {
    
    @weakify(self)
    [object dismissViewControllerAnimated:NO completion:^{
        
        @strongify(self)
        
        TTAlertConfig *config = [[TTAlertConfig alloc] init];
        config.title = @"未匹配到用户";
        config.message = @"试下开个陪伴房等异性来撩";
        config.confirmButtonConfig.title = @"创建房间";
        
        [TTPopup alertWithConfig:config confirmHandler:^{
            
            [[XCMediator sharedInstance] ttRoomMoudle_closeRoomViewController];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self companyButtonActionResponse];
            });
            
        } cancelHandler:^{
            
        }];
    }];
}

#pragma mark --- 创建房间选择 ---
- (void)ordinaryButtonActionResponse {
    [TTPopup dismiss];
    
    GetCore(TTGameStaticTypeCore).openRoomStatus = OpenRoomType_Normal;
    [[XCMediator sharedInstance] ttRoomMoudle_openMyRoomByType:3];
    [[BaiduMobStat defaultStat]logEvent:@"game_homepage_cr_ord_click" eventLabel:@"创建普通房"];
}
- (void)companyButtonActionResponse {
    [TTPopup dismiss];
    
    GetCore(TTGameStaticTypeCore).openRoomStatus = OpenRoomType_CP;
    [[XCMediator sharedInstance] ttRoomMoudle_openMyRoomByType:5];
    [[BaiduMobStat defaultStat]logEvent:@"game_homepage_cr_cp_click" eventLabel:@"创建陪伴房"];
}

- (void)touchMaskBackground {
}

#pragma mark -- 全部游戏 --
- (void)moreGameBtnClickActionBackMainPageDeal {
    [TTStatisticsService trackEvent:@"game_homepage_all_game" eventDescribe:@"全部游戏入口"];
    UIViewController *completeVC = [[XCMediator sharedInstance] ttGameMoudle_TTCompleteGameListViewController];
    [self.navigationController pushViewController:completeVC animated:YES];
}

#pragma mark - CPGameCoreClient
// 开启青少年模式成功
- (void)openParentModelSuccess {
    [self reloadDataWhenLoadFail];
}

// 关闭青少年模式成功
- (void)closeParentModelSuccess {
    [self reloadDataWhenLoadFail];
}

#pragma mark - Getters and Setters
- (JXCategoryTitleImageView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[JXCategoryTitleImageView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, kCategoryViewHeight)];
        _categoryView.backgroundColor = UIColor.clearColor;
        _categoryView.collectionView.backgroundColor = UIColor.clearColor;
        _categoryView.titleLabelAnchorPointStyle = JXCategoryTitleLabelAnchorPointStyleCenter;
        
        _categoryView.averageCellSpacingEnabled = NO;
        _categoryView.titleColorGradientEnabled = YES;
        
        _categoryView.titleColor = UIColorFromRGB(0xb3b3b3);
        _categoryView.titleSelectedColor = [XCTheme getTTMainTextColor];
        _categoryView.titleFont = [UIFont systemFontOfSize:15];
        _categoryView.titleSelectedFont = [UIFont systemFontOfSize:15];//见titleLabelSelectedStrokeWidth
        
        _categoryView.titleLabelZoomEnabled = YES;
        //        _categoryView.imageZoomEnabled = YES;
        _categoryView.cellWidthZoomEnabled = YES;
        _categoryView.titleLabelStrokeWidthEnabled = YES;
        _categoryView.titleLabelZoomScale = 1.5;
        //        _categoryView.imageZoomScale = 1.5;
        _categoryView.cellWidthZoomScale = 1.5;
        _categoryView.titleLabelSelectedStrokeWidth = -3;
        
        _categoryView.selectedAnimationEnabled = YES;
        _categoryView.cellSpacing = 20;
        _categoryView.contentEdgeInsetLeft = 20;
        _categoryView.contentEdgeInsetRight = 16;
        
        _categoryView.titles = self.titles;
        _categoryView.delegate = self;
        _categoryView.imageSize = CGSizeMake(10, 20);
        _categoryView.titleImageSpacing = 5;
        _categoryView.contentScrollView = self.pagingView.listContainerView.collectionView;
    }
    return _categoryView;
}

- (JXPagerView *)pagingView {
    if (!_pagingView) {
        _pagingView = [[JXPagerListRefreshView alloc] initWithDelegate:self];
        _pagingView.listContainerView.collectionView.backgroundColor = UIColor.clearColor;
        _pagingView.mainTableView.backgroundColor = LLGAMEHOME_BASE_COLOR;
        // 由于这里是隐藏导航栏的做法，所以要减去自定义导航栏的高度。
        _pagingView.pinSectionHeaderVerticalOffset = statusbarHeight;
        _pagingView.frame = self.view.bounds;
    }
    return _pagingView;
}

- (NSArray<NSString *> *)titles {
    if (!_titles) {
        _titles = @[];
    }
    return _titles;
}

- (LLGameHomeHeaderContainerView *)headerContainerView {
    if (!_headerContainerView) {
        _headerContainerView = [[LLGameHomeHeaderContainerView alloc] init];
        _headerContainerView.navView.delegate = self;
        _headerContainerView.bannerView.delegate = self;
        _headerContainerView.cardEntranceView.delegate = self;
    }
    return _headerContainerView;
}

- (LLGoddessViewController *)goddessViewController {
    if (!_goddessViewController) {
        _goddessViewController = [[LLGoddessViewController alloc] initWithTableViewStyle:UITableViewStyleGrouped];
        _goddessViewController.labelType = 1;
        
        @weakify(self)
        _goddessViewController.didSelectBanner = ^(BannerInfo * _Nonnull info) {
            @strongify(self)
            
            [self routerHandleWithBannerInfo:info];
        };
    }
    return _goddessViewController;
}

- (TTHomeRoomSelectView *)roomSelectView {
    if (!_roomSelectView) {
        _roomSelectView = [[TTHomeRoomSelectView alloc] init];
        _roomSelectView.frame = CGRectMake(0, 0, 311, 311);
        _roomSelectView.backgroundColor = [UIColor clearColor];
        _roomSelectView.delegate = self;
    }
    return _roomSelectView;
}

- (TTCheckinAlertView *)checkinView {
    if (_checkinView == nil) {
        _checkinView = [[TTCheckinAlertView alloc] init];
        @KWeakify(self)
        _checkinView.dismissBlock = ^{
            @KStrongify(self)
            
            if (!self.checkinView.signDetail.isSign) {
                [TTStatisticsService trackEvent:TTStatisticsServiceEventHomePopupSignClosed
                                  eventDescribe:@"签到弹窗关闭按钮(未签到关闭)"];
            }
            
            [self dismissCheckinView];
        };
        _checkinView.checkinBlock = ^{
            @KStrongify(self)
            self.checkinView.checkinButton.userInteractionEnabled = NO;
            
            [TTStatisticsService trackEvent:TTStatisticsServiceEventHomePopupSign eventDescribe:@"签到按钮-签到弹窗"];
            [GetCore(CheckinCore) requestCheckinSign];
        };
        _checkinView.bonusBlock = ^{
            @KStrongify(self)
            
            UIViewController *vc = [[XCMediator sharedInstance] ttDiscoverMoudle_TTCheckinViewController];
            [self.navigationController pushViewController:vc animated:YES];
        };
    }
    return _checkinView;
}

@end

