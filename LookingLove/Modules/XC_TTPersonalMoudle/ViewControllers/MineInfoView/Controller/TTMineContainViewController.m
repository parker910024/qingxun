//
//  TTMineContainViewController.m
//  TuTu
//
//  Created by lee on 2018/10/29.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTMineContainViewController.h"
// edit
#import "TTPersonEditViewController.h"
#import "TTCarDressUpViewController.h"
#import "XCMediator+TTRoomMoudleBridge.h"
#import "XCMediator+TTMessageMoudleBridge.h"
#import "TTWKWebViewViewController.h"

// childVCs
#import "TTGiftViewController.h"
#import "TTMineInfoViewController.h"
#import "TTCarDressUpShopViewController.h"
#import "TTMineMomentViewController.h"

//view
#import "TTMineInfoView.h"
#import "TTMineInfoBottomView.h"
#import "TTDressUpSelectTabView.h"
#import "ZJScrollPageView.h"
#import "UIButton+EnlargeTouchArea.h"

#import "TTFamilyAlertModel.h"

//core
#import "UserCore.h"
#import "AuthCore.h"
#import "ImFriendCore.h"
#import "ImFriendCoreClient.h"
#import "PraiseCore.h"
#import "PraiseCoreClient.h"
#import "RoomCoreV2.h"
#import "RoomCoreClient.h"
#import "CarCore.h"
#import "HostUrlManager.h"

// tools
#import "XCTheme.h"
#import "XCMacros.h"
#import "XCHtmlUrl.h"
#import <JXCategoryView/JXCategoryView.h>
#import "TTPopup.h"
#import "XCHUDTool.h"
#import "TTStatisticsService.h"

#import <JXPagingView/JXPagerListRefreshView.h>
#import <JXPagingView/JXPagerView.h>
#import <Masonry/Masonry.h>
#import "SVGAParser.h"
#import "SVGAImageView.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface TTMineContainViewController ()<ImFriendCoreClient, RoomCoreClient, SVGAPlayerDelegate, JXCategoryViewDelegate, JXPagerViewDelegate, TTMineInfoViewVCDelegate>
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXCategoryIndicatorLineView *lineView;
@property (nonatomic, strong) JXPagerView *pagingView;
@property (nonatomic, strong) NSArray<NSString *> *titles;

@property (nonatomic, strong) TTMineInfoView *headView;
@property (nonatomic, strong) TTMineInfoBottomView *bottomView;

// 播放特效
@property (nonatomic, strong) SVGAImageView *svgaImageView;
@property (nonatomic, strong) SVGAParser *svgaParser;
@property (nonatomic, strong) NSArray<UserCar *>* userCarList;
@property (assign , nonatomic) BOOL hadShowCar;


// 自定义导航栏
@property (nonatomic, strong) UIView *customNavBar;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) CGFloat navAlpha;
@end

static CGFloat kBottomViewHeight = 0;
static CGFloat kSelectTabViewHeight = 50;

@implementation TTMineContainViewController

- (void)dealloc {
    RemoveCoreClientAll(self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.hiddenNavBar = YES;
    
    AddCoreClient(ImFriendCoreClient, self);
    AddCoreClient(PraiseCoreClient, self);
    AddCoreClient(RoomCoreClient, self);
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 解决底部列表无法滑动返回的问题
    [self.categoryView.contentScrollView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
    
    [self baseUI];
    [self initViews];
    [self initConstraints];
    [self headViewHandler];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    @weakify(self)
    [GetCore(UserCore)getUserInfo:self.userID refresh:YES success:^(UserInfo *info) {
        @strongify(self)
        self.userInfo = info;
        if (info.carport.isUsed && (self.userInfo.carport.status != Car_Status_expire)) {
            if (!self.hadShowCar) {
                [self startCarEffectWith:self.userInfo.carport.effect];
                self.hadShowCar = YES;
            }
        }

    }failure:nil];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.pagingView.frame = self.view.bounds;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.navAlpha > 0.7) {
        return UIStatusBarStyleDefault;
    }
    return UIStatusBarStyleLightContent;
}

#pragma mark - JXPagerViewDelegate
- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.headView;
}

- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    // headView 的高度
    return kMineViewHeight + kNavigationHeight;
}

- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return kSelectTabViewHeight;
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
            TTMineMomentViewController *vc = [[TTMineMomentViewController alloc] init];
            vc.mineInfoStyle = self.mineInfoStyle;
            vc.userID = self.userID;
            viewController = vc;
        }
            break;
        case 1:
        {
            TTMineInfoViewController *vc = [[TTMineInfoViewController alloc] init];
            vc.mineInfoStyle = self.mineInfoStyle;
            vc.userID = self.userID;
            vc.delegate = self;
            viewController = (UIViewController<JXPagerViewListViewDelegate> *)vc;
        }
            break;
        case 2:
        {
            TTGiftViewController *vc = [[TTGiftViewController alloc] init];
            vc.mineInfoStyle = self.mineInfoStyle;
            vc.userID = self.userID;
            viewController = (UIViewController<JXPagerViewListViewDelegate> *)vc;
        }
            break;
        case 3:
        {
            TTCarDressUpViewController *vc = [[TTCarDressUpViewController alloc] init];
            vc.mineInfoStyle = self.mineInfoStyle;
            vc.userID = self.userID;
            viewController = (UIViewController<JXPagerViewListViewDelegate> *)vc;
        }
            break;
            
        default:
            break;
    }
    
    return (id <JXPagerViewListViewDelegate>)viewController;
}

- (void)mainTableViewDidScroll:(UIScrollView *)scrollView {
    [self scrollViewDidScroll:scrollView];
}

#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
}

#pragma mark -
#pragma mark lifeCycle
- (void)baseUI {
    
    if (self.userID == [GetCore(AuthCore) getUid].longLongValue) {
        self.mineInfoStyle = TTMineInfoViewStyleDefault;
    } else {
        self.mineInfoStyle = TTMineInfoViewStyleOhter;
    }
    
    UIImage *leftImage = [UIImage imageNamed:@"nav_bar_back_white"];
    UIImage *rightImage;
    
    if (self.mineInfoStyle == TTMineInfoViewStyleDefault) {
        kBottomViewHeight = 0;
        rightImage = [UIImage imageNamed:@"meinfo_edit_white"];
    } else {
        kBottomViewHeight = 84.f;
        rightImage = [UIImage imageNamed:@"meInfo_more_icon"];
    }
    [self.leftBtn setImage:leftImage forState:UIControlStateNormal];
    [self.leftBtn setImage:leftImage forState:UIControlStateHighlighted];
    [self.rightBtn setImage:rightImage forState:UIControlStateNormal];
    [self.rightBtn setImage:rightImage forState:UIControlStateHighlighted];
}

- (void)initViews {
    [self.view addSubview:self.pagingView];
    [self.view addSubview:self.customNavBar];
    [self.view addSubview:self.svgaImageView];
    
    [self.customNavBar addSubview:self.leftBtn];
    [self.customNavBar addSubview:self.rightBtn];
    [self.customNavBar addSubview:self.titleLabel];
    
    EnvironmentType env = [HostUrlManager.shareInstance currentEnvironment];
    BOOL devMode = env == TestType || env == DevType;
    NSString *secretaryUid = keyWithType(KeyType_SecretaryUid, devMode);
    NSString *systemUid = keyWithType(KeyType_SystemNotifyUid, devMode);
      
    if ([@(self.userID).stringValue isEqualToString:secretaryUid] ||
        [@(self.userID).stringValue isEqualToString:systemUid]) {
        //小秘书和系统通知不能拉黑
        self.rightBtn.hidden = YES;
    }
    
    if (self.mineInfoStyle == TTMineInfoViewStyleOhter) {
        
        [self.view addSubview:self.bottomView];
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(self.view);
            make.height.mas_equalTo(74 + kSafeAreaBottomHeight);
        }];
        
        UserID myUid = [GetCore(AuthCore) getUid].userIDValue;
        if (myUid != self.userID) {// 判断是否已经关注
            [GetCore(PraiseCore) isLike:myUid isLikeUid:self.userID];
        }
    }
}

- (void)initConstraints {
    
    [self.customNavBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(statusbarHeight + 44);
    }];
    
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0).inset(15);
    }];
    
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(0).inset(15);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-15);
        make.centerX.mas_equalTo(0);
    }];
}

//播放特效
- (void)startCarEffectWith:(NSString *)effect {
    @weakify(self);
    if (!effect) {
        return;
    }
    [self.svgaParser parseWithURL:[NSURL URLWithString:effect] completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
        @strongify(self);
        dispatch_main_sync_safe(^{
            self.svgaImageView.hidden = NO;
            self.svgaImageView.loops = 1;
            self.svgaImageView.clearsAfterStop = YES;
            self.svgaImageView.videoItem = videoItem;
            [self.svgaImageView startAnimation];
        });
    } failureBlock:^(NSError * _Nullable error) {
        
    }];
    
}

#pragma mark - SVGAPlayerDelegate
- (void)svgaPlayerDidFinishedAnimation:(SVGAPlayer *)player{
    self.svgaImageView.hidden = YES;
}

#pragma mark -
#pragma mark navtionBar

- (void)initNavtionBlackItem {
    
    UIImage *leftImage = [UIImage imageNamed:@"nav_bar_back"];
    UIImage *rightImage;
    
    if (self.mineInfoStyle == TTMineInfoViewStyleDefault) {
        rightImage = [UIImage imageNamed:@"meInfo_edit_black"];
    } else {
        rightImage = [UIImage imageNamed:@"meInfo_more_black"];
    }
    [self.leftBtn setImage:leftImage forState:UIControlStateNormal];
    [self.leftBtn setImage:leftImage forState:UIControlStateHighlighted];
    [self.rightBtn setImage:rightImage forState:UIControlStateNormal];
    [self.rightBtn setImage:rightImage forState:UIControlStateHighlighted];
}

#pragma mark -
#pragma mark custom target action
// 更多
- (void)showRightItemActionSheet {
    // show actionSheet
    [self showReport]; // 举报 拉黑
}

- (void)leftBtnClickAction:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnClickAction:(UIButton *)btn {
    
    if (_mineInfoStyle == TTMineInfoViewStyleDefault) {
        // push next viewController
        TTPersonEditViewController *vc = [[TTPersonEditViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    // 举报，分享，推荐，进入房间
    // show ActionSheet
    [self showRightItemActionSheet];
}


#pragma mark -
#pragma mark scroll delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"%f",scrollView.contentOffset.y);
    CGFloat offSetY = scrollView.contentOffset.y;
    if (offSetY <= -statusbarHeight) { // 超出部分不显示 bounces
        self.customNavBar.backgroundColor = UIColorRGBAlpha(0xffffff, 0);
    } else {
        CGFloat alpha = offSetY / (kMineViewHeight - kMineInfoHeadTopMargin - statusbarHeight);
        
        if (alpha <= 0.7) { // 黑色
            [self baseUI];
            self.navAlpha = alpha;
            [self setNeedsStatusBarAppearanceUpdate];
        } else { // 白色
            [self initNavtionBlackItem];
            self.navAlpha = alpha;
            [self setNeedsStatusBarAppearanceUpdate];
        }
        self.customNavBar.backgroundColor = UIColorRGBAlpha(0xffffff, alpha);
        
        if (alpha >= 0.9) {
            self.titleLabel.text = self.userInfo.nick;
            self.customNavBar.backgroundColor = UIColorRGBAlpha(0xffffff, 1.0);
        } else {
            self.titleLabel.text = @"";
        }
    }
}

#pragma mark -
#pragma mark private methods
- (void)headViewHandler {
    @weakify(self);
    _headView.bubbleClickHandler = ^(TTBubbleViewType type) {
        @strongify(self);
        switch (type) {
            case TTBubbleViewTypeFans:
            { // 粉丝
                if (self.mineInfoStyle == TTMineInfoViewStyleDefault) {
                    UIViewController *vc = [[XCMediator sharedInstance] ttMessageMoudle_TTFansViewController];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
                break;
            case TTBubbleViewTypeFollow:
            {// 关注
                if (self.mineInfoStyle == TTMineInfoViewStyleDefault) {
                    [TTStatisticsService trackEvent:@"guest_page_follow" eventDescribe:@"客态页-关注"];
                    UIViewController *vc = [[XCMediator sharedInstance] ttMessageMoudle_TTFocusViewController];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
                break;
            case TTBubbleViewTypeFindTA:
            {   // 找到TA
                [GetCore(RoomCoreV2) getUserInterRoomInfo:self.userID Success:^(RoomInfo *roomInfo) {
                    if (roomInfo && roomInfo.uid > 0 && roomInfo.title.length > 0) {
                        [[XCMediator sharedInstance] ttRoomMoudle_presentRoomViewControllerWithRoomUid:roomInfo.uid];
                    } else {
                        [XCHUDTool showErrorWithMessage:@"TA现在没有在房间内哦" inView:self.view];
                    }
                    
                } failure:^(NSNumber *resCode, NSString *message) {
                    [XCHUDTool showErrorWithMessage:message inView:self.view];
                }];
            }
                break;
            case TTBubbleViewTypeRoom:
            {// TA的房间
                [[XCMediator sharedInstance] ttRoomMoudle_presentRoomViewControllerWithRoomUid:self.userInfo.uid];
            }
                break;
                
            default:
                break;
        }
        
    };
    
    self.headView.headerAvatarClickHandler = ^{
        @strongify(self);
        if (self.userID == [GetCore(AuthCore) getUid].longLongValue) {
            TTPersonEditViewController *vc = [[TTPersonEditViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    };
    
    _bottomView.btnClickHandler = ^(UIButton * _Nonnull btn) {
        @strongify(self);
        switch (btn.tag) {
            case 1001: // 关注按钮
            {
                if (!self.bottomView.attentioned) {
                    NSString * mine = [GetCore(AuthCore) getUid];
                    [GetCore(PraiseCore) praise:mine.userIDValue bePraisedUid:self.userID];
                }else{
                    [self showCancelAttentionAlert];
                }
            }
                break;
            case 1002: // 私信按钮
            {
                UserID myUid = [GetCore(AuthCore) getUid].userIDValue;
                if (myUid != self.userID) {// 判断是否是自己的账号ID
                    UIViewController *vc = [[XCMediator sharedInstance] ttMessageMoudle_TTSessionViewController:self.userID sessectionType:0];
                    [self.navigationController pushViewController:vc animated:YES];
                }    
            }
                break;
                
            default:
                break;
        }
    };
}

//取消关注
- (void)showCancelAttentionAlert {
    
    TTAlertConfig *config = [[TTAlertConfig alloc] init];
    config.title = @"是否确定取消关注？";
    config.message = @"取消关注后将会收不到主播开播通知";

    @weakify(self);
    [TTPopup alertWithConfig:config confirmHandler:^{
        @strongify(self);
        NSString* mine = [GetCore(AuthCore) getUid];
        [XCHUDTool showGIFLoadingInView:self.view];
        [GetCore(PraiseCore) cancel:mine.userIDValue beCanceledUid:self.userID];
    } cancelHandler:^{
    }];
}


// 举报
- (void)showReport {
    
    NSMutableArray<TTActionSheetConfig *> *array = [NSMutableArray array];
    
    NSString *uid = [NSString stringWithFormat:@"%lld",self.userInfo.uid];
    BOOL isAllReadyBlack = [GetCore(ImFriendCore) isUserInBlackList:uid];
    
    TTActionSheetConfig *report = [TTActionSheetConfig normalTitle:@"举报" clickAction:^{
        [self beInReport];
    }];
    
    TTActionSheetConfig *removeBlack = [TTActionSheetConfig normalTitle:@"移除黑名单" clickAction:^{
        [self beInBlack:isAllReadyBlack];
    }];
    
    TTActionSheetConfig *black = [TTActionSheetConfig normalTitle:@"拉黑" clickAction:^{
        [self beInBlack:isAllReadyBlack];
    }];

    [array addObjectsFromArray:@[report, black]];

    if (isAllReadyBlack) {
        [array replaceObjectAtIndex:1 withObject:removeBlack];
    }

    [TTPopup actionSheetWithItems:array];
}
//举报
- (void)beInReport {
    
    TTWKWebViewViewController *vc = [[TTWKWebViewViewController alloc]init];
    NSString *urlstr = [NSString stringWithFormat:@"%@?reportUid=%lld&source=PERSONAL",HtmlUrlKey(kReportURL),self.userID];
    vc.urlString = urlstr;
    [self.navigationController pushViewController:vc animated:YES];
}


//加入黑名单
- (void)beInBlack:(BOOL)isInBlackList {
    
    NSString *title;
    NSString *message;
    if (isInBlackList) {
        title = @"移除黑名单";
        message = @"移除黑名单，你将正常收到对方的消息";
    }else{
        title = @"加入黑名单";
        message = @"加入黑名单，你将不再收到对方的消息";
    }

    TTAlertConfig *config = [[TTAlertConfig alloc] init];
    config.title = title;
    config.message = message;
    
    [TTPopup alertWithConfig:config confirmHandler:^{
        if (isInBlackList) {
            [GetCore(ImFriendCore) removeFromBlackList:[NSString stringWithFormat:@"%lld",self.userInfo.uid]];
        } else {
            [GetCore(ImFriendCore) addToBlackList:[NSString stringWithFormat:@"%lld",self.userInfo.uid]];
        }
    } cancelHandler:^{
    }];
}

#pragma mark -
#pragma mark RoomCoreClient
- (void)requestUserRoomInterInfo:(RoomInfo *)info uid:(UserID)uid {
    NSLog(@"%@ --- %lld ---", info, uid);
}
- (void)requestUserRoomInterInfoFailth:(NSString *)message {
}

#pragma mark -
#pragma mark core clients
#pragma mark - ImFriendCoreClient
- (void)onAddToBlackListSuccess{
//    [UIView showToastInKeyWindow:@"加入黑名单成功" duration:2 position:YYToastPositionCenter];
}
- (void)onAddToBlackListFailth{
//    [UIView showToastInKeyWindow:@"加入黑名单失败" duration:2 position:YYToastPositionCenter];
}

- (void)onRemoveFromBlackListSuccess{
//    [UIView showToastInKeyWindow:@"移除黑名单成功" duration:2 position:YYToastPositionCenter];
}
- (void)onRemoveFromBlackListFailth{
//    [UIView showToastInKeyWindow:@"移除黑名单失败" duration:2 position:YYToastPositionCenter];
}


#pragma mark - PraiseCoreClient
- (void)onPraiseSuccess:(UserID)uid
{
    self.bottomView.attentioned = YES;
    [XCHUDTool hideHUDInView:self.view];
    [XCHUDTool showSuccessWithMessage:@"关注成功，相互关注可成为好友哦" inView:self.view];
}

- (void)onPraiseFailth:(NSString *)msg
{
    [XCHUDTool hideHUDInView:self.view];
    [XCHUDTool showErrorWithMessage:@"请求失败，请检查网络" inView:self.view];
}

- (void)onCancelSuccess:(UserID)uid;
{
    self.bottomView.attentioned = NO;
    [XCHUDTool hideHUDInView:self.view];
    [XCHUDTool showSuccessWithMessage:@"取消关注成功" inView:self.view];
}

- (void)onCancelFailth:(NSString *)msg
{
    [XCHUDTool hideHUDInView:self.view];
    [XCHUDTool showErrorWithMessage:@"请求失败，请检查网络" inView:self.view];
}

- (void)onRequestIsLikeSuccess:(BOOL)isLike islikeUid:(UserID)islikeUid
{
    self.bottomView.attentioned = isLike;
}

// 个人信息发生变化，刷新头部视图
- (void)refreshTableViewHeaderWithUserInfo:(UserInfo *)info{
    self.headView.userInfo = info;
}

#pragma mark -
#pragma mark getter & setter

- (void)setUserID:(long long)userID {
    _userID = userID;
    //需要YES不然修改资料之后无法更新，只能卸载app
    UserExtensionRequest *requese = [[UserExtensionRequest alloc] init];
    requese.type = QueryUserInfoExtension_Full;
    requese.needRefresh = YES;
    [[GetCore(UserCore) queryExtensionUserInfoByWithUserID:self.userID requests:@[requese]] subscribeNext:^(id x) {
        self.userInfo = (UserInfo *)x;
    }];
}

- (void)setUserInfo:(UserInfo *)userInfo {
    _userInfo = userInfo;
    self.headView.userInfo = userInfo;
}

- (TTMineInfoView *)headView {
    if (!_headView) {
        if (self.userID == [GetCore(AuthCore) getUid].longLongValue) {
            self.mineInfoStyle = TTMineInfoViewStyleDefault;
        } else {
            self.mineInfoStyle = TTMineInfoViewStyleOhter;
        }
//        CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kMineViewHeight + kStatusBarHeight);
        _headView = [[TTMineInfoView alloc] initWithFrame:CGRectZero style:_mineInfoStyle];
    }
    return _headView;
}

- (NSArray<NSString *> *)titles {
    if (!_titles) {
        _titles = @[@"动态", @"资料", @"礼物", @"座驾"];
    }
    return _titles;
}

- (TTMineInfoBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[TTMineInfoBottomView alloc] init];
    }
    return _bottomView;
}

- (UIView *)customNavBar {
    if (!_customNavBar) {
        _customNavBar = [[UIView alloc] init];
        _customNavBar.backgroundColor = UIColorRGBAlpha(0xffffff, 0);
    }
    return _customNavBar;
}

- (UIButton *)leftBtn {
    if (!_leftBtn) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftBtn setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
        [_leftBtn addTarget:self action:@selector(leftBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
        [_rightBtn addTarget:self action:@selector(rightBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [XCTheme getTTMainTextColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18.f];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _titleLabel;
}

- (SVGAImageView *)svgaImageView {
    if (_svgaImageView == nil) {
        _svgaImageView = [[SVGAImageView alloc]init];
        _svgaImageView.backgroundColor = [UIColor clearColor];
        _svgaImageView.contentMode = UIViewContentModeScaleAspectFit;
        _svgaImageView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
        _svgaImageView.hidden = YES;
        _svgaImageView.delegate = self;
        _svgaImageView.userInteractionEnabled = NO;
    }
    return _svgaImageView;
}
- (SVGAParser *)svgaParser {
    if (_svgaParser == nil) {
        _svgaParser = [[SVGAParser alloc]init];
    }
    return _svgaParser;
}

- (JXCategoryTitleView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kSelectTabViewHeight)];
        _categoryView.titles = self.titles;
        _categoryView.backgroundColor = [UIColor whiteColor];
        _categoryView.delegate = self;
        _categoryView.titleSelectedColor = [XCTheme getTTMainTextColor];
        _categoryView.titleColor = [XCTheme getTTDeepGrayTextColor];
        _categoryView.titleFont = [UIFont systemFontOfSize:16];
        _categoryView.titleSelectedFont = [UIFont boldSystemFontOfSize:16];
        _categoryView.titleColorGradientEnabled = YES;
        _categoryView.titleLabelZoomEnabled = NO;
        _categoryView.indicators = @[self.lineView];
        _categoryView.contentScrollView = self.pagingView.listContainerView.collectionView;
    }
    return _categoryView;
}

- (JXCategoryIndicatorLineView *)lineView {
    if (!_lineView) {
        _lineView = [[JXCategoryIndicatorLineView alloc] init];
        _lineView.indicatorColor = [XCTheme getTTMainTextColor];
        _lineView.indicatorWidth = 8;
    }
    return _lineView;
}

- (JXPagerView *)pagingView {
    if (!_pagingView) {
        _pagingView = [[JXPagerListRefreshView alloc] initWithDelegate:self];
        // 由于这里是隐藏导航栏的做法，所以要减去自定义导航栏的高度。
        _pagingView.pinSectionHeaderVerticalOffset = kNavigationHeight;
    }
    return _pagingView;
}
@end
